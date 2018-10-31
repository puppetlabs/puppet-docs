---
layout: default
title: "Facter 2.4: Release Notes"
description: "Facter release notes for all 2.4 versions"
---

This page documents the history of the Facter 2.4 series. (Elsewhere: release notes for [Facter 2.3](../2.3/release_notes.html), [Facter 2.2](../2.2/release_notes.html), [Facter 2.1](../2.1/release_notes.html), and [Facter 2.0](../2.0/release_notes.html)).

## Facter 2.4.6

Released January 26, 2016.

Facter 2.4.6 reverts a change in Facter 2.4.5 that caused breaking behavior for users.

### Reverted: Use public IP address for the `ipaddress` fact

Many users were relying on Facter's existing behavior in Facter 2.x for returning IP addresses, so this change has been reverted. Users who want to ignore private IP addresses when reporting the `ipadress` fact can upgrade to Facter 3.x.

* [FACT-380](https://tickets.puppetlabs.com/browse/FACT-380)

## Facter 2.4.5

Released January 20, 2016.

Facter 2.4.5 is a bug fix release in the Facter 2.4 series.

### Bug fix: Use public IP address for the `ipaddress` fact

Previous versions of Facter 2 reported the IP address of the first interface in alphabetical order in the `ipaddress` fact, which wasn't always desirable as that interface might not have a public IP address. Facter 2.4.5 ignores private IP addresses when reporting the `ipaddress` fact.

* [FACT-380](https://tickets.puppetlabs.com/browse/FACT-380)

### Bug fixes: Miscellaneous

* [FACT-765: The `gid` fact is ill-constrained on Windows](https://tickets.puppetlabs.com/browse/FACT-765): Previous versions of Facter 2 would attempt to invoke `id.exe` if found on the system. Doing so would cause an error resolving the `gid` fact. Facter 2.4.5 and Facter 3 resolve this issue.
* [FACT-1286: `Facter::Util::Resolution.which()` returns directories, not only executable files](https://tickets.puppetlabs.com/browse/FACT-1286): Previous versions of Facter 2 could return a directory if one matches the request in the `PATH` environment variable before an executable. Facter 2.4.5 resolves this by only returning a matching executable.
* [FACT-959: Incorrect processor counts on Windows](https://tickets.puppetlabs.com/browse/FACT-959): Facter 2.4.3 and 2.4.4 could erroneously report the number of physical processors as the number of virtual processors. Facter 2.4.5 resolves this issue.
* [FACT-704: Docker support for virtual and is_virtual broken by systemd slices](https://tickets.puppetlabs.com/browse/FACT-704): Previous versions of Facter 2 couldn't accurately detect when running in a Docker container, because the virtual fact was broken due to `systemd` slices that changed the cgroup paths.  Facter 2.4.5 correctly detects when it is running in a Docker container when using `systemd` slices.

### Full list of issues

[See Jira for a full list of issues resolved in Facter 2.4.5.](https://tickets.puppetlabs.com/issues/?filter=17113)

## Facter 2.4.4

Released May 20, 2015

Facter 2.4.4 is a bug fix release in the Facter 2.4 series. It also deprecates the `--puppet` command line option, since it caused circular load dependencies. To run Facter in Puppet's context, you should use the `puppet facts` command instead.


* [FACT-96: Deprecate 'facter --puppet'](https://tickets.puppetlabs.com/browse/FACT-96)
* [FACT-628: facter returns incorrect value for `facter virtual` for Solaris Ldoms](https://tickets.puppetlabs.com/browse/FACT-628)
* [FACT-697: If NetworkManager is installed but not used facter throws a warning.](https://tickets.puppetlabs.com/browse/FACT-697)
* [FACT-975: On PPC64LE architecture, processors aren't detected](https://tickets.puppetlabs.com/browse/FACT-975)
* [FACT-963: Remove pre-suite environment setup for AIO](https://tickets.puppetlabs.com/browse/FACT-963)


## Facter 2.4.3

Released April 2, 2015

Facter 2.4.3 is an AIO support release in the Facter 2.4 series that also includes two improvements to performance, and multiple bug fixes.

### AIO External Facts Directory Change
Changed external facts directory from `/opt/puppetlabs/agent/facts.d` to `/opt/puppetlabs/facter/facts.d` on *nix. Windows is unchanged.

* [FACT-826: Prepend AIO external facts directory for root](https://tickets.puppetlabs.com/browse/FACT-826)

### Improvements to Performance and Speed

* Reduced calls to `ip link show` for performance. `Facter::Util:IP.get_interface_value` called `get_bonding_interface` for every possible value, which could have caused performance issues if many interfaces were being used.

* Improved the speed of `puppetversion` in standalone Facter. There is no notable difference when calling Facter while Puppet is already running. Previously, running Facter with `--timing` showed that `puppetversion` was by far the slowest fact. This was not true when executed by Puppet, but gave the impression that Puppet is slow.

### Bugs

* [FACT-893: selinux_config_policy returns "unknown" on Debian and RHEL7](https://tickets.puppetlabs.com/browse/FACT-893)

* [FACT-596: Fix to selinux_config_policy, always returned "unknown" on Debian and RHEL7.](https://tickets.puppetlabs.com/browse/FACT-596)

* [FACT-825: Default timeout for `prtdiag` in the 'virtual' fact is too low for large Solaris systems](https://tickets.puppetlabs.com/browse/FACT-825)

* [FACT-830: xendomains returning empty on debian hosts](https://tickets.puppetlabs.com/browse/FACT-830)

* [FACT-834: Only load ec2 rest once to avoid double loading warnings](https://tickets.puppetlabs.com/browse/FACT-834)

* [FACT-888: Facter does not properly detect KVM when CPU type is not qenu32/qumu64](https://tickets.puppetlabs.com/browse/FACT-888)

* [FACT-894: Prepend ~/.puppetlabs/opt/facter/facts.d to external search path for non-root](https://tickets.puppetlabs.com/browse/FACT-894)

* [FACT-805: use /etc/os-release on CoreOS](https://tickets.puppetlabs.com/browse/FACT-805)

### Full List of Issues

[See Jira for a full list of issues resolved in Facter 2.4.3.](https://tickets.puppetlabs.com/browse/FACT-596?jql=project%20%3D%20FACT%20AND%20fixVersion%20in%20%20(%22FACT%202.4.3%22%2C%20%22FACT%202.4.2%22)%20ORDER%20BY%20due%20ASC%2C%20priority%20DESC%2C%20created%20ASC)

## Facter 2.4.2

Facter 2.4.2 was not publicly released, and no packages were provided.

## Facter 2.4.1

Released February 10, 2015.

Facter 2.4.1 is a security fix release in the Facter 2.4 series. It also fixes one non-security bug.

### SECURITY FIX: Leaking EC2 IAM Tokens

If an EC2 instance had an IAM (Identity and Access Management) role assigned to it, Facter's output would include that node's temporary security credentials, which could be used to perform requests against the AWS APIs. (To use the credentials, an attacker would need to obtain Facter output for that node.)

Since these credentials aren't meant to leave the node they're installed on, Facter now filters them out when making facts from EC2 instance data.

These temporary credentials expire relatively quickly and are automatically replaced with new ones. Once they've expired, no further remediation should be needed.

* [FACT-800: facter returns sensitive information about EC2 IAM tokens](https://tickets.puppetlabs.com/browse/FACT-800)


### KVM Not Detected When Running Facter as Non-Root User

When Facter was run as a non-root user, the `virtual` fact wasn't properly detecting machines running under KVM, which could prevent evaluation of other facts (including EC2 data).

* [FACT-797: Virtual fact on Linux does not work](https://tickets.puppetlabs.com/browse/FACT-797)

### Full List of Issues

[See Jira for a full list of issues resolved in Facter 2.4.1.](https://tickets.puppetlabs.com/browse/FACT/fixforversion/12625/)


## Facter 2.4.0

Released January 22, 2015.

Facter 2.4.0 is a backward-compatible feature release in the Facter 2 series.

This release has several backend improvements to prepare for Puppet 4.0. It doesn't add any new facts, but does add a new key to the `partitions` fact and improves OS support for a few others.

### Preparation for Puppet 4

Puppet 4.0 is coming soon, and Facter needed some changes to keep up. The current plan is that Facter 2.4.0 will be fully compatible with Puppet 4.

The main change is to the filesystem layout: Puppet 4 will change the directories it uses for configuration and synced plugins, and Facter can now use those new directories (as well as the existing Puppet 3 directories). We also updated the `facter --puppet` feature to account for some removed code, and made it so Puppet 4 can show Facter's error and warning messages in its logs.

* [FACT-779: Facter --puppet fails silently with Puppet 4](https://tickets.puppetlabs.com/browse/FACT-779)
* [FACT-753: Update FS layout for Facter](https://tickets.puppetlabs.com/browse/FACT-753)
* [FACT-750: Add pluggable logging](https://tickets.puppetlabs.com/browse/FACT-750)

### Fact Changes or Improvements

The `partitions` fact now includes a `label` key for each partition. Like this:

    partitions:
      sda1:
        size: '1953523087'
        filesystem: ntfs
      sdb1:
        size: '2014'
        label: BIOS boot partition
      sdb2:
        uuid: e746c990-fb8d-4449-90ad-c517ccd859f6
        size: '204800'
        mount: /boot
        label: Linux filesystem
        filesystem: ext2

This release also improves the `ipaddress_<ID>`, `macaddress_<ID>`, `mtu_<ID>`, `netmask_<ID>`, and `network_<ID>` facts on AIX.

* [FACT-776: Display the FS label in the partitions fact](https://tickets.puppetlabs.com/browse/FACT-776)
* [FACT-770: AIX Network Interfaces Improvements](https://tickets.puppetlabs.com/browse/FACT-770)

### Fact Bugs

This release fixes several bugs with various facts.

* [FACT-755: some xen hosts are not marked as xen](https://tickets.puppetlabs.com/browse/FACT-755)
* [FACT-546: facter fails when on non standard nic](https://tickets.puppetlabs.com/browse/FACT-546)
* [FACT-658: facter doesn't parse gnu uptime output](https://tickets.puppetlabs.com/browse/FACT-658)
* [FACT-697: If NetworkManager is installed but not used facter throws a warning.](https://tickets.puppetlabs.com/browse/FACT-697)
* [FACT-715: LXC detection code raises errors on old OpenVZ](https://tickets.puppetlabs.com/browse/FACT-715)


### Improvements for External Tools

Sometimes, tools like Boxen want to load their own collection of external facts from their own directory, and they generally subclass `Facter::Util::DirectoryLoader` to do it. The Boxen folk also wanted to set a different weight for facts from that directory, but there wasn't a way to do that. Now there is, by passing an optional weight argument to that class's initializer.

* [FACT-766: Facter::Util::DirectoryLoader should have configurable weight](https://tickets.puppetlabs.com/browse/FACT-766)


### Full List of Issues

[See Jira for a full list of issues resolved in Facter 2.4.0.](https://tickets.puppetlabs.com/browse/FACT/fixforversion/12021/)
