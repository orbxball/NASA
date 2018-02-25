#!/bin/bash

x=1

while [ ${x} -le 100 ]
do
	if [ $(( ${x}%2 )) == 1 ];then
		echo "${x}" > "${x}"
	else
		echo "$(( ${x}*2 ))" > "${x}"
	fi
	x=$(( ${x}+1 ))
done
