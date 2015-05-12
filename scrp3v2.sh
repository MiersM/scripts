###
#!/bin/bash
#Script Opdracht 3
#Maarten Miers

CPU=`cat /proc/cpuinfo | grep "model name" | awk -F: '{print $2}'`

MEMUSED=`free -m | grep "Mem" | awk '{print $3}'`
MEMTOTAL=`cat /proc/meminfo | grep "MemTotal" | awk -F: '{print $2/1024}'| awk '{print int($1+0.5)}'`
MEMPCT=`free | grep "Mem" | awk '{print (($3/$2)*100)}'| awk '{print int($1+0.5)}'`

IP=`hostname -I`
DG=`route | grep "default" | awk '{print $2}'`

herhaalFct()
{
   echo "$1 says:"
   echo ""
   echo "Your hostname is: $(hostname)"
   echo "Your CPU model is:$CPU"
   echo -e "Your used memory is: \e[4m$MEMUSED MB\e[24m, this is \e[4m$MEMPCT%\e[24m of your total memory: \e[4m$MEMTOTAL MB\e[24m"
   echo -n "Your IP address is: $IP"; echo " Your Default Gateway is: $DG"
   echo ""
   sleep 0.7
}   

helpFct()
{
echo "-c zorgt er voor dat de naam die volgt, sowieso in hoofdletters wordt geplaatst"
echo "-<Y> zorgt er voor dat de naam die hierna volgt, Y keer in de lijst wordt toegevoegd (bvb "-4 Leen" zorgt er voor dat Leen 4 keer in de lijst komt). Y kan gaan van 1 tot 9..."
}

voegToeAanLijst()
{
	LIJST="$LIJST $1"
}

voegToeAanLijstX()
{
	for (( i=1; $i <= ${1:1}; i++ ))
		do 
                	voegToeAanLijst $2
                done
}
	
      until [ -z "$1" ]
	 do
	    case $1 in

		-c	)  shift; voegToeAanLijst ${1^^};;

		-[0-9]* ) voegToeAanLijstX $1 $2; shift;;

		-h	) helpFct
			  exit
			;;

	       	 *	) echo "Bad argument!, use the HELPfunction: -h"
			  exit
			;; 
	    esac
	   shift
	 done

while :;
do
	for NAAM in $LIJST ; 
	do
		herhaalFct $NAAM
	done
	
  	 echo ""
 	 echo "CTRL + C to quit" 
   	 echo "________________"
	 echo ""
done
