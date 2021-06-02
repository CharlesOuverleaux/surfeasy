require 'json'

class FetchSpotConditionsJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    spots = Spot.all

    spots.each do |spot|
      url = "https://services.surfline.com/kbyg/spots/forecasts/?spotId=#{spot.surfline_id}&days=1&intervalHours=3"
      data = JSON.parse(URI.open(url).read)
      condition = { weather: data['data']['forecasts'][0]['weather'],
                    wind_speed: data['data']['forecasts'][0]['wind']['speed'].to_i,
                    wave_height: data['data']['forecasts'][0]['surf']['max'].round(1),
                    period: data['data']['forecasts'][0]['swells'][0]['period'] }
      Rails.cache.write(spot.surfline_id, JSON.generate(condition))
    end
  end
end
