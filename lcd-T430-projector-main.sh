#!/bin/bash
#
# Turn on the external monitor at work:
/usr/bin/xrandr --output LVDS1 --primary ; /usr/bin/xrandr --output LVDS1 --mode 1600x900; /usr/bin/xrandr --output HDMI1 --mode 1280x720; /usr/bin/xrandr --output HDMI1 --left-of LVDS1
echo "External LCD at work has been turned on"
exit
