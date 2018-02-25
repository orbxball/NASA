#!/bin/bash

if [ "$#" == '2' ]; then
  N=1
elif [ "$#" -lt '2' ]; then
  echo "There are not enough file arguments" && exit 0
else
  N=${3}
fi
#echo ${N}

cat ${1} |
  tr -cs '[:alnum:]' '[\n*]' |
    tr '[:upper:]' '[:lower:]' |
      sort |
        uniq -c |
          sort -k1nr -k2 |
            awk '$1>='${N}'{printf "%s\n", $2}' > out1

cat ${2} |
  tr -cs '[:alnum:]' '[\n*]' |
    tr '[:upper:]' '[:lower:]' |
      sort |
        uniq -c |
          sort -k1nr -k2 |
            awk '$1>='${N}'{printf "%s\n", $2}' > out2

while read line; do
  grep ${line} out2
done < out1

rm -f out1
rm -f out2