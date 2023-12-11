#!/bin/bash
while sleep 1 ; do 
  cat /sys/class/spi_master/spi0/spi0.0/hwmon/*/temp0 >/dev/null 
  DISPLAY=:0 xset -q | grep "Monitor is On" && echo 0 | sudo tee /sys/class/backlight/fb_st7796s/bl_power
  DISPLAY=:0 xset -q | grep "Monitor is in Suspend" && echo 1 | sudo tee /sys/class/backlight/fb_st7796s/bl_power  
done
