#!/bin/bash
# Dan Shick 2018
# simple script to deploy mastodon https://github.com/tootsuite/mastodon
TAG=$1
function die() { echo -e "$@" 1>&2 ; exit 1; }
cd ~/live
git fetch --tags
TERGS="$(git tag --sort=committerdate | tail -5)"
LATEST="$(echo "$TERGS" | tail -1)"
echo "FYI, the latest 5 tags are: 
$TERGS"
if [ "x$TAG" == "x" ]
then
	read -e -p "Enter a tag (latest by default): " -i $LATEST TAG
fi
echo "$TAG" | grep -q '^v' || die "Tag must begin with a 'v'."
echo ""
echo "Do you want to fetch and checkout the following tag? y/N: -- $TAG"
read YN
if [ $YN != "y" ]
then
	echo "Guess you didn't want to."
	exit 1
else
	cd ~/live
	git tag | grep -q ^$TAG$ || die "No such tag: $TAG"
	echo "Checking out tag $TAG."
	sleep 5
	git checkout tags/$TAG
	echo "Check the release notes."
	commands=(ls "df -h" who last)
	read -e -p "bundle install? y/N: "  YUN
	if [ $YUN == "y" ]
	then
		bundle install || die "Failed."
	fi
	read -e -p "yarn install? y/N: "  YUN
	if [ $YUN == "y" ]
	then
		yarn install || die "Failed."
	fi
	read -e -p  "RAILS_ENV=production bundle exec rails db:migrate? y/N: "  YUN
	if [ $YUN == "y" ]
	then
		RAILS_ENV=production bundle exec rails db:migrate || die "Failed."
	fi
	read -e -p  "RAILS_ENV=production bundle exec rails assets:precompile? y/N: "   YUN
	if [ $YUN == "y" ]
	then
		RAILS_ENV=production bundle exec rails assets:precompile || die "Failed."
	fi
fi
echo "
Now you can run restart-mastodon.sh as root unless there are other commands to be run in the deployment."
