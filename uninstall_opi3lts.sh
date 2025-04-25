#!/bin/bash

die() { echo "$*" 1>&2 ; exit 1; }

SCRIPT=$(realpath "$0")
SPATH=$(dirname "$SCRIPT")

echo "Check kernel architecture..."
UN=`uname -a`

#armbian, https://www.armbian.com/orangepi3-lts/
echo "$UN" | grep sunxi64 && sbcEnv=armbianEnv.txt

#debian, https://github.com/silver-alx/sbc/releases
echo "$UN" | grep sun50iw6 && sbcEnv=orangepiEnv.txt

sudo rm /etc/X11/xorg.conf.d/50-fbdev.conf
sudo rm /etc/X11/xorg.conf.d/51* 
sudo rm /etc/X11/xorg.conf.d/52* 

sudo rm /boot/overlay-user/sun50i-h6-st7796s.dtbo

sudo sed -i -e 's/sun50i-h6-st7796s//' /boot/$sbcEnv


