
all: profiles avatars

avatars: get_images
	mkdir -p avatars generated
	bin/generate_avatar_files.rb

get_images:
	git clone https://github.com/unitedstates/images || true

download_profiles: dp
profiles: dp
dp:
	wget -nc https://bioguide.congress.gov/bioguide/data/BioguideProfiles.zip
	unzip BioguideProfiles.zip -d BioguideProfiles

clean:
	rm -fr public avatars generated BioguideProfiles.zip BioguideProfiles images

download_lstrades:
	curl -sSL https://github.com/penguinpowernz/stonkcritter/releases/download/v2.1.0/lstrades.amd64 -o bin/lstrades
	chmod +x bin/lstrades

setup: download_lstrades download_profiles avatars

start:
	docker-compose up -d

status:
	docker-compose ps