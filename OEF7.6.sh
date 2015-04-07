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

#7.6 blz 67
#_________________________________________
#1

#2
#!/bin/bash
#for (( i=1 ; i <=50 ; i++ ))
#do
#   echo $i
#done
#3
