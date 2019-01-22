---
layout: default
title: "Facter release notes"
---

These are the new features, resolved issues, and deprecations in this version of Facter. 


## Facter 3.11.7

Released 15 January 2019

This is a bug-fix release that shipped with Puppet Platform 5.5.10

### Bug fixes

- Facter now correctly returns the path to system32 on 64-bit systems when a user has manually created the "sysnative" folder. [FACT-1900](https://tickets.puppetlabs.com/browse/FACT-1900)

## Facter 3.11.6

Released 1 November 2018

This is a bug-fix release that shipped with Puppet Platform 5.5.8

### Bug fixes

- Previously, if you had multiple custom versions of a built-in fact, and only those with a weight of 0 could resolve, Facter used those zero-weighted values. Now, if only zero-weighted custom facts resolve, Facter uses built-in fact values instead. ([FACT-1873](https://tickets.puppetlabs.com/browse/FACT-1873))

## Facter 3.11.5

Released 23 October 2018

This is a bug-fix release that shipped with Puppet Platform 5.5.7.

### Bug fixes

- Facter now correctly distinguishes between Windows Server 2016 and Windows Server 2019. ([FACT-1889](https://tickets.puppetlabs.com/browse/FACT-1889))

## Facter 3.11.4

Released 21 August 2018

This is a bug-fix release that shipped with Puppet Platform 5.5.6.

### Bug fixes

- Facter now indicates if SELinux is enabled on the system by also checking for the existence of the `/etc/selinux/config` file in addition to checking for the presence of the SELinux file system. ([FACT-1477](https://tickets.puppetlabs.com/browse/FACT-1477))

- Facter returned the wrong IPv6 information when IPV6 stack was disabled. Now,Facter correctly validates the IP command's output for the IPv6 family. If the IP command's output is invalid (for example, if it contains IPv4 info), then Facter ignores it. ([FACT-1475](https://tickets.puppetlabs.com/browse/FACT-1475))

- Facter failed on Solaris 11.3 patch 29.0.4.0 native zone. Now, Facter does not try to read kstat entries that it does not need to process. This avoids potential permissions issues when run in a zone or as non-root on Solaris. ([FACT-1832](https://tickets.puppetlabs.com/browse/FACT-1832))

- Facter has been updated to correctly read the format of `/etc/system-release` under Amazon Linux 2. This corrects the operating system release fact, which previously fell back to the kernel version. ([FACT-1865](https://tickets.puppetlabs.com/browse/FACT-1865))

- The `os.architecture` fact is now determined from the `processors.models[0]` fact. This addresses a problem where Puppet agent wasn't working with dynamic CPU allocations on AIX. ([FACT-1550](https://tickets.puppetlabs.com/browse/FACT-1550)) 

- The `memory` fact was occasionally failing on AIX. This has been fixed. ([FACT-1821](https://tickets.puppetlabs.com/browse/FACT-1821))


## Facter 3.11.3

Released July 17, 2018.

This is a bug-fix release that shipped with Puppet Platform 5.5.4.

-   [All issues resolved in Facter 3.11.3](https://tickets.puppetlabs.com/issues/?jql=fixVersion+%3D+%27FACT+3.11.3%27)

### Bug fixes

-   Facter 3.11.3 correctly reads the format of `/etc/system-release` and reports the `os release` fact on Amazon Linux 2. Previous versions of Facter instead fell back to the kernel version. ([FACT-1865](https://tickets.puppetlabs.com/browse/FACT-1865))

-   Facter 3.11.3 no longer tries to read `kstat` entries that it does not need to process. This avoids potential permissions issues when run in a zone or as non-root on Solaris. ([FACT-1832](https://tickets.puppetlabs.com/browse/FACT-1832))

## Facter 3.11.2

Released June 7, 2018.

This is a bug-fix release that shipped with Puppet Platform 5.5.2 and 5.5.3.

-   [All issues resolved in Facter 3.11.2](https://tickets.puppetlabs.com/issues/?jql=fixVersion+%3D+%27FACT+3.11.2%27)

### Bug fix

-   When using the `systemd-networkd` DHCP client, previous versions of the Linux networking resolver didn't know how to collect DHCP lease information, since it expected `dhclient` to be installed. Systems relying entirely on `systemd-networkd` for DHCP management do not use `dhclient`.

    Facter 3.11.2 checks `systemd-networkd`'s DHCP leases directory (`/run/systemd/netif/leases`) in addition to `dhclient`'s lease files when attempting to identify DHCP servers.

## Facter 3.11.1

Released April 17, 2018.

This is a bug-fix and feature release that shipped with Puppet Platform 5.5.1.

-   [All issues resolved in Facter 3.11.1](https://tickets.puppetlabs.com/issues/?jql=fixVersion+%3D+%27FACT+3.11.1%27)

### Bug fixes

-   Facter 3.11.1 properly checks for errors when gathering disk information on AIX, and no longer warns or reports bogus results for devices assigned to special uses, such as databases. ([FACT-1597](https://tickets.puppetlabs.com/browse/FACT-1597))

-   Facter 3.11.1 reports MAC addresses on infiniband interfaces. ([FACT-1761](https://tickets.puppetlabs.com/browse/FACT-1761))

## Facter 3.11.0

Released March 20, 2018.

This is a bug-fix and feature release that shipped with Puppet Platform 5.5.0.

-   [All issues resolved in Facter 3.11.0](https://tickets.puppetlabs.com/issues/?jql=fixVersion+%3D+%27FACT+3.11.0%27)

### Bug fixes

-   The `uptime` fact for Windows now uses `GetTickCount64`, which is more reliable, minimizes clock skews, and offers better resolution than the previous method of computing using WMI BootUptime.

### New features

-   For each SSH key, Facter 3.11.0 includes the key type as part of its `ssh` fact.
