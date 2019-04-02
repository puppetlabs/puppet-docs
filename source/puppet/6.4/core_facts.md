---
layout: default
built_from_commit: 1b244597afcfe4b1745bafc544ed801a1e762cd8
title: 'Facter: Core Facts'
toc: columns
canonical: "/facter/latest/core_facts.html"
---

This is a list of all of the built-in facts that ship with Facter, which includes both legacy facts and newer structured facts.

Not all of them apply to every system, and your site might also use [custom facts](./custom_facts.html) delivered via Puppet modules. To see the full list of structured facts and values on a given system (including plugin facts), run `puppet facts` at the command line. If you are using Puppet Enterprise, you can view all of the facts for any node on the node's page in the console.

You can access facts in your Puppet manifests as `$fact_name` or `$facts[fact_name]`. For more information, see [the Puppet docs on facts and built-in variables.]({{puppet}}/lang_facts_and_builtin_vars.html)

> **Legacy Facts Note:** As of Facter 3, legacy facts such as `architecture` are hidden by default to reduce noise in Facter's default command-line output. These older facts are now part of more useful structured facts; for example, `architecture` is now part of the `os` fact and accessible as `os.architecture`. You can still use these legacy facts in Puppet manifests (`$architecture`), request them on the command line (`facter architecture`), and view them alongside structured facts (`facter --show-legacy`).

* * *

## Modern Facts

### `aio_agent_version`

**Type:** string

**Purpose:**

Return the version of the puppet-agent package that installed facter.


**Resolution:**

* All platforms: use the compile-time enabled version definition.


