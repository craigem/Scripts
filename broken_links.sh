#!/bin/bash
#
# This script calls lynx and checks known broken links from an input
# file and outputs a file of links that still failed.

# Request the file to be read in
echo "Enter the file name: "
read urls

$debug " Number of elements in array is $(( ${#urls[@]} ))"
for i in $($SEQ 0 $((${#urls[@]} - 1)))
do
  echo $urls{a[$i]}
done

# Initialise the array


# Loop through the array
#while read url ; do
#	URLARRAY[$index]="$url"
#	echo "URLARRAY is: ${URLARRAY[*]}"
#	index=$(($index+1))
#done < $urls
