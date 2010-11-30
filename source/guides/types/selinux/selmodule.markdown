---
layout: default
title: selmodule
---

selmodule
=========

Manages loading and unloading of SELinux policy modules on the
system.

* Requires SELinux support. See `man semodule(8)` for more
information on SELinux policy modules.

* * *

Parameters
----------

## ensure

The basic property that the resource should be in. Valid values are
`present`, `absent`.

## name

-   **namevar**

The name of the SELinux policy to be managed. You should not
include the customary trailing .pp extension.

## provider

The specific backend for provider to use. You will seldom need to
specify this -- Puppet will usually discover the appropriate
provider for your platform. Available providers are:

-   **semodule**: Manage SELinux policy modules using the semodule
    binary. Required binaries: `/usr/sbin/semodule`.

## selmoduledir

The directory to look for the compiled pp module file in. Currently
defaults to /usr/share/selinux/targeted. If selmodulepath is not
specified the module will be looked for in this directory in a in a
file called NAME.pp, where NAME is the value of the name
parameter.

## selmodulepath

The full path to the compiled .pp policy module. You only need to
use this if the module file is not in the directory pointed at by
selmoduledir.

## syncversion

If set to `true`, the policy will be reloaded if the version found
in the on-disk file differs from the loaded version. If set to
`false` (the default) the the only check that will be made is if
the policy is loaded at all or not. Valid values are `true`,
`false`.


* * * * *

