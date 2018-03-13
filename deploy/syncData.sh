#!/bin/bash
root=$1
pip install googledrivedownloader
/home/$USER/.local/bin/pssh -h "$(pwd)/cluster.txt" -t 0 -l root "yum install rsync -y"

if [ ! -d "$root/src/Data/NPB" ]; then
	mkdir -p $root/src/Data
	python downloadGoogleDrive.py --id "1TpgZlmm2ByhsTNTrY4WHGwYWPZHYgt10" --path $root/src/Data
	tar -xzf "$root/src/Data/dataSrc.tar.gz" -C $root/src/Data 
fi

rm -f $root/src/Data/dataSrc.tar.gz

# Sent BINs and SRCs
cp -rf $root/src/deploy/sar.sh $root/src/Data/NPB/bin/
cp -rf $root/src/deploy/runMPI.sh $root/src/Data/NPB/bin/

# sync with frontend
pip install -user pssh

/home/$USER/.local/bin/prsync -ravz -h "$(pwd)/cluster.txt" -l root -t 0 $root/src/Data/NPB /tmp/
/home/$USER/.local/bin/prsync -ravz -h "$(pwd)/cluster.txt" -l root -t 0 $root/src/Data/intelProfiler/ /opt