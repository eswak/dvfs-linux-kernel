/*
 * linux/drivers/cpufreq/cpufreq_dvfs.c
 * kernel version : 4.10.0-28
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 */

#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

#include <linux/cpufreq.h>
#include <linux/init.h>
#include <linux/module.h>

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
	return cpufreq_register_governor(&cpufreq_gov_dvfs);
}

static void __exit cpufreq_gov_dvfs_exit(void)
{
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
