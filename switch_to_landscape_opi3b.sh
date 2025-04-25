#!/bin/bash

##### Please note this script is still under development
##### Внимание! Скрипт в стадии разработки и тестирования
##### inspired by mo5 (https://t.me/Ogmins, https://telegra.ph/kliperscreen-04-08 )

##### This script should be installed AFTER install.sh

die() { echo "$*" 1>&2 ; exit 1; }

SCRIPT=$(realpath "$0")
SPATH=$(dirname "$SCRIPT")

echo "Check kernel architecture..."
UN=`uname -a`

echo $UN | grep 5.10.160-rockchip-rk356x || die "Unsupported kernel architecture"

OVL=orangepi-add-overlay

cd $SPATH

echo "Installing overlay..."
cp $SPATH/dts/rk3566-st7796s-landscape.dts /tmp/rk3566-st7796s.dts
sudo $OVL /tmp/rk3566-st7796s.dts || die "Error installing overlay"


echo "Copying xorg.conf rules..."
sudo systemctl stop KlipperScreen.service
sudo rm /etc/X11/xorg.conf.d/51*
sudo rm /etc/X11/xorg.conf.d/52*
sudo cp $SPATH/X11/xorg.conf.d/52* /etc/X11/xorg.conf.d

echo "Your need reboot your SBC to activate module"
