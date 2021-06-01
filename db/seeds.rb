require 'json'

# clean database
puts "Cleaning database..."
Spot.destroy_all

puts "\nStart seeding"

# read/parse json
file = File.read('scraping/data/spots.json')
data_hash = JSON.parse(file)
spots = data_hash["spots"]
puts "Retrieved #{spots.count} spots"

# loop spots
spots.each do |spot|
  # save to db
  item = Spot.create(name: spot["spot_name"],
                     surfline_id: spot["surfline_id"],
                     lat: spot["latitude"],
                     lon: spot["longitude"],
                     country: spot["country"],
                     ideal_swell_direction: spot["Swell Direction"],
                     ideal_wind_direction: spot["Wind"],
                     ideal_tide: spot["Tide"],
                     description: spot["description"],
                     ability_level: spot["Ability Level"],
                     vibe: spot["Local Vibe"],
                     access: spot["Access"])
  puts " added: #{item[:name]}"
end

puts "\n-----------------------------"
puts "Seeding done"
puts "Added #{Spot.count} spots to the database"

