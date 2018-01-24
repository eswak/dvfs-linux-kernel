#!/bin/bash


wget -qO- 'url' | tar xf and rm -f 'data.tar'

/home/amkoyan/.local/bin/pssh -h "$(pwd)/cluster.txt"  -l root "yum install rsync -y"

# Sent BINs and SRCs
cp /home/amkoyan/DVFS/deploy/sar.sh /home/amkoyan/DVFS/Data/NPB/bin/
cp /home/amkoyan/DVFS/deploy/runMPI.sh /home/amkoyan/DVFS/Data/NPB/bin/

# sync with frontend
pip install --user pssh
/home/amkoyan/.local/bin/prsync -ravz -h "$(pwd)/cluster.txt" -l root -t 0 /home/amkoyan/DVFS/Data/ /tmp/
/home/amkoyan/.local/bin/prsync -ravz -h "$(pwd)/cluster.txt" -l root -t 0 /home/amkoyan/DVFS/Data/intelProfiler/ /opt

