#!/bin/bash
#
##############
# WARNING
# This script is nasty hack with no error control.
# Best of luck!
#
# Designed for Centos 7. YMMV
#
# This script takes a list of installed packages and outputs
# that list to a file in /tmp.

set -eu

# Where are your tools?
rpm=/usr/bin/rpm

# Get the list of RPMs and write them to a file:
$rpm -qa --qf "%{NAME}\n" > /tmp/$HOSTNAME.packages

exit 0
