---
layout: default
title: zpool
---

zpool
=====

* * *

Manage zpools. Create and delete zpools. The provider WILL NOT
SYNC, only report differences.

Supports vdevs with mirrors, raidz, logs and spares.

### Parameters

#### disk

The disk(s) for this pool. Can be an array or space separated
string

#### ensure

The basic property that the resource should be in. Valid values are
`present`, `absent`.

#### log

Log disks for this pool. (doesn't support mirroring yet)

#### mirror

List of all the devices to mirror for this pool. Each mirror should
be a space separated string. mirror =\> ["disk1 disk2", "disk3
disk4"]

#### pool

-   **namevar**

The name for this pool.

#### provider

The specific backend for provider to use. You will seldom need to
specify this -- Puppet will usually discover the appropriate
provider for your platform. Available providers are:

-   **solaris**: Provider for Solaris zpool. Required binaries:
    `/usr/sbin/zpool`. Default for `operatingsystem` == `solaris`.

#### raid\_parity

Determines parity when using raidz property.

#### raidz

List of all the devices to raid for this pool. Should be an array
of space separated strings. raidz =\> ["disk1 disk2", "disk3
disk4"]

#### spare

Spare disk(s) for this pool.
