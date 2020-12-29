#!/run/current-system/sw/bin/bash
#
# This script will allow you to play podcasts from gPodder on mpd

# Ser the socket to connect to
export MPD_HOST=~/.mpd/socket

mpc clear
mpc add "$@"
mpc play
