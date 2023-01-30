#!/usr/bin/env ruby

require "/mastodon/config/environment.rb"

Dir["/critters/generated/trades.*.json"].each do |json|
  trades = JSON.parse(File.read(json), symbolize_names: true)
  ActiveRecord::Base.transaction do
    trades.each do |trade|
      begin
        a = Account.find_by!(username: trade[:username])
        PostStatusService.new.call(a, text: trade[:text]).tap {|s| s.created_at = DateTime.parse(trade[:disclosed_on]) }.save
        FileUtils.rm_f "/critters/generated/trades.*.json"
      rescue
        Rails.logger.error("failed to create status post for: #{e.msg}")
      end
    end
  end
end


