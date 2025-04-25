#!/bin/bash

die() { echo "$*" 1>&2 ; exit 1; }

SCRIPT=$(realpath "$0")
SPATH=$(dirname "$SCRIPT")

echo "Check kernel architecture..."
UN=`uname -a`

echo $UN | grep 5.10.160-rockchip-rk356x || die "Unsupported kernel architecture"

#LHEADERS=linux-headers-next-sun50iw6
sbcEnv=orangepiEnv.txt

sudo rm /etc/X11/xorg.conf.d/50-fbdev.conf
sudo rm /etc/X11/xorg.conf.d/51* 
sudo rm /etc/X11/xorg.conf.d/52* 

sudo rm /boot/overlay-user/rk3566-st7796s.dtbo

sudo sed -i -e 's/rk3566-st7796s//' /boot/$sbcEnv


