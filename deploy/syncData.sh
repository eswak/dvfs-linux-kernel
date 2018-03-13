#!/bin/bash
root=$1
pip install googledrivedownloader
/home/$USER/.local/bin/pssh -h "$(pwd)/cluster.txt" -t 0 -l root "yum install rsync -y"

if [ ! -d "$root/Data/NPB" ]; then
	mkdir -p $root/Data
	python downloadGoogleDrive.py --id "1TpgZlmm2ByhsTNTrY4WHGwYWPZHYgt10" --path $root/Data
	tar -xzf "$root/Data/dataSrc.tar.gz" -C $root/Data 
fi

rm -f $root/Data/dataSrc.tar.gz

# Sent BINs and SRCs
cp -rf sar.sh $root/Data/NPB/bin/
cp -rf runMPI.sh $root/Data/NPB/bin/

# sync with frontend
pip install pssh --user

/home/$USER/.local/bin/prsync -ravz -h "$(pwd)/cluster.txt" -l root -t 0 $root/Data/NPB /tmp/
/home/$USER/.local/bin/prsync -ravz -h "$(pwd)/cluster.txt" -l root -t 0 $root/Data/intelProfiler/ /opt