#!/usr/bin/env bash

x=$1
x="^"${x}".*"

#echo ${x}
ps aux | grep ${x} | awk 'BEGIN{total=0} {total=total+$5} END{printf total"\n"}'
