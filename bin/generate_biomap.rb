#!/usr/bin/env ruby

require 'json'

states = JSON.parse(File.read("states_hash.json"))

map = {}

Dir["BioguideProfiles/*.json"].each do |fn|
  profile = JSON.parse(File.read(fn))
  fname = profile["givenName"]
  fname = profile["middleName"] if fname.match(/^[^\.]*\./)
  fname = profile["nickName"] if profile.key?("nickName")
  lname = profile["familyName"]
  name = "#{fname}_#{lname}".downcase.gsub(/[^a-z_]/, '')
  id = profile["usCongressBioId"]

  fname = fname.gsub(/'/,"@'").split(",").first
  lname = lname.gsub(/'/,"@'").split(",").first

  memorial = false
  if profile["deathDate"]
    memorial = true
  end

  job = profile["jobPositions"].last
  pos = job["job"]["name"] rescue ""
  
  dname = ""
  dname = "#{pos[0..2]}. " if pos
  dname += "%s %s" % [fname, lname]

  stateCode = job["congressAffiliation"]["represents"]["regionCode"] rescue ""
  state = states[stateCode]

  username = (fname+"_"+lname).downcase
  map[username] = {
    position: pos,
    state: state,
    display_name: dname,
    fname: fname,
    lname: lname,
    id: id,
    memorial: memorial
  }
end

puts map.to_json