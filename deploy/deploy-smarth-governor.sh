#!/bin/bash

apt-get update -y
apt-get install git vim wget build-essential cpufreqd cpufrequtils -y
kern_full="4.10.0-20-generic"
kern_short=`echo $kern_full |awk -F '-' '{print $1}'`
sudo apt install -y "linux-source-$kern_short" "linux-headers-$kern_full" "linux-image-$kern_full"
echo "CONFIG_MODULE_SIG_FORCE=y" >> /usr/src/linux-headers-4.10.0-20-generic/.config
grub-mkconfig -o /boot/grub/grub.cfg
reboot 

