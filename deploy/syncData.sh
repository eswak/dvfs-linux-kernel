#!/bin/bash
root=$1
/home/$USER/.local/bin/pssh -h "$(pwd)/cluster.txt" -t 0 -l root "yum install rsync -y"
# Sent BINs and SRCs
cp -rf $root/src/deploy/sar.sh $root/src/Data/NPB/bin/
cp -rf $root/src/deploy/runMPI.sh $root/src/Data/NPB/bin/

# sync with frontend
pip install -user pssh

/home/$USER/.local/bin/prsync -ravz -h "$(pwd)/cluster.txt" -l root -t 0 $root/src/Data/NPB /tmp/
/home/$USER/.local/bin/prsync -ravz -h "$(pwd)/cluster.txt" -l root -t 0 $root/src/Data/intelProfiler/ /opt