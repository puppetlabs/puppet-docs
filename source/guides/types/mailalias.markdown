mailalias
=========

Creates an email alias in the local alias database.

* * *

{GENERIC}

Examples
--------

{TODO}

Parameters
----------

### `ensure`

The basic property that the resource should be in. Valid values are
`present`, `absent`.

### `name`

The alias name.

INFO: This is the `namevar` for this resource type.

### `provider`

The specific backend for provider to use. You will seldom need to
specify this -- Puppet will usually discover the appropriate
provider for your platform. Available providers are:

#### `aliases`

### `recipient`

Where email should be sent. Multiple values should be specified as
an array.

### `target`

The file in which to store the aliases. Only used by those
providers that write to disk.
