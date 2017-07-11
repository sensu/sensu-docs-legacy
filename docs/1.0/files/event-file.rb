#!/usr/bin/env ruby

require 'rubygems'
require 'json'

# Read the JSON event data from STDIN.
event = JSON.parse(STDIN.read, :symbolize_names => true)

# Write the event data to a file.
# Using the client and check names in the file name.
file_name = "/tmp/sensu_#{event[:client][:name]}_#{event[:check][:name]}.json"

File.open(file_name, 'w') do |file|
  file.write(JSON.pretty_generate(event))
end
