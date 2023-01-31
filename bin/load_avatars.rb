#!/usr/bin/env ruby

require "/mastodon/config/environment.rb"

Account.where(avatar_file_name: nil).all.each do |a|
  begin
    uf = ActionDispatch::Http::UploadedFile.new(
      tempfile: File.open("/opt/mastodon/public/avatars/original/#{a.username}.jpg"),
      filename: "#{a.username}.jpg",
      type: "image/jpeg",
      head: {}
    )
    a.update(avatar: uf)
  rescue => e
    Rails.logger.error("failed to update avatar for #{a.username}: #{e.message}")
  end
end
