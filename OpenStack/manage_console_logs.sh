#!/bin/bash
#
# In certain circumstances, KVM console logs in OpenStack can grow rapidly and
# easily fill your compute node disks. Run this script at a desirable interval
# to ensure that the logs are kept to a reasonable length.

set -eux
set -o pipefail

# Where are your tools?
FIND=/usr/bin/find
GREP=/bin/grep
TAIL=/usr/bin/tail

# Where are your console logs?
CONSOLE_LOG_PATH=/tmp/instances

# What size (in bytes) do you want to shrink the log file to?
LOG_SIZE=100000

# What is the maximum size in bytes of the console logs that you'll tolerate?
MAX_LOG_SIZE=1024000

# Get a list of directories that end with a UUID in the console log path:
LIST_INSTANCE_DIRS=($($FIND $CONSOLE_LOG_PATH/* -maxdepth 0 -type d -printf "%f\n" | $GREP -E "[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$"))

# for each console log that's over size, truncate it.
for i in "${LIST_INSTANCE_DIRS[@]}"; do
    # Get the actual size of the log file
    ACTUAL_SIZE=$(wc -c $CONSOLE_LOG_PATH/$i/console.log | cut -f 1 -d ' ')
    # If the log file is > the specified maximum, truncate it
    if [ "$ACTUAL_SIZE" -gt $MAX_LOG_SIZE ]; then
        echo "$i is $ACTUAL_SIZE, we're going to have to truncate this file."
        echo "$($TAIL -c $LOG_SIZE $CONSOLE_LOG_PATH/$i/console.log)" > "$CONSOLE_LOG_PATH/$i/console.log"
        echo "$i is now $ACTUAL_SIZE"
    else
        echo "%i is fine, we're leaving it alone."
    fi
done

exit 0
