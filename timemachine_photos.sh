#!/bin/bash
#
# USE CASE:
# You have an external drive with Apple's TimeMachine backups on it. You would
# like to recover all the photos from one particular backup.
#
# This script
# * Takes the following arguments:
#   * $1 is the Drive location ie: usb0 or usb1
#   * $2 is the username
#   * $3 is the date you wish to recover from ie: 2014-04-19-131501
#   * $4 is where you wish the output to go
# * It will locate all the photos backed up on that date
# * Then copy them to your preferred location

set -eux
set -o pipefail

# Environment
# Where are your tools?
readonly SUDO=/usr/bin/sudo
readonly FIND=/usr/bin/find
readonly LS=/bin/ls
readonly AWK=/usr/bin/awk

# What has the user given us?
#readonly DRIVE="/media/$1/Time Machine Backups"
readonly DRIVE="/media/$1"
readonly USERNAME=$2
readonly RECOVERY_DATE=$3
readonly COPY_TO=$4

# Others

# Locate Pictures folder and get it's number
find_pictures() {
    # Make the first character of the user name upper-case to conform to the default Mac names
    local username=${USERNAME[@]^}
    # Find the path for the recovery date
    local date_path="$($SUDO $FIND "$DRIVE" -name $RECOVERY_DATE)"
    local pictures_path="$($SUDO $FIND "$date_path" -name Pictures)"
    local pictures_number="$($LS -lah "$pictures_path" | $AWK '{print $2}')"
    # Use it's number from the second column to locate the real Pictures data
    local real_pictures="$($SUDO $FIND "$DRIVE" -name dir_$pictures_number)"
    local photos="$($SUDO $LS "$real_pictures" | grep -i .jpg)"
    for i in "${photos}"; do
        echo "$i"
        PHOTO_ARRAY+=("$real_pictures"/"$i")
    done
    # Copy any photos (JPEGs) from the root folder
    # Iterate through the files in the real picture folders
    #
}

copy_pictures() {
    echo "Copy Pictures to $COPY_TO"
    for i in "${PHOTO_ARRAY[@]}"; do
        $SUDO cp "$i" $COPY_TO/
        echo "$i"
    done
}

check_pictures() {
    echo "Check Pictures"
}

main() {
    find_pictures
    copy_pictures
    check_pictures
}

main

### TO DO:
# Add error handling

exit 0
