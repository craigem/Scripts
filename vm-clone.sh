#!/bin/bash
#
##############
# WARNING
# This script is nasty hack with no error control.
# Best of luck!
#
# Designed for Debian, YMMV.
#
# This script takes an exisitng VM on localhost
# shuts it down, 
# clones it to the newly named VM on localhost
# starts up the new VM
# prints out the IP addess of the newly running VM.


#set -eu

# Where are your tools?
virsh=/usr/bin/virsh
virtclone=/usr/bin/virt-clone
arp=/usr/sbin/arp
grep=/bin/grep
sed=/bin/sed

# Ensure the default URI is set for your environment:
export LIBVIRT_DEFAULT_URI=qemu:///system

# Set the names of the VMs
VM2CLONE=$1
VM2BUILD=$2

# Shutdown the existing VM
echo "Shutting down $VM2CLONE."
sudo $virsh shutdown $VM2CLONE

# Clone to the new VM:
echo "Cloning $VM2CLONE to $VM2BUILD."
sudo $virtclone -o $VM2CLONE -n $VM2BUILD -f /var/lib/libvirt/images/$VM2BUILD.qcow2

# Start the new VM
echo "Starting $VM2BUILD."
sudo virsh start $VM2BUILD

# Wait for the VM to complete booting before running the next section:
echo "Waiting 30 seconds for the VM for boot."
sleep 30

# Print out the IP of the new VM using virsh and arp to determine the IP address of the VM

# Obtain the MAC address from libvirt:
MAC_ADDRESS=`$virsh dumpxml $VM2BUILD | $grep "mac address" | $sed "s/.*'\(.*\)'.*/\1/g"`

# Use arp to find the IP address you're looking for via it's MAC address:
$arp -an | $grep $MAC_ADDRESS

exit 0
