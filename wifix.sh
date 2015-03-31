#!/bin/bash
#Short script to fix my WiFi issue.
#I did not make this.
#Source: http://www.backtrack-linux.org/forums/archive/index.php/t-47352.html

echo Remove RTL8187 Module
rmmod rtl8187
rfkill block all
rfkill unblock all
echo Add RTL8187 Module
modprobe rtl8187
rfkill unblock all
echo Bring wlan0 Up
ifconfig wlan0 up
