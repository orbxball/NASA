#!/bin/bash

x=0

while [ ${x} != "100" ]
do
	echo "hello" >> h
	x=$(( ${x}+1  ))
done
