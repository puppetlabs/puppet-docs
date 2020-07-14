---
layout: default
title: "Facter release notes"
---

These are the new features, resolved issues, and deprecations in this version of Facter. 

> For Facter releases later than version 3.11.x, release notes are included in the corresponding Puppet documentation set. For the most recent Facter documentation, see the [Facter](https://puppet.com/docs/puppet/latest/facter.html) page.

## Facter 3.11.14

Released 14 July 2020 and shipped with Puppet Platform 5.5.21.

### Resolved issues

- **The `facter -p` command returns NUL character on stdout when called from nested Ruby on Windows.** This release fixes an issue where Facter executed a system command using back ticks when called from Ruby. [FACT-2682](https://tickets.puppetlabs.com/browse/FACT-2682)

## Facter 3.11.13

Released 30 April 2020 and shipped with Puppet Platform 5.5.20.

### New features

- This release moves `cached-custom-facts` to a new section in the`facter.conf` file, called `fact-groups`. [FACT-2544](https://tickets.puppetlabs.com/browse/FACT-2544)
- This release allows you to cache custom facts based on the `facter.conf` file. Depending on the `ttl` defined under `Facts.ttls`, custom facts defined in `facter.conf` under `Facts.cached-custom-facts` will be cached. [FACT-1575](https://tickets.puppetlabs.com/browse/FACT-1575)

### Resolved issues

- Previously, when the `oslevel -s` command was executed on AIX, redirects `stderr` to `/dev/null` were shown on `stderr` and the `kernel` fact broke. This is now fixed. [FACT-2545](https://tickets.puppetlabs.com/browse/FACT-2545)
- Previously, when os-specific facts were not resolved, Puppet logged a warning. This release lowers the severity of the logged messages to debug. [FACT-2489](https://tickets.puppetlabs.com/browse/FACT-2489)

## Facter 3.11.12

Released 10 March 2020 and shipped with Puppet Platform 5.5.19

### New features 

-  You can now cache external facts using external facts filename as cache group [FACT-2307](https://tickets.puppetlabs.com/browse/FACT-2307).
- New ssh fact on Windows (available when OpenSSH is present). [FACT-1934](https://tickets.puppetlabs.com/browse/FACT-1934)

### Resolved issues

- Facter no longer crashes if the user has a numeric hostname. [FACT-2346](https://tickets.puppetlabs.com/browse/FACT-2346)
- Facter correctly displays ssh host key fact, in case the host key file does not contain a comment. [FACT-1833](https://tickets.puppetlabs.com/browse/FACT-1833)
- The `facter --puppet` command no longer throws a deprecation warning. [FACT-2260](https://tickets.puppetlabs.com/browse/FACT-2260)

## Facter 3.11.11

Released 14 January 2020

### New features

- This release adds support for the `fips_enabled` fact on Windows. The check examines the contents of `HKEY_LOCAL_MACHINE/System/CurrentControlSet/Control/Lsa/FipsAlgorithmPolicy/Enabled`. If the returned value is 1, it means that FIPS mode is enabled. [FACT-2065](https://tickets.puppetlabs.com/browse/FACT-2065)

- Facter can now return the new `scope6` fact to display IPv6 address scope. [FACT-2016](https://tickets.puppetlabs.com/browse/FACT-2016)

- Facter command execution now accepts a Boolean parameter, `expand`. By default, Facter searches the command and expands it to absolute path. When `expand` is set to false, Facter verifies whether the command is a shell command and, if so, passes the command as is.[FACT-1824](https://tickets.puppetlabs.com/browse/FACT-1824)

### Resolved issues

- Facter incorrectly reported disabled CPU cores as physical CPU cores. Now, Facter correctly reports physical and logical CPUs and ignores disabled CPUs. [FACT-1824](https://tickets.puppetlabs.com/browse/FACT-1824)

- In previous releases, Facter did not report the `cloud` fact on Azure. This issue is now fixed. [FACT-2004](https://tickets.puppetlabs.com/browse/FACT-2004)

- In previous versions, Facter could not always determine the primary network interface on Solaris, so it sometimes failed to return any valid interface. This is now fixed. [FACT-2146](https://tickets.puppetlabs.com/browse/FACT-2146)

-In systems using Windows Remote Desktop Services (RDS),  Facter returned an incorrect operating system fact. This was due to a Windows API deprecation that caused issues in mixed 32- and 64-bit application environments, such as RDS. [FACT-2096](https://tickets.puppetlabs.com/browse/FACT-2096)

## Facter 3.11.10

Released 15 October 2019 with Puppet 5.5.17.

### Resolved issues

- Google Compute Engine's internal metadata service is deprecating the v1beta1 endpoint sometime before the end of 2019. To prepare for this, Facter now uses the v1 endpoint instead. [FACT-2018](https://tickets.puppetlabs.com/browse/FACT-2018)

- When Facter starts a mountpoint to get the size and available space, it automatically mounts type `autofs` mountpoints, which is not the intended behavior. Automounts are now skipped by Facter when resolving mountpoints. [FACT-1992](https://tickets.puppetlabs.com/browse/FACT-1992)


## Facter 3.11.9

Released 16 July 2019 with Puppet 5.5.16.

### New features

This release adds new facts for Windows 10/2016+ :

- `ReleaseID`: The 4 digit Windows build Version in the form `YYMM`
- `InstallationType`: Differentiates Server, Server Core, Client (Desktop): `Server|Server Core|Client`.
- `EditionID`: Server or Desktop Edition variant: `(ServerStandard|Professional|Enterprise)`.
- `ProductName`: Textual Product Name.

Exception: on Windows 10 1511-x86_64, `ReleaseID` is not displayed, as is not present in Windows registry. [FACT-1881](https://tickets.puppetlabs.com/browse/FACT-1881)

### Bug fixes

- This release fixes an issue with Facter gem installation errors, which occurred because Facter was pinned to Ruby 2.1.7. The pinned version is now 2.1. [FACT-1918](https://tickets.puppetlabs.com/browse/FACT-1918)
- Prior to this release, Facter returned warnings if `ip route show` output was not in a key-value format. However, this format does not apply to all configurations, and Facter no longer returns warnings about this. [FACT-1916](https://tickets.puppetlabs.com/browse/FACT-1916)
- Previously, the `mountpoint` fact showed only temporary file systems and physical mounts. Now Facter returns mount points for all mounts on the systems. [FACT-1910](https://tickets.puppetlabs.com/browse/FACT-1910)
- This release adds support for Virtuzzo Linux facts. [FACT-1888](https://tickets.puppetlabs.com/browse/FACT-1888)


`
## Facter 3.11.8

Released 16 April 2019

### Bug fixes

- Previously, Facter incorrectly reported operating system facts (such as `os.name` and `os.release`) on Ubuntu systems that did not have the `lsb_release` executable. Operating system facts are now resolved without relying on `lsb_release`. FACT-1899 

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
