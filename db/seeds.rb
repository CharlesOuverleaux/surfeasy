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
                     country: spot["country"])
  puts " added: #{item[:name]}"
end
