# Linux Kernel DVFS CPU Governor
## Setup your environment
1) Download VMWare Workstation Player 14
2) Download Ubuntu latest stable release (Ubuntu 16.04.3 LTS)
3) Install your VM with ubuntu
4) Log in, open a terminal, and run :
```shell
# should output your kernel version : 4.10.0-28-generic
uname -r

# install linux-source, linux-headers, and linux-image corresponding to your kernel version
sudo apt install linux-source-4.13.0
sudo apt install linux-headers-4.13.0-36-generic
sudo apt install linux-image-4.13.0-36-generic
sudo apt install python-pip
pip install pssh

# install utils that we'll use to switch CPU governor
sudo apt install cpufrequtils
```
5) You're done !

## Build the project, and run it
The `Makefile` has a few tasks in it, that make it easier to run commands so don't have to type them everytime.
```shell
make build # compile the .c files & create the .ko (kernel object) patch file
```
```shell
make clean # clean all the compiled files (.o, etc...)o
```
```shell
make install # install the mod on your current VM (you need to build it first of course)
```
```shell
make remove # uninstall the mod
```
```shell
make log # show the kernel logs; any new log will be displayed in real time
```
## Run experiment

### Register an account on grid5000
https://www.grid5000.fr/mediawiki/index.php/Grid5000:Get_an_account

### Connect to grid5000
> Note : fore more informations on this part, you can also check [the Getting Started guide of grid5000](https://www.grid5000.fr/mediawiki/index.php/Getting_Started#Connecting_for_the_first_time)

1) add your ssh key (the one of which you provided the public key to grid5000)
```
# add in your ~/.bashrc
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
```

2) connect to the global access machine
```
# add in your ~/.bashrc
alias g5k='ssh username@access.grid5000.fr'
```
Then in your shell : `g5k`

### Reserve nodes
> Note : fore more informations on this part, you can also check [the Getting Started guide of grid5000](https://www.grid5000.fr/mediawiki/index.php/Getting_Started#Connecting_for_the_first_time)

Once connected to the global access machine, choose a cluster. For example, we'll use the `lyon` cluster.
```
ssh frontend.lyon
```
Once connected to the Lyon frontend, we'll reserve 2 nodes for 3 hours.
```
oarsub -I -l nodes=2,walltime=3 -t deploy
```
Copy the content of the $OAR_NODE_FILE file in `deploy/cluster.txt`.

### Install nodes
TODO: more details here
```
kadeploy3 -f $OAR_NODE_FILE -e debian9-x64-base -k
```
