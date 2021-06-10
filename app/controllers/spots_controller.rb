require 'open-uri'
require 'json'
require_relative '../../reco_model/secret_sauce'
class SpotsController < ApplicationController
  before_action :set_spot, only: [:show]

  def index
    update_cached_conditions
    @filters = parse_filter_params
    @spots = filtered_spots
    @city = @location.city

    add_current_spot_data
    sort_by_kpi
  end

  def show
    @spot = Spot.find(params[:id])
    @conditions = current_conditions(@spot)
    # refactor later
    sum = 0
    @spot.reviews.each do |review|
      sum += review.rating
    end
    @review_count = @spot.reviews.count
    @stars = (sum / @review_count).round

    @distance = params[:distance]
    @score_msg = params[:score_msg]

    # is favorite?
    @is_favorite = false

    current_user&.favorites&.each do |favorite|
      if favorite.spot_id == @spot.id
        @is_favorite = true
        @favorite = favorite
      end
    end
    @image_id = params[:image_id]
  end

  private

  def set_spot
    @spot = Spot.find(params[:id])
  end

  def parse_filter_params
    # get lat long coordinates for query param location
    @location = Geocoder.search(params[:location]).first if params[:location]
    coordinates = @location.coordinates
    filters = { location: coordinates || [39.598, -9.070],
                radius: params[:radius] || 30,
                skill_level: params[:skill] }
    return filters
  end

  def filtered_spots
    # where spot is within radius of location
    # geocoder => finds spots near [lat lon]
    Spot.near(@filters[:location], @filters[:radius], units: :km).to_a
  end

  def add_current_spot_data
    @spots.map! do |spot|
      # get conditions for spot
      conditions = current_conditions(spot)
      kpi, score_msg = calculate_kpi(spot, @filters[:skill_level], conditions)
      { data: spot,
        distance: spot.distance_from(@filters[:location]).round,
        kpi: kpi,
        score_msg: score_msg,
        wind_speed: conditions[:wind_speed],
        wave_height: conditions[:wave_height],
        period: conditions[:period],
        weather: conditions[:weather] }
    end
  end

  def current_conditions(spot)
    # retrieve and parse cached condition for spot from redis
    condition = $redis.get(spot.surfline_id)

    # return cached condition if it exists
    return JSON.parse(condition, { symbolize_names: true }) if condition

    # return live fetched condition if not found in cache
    return fetch_condition(spot)
  end

  def fetch_spot_condition(spot)
    url = "https://services.surfline.com/kbyg/spots/forecasts/?spotId=#{spot.surfline_id}&days=1&intervalHours=3"
    # Get current conditions for each spot
    data = JSON.parse(URI.open(url).read)
    forecasts = data['data']['forecasts']
    units = data['units']
    return { weather: forecasts[0]['weather'],
             wind_speed: in_kph(forecasts[0]['wind']['speed'].to_i, units).to_i,
             wind_direction: forecasts[0]['wind']['direction'].to_i,
             wave_height: in_meters(forecasts[0]['surf']['max'], units).round(1),
             swell_direction: forecasts[0]['swells'][0]['direction'].to_i,
             period: forecasts[0]['swells'][0]['period'] }
  end

  def in_meters(data, units)
    return data / 3.2808 unless units['swellHeight'] == 'M'

    return data
  end
  def in_kph(data,units)
    return data * 1.609 unless units['windSpeed'] == 'KPH'

    return data
  end

  def sort_by_kpi
    @spots.sort_by! { |spot| - spot[:kpi] }
  end

  def calculate_kpi(spot, level, current_conditions)
    # calculate kpi for a spot
    # extract ideal condition data from spot instance
    ideal_conditions = {
      ideal_swell_direction: spot[:ideal_swell_direction].to_i,
      ideal_wind_direction: spot[:ideal_wind_direction].to_i
    }
    return calculate_score(level, ideal_conditions, current_conditions)
  end

  def update_cached_conditions
    # check if cached conditions are older than 30 mins
    created_at = $redis.get('created_at')
    # if they are, update them
    FetchSpotConditionsJob.perform_now if created_at.nil? || created_at.to_i < Time.now.to_i - 1800
  end
end
