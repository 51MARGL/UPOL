#! /bin/bash

if [ "$#" -eq "1" ]; then
	start=0
	end=$1
elif [ "$#" -eq "2" ]; then
	start=$1
	end=$2
elif [ "$#" -eq "0" ]; then
	start=0
	end=100
fi

guessed=0;
echo "Think a number";
while [ $guessed -eq 0 ];
do
	guess=$((($start + $end) / 2));
	echo "Is it $guess ?"
	read answer
	if [ "$answer" = "y" ]; then
		echo "Fine.";
		guessed=1;
	else
		echo "Is number greater than $guess ?"
		read answer
		if [ "$answer" = "y" ]; then
			start=$guess;
		elif [ "$answer" = "n" ]; then
			end=$guess;
		else echo "WTF"
		fi
	fi
done
