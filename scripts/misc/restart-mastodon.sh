#!/bin/bash
# Dan Shick 2018
# boring restart services for mastodon https://github.com/tootsuite/mastodon
SERVICES="web sidekiq streaming"
echo "About to restart the following services: $SERVICES"
sleep 5
for I in $SERVICES
do
	systemctl stop mastodon-$I.service
	systemctl start mastodon-$I.service
	systemctl status mastodon-$I.service
done
