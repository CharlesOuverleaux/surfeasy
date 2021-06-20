# Create a scraping script to get the ideal conditions of a surf spot
# from surfline and save it in our data scraping
require 'open-uri'
require 'nokogiri'
require 'json'

# fixed regions links
regions = [
  'portugal/porto/2735941',
  'portugal/leiria/2267094',
  'portugal/lisbon/2267056',
  'portugal/set-bal/2262961',
  'portugal/beja/2270984',
  'portugal/faro/2268337',
  'spain/galicia/3336902'
]

# URL's
base_url = 'https://www.surfline.com'

# Methods
def get_html_doc(url)
  html_file = URI.open(url).read
  return Nokogiri::HTML(html_file)
end

def get_location(spot_id)
  url = "https://services.surfline.com/kbyg/spots/forecasts/wave?spotId=#{spot_id}"
  res = JSON.parse(URI.open(url).read)
  res['associated']['location']
end

puts "Getting all the spots from the regions"
spot_links = []
regions.each do |region|
  url = "#{base_url}/surf-reports-forecasts-cams/#{region}"
  html_doc = get_html_doc(url)
  html_doc.search('.sl-spot-list__ref a').each do |element|
    spot_links << element.attribute('href').value
  end
end
puts "got all the spots from region"

puts "starting to scrape each spot"
spots = []
spot_links.each do |link|
  # split link and take: id & spot name
  link_parts = link.split('/')
  spot = {
    'surfline_id' => link_parts.last,
    'spot_name' => link_parts[-2]
  }

  location = get_location(spot['surfline_id'])
  spot['latitude'] = location['lat']
  spot['longitude'] = location['lon']

  # scrape spot details
  url = "#{base_url}#{link}"
  html_doc = get_html_doc(url)
  # ideal condition search
  html_doc.search('.sl-ideal-conditions__condition__description').each do |element|
    key = element.css('h5').text
    value = element.css('p').text
    spot[key] = value
  end
  # get country of spot
  country = html_doc.css('.sl-link').first.text
  spot['country'] = country
  # description
  description = html_doc.css('.sl-travel-guide__overview__description').text
  spot['description'] = description
  # ability and rating
  # select the container & loop thourgh each div
  html_doc.search('.sl-travel-guide__overview__ratings div').each do |element|
    # select the title (Ability or vibe)
    title = element.css('h3').text
    # check the matching title
    if ['Ability Level', 'Local Vibe'].include?(title)
      # add the info to the spot JSON
      spot[title] = element.css('h2').text
    end
  end
  # select the container & loop through each div
  html_doc.search('.sl-travel-guide__notes div').each do |element|
    # select the title (Access)
    title = element.css('h3').text
    # check the matching title
    if ['Access'].include?(title)
      # read 'Spot Access' & add the info to the spot JSON
      spot[title] = element.css('p').text
    end
  end
  puts "  Done scraping #{spot['spot_name']} [#{spots.length + 1}/#{spot_links.length}]"
  spots << spot
end

File.open('scraping/data/spots_import.json', 'wb') do |file|
  file.write(JSON.generate({
                             spots: spots
                           }))
end
