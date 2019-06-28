require 'rubygems'
gem 'libxml-ruby', '>= 0.8.3'
require 'json'
require 'rss'
require 'open-uri'
require 'active_support/all'
require 'net/http'
require 'nokogiri'
require 'xml'
require 'date'

url = "http://www.waze.com/rtserver/web/GeoRSS?format=JSON&mj=10&ma=10&jmds=120&jmu=0&left=-9902228.4683365&right=-9233863.0931305&bottom=4707736.5908183&top=5045282.5076653&sc=1733376&pr=Mercator"


uri = URI.parse(url)
request = Net::HTTP::Post.new(uri.path)
response = Net::HTTP.new(uri.host, uri.port).start{ |http| http.request(request) }
#puts response.body
f = File.open("response.txt", 'w')
#doc = Nokogiri::XML(f)
f.write(response.body)
f.close

f = File.open("response.txt", 'r')

parser = XML::Parser.string(f.read, :options =>XML::Parser::Options::RECOVER)

#puts doc.at('linqmap:type').detect{ |i| i.text == "POLICEMAN" }
doc = parser.parse
items = doc.find("channel").first.find("item").select do |item|
  item.find("linqmap:type").first.content == "POLICEMAN"
  #and just guessing you want that url thingy
  # puts item.find("media:content").first.attributes.get_attribute("url").value
end
#puts items
#puts items.count

csv_file = File.open("police_locations.csv", 'a')

#puts "writing to file"

items.each do |i|
  csv_file.write(i.find("georss:point").first.content.gsub(" ", ",") + "," + DateTime.now.strftime("%m/%d/%Y %H:%M:%S") + "\n")
end

# feed = RSS::Parser.parse(f, false)
# puts "TITLE: #{feed.channel.title}"
# puts "ITEM:"
# puts feed.items.first
# feed.items.each do |i|
#   puts "1"
#   begin
#     puts i.linqmap[:type]
#   rescue
#     nil
#   end
#   puts "2"
#   begin
#     puts i.linqmap['type']
#   rescue
#     nil
#   end
#   puts "3"
#   begin
#     puts i.linqmap_type
#   rescue
#     nil
#   end
# end
#cop = feed.items.detect{ |i| i.linqmap[:type] == "POLICEMAN" }
#puts "COP:"
#puts cop

#open(url) do |rss|
#  feed = RSS::Parser.parse(rss)
#  if feed.present?
#    puts "Title: #{feed.channel.title}"
#    feed.items.each do |item|
#      puts "Item: #{item.title}"
#    end
#  else
#    json = JSON.parse(rss.read)
#    puts rss.read
#  end
#end
