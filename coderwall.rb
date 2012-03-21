# v0.1
# written (very badly) by scott boss
#
#
require "rubygems"
require 'json'
require 'net/http'
#
username = ARGV[0]
#
if username.nil? then
  puts "no name provided"
  puts $0 + " coderwall_username"
else
base_url = "http://coderwall.com/" + username + ".json"
resp     = Net::HTTP.get_response( URI.parse( base_url ) )
data     = resp.body
result   = JSON.parse( data )
#puts result.class
result["badges"].each { |i|
  uri = URI.parse( i["badge"] )
  Net::HTTP.start( uri.host,uri.port ) do |http|
    filename = i["name"] + ".png"
    response = http.get( uri.path )
    open( filename, "wb" ) do |file|
      file.write( response.body )
    end
  end
  puts i["name"] + " -> " + i["description"]
  }
end