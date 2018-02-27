#!/usr/bin/env bash

# get the hostname from parameter 1 and split it using "."
IFS=.
HOSTNAME=($1)
NAMESERVER=$(cat /etc/resolv.conf | grep "^nameserver" | head -n1 | awk '{print $2}')

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

# query is a type A query
printf "\x00\x01" >> dig.tmp

# query is class IN (Internet address)
printf "\x00\x01" >> dig.tmp

# Fuck you the IFS
#IFS=' '
#echo "${NAMESERVER}"

# send the DNS query
cat dig.tmp - | ncat -u -i 1 "${NAMESERVER}" 53 2>/dev/null | hexdump -C

# if using nc instead of ncat
#cat dig.tmp | nc -q 1 -u 140.112.30.21 53 | hexdump -C

# remove the temp file
rm -f dig.tmp
