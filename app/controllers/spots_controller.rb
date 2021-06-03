require 'open-uri'
require 'json'
class SpotsController < ApplicationController
  def index
    update_cached_conditions
    @filters = parse_filter_params
    @spots = filtered_spots
    add_current_spot_data
    sort_by_kpi
  end

  private

  def parse_filter_params
    filters = { location: params[:location] || [39.598, -9.070],
                radius: params[:radius] || 30,
                skill_level: params[:skill_level] }
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

      { data: spot,
        distance: spot.distance_from(@filters[:location]).round,
        kpi: calculate_kpi(spot),
        wind_speed: conditions[:wind_speed],
        wave_height: conditions[:wave_height],
        period: conditions[:period] }
    end
  end

  def current_conditions(spot)
    # retrieve and parse cached condition for spot from redis
    condition = JSON.parse($redis.get(spot.surfline_id), { symbolize_names: true })
    return condition
  end

  def sort_by_kpi
    @spots.sort_by! { |spot| - spot[:kpi] }
  end

  def calculate_kpi(_spot)
    # calculate kpi for a spot
    # for now fake it with rand
    rand(100)
  end

  def update_cached_conditions
    # check if cached conditions are older than 30 mins
    condition = JSON.parse($redis.get(Spot.first.surfline_id), { symbolize_names: true })
    # if they are, update them
    FetchSpotConditionsJob.perform_later if condition[:created_at] < Time.now.to_i - 1800
  end
end
