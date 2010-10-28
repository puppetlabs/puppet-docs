---
layout: default
title: zfs
---

zfs
===

* * *

Manage zfs. Create destroy and set properties on zfs instances.

### Parameters

#### compression

The compression property.

#### copies

The copies property.

#### ensure

The basic property that the resource should be in. Valid values are
`present`, `absent`.

#### mountpoint

The mountpoint property.

#### name

-   **namevar**

The full name for this filesystem. (including the zpool)

#### provider

The specific backend for provider to use. You will seldom need to
specify this -- Puppet will usually discover the appropriate
provider for your platform. Available providers are:

-   **solaris**: Provider for Solaris zfs. Required binaries:
    `/usr/sbin/zfs`. Default for `operatingsystem` == `solaris`.

#### quota

The quota property.

#### reservation

The reservation property.

#### sharenfs

The sharenfs property.

#### snapdir

The sharenfs property.


* * * * *

