#!/bin/bash
#This script prints the following: CPUmodel, used ram, total ram, % used ram,
#IP address and default gateway.

CPU=`cat /proc/cpuinfo | grep "model name" | awk -F: '{print $2}'`

memused=`free -m | grep "Mem" | awk '{print $3}'`
memtotal=`cat /proc/meminfo | grep "MemTotal" | awk -F: '{print $2/1024}'| awk '{print int($1+0.5)}'`
# | awk '{print int($1+0.5)}' is used to round numbers.
mempct=`free | grep "Mem" | awk '{print (($3/$2)*100)}'| awk '{print int($1+0.5)}'`

#IP=`ifconfig eth0 | grep "inet addr" | awk '{print $2}' | cut -d: -f2`
IP=`hostname -I`
DG=`route | grep "default" | awk '{print $2}'`

echo "Your CPU model is:$CPU"
echo -e "Your used memory is: \e[4m$memused MB\e[24m, this is \e[4m$mempct%\e[24m of your total memory: \e[4m$memtotal MB\e[24m"
echo -n "Your IP address is: $IP"; echo " Your Default Gateway is: $DG"







