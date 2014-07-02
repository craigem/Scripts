#!/bin/bash
#
# This script uses virsh and arp to determince the IP address of a VM

# Where are your tools?
virsh=/usr/bin/virsh
arp=/usr/sbin/arp
grep=/bin/grep
sed=/bin/sed

# Get the VM name as an argument:
VM_NAME=$1

# Ensure the defaul URI is set for your environment:
export LIBVIRT_DEFAULT_URI=qemu:///system

# Obtain the MAC address from libvirt:
MAC_ADDRESS=`$virsh dumpxml $VM_NAME | $grep "mac address" | $sed "s/.*'\(.*\)'.*/\1/g"`

# Use arp to find the IP address you're looking for via it's MAC address:
$arp -an | $grep $MAC_ADDRESS

exit 0
