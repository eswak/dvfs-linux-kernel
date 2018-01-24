#!/bin/bash
# used for matplotlib 
export MPLBACKEND="agg"
cd /home/amkoyan/DVFS/deploy


# deploy shared ssh keys to remote server 
/home/amkoyan/.local/bin/pssh -h cluster.txt  -l root -I< deploySshKeys.sh

# dep /etc/hosts 
bash makeHosts.sh
# Send Data dir to remote hosts
bash syncData.sh

# Get and Install MPI
# compile,set up,prepare cluster
/home/amkoyan/.local/bin/pssh -h cluster.txt  -l root -t 0 -P -I< deployCluster.sh

# run os optimization 
/home/amkoyan/.local/bin/pssh -h cluster.txt  -l root -t 0 -P -I< perfOpt.sh
#/home/amkoyan/.local/bin/pssh -h cluster.txt  -l root -t 0 -P -I< deployWRF.sh

# Map host:freq
bash getHostnameFreq.sh > hostname-freq.txt
