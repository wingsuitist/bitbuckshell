#!/bin/bash
# Script to get all repositories under a user from bitbucket
# Usage: bitbucket-clone-all.sh <username> <apikey>

curl -u ${1}:${2}  https://api.bitbucket.org/1.0/users/${1} > repoinfo.json
for repo_name in `grep -Po '"name":.*?[^\\]",' repoinfo.json |cut -f4 -d\"`
do
	git clone --bare ssh://git@bitbucket.org/${1}/$repo_name
done
