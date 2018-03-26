#!/bin/bash 



function basename() {
	path=$1

	if [ -d $path ] && [ ${#path} -ne 1 ] && [ "${path:${#path} - 1}" == "/" ]; then
		path=${path%?}
	fi

	file=`echo $path |tr "/" "\n" |tail -n 1 |tr "\n" "/"`
	file=${file:0:-1}

	if [ "$file" == "" ]; then
		file="/"
	fi

	echo $file
}

function dirname() {
	file=$1

	if [ -d $file ] && [ ${#file} -ne 1 ]; then
		file=${file%?}
	fi
	dir=`echo $file |tr "/" "\n" |head -n -1 |tr "\n" "/"`

	if [ ${#dir} -gt 1 ]; then
		dir=${dir%?}
	fi

	if [ "$dir" == "" ]; then
		dir="."
	fi

	echo $dir
}

basename $1

dirname $1
