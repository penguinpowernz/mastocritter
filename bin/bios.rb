#!/usr/bin/env ruby

require 'json'

states = JSON.parse(File.read("states_hash.json"))


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

  if profile["deathDate"]
    puts %q[Account.where("display_name LIKE '%%%s%%%s%%'").first.tap {|a| a.memorial = true }.save rescue nil] % [fname, lname]
  end

  job = profile["jobPositions"].last
  pos = job["job"]["name"] rescue ""
  
  dname = ""
  dname = "#{pos[0..2]}. " if pos
  dname += "%s %s" % [fname, lname]

  stateCode = job["congressAffiliation"]["represents"]["regionCode"] rescue ""
  state = states[stateCode]

  note = "Mock account of %s for %s." % [pos, state]
  puts %q[Account.where("display_name LIKE '%%%s%%%s%%'").first.tap {|a| a.note = "%s"; a.display_name = "%s" }.save rescue nil] % [fname, lname, note, dname]

end