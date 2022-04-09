#!/bin/bash
# Get Image URI from a json file generated by push.sh
IMAGE_URI=$(cat image_uri.json | jq .Image_URI | sed 's/"//g')
echo '{ "URI": "'$IMAGE_URI'" }'