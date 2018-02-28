#!/bin/bash

getIP () {
	grep $(virsh dumpxml ubuntu | grep 'mac address' | grep -o '..:..:..:..:..:..') <(arp -a) | grep -o '(.*)'  | sed -e 's/(//' -e 's/)//'
}

sudo virt-install \
--connect=qemu:///system \
--name ubuntu \
--vcpus=2 \
--ram=2048 \
--memballoon virtio \
--os-type=linux \
--network bridge=virbr0 \
--nographics \
--accelerate \
--noautoconsole --wait=-1 \
--location http://archive.ubuntu.com/ubuntu/dists/trusty-updates/main/installer-amd64/ \
--disk path=/var/lib/libvirt/images/ubuntu.img,size=5 \
--initrd-inject=/tmp/ks.cfg \
--extra-args="ks=file:/ks.cfg ksdevice=eth0 _ip=192.168.122.10 _netmask=255.255.255.0 console=tty1 console=ttyS0,115200n8 serial"

echo "~~~Installed~~~"

# Waiting the VM to be started automatically
sleep 30s
ssh-keygen -t rsa -f ~/.ssh/id_rsa -q -P ""
ssh-copy-id ubuntu@$(getIP) && ssh-add
