#!/bin/bash

_temp_tag=$1

echo "_temp_tag environment variable is: $_temp_tag"

if [ "$_temp_tag" == "latest" ] || [ "$_temp_tag" == "development" ]
then
	echo "Updating $_temp_tag image"
	docker ps -q -a -f "ancestor=cyzhang/discord_quote_bot:$_temp_tag" |xargs docker stop
	docker ps -q -a -f "ancestor=cyzhang/discord_quote_bot:$_temp_tag" |xargs docker rm
	docker pull cyzhang/discord_quote_bot:$_temp_tag

	if [ "$_temp_tag" == "latest" ]
	then
		docker run --restart unless-stopped \
	    		-d -e DISCORD_QUOTEBOT_TOKEN=$DISCORD_QUOTEBOT_TOKEN \
			-e DISCORD_QUOTEBOT_BUCKET=$DISCORD_QUOTEBOT_BUCKET \
			-e DISCORD_QUOTEBOT_DB_FILENAME=$DISCORD_QUOTEBOT_DB_FILENAME \
			cyzhang/discord_quote_bot:latest
	elif [ "$_temp_tag" == "development" ]
	then
		docker run --restart unless-stopped \
	    		-d -e DISCORD_QUOTEBOT_TOKEN=$DISCORD_QUOTEBOT_DEV_TOKEN \
			-e DISCORD_QUOTEBOT_BUCKET=$DISCORD_QUOTEBOT_BUCKET_DEV \
			-e DISCORD_QUOTEBOT_DB_FILENAME=$DISCORD_QUOTEBOT_DB_FILENAME_DEV \
			cyzhang/discord_quote_bot:development
	fi
	
	docker system prune -f
else
	echo "Tag is $_temp_tag; not updating."
fi
