#! /bin/bash

if [ "$#" -eq "1" ]; then
	start=1
	end=$1
	step=1
elif [ "$#" -eq "2" ]; then
	start=$1
	end=$2
	step=1
elif [ "$#" -eq "3" ]; then
	start=$1
	end=$3
	step=$2
fi

array=();
if [ $start -gt $end ]; then
	for ((i=$start; i>=$end; i=i+$step)); do
		array+="$i ";
	done
else
	for ((i=$start; i<=$end; i=i+$step)); do
		array+="$i ";
	done
fi
echo $array;
