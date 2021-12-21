#!/usr/bin/env ruby
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

baseurl =  "http://api.openweathermap.org/data/2.5/forecast?q="
appid = "&APPID={apikey}"
fullurl = "#{baseurl}#{search}#{appid}"

data = URI.open(fullurl).read
json = JSON.parse(data)

if json['cod'] == 400
	abort("City not found. Please try again.")
end
puts "\n******Weather Forecast of #{search} for next 16 hours:******\n\n"
for i in 0..16 do
	tempc = KelvinToCelcius(json["list"][i]["main"]["temp"])
	highc = KelvinToCelcius(json["list"][i]["main"]["temp_max"])
	lowc = KelvinToCelcius(json["list"][i]["main"]["temp_min"])

	tempf = KelvinToFahrenheit(json["list"][i]["main"]["temp"])
	highf = KelvinToFahrenheit(json["list"][i]["main"]["temp_min"])
	lowf = KelvinToFahrenheit(json["list"][i]["main"]["temp_max"])

	puts "Temperature (F°) #{tempf}° (highest: #{highf}/lowest: #{lowf})"
	puts "Temperature (C°) #{tempc}° (highest: #{highc}/lowest: #{lowc})"
	puts ""
	puts "Description: #{json["list"][i]['weather'][0]["description"]}"
	puts "Wind Speed: #{json["list"][i]['wind']['speed']} mph"
	puts "Cloudiness: #{json["list"][i]['clouds']['all']}%"
	puts "****************************************************************"
end
end

