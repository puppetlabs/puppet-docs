selboolean
==========

Manages SELinux booleans on systems with SELinux support.

* The supported booleans are any of the ones found in `/selinux/booleans/`

* * *

* * *

Parameters
==========

## name

-   **namevar**

The name of the SELinux boolean to be managed.

## persistent

If set true, SELinux booleans will be written to disk and persist
accross reboots. The default is `false`. Valid values are `true`,
`false`.

## provider

The specific backend for provider to use. You will seldom need to
specify this -- Puppet will usually discover the appropriate
provider for your platform. Available providers are:

-   **getsetsebool**: Manage SELinux booleans using the getsebool
    and setsebool binaries. Required binaries: `/usr/sbin/getsebool`,
    `/usr/sbin/setsebool`.

## value

Whether the the SELinux boolean should be enabled or disabled.
Valid values are `on`, `off`.


* * * * *

