# Creating fake current conditions for each surf spot to avoid using redis and paying fees

require 'json'

puts 'Starting to create weather conditions for each spot'
spots_file = File.read('scraping/data/spots.json')
spots = JSON.parse(spots_file)['spots']
puts "Retrieved #{spots.count} spots"

conditions = []

spots.each do |spot|
  spot_conditions = {
                  surfline_id: spot['surfline_id'],
                  weather: {"temperature" => rand(10..25), "condition" => "NIGHT_MOSTLY_CLEAR"},
                  wind_speed: rand(2..50),
                  wind_direction: rand(0..360),
                  wave_height: rand(1..20) / 10.to_f,
                  swell_direction: rand(220..350),
                  period: rand(5..20)
                  }
  conditions.push(spot_conditions)
  puts "Faked weather conditions for #{spot['surfline_id']} spots"
end

File.open('scraping/data/spots_conditions.json', 'wb') do |file|
  file.write(JSON.generate({
                             conditions: conditions
                           }))
end
puts "Created surf spots weather conditions JSON"


puts "selecting one spot"

file = File.read('scraping/data/spots_conditions.json')
data = JSON.parse(file)

spot_conditions =  data['conditions'].select{ |spot| spot['surfline_id'] == '5842041f4e65fad6a7708e5a'}
p spot_conditions[0]
