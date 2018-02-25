#!/bin/bash

x=$(cat $1 | sed -n $3'p')
y=$(cat $2 | sed -n $3'p')

#x=$(sed -n $3p < $1)
#y=$(sed -n $3p < $2)

#echo ${x} ${y}
if [ ${x} -gt ${y} ];then
	echo ${x}
else
	echo ${y}
fi
