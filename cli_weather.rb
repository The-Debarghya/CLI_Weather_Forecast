require 'open-uri'
require 'json'

def KelvinToCelcius(kelvin)
	return (kelvin - 273.15).round(2)
end

def KelvinToFahrenheit(kelvin)
	return (kelvin * 9/5 - 459.67).round(2)
end

if ARGV.empty?
	puts "Pass location parameters in the following format: '[City], [State]'"
else

search = Array.new
ARGV.each do |argv|
	search << argv
end
search = search.join

baseurl =  "http://api.openweathermap.org/data/2.5/weather?q="
appid = "&APPID=aade92db2619aca3f567b1ac542128b5"
fullurl = "#{baseurl}#{search}#{appid}"

data = URI.open(fullurl).read
json = JSON.parse(data)

if json['cod'] == 400
	abort("City not found. Please try again.")
end

tempc = KelvinToCelcius(json["main"]["temp"])
highc = KelvinToCelcius(json["main"]["temp_min"])
lowc = KelvinToCelcius(json["main"]["temp_max"])

tempf = KelvinToFahrenheit(json["main"]["temp"])
highf = KelvinToFahrenheit(json["main"]["temp_min"])
lowf = KelvinToFahrenheit(json["main"]["temp_max"])

puts "\n******Weather Forecast for #{search}:******\n\n"
puts "Temperature (F°) #{tempf}° (highest: #{highf}/lowest: #{lowf})"
puts "Temperature (C°) #{tempc}° (highest: #{highc}/lowest: #{lowc})"
puts ""
puts "Description: #{json['weather'].first['description']}"
puts "Wind Speed: #{json['wind']['speed']} mph"
puts "Cloudiness: #{json['clouds']['all']}%"
