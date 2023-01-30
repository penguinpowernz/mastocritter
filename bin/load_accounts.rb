#!/usr/bin/env ruby

# This script will load accounts into Mastodon based on the congress critters
# found in the metas.json file.  It expects a corresponding entry in the bios.json
# file as well.

require 'json'

require "/mastodon/config/environment.rb"

bios = JSON.parse(File.read("/critters/generated/bios.json"), symbolize_names: true)
metas = JSON.parse(File.read("/critters/generated/meta.json"), symbolize_names: true)

default_bio = {position: "??", state: "??", memorial: false}

metas.each do |username, meta|
  bio = bios[username]
  bio = resolve_bio(bios, username) if bio.nil?
  bio = default_bio if bio.nil?

  a = nil
  begin
    a = Account.find_by!(username: username)
  rescue
    a = Account.create(
      username: username,
      display_name: meta[:name],
    )
  end

  a.memorial = bio[:memorial]
  a.note = "Mock account of %s for %s. I typically disclose trades within %d days. I did %d trades in the last 30 days. %s" % [
    bio[:position],
    bio[:state],
    meta[:avg_disclosure_days],
    meta[:trades_last30_days],
    meta[:associated_tickers].map{|t| "#"+t }.join(" ")
  ]
  a.save
end

# try different methods to resolve bio
def resolve_bio(bios, username)
  _u = username.gsub(/_[a-z]_/, '_')
  return bios[_u]
end