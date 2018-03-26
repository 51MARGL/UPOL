#!/bin/bash 

maxr=$2;
if [ -z $maxr ];then
	maxr=30;
fi

files=$(ls -rv $1*); #sort to prevent overriding files with mv
for file in $files; do 
	start=${file%.*};
	curnum=${file:$((${#start} + 1))};

	if [ -z $curnum ];then
		curnum=0;
		echo "created: $file.$curnum";
		mv "$file" "$file.$curnum";
	else
		if [ $(($curnum + 1)) -gt $maxr ]; then
			echo "deleted: $file";
			rm $file;
		else
			echo "incremented: ${file/.$curnum/.$(($curnum + 1))}";
			mv "$file" "${file/.$curnum/.$(($curnum + 1))}"; 
		fi
	fi
done
