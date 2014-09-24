#!/bin/bash
#
# This script takes an existing ikiwiki (http://ikiwiki.info/) site and converts
# the files to a format suitable for Hakyll input. 
#
# Specifically it takes my own ikiwiki files as input. Your mileage may vary.
# Actually, you should expect problems.
#
# This script just handles the conversion of the markdown files and the copying 
# of images. You will still need to write a suitable site.hs for your particular
# layout

# Arguments required to run this conversion

## Copy the source files to the destination folder
# Each needs to be copied from it's original name to a directory of the same 
# name, minus the mdwn extension.
# The file itself is renamed to index.html (as per ikiwiki)
# metadata fields are added
# published
# author
# title
# date ??

## Iterate through each file  
# Delete ikiwiki statements from the top of the file
# Delete tags from the bottom of each file
# Locate any images 
