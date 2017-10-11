ifneq ($(KERNELRELEASE),)
obj-m	:= src/cpufreq_dvfs.o
else
KDIR	?= /lib/modules/`uname -r`/build
PWD	:= $(shell pwd)
build:
	$(MAKE) -C $(KDIR) M=$(PWD)
clean:
	# clean root directory
	rm -Rf ./.tmp_versions
	rm -f ./*.o
	rm -f ./.*.o.cmd
	rm -f ./*.order
	rm -f ./*.symvers
	# clean source directory
	rm -f ./src/*.ko
	rm -f ./src/*.o
	rm -f ./src/*.mod.c
	rm -f ./src/.*.ko.cmd
	rm -f ./src/*.mod.o
	rm -f ./src/.*.o.cmd
insmod:
	sudo insmod src/cpufreq_dvfs.ko
rmmod:
	sudo rmmod cpufreq_dvfs

endif
