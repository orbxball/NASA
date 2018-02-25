#!/usr/bin/env bash

parted /dev/sdb -s mklabel gpt
parted -a optimal /dev/sdb -s mkpart primary 0.0 2GiB
mkfs -t vfat -F 32 /dev/sdb1
parted -a optimal /dev/sdb mkpart primary $((2*1024))MiB 100%
parted /dev/sdb -s set 2 lvm on
pvcreate /dev/sdb2 /dev/sdc
vgcreate nasavg /dev/sdb2 /dev/sdc
lvcreate -L 3GiB -n home_student nasavg
mkfs -t ext4 /dev/nasavg/home_student
lvcreate -n home_ta -l 100%FREE nasavg
mkfs -t ext4 /dev/nasavg/home_ta
