"""You have an external drive with Apple's TimeMachine backups on it. You would
like to recover all the photos from one particular backup.

This script
* Takes the following arguments:
  * $1 is the Drive location ie: usb0 or usb1
  * $2 is the username
  * $3 is the date you wish to recover from ie: 2014-04-19-131501
  * $4 is where you wish the output to go
* It will locate all the photos backed up on that date
* Then copy them to your preferred location"""

import os

# Environment
# Where are your tools?
# readonly SUDO=/usr/bin/sudo
# readonly FIND=/usr/bin/find
# readonly LS=/bin/ls
# readonly AWK=/usr/bin/awk

# What has the user given us?
# readonly DRIVE="/media/$1/Time Machine Backups"
# DRIVE = "/media/$1"
DRIVE = "/media/usb1"
# readonly USERNAME=$2
# readonly RECOVERY_DATE=$3
# readonly COPY_TO=$4

# Others


def start():
    """Run the bulk of the script"""
    print "Start finding the pictures"
    find_pictures()
    copy_pictures()
    check_pictures()


def find_pictures():
    """Locate Pictures folder and get it's number"""
    print "Find the pictures"
    # Make the first character of the user name upper-case to conform to the
    # default Mac names
    # local username=${USERNAME[@]^}
    # Find the path for the recovery date
    # local date_path="$($SUDO $FIND "$DRIVE" -name $RECOVERY_DATE)"
    """for media in os.listdir(DRIVE):
        if media.endswith(".jpg"):
            print media"""
    for root, dirs, files in os.walk("/media/usb1"):
        for media in dirs:
            if media.endswith("_8374224"):
                print os.path.join(root, media)
    # local pictures_path="$($SUDO $FIND "$date_path" -name Pictures)"
    # local pictures_number="$($LS -lah "$pictures_path" | $AWK '{print $2}')"
    # Use it's number from the second column to locate the real Pictures data
    # local real_pictures="$($SUDO $FIND "$DRIVE" -name dir_$pictures_number)"
    # local photos="$($SUDO $LS "$real_pictures" | grep -i .jpg)"
    # for i in "${photos}"; do
    #    echo "$i"
    #    PHOTO_ARRAY+=("$real_pictures"/"$i")
    # done
    # Copy any photos (JPEGs) from the root folder
    # Iterate through the files in the real picture folders


def copy_pictures():
    """Copy the pictures we've found"""
    print "Copy Pictures to $COPY_TO"
    # for i in "${PHOTO_ARRAY[@]}"; do
    #    $SUDO cp "$i" $COPY_TO/
    #    echo "$i"
    # done


def check_pictures():
    """Verify that the pictures were copied correctly."""
    print "Check Pictures"

# Start the script.
start()

# TO DO:
# Add error handling
