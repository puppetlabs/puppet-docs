---
layout: default
built_from_commit: b1ccc5d8d335a57108919a17a10d0ab80e91b2fc
title: 'Facter: Core Facts'
toc: columns
canonical: "/puppet/latest/core_facts.html"
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


### `augeas`

**Type:** map

**Purpose:**

Return information about augeas.

**Elements:**

* `version` (string) --- The version of augparse.


### `az_metadata`

**Type:** map

**Purpose:**

Return the Microsoft Azure instance metadata.
Please see the [Microsoft Azure instance metadata documentation](https://learn.microsoft.com/en-us/azure/virtual-machines/instance-metadata-service?tabs=windows) for the contents of this fact.



### `cloud`

**Type:** map

**Purpose:**

Information about the cloud instance of the node. This is currently only populated on nodes running in Microsoft Azure.

**Elements:**

* `provider` (string) --- The cloud provider for the node.


### `disks`

**Type:** map

**Purpose:**

Return the disk (block) devices attached to the system.

**Elements:**

* `<devicename>` (map) --- Represents a disk or block device.
    * `model` (string) --- The model of the disk or block device.
    * `product` (string) --- The product name of the disk or block device.
    * `serial_number` (string) --- The serial number of the disk or block device.
    * `size` (string) --- The display size of the disk or block device, such as "1 GiB".
    * `size_bytes` (integer) --- The size of the disk or block device, in bytes.
    * `vendor` (string) --- The vendor of the disk or block device.
    * `type` (string) --- The type of disk or block device (sshd or hdd). This fact is available only on Linux.


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


### `ec2_metadata`

**Type:** map

**Purpose:**

Return the Amazon Elastic Compute Cloud (EC2) instance metadata.
Please see the [EC2 instance metadata documentation](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-metadata.html) for the contents of this fact.



### `ec2_userdata`

**Type:** string

**Purpose:**

Return the Amazon Elastic Compute Cloud (EC2) instance user data.
Please see the [EC2 instance user data documentation](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-metadata.html) for the contents of this fact.



### `env_windows_installdir`

**Type:** string

**Purpose:**

Return the path of the directory in which Puppet was installed.


### `facterversion`

**Type:** string

**Purpose:**

Return the version of facter.


### `filesystems`

**Type:** string

**Purpose:**

Return the usable file systems for block or disk devices.


### `fips_enabled`

**Type:** boolean

**Purpose:**

Return whether the platform is in FIPS mode


**Details:**

Only available on Windows and Redhat linux family

### `gce`

**Type:** map

**Purpose:**

Return the Google Compute Engine (GCE) metadata.
Please see the [GCE metadata documentation](https://cloud.google.com/compute/docs/metadata) for the contents of this fact.



### `hypervisors`

**Type:** map

**Purpose:**

Experimental fact: Return the names of any detected hypervisors and any collected metadata about them.



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


### `is_virtual`

**Type:** boolean

**Purpose:**

Return whether or not the host is a virtual machine.


### `kernel`

**Type:** string

**Purpose:**

Return the kernel's name.


### `kernelmajversion`

**Type:** string

**Purpose:**

Return the kernel's major version.


### `kernelrelease`

**Type:** string

**Purpose:**

Return the kernel's release.


### `kernelversion`

**Type:** string

**Purpose:**

Return the kernel's version.


### `ldom`

**Type:** map

**Purpose:**

Return Solaris LDom information from the `virtinfo` utility.


### `load_averages`

**Type:** map

**Purpose:**

Return the load average over the last 1, 5 and 15 minutes.

**Elements:**

* `1m` (double) --- The system load average over the last minute.
* `5m` (double) --- The system load average over the last 5 minutes.
* `15m` (double) --- The system load average over the last 15 minutes.


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
        * `scope6` (string) --- The IPv6 scope for the network interface.
* `ip` (ip) --- The IPv4 address of the default network interface.
* `ip6` (ip6) --- The IPv6 address of the default network interface.
* `mac` (mac) --- The MAC address of the default network interface.
* `mtu` (integer) --- The Maximum Transmission Unit (MTU) of the default network interface.
* `netmask` (ip) --- The IPv4 netmask of the default network interface.
* `netmask6` (ip6) --- The IPv6 netmask of the default network interface.
* `network` (ip) --- The IPv4 network of the default network interface.
* `network6` (ip6) --- The IPv6 network of the default network interface.
* `primary` (string) --- The name of the primary interface.
* `scope6` (string) --- The IPv6 scope of the default network interface.


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
    * `patchlevel` (string) --- The patchlevel of the operating system.
    * `branch` (string) --- The branch the operating system was cut from.
* `selinux` (map) --- Represents information about Security-Enhanced Linux (SELinux).
    * `config_mode` (string) --- The configured SELinux mode.
    * `config_policy` (string) --- The configured SELinux policy.
    * `current_mode` (string) --- The current SELinux mode.
    * `enabled` (boolean) --- True if SELinux is enabled or false if not.
    * `enforced` (boolean) --- True if SELinux policy is enforced or false if not.
    * `policy_version` (string) --- The version of the SELinux policy.
* `windows` (map) --- Represents information about Windows.
    * `edition_id` (string) --- Specify the edition variant. (ServerStandard|Professional|Enterprise)
    * `installation_type` (string) --- Specify the installation type. (Server|Server Core|Client)
    * `product_name` (string) --- Specify the textual product name.
    * `release_id` (string) --- Windows Build Version of the form YYMM.
    * `system32` (string) --- The path to the System32 directory.


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


### `path`

**Type:** string

**Purpose:**

Return the PATH environment variable.


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


### `ruby`

**Type:** map

**Purpose:**

Return information about the Ruby loaded by facter.

**Elements:**

* `platform` (string) --- The platform Ruby was built for.
* `sitedir` (string) --- The path to Ruby's site library directory.
* `version` (string) --- The version of Ruby.


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


### `system_uptime`

**Type:** map

**Purpose:**

Return the system uptime information.

**Elements:**

* `days` (integer) --- The number of complete days the system has been up.
* `hours` (integer) --- The number of complete hours the system has been up.
* `seconds` (integer) --- The number of total seconds the system has been up.
* `uptime` (string) --- The full uptime string.


### `timezone`

**Type:** string

**Purpose:**

Return the system timezone.


### `virtual`

**Type:** string

**Purpose:**

Return the hypervisor name for virtual machines or "physical" for physical machines.


### `xen`

**Type:** map

**Purpose:**

Return metadata for the Xen hypervisor.

**Elements:**

* `domains` (array) --- list of strings identifying active Xen domains.


### `zfs_featurenumbers`

**Type:** string

**Purpose:**

Return the comma-delimited feature numbers for ZFS.


### `zfs_version`

**Type:** string

**Purpose:**

Return the version for ZFS.


### `zpool_featureflags`

**Type:** string

**Purpose:**

Return the comma-delimited feature flags for ZFS storage pools.


### `zpool_featurenumbers`

**Type:** string

**Purpose:**

Return the comma-delimited feature numbers for ZFS storage pools.


### `zpool_version`

**Type:** string

**Purpose:**

Return the version for ZFS storage pools.


### `nim_type`

**Type:** string

**Purpose:**

Tells if the node is master or standalone inside an AIX Nim environment.


**Details:**

Is Available only on AIX.

## Legacy Facts

### `architecture`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the operating system's hardware architecture.


### `augeasversion`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the version of augeas.


### `blockdevices`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return a comma-separated list of block devices.


### `blockdevice_<devicename>_model`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the model name of block devices attached to the system.


### `blockdevice_<devicename>_size`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** integer

**Purpose:**

Return the size of a block device in bytes.


### `blockdevice_<devicename>_vendor`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the vendor name of block devices attached to the system.


### `bios_release_date`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the release date of the system BIOS.


### `bios_vendor`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the vendor of the system BIOS.


### `bios_version`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the version of the system BIOS.


### `boardassettag`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the system board asset tag.


### `boardmanufacturer`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the system board manufacturer.


### `boardproductname`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the system board product name.


### `boardserialnumber`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the system board serial number.


### `chassisassettag`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the system chassis asset tag.


### `chassistype`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the system chassis type.


### `dhcp_servers`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** map

**Purpose:**

Return the DHCP servers for the system.

**Elements:**

* `<interface>` (ip) --- The DHCP server for the interface.
* `system` (ip) --- The DHCP server for the default interface.


### `domain`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the network domain of the system.


### `fqdn`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the fully qualified domain name (FQDN) of the system.


### `gid`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the group identifier (GID) of the user running facter.


### `hardwareisa`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the hardware instruction set architecture (ISA).


### `hardwaremodel`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the operating system's hardware model.


### `hostname`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the host name of the system.


### `id`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the user identifier (UID) of the user running facter.


### `interfaces`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the comma-separated list of network interface names.


### `ipaddress`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** ip

**Purpose:**

Return the IPv4 address for the default network interface.


### `ipaddress6`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** ip6

**Purpose:**

Return the IPv6 address for the default network interface.


### `ipaddress6_<interface>`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** ip6

**Purpose:**

Return the IPv6 address for a network interface.


### `ipaddress_<interface>`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** ip

**Purpose:**

Return the IPv4 address for a network interface.


### `ldom_<name>`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return Solaris LDom information.


### `lsbdistcodename`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the Linux Standard Base (LSB) distribution code name.


### `lsbdistdescription`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the Linux Standard Base (LSB) distribution description.


### `lsbdistid`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the Linux Standard Base (LSB) distribution identifier.


### `lsbdistrelease`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the Linux Standard Base (LSB) distribution release.


### `lsbmajdistrelease`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the Linux Standard Base (LSB) major distribution release.


### `lsbminordistrelease`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the Linux Standard Base (LSB) minor distribution release.


### `lsbrelease`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the Linux Standard Base (LSB) release.


### `macaddress`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** mac

**Purpose:**

Return the MAC address for the default network interface.


### `macaddress_<interface>`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** mac

**Purpose:**

Return the MAC address for a network interface.


### `macosx_buildversion`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the Mac OSX build version.


### `macosx_productname`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the Mac OSX product name.


### `macosx_productversion`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the Mac OSX product version.


### `macosx_productversion_major`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the Mac OSX product major version.


### `macosx_productversion_minor`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the Mac OSX product minor version.


### `manufacturer`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the system manufacturer.


### `memoryfree`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the display size of the free system memory, such as "1 GiB".


### `memoryfree_mb`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** double

**Purpose:**

Return the size of the free system memory, in mebibytes.


### `memorysize`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the display size of the total system memory, such as "1 GiB".


### `memorysize_mb`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** double

**Purpose:**

Return the size of the total system memory, in mebibytes.


### `mtu_<interface>`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** integer

**Purpose:**

Return the Maximum Transmission Unit (MTU) for a network interface.


### `netmask`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** ip

**Purpose:**

Return the IPv4 netmask for the default network interface.


### `netmask6`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** ip6

**Purpose:**

Return the IPv6 netmask for the default network interface.


### `netmask6_<interface>`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** ip6

**Purpose:**

Return the IPv6 netmask for a network interface.


### `netmask_<interface>`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** ip

**Purpose:**

Return the IPv4 netmask for a network interface.


### `network`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** ip

**Purpose:**

Return the IPv4 network for the default network interface.


### `network6`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** ip6

**Purpose:**

Return the IPv6 network for the default network interface.


### `network6_<interface>`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** ip6

**Purpose:**

Return the IPv6 network for a network interface.


### `network_<interface>`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** ip

**Purpose:**

Return the IPv4 network for a network interface.


### `operatingsystem`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the name of the operating system.


### `operatingsystemmajrelease`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the major release of the operating system.


### `operatingsystemrelease`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the release of the operating system.


### `osfamily`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the family of the operating system.


### `physicalprocessorcount`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** integer

**Purpose:**

Return the count of physical processors.


### `processor<N>`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the model string of processor N.


### `processorcount`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** integer

**Purpose:**

Return the count of logical processors.


### `productname`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the system product name.


### `rubyplatform`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the platform Ruby was built for.


### `rubysitedir`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the path to Ruby's site library directory.


### `rubyversion`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the version of Ruby.


### `scope6`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the IPv6 scope for the default network interface.


### `scope6_<interface>`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the IPv6 scope for the default network interface.


### `selinux`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** boolean

**Purpose:**

Return whether Security-Enhanced Linux (SELinux) is enabled.


### `selinux_config_mode`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the configured Security-Enhanced Linux (SELinux) mode.


### `selinux_config_policy`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the configured Security-Enhanced Linux (SELinux) policy.


### `selinux_current_mode`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the current Security-Enhanced Linux (SELinux) mode.


### `selinux_enforced`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** boolean

**Purpose:**

Return whether Security-Enhanced Linux (SELinux) is enforced.


### `selinux_policyversion`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the Security-Enhanced Linux (SELinux) policy version.


### `serialnumber`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the system product serial number.


### `sp_<name>`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return Mac OSX system profiler information.


### `ssh<algorithm>key`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the SSH public key for the algorithm.


### `sshfp_<algorithm>`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the SSH fingerprints for the algorithm's public key.


### `swapencrypted`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** boolean

**Purpose:**

Return whether or not the swap is encrypted.


### `swapfree`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the display size of the free swap memory, such as "1 GiB".


### `swapfree_mb`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** double

**Purpose:**

Return the size of the free swap memory, in mebibytes.


### `swapsize`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the display size of the total swap memory, such as "1 GiB".


### `swapsize_mb`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** double

**Purpose:**

Return the size of the total swap memory, in mebibytes.


### `windows_edition_id`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the type of Windows edition, Server or Desktop Edition variant.


### `windows_installation_type`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return Windows installation type (Server|Server Core|Client).


### `windows_product_name`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return Windows textual product name.


### `windows_release_id`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return Windows Build Version of the form YYMM.


### `system32`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the path to the System32 directory on Windows.


### `uptime`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the system uptime.


### `uptime_days`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** integer

**Purpose:**

Return the system uptime days.


### `uptime_hours`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** integer

**Purpose:**

Return the system uptime hours.


### `uptime_seconds`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** integer

**Purpose:**

Return the system uptime seconds.


### `uuid`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the system product unique identifier.


### `xendomains`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return a list of comma-separated active Xen domain names.


### `zone_<name>_brand`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the brand for the Solaris zone.


### `zone_<name>_iptype`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the IP type for the Solaris zone.


### `zone_<name>_name`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the name for the Solaris zone.


### `zone_<name>_uuid`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the unique identifier for the Solaris zone.


### `zone_<name>_id`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the zone identifier for the Solaris zone.


### `zone_<name>_path`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the zone path for the Solaris zone.


### `zone_<name>_status`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the zone state for the Solaris zone.


### `zonename`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** string

**Purpose:**

Return the name of the current Solaris zone.


### `zones`

This legacy fact is hidden by default in Facter's command-line output.

**Type:** integer

**Purpose:**

Return the count of Solaris zones.


