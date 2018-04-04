# Deploy the experiment to grid5000

let be $USER the variable that contain your grid5000 user and $FRONT the one that define with which frontend you are working with.

## Initialisation
1. run the pustToFront.sh script (located in /deploy). provide the option -u $USER and -f $FRONT. It will automatically copy the complete project to the grid05000 frontend you specified. The process can take some time depending on your connection speed.

2. Connect to your frontend and run a screen session to get an uninteruptable ssh session.
```
ssh $USER@access.grid5000.fr
ssh $FRONT
screen
```

## Prepare the experiment
3. reserve the node you need
	* __wattmeter='YES'__: Required to tell grid5000 that we need nodes where the power consumption can be probe.
	* __cluster='orion'__: We would like to perform the experiment on the orion cluster. (orion have fairly new intel cpu [lyon:hardware](https://www.grid5000.fr/mediawiki/index.php/Lyon:Hardware)
	To perform the experiment, cpu with dynamic frequency functionnality are needed. Choose your cluter carrefully (link above)
```
oarsub -p "cluster='orion' AND wattmeter='YES'" -I -l cluster=1/nodes=2,walltime=4:0:0 -t deploy
```

4. Deploy the linux image
	* "_ubuntu16.04-x64-min.env_" is in the _deploy_ directory
```
kadeploy3 -a ubuntu16.04-x64-min.env  -f $OAR_FILE_NODES -k
```


5. oarsub reserves the nodes and store the name of the choosen machine in the variable $OAR_FILE_NODES. It is important to copy the content of this variable into the _cluster.txt_ file in _deploy_ directory in order for the scripts to work. It is also required to export the local python bin path to use to very usefull command such as pssh
```
cd deploy/
cat $OAR_FILE_NODES | uniq > cluster.txt
export PATH=$PATH:~/.local/bin/
```

6. Compile the experiment benchmark software on all nodes by running the script _main.sh_,  :warning: the process is quite long and depends on the hardware you reserved. installation time for a i5-6200U $\approx 20 minutes$.
```
bash main.sh
```

7. Change the kernel to 4.10 for each nodes y running _postdeploy-smart-governor_ script
 :warning: This will reboot the nodes and the procedure can take sometime
```
bash postdeploy-smart-governor.sh
```

8) 
	8.1)
		bash postdeploy-smarth-governor.sh
		# After sucsessfull deployment run post deploy manualy on each node to change kernel to 4.10
	8.2)
		screen -d -m sh -c '/tmp/NPB/bin/sar.sh'
		# sysstat script removes afters restart, so ensure that is runing 
9) bash buildSmartGovernor.sh
	# run smart governor
	# make sure you are using right kernel folder, deployment script use "/lib/modules/4.10.0-20-generic/build"

10) mkdir data/;  python AutoExecution/main.py --nodes deploy/cluster.txt -s lyon -o data/
	#run experiment from Measurment/AutoExecution module
