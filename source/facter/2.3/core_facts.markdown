---
layout: default
title: "Facter 2.3: Core Facts"
---

## Summary

This is a list of all of the built-in facts that ship with Facter 2.3.x. Not all of them apply to every system, and your site may use many [custom facts](./custom_facts.html) delivered via Puppet modules. To see the actual available facts (including plugins) and their values on any of your systems, run `facter -p` at the command line. If you are using Puppet Enterprise, you can view all of the facts for any node on the node's page in the console.

Facts appear in Puppet as normal top-scope variables. This means you can access any fact for a node in your manifests with `$<fact name>`. (E.g. `$osfamily`, `$memorysize`, etc.)

* * *

## `architecture`


**Purpose**:

Return the CPU hardware architecture.

**Resolution**:

* On non-AIX IBM, OpenBSD, Linux, and Debian's kfreebsd, use the hardwaremodel fact.
* On AIX get the arch value from `lsattr -El proc0 -a type`.
* Gentoo and Debian call "x86_86" "amd64".
* Gentoo also calls "i386" "x86".


([↑ Back to top](#page-nav))

* * *

## `augeasversion`


**Purpose**:

Report the version of the Augeas library.

**Resolution**:

Loads ruby-augeas and reports the value of `/augeas/version`, the version of the underlying Augeas library.

**Caveats**:

* The library version may not indicate the presence of certain lenses, depending on the system packages updated, nor the version of ruby-augeas which may affect support for the Puppet Augeas provider.
* Versions prior to 0.3.6 cannot be interrogated for their version.


([↑ Back to top](#page-nav))

* * *

## `blockdevice_<devicename>_size`


**Purpose**:

Return the size of a block device in bytes.

**Resolution**:

Parse the contents of `/sys/block/<device>/size` to receive the size (multiplying by 512 to correct for blocks-to-bytes).

**Caveats**:

Only supports Linux 2.6+ at this time, due to the reliance on sysfs.


([↑ Back to top](#page-nav))

* * *

## `blockdevice_<devicename>_vendor`


**Purpose**:

Return the vendor name of block devices attached to the system.

**Resolution**:

Parse the contents of `/sys/block/<device>/device/vendor` to retrieve the vendor for a device.

**Caveats**:

Only supports Linux 2.6+ at this time, due to the reliance on sysfs.


([↑ Back to top](#page-nav))

* * *

## `blockdevice_<devicename>_model`


**Purpose**:

Return the model name of block devices attached to the system.

**Resolution**:

Parse the contents of `/sys/block/<device>/device/model` to retrieve the model name/number for a device.

**Caveats**:

Only supports Linux 2.6+ at this time, due to the reliance on sysfs.


([↑ Back to top](#page-nav))

* * *

## `blockdevices`


**Purpose**:

Return a comma-separated list of block devices.

**Resolution**:

Retrieve the block devices that were identified and iterated over in the creation of the blockdevice_ facts.

**Caveats**:

Block devices must have been identified using sysfs information.


([↑ Back to top](#page-nav))

* * *

## `cfkey`


**Purpose**:

Return the public key(s) for CFengine.

**Resolution**:

Tries each file of standard `localhost.pub` and `cfkey.pub` locations, checks if they appear to be a public key, and then joins them all together.


([↑ Back to top](#page-nav))

* * *

## `dhcp_servers`


**Purpose**:

* Return the DHCP server addresses for all interfaces as a hash.
* If the interface that is the default gateway is DHCP assigned, there will also be a `"system"` entry in the hash.

**Resolution**:

Parses the output of `nmcli` to find the DHCP server for the interface if available.

**Caveats**:

Requires `nmcli` to be available and the interface must use network-manager.


([↑ Back to top](#page-nav))

* * *

## `domain`


**Purpose**:

Return the host's primary DNS domain name.

**Resolution**:

* On UNIX (excluding Darwin), first tries to use the hostname fact, which uses the `hostname` system command, and then parses the output of that.
* Failing that, it tries the `dnsdomainname` system command.
* Failing that, it uses `/etc/resolv.conf` and takes the domain from that, or as a final resort, the search from that.
* Otherwise returns `nil`.
* On Windows uses the win32ole gem and winmgmts to get the DNSDomain value from the Win32 networking stack.


([↑ Back to top](#page-nav))

* * *

## `ec2_<EC2 INSTANCE DATA>`


**Purpose**:

Return info retrieved in bulk from the EC2 API. The names of these facts should be self explanatory, and they are otherwise undocumented. The full list of these facts is: ec2_ami_id, ec2_ami_launch_index, ec2_ami_manifest_path, ec2_block_device_mapping_ami, ec2_block_device_mapping_ephemeral0, ec2_block_device_mapping_root, ec2_hostname, ec2_instance_id, ec2_instance_type, ec2_kernel_id, ec2_local_hostname, ec2_local_ipv4, ec2_placement_availability_zone, ec2_profile, ec2_public_hostname, ec2_public_ipv4, ec2_public_keys_0_openssh_key, ec2_reservation_id, and ec2_security_groups.

**Resolution**:

Directly queries the EC2 metadata endpoint.


([↑ Back to top](#page-nav))

* * *

## `facterversion`


**Purpose**:

Return the version of the facter module.

**Resolution**:

Uses the `Facter.version` method.


([↑ Back to top](#page-nav))

* * *

## `filesystems`


**Purpose**:

Provide an alphabetic list of usable file systems that can be used for block devices like hard drives, media cards, etc.

**Resolution**:

Checks `/proc/filesystems`.

**Caveats**:

Only supports Linux.


([↑ Back to top](#page-nav))

* * *

## `fqdn`


**Purpose**:

Return the fully-qualified domain name of the host.

**Resolution**:

Simply joins the hostname fact with the domain name fact.

**Caveats**:

No attempt is made to check that the two facts are accurate or that the two facts go together. At no point is there any DNS resolution made either.


([↑ Back to top](#page-nav))

* * *

## `gce`


**Purpose**:

Return metadata for Google compute engine.

**Resolution**:

Queries the HTTP endpoint and processes the resulting data.


([↑ Back to top](#page-nav))

* * *

## `gid`


**Purpose**:

Return the GID (group identifier) of the user running Puppet.


([↑ Back to top](#page-nav))

* * *

## `hardwareisa`


**Purpose**:

Returns hardware processor type.

**Resolution**:

* On Solaris, AIX, Linux and the BSDs simply uses the output of `uname -p`.
* On HP-UX, `uname -m` gives us the same information.

**Caveats**:

Some Linuxes return unknown to `uname -p` with relative ease.


([↑ Back to top](#page-nav))

* * *

## `hardwaremodel`


**Purpose**:

Returns the hardware model of the system.

**Resolution**:

* Uses purely `uname -m` on all platforms other than AIX and Windows.
* On AIX uses the parsed `modelname` output of `lsattr -El sys0 -a modelname`.
* On Windows uses the `host_cpu` pulled out of Ruby's config.


([↑ Back to top](#page-nav))

* * *

## `hostname`


**Purpose**:

Return the system's short hostname.

**Resolution**:

* On all systems but Darwin, parses the output of the `hostname` system command to everything before the first period.
* On Darwin, uses the system configuration util to get the LocalHostName variable.


([↑ Back to top](#page-nav))

* * *

## `id`


**Purpose**:

Return the currently running user ID.

**Resolution**:

* On all Unixes but Solaris, just returns the output from `whoami`.
* On Solaris, parses the output of the `id` command to grab the username, as Solaris doesn't have the `whoami` command.


([↑ Back to top](#page-nav))

* * *

## `interfaces`


**Purpose**:

Generates the following facts on supported platforms: `<interface>_ipaddress`, `<interface>_ipaddress6`, `<interface>_macaddress`, `<interface>_netmask`, and `<interface>_mtu`.


([↑ Back to top](#page-nav))

* * *

## `ipaddress`


**Purpose**:

Return the main IP address for a host.

**Resolution**:

* On the Unixes, does an ifconfig and returns the first non 127.0.0.0/8 subnetted IP it finds.
* On Windows, it attempts to use the socket library and resolve the machine's hostname via DNS.
* On LDAP based hosts it tries to use either the win32/resolv library to resolve the hostname to an IP address, or on Unix, it uses the resolv library.
* As a fallback for undefined systems, it tries to run the "host" command to resolve the machine's hostname using the system DNS.

**Caveats**:

* DNS resolution relies on working DNS infrastructure and resolvers on the host system.
* The ifconfig parsing purely takes the first IP address it finds without any checking this is a useful IP address.


([↑ Back to top](#page-nav))

* * *

## `ipaddress6`


**Purpose**:

Returns the "main" IPv6 IP address of a system.

**Resolution**:

OS-dependent code that parses the output of various networking tools and currently not very intelligent. Returns the first non-loopback and non-linklocal address found in the ouput unless a default route can be mapped to a routable interface. Guessing an interface is currently only possible with BSD-type systems; too many assumptions have to be made on other platforms to make this work with the current code. Most of this code is ported or modeled after the ipaddress fact for the sake of similar functionality and familiar mechanics.


([↑ Back to top](#page-nav))

* * *

## `iphostnumber`


**Purpose**:

On selected versions of Darwin, returns the host's IP address.

**Resolution**:

Uses either the scutil program to get the localhost name, or parses output of ifconfig for a MAC address.


([↑ Back to top](#page-nav))

* * *

## `kernel`


**Purpose**:

Return the operating system's name.

**Resolution**:

Uses Ruby's RbConfig to find host_os; if that is a Windows derivative, then returns `windows`, otherwise returns the output of `uname -s` verbatim.


([↑ Back to top](#page-nav))

* * *

## `kernelmajversion`


**Purpose**:

Return the operating system's release number's major value.

**Resolution**:

* Takes the first two elements of the kernel version as delimited by periods.
* Takes the first element of the kernel version on FreeBSD.


([↑ Back to top](#page-nav))

* * *

## `kernelrelease`


**Purpose**:

Return the operating system's release number.

**Resolution**:

* On AIX, returns the output from the `oslevel -s` system command.
* On Windows-based systems, uses the win32ole gem to query Windows Management for the `Win32_OperatingSystem` value.
* Otherwise uses the output of `uname -r` system command.


([↑ Back to top](#page-nav))

* * *

## `kernelversion`


**Purpose**:

Return the operating system's kernel version.

**Resolution**:

* On Solaris and SunOS based machines, returns the output of `uname -v`.
* Otherwise returns the kernerlversion fact up to the first `-`. This may be the entire kernelversion fact in many cases.


([↑ Back to top](#page-nav))

* * *

## `ldom`


**Purpose**:

Returns a list of dynamic facts that describe the attributes of a Solaris logical domain. The facts returned will include: domainrole, domainname, domainuuid, domaincontrol, and domainchassis.

**Resolution**:

Uses the output of `virtinfo -ap`.


([↑ Back to top](#page-nav))

* * *

## `lsbdistcodename`


**Purpose**:

Return Linux Standard Base information for the host.

**Resolution**:

Uses the lsbdistcodename key of the os structured fact, which itself uses the `lsb_release` system command.

**Caveats**:

* Only works on Linux (and the kfreebsd derivative) systems.
* Requires the `lsb_release` program, which may not be installed by default.
* Also is as only as accurate as that program outputs.


([↑ Back to top](#page-nav))

* * *

## `lsbdistdescription`


**Purpose**:

Return Linux Standard Base information for the host.

**Resolution**:

Uses the lsbdistdescription key of the os structured fact, which itself uses the `lsb_release` system command.

**Caveats**:

* Only works on Linux (and the kfreebsd derivative) systems.
* Requires the `lsb_release` program, which may not be installed by default.
* Also is as only as accurate as that program outputs.


([↑ Back to top](#page-nav))

* * *

## `lsbdistid`


**Purpose**:

Return Linux Standard Base information for the host.

**Resolution**:

Uses the lsbdistid key of the os structured fact, which itself uses the `lsb_release` system command.

**Caveats**:

* Only works on Linux (and the kfreebsd derivative) systems.
* Requires the `lsb_release` program, which may not be installed by default.
* Also is as only as accurate as that program outputs.


([↑ Back to top](#page-nav))

* * *

## `lsbdistrelease`


**Purpose**:

Return Linux Standard Base information for the host.

**Resolution**:

Uses the lsbdistrelease key of the os structured fact, which itself uses the `lsb_release` system command.

**Caveats**:

* Only works on Linux (and the kfreebsd derivative) systems.
* Requires the `lsb_release` program, which may not be installed by default.
* Also is as only as accurate as that program outputs.


([↑ Back to top](#page-nav))

* * *

## `lsbmajdistrelease`


**Purpose**:

Returns the major version of the operation system version as gleaned from the lsbdistrelease fact.

**Resolution**:

Uses the lsbmajdistrelease key of the os structured fact, which itself parses the lsbdistrelease fact for numbers followed by a period and returns those, or just the lsbdistrelease fact if none were found.


([↑ Back to top](#page-nav))

* * *

## `lsbminordistrelease`


**Purpose**:

Returns the minor version of the operation system version as gleaned from the lsbdistrelease fact.

**Resolution**:

* Parses the lsbdistrelease fact for x.y and returns y. If y is not present, the fact is not present.
* For both values '1.2.3' and '1.2' of lsbdistrelease, lsbminordistrelease would return '2'. For the value '1', no fact would be set for lsbminordistrelease.


([↑ Back to top](#page-nav))

* * *

## `lsbrelease`


**Purpose**:

Return Linux Standard Base information for the host.

**Resolution**:

Uses the lsbrelease key of the os structured fact, which itself uses the `lsb_release` system command.

**Caveats**:

* Only works on Linux (and the kfreebsd derivative) systems.
* Requires the `lsb_release` program, which may not be installed by default.
* Also is as only as accurate as that program outputs.


([↑ Back to top](#page-nav))

* * *

## `macaddress`


**Purpose**:

Returns the MAC address of the primary network interface.


([↑ Back to top](#page-nav))

* * *

## `macosx`


**Purpose**:

Returns a number of Mac specific facts, from system profiler and sw_vers.

**Resolution**:

Uses util/macosx.rb to do the fact reconnaissance, then outputs them preceded by `sp_`


([↑ Back to top](#page-nav))

* * *

## `manufacturer`


**Purpose**:

Return the hardware manufacturer information about the hardware.

**Resolution**:

* On OpenBSD, queries `sysctl` values, via a util class.
* On SunOS Sparc, uses `prtdiag` via a util class.
* On Windows, queries the system via a util class.
* Uses `util/manufacturer.rb` for fallback parsing.


([↑ Back to top](#page-nav))

* * *

## `memory`


**Purpose**:

Return information about memory and swap usage.

**Resolution**:

* On Linuxes, uses `Facter::Memory.meminfo_number` from `facter/util/memory.rb`
* On AIX, parses `swap -l` for swap values only.
* On OpenBSD, parses `swapctl -l` for swap values, `vmstat` via a module for free memory, and `sysctl hw.physmem` for maximum memory.
* On FreeBSD, parses `swapinfo -k` for swap values, and parses `sysctl` for maximum memory.
* On Solaris, uses `swap -l` for swap values, parsing `prtconf` for maximum memory, and again, the `vmstat` module for free memory.

**Caveats**:

Some BSD platforms aren't covered at all. AIX is missing memory values.


([↑ Back to top](#page-nav))

* * *

## `netmask`


**Purpose**:

Returns the netmask for the main interfaces.

**Resolution**:

Uses the `facter/util/netmask` library routines.


([↑ Back to top](#page-nav))

* * *

## `network`


**Purpose**:

Get IP, network, and netmask information for available network interfaces.

**Resolution**:

Uses `facter/util/ip` to enumerate interfaces and return their information.


([↑ Back to top](#page-nav))

* * *

## `operatingsystem`


**Purpose**:

Return the name of the operating system.

**Resolution**:

* Uses the name key of the os structured fact, which itself operates on the following conditions:
* If the kernel is a Linux kernel, check for the existence of a selection of files in `/etc/` to find the specific flavour.
* On SunOS based kernels, attempt to determine the flavour, otherwise return Solaris.
* On systems other than Linux, use the kernel fact's value.


([↑ Back to top](#page-nav))

* * *

## `operatingsystemmajrelease`


**Purpose**:

Returns the major release of the operating system.

**Resolution**:

* Uses the releasemajor key of the os structured fact, which itself splits down its operatingsystemrelease key at decimal point for osfamily RedHat derivatives and Debian.
* Uses operatingsystemrelease key to the first non decimal character for operatingsystem Solaris.
* This should be the same as lsbmajdistrelease, but on minimal systems there are too many dependencies to use LSB


([↑ Back to top](#page-nav))

* * *

## `operatingsystemrelease`


**Purpose**:

Returns the release of the operating system.

**Resolution**:

* Uses the release key of the os structured hash, which itself operates on the following conditions:
* On RedHat derivatives, returns their `/etc/<variant>-release` file.
* On Debian, returns `/etc/debian_version`.
* On Ubuntu, parses `/etc/lsb-release` for the release version.
* On Suse, derivatives, parses `/etc/SuSE-release` for a selection of version information.
* On Slackware, parses `/etc/slackware-version`.
* On Amazon Linux, returns the `lsbdistrelease` value.
* On Mageia, parses `/etc/mageia-release` for the release version.
* On all remaining systems, returns the kernelrelease fact's value.


([↑ Back to top](#page-nav))

* * *

## `os`


**Purpose**:

Return various facts related to the machine's operating system.

**Resolution**:

* For operatingsystem, if the kernel is a Linux kernel, checks for the existence of a selection of files in `/etc` to find the specific flavor.
* On SunOS-based kernels, attempts to determine the flavor, otherwise returns Solaris.
* On systems other than Linux, uses the kernel value.
* For operatingsystemrelease, on RedHat derivatives, returns their `/etc/<varient>-release` file.
* On Debian, returns `/etc/debian_version`.
* On Ubuntu, parses `/etc/lsb-release` for the release version
* On Suse and derivatives, parses `/etc/SuSE-release` for a selection of version information.
* On Slackware, parses `/etc/slackware-version`.
* On Amazon Linux, returns the lsbdistrelease fact's value.
* On Mageia, parses `/etc/mageia-release` for the release version.
* On all remaining systems, returns the kernelrelease fact's value.
* For the lsb facts, uses the `lsb_release` system command.

**Caveats**:

* Lsb facts only work on Linux (and the kfreebsd derivative) systems.
* Requires the `lsb_release` program, which may not be installed by default.
* It is only as accurate as the output of lsb_release.


([↑ Back to top](#page-nav))

* * *

## `osfamily`


**Purpose**:

Returns the operating system

**Resolution**:

Uses the family key of the os structured fact, which itself maps operating systems to operating system families, such as Linux distribution derivatives. Adds mappings from specific operating systems to kernels in the case that it is relevant.

**Caveats**:

This fact is completely reliant on the operatingsystem fact, and no heuristics are used.


([↑ Back to top](#page-nav))

* * *

## `partitions`


**Purpose**:

Return the details of the disk partitions.

**Resolution**:

Parses the contents of `/sys/block/<device>/size` to receive the size (multiplying by 512 to correct for blocks-to-bytes).

**Caveats**:

For Linux, only 2.6+ is supported at this time due to the reliance on sysfs.


([↑ Back to top](#page-nav))

* * *

## `path`


**Purpose**:

Returns the `$PATH` variable.

**Resolution**:

Gets `$PATH` from the environment.


([↑ Back to top](#page-nav))

* * *

## `physicalprocessorcount`


**Purpose**:

Return the number of physical processors.

**Resolution**:

Uses the physicalprocessorcount key of the processors structured fact, which itself attempts to use sysfs to get the physical IDs of the processors and falls back to `/proc/cpuinfo` and `physical id` if sysfs is not available.


([↑ Back to top](#page-nav))

* * *

## `processor`


**Purpose**:

Provide additional facts about the machine's CPUs.

**Resolution**:

Utilizes values from the processors structured fact, which itself uses various methods to collect CPU information, with implementation dependent on the OS of the system in question.


([↑ Back to top](#page-nav))

* * *

## `processors`


**Purpose**:

Additional facts about the machine's CPU's, including processor lists, models, counts, and speeds.

**Resolution**:

* Each kernel uses its own implementation object to collect processor data. Linux and kFreeBSD parse `/proc/cpuinfo` for each processor. AIX parses the output of `lsdev` for its processor section.
* For Solaris, we parse the output of `kstat` for each processor. OpenBSD uses the sysctl variables 'hw.model' and 'hw.ncpu' for the CPU model and the CPU count respectively. Darwin uses the system profiler to collect the physical CPU count and speed.


([↑ Back to top](#page-nav))

* * *

## `ps`


**Purpose**:

Internal fact for what to use to list all processes. Used by the Service type in Puppet.

**Resolution**:

Assumes `ps -ef` for all operating systems other than BSD derivatives, where it uses `ps auxwww`.


([↑ Back to top](#page-nav))

* * *

## `puppetversion`


**Purpose**:

Return the version of Puppet installed.

**Resolution**:

Requires Puppet via Ruby and returns the value of its version constant.


([↑ Back to top](#page-nav))

* * *

## `rsc_<RACKSPACE INSTANCE DATA>`


**Purpose**:

Determine information about Rackspace cloud instances.

**Resolution**:

If this is a Rackspace Cloud instance, populates `rsc_` facts: `is_rsc`, `rsc_region`, and `rsc_instance_id`.

**Caveats**:

Depends on Xenstore.


([↑ Back to top](#page-nav))

* * *

## `rubyplatform`


**Purpose**:

Returns the platform of Ruby that Facter is running under.

**Resolution**:

Returns the value of the `RUBY_PLATFORM` constant.


([↑ Back to top](#page-nav))

* * *

## `rubysitedir`


**Purpose**:

Returns Ruby's site library directory.

**Resolution**:

Uses the RbConfig module.


([↑ Back to top](#page-nav))

* * *

## `rubyversion`


**Purpose**:

Returns the version of Ruby that Facter is running under.

**Resolution**:

Returns the value of the `RUBY_VERSION` constant.


([↑ Back to top](#page-nav))

* * *

## `selinux`


**Purpose**:

Determine whether SE Linux is enabled on the node.

**Resolution**:

Checks for the existence of the enforce file under the SE Linux mount point (e.g., `/selinux/enforce`) and returns true if `/proc/self/attr/current` does not contain the kernel.


([↑ Back to top](#page-nav))

* * *

## `selinux_config_mode`


**Purpose**:

Returns the configured SE Linux mode (e.g., `enforcing`, `permissive`, or `disabled`).

**Resolution**:

Parses the output of `sestatus_cmd` and returns the value of the line beginning with `Mode from config file:`.


([↑ Back to top](#page-nav))

* * *

## `selinux_config_policy`


**Purpose**:

Returns the configured SE Linux policy (e.g., `targeted`, `MLS`, or `minimum`).

**Resolution**:

Parses the output of `sestatus_cmd` and returns the value of the line beginning with `Policy from config file:`.


([↑ Back to top](#page-nav))

* * *

## `selinux_enforced`


**Purpose**:

Returns whether SE Linux is enabled (`true`) or not (`false`).

**Resolution**:

Returns the value found in the `enforce` file under the SE Linux mount point (e.g., `/selinux/enforce`).


([↑ Back to top](#page-nav))

* * *

## `selinux_policyversion`


**Purpose**:

Returns the current SE Linux policy version.

**Resolution**:

Reads the content of the `policyvers` file found under the SE Linux mount point, e.g. `/selinux/policyvers`.


([↑ Back to top](#page-nav))

* * *

## `ssh`


**Purpose**:

Gather facts related to SSH.


([↑ Back to top](#page-nav))

* * *

## `system32`


**Purpose**:

Returns the directory of the native system32 directory.


([↑ Back to top](#page-nav))

* * *

## `system_uptime`


**Purpose**:

Return the system uptime in a hash in the forms of seconds, hours, days, and a general, human readable uptime.

**Resolution**:

Does basic math on the get_uptime_seconds utility to calculate seconds, hours, and days.


([↑ Back to top](#page-nav))

* * *

## `timezone`


**Purpose**:

Return the machine's time zone.

**Resolution**:

Uses Ruby's Time module.


([↑ Back to top](#page-nav))

* * *

## `uniqueid`


**Purpose**:

Return the output of the `hostid` command.


([↑ Back to top](#page-nav))

* * *

## `uptime`


**Purpose**:

Return the system uptime in a human-readable format.

**Resolution**:

Uses the structured system_uptime fact, which does basic math on the number of seconds of uptime to return a count of days and hours of uptime.


([↑ Back to top](#page-nav))

* * *

## `uptime_days`


**Purpose**:

Return just the number of days of uptime.

**Resolution**:

Uses the "days" key of the system_uptime fact, which divides its own "hours" key by 24


([↑ Back to top](#page-nav))

* * *

## `uptime_hours`


**Purpose**:

Return just the number of hours of uptime.

**Resolution**:

Uses the "hours" key of the system_uptime fact, which divides its own 'seconds' key by 3600.


([↑ Back to top](#page-nav))

* * *

## `uptime_seconds`


**Purpose**:

Return just the number of seconds of uptime.

**Resolution**:

* Acquires the uptime in seconds via the 'seconds' key of the system_uptime fact, which uses the `facter/util/uptime.rb` module to try a variety of methods to acquire the uptime on Unix.
* On Windows, the module calculates the uptime by the `LastBootupTime` Windows management value.


([↑ Back to top](#page-nav))

* * *

## `virtual`


**Purpose**:

Determine if the system's hardware is physical or virtualized.

**Resolution**:

* Assumes physical unless proven otherwise.
* On Darwin, use the macosx util module to acquire the SPHardwareDataType and SPEthernetDataType, from which it is possible to determine if the host is a VMware, Parallels, or VirtualBox. This previously used SPDisplaysDataType, which was not reliable if running headless, and also caused lagging issues on actual Macs.
* On Linux, BSD, Solaris and HPUX: Much of the logic here is obscured behind `util/virtual.rb`, which you can consult directly for more detailed resolution information.
* The Xen tests in here rely on `/sys` and `/proc,` and check for the presence and contents of files in there.
* If after all the other tests it's still seen as physical, then it tries to parse the output of the `lspci`, `dmidecode`, and `prtdiag` and parses them for obvious signs of being under VMware, Parallels or VirtualBox.
* Finally, it checks for the existence of `vmware-vmx`, which would hint that it's VMware.

**Caveats**:

Many checks rely purely on existence of files.


([↑ Back to top](#page-nav))

* * *

## `is_virtual`


**Purpose**:

Return `true` or `false` depending on whether a machine is virtualized or not.

**Resolution**:

Hypervisors and the like may be detected as a virtual type, but are not actual virtual machines, or should not be treated as such. This determines if the host is actually virtualized.


([↑ Back to top](#page-nav))

* * *

## `vlans`


**Purpose**:

On Linux, return a list of all the VLANs on the system.

**Resolution**:

On Linux only, checks for and reads `/proc/net/vlan/config` and parses it.


([↑ Back to top](#page-nav))

* * *

## `xendomains`


**Purpose**:

Return the list of Xen domains on the Dom0.

**Resolution**:

On a Xen Dom0 host, return a list of Xen domains using the `util/xendomains` library.


([↑ Back to top](#page-nav))

* * *

## `zfs_version`


**Purpose**:

Return the version of zfs in use on the system.

**Resolution**:

Uses the output of `zfs upgrade -v`.


([↑ Back to top](#page-nav))

* * *

## `zonename`


**Purpose**:

Return the name of the Solaris zone.

**Resolution**:

Uses `zonename` to return the name of the Solaris zone.

**Caveats**:

No support for Solaris 9 and below, where zones are not available.


([↑ Back to top](#page-nav))

* * *

## `zones_<ZONE>`


**Purpose**:

Return the list of zones on the system and add one zones_ fact for each zone with its state e.g., `running`, `incomplete`, or `installed`.

**Resolution**:

Uses `usr/sbin/zoneadm list -cp` to get the list of zones in separate parsable lines with delimeter being `:` which is used to split the line string and get the zone details.

**Caveats**:

Only supported on Solaris 10 and up.


([↑ Back to top](#page-nav))

* * *

## `zpool_version`


**Purpose**:

Return the version number for the ZFS storage pool.

**Resolution**:

Uses `zpool upgrade -v` to return the ZFS storage pool version number.


([↑ Back to top](#page-nav))
