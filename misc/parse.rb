#!/usr/bin/env ruby
require 'rubygems'
require 'json'
require 'pp'

string = ARGF.read

orgs = Hash.new

parsed = JSON.parse(string)
parsed.each do |eek|
  eek.each do |key, value|
    p key
    p value
  end
end
##squang = parsed["resources"]
##p squang.class
##squang.each do |md|
##  p md["entity"].class
##end

##parsed.find {|x| x['resources'] == 'entity' }
#pp parsed["resources"]["entity"]["name"].class
#parsed["resources"]["entity"]["name"].each do |naime|
#  p naime
#end
