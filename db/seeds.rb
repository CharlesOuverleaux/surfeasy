require 'json'
require 'faker'

REVIEW_TITLE = ['Amazing surf spot!',
  'Great spot', 
  'My favorite place to surf', 
  'Perfect waves here', 
  'One of the best wave of the country',
  'Bro! A fun place with a great vibe', 
  'Easy access and paddle out, perfect to get started', 
  'Beautiful waves with nice barrels', 
  'Perfect waves breaking in an ideal bay with crystal water',
  'Search no more, this is THE spot', 
  'Great-shaped waves with room to move', 
  'Awesome spot', 
  'Great waves here!', 
  'Loved to surf here' ]
REVIEW_DESCRIPTION = ['the lineups here are still undiscovered and uncrowded, go surf it broo', 
  'Wake up before sunrise and wander down to the beach. Head off to surf empty glassy warm waves with a few mates. Grab a quick siesta after lunch before the afternoon then go surf again. Finish the day with spectacular sunsets. Repeat: every day!',
  'world-class waves, park above the cliff and walk down the second path at the beach. Best to be there before 10am before all the surf school arriving', 
  'Have a coffee and a pastel de nata, then jump straight into this right hander, be careful of the rocks on the left side of the beach',
  'This is spot has three waves in one, if you are just starting you go easily go to the spot on the right there is no line-up',
  'This is a really popular spot with good facilties including showers and a beach bar to boot.',
  'Many pro surfers here, come early or try to avoid the crowds',
  'fantastically flexible, crescent shaped beach that curves towards the town. Long, sometimes hollow rights can peel here. Consistent and fun, popular with beginners when small. Great place to party after a fun surf', 
  'You might meet the quatro local legends here, they come to surf quite often. Rumors said they became millionairs after developing a surf app', 
  'Nice place to eat, surf, relax and repeat!',
  'Valentina, amazing lifeguard saved my life here! Great spot',
  'you cant stop the waves, but you can learn how to surf this amazing spot, its lit man',
  'In doubt paddle out, thats the way you should surf there! Be careful of the strong currents, many tourists have to be rescued by lifeguards',
  'glassy waves, super nice to surf here on the right side', 'Wow loved it so much here, the locals are great, the vibe in the water is amazing',
  'this is a great spot with nice access to the beach and restaurants around to refill you with good energy']

# method to create random reviews and assign it to a spot
def assign_random_review(spot)
  reviews = []
  rand(4..8).times do
    review = Review.create(
      title:REVIEW_TITLE.sample,
      description:REVIEW_DESCRIPTION.sample,
      rating:rand(3..5),
      user: User.all.sample,
      spot: spot
      )
    reviews << review
    end
end

# clean database
puts "Cleaning database..."
Review.destroy_all
Spot.destroy_all
User.destroy_all

puts "\nStart seeding"

# seeding admin user & fake users
admin = User.new(
  username: 'admin',
  password: '123456',
  email: 'admin@surf-easy.com')
admin.save
puts "admin created 👌"

10.times do
  user = User.new(
    username: Faker::Internet.username,
    password: '123456',
    email: Faker::Internet.email
  )
  user.save
end
puts "users created 🤩"

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
  assign_random_review(item)
  puts " added: #{item[:name]}, #{item.reviews.count} reviews"
end

puts "\n-----------------------------"
puts "Seeding done"
puts "Added #{Spot.count} spots to the database"
puts "Added #{User.count} users to the database"
