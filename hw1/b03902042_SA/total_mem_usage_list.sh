#!/usr/bin/env bash

function ALL_USERS(){
	ps aux | sed '1d' | awk '{print substr($1, 1, 3)}' | sort | uniq | sed -n '/^'[a-z]''[0-9]''[0-9]'/p'
}

function MEM_USAGE(){
	for user in $(ALL_USERS); do
		echo "$user $(./total_mem_usage.sh $user)"
	done
}

MEM_USAGE | sort -nrk2
