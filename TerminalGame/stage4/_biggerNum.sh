#!/bin/bash

cat -n $1 | awk '$1=='$3'{printf $2}' > out1

cat -n $2 | awk '$1=='$3'{printf $2}' > out2

x=$(cat out1)
y=$(cat out2)

#echo ${x} ${y}

if [ ${x} -gt ${y}  ];then
	echo ${x}
else
	echo ${y}
fi

#rm -f out1 out2
