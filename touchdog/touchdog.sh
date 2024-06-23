#!/bin/bash
if [ "$EUID" -ne 0 ]; then echo "Please run as root." >&2; exit 1; fi

while sleep 1 ; do 
  cat /sys/class/spi_master/spi0/spi0.0/hwmon/*/temp0 >/dev/null 
  DISPLAY=:0 xset -q | grep -q "Monitor is On" && echo 0 > /sys/class/backlight/fb_st7796s/bl_power
  DISPLAY=:0 xset -q | grep -q "Monitor is in Suspend" && echo 1 > /sys/class/backlight/fb_st7796s/bl_power  
done
