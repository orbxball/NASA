#!/usr/bin/env bash

# get the hostname from parameter 1 and split it using "."
IFS=.
HOSTNAME=($1)

# transction ID(always 0 here), flags and number of questions(always 1 here)
printf "\x00\x00\x01\x00\x00\x01\x00\x00\x00\x00\x00\x00" > dig.tmp

# transform the hostname into DNS query format
for i in ${HOSTNAME[@]}; do
	LENGTH=$(printf $i | wc -c)
	LENGTH=$(printf %02d $LENGTH)
	printf "\x$LENGTH$i" >> dig.tmp
done

# end of this name
printf "\x00" >> dig.tmp


if [ $# -eq 2 ] && [ "$2" == "MX" ];then
	# query is a type MX query
	printf "\x00\x0F" >> dig.tmp
else
	# query is a type A query
	printf "\x00\x01" >> dig.tmp
fi

# query is class IN (Internet address)
printf "\x00\x01" >> dig.tmp

# send the DNS query
cat dig.tmp - | ncat -u -i 1 140.112.30.21 53 2>/dev/null | hexdump -C

# if using nc instead of ncat
#cat dig.tmp | nc -q 1 -u 140.112.30.21 53 | hexdump -C

# remove the temp file
rm -f dig.tmp
