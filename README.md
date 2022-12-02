# Mastocritters

A toolchain for creating mastodon bots that masquerade as US Politicians
disclosing their stock trades.

## Method of Operation

I didn't want to patch Mastodons API to allow certain extra required features like modifying
a posts publish time. I opted instead for generating ruby code that can be directly run by the rails
apps runner script.

```ruby
#!/usr/bin/env ruby

require '/path/to/mastodon/config/environment.rb'
require '/path/to/mastocritter/generated/accounts.posts.rb'
require '/path/to/mastocritter/generated/avatars.rb'
```

Also having avatars is nice, so bioguides.congress.gov and github.com/unitedstates/images are used
to create avatar images file structure.  The same script that does this also sets the avatar on the
mastodon accounts.

1. Generate ruby code for accounts and posts using [stonkcritter](https://github.com/penguinpowernz/stonkcritter)
1. Downloads "BioGuide" profiles
1. Downloads images of US Politicians for account avatars
1. Convert images to be more easily accessible by the Mastodon avatar system
1. Generate ruby code to add avatars to accounts
1. Load ruby code into the rails app

## Usage

Use it like this:

    make profiles
    make avatars
