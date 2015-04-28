#!/usr/bin/env python
'''
Error_Deleting

There are times when you may have issues deleting volumes from OpenStack
when there are issues with Cinder. The instance may be deleted but Cinder
may not delete the volume from either it's database or from object storage.

Normally you can correct this with --reset-state to available and then
re-issuing a cinder delete command.

This script is for when you have an awful lot of these and doing the above
manually makes you want to cry.
'''

# Use existing shell environment to obtain: $OS_TENANT_ID, $OS_USERNAME,
# $OS_PASSWORD, $OS_AUTH_URL, $OS_CACERT

# Obtain a list of volumes with status of "error_deleting".

# Set their status to available.
# Delete them
# Error handling?
