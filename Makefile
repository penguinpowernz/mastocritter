
all: profiles avatars

avatars: get_images
	mkdir -p public generated
	bin/main.rb > generated/avatars.rb

get_images:
	git clone https://github.com/unitedstates/images

download_profiles: dp
profiles: dp
dp:
	wget https://bioguide.congress.gov/bioguide/data/BioguideProfiles.zip
	unzip BioguideProfiles.zip

clean:
	rm -fr public generated BioguideProfiles.zip BioguideProfiles images
