#!/bin/bash
#
# Turn on the external monitor at work:
/usr/bin/xrandr --output DP2 --primary ; /usr/bin/xrandr --output LVDS1 --mode 1600x400; /usr/bin/xrandr --output DP2 --mode 2560x1440; /usr/bin/xrandr --output DP2 --left-of LVDS1
echo "External LCD at work has been turned on"
exit
