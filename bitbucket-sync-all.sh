#!/bin/bash
# Script to get all repositories from a bitbucket user and keep them in sync

if [ -z "${1}" ] || [ -z "${2}" ]; then \
	echo "usage: bitbucket-sync-all.sh <username> <apikey>"
	exit;
fi

echo "fetching repoinfo.json"
curl -u ${1}:${2}  https://api.bitbucket.org/1.0/users/${1} > repoinfo.json 2>/dev/null

for repo_name in $(grep -Po '"name":.*?[^\\]",' repoinfo.json |cut -f4 -d\")
do
	if [ -d "$repo_name.git" ] ; then \
		echo fetching "$repo_name"
		git --git-dir="$repo_name.git" fetch -q --all -p
	else \
		git clone --bare "ssh://git@bitbucket.org/${1}/$repo_name"
	fi
done
