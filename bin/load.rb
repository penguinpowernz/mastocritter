#!/usr/bin/env ruby

require "/mastodon/config/environment.rb"

Dir["/critters/generated/*.rb"].each do |f|
  require f
end

#require "/critters/generated/avatars.rb"
#require "/critters/generated/accounts.posts.rb"
