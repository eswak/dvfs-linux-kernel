/*
 * linux/drivers/cpufreq/cpufreq_dvfs.c
 * kernel version : 4.10.0-28
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 */

#define DEBUG

#include <linux/cpufreq.h>
#include <linux/init.h>
#include <linux/module.h>
#include <linux/netdevice.h>

static __u64 print_net_stats(void){
	struct net_device *dev;
	struct rtnl_link_stats64 temp;
	struct rtnl_link_stats64 *net_stats;
	__u64 tr_bytes;

	//char* interface = "eth0";
	char* interface = "ens33";
	dev = dev_get_by_name(&init_net, interface);
	if (!dev) {
		printk(KERN_ERR "interface %s not found. Available interfaces :\n", interface);

		read_lock(&dev_base_lock);

		dev = first_net_device(&init_net);
		while (dev) {
			printk(KERN_ERR " - [%s]\n", dev->name);
			dev = next_net_device(dev);
		}
		read_unlock(&dev_base_lock);

		return 0;
	}

	net_stats = dev_get_stats(dev, &temp);
        tr_bytes = net_stats->tx_bytes + net_stats->rx_bytes;

        printk(KERN_INFO "network bytes : %llu", tr_bytes);
        return tr_bytes;
}

static void cpufreq_gov_dvfs_limits(struct cpufreq_policy *policy)
{
	pr_debug("setting to %u kHz\n", policy->max);
	__cpufreq_driver_target(policy, policy->max, CPUFREQ_RELATION_H);
}

static struct cpufreq_governor cpufreq_gov_dvfs = {
	.name		= "dvfs",
	.owner		= THIS_MODULE,
	.limits		= cpufreq_gov_dvfs_limits,
};

static int __init cpufreq_gov_dvfs_init(void)
{
	#ifdef DEBUG
	printk(KERN_INFO "dvfs: init\n");
	#endif

	print_net_stats();

	return cpufreq_register_governor(&cpufreq_gov_dvfs);
}

static void __exit cpufreq_gov_dvfs_exit(void)
{
	#ifdef DEBUG
	printk(KERN_INFO "dvfs: exit\n");
	#endif

	cpufreq_unregister_governor(&cpufreq_gov_dvfs);
}

#ifdef CONFIG_CPU_FREQ_DEFAULT_GOV_DVFS
struct cpufreq_governor *cpufreq_default_governor(void)
{
	return &cpufreq_gov_dvfs;
}
#endif
#ifndef CONFIG_CPU_FREQ_GOV_DVFS_MODULE
struct cpufreq_governor *cpufreq_fallback_governor(void)
{
	return &cpufreq_gov_dvfs;
}
#endif

MODULE_AUTHOR("Erwan Beauvois <erwan@allmyt.eu>");
MODULE_DESCRIPTION("CPUfreq policy governor 'dvfs'");
MODULE_LICENSE("GPL");

fs_initcall(cpufreq_gov_dvfs_init);
module_exit(cpufreq_gov_dvfs_exit);
