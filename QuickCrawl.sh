#!/bin/bash

# Prompt the user for the URL of the website
echo "Enter the URL of the website: "
read url

# Use wget to download the website
wget $url

# Use grep to search the downloaded HTML for hyperlinks and URLs
grep -Eo "(http|https)://[a-zA-Z0-9./?=_-]*" index.html > result.txt

# Remove the downloaded HTML file
rm index.html

# Print a message to the user
echo "Hyperlinks and URLs saved to result.txt"
