# v0.2
# written (very badly) by scott boss
#
#
require "rubygems"
require 'json'
require 'net/http'
require 'colored'
#
username = ARGV[0]
#
if username.nil? then
  puts "no name provided".red
  puts $0.red + " coderwall_username".red
else
base_url = "http://coderwall.com/" + username + ".json"
resp     = Net::HTTP.get_response( URI.parse( base_url ) )
data     = resp.body
result   = JSON.parse( data )
#puts result.class
result["badges"].each { |i|
  uri = URI.parse( i["badge"] )
  Net::HTTP.start( uri.host,uri.port ) do |http|
    filename = i["name"].sub( / /, "_" ) + ".png"
    if File::exists?( filename ) then
      puts "already have ".red + filename
    else
      response = http.get( uri.path )
      open( filename, "wb" ) do |file|
        file.write( response.body )
      end
       puts i["name"].green + " -> " + i["description"].white
    end
  end

  }
end