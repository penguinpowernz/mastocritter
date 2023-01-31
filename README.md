# Mastocritters

A toolchain for creating mastodon bots that masquerade as US Politicians
disclosing their stock trades.


### Level1Techs Devember 2022

[![level1techslogo](https://level1techs.com/sites/all/themes/l1/img/black-logo.png)](https://level1techs.com/)

This was done as part of the [Level1Techs Devember competition](https://forum.level1techs.com/t/official-devember-2022/191497/63).  Check them out at https://level1techs.com/ or https://www.youtube.com/c/level1techs

This is running on a Linode server at https://indoors.trade using the Level1Techs coupon: https://linode.com/level1techs

The version of the software that was submitted for the competition is tagged v1.0.0.

[![image](https://user-images.githubusercontent.com/4642414/145663935-ca14c03f-c80f-4eaf-9dd4-141049720076.png)](https://linode.com/level1techs
)

## Method of Operation

I didn't want to patch Mastodons API to allow certain extra required features like modifying
a posts publish time. I opted instead for using the Mastodon evironment and models directly to
insert data parsed from the JSON output of other tools.

```ruby
#!/usr/bin/env ruby

require '/path/to/mastodon/config/environment.rb'

a = Account.create(username: "nancy_pelosi", note: "Mock account of Representative for California")
Status.new(account: a , text: "Hello world")
# ...etc...
```

Also having avatars is nice, so https://bioguides.congress.gov and https://github.com/unitedstates/images are used
to create avatar images file structure. 

The steps look something like this:

1. download BioGuides and images
1. rename the images to the congress critters name based on the BioGuides
1. download the trade disclosure data
1. generate a JSON doc of congress critters in that disclosure data, including some aggregate metadata
1. convert the BioGuides to a single JSON doc with just the info we need
1. create any missing accounts, update existing accounts with the latest metadata
1. add avatars to any accounts that were created
1. convert trade disclosures from the JSON doc to status posts

## Problems

There are some problems that need to be solved at some point:

* the names in the trade disclosure data don't always match whats in the bioguide, better matching is needed
* this also affects the avatar generation/naming
* unauthenticated Mastodon is not really that user friendly
* there is no way to uniquely identify any particular trade disclosure, so it is hard to protect against double ups
* updating is fragile for this reason