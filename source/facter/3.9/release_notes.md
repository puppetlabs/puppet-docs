---
layout: default
title: "Facter release notes"
---

This page documents the history of the Facter 3.9 series.

## Facter 3.9.6

Released April 17, 2018.

This is a bug-fix release that shipped with Puppet Platform 5.3.6.

-   [All issues resolved in Facter 3.9.6](https://tickets.puppetlabs.com/issues/?jql=fixVersion+%3D+%27FACT+3.9.6%27)

### Bug fixes

-   The `uptime` fact for Windows now uses `GetTickCount64`, which is more reliable, minimizes clock skews, and offers better resolution than the previous method of computing using WMI BootUptime. ([FACT-1504](https://tickets.puppetlabs.com/browse/FACT-1504))

-   Facter 3.9.6 properly checks for errors when gathering disk information on AIX, and no longer warns or reports bogus results for devices assigned to special uses, such as databases. ([FACT-1597](https://tickets.puppetlabs.com/browse/FACT-1597))

-   Facter 3.9.6 reports MAC addresses on infiniband interfaces. ([FACT-1761](https://tickets.puppetlabs.com/browse/FACT-1761))

## Facter 3.9.5

Released February 14, 2018.

This is a bug-fix release that shipped with Puppet Platform 5.3.5.

-   [All issues resolved in Facter 3.9.5](https://tickets.puppetlabs.com/issues/?jql=fixVersion+%3D+%27FACT+3.9.5%27)

### Bug fixes

-   Facter 3.9.5 updates its virtualization resolvers to recognize the SMBIOS data reported by Amazon's newer kvm-based hypervisor, which is used with c5 instances. Facter now reports the hypervisor as `kvm` for these cases, allowing c5 instances to be detected as virtual and filling the `ec2_metadata` fact.

## Facter 3.9.4

Released February 5, 2018.

This is a bug-fix release that shipped with Puppet Platform 5.3.4.

-   [All issues resolved in Facter 3.9.4](https://tickets.puppetlabs.com/issues/?jql=fixVersion+%3D+%27FACT+3.9.4%27)

### Bug fixes

-   Facter correctly reports the `is_virtual` and `virtual` facts on FreeBSD Proxmox virtual machines.

-   Facter no longer attempts to check the `dmidecode` fact in Linux systems running on POWER architectures.

-   Facter can interpret YAML or JSON output from external facts written in Powershell as structured facts.

## Facter 3.9.3

Released November 6, 2017.

This is a bug-fix release that shipped with Puppet Platform 5.3.3.

-   [All issues resolved in Facter 3.9.3](https://tickets.puppetlabs.com/issues/?jql=fixVersion+%3D+%27FACT+3.9.3%27)

### Bug fixes

Facter 3.9.3 resolves issues on Power8 architectures and with custom fact evaluation.

-   On Power8 architectures, previous versions of Facter reported inaccurate counts of logical and physical processors in the `processors` fact. Facter 3.9.3 resolves the issue by using the `/sys/devices/system/cpu` directory to compute only the physical CPU count, and computes the logical CPU count by incrementing the number of processor entries in `/proc/cpuinfo`.

    Also, previous versions of Facter used the wrong fields of `/proc/cpu/info` on Power8 architectures when determining the CPU model and clock speed. Facter 3.9.3 correctly uses the `cpu` and `clock` fields when populating relevant facts.

-   Since Facter 3.6, Facter evaluated custom facts from Puppet twice. Facter 3.9.3 resolves this issue by evaluating them only once, which significantly reduces the time required to evaluate facts.

## Facter 3.9.2

Released October 2, 2017.

This is a bug-fix release of Facter and libwhereami that addresses potential fatal errors in the new `hypervisors` fact. Facter 3.9.1 was not publicly released.

-   [All issues resolved in Facter 3.9.2](https://tickets.puppetlabs.com/issues/?jql=fixVersion+%3D+%27FACT+3.9.2%27)
-   [All issues resolved in libwhereami 0.1.2](https://tickets.puppetlabs.com/issues/?jql=fixVersion+%3D+%27whereami+0.1.2%27)

### Bug fix: Fix `hypervisors` fact resolution when run inside some Windows VMs

When running Facter 3.9.0 in virtualized Windows environments where Windows Management Instrumentation (WMI) values were only partially available, for instance on an OpenStack VM, Facter exited with a fatal `unhandled exception: unable to get from empty array of objects` error. Facter 3.9.2 resolves this issue.

-   [FACT-1749](https://tickets.puppetlabs.com/browse/FACT-1749)

### Bug fix: Prevent failed fact resolutions from stopping Facter

In previous versions of Facter, a failed fact resolution could halt Facter. Facter 3.9.2 resolves this issue by displaying failures as warnings and continuing to resolve other facts.

-   [FACT-1750](https://tickets.puppetlabs.com/browse/FACT-1750)

### Bug fix: Allow `hypervisors` fact to be blocked

The experimental `hypervisors` fact introduced in Facter 3.9.0 can cause Facter to fail in some virtualization environments. In Facter 3.9.2, you can block this fact in [`facter.conf`](./configuring_facter.html).

-   [FACT-1751](https://tickets.puppetlabs.com/browse/FACT-1751)

### Other bug fixes

-   [FACT-1765](https://tickets.puppetlabs.com/browse/FACT-1765), [PA-1466](https://tickets.puppetlabs.com/browse/PA-1466): Don't report warnings about a missing dmidecode component on Power8 systems, which don't use dmidecode.

## Facter 3.9.0

Released September 13, 2017.

This is a feature and bug-fix release of Facter.

-   [All issues resolved in Facter 3.9.0](https://tickets.puppetlabs.com/issues/?jql=fixVersion%20%3D%20%27FACT%203.9.0%27)

### Known issues

-   [FACT-1749](https://tickets.puppetlabs.com/browse/FACT-1749): The `hypervisors` fact introduced in Facter 3.9.0 can cause Facter to fail in virtualized Windows environments where Windows Management Instrumentation (WMI) values are only partially available, for instance on an OpenStack VM.

### New Features

-   [FACT-1742](https://tickets.puppetlabs.com/browse/FACT-1742): Facter 3.9.0 adds a new [`hypervisors` fact](./core_facts.html#hypervisors) for virtualization providers that uses [libwhereami](https://github.com/puppetlabs/libwhereami/), an optional new dependency enabled by default in Puppet Platform 5.2 builds of Facter.

    The new fact recognizes multiple hypervisors in nested virtualization environments, and includes metadata about each hypervisor where available. The `hypervisors` fact and libwhereami are the first steps toward improved virtualzation support in future releases of Facter. They also reduce its dependence on the external tool `virt-what`, which has a few detection bugs and requires root to run.

    This new feature should therefore also remediate discrepancies in Facter's output when run as root and as a non-root user under virtualized environments.

### Bug fixes

-   [FACT-1728](https://tickets.puppetlabs.com/browse/FACT-1728): Facter 3.9.0 provides an improved error message when `facter -p` is specified but Puppet cannot be loaded.
-   [FACT-1731](https://tickets.puppetlabs.com/browse/FACT-1731): Facter 3.9.0 correctly reports `virtual` and `is_virtual` facts when using FreeBSD's bhyve hypervisor.
