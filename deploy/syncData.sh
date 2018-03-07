#!/bin/bash
wget -qO- 'url' | tar xf and rm -f 'data.tar'

pssh -h "$(pwd)/cluster.txt"  -l root "yum install rsync -y"

# Sent BINs and SRCs
cp ./sar.sh ../Data/NPB/bin/
cp ./runMPI.sh ../Data/NPB/bin/

# sync with frontend
pip install --user pssh
prsync -ravz -h "$(pwd)/cluster.txt" -l root -t 0 ../Data/ /tmp/
prsync -ravz -h "$(pwd)/cluster.txt" -l root -t 0 ../Data/intelProfiler/ /opt
