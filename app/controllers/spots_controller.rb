require 'open-uri'
require 'json'
class SpotsController < ApplicationController
  def index
    @filters = parse_filter_params
    @spots = filtered_spots
    add_current_spot_data
    sort_by_kpi
  end

  private

  def parse_filter_params
    { location: [39.598, -9.070],
      radius: params[:radius] || 30,
      skill_level: params[:skill_level] }
  end

  def filtered_spots
    # where spot is within radius of location
    # geocoder => finds spots near [lat lon]
    Spot.near(@filters[:location], @filters[:radius], units: :km).to_a

    # calculate fit based on skill level and api data
    # return filtered spots
    # for now just take random spots
    # Spot.order(Arel.sql('RANDOM()')).take(rand(2..3))
  end

  def add_current_spot_data
    @spots.map! do |spot|
      # get conditions for spot
      conditions = current_conditions(spot)

      { data: spot,
        distance: spot.distance_from(@filters[:location]).round,
        kpi: calculate_kpi(spot),
        wind_speed: conditions[:wind_speed],
        wave_height: conditions[:wave_height],
        period: conditions[:period] }

      # add to spots
      # and kpi
    end
  end

  def current_conditions(spot)
    url = "https://services.surfline.com/kbyg/spots/forecasts/?spotId=#{spot.surfline_id}&days=1&intervalHours=3"
    data = JSON.parse(URI.open(url).read)
    result = { weather: data['data']['forecasts'][0]['weather'],
               wind_speed: data['data']['forecasts'][0]['wind']['speed'].to_i,
               wave_height: data['data']['forecasts'][0]['surf']['max'].round(1),
               period: data['data']['forecasts'][0]['swells'][0]['period'] }
    # Rails.cache.write(url, result)
    # cached = Rails.cache.read(url)
  end

  def sort_by_kpi
    @spots.sort_by! { |spot| - spot[:kpi] }
  end

  def calculate_kpi(_spot)
    # calculate kpi for a spot
    # for now fake it with rand
    rand(100)
  end
end
