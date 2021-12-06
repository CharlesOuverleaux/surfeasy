require 'open-uri'
require 'json'
require_relative '../../reco_model/secret_sauce'
class SpotsController < ApplicationController
  before_action :set_spot, only: [:show]

  def index
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
    @origin = params[:origin]

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
    @coordinates = @location.coordinates
    filters = { location: @coordinates || [39.598, -9.070],
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
    file = File.read('scraping/data/spots_conditions.json')
    data = JSON.parse(file)

    spot_condition = data['conditions'].select { |s| s['surfline_id'] == spot.surfline_id }

    return { weather: spot_condition[0]['weather'],
             wind_speed: spot_condition[0]['wind_speed'],
             wind_direction: spot_condition[0]['wind_direction'],
             wave_height: spot_condition[0]['wave_height'],
             swell_direction: spot_condition[0]['swell_direction'],
             period: spot_condition[0]['period'] }
  end

  def fetch_spot_condition(spot)
    file = File.read('scraping/data/spots_conditions.json')
    data = JSON.parse(file)

    spot_condition = data['conditions'].select { |s| s['surfline_id'] == spot.surfline_id }

    return { weather: spot_condition[0]['weather'],
             wind_speed: spot_condition[0]['wind_speed'],
             wind_direction: spot_condition[0]['wind_direction'],
             wave_height: spot_condition[0]['wave_height'],
             swell_direction: spot_condition[0]['swell_direction'],
             period: spot_condition[0]['period'] }
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

end
