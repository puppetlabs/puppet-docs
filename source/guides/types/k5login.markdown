---
layout: default
title: k5login
---

k5login
=======

Manage the `.k5login` file for a user.

* * *

{GENERIC}

Examples
--------

    k5login { "/tmp/k5login-example":
        principals => ["test1@example", "test2@example"]
    }
{:puppet}

Parameters
----------

Specify the full path to the `.k5login` file as the name and an array
of principals as the property principals.

### `ensure`

The basic property that the resource should be in. Valid values are
`present`, `absent`.

### `mode`

Manage the k5login file's mode

### `path`

The path to the file to manage. Must be fully qualified.

INFO: This is the `namevar` for this resource type.

### `principals`

The principals present in the `.k5login` file.

### provider

The specific backend for provider to use. You will seldom need to
specify this -- Puppet will usually discover the appropriate
provider for your platform. Available providers are:

#### `k5login`

The k5login provider is the only provider for the k5login resource type.
