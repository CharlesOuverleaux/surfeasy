# Create a scraping script to get the ideal conditions of a surf spot
# from surfline and save it in our data scraping
require 'open-uri'
require 'nokogiri'

# we need to find a way to get all the surf spot links

surf_spot = 'ribeira-de-ilhas/5842041f4e65fad6a7708bc2'
base_url = 'https://www.surfline.com/surf-report/'
url = base_url + surf_spot

html_file = URI.open(url).read
html_doc = Nokogiri::HTML(html_file)

html_selector = '.sl-ideal-conditions__condition__description p'

# this outputs all the content from the ideal conditions
# we need to divide it/organize it to output a JSON per spot with
# JSON:  surf spot / swell direction / wind / surf height / tides

html_doc.search(html_selector).each do |element|
  p element.text
end
