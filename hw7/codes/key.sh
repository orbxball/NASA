#!/bin/bash

getIP () {
grep $(virsh dumpxml ubuntu | grep 'mac address' | grep -o '..:..:..:..:..:..') <(arp -a) | grep -o '(.*)'  | sed -e 's/(//' -e 's/)//'
}

#ssh-keygen -t rsa ‐f ~/.ssh/id_rsa ‐q ‐P "" && 
#ssh-copy-id ubuntu@$(getIP) && ssh-add
echo $(getIP)
#ssh-keygen -t rsa -f ~/.ssh/id_rsa -q -P ""
#ssh-copy-id ubuntu@$(getIP) && ssh-add
