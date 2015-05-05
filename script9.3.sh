#!/bin/bash
#script opdracht 9.3, pg.: 85

helpFct(){
echo Use the parameter "-c" to output the studentname in UPPERCASe
echo
echo
}

if [ -z "$1" ]
	then
  		echo "You did not enter a parameter"
	else
	 until [ -z "$1" ]
	  do
 		case $1 in

		    -n ) shift; echo "WELc0me, $1" ;;	

		    -n[0-9]* )  echo "WelCome, ${1:2}";;#ABS 10.1		    			    
		    [0-9]* ) echo "I will not say welcome to the number: $1" 
			#shift
				;;

		    *[0-9]* ) echo "I will not say welcome to the number: $1" 
                        #shift
				;;	

		     -c ) shift; echo -n "welkom, " ; echo ${1^^};#shift
				;;

		     -h )
			helpFct
				;;	
           	     * )  #echo "welcome, $1"
                          echo "Bad argument!, use the HELPfunction: "-h""
			  #exit
                    		;;  	
         	esac		 
             shift
  	  done
fi
