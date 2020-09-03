---
layout: default
title: "Facter 2.0: Core Facts"
---

## Summary

This is a list of all of the built-in facts that ship with Facter 2.0.x. Not all of them apply to every system, and your site may use many [custom facts](./custom_facts.html) delivered via Puppet modules. To see the actual available facts (including plugins) and their values on any of your systems, run `facter -p` at the command line. If you are using Puppet Enterprise, you can view all of the facts for any node on the node's page in the console.

Facts appear in Puppet as normal top-scope variables. This means you can access any fact for a node in your manifests with `$<fact name>`. (E.g. `$osfamily`, `$memorysize`, etc.)

## `architecture`


Returns the CPU hardware architecture.

**Resolution:**

* On OpenBSD, Linux and Debian's kfreebsd, use the hardwaremodel fact.
* Gentoo and Debian call "x86_64" "amd64".
* Gentoo also calls "i386" "x86".

([↑ Back to top](#page-nav))


* * *

## `augeasversion`


Returns the version of the Augeas library.

**Resolution:**

Loads ruby-augeas and reports the value of `/augeas/version`, the version of
the underlying Augeas library.

**Caveats:**

The library version may not indicate the presence of certain lenses,
depending on the system packages updated, nor the version of ruby-augeas
which may affect support for the Puppet Augeas provider.
Versions prior to 0.3.6 cannot be interrogated for their version.

([↑ Back to top](#page-nav))

* * *

## `blockdevice_{devicename}_size`


Returns the size of a block device in bytes.

**Resolution:**

Parse the contents of `/sys/block/{device}/size` to receive the size (multiplying by 512 to correct for blocks-to-bytes).

**Caveats:**

Only supports Linux 2.6+ at this time, due to the reliance on sysfs.

([↑ Back to top](#page-nav))

* * *

## blockdevice_{devicename}_vendor


Returns the vendor name of block devices attached to the system.

**Resolution:**

Parse the contents of `/sys/block/{device}/device/vendor` to retrieve the vendor for a device.

**Caveats:**

Only supports Linux 2.6+ at this time, due to the reliance on sysfs.

([↑ Back to top](#page-nav))

* * *

## blockdevice_{devicename}_model


Returns the model name of block devices attached to the system.

**Resolution:**

Parse the contents of `/sys/block/{device}/device/model` to retrieve the model name/number for a device.

**Caveats:**

Only supports Linux 2.6+ at this time, due to the reliance on sysfs.

([↑ Back to top](#page-nav))

* * *

## blockdevices


Returns a comma-separated list of block devices.

**Resolution:**

Retrieve the block devices that were identified and iterated over in the creation of the blockdevice_ facts.

**Caveats:**

Block devices must have been identified using sysfs information

([↑ Back to top](#page-nav))


* * *

## `boardmanufacturer`


Returns the manufacturer of the machine's motherboard.

([↑ Back to top](#page-nav))

* * *

## `boardproductname`


Returns the model name of the machine's motherboard.

([↑ Back to top](#page-nav))

* * *

## `boardserialnumber`


Returns the serial number of the machine's motherboard.

([↑ Back to top](#page-nav))

* * *

## `cfkey`


Returns the public key(s) for CFengine.

**Resolution:**

Tries each file of standard localhost.pub & cfkey.pub locations,
checks if they appear to be a public key, and then join them all together.

([↑ Back to top](#page-nav))

* * *

## `domain`


Returns the host's primary DNS domain name.

**Resolution:**

* On UNIX (excluding Darwin), first try and use the hostname fact, which uses the hostname system command, and then parse the output of that.
* Failing that it tries the dnsdomainname system command.
* Failing that it uses /etc/resolv.conf and takes the domain from that, or as a final resort, the search from that.
* Otherwise returns nil.
* On Windows uses the win32ole gem and winmgmts to get the DNSDomain value from the Win32 networking stack.

([↑ Back to top](#page-nav))

* * *

## `ec2_{EC2 INSTANCE DATA}`


Returns info retrieved in bulk from the EC2 API. The names of these facts should be self explanatory, and they are otherwise undocumented. The full list of these facts is:

* `ec2_ami_id`
* `ec2_ami_launch_index`
* `ec2_ami_manifest_path`
* `ec2_block_device_mapping_ami`
* `ec2_block_device_mapping_ephemeral0`
* `ec2_block_device_mapping_root`
* `ec2_hostname`
* `ec2_instance_id`
* `ec2_instance_type`
* `ec2_kernel_id`
* `ec2_local_hostname`
* `ec2_local_ipv4`
* `ec2_placement_availability_zone`
* `ec2_profile`
* `ec2_public_hostname`
* `ec2_public_ipv4`
* `ec2_public_keys_0_openssh_key`
* `ec2_reservation_id`
* `ec2_security_groups`

([↑ Back to top](#page-nav))

* * *

## `ec2_userdata`

Undocumented.

([↑ Back to top](#page-nav))

* * *

## `facterversion`


Returns the version of the facter module.

**Resolution:**

Uses the version constant.

([↑ Back to top](#page-nav))

* * *

## `filesystems`


Provides an alphabetic list of file systems for use by block devices such as hard drives, media cards, etc.

**Resolution:**

Returns a comma-delimited list.

**Caveats:**

Linux only. FUSE will not be reported.

([↑ Back to top](#page-nav))

* * *

## `ldom`


Returns a list of dynamic facts that describe the attributes of a Solaris logical domain.

The facts returned will include:

- `DOMAINROLE`
- `DOMAINNAME`
- `DOMAINUUID`
- `DOMAINCONTROL`
- `DOMAINCHASSIS`

**Resolution:**

Uses the output of `virtinfo -ap`.

**Caveats:**

([↑ Back to top](#page-nav))

* * *

## `fqdn`


Returns the fully qualified domain name of the host.

**Resolution:**

Simply joins the hostname fact with the domain name fact.

**Caveats:**

No attempt is made to check that the two facts are accurate or that
the two facts go together. At no point is there any DNS resolution made
either.


([↑ Back to top](#page-nav))

* * *

## `gid`


Returns the group ID of the user running the puppet process.

**Resolution**

Uses the output of `gid -ng`.

([↑ Back to top](#page-nav))

* * *

## `hardwareisa`


Returns hardware processor type.

**Resolution:**

On Solaris, Linux and the BSDs simply uses the output of "uname -p".

**Caveats:**

Some linuxes return unknown to uname -p with relative ease.

([↑ Back to top](#page-nav))

* * *

## `hardwaremodel`


Returns the hardware model of the system.

**Resolution:**

* Uses purely "uname -m" on all platforms other than AIX and Windows.
* On AIX uses the parsed "modelname" output of "lsattr -El sys0 -a modelname".
* On Windows uses the 'host_cpu' pulled out of Ruby's config.

([↑ Back to top](#page-nav))

* * *

## `hostname`


Returns the system's short hostname.

**Resolution:**

* On all system bar Darwin, parses the output of the "hostname" system command to everything before the first period.
* On Darwin, uses the system configuration util to get the LocalHostName variable.

([↑ Back to top](#page-nav))

* * *

## `id`


Internal fact used to specify the program to return the currently running user id.

**Resolution:**

* On all Unixes bar Solaris, just returns "whoami".
* On Solaris, parses the output of the "id" command to grab the username, as Solaris doesn't have the whoami command.

([↑ Back to top](#page-nav))

* * *

## `interfaces`


Returns a list of the network interfaces on the machine. These interface names are also used to construct several additional facts.

([↑ Back to top](#page-nav))

* * *

## `ipaddress`


Returns the main IP address for a host.

**Resolution:**

* On the Unixes does an ifconfig, and returns the first non 127.0.0.0/8 subnetted IP it finds.
* On Windows, it attempts to use the socket library and resolve the machine's hostname via DNS.
* On LDAP based hosts it tries to use either the win32/resolv library to resolve the hostname to an IP address, or on Unix, it uses the resolv library.
* As a fall back for undefined systems, it tries to run the "host" command to resolve the machine's hostname using the system DNS.

**Caveats:**

* DNS resolution relies on working DNS infrastructure and resolvers on the host system.
* The ifconfig parsing purely takes the first IP address it finds without any checking this is a useful IP address.

([↑ Back to top](#page-nav))

* * *

## `ipaddress_{NETWORK INTERFACE}`


Returns the IP4 address for a specific network interface (from the list in the `interfaces` fact).

([↑ Back to top](#page-nav))

* * *

## `ipaddress6`


Returns the "main" IPv6 IP address of a system.

**Resolution:**

OS-dependent code that parses the output of various networking tools and currently not very intelligent. Returns the first non-loopback and non-linklocal address found in the ouput unless a default route can be mapped to a routeable interface. Guessing an interface is currently only possible with BSD type systems to many assumptions have to be made on other platforms to make this work with the current code. Most code ported or modeled after the ipaddress fact for the sake of similar functionality and familiar mechanics.

([↑ Back to top](#page-nav))

* * *

## `ipaddress6_{NETWORK INTERFACE}`


Returns the IP6 address for a specific network interface (from the list in the `interfaces` fact).

([↑ Back to top](#page-nav))

* * *

## `iphostnumber`


On selected versions of Darwin, returns the host's IP address.

**Resolution:**

Uses either the scutil program to get the localhost name, or parses output of ifconfig for a MAC address.

([↑ Back to top](#page-nav))

* * *

## `is_virtual`


Returns `true` or `false` if a machine is virtualized or not.

**Resolution:**

Hypervisors and the like may be detected as a virtual type, but are not actual virtual machines, or should not be treated as such. This determines if the host is actually virtualized.

([↑ Back to top](#page-nav))

* * *

## `kernel`


Returns the operating system's name.

**Resolution:**

Uses Ruby's rbconfig to find `host_os`, if that is a Windows derivative, the returns 'windows', otherwise returns "uname -s" verbatim.

([↑ Back to top](#page-nav))

* * *

## `kernelmajversion`


Returns the operating system's release number's major value.

**Resolution:**

Takes the first 2 elements of the kernel version as delimited by periods.

([↑ Back to top](#page-nav))

* * *

## `kernelrelease`


Returns the operating system's release number.

**Resolution:**

* On AIX returns the output from the "oslevel -s" system command.
* On Windows based systems, uses the win32ole gem to query Windows Management for the '`Win32_OperatingSystem`' value.
* Otherwise uses the output of "uname -r" system command.

([↑ Back to top](#page-nav))

* * *

## `kernelversion`


Returns the operating system's kernel version.

**Resolution:**

* On Solaris and SunOS based machines, returns the output of "uname -v".
* Otherwise returns the 'kernerlrelease' fact up to the first '-'. This may be the entire 'kernelrelease' fact in many cases.

([↑ Back to top](#page-nav))

* * *

## `lsbdistcodename`


Returns Linux Standard Base information for the host.

**Resolution:**

Uses the `lsb_release` system command.

**Caveats:**

Only works on Linux (and the kfreebsd derivative) systems.
Requires the `lsb_release` program, which may not be installed by default.
Also is as only as accurate as that program outputs.

([↑ Back to top](#page-nav))

* * *

## `lsbdistdescription`


Returns Linux Standard Base information for the host.

**Resolution:**

Uses the `lsb_release` system command.

**Caveats:**

Only works on Linux (and the kfreebsd derivative) systems.
Requires the `lsb_release` program, which may not be installed by default.
Also is as only as accurate as that program outputs.

([↑ Back to top](#page-nav))

* * *

## `lsbdistid`


Returns Linux Standard Base information for the host.

**Resolution:**

Uses the `lsb_release` system command.

**Caveats:**

Only works on Linux (and the kfreebsd derivative) systems.
Requires the `lsb_release` program, which may not be installed by default.
Also is as only as accurate as that program outputs.

([↑ Back to top](#page-nav))

* * *

## `lsbdistrelease`


Returns Linux Standard Base information for the host.

**Resolution:**

Uses the `lsb_release` system command.

**Caveats:**

Only works on Linux (and the kfreebsd derivative) systems. Requires the `lsb_release`
program, which may not be installed by default. Also is as only as accurate as that program outputs.

([↑ Back to top](#page-nav))

* * *

## `lsbmajdistrelease`


Returns the major version of the operation system version as gleaned from the lsbdistrelease fact.

**Resolution:**

Parses the lsbdistrelease fact for numbers followed by a period and returns those, or just the lsbdistrelease fact if none were found.

([↑ Back to top](#page-nav))


* * *

## `lsbrelease`


Returns Linux Standard Base information for the host.

**Resolution:**

Uses the `lsb_release` system command.

**Caveats:**

Only works on Linux (and the kfreebsd derivative) systems.
Requires the `lsb_release` program, which may not be installed by default.
Also is as only as accurate as that program outputs.

([↑ Back to top](#page-nav))

* * *

## `macaddress`


Returns the MAC address of the primary network interface.

([↑ Back to top](#page-nav))

* * *

## `macaddress_{NETWORK INTERFACE}`


Returns the MAC address for a specific network interface (from the list in the `interfaces` fact).

([↑ Back to top](#page-nav))

* * *

## `macosx_buildversion`


Returns the system's Mac OS X build version.

([↑ Back to top](#page-nav))

* * *

## `macosx_productname`


Returns the system's Mac OS X product name. Will almost always be "Mac OS X".

([↑ Back to top](#page-nav))

* * *

## `macosx_productversion`


Returns the system's full Mac OS X version number. (e.g. 10.7.4)

([↑ Back to top](#page-nav))

* * *

## `macosx_productversion_major`


Returns the system's major Mac OS X version number. (e.g. 10.7)

([↑ Back to top](#page-nav))

* * *

## `macosx_productversion_minor`


Returns the system's minor Mac OS X version number. (e.g. 4)

([↑ Back to top](#page-nav))

* * *

## `manufacturer`


Returns the hardware's manufacturer information.

**Resolution:**

* On OpenBSD, queries sysctl values, via a util class.
* On SunOS Sparc, uses prtdiag via a util class.
* On Windows, queries the system via a util class.
* Uses  `util/manufacturer.rb` for fallback parsing.

([↑ Back to top](#page-nav))

* * *

## `memoryfree`

Returns the amount of free memory on the system.

([↑ Back to top](#page-nav))

* * *

## `memorysize`

Returns the total amount of memory on the system.

([↑ Back to top](#page-nav))

* * *

## `netmask`


Returns the netmask for the main interfaces.

**Resolution:**

Uses the facter/util/netmask library routines.

([↑ Back to top](#page-nav))

* * *

## `netmask_{NETWORK INTERFACE}`

Returns the netmask for a specific network interface (from the list in the `interfaces` fact).

([↑ Back to top](#page-nav))

* * *

## `network_{NETWORK INTERFACE}`

Returns the network for a specific network interface (from the list in the `interfaces` fact).

([↑ Back to top](#page-nav))

* * *

## `operatingsystem`

Returns the name of the operating system.

**Resolution:**

* If the kernel is a Linux kernel, check for the existence of a selection of files in /etc/ to find the specific flavour.
* On SunOS based kernels, return Solaris.
* On systems other than Linux, use the kernel value.

([↑ Back to top](#page-nav))

* * *

## `operatingsystemmajrelease`

Returns the major release of the operating system.

**Resolution:**

Splits the version number from the `operatingsystemrelease` fact by `.` and returns the first element. Only available if `operatingsystem` returns `Amazon`, `Centos`, `CloudLinux`, `CumulusLinux`, `Debian`, `Fedora`, `OEL`, `OracleLinux`, `OVS`, `RedHat`, `Scientific`, or `SLC`.

([↑ Back to top](#page-nav))

* * *

## `operatingsystemrelease`

Returns the release of the operating system.

**Resolution:**

* On RedHat derivatives, returns their '`/etc/<variant>-release`' file.
* On Debian, returns '`/etc/debian_version`'.
* On Ubuntu, parses '/etc/issue' for the release version.
* On Suse, derivatives, parses '/etc/SuSE-release' for a selection of version information.
* On Slackware, parses '/etc/slackware-version'.
* On Amazon Linux, returns the 'lsbdistrelease' value.
* On all remaining systems, returns the 'kernelrelease' value.

([↑ Back to top](#page-nav))

* * *

## `osfamily`

Returns the operating system family.

**Resolution:**

Maps operating systems to operating system families, such as Linux distribution derivatives.
Adds mappings from specific operating systems to kernels in the case that it is relevant.

**Caveats:**

This fact is completely reliant on the operatingsystem fact, and no heuristics are used.


([↑ Back to top](#page-nav))

* * *

## `path`


Returns the $PATH variable.

**Resolution:**

Gets $PATH from the environment.

([↑ Back to top](#page-nav))

* * *

## `physicalprocessorcount`


Returns the number of physical processors.

**Resolution:**

Attempts to use sysfs to get the physical IDs of the processors. Falls
back to `/proc/cpuinfo` and "physical id" if sysfs is not available.

([↑ Back to top](#page-nav))

* * *

## `processor`


Additional Facts about the machine's CPUs. Only used on BSDs.

([↑ Back to top](#page-nav))

* * *

## `processor{NUMBER}`


One fact for each processor, with processor info.

**Resolution:**

* On Linux and kFreeBSD, parse `/proc/cpuinfo` for each processor.
* On AIX, parse the output of `lsdev` for its processor section.
* On Solaris, parse the output of `kstat` for each processor.
* On OpenBSD, use `uname -p` and the sysctl variable for `hw.ncpu` for CPU count.

([↑ Back to top](#page-nav))

* * *

## `processorcount`

Returns the number of processors in the machine.


([↑ Back to top](#page-nav))

* * *

## `productname`


Returns the model identifier of the machine.

([↑ Back to top](#page-nav))

* * *

## `ps`

Internal fact for what to use to list all processes. Used by Service{} type in Puppet.

**Resolution:**

Assumes `ps -ef` for all operating systems other than BSD derivatives, where it uses
`ps auxwww`.

([↑ Back to top](#page-nav))

* * *

## `puppetversion`


Returns the version of puppet installed.

**Resolution:**

Requres puppet via Ruby and returns its version constant.

([↑ Back to top](#page-nav))

* * *

## `rubysitedir`


Returns Ruby's site library directory.

**Resolution:**

Works out the version to major/minor (1.8, 1.9, etc), then joins that with all the $:
library paths.

([↑ Back to top](#page-nav))

* * *

## `rubyversion`

Returns the version of Ruby facter is running under.

**Resolution:**

Returns `RUBY_VERSION`.

([↑ Back to top](#page-nav))

* * *

## `selinux`

Determine whether SE Linux is enabled on the node.

**Resolution:**

Checks for the existence of the `enforce` file under the SE Linux mount point (e.g. `/selinux/enforce`)
and returns `true` if `/proc/self/attr/current` does not contain `kernel`.

([↑ Back to top](#page-nav))

* * *

## `selinux_config_mode`

Returns the configured SE Linux mode (e.g., `enforcing`, `permissive`, or `disabled`).

**Resolution:**

Parses the output of `sestatus_cmd` and returns the value of the line beginning with `Mode from config file:`.

([↑ Back to top](#page-nav))

* * *

## `selinux_config_policy`


Returns the configured SE Linux policy (e.g., `targeted`, `MLS`, or `minimum`).

**Resolution:**

Parses the output of `sestatus_cmd` and returns the value of the line beginning with `Policy from config file:`.


([↑ Back to top](#page-nav))

* * *

## `selinux_current_mode`


Returns the current SE Linux mode (e.g., `enforcing`, `permissive`, or `disabled`).

**Resolution:**

Parses the output of `sestatus_cmd` and returns the value of the line beginning with `Current mode:`.

([↑ Back to top](#page-nav))

* * *

## `selinux_enforced`


Returns whether SE Linux is enabled (`true`) or not (`false`).

**Resolution:**

Returns the value found in the `enforce` file under the SE Linux mount point (e.g. `/selinux/enforce`).

([↑ Back to top](#page-nav))

* * *

## `selinux_policyversion`


Returns the current SE Linux policy version.

**Resolution:**

Reads the content of the `policyvers` file found under the SE Linux mount point, e.g. `/selinux/policyvers`.

([↑ Back to top](#page-nav))

* * *

## `serialnumber`


Returns the machine's serial number.

([↑ Back to top](#page-nav))

* * *

## `sp_{SYSTEM PROFILER DATA}`


Returns info retrieved in bulk from the OS X system profiler. The names of these facts should be self explanatory, and they are otherwise undocumented. The full list of these facts is:

* `sp_64bit_kernel_and_kexts`
* `sp_boot_mode`
* `sp_boot_rom_version`
* `sp_boot_volume`
* `sp_cpu_interconnect_speed`
* `sp_cpu_type`
* `sp_current_processor_speed`
* `sp_kernel_version`
* `sp_l2_cache_core`
* `sp_l3_cache`
* `sp_local_host_name`
* `sp_machine_model`
* `sp_machine_name`
* `sp_mmm_entry`
* `sp_number_processors`
* `sp_os_version`
* `sp_packages`
* `sp_physical_memory`
* `sp_platform_uuid`
* `sp_secure_vm`
* `sp_serial_number`
* `sp_smc_version_system`
* `sp_uptime`
* `sp_user_name`

([↑ Back to top](#page-nav))

* * *

## `sshdsakey`


Returns the host's SSH DSA key.

([↑ Back to top](#page-nav))

* * *

## `sshecdsakey`


Returns the host's SSH ECDSA key.

([↑ Back to top](#page-nav))

* * *

## `sshrsakey`


Returns the host's SSH RSA key.

([↑ Back to top](#page-nav))

* * *

## `swapencrypted`


Say whether the system's swap space is encrypted. Only used on Darwin.

([↑ Back to top](#page-nav))

* * *

## `swapfree`


Returns the amount of free swap on the system.

([↑ Back to top](#page-nav))

* * *

## `swapsize`


Returns the total amount of swap space available on the system.

([↑ Back to top](#page-nav))

* * *

## `timezone`


Returns the machine's time zone.

**Resolution:**

Uses's Ruby's Time module's Time.new call.

([↑ Back to top](#page-nav))

* * *

## `type`


Returns the machine's chassis type.

([↑ Back to top](#page-nav))

* * *

## `uniqueid`


Returns the output of the `hostid` command.

([↑ Back to top](#page-nav))

* * *

## `uptime`


Returns the system uptime in a human readable format.

**Resolution:**

Does basic maths on the "`uptime_seconds`" fact to return a count of
days, hours and minutes of uptime

([↑ Back to top](#page-nav))

* * *

## `uptime_days`


Returns the total days of uptime.

**Resolution:**

Divides `uptime_hours` fact by 24.

([↑ Back to top](#page-nav))

* * *

## `uptime_hours`


Returns the total hours of uptime.

**Resolution:**

Divides `uptime_seconds` fact by 3600.

([↑ Back to top](#page-nav))

* * *

## `uptime_seconds`


Returns the total seconds of uptime.

**Resolution:**

* Using the 'facter/util/uptime.rb' module, try a variety of methods to acquire the uptime on Unix.
* On Windows, the module calculates the uptime by the "LastBootupTime" Windows management value.

([↑ Back to top](#page-nav))

* * *

## `uuid`


Returns the universally unique identifier on systems where it is available.

**Resolution:**

Parses the output of `dmidecode`.

**Caveats:**

Only available on some versions of Linux, including RHEL/CentOS.

([↑ Back to top](#page-nav))

* * *

## `virtual`


Determine if the system's hardware is real or virtualized.

**Resolution:**

Assumes physical unless proven otherwise.

* On Darwin, uses the macosx util module to acquire the SPDisplaysDataType and from that parses it to see if it's VMWare or Parallels pretending to be the display.
* On Linux, BSD, Solaris, and HPUX: Much of the logic here is obscured behind util/virtual.rb, which rather than document here, which would encourage drift, just refer to it. The Xen tests in here rely on `/sys` and `/proc`, and check for the presence and contents of files in there. If after all the other tests it's still seen as physical, then it tries to parse the output of `lspci`, `dmidecode` and `prtdiag` for obvious signs of being under VMWare, Parallels, or VirtualBox. Finally, it checks for the existence of vmware-vmx, which would hint it's VMWare.

**Caveats:**

Many checks rely purely on existence of files.

([↑ Back to top](#page-nav))

* * *

## `vlans`

On Linux, return a list of all the VLANs on the system.

**Resolution:**

On Linux only, checks for and reads /proc/net/vlan/config and parses it.

([↑ Back to top](#page-nav))

* * *

## `xendomains`

Returns the list of Xen domains on the Dom0.

**Resolution:**

On a Xen Dom0 host, return a list of Xen domains using the 'util/xendomains' library.

([↑ Back to top](#page-nav))


* * *

## `zfs_version`

Returns the version of zfs in use on the system.

**Resolution:**

Uses the output of `zfs upgrade -v`.

([↑ Back to top](#page-nav))

* * *

## `zonename`

Returns the name of the Solaris zone.

**Resolution:**

Uses `zonename` to return the name of the Solaris zone.

**Caveats:**

No support for Solaris 9 and below, where zones are not available.

([↑ Back to top](#page-nav))

* * *

## `zones`

**Purpose:**

Returns the list of zones on the system and adds one `zones_` fact for each zone, with its state (e.g. "running," "incomplete," or "installed.")

**Resolution:**

Uses `usr/sbin/zoneadm list -cp` to get the list of zones in separate parsable lines with a delimeter of ':', which is used to split the line string and get the zone details.

**Caveats:**

No support for Solaris 9 and below, where zones are not available.

([↑ Back to top](#page-nav))

* * *

## `zpool_version`

Returns the version number for the ZFS storage pool.

**Resolution:**

Uses `zpool upgrade -v` to return the ZFS storage pool version number.


([↑ Back to top](#page-nav))
