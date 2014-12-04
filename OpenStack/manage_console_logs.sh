#!/bin/bash
#
# In certain circumstances, KVM console logs in OpenStack can grow rapidly and
# easily fill your compute node disks. Run this script at a desirable interval
# to ensure that the logs are kept to a reasonable length.

set -eux
set -o pipefail

# Where are your tools?
readonly FIND=/usr/bin/find
readonly GREP=/bin/grep
readonly TAIL=/usr/bin/tail
readonly FLOCK=/usr/bin/flock
readonly WC=/usr/bin/wc

# Set the global variables:
readonly SCRIPTNAME=$(basename "$0")
readonly LOCKFILE_DIR=/var/lock
readonly LOCK_FD=200

# The locking function using flock to ensure the script is not running twice:
lock() {
    local prefix=$1
    local fd=${2:-$LOCK_FD}
    local lock_file=$LOCKFILE_DIR/$prefix.lock

    # Create the lock file:
    eval "exec $fd>$lock_file"

    # Acquire the lock:
    $FLOCK -n $fd \
        && return 0 \
        || return 1
}

# This function checks each console log and truncates if required
manage_logs() {
    local console_log_path=/var/lib/nova/instances
    local log_size=100000
    local max_log_size=1024000
    local list_instance_dirs=($($FIND $console_log_path/* -maxdepth 0 -type d -printf "%f\n" | $GREP -E "[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$"))

    # for each console log that's over size, truncate it.
    for i in "${list_instance_dirs[@]}"; do
        local actual_size=$($WC -c $console_log_path/$i/console.log | cut -f 1 -d ' ')
        if [ "$actual_size" -gt $max_log_size ]; then
            echo "$i is $actual_size, we're going to have to truncate this file."
            echo "$($TAIL -c $log_size $console_log_path/$i/console.log)" > "$console_log_path/$i/console.log"
            echo "$i is now $actual_size"
        else
            echo "$i is fine, we're leaving it alone."
        fi
    done
}

myexit() {
    local error_str="$@"

    echo $error_str
    exit 1
}

main() {
    lock $SCRIPTNAME \
      || myexit "Only one instance of $SCRIPTNAME can run at one time."

    manage_logs
}

main
