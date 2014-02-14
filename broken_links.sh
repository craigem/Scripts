#!/bin/bash
#
# This script calls curl and checks known broken links from an input
# file and outputs a file of links that still failed.
# It's rought and ready with no error handling, enjoy.

# Where is your curl?
curl=/usr/bin/curl

# Request the file to be read in
echo "Enter the path and file name that contains the broken URLs: "
read urls
# Request the output file
echo "Enter the full or relative path & file name for the list of still broken URLs:"
read broken

# Initialise the array
index=0

# Loop through the array
while read url ; do
	URLARRAY[$index]="$url"
	echo "Now checking: $url"
	# Set STATUS_CODE to use the curl command
	STATUS_CODE=`$curl --output /dev/null --silent --head --write-out '%{http_code}\n' $url`
	# Check all the URLs and if it's 404 let me know
	case $STATUS_CODE in
		#404) echo "$url returned $STATUS_CODE : Not Found" ;;
		# Add the 404 URLs to the list of still broken URLs
		404) echo $url > $broken ;;
	esac
	index=$(($index+1))
done < $urls

echo "Total URLs in the file: ${index}"

exit 0
