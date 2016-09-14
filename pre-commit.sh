#!/bin/bash

set -e

####################################################
# SETUP START
#
# global git hooks setup
#  - git config --global init.templatedir '~/.git-templates'
#  - mkdir -p ~/.git-templates/hooks
#  - create ~/.git-templates/hooks/pre-commit file and populate it with this bash script
#  - make file executable
#      chmod a+x ~/.git-templates/hooks/pre-commit
#  - reinitialise each relevant git hub repo that should use the script
#      git init

# jq is a dependency which will need to be installed
#   https://stedolan.github.io/jq/  osx
#   - copy file to /usr/local/bin
#   - make file executable
#     chmod +x jq
# SETUP END
####################################################

if [ ! -f ./deploy/metadata.json ]; then
    exit
fi

currentVersion=($(jq -r '.version' ./deploy/metadata.json))
lastVersionPart="${currentVersion##*.}"
lastVersionPart=$((lastVersionPart + 1))
newVersion=${currentVersion%.*}.${lastVersionPart}
jq '.version="'${newVersion}'"' ./deploy/metadata.json > tmp.$$.json && mv tmp.$$.json ./deploy/metadata.json
git add ./deploy/metadata.json