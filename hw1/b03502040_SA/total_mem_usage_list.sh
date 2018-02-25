#!/usr/bin/env bash

function MEM_USAGE() {
	ps aux | awk '{print $1}' | 
		grep '^[[:lower:]][[:digit:]][[:digit:]].*' | sed 's/^\(...\).*/\1/g' | 
			sort | uniq
}

function MEM_LIST() {
	for line in $(MEM_USAGE);
	do
		echo "${line} $(./total_mem_usage.sh ${line})" 
	done
}

MEM_LIST | sort -rnk2

#rm -f out out2
