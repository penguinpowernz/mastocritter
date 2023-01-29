
all: profiles avatars

avatars: get_images
	mkdir -p avatars generated
	bin/avatars.rb > generated/avatars.rb

get_images:
	git clone https://github.com/unitedstates/images || true

download_profiles: dp
profiles: dp
dp:
	wget -nc https://bioguide.congress.gov/bioguide/data/BioguideProfiles.zip
	unzip BioguideProfiles.zip -d BioguideProfiles

clean:
	rm -fr public avatars generated BioguideProfiles.zip BioguideProfiles images

get_stonks:
	mkdir -p avatars generated
	lstrades -d > stonks.json
	lstrades -m stonks.json > generated/profiles.rb

load:
	docker-compose exec web /critters/bin/load.rb



start:
	docker-compose up -d

status:
	docker-compose ps