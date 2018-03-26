#!/bin/bash 

function cfd(){
	result="";
	j=0;
	number=$1;
	while [ $number -gt 0 ]; do
		curr=$(($number % $2));
		if [[ $curr -ge 0 && $curr -le 9 ]]; then
			result+=$curr;
		else
			asc=$(($curr - 10 + 65));				#65 for 'A' ascii
			asc=$(printf \\$(printf '%03o' $asc)); 			#dec to ascii char
			result+=$asc;
		fi
		number=$(($number / $2));		
	done
	result=$(echo $result| tr '[:upper:]' '[:lower:]' | rev)
	echo $result;
}


function ctd(){
	result=0;
	j=0;
	for (( i=${#1}-1; i>=0; i-- )); do
  		current="${1:$i:1}";
		if [[ $current =~ ^[0-9]+$ ]]; then 
			result=$((result + ($current * ($2 ** $j))));			
		else 
			current=$(echo $current | tr '[:lower:]' '[:upper:]');
			asc=$(printf '%d' "'$current");				#ascii char to dec
			result=$((result + (($asc - 65 + 10) * ($2 ** $j))));	#65 for 'A' ascii
		fi
		j=$((j+1));
	done
	echo $result;
}

for (( ; ; )); do
   read command;
   $command;
done

