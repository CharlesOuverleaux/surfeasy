require 'json'
require 'open-uri'

class FetchSpotConditionsJob < ApplicationJob
  queue_as :default

  def perform
    spots = Spot.all
    $redis.set('created_at', Time.now.to_i)
    spots.each do |spot|
      url = "https://services.surfline.com/kbyg/spots/forecasts/?spotId=#{spot.surfline_id}&days=1&intervalHours=3"
      # Get current conditions for each spot
      data = JSON.parse(URI.open(url).read)
      forecasts = data['data']['forecasts']
      units = data['units']
      condition = { weather: forecasts[0]['weather'],
                    wind_speed: forecasts[0]['wind']['speed'].to_i,
                    wind_direction: forecasts[0]['wind']['direction'].to_i,
                    wave_height: standardize_units(forecasts[0]['surf']['max'], units).round(1),
                    swell_direction: forecasts[0]['swells'][0]['direction'],
                    period: forecasts[0]['swells'][0]['period'] }
      # cache spot in redis
      $redis.set(spot.surfline_id, JSON.generate(condition))
    end
  end

  private

  def standardize_units(data, units)
    return data / 3.2808 unless units['swellHeight'] == 'M'

    return data
  end
end
