#!/bin/bash
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
cd $DIR;
# used for matplotlib
export MPLBACKEND="agg"

# deploy shared ssh keys to remote server
pssh -h ./cluster.txt -l root -I < ./deploySshKeys.sh

# deploy /etc/hosts
bash makeHosts.sh

# Send Data dir to remote hosts
bash syncData.sh $DIR

# Get and Install MPI
# compile,set up,prepare cluster
pssh -h ./cluster.txt -l root -t 0 -P -I < ./deployCluster.sh

# run os optimization
pssh -h ./cluster.txt -l root -t 0 -P -I < ./perfOpt.sh
#pssh -h ./cluster.txt -l root -t 0 -P -I < ./deployWRF.sh

# Map host:freq
bash getHostnameFreq.sh > ./hostname-freq.txt
