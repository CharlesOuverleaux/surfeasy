require 'json'
# import data from json
file = File.read('reco_model/training.json')
data_hash = JSON.parse(file)
spots = data_hash["spots"]
puts "Retrieved #{spots.count} spots"

# get data from the api / at the moment test it with mock data
current_condition = {
  wave_height: 0.5,
  wave_period: 10,
  wind_speed: 20,
  wind_direction: 160,
  swell_direction: 130
}

level = 'beginner'
# compare ideal data vs live data
spots.each do |spot|
  score = 0
  wave_height = current_condition[:wave_height]
  if level == 'beginner' && wave_height < 1
    score += 20
  elsif level == 'intermediate' && wave_height.between?(0.5, 2)
    score += 20
  elsif level == 'advanced' && wave_height > 0.5
    score += 20
  end
  puts "#{spot['spot_name']} wave height: #{wave_height} -- score: #{score}"
end
# calculate the score
# give the score to each spot
# sort results based on the score
