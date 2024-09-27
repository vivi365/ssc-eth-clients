#!/bin/bash

# GitHub username and personal access token for authentication
TOKEN="${GITHUB_TOKEN}"         # Read from environment variable

# Repository owner and name
if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Repository owner and name are required."
    exit 1
fi
OWNER=$1  # ethereum
REPO=$2    # go-ethereum

# Get the current date
CURRENT_DATE=$(date +%Y-%m-%dT%H:%M:%S%z)

# Calculate the date one year ago from now
ONE_YEAR_AGO=$(date -d "-1 year" +%Y-%m-%dT%H:%M:%S%z) 

# Query the GitHub API to get contributors for the repository's main branch in the last year
page=1
total_contributors=0
seen_contributors=""

while true; do
    curl_response=$(gh api --method GET https://api.github.com/repos/$OWNER/$REPO/commits \
    -F since=$ONE_YEAR_AGO -F until="$CURRENT_DATE" -F page=$page \
    --header 'Accept: application/vnd.github+json' \
    --header "X-GitHub-Api-Version: 2022-11-28" \
    --header "Authorization: token $TOKEN")  # Use the token for authorization

    contributors_on_page=$(echo "$curl_response" | jq -r '.[].author.login')

    # Iterate over contributors on the current page
    for contributor in $contributors_on_page; do
        # Check if the contributor has been seen before
        if ! [[ "$seen_contributors" =~ "$contributor" ]]; then
            seen_contributors+=" $contributor"
            ((total_contributors++))
        fi
    done
    
    # If curl_response is empty, break the loop
    if [ -z "$curl_response" ] || [ "$contributors_on_page" == "" ]; then
        break
    fi
    
    # Increment page number
    ((page++))
done

# Output results to a file
echo "Number of contributors in the last year: $total_contributors" > contributors-year.txt
echo -e "\n\n$seen_contributors" >> contributors-year.txt

