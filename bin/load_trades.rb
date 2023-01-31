#!/usr/bin/env ruby

require "/mastodon/config/environment.rb"

Dir["/critters/generated/current.*.json"].each do |json|
  trades = JSON.parse(File.read(json), symbolize_names: true)
  trades.sort_by! {|t| t[:disclosed_on] }
  bkt = []
  day = trades.first[:disclosed_on]
  trades.each do |t|
    if t[:disclosed_on] != day
      File.write("/critters/generated/trades.#{day}.json", bkt.to_json)
      bkt = []
      day = t[:disclosed_on]
    end
    
    bkt << t
  end

  FileUtils.rm_f json
end

begin
  Dir["/critters/generated/trades.*.json"].each do |json|
    trades = JSON.parse(File.read(json), symbolize_names: true)
    ActiveRecord::Base.transaction do
      trades.each do |trade|
        begin
          a = Account.find_by!(username: trade[:username])
          PostStatusService.new.call(a, text: trade[:text]).tap {|s| s.created_at = DateTime.parse(trade[:disclosed_on]) }.save
          Rails.logger.info("create status post for #{trade[:username]}")
        rescue => e
          Rails.logger.error("failed to create status post for #{trade[:username]}: #{e.message}")
        end
      end
      FileUtils.rm_f json
    rescue => e
      Rails.logger.error("failed to import #{json}: #{e.message}")
    end
  end
rescue
  Rails.logger.error("failed to import trades dir: #{e.message}")
end

