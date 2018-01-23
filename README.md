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
sudo apt install linux-source-4.10.0
sudo apt install linux-headers-4.10.0-28-generic
sudo apt install linux-image-4.10.0-28-generic

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
make clean # clean all the compiled files (.o, etc...)
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



