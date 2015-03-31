#!/bin/bash
#I did not make this script.
#src: https://forums.kali.org/archive/index.php/t-16171.html

currentMode=$(cat /proc/sys/vm/laptop_mode)

if [ $currentMode -eq 0 ]
 then
  echo "5" > /proc/sys/vm/laptop_mode
  echo "Laptop Mode Enabled"
 else
  echo "0" > /proc/sys/vm/laptop_mode
  echo "Laptop Mode Disabled"
fi
