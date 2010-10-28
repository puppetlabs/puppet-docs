---
layout: default
title: host
---

host
====

Installs and manages host entries.

* For most systems, these entries will just be in `/etc/hosts`, but some systems (notably OS X) will have different solutions.

* * *

{GENERIC}

Examples
--------

    host { 'peer':
        ip => '192.168.1.121',
        host_aliases => [ "foo", "bar" ],
        ensure => 'present',
    }
{:puppet}


Parameters
----------

### `host_aliases`

Any aliases the host might have. Multiple values must be specified as
an array

### `ensure`

The basic property that the resource should be in. Valid values are
`present`, `absent`.

### `ip`

The host's IP address, IPv4 or IPv6.

### `name`

The host name.

INFO: This is the `namevar` for this resource type.

### `provider`

The specific backend for provider to use. You will seldom need to
specify this -- Puppet will usually discover the appropriate
provider for your platform. Available providers are:

#### `parsed`

The default provider.

### `target`

The file in which to store service information. Only used by those
providers that write to disk.
