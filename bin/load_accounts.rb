#!/usr/bin/env ruby

require 'json'

require "/mastodon/config/environment.rb"

bios = JSON.parse(File.read("/critters/generated/bios.json"), symbolize_names: true)
metas = JSON.parse(File.read("/critters/generated/meta.json"), symbolize_names: true)

metas.each do |username, meta|
  bio = bios[username]
  a = nil
  begin
    a = Account.find_by!(username: username)
  rescue
    a = Account.create(
      username: username,
      display_name: meta[:name],
    )
  end

  a.memorial = bio.memorial
  a.note = "Mock account of %s for %s. I typically disclose trades within %d days. I did %d trades in the last 30 days. %s" % [
    bio[:position],
    bio[:state],
    meta[:avg_disclosure_days],
    meta[:trades_last30_days],
    meta[:associated_tickers].map{|t| "#"+t }.join(" ")
  ]
  a.save
end