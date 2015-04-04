#!/bin/bash
#Script Opdracht 2
#Maarten Miers
#Instructions: add 1 to N parameters before running the script.

CPU=`cat /proc/cpuinfo | grep "model name" | awk -F: '{print $2}'`

MEMUSED=`free -m | grep "Mem" | awk '{print $3}'`
MEMTOTAL=`cat /proc/meminfo | grep "MemTotal" | awk -F: '{print $2/1024}'| awk '{print int($1+0.5)}'`
# | awk '{print int($1+0.5)}' is used to round numbers. (See source)
MEMPCT=`free | grep "Mem" | awk '{print (($3/$2)*100)}'| awk '{print int($1+0.5)}'`

#IP=`hostname -I` #source: yannick
#DG=`route | grep "default" | awk '{print $2}'`

herhaalFct()
{
echo "Your hostname is: $(hostname)"
echo "Your CPU model is:$CPU"
echo -e "Your used memory is: \e[4m$MEMUSED MB\e[24m, this is \e[4m$MEMPCT%\e[24m of your total memory: \e[4m$MEMTOTAL MB\e[24m"
echo -n "Your IP address is: $IP"; echo " Your Default Gateway is: $DG"
}

while true;
   do	
	echo "================"
        echo "START SMALL LOOP"
        echo "================"
	echo ""
		for N in ${*}
		    do
			echo "${N} tells you that:"
			echo""
			herhaalFct;
			echo "CTRL + C to quit" 
			echo "________________"
			sleep 0.7
		    done
	echo "================"
	echo " END SMALL LOOP"
	echo "================"
	echo ""
   done



















