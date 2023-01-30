#!/usr/bin/env ruby

require "/mastodon/config/environment.rb"

loop do
  day = Time.now.strftime("%F")
  cursor = JSON.parse(File.read("/critters/cursor.json"))["cursor"]
  FileUtils.chdir "/critters" do
    system "/critters/bin/lstrades -d"
    system "/critters/bin/lstrades -mr > /critters/generated/meta.json"
    system "/critters/bin/lstrades -mr -c #{cursor} > /critters/generated/trades.#{day}.json"
    system "/critters/bin/generate_biomap.rb > /critters/generated/bios.json"
  end

  require "/critters/bin/load_accounts"
  require "/critters/bin/load_avatars"
  require "/critters/bin/load_trades"

  sleep_time = Date.tomorrow.midnight.to_time.to_i - Time.now.to_i
  Rails.logger.info "sleeping for #{sleep_time}s"
  sleep sleep_time
end