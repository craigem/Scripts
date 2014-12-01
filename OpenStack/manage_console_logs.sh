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
# Get a list of directories that end with a UUID in the console log path:
LIST_INSTANCE_DIRS=($($FIND $CONSOLE_LOG_PATH/* -maxdepth 0 -type d -printf "%f\n" | $GREP -E "[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$"))

# for each instance, truncate the console log.
for i in "${LIST_INSTANCE_DIRS[@]}"; do
    # Tail the last 1000 lines and overwrite the log file with the output
    echo "$($TAIL -n 1000 $CONSOLE_LOG_PATH/$i/console.log)" > "$CONSOLE_LOG_PATH/$i/console.log"
    # echo "$CONSOLE_LOG_PATH/$i"
    # echo "Hello"
done

exit 0
