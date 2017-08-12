#!/bin/bash

set -e


REPOSITORY=$1
FROMTAG=$2
TOTAG=$3

echo "$REPOSITORY $FROMTAG -> $TOTAG"





getLogin() {
    read -p "Please enter username (or empty for anonymous): " username
    if [ -n "$username" ]; then
        read -s -p "password: " password
        echo
    fi
}

getToken() {
    local reponame=$1
    local actions=$2
    local headers
    local response

    if [ -n "$username" ]; then
        headers="Authorization: Basic $(echo -n "${username}:${password}" | base64)"
    fi

    response=$(curl -s -H "$headers" "https://auth.docker.io/token?service=registry.docker.io&scope=repository:$reponame:$actions")

    echo $response | jq '.token' | xargs echo
}


getLogin

TOKEN=$(getToken $REPOSITORY "pull,push")


curl -s -H "Authorization: Bearer $TOKEN" -H "Accept: application/vnd.docker.distribution.manifest.v2+json" https://index.docker.io/v2/$REPOSITORY/manifests/${FROMTAG} > manifest.json
curl -XPUT  -s -H "Authorization: Bearer $TOKEN" -H "Content-type: application/vnd.docker.distribution.manifest.v2+json" https://index.docker.io/v2/$REPOSITORY/manifests/${TOTAG} -d '@manifest.json'


