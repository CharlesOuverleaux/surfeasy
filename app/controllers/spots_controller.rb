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
    { location: { lon: 43.4, lat: 32.1 },
      radius: params[:radius],
      skill_level: params[:skill_level] }
  end

  def filtered_spots
    # where spot is within radius of location
    # geocoder?
    # calculate fit based on skill level and api data
    # return filtered spots
    # for now just take random spots
    Spot.order(Arel.sql('RANDOM()')).take(rand(5..15))
  end

  def add_current_spot_data
    @spots.map! do |spot|
      # get conditions for cards
      conditions = get_current_spot_data(spot)

      { data: spot,
        kpi: calculate_kpi(spot),
        wind_speed: conditions[:wind_speed],
        wave_height: conditions[:wave_height],
        period: conditions[:period] }

      # add to spots
      # and kpi
    end
  end

  def get_current_spot_data(spot)
    url = "https://services.surfline.com/kbyg/spots/forecasts/?spotId=#{spot.surfline_id}&days=1&intervalHours=3"
    data = JSON.parse(URI.open(url).read)
    { weather: data['data']['forecasts'][0]['weather'],
      wind_speed: data['data']['forecasts'][0]['wind']['speed'].to_i,
      wave_height: data['data']['forecasts'][0]['surf']['max'].round(1),
      period: data['data']['forecasts'][0]['swells'][0]['period'] }
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
