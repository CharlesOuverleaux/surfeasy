require 'json'
# import data from json
# file = File.read('reco_model/training.json')
# data_hash = JSON.parse(file)
# spots = data_hash["spots"]
# puts "Retrieved #{spots.count} spots"

# # get data from the api / at the moment test it with mock data
# current_condition = {
#   wave_height: 0.5,
#   wave_period: 17,
#   wind_speed: 5,
#   wind_direction: 90,
#   swell_direction: 325
# }
BEGINNER = 'BEGINNER'
INTERMEDIATE = 'INTERMEDIATE'
ADVANCED = 'ADVANCED'

def wave_height_score(wave_height, level)
  if level == BEGINNER && wave_height < 1 ||
     level == INTERMEDIATE && wave_height.between?(0.5, 2) ||
     level == ADVANCED && wave_height > 0.5
    return 20
  end

  return 0
end

def wave_period_score(wave_period)
  return 20 if wave_period > 16
  return wave_period if wave_period.between?(7, 15)

  return 0
end

def wind_speed_score(wind_speed)
  return 0 if wind_speed > 30
  return 5 if wind_speed > 16

  return 10
end

def direction_score(dir, ideal_dir, max_diff, points)
  diff = (dir - ideal_dir) % 360
  return points if diff < max_diff

  return 0
end

def translate_score(score)
  return "Amazing" if score.between?(50, 60)
  return "Very good" if score.between?(40, 49)
  return "Decent" if score.between?(30, 39)
  return "Not good" if score < 30
end

def calculate_score(level, ideal_conditions, current_condition)
  score = 0
  score += wave_height_score(current_condition[:wave_height], level)
  score += wave_period_score(current_condition[:period])
  score += wind_speed_score(current_condition[:wind_speed])
  score += direction_score(current_condition[:wind_direction], ideal_conditions[:ideal_wind_direction], 30, 5)
  score += direction_score(current_condition[:swell_direction], ideal_conditions[:ideal_swell_direction], 30, 5)

  return [score, translate_score(score)]
end



# compare ideal data vs live data
# calculate the score
