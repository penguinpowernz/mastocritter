#!/usr/bin/env ruby

require 'json'

image_base = "images/congress/450x550"
target = ENV["TARGET"]
target = "./public" if target.nil?

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
#    puts %q[c += Account.where("display_name LIKE E'%%%s%%%s%%' ESCAPE '@'").count] % [fname, lname]
#    next
    
    srcimg = "#{image_base}/#{id}.jpg"
    next unless File.exist? srcimg

    s = File.size(srcimg)
 #   system("ln -s ../#{srcimg} #{target}/#{name}.jpg")
    system("cp -l #{srcimg} #{target}/#{name}.jpg")

    print %q[Account.where("display_name LIKE '%%%s%%%s%%'").first.tap {|a|] % [fname, lname]
    print %q[ a.avatar_file_name = Rails.root.join("public", "avatars", "original", "%s.jpg");] % [name]
    print %q[ a.content_type = "image/jpeg";]
    print %q[ a.avatar_file_size = %d;] % [s]
    print %q[ a.avatar_updated_at = DateTime.now;]
    puts %q[}.save rescue nil]
end
