#!/bin/bash
#
# Turn on the external monitor at work:
/usr/bin/xrandr --output LVDS1 --primary ; /usr/bin/xrandr --output LVDS1 --mode 1600x400; /usr/bin/xrandr --output VGA1 --mode 1280x960; /usr/bin/xrandr --output VGA1 --left-of LVDS1
echo "External LCD at work has been turned on"
exit
