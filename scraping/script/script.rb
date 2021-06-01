# Create a scraping script to get the ideal conditions of a surf spot
# from surfline and save it in our data scraping
require 'open-uri'
require 'nokogiri'
require 'json'

# we need to find a way to get all the surf spot links
regions = [
  'portugal/porto/2735941',
  'portugal/leiria/2267094',
  'portugal/lisbon/2267056',
  'portugal/set-bal/2262961',
  'portugal/beja/2270984',
  'portugal/faro/2268337'
]

base_url = 'https://www.surfline.com/surf-reports-forecasts-cams/'
arr = []

regions.each do |region|
  url = base_url + region
  html_file = URI.open(url).read
  html_doc = Nokogiri::HTML(html_file)
  html_selector = '.sl-spot-list__ref a'
  html_doc.search(html_selector).each do |element|
    arr << element.attribute('href').value
  end
end


spots = []

arr.each do |link|
  url = 'https://www.surfline.com' + link
  link_parts = link.split('/')
  surfline_id = link_parts.last
  spot_name = link_parts[-2]
  spot = {
    surfline_id: surfline_id,
    spot_name: spot_name
  }

  html_file = URI.open(url).read
  html_doc = Nokogiri::HTML(html_file)
  html_selector = '.sl-ideal-conditions__condition__description'
  html_doc.search(html_selector).each do |element|
     key = element.css('h5').text
     value = element.css('p').text
     spot[key] = value
  end
  spots << spot
end

File.open('spots.json', 'wb') do |file|
  file.write(JSON.generate({
    spots: spots
  }))
end

# X id
#  Country name
# X Spot name
#  description
# X Ideal swell
# X Ideal wind
# X Ideal surf height
# X Ideal tide
#  Ability level
#  Vibe

# # this outputs all the content from the ideal conditions
# # we need to divide it/organize it to output a JSON per spot with
# # JSON:  surf spot / swell direction / wind / surf height / tides


