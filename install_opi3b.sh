#!/bin/bash

##### Only for OrangePi 3B, Debian Bookworm, kernel 5.10.160
##### Please note this script is still under development
##### Внимание! Скрипт в стадии разработки и тестирования

##### This script should be installed AFTER KlipperScreen

SOURCES="https://github.com/evgs/fb_st7796s.git"

die() { echo "$*" 1>&2 ; exit 1; }

SCRIPT=$(realpath "$0")
SPATH=$(dirname "$SCRIPT")

echo "Check kernel architecture..."
UN=`uname -a`

echo $UN | grep 5.10.160-rockchip-rk356x || die "Unsupported kernel architecture"

#LHEADERS=linux-headers-next-sun50iw6
OVL=orangepi-add-overlay

die "STOP"
#sudo apt update
#sudo apt install git build-essential $LHEADERS || die "Error while installing packages"
sudo apt install git build-essential || die "Error while installing packages"

echo "Installing headers..."
sudo dpkg -i /opt/linux-headers-legacy-rockchip-rk356x_1.0.2_arm64.deb || die "Error while installing headers"

cd $SPATH


#echo "Fetching sources..."
#git clone $SOURCES || die "Error while fetching sources from github"
cd $SPATH/kernel_module/

echo "Building TFT driver..."
make  || die "Driver compiling fault"

echo "Installing kernel module..."
sudo make install
make clean
sudo depmod -A


cd $SPATH/ads7846x_module/

echo "Building Touchscreen driver..."
make  || die "Driver compiling fault"

echo "Installing kernel module..."
sudo make install
make clean
sudo depmod -A

echo "Appending modules to initramfs..."

grep -qxF 'ads7846x' /etc/initramfs-tools/modules || echo ads7846x | sudo tee /etc/initramfs-tools/modules
grep -qxF 'fb_st7796s' /etc/initramfs-tools/modules || echo fb_st7796s | sudo tee /etc/initramfs-tools/modules
sudo update-initramfs -u || die "Error updating initramfs"

echo "Installing overlay..."
sudo $OVL $SPATH/dts/rk3566-st7796.dts || die "Error installing overlay"

sudo systemctl stop KlipperScreen.service
sudo rm /etc/X11/xorg.conf.d/50-fbturbo.conf
sudo rm /etc/X11/xorg.conf.d/20* 
sudo rm /etc/X11/xorg.conf.d/51* 
sudo rm /etc/X11/xorg.conf.d/52* 
sudo apt remove xserver-xorg-video-fbturbo
sudo apt install xserver-xorg-video-fbdev

echo "Copying xorg.conf rules..."
sudo cp $SPATH/X11/xorg.conf.d/50* /etc/X11/xorg.conf.d
sudo cp $SPATH/X11/xorg.conf.d/51* /etc/X11/xorg.conf.d
sudo cp $SPATH/X11/Xwrapper.conf /etc/X11/

echo "Installing touchscreen watchdog..."
cd $SPATH/touchdog
source ./touchdog-install.sh

echo "Your need reboot your SBC to activate module"