([↑ Back to top](#page-nav))

### `augeas`

**Type:** map

**Purpose:**

Return information about augeas.

**Elements:**

* `version` (string) --- The version of augparse.


**Resolution:**

* All platforms: query augparse for augeas metadata.


([↑ Back to top](#page-nav))

### `cloud`

**Type:** map

**Purpose:**

Information about the cloud instance of the node. This is currently only populated on Linux nodes running in Microsoft Azure.

**Elements:**

* `provider` (string) --- The cloud provider for the node.




([↑ Back to top](#page-nav))

### `disks`

**Type:** map

**Purpose:**

Return the disk (block) devices attached to the system.

**Elements:**

* `<devicename>` (map) --- Represents a disk or block device.
    * `model` (string) --- The model of the disk or block device.
    * `product` (string) --- The product name of the disk or block device.
    * `size` (string) --- The display size of the disk or block device, such as "1 GiB".
    * `size_bytes` (integer) --- The size of the disk or block device, in bytes.
    * `vendor` (string) --- The vendor of the disk or block device.


**Resolution:**

* AIX: query the ODM for all disk devices
* Linux: parse the contents of `/sys/block/<device>/`.
* Solaris: use the `kstat` function to query disk information.

**Caveats:**

* Linux: kernel 2.6+ is required due to the reliance on sysfs.

([↑ Back to top](#page-nav))

### `dmi`

**Type:** map

**Purpose:**

Return the system management information.

**Elements:**

* `bios` (map) --- The system BIOS information.
    * `release_date` (string) --- The release date of the system BIOS.
    * `vendor` (string) --- The vendor of the system BIOS.
    * `version` (string) --- The version of the system BIOS.
* `board` (map) --- The system board information.
    * `asset_tag` (string) --- The asset tag of the system board.
    * `manufacturer` (string) --- The manufacturer of the system board.
    * `product` (string) --- The product name of the system board.
    * `serial_number` (string) --- The serial number of the system board.
* `chassis` (map) --- The system chassis information.
    * `asset_tag` (string) --- The asset tag of the system chassis.
    * `type` (string) --- The type of the system chassis.
* `manufacturer` (string) --- The system manufacturer.
* `product` (map) --- The system product information.
    * `name` (string) --- The product name of the system.
    * `serial_number` (string) --- The product serial number of the system.
    * `uuid` (string) --- The product unique identifier of the system.


**Resolution:**

* Linux: parse the contents of `/sys/class/dmi/id/` to retrieve system management information.
* Mac OSX: use the `sysctl` function to retrieve system management information.
* Solaris: use the `smbios`, `prtconf`, and `uname` utilities to retrieve system management information.
* Windows: use WMI to retrieve system management information.

**Caveats:**

* Linux: kernel 2.6+ is required due to the reliance on sysfs.

([↑ Back to top](#page-nav))

### `ec2_metadata`

**Type:** map

**Purpose:**

Return the Amazon Elastic Compute Cloud (EC2) instance metadata.
Please see the [EC2 instance metadata documentation](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-metadata.html) for the contents of this fact.



**Resolution:**

* EC2: query the EC2 metadata endpoint and parse the response.

**Caveats:**

* All platforms: `libfacter` must be built with `libcurl` support.

([↑ Back to top](#page-nav))

### `ec2_userdata`

**Type:** string

**Purpose:**

Return the Amazon Elastic Compute Cloud (EC2) instance user data.
Please see the [EC2 instance user data documentation](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-metadata.html) for the contents of this fact.



**Resolution:**

* EC2: query the EC2 user data endpoint and parse the response.

**Caveats:**

* All platforms: `libfacter` must be built with `libcurl` support.

([↑ Back to top](#page-nav))

### `env_windows_installdir`

**Type:** string

**Purpose:**

Return the path of the directory in which Puppet was installed.


**Resolution:**

* Windows: This fact is specific to the Windows MSI generated environment, and is
*   set using the `environment.bat` script that configures the runtime environment
*   for all Puppet executables. Please see [the original commit in the puppet_for_the_win repo](https://github.com/puppetlabs/puppet_for_the_win/commit/0cc32c1a09550c13d725b200d3c0cc17d93ec262) for more information.

**Caveats:**

* This fact is specific to Windows, and will not resolve on any other platform.

([↑ Back to top](#page-nav))

### `facterversion`

**Type:** string

**Purpose:**

Return the version of facter.


**Resolution:**

* All platforms: use the built-in version of libfacter.


([↑ Back to top](#page-nav))

### `filesystems`

**Type:** string

**Purpose:**

Return the usable file systems for block or disk devices.


**Resolution:**

* AIX: parse the contents of `/etc/vfs` to retrieve the usable file systems.
* Linux: parse the contents of `/proc/filesystems` to retrieve the usable file systems.
* Mac OSX: use the `getfsstat` function to retrieve the usable file systems.
* Solaris: use the `sysdef` utility to retrieve the usable file systems.

**Caveats:**

* Linux: The proc file system must be mounted.
* Mac OSX: The usable file systems is limited to the file system of mounted devices.

([↑ Back to top](#page-nav))

### `fips_enabled`

**Type:** boolean

**Purpose:**

Return whether the platform is in FIPS mode


**Resolution:**

* Linux: parse the contents of `/proc/sys/crypto/fips_enabled` which if non-zero indicates fips mode has been enabled.

**Caveats:**

* Linux: Limited to linux redhat family only

([↑ Back to top](#page-nav))

### `gce`

**Type:** map

**Purpose:**

Return the Google Compute Engine (GCE) metadata.
Please see the [GCE metadata documentation](https://cloud.google.com/compute/docs/metadata) for the contents of this fact.



**Resolution:**

* GCE: query the GCE metadata endpoint and parse the response.

**Caveats:**

* All platforms: `libfacter` must be built with `libcurl` support.

([↑ Back to top](#page-nav))

### `hypervisors`

**Type:** map

**Purpose:**

Experimental fact: Return the names of any detected hypervisors and any collected metadata about them.



**Resolution:**

* All platforms: Use the external `whereami` library to gather hypervisor data, if available.


([↑ Back to top](#page-nav))

### `identity`

**Type:** map

**Purpose:**

Return the identity information of the user running facter.

**Elements:**

* `gid` (integer) --- The group identifier of the user running facter.
* `group` (string) --- The group name of the user running facter.
* `uid` (integer) --- The user identifier of the user running facter.
* `user` (string) --- The user name of the user running facter.
* `privileged` (boolean) --- True if facter is running as a privileged process or false if not.


**Resolution:**

* POSIX platforms: use the `getegid`, `getpwuid_r`, `geteuid`, and `getgrgid_r` functions to retrieve the identity information; use the result of the `geteuid() == 0` test as the value of the privileged element
* Windows: use the `GetUserNameExW` function to retrieve the identity information; use the `GetTokenInformation` to get the current process token elevation status and use it as the value of the privileged element on versions of Windows supporting the token elevation, on older versions of Windows use the `CheckTokenMembership` to test whether the well known local Administrators group SID is enabled in the current thread impersonation token and use the test result as the value of the privileged element


([↑ Back to top](#page-nav))

### `is_virtual`

**Type:** boolean

**Purpose:**

Return whether or not the host is a virtual machine.


**Resolution:**

* Linux: use procfs or utilities such as `vmware` and `virt-what` to retrieve virtual machine status.
* Mac OSX: use the system profiler to retrieve virtual machine status.
* Solaris: use the `zonename` utility to retrieve virtual machine status.
* Windows: use WMI to retrieve virtual machine status.


([↑ Back to top](#page-nav))

### `kernel`

**Type:** string

**Purpose:**

Return the kernel's name.


**Resolution:**

* POSIX platforms: use the `uname` function to retrieve the kernel name.
* Windows: use the value of `windows` for all Windows versions.


([↑ Back to top](#page-nav))

### `kernelmajversion`

**Type:** string

**Purpose:**

Return the kernel's major version.


**Resolution:**

* POSIX platforms: use the `uname` function to retrieve the kernel's major version.
* Windows: use the file version of `kernel32.dll` to retrieve the kernel's major version.


([↑ Back to top](#page-nav))

### `kernelrelease`

**Type:** string

**Purpose:**

Return the kernel's release.


**Resolution:**

* POSIX platforms: use the `uname` function to retrieve the kernel's release.
* Windows: use the file version of `kernel32.dll` to retrieve the kernel's release.


([↑ Back to top](#page-nav))

### `kernelversion`

**Type:** string

**Purpose:**

Return the kernel's version.


**Resolution:**

* POSIX platforms: use the `uname` function to retrieve the kernel's version.
* Windows: use the file version of `kernel32.dll` to retrieve the kernel's version.


([↑ Back to top](#page-nav))

### `ldom`

**Type:** map

**Purpose:**

Return Solaris LDom information from the `virtinfo` utility.


**Resolution:**

* Solaris: use the `virtinfo` utility to retrieve LDom information.


([↑ Back to top](#page-nav))

### `load_averages`

**Type:** map

**Purpose:**

Return the load average over the last 1, 5 and 15 minutes.

**Elements:**

* `1m` (double) --- The system load average over the last minute.
* `5m` (double) --- The system load average over the last 5 minutes.
* `15m` (double) --- The system load average over the last 15 minutes.


**Resolution:**

* POSIX platforms: use `getloadavg` function to retrieve the system load averages.


([↑ Back to top](#page-nav))

### `memory`

**Type:** map

**Purpose:**

Return the system memory information.

**Elements:**

* `swap` (map) --- Represents information about swap memory.
    * `available` (string) --- The display size of the available amount of swap memory, such as "1 GiB".
    * `available_bytes` (integer) --- The size of the available amount of swap memory, in bytes.
    * `capacity` (string) --- The capacity percentage (0% is empty, 100% is full).
    * `encrypted` (boolean) --- True if the swap is encrypted or false if not.
    * `total` (string) --- The display size of the total amount of swap memory, such as "1 GiB".
    * `total_bytes` (integer) --- The size of the total amount of swap memory, in bytes.
    * `used` (string) --- The display size of the used amount of swap memory, such as "1 GiB".
    * `used_bytes` (integer) --- The size of the used amount of swap memory, in bytes.
* `system` (map) --- Represents information about system memory.
    * `available` (string) --- The display size of the available amount of system memory, such as "1 GiB".
    * `available_bytes` (integer) --- The size of the available amount of system memory, in bytes.
    * `capacity` (string) --- The capacity percentage (0% is empty, 100% is full).
    * `total` (string) --- The display size of the total amount of system memory, such as "1 GiB".
    * `total_bytes` (integer) --- The size of the total amount of system memory, in bytes.
    * `used` (string) --- The display size of the used amount of system memory, such as "1 GiB".
    * `used_bytes` (integer) --- The size of the used amount of system memory, in bytes.


**Resolution:**

* Linux: parse the contents of `/proc/meminfo` to retrieve the system memory information.
* Mac OSX: use the `sysctl` function to retrieve the system memory information.
* Solaris: use the `kstat` function to retrieve the system memory information.
* Windows: use the `GetPerformanceInfo` function to retrieve the system memory information.


([↑ Back to top](#page-nav))

### `mountpoints`

**Type:** map

**Purpose:**

Return the current mount points of the system.

**Elements:**

* `<mountpoint>` (map) --- Represents a mount point.
    * `available` (string) --- The display size of the available space, such as "1 GiB".
    * `available_bytes` (integer) --- The size of the available space, in bytes.
    * `capacity` (string) --- The capacity percentage (0% is empty, 100% is full).
    * `device` (string) --- The name of the mounted device.
    * `filesystem` (string) --- The file system of the mounted device.
    * `options` (array) --- The mount options.
    * `size` (string) --- The display size of the total space, such as "1 GiB".
    * `size_bytes` (integer) --- The size of the total space, in bytes.
    * `used` (string) --- The display size of the used space, such as "1 GiB".
    * `used_bytes` (integer) --- The size of the used space, in bytes.


**Resolution:**

* AIX: use the `mntctl` function to retrieve the mount points.
* Linux: use the `setmntent` function to retrieve the mount points.
* Mac OSX: use the `getfsstat` function to retrieve the mount points.
* Solaris: parse the contents of `/etc/mnttab` to retrieve the mount points.


([↑ Back to top](#page-nav))

### `networking`

**Type:** map

**Purpose:**

Return the networking information for the system.

**Elements:**

* `dhcp` (ip) --- The address of the DHCP server for the default interface.
* `domain` (string) --- The domain name of the system.
* `fqdn` (string) --- The fully-qualified domain name of the system.
* `hostname` (string) --- The host name of the system.
* `interfaces` (map) --- The network interfaces of the system.
    * `<interface>` (map) --- Represents a network interface.
        * `bindings` (array) --- The array of IPv4 address bindings for the interface.
        * `bindings6` (array) --- The array of IPv6 address bindings for the interface.
        * `dhcp` (ip) --- The DHCP server for the network interface.
        * `ip` (ip) --- The IPv4 address for the network interface.
        * `ip6` (ip6) --- The IPv6 address for the network interface.
        * `mac` (mac) --- The MAC address for the network interface.
        * `mtu` (integer) --- The Maximum Transmission Unit (MTU) for the network interface.
        * `netmask` (ip) --- The IPv4 netmask for the network interface.
        * `netmask6` (ip6) --- The IPv6 netmask for the network interface.
        * `network` (ip) --- The IPv4 network for the network interface.
        * `network6` (ip6) --- The IPv6 network for the network interface.
* `ip` (ip) --- The IPv4 address of the default network interface.
* `ip6` (ip6) --- The IPv6 address of the default network interface.
* `mac` (mac) --- The MAC address of the default network interface.
* `mtu` (integer) --- The Maximum Transmission Unit (MTU) of the default network interface.
* `netmask` (ip) --- The IPv4 netmask of the default network interface.
* `netmask6` (ip6) --- The IPv6 netmask of the default network interface.
* `network` (ip) --- The IPv4 network of the default network interface.
* `network6` (ip6) --- The IPv6 network of the default network interface.
* `primary` (string) --- The name of the primary interface.


**Resolution:**

* Linux: use the `getifaddrs` function to retrieve the network interfaces.
* Mac OSX: use the `getifaddrs` function to retrieve the network interfaces.
* Solaris: use the `ioctl` function to retrieve the network interfaces.
* Windows: use the `GetAdaptersAddresses` function to retrieve the network interfaces.

**Caveats:**

* Windows Server 2003: the `GetAdaptersInfo` function is used for DHCP and netmask lookup. This function does not support IPv6 netmasks.

([↑ Back to top](#page-nav))

### `os`

**Type:** map

**Purpose:**

Return information about the host operating system.

**Elements:**

* `architecture` (string) --- The operating system's hardware architecture.
* `distro` (map) --- Represents information about a Linux distribution.
    * `codename` (string) --- The code name of the Linux distribution.
    * `description` (string) --- The description of the Linux distribution.
    * `id` (string) --- The identifier of the Linux distribution.
    * `release` (map) --- Represents information about a Linux distribution release.
        * `full` (string) --- The full release of the Linux distribution.
        * `major` (string) --- The major release of the Linux distribution.
        * `minor` (string) --- The minor release of the Linux distribution.
    * `specification` (string) --- The Linux Standard Base (LSB) release specification.
* `family` (string) --- The operating system family.
* `hardware` (string) --- The operating system's hardware model.
* `macosx` (map) --- Represents information about Mac OSX.
    * `build` (string) --- The Mac OSX build version.
    * `product` (string) --- The Mac OSX product name.
    * `version` (map) --- Represents information about the Mac OSX version.
        * `full` (string) --- The full Mac OSX version number.
        * `major` (string) --- The major Mac OSX version number.
        * `minor` (string) --- The minor Mac OSX version number.
* `name` (string) --- The operating system's name.
* `release` (map) --- Represents the operating system's release.
    * `full` (string) --- The full operating system release.
    * `major` (string) --- The major release of the operating system.
    * `minor` (string) --- The minor release of the operating system.
* `selinux` (map) --- Represents information about Security-Enhanced Linux (SELinux).
    * `config_mode` (string) --- The configured SELinux mode.
    * `config_policy` (string) --- The configured SELinux policy.
    * `current_mode` (string) --- The current SELinux mode.
    * `enabled` (boolean) --- True if SELinux is enabled or false if not.
    * `enforced` (boolean) --- True if SELinux policy is enforced or false if not.
    * `policy_version` (string) --- The version of the SELinux policy.
* `windows` (map) --- Represents information about Windows.
    * `system32` (string) --- The path to the System32 directory.


**Resolution:**

* Linux: use the `lsb_release` utility and parse the contents of release files in `/etc` to retrieve the OS information.
* OSX: use the `sw_vers` utility to retrieve the OS information.
* Solaris: parse the contents of `/etc/release` to retrieve the OS information.
* Windows: use WMI to retrieve the OS information.


([↑ Back to top](#page-nav))

### `partitions`

**Type:** map

**Purpose:**

Return the disk partitions of the system.

**Elements:**

* `<partition>` (map) --- Represents a disk partition.
    * `filesystem` (string) --- The file system of the partition.
    * `label` (string) --- The label of the partition.
    * `mount` (string) --- The mount point of the partition (if mounted).
    * `partlabel` (string) --- The label of a GPT partition.
    * `partuuid` (string) --- The unique identifier of a GPT partition.
    * `size` (string) --- The display size of the partition, such as "1 GiB".
    * `size_bytes` (integer) --- The size of the partition, in bytes.
    * `uuid` (string) --- The unique identifier of a partition.
    * `backing_file` (string) --- The path to the file backing the partition.


**Resolution:**

* AIX: use the ODM to retrieve list of logical volumes; use `lvm_querylv` function to get details
* Linux: use `libblkid` to retrieve the disk partitions.

**Caveats:**

* Linux: `libfacter` must be built with `libblkid` support.

([↑ Back to top](#page-nav))

### `path`

**Type:** string

**Purpose:**

Return the PATH environment variable.


**Resolution:**

* All platforms: retrieve the value of the PATH environment variable.


([↑ Back to top](#page-nav))

### `processors`

**Type:** map

**Purpose:**

Return information about the system's processors.

**Elements:**

* `count` (integer) --- The count of logical processors.
* `isa` (string) --- The processor instruction set architecture.
* `models` (array) --- The processor model strings (one for each logical processor).
* `physicalcount` (integer) --- The count of physical processors.
* `speed` (string) --- The speed of the processors, such as "2.0 GHz".


**Resolution:**

* Linux: parse the contents `/sys/devices/system/cpu/` and `/proc/cpuinfo` to retrieve the processor information.
* Mac OSX: use the `sysctl` function to retrieve the processor information.
* Solaris: use the `kstat` function to retrieve the processor information.
* Windows: use WMI to retrieve the processor information.


([↑ Back to top](#page-nav))

### `ruby`

**Type:** map

**Purpose:**

Return information about the Ruby loaded by facter.

**Elements:**

* `platform` (string) --- The platform Ruby was built for.
* `sitedir` (string) --- The path to Ruby's site library directory.
* `version` (string) --- The version of Ruby.


**Resolution:**

* All platforms: Use `RbConfig`, `RUBY_PLATFORM`, and `RUBY_VERSION` to retrieve information about Ruby.

**Caveats:**

* All platforms: facter must be able to locate `libruby`.

([↑ Back to top](#page-nav))

### `solaris_zones`

**Type:** map

**Purpose:**

Return information about Solaris zones.

**Elements:**

* `current` (string) --- The name of the current Solaris zone.
* `zones` (map) --- Represents the Solaris zones.
    * `<zonename>` (map) --- Represents a Solaris zone.
        * `brand` (string) --- The brand of the Solaris zone.
        * `id` (string) --- The id of the Solaris zone.
        * `ip_type` (string) --- The IP type of the Solaris zone.
        * `path` (string) --- The path of the Solaris zone.
        * `status` (string) --- The status of the Solaris zone.
        * `uuid` (string) --- The unique identifier of the Solaris zone.


**Resolution:**

* Solaris: use the `zoneadm` and `zonename` utilities to retrieve information about the Solaris zones.


([↑ Back to top](#page-nav))

### `ssh`

**Type:** map

**Purpose:**

Return SSH public keys and fingerprints.

**Elements:**

* `dsa` (map) --- Represents the public key and fingerprints for the DSA algorithm.
    * `fingerprints` (map) --- Represents fingerprint information.
        * `sha1` (string) --- The SHA1 fingerprint of the public key.
        * `sha256` (string) --- The SHA256 fingerprint of the public key.
    * `key` (string) --- The DSA public key.
    * `type` (string) --- The exact type of the key, i.e. "ssh-dss".
* `ecdsa` (map) --- Represents the public key and fingerprints for the ECDSA algorithm.
    * `fingerprints` (map) --- Represents fingerprint information.
        * `sha1` (string) --- The SHA1 fingerprint of the public key.
        * `sha256` (string) --- The SHA256 fingerprint of the public key.
    * `key` (string) --- The ECDSA public key.
    * `type` (string) --- The exact type of the key, e.g. "ecdsa-sha2-nistp256".
* `ed25519` (map) --- Represents the public key and fingerprints for the Ed25519 algorithm.
    * `fingerprints` (map) --- Represents fingerprint information.
        * `sha1` (string) --- The SHA1 fingerprint of the public key.
        * `sha256` (string) --- The SHA256 fingerprint of the public key.
    * `key` (string) --- The Ed25519 public key.
    * `type` (string) --- The exact type of the key, i.e. "ssh-ed25519".
* `rsa` (map) --- Represents the public key and fingerprints for the RSA algorithm.
    * `fingerprints` (map) --- Represents fingerprint information.
        * `sha1` (string) --- The SHA1 fingerprint of the public key.
        * `sha256` (string) --- The SHA256 fingerprint of the public key.
    * `key` (string) --- The RSA public key.
    * `type` (string) --- The exact type of the key, i.e. "ssh-rsa".


**Resolution:**

* POSIX platforms: parse SSH public key files and derive fingerprints.

**Caveats:**

* POSIX platforms: facter must be built with OpenSSL support.

([↑ Back to top](#page-nav))

### `system_profiler`

**Type:** map

**Purpose:**

Return information from the Mac OSX system profiler.

**Elements:**

* `boot_mode` (string) --- The boot mode.
* `boot_rom_version` (string) --- The boot ROM version.
* `boot_volume` (string) --- The boot volume.
* `computer_name` (string) --- The name of the computer.
* `cores` (string) --- The total number of processor cores.
* `hardware_uuid` (string) --- The hardware unique identifier.
* `kernel_version` (string) --- The version of the kernel.
* `l2_cache_per_core` (string) --- The size of the processor per-core L2 cache.
* `l3_cache` (string) --- The size of the processor L3 cache.
* `memory` (string) --- The size of the system memory.
* `model_identifier` (string) --- The identifier of the computer model.
* `model_name` (string) --- The name of the computer model.
* `processor_name` (string) --- The model name of the processor.
* `processor_speed` (string) --- The speed of the processor.
* `processors` (string) --- The total number of processors.
* `secure_virtual_memory` (string) --- Whether or not secure virtual memory is enabled.
* `serial_number` (string) --- The serial number of the computer.
* `smc_version` (string) --- The System Management Controller (SMC) version.
* `system_version` (string) --- The operating system version.
* `uptime` (string) --- The uptime of the system.
* `username` (string) --- The name of the user running facter.


**Resolution:**

* Mac OSX: use the `system_profiler` utility to retrieve system profiler information.


([↑ Back to top](#page-nav))

### `system_uptime`

**Type:** map

**Purpose:**

Return the system uptime information.

**Elements:**

* `days` (integer) --- The number of complete days the system has been up.
* `hours` (integer) --- The number of complete hours the system has been up.
* `seconds` (integer) --- The number of total seconds the system has been up.
* `uptime` (string) --- The full uptime string.


**Resolution:**

* Linux: use the `sysinfo` function to retrieve the system uptime.
* POSIX platforms: use the `uptime` utility to retrieve the system uptime.
* Solaris: use the `kstat` function to retrieve the system uptime.
* Windows: use WMI to retrieve the system uptime.


([↑ Back to top](#page-nav))

### `timezone`

**Type:** string

**Purpose:**

Return the system timezone.


**Resolution:**

* POSIX platforms: use the `localtime_r` function to retrieve the system timezone.
* Windows: use the `localtime_s` function to retrieve the system timezone.


([↑ Back to top](#page-nav))

### `virtual`

**Type:** string

**Purpose:**

Return the hypervisor name for virtual machines or "physical" for physical machines.


**Resolution:**

* Linux: use procfs or utilities such as `vmware` and `virt-what` to retrieve virtual machine name.
* Mac OSX: use the system profiler to retrieve virtual machine name.
* Solaris: use the `zonename` utility to retrieve virtual machine name.
* Windows: use WMI to retrieve virtual machine name.


([↑ Back to top](#page-nav))

### `xen`

**Type:** map

**Purpose:**

Return metadata for the Xen hypervisor.

**Elements:**

* `domains` (array) --- list of strings identifying active Xen domains.


**Resolution:**

* POSIX platforms: use `/usr/lib/xen-common/bin/xen-toolstack` to locate xen admin commands if available, otherwise fallback to `/usr/sbin/xl` or `/usr/sbin/xm`. Use the found command to execute the `list` query.

**Caveats:**

* POSIX platforms: confined to Xen privileged virtual machines.

([↑ Back to top](#page-nav))

### `zfs_featurenumbers`

**Type:** string

**Purpose:**

Return the comma-delimited feature numbers for ZFS.


**Resolution:**

* Solaris: use the `zfs` utility to retrieve the feature numbers for ZFS

**Caveats:**

* Solaris: the `zfs` utility must be present.

([↑ Back to top](#page-nav))

### `zfs_version`

**Type:** string

**Purpose:**

Return the version for ZFS.


**Resolution:**

* Solaris: use the `zfs` utility to retrieve the version for ZFS

**Caveats:**

* Solaris: the `zfs` utility must be present.

([↑ Back to top](#page-nav))

### `zpool_featureflags`

**Type:** string

**Purpose:**

Return the comma-delimited feature flags for ZFS storage pools.


**Resolution:**

* Solaris: use the `zpool` utility to retrieve the feature numbers for ZFS storage pools

**Caveats:**

* Solaris: the `zpool` utility must be present.

([↑ Back to top](#page-nav))

### `zpool_featurenumbers`

**Type:** string

**Purpose:**

Return the comma-delimited feature numbers for ZFS storage pools.


**Resolution:**

* Solaris: use the `zpool` utility to retrieve the feature numbers for ZFS storage pools

**Caveats:**

* Solaris: the `zpool` utility must be present.

([↑ Back to top](#page-nav))

### `zpool_version`

**Type:** string

**Purpose:**

Return the version for ZFS storage pools.


**Resolution:**

* Solaris: use the `zpool` utility to retrieve the version for ZFS storage pools

**Caveats:**

* Solaris: the `zpool` utility must be present.

([↑ Back to top](#page-nav))

## Legacy Facts

### `architecture`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the operating system's hardware architecture.


**Resolution:**

* POSIX platforms: use the `uname` function to retrieve the OS hardware architecture.
* Windows: use the `GetNativeSystemInfo` function to retrieve the OS hardware architecture.

**Caveats:**

* Linux: Debian, Gentoo, kFreeBSD, and Ubuntu use "amd64" for "x86_64" and Gentoo uses "x86" for "i386".

([↑ Back to top](#page-nav))

### `augeasversion`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the version of augeas.


**Resolution:**

* All platforms: query augparse for the augeas version.


([↑ Back to top](#page-nav))

### `blockdevices`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return a comma-separated list of block devices.


**Resolution:**

* Linux: parse the contents of `/sys/block/<device>/`.
* Solaris: use the `kstat` function to query disk information.

**Caveats:**

* Linux: kernel 2.6+ is required due to the reliance on sysfs.

([↑ Back to top](#page-nav))

### `blockdevice_<devicename>_model`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the model name of block devices attached to the system.


**Resolution:**

* Linux: parse the contents of `/sys/block/<device>/device/model` to retrieve the model name/number for a device.
* Solaris: use the `kstat` function to query disk information.

**Caveats:**

* Linux: kernel 2.6+ is required due to the reliance on sysfs.

([↑ Back to top](#page-nav))

### `blockdevice_<devicename>_size`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** integer

**Purpose:**

Return the size of a block device in bytes.


**Resolution:**

* Linux: parse the contents of `/sys/block/<device>/size` to receive the size (multiplying by 512 to correct for blocks-to-bytes).
* Solaris: use the `kstat` function to query disk information.

**Caveats:**

* Linux: kernel 2.6+ is required due to the reliance on sysfs.

([↑ Back to top](#page-nav))

### `blockdevice_<devicename>_vendor`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the vendor name of block devices attached to the system.


**Resolution:**

* Linux: parse the contents of `/sys/block/<device>/device/vendor` to retrieve the vendor for a device.
* Solaris: use the `kstat` function to query disk information.

**Caveats:**

* Linux: kernel 2.6+ is required due to the reliance on sysfs.

([↑ Back to top](#page-nav))

### `bios_release_date`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the release date of the system BIOS.


**Resolution:**

* Linux: parse the contents of `/sys/class/dmi/id/bios_date` to retrieve the system BIOS release date.
* Solaris: use the `smbios` utility to retrieve the system BIOS release date.

**Caveats:**

* Linux: kernel 2.6+ is required due to the reliance on sysfs.

([↑ Back to top](#page-nav))

### `bios_vendor`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the vendor of the system BIOS.


**Resolution:**

* Linux: parse the contents of `/sys/class/dmi/id/bios_vendor` to retrieve the system BIOS vendor.
* Solaris: use the `smbios` utility to retrieve the system BIOS vendor.

**Caveats:**

* Linux: kernel 2.6+ is required due to the reliance on sysfs.

([↑ Back to top](#page-nav))

### `bios_version`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the version of the system BIOS.


**Resolution:**

* Linux: parse the contents of `/sys/class/dmi/id/bios_version` to retrieve the system BIOS version.
* Solaris: use the `smbios` utility to retrieve the system BIOS version.

**Caveats:**

* Linux: kernel 2.6+ is required due to the reliance on sysfs.

([↑ Back to top](#page-nav))

### `boardassettag`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the system board asset tag.


**Resolution:**

* Linux: parse the contents of `/sys/class/dmi/id/board_asset_tag` to retrieve the system board asset tag.

**Caveats:**

* Linux: kernel 2.6+ is required due to the reliance on sysfs.

([↑ Back to top](#page-nav))

### `boardmanufacturer`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the system board manufacturer.


**Resolution:**

* Linux: parse the contents of `/sys/class/dmi/id/board_vendor` to retrieve the system board manufacturer.

**Caveats:**

* Linux: kernel 2.6+ is required due to the reliance on sysfs.

([↑ Back to top](#page-nav))

### `boardproductname`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the system board product name.


**Resolution:**

* Linux: parse the contents of `/sys/class/dmi/id/board_name` to retrieve the system board product name.

**Caveats:**

* Linux: kernel 2.6+ is required due to the reliance on sysfs.

([↑ Back to top](#page-nav))

### `boardserialnumber`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the system board serial number.


**Resolution:**

* Linux: parse the contents of `/sys/class/dmi/id/board_serial` to retrieve the system board serial number.

**Caveats:**

* Linux: kernel 2.6+ is required due to the reliance on sysfs.

([↑ Back to top](#page-nav))

### `chassisassettag`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the system chassis asset tag.


**Resolution:**

* Linux: parse the contents of `/sys/class/dmi/id/chassis_asset_tag` to retrieve the system chassis asset tag.
* Solaris: use the `smbios` utility to retrieve the system chassis asset tag.

**Caveats:**

* Linux: kernel 2.6+ is required due to the reliance on sysfs.

([↑ Back to top](#page-nav))

### `chassistype`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the system chassis type.


**Resolution:**

* Linux: parse the contents of `/sys/class/dmi/id/chassis_type` to retrieve the system chassis type.
* Solaris: use the `smbios` utility to retrieve the system chassis type.

**Caveats:**

* Linux: kernel 2.6+ is required due to the reliance on sysfs.

([↑ Back to top](#page-nav))

### `dhcp_servers`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** map

**Purpose:**

Return the DHCP servers for the system.

**Elements:**

* `<interface>` (ip) --- The DHCP server for the interface.
* `system` (ip) --- The DHCP server for the default interface.


**Resolution:**

* Linux: parse `dhclient` lease files or use the `dhcpcd` utility to retrieve the DHCP servers.
* Mac OSX: use the `ipconfig` utility to retrieve the DHCP servers.
* Solaris: use the `dhcpinfo` utility to retrieve the DHCP servers.
* Windows: use the `GetAdaptersAddresses` (Windows Server 2003: `GetAdaptersInfo`) function to retrieve the DHCP servers.


([↑ Back to top](#page-nav))

### `domain`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the network domain of the system.


**Resolution:**

* POSIX platforms: use the `getaddrinfo` function to retrieve the network domain.
* Windows: query the registry to retrieve the network domain; falls back to the primary interface's domain if not set in the registry.


([↑ Back to top](#page-nav))

### `fqdn`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the fully qualified domain name (FQDN) of the system.


**Resolution:**

* POSIX platforms: use the `getaddrinfo` function to retrieve the FQDN or use host and domain names.
* Windows: use the host and domain names to build the FQDN.


([↑ Back to top](#page-nav))

### `gid`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the group identifier (GID) of the user running facter.


**Resolution:**

* POSIX platforms: use the `getegid` fuction to retrieve the group identifier.


([↑ Back to top](#page-nav))

### `hardwareisa`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the hardware instruction set architecture (ISA).


**Resolution:**

* POSIX platforms: use `uname` to retrieve the hardware ISA.
* Windows: use WMI to retrieve the hardware ISA.


([↑ Back to top](#page-nav))

### `hardwaremodel`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the operating system's hardware model.


**Resolution:**

* POSIX platforms: use the `uname` function to retrieve the OS hardware model.
* Windows: use the `GetNativeSystemInfo` function to retrieve the OS hardware model.


([↑ Back to top](#page-nav))

### `hostname`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the host name of the system.


**Resolution:**

* POSIX platforms: use the `gethostname` function to retrieve the host name
* Windows: use the `GetComputerNameExW` function to retrieve the host name.


([↑ Back to top](#page-nav))

### `id`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the user identifier (UID) of the user running facter.


**Resolution:**

* POSIX platforms: use the `geteuid` fuction to retrieve the user identifier.


([↑ Back to top](#page-nav))

### `interfaces`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the comma-separated list of network interface names.


**Resolution:**

* Linux: use the `getifaddrs` function to retrieve the network interface names.
* Mac OSX: use the `getifaddrs` function to retrieve the network interface names.
* Solaris: use the `ioctl` function to retrieve the network interface names.
* Windows: use the `GetAdaptersAddresses` function to retrieve the network interface names.


([↑ Back to top](#page-nav))

### `ipaddress`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** ip

**Purpose:**

Return the IPv4 address for the default network interface.


**Resolution:**

* Linux: use the `getifaddrs` function to retrieve the network interface address.
* Mac OSX: use the `getifaddrs` function to retrieve the network interface address.
* Solaris: use the `ioctl` function to retrieve the network interface address.
* Windows: use the `GetAdaptersAddresses` function to retrieve the network interface address.


([↑ Back to top](#page-nav))

### `ipaddress6`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** ip6

**Purpose:**

Return the IPv6 address for the default network interface.


**Resolution:**

* Linux: use the `getifaddrs` function to retrieve the network interface address.
* Mac OSX: use the `getifaddrs` function to retrieve the network interface address.
* Solaris: use the `ioctl` function to retrieve the network interface address.
* Windows: use the `GetAdaptersAddresses` function to retrieve the network interface address.


([↑ Back to top](#page-nav))

### `ipaddress6_<interface>`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** ip6

**Purpose:**

Return the IPv6 address for a network interface.


**Resolution:**

* Linux: use the `getifaddrs` function to retrieve the network interface address.
* Mac OSX: use the `getifaddrs` function to retrieve the network interface address.
* Solaris: use the `ioctl` function to retrieve the network interface address.
* Windows: use the `GetAdaptersAddresses` function to retrieve the network interface address.


([↑ Back to top](#page-nav))

### `ipaddress_<interface>`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** ip

**Purpose:**

Return the IPv4 address for a network interface.


**Resolution:**

* Linux: use the `getifaddrs` function to retrieve the network interface address.
* Mac OSX: use the `getifaddrs` function to retrieve the network interface address.
* Solaris: use the `ioctl` function to retrieve the network interface address.
* Windows: use the `GetAdaptersAddresses` function to retrieve the network interface address.


([↑ Back to top](#page-nav))

### `ldom_<name>`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return Solaris LDom information.


**Resolution:**

* Solaris: use the `virtinfo` utility to retrieve LDom information.


([↑ Back to top](#page-nav))

### `lsbdistcodename`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the Linux Standard Base (LSB) distribution code name.


**Resolution:**

* Linux: use the `lsb_release` utility to retrieve the LSB distribution code name.

**Caveats:**

* Linux: Requires that the `lsb_release` utility be installed.

([↑ Back to top](#page-nav))

### `lsbdistdescription`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the Linux Standard Base (LSB) distribution description.


**Resolution:**

* Linux: use the `lsb_release` utility to retrieve the LSB distribution description.

**Caveats:**

* Linux: Requires that the `lsb_release` utility be installed.

([↑ Back to top](#page-nav))

### `lsbdistid`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the Linux Standard Base (LSB) distribution identifier.


**Resolution:**

* Linux: use the `lsb_release` utility to retrieve the LSB distribution identifier.

**Caveats:**

* Linux: Requires that the `lsb_release` utility be installed.

([↑ Back to top](#page-nav))

### `lsbdistrelease`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the Linux Standard Base (LSB) distribution release.


**Resolution:**

* Linux: use the `lsb_release` utility to retrieve the LSB distribution release.

**Caveats:**

* Linux: Requires that the `lsb_release` utility be installed.

([↑ Back to top](#page-nav))

### `lsbmajdistrelease`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the Linux Standard Base (LSB) major distribution release.


**Resolution:**

* Linux: use the `lsb_release` utility to retrieve the LSB major distribution release.

**Caveats:**

* Linux: Requires that the `lsb_release` utility be installed.

([↑ Back to top](#page-nav))

### `lsbminordistrelease`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the Linux Standard Base (LSB) minor distribution release.


**Resolution:**

* Linux: use the `lsb_release` utility to retrieve the LSB minor distribution release.

**Caveats:**

* Linux: Requires that the `lsb_release` utility be installed.

([↑ Back to top](#page-nav))

### `lsbrelease`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the Linux Standard Base (LSB) release.


**Resolution:**

* Linux: use the `lsb_release` utility to retrieve the LSB release.

**Caveats:**

* Linux: Requires that the `lsb_release` utility be installed.

([↑ Back to top](#page-nav))

### `macaddress`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** mac

**Purpose:**

Return the MAC address for the default network interface.


**Resolution:**

* Linux: use the `getifaddrs` function to retrieve the network interface address.
* Mac OSX: use the `getifaddrs` function to retrieve the network interface address.
* Solaris: use the `ioctl` function to retrieve the network interface address.
* Windows: use the `GetAdaptersAddresses` function to retrieve the network interface address.


([↑ Back to top](#page-nav))

### `macaddress_<interface>`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** mac

**Purpose:**

Return the MAC address for a network interface.


**Resolution:**

* Linux: use the `getifaddrs` function to retrieve the network interface address.
* Mac OSX: use the `getifaddrs` function to retrieve the network interface address.
* Solaris: use the `ioctl` function to retrieve the network interface address.
* Windows: use the `GetAdaptersAddresses` function to retrieve the network interface address.


([↑ Back to top](#page-nav))

### `macosx_buildversion`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the Mac OSX build version.


**Resolution:**

* Mac OSX: use the `sw_vers` utility to retrieve the Mac OSX build version.


([↑ Back to top](#page-nav))

### `macosx_productname`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the Mac OSX product name.


**Resolution:**

* Mac OSX: use the `sw_vers` utility to retrieve the Mac OSX product name.


([↑ Back to top](#page-nav))

### `macosx_productversion`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the Mac OSX product version.


**Resolution:**

* Mac OSX: use the `sw_vers` utility to retrieve the Mac OSX product version.


([↑ Back to top](#page-nav))

### `macosx_productversion_major`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the Mac OSX product major version.


**Resolution:**

* Mac OSX: use the `sw_vers` utility to retrieve the Mac OSX product major version.


([↑ Back to top](#page-nav))

### `macosx_productversion_minor`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the Mac OSX product minor version.


**Resolution:**

* Mac OSX: use the `sw_vers` utility to retrieve the Mac OSX product minor version.


([↑ Back to top](#page-nav))

### `manufacturer`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the system manufacturer.


**Resolution:**

* Linux: parse the contents of `/sys/class/dmi/id/sys_vendor` to retrieve the system manufacturer.
* Solaris: use the `prtconf` utility to retrieve the system manufacturer.
* Windows: use WMI to retrieve the system manufacturer.

**Caveats:**

* Linux: kernel 2.6+ is required due to the reliance on sysfs.

([↑ Back to top](#page-nav))

### `memoryfree`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the display size of the free system memory, such as "1 GiB".


**Resolution:**

* Linux: parse the contents of `/proc/meminfo` to retrieve the free system memory.
* Mac OSX: use the `sysctl` function to retrieve the free system memory.
* Solaris: use the `kstat` function to retrieve the free system memory.
* Windows: use the `GetPerformanceInfo` function to retrieve the free system memory.


([↑ Back to top](#page-nav))

### `memoryfree_mb`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** double

**Purpose:**

Return the size of the free system memory, in mebibytes.


**Resolution:**

* Linux: parse the contents of `/proc/meminfo` to retrieve the free system memory.
* Mac OSX: use the `sysctl` function to retrieve the free system memory.
* Solaris: use the `kstat` function to retrieve the free system memory.
* Windows: use the `GetPerformanceInfo` function to retrieve the free system memory.


([↑ Back to top](#page-nav))

### `memorysize`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the display size of the total system memory, such as "1 GiB".


**Resolution:**

* Linux: parse the contents of `/proc/meminfo` to retrieve the total system memory.
* Mac OSX: use the `sysctl` function to retrieve the total system memory.
* Solaris: use the `kstat` function to retrieve the total system memory.
* Windows: use the `GetPerformanceInfo` function to retrieve the total system memory.


([↑ Back to top](#page-nav))

### `memorysize_mb`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** double

**Purpose:**

Return the size of the total system memory, in mebibytes.


**Resolution:**

* Linux: parse the contents of `/proc/meminfo` to retrieve the total system memory.
* Mac OSX: use the `sysctl` function to retrieve the total system memory.
* Solaris: use the `kstat` function to retrieve the total system memory.
* Windows: use the `GetPerformanceInfo` function to retrieve the total system memory.


([↑ Back to top](#page-nav))

### `mtu_<interface>`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** integer

**Purpose:**

Return the Maximum Transmission Unit (MTU) for a network interface.


**Resolution:**

* Linux: use the `ioctl` function to retrieve the network interface MTU.
* Mac OSX: use the `getifaddrs` function to retrieve the network interface MTU.
* Solaris: use the `ioctl` function to retrieve the network interface MTU.
* Windows: use the `GetAdaptersAddresses` function to retrieve the network interface MTU.


([↑ Back to top](#page-nav))

### `netmask`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** ip

**Purpose:**

Return the IPv4 netmask for the default network interface.


**Resolution:**

* Linux: use the `getifaddrs` function to retrieve the network interface netmask.
* Mac OSX: use the `getifaddrs` function to retrieve the network interface netmask.
* Solaris: use the `ioctl` function to retrieve the network interface netmask.
* Windows: use the `GetAdaptersAddresses` (Windows Server 2003: `GetAdaptersInfo`) function to retrieve the network interface netmask.


([↑ Back to top](#page-nav))

### `netmask6`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** ip6

**Purpose:**

Return the IPv6 netmask for the default network interface.


**Resolution:**

* Linux: use the `getifaddrs` function to retrieve the network interface netmask.
* Mac OSX: use the `getifaddrs` function to retrieve the network interface netmask.
* Solaris: use the `ioctl` function to retrieve the network interface netmask.
* Windows: use the `GetAdaptersAddresses` function to retrieve the network interface netmask.

**Caveats:**

* Windows Server 2003: IPv6 netmasks are not supported.

([↑ Back to top](#page-nav))

### `netmask6_<interface>`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** ip6

**Purpose:**

Return the IPv6 netmask for a network interface.


**Resolution:**

* Linux: use the `getifaddrs` function to retrieve the network interface netmask.
* Mac OSX: use the `getifaddrs` function to retrieve the network interface netmask.
* Solaris: use the `ioctl` function to retrieve the network interface netmask.
* Windows: use the `GetAdaptersAddresses` function to retrieve the network interface netmask.

**Caveats:**

* Windows Server 2003: IPv6 netmasks are not supported.

([↑ Back to top](#page-nav))

### `netmask_<interface>`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** ip

**Purpose:**

Return the IPv4 netmask for a network interface.


**Resolution:**

* Linux: use the `getifaddrs` function to retrieve the network interface netmask.
* Mac OSX: use the `getifaddrs` function to retrieve the network interface netmask.
* Solaris: use the `ioctl` function to retrieve the network interface netmask.
* Windows: use the `GetAdaptersAddresses` (Windows Server 2003: `GetAdaptersInfo`) function to retrieve the network interface netmask.


([↑ Back to top](#page-nav))

### `network`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** ip

**Purpose:**

Return the IPv4 network for the default network interface.


**Resolution:**

* Linux: use the `getifaddrs` function to retrieve the network interface network.
* Mac OSX: use the `getifaddrs` function to retrieve the network interface network.
* Solaris: use the `ioctl` function to retrieve the network interface network.
* Windows: use the `GetAdaptersAddresses` function to retrieve the network interface network.


([↑ Back to top](#page-nav))

### `network6`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** ip6

**Purpose:**

Return the IPv6 network for the default network interface.


**Resolution:**

* Linux: use the `getifaddrs` function to retrieve the network interface network.
* Mac OSX: use the `getifaddrs` function to retrieve the network interface network.
* Solaris: use the `ioctl` function to retrieve the network interface network.
* Windows: use the `GetAdaptersAddresses` function to retrieve the network interface network.


([↑ Back to top](#page-nav))

### `network6_<interface>`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** ip6

**Purpose:**

Return the IPv6 network for a network interface.


**Resolution:**

* Linux: use the `getifaddrs` function to retrieve the network interface network.
* Mac OSX: use the `getifaddrs` function to retrieve the network interface network.
* Solaris: use the `ioctl` function to retrieve the network interface network.
* Windows: use the `GetAdaptersAddresses` function to retrieve the network interface network.


([↑ Back to top](#page-nav))

### `network_<interface>`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** ip

**Purpose:**

Return the IPv4 network for a network interface.


**Resolution:**

* Linux: use the `getifaddrs` function to retrieve the network interface network.
* Mac OSX: use the `getifaddrs` function to retrieve the network interface network.
* Solaris: use the `ioctl` function to retrieve the network interface network.
* Windows: use the `GetAdaptersAddresses` function to retrieve the network interface network.


([↑ Back to top](#page-nav))

### `operatingsystem`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the name of the operating system.


**Resolution:**

* All platforms: default to the kernel name.
* Linux: use various release files in `/etc` to retrieve the OS name.


([↑ Back to top](#page-nav))

### `operatingsystemmajrelease`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the major release of the operating system.


**Resolution:**

* All platforms: default to the major version of the kernel release.
* Linux: parse the contents of release files in `/etc` to retrieve the OS major release.
* Solaris: parse the contents of `/etc/release` to retrieve the OS major release.
* Windows: use WMI to retrieve the OS major release.

**Caveats:**

* Linux: for Ubuntu, the major release is X.Y, such as "10.4".

([↑ Back to top](#page-nav))

### `operatingsystemrelease`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the release of the operating system.


**Resolution:**

* All platforms: default to the kernel release.
* Linux: parse the contents of release files in `/etc` to retrieve the OS release.
* Solaris: parse the contents of `/etc/release` to retrieve the OS release.
* Windows: use WMI to retrieve the OS release.


([↑ Back to top](#page-nav))

### `osfamily`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the family of the operating system.


**Resolution:**

* All platforms: default to the kernel name.
* Linux: map various Linux distributions to their base distribution. For example, Ubuntu is a "Debian" distro.
* Solaris: map various Solaris-based operating systems to the "Solaris" family.
* Windows: use "windows" as the family name.


([↑ Back to top](#page-nav))

### `physicalprocessorcount`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** integer

**Purpose:**

Return the count of physical processors.


**Resolution:**

* Linux: parse the contents `/sys/devices/system/cpu/` and `/proc/cpuinfo` to retrieve the count of physical processors.
* Mac OSX: use the `sysctl` function to retrieve the count of physical processors.
* Solaris: use the `kstat` function to retrieve the count of physical processors.
* Windows: use WMI to retrieve the count of physical processors.

**Caveats:**

* Linux: kernel 2.6+ is required due to the reliance on sysfs.

([↑ Back to top](#page-nav))

### `processor<N>`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the model string of processor N.


**Resolution:**

* Linux: parse the contents of `/proc/cpuinfo` to retrieve the processor model string.
* Mac OSX: use the `sysctl` function to retrieve the processor model string.
* Solaris: use the `kstat` function to retrieve the processor model string.
* Windows: use WMI to retrieve the processor model string.


([↑ Back to top](#page-nav))

### `processorcount`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** integer

**Purpose:**

Return the count of logical processors.


**Resolution:**

* Linux: parse the contents `/sys/devices/system/cpu/` and `/proc/cpuinfo` to retrieve the count of logical processors.
* Mac OSX: use the `sysctl` function to retrieve the count of logical processors.
* Solaris: use the `kstat` function to retrieve the count of logical processors.
* Windows: use WMI to retrieve the count of logical processors.

**Caveats:**

* Linux: kernel 2.6+ is required due to the reliance on sysfs.

([↑ Back to top](#page-nav))

### `productname`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the system product name.


**Resolution:**

* Linux: parse the contents of `/sys/class/dmi/id/product_name` to retrieve the system product name.
* Mac OSX: use the `sysctl` function to retrieve the system product name.
* Solaris: use the `smbios` utility to retrieve the system product name.
* Windows: use WMI to retrieve the system product name.

**Caveats:**

* Linux: kernel 2.6+ is required due to the reliance on sysfs.

([↑ Back to top](#page-nav))

### `rubyplatform`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the platform Ruby was built for.


**Resolution:**

* All platforms: use `RUBY_PLATFORM` from the Ruby loaded by facter.

**Caveats:**

* All platforms: facter must be able to locate `libruby`.

([↑ Back to top](#page-nav))

### `rubysitedir`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the path to Ruby's site library directory.


**Resolution:**

* All platforms: use `RbConfig` from the Ruby loaded by facter.

**Caveats:**

* All platforms: facter must be able to locate `libruby`.

([↑ Back to top](#page-nav))

### `rubyversion`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the version of Ruby.


**Resolution:**

* All platforms: use `RUBY_VERSION` from the Ruby loaded by facter.

**Caveats:**

* All platforms: facter must be able to locate `libruby`.

([↑ Back to top](#page-nav))

### `selinux`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** boolean

**Purpose:**

Return whether Security-Enhanced Linux (SELinux) is enabled.


**Resolution:**

* Linux: parse the contents of `/proc/self/mounts` to determine if SELinux is enabled.


([↑ Back to top](#page-nav))

### `selinux_config_mode`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the configured Security-Enhanced Linux (SELinux) mode.


**Resolution:**

* Linux: parse the contents of `/etc/selinux/config` to retrieve the configured SELinux mode.


([↑ Back to top](#page-nav))

### `selinux_config_policy`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the configured Security-Enhanced Linux (SELinux) policy.


**Resolution:**

* Linux: parse the contents of `/etc/selinux/config` to retrieve the configured SELinux policy.


([↑ Back to top](#page-nav))

### `selinux_current_mode`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the current Security-Enhanced Linux (SELinux) mode.


**Resolution:**

* Linux: parse the contents of `<mountpoint>/enforce` to retrieve the current SELinux mode.


([↑ Back to top](#page-nav))

### `selinux_enforced`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** boolean

**Purpose:**

Return whether Security-Enhanced Linux (SELinux) is enforced.


**Resolution:**

* Linux: parse the contents of `<mountpoint>/enforce` to retrieve the current SELinux mode.


([↑ Back to top](#page-nav))

### `selinux_policyversion`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the Security-Enhanced Linux (SELinux) policy version.


**Resolution:**

* Linux: parse the contents of `<mountpoint>/policyvers` to retrieve the SELinux policy version.


([↑ Back to top](#page-nav))

### `serialnumber`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the system product serial number.


**Resolution:**

* Linux: parse the contents of `/sys/class/dmi/id/product_name` to retrieve the system product serial number.
* Solaris: use the `smbios` utility to retrieve the system product serial number.
* Windows: use WMI to retrieve the system product serial number.

**Caveats:**

* Linux: kernel 2.6+ is required due to the reliance on sysfs.

([↑ Back to top](#page-nav))

### `sp_<name>`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return Mac OSX system profiler information.


**Resolution:**

* Mac OSX: use the `system_profiler` utility to retrieve system profiler information.


([↑ Back to top](#page-nav))

### `ssh<algorithm>key`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the SSH public key for the algorithm.


**Resolution:**

* POSIX platforms: parse SSH public key files.

**Caveats:**

* POSIX platforms: facter must be built with OpenSSL support.

([↑ Back to top](#page-nav))

### `sshfp_<algorithm>`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the SSH fingerprints for the algorithm's public key.


**Resolution:**

* POSIX platforms: derive the SHA1 and SHA256 fingerprints; delimit with a new line character.

**Caveats:**

* POSIX platforms: facter must be built with OpenSSL support.

([↑ Back to top](#page-nav))

### `swapencrypted`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** boolean

**Purpose:**

Return whether or not the swap is encrypted.


**Resolution:**

* Mac OSX: use the `sysctl` function to retrieve swap encryption status.


([↑ Back to top](#page-nav))

### `swapfree`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the display size of the free swap memory, such as "1 GiB".


**Resolution:**

* Linux: parse the contents of `/proc/meminfo` to retrieve the free swap memory.
* Mac OSX: use the `sysctl` function to retrieve the free swap memory.
* Solaris: use the `swapctl` function to retrieve the free swap memory.


([↑ Back to top](#page-nav))

### `swapfree_mb`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** double

**Purpose:**

Return the size of the free swap memory, in mebibytes.


**Resolution:**

* Linux: parse the contents of `/proc/meminfo` to retrieve the free swap memory.
* Mac OSX: use the `sysctl` function to retrieve the free swap memory.
* Solaris: use the `swapctl` function to retrieve the free swap memory.


([↑ Back to top](#page-nav))

### `swapsize`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the display size of the total swap memory, such as "1 GiB".


**Resolution:**

* Linux: parse the contents of `/proc/meminfo` to retrieve the total swap memory.
* Mac OSX: use the `sysctl` function to retrieve the total swap memory.
* Solaris: use the `swapctl` function to retrieve the total swap memory.


([↑ Back to top](#page-nav))

### `swapsize_mb`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** double

**Purpose:**

Return the size of the total swap memory, in mebibytes.


**Resolution:**

* Linux: parse the contents of `/proc/meminfo` to retrieve the total swap memory.
* Mac OSX: use the `sysctl` function to retrieve the total swap memory.
* Solaris: use the `swapctl` function to retrieve the total swap memory.


([↑ Back to top](#page-nav))

### `system32`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the path to the System32 directory on Windows.


**Resolution:**

* Windows: use the `SHGetFolderPath` function to retrieve the path to the System32 directory.


([↑ Back to top](#page-nav))

### `uptime`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the system uptime.


**Resolution:**

* Linux: use the `sysinfo` function to retrieve the system uptime.
* POSIX platforms: use the `uptime` utility to retrieve the system uptime.
* Solaris: use the `kstat` function to retrieve the system uptime.
* Windows: use WMI to retrieve the system uptime.


([↑ Back to top](#page-nav))

### `uptime_days`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** integer

**Purpose:**

Return the system uptime days.


**Resolution:**

* Linux: use the `sysinfo` function to retrieve the system uptime days.
* POSIX platforms: use the `uptime` utility to retrieve the system uptime days.
* Solaris: use the `kstat` function to retrieve the system uptime days.
* Windows: use WMI to retrieve the system uptime days.


([↑ Back to top](#page-nav))

### `uptime_hours`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** integer

**Purpose:**

Return the system uptime hours.


**Resolution:**

* Linux: use the `sysinfo` function to retrieve the system uptime hours.
* POSIX platforms: use the `uptime` utility to retrieve the system uptime hours.
* Solaris: use the `kstat` function to retrieve the system uptime hours.
* Windows: use WMI to retrieve the system uptime hours.


([↑ Back to top](#page-nav))

### `uptime_seconds`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** integer

**Purpose:**

Return the system uptime seconds.


**Resolution:**

* Linux: use the `sysinfo` function to retrieve the system uptime seconds.
* POSIX platforms: use the `uptime` utility to retrieve the system uptime seconds.
* Solaris: use the `kstat` function to retrieve the system uptime seconds.
* Windows: use WMI to retrieve the system uptime seconds.


([↑ Back to top](#page-nav))

### `uuid`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the system product unique identifier.


**Resolution:**

* Linux: parse the contents of `/sys/class/dmi/id/product_uuid` to retrieve the system product unique identifier.
* Solaris: use the `smbios` utility to retrieve the system product unique identifier.

**Caveats:**

* Linux: kernel 2.6+ is required due to the reliance on sysfs.

([↑ Back to top](#page-nav))

### `xendomains`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return a list of comma-separated active Xen domain names.


**Resolution:**

* POSIX platforms: see the `xen` structured fact.

**Caveats:**

* POSIX platforms: confined to Xen privileged virtual machines.

([↑ Back to top](#page-nav))

### `zone_<name>_brand`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the brand for the Solaris zone.


**Resolution:**

* Solaris: use the `zoneadm` utility to retrieve the brand for the Solaris zone.

**Caveats:**

* Solaris: the `zoneadm` utility must be present.

([↑ Back to top](#page-nav))

### `zone_<name>_iptype`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the IP type for the Solaris zone.


**Resolution:**

* Solaris: use the `zoneadm` utility to retrieve the IP type for the Solaris zone.

**Caveats:**

* Solaris: the `zoneadm` utility must be present.

([↑ Back to top](#page-nav))

### `zone_<name>_name`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the name for the Solaris zone.


**Resolution:**

* Solaris: use the `zoneadm` utility to retrieve the name for the Solaris zone.

**Caveats:**

* Solaris: the `zoneadm` utility must be present.

([↑ Back to top](#page-nav))

### `zone_<name>_uuid`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the unique identifier for the Solaris zone.


**Resolution:**

* Solaris: use the `zoneadm` utility to retrieve the unique identifier for the Solaris zone.

**Caveats:**

* Solaris: the `zoneadm` utility must be present.

([↑ Back to top](#page-nav))

### `zone_<name>_id`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the zone identifier for the Solaris zone.


**Resolution:**

* Solaris: use the `zoneadm` utility to retrieve the zone identifier for the Solaris zone.

**Caveats:**

* Solaris: the `zoneadm` utility must be present.

([↑ Back to top](#page-nav))

### `zone_<name>_path`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the zone path for the Solaris zone.


**Resolution:**

* Solaris: use the `zoneadm` utility to retrieve the zone path for the Solaris zone.

**Caveats:**

* Solaris: the `zoneadm` utility must be present.

([↑ Back to top](#page-nav))

### `zone_<name>_status`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the zone state for the Solaris zone.


**Resolution:**

* Solaris: use the `zoneadm` utility to retrieve the zone state for the Solaris zone.

**Caveats:**

* Solaris: the `zoneadm` utility must be present.

([↑ Back to top](#page-nav))

### `zonename`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the name of the current Solaris zone.


**Resolution:**

* Solaris: use the `zonename` utility to retrieve the current zone name.

**Caveats:**

* Solaris: the `zonename` utility must be present.

([↑ Back to top](#page-nav))

### `zones`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** integer

**Purpose:**

Return the count of Solaris zones.


**Resolution:**

* Solaris: use the `zoneadm` utility to retrieve the count of Solaris zones.

**Caveats:**

* Solaris: the `zoneadm` utility must be present.

([↑ Back to top](#page-nav))

