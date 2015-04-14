#!/bin/bash
#7.6 blz 67


#7
i=0
for file in *[$1,$2]
do
  let i++
done
echo "[$i] files were found ending with .txt"

exit
#6
i=1
while [ $i -le 3 ];
do
	 for N in {3..7};
                 do
                      echo "${N}"
                      sleep 0.1;
                 done
	 for B in {7..3};
		 do
		      echo "${B}"
		      sleep 0.1;
	       	 done                      
	 sleep 0.4;
         let i++;
	 echo =====;
done

exit
#5
while true;
  do
  echo "$1"
  echo "end with ctrl + C"
  sleep 3
done

exit
#4
while true;
do
echo "maarten"
echo "end with ctrl + C"
sleep 3
done

exit
#3
echo "number of files ending with .txt : "
ls -1 *.txt | wc -l
exit

#Andere mogelijkheid
 
let i=0
for file in *.txt
do
  let i++
done
echo "[$i] files were found ending with .txt"

#2
for (( i=1 ; i <=50 ; i++ ))
do
   echo $i
done

exit
#1
echo $4
echo $3
echo $2
echo $1


#_________________________________________
exit

MAX=$1 #parameter
i=0
while [[ $i < $MAX ]];
do 
	echo $1	
	let i++;
	sleep 1
	#let i="$i + 1"
	#i=$(($i + 1))
done
