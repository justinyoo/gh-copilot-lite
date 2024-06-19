#!/bin/bash

# Assign named arguments to variables
for arg in "$@"
do
    case $arg in
        --url=*)
        URL="${arg#*=}"
        shift # Remove --url= from processing
        ;;
        --filepath=*)
        FILEPATH="${arg#*=}"
        shift # Remove --filepath= from processing
        ;;
    esac
done

# Check if URL and FILEPATH variables are set
if [ -z "$URL" ] || [ -z "$FILEPATH" ]; then
    echo "Both --url and --filepath arguments are required."
    exit 1
fi

# Download the data from the URL and save it to the file path
curl "$URL" -o "$FILEPATH"

# Read the data from the saved file and process it
# Assuming the data is in JSON format and jq is installed
jq -r '.items | group_by(.artist) | .[] | sort_by(.title) | .[] | @base64' "$FILEPATH" |
while read -r line; do
    echo $line | base64 --decode | jq -r '[.artist, .title] | @tsv'
done | column -t