computer
========

Computer object management using DirectoryService on OS X.

* Manages Computer objects in the local directory service domain.
* This type primarily exists to create localhost Computer objects to which MCX policy can then be attached.

* * *

Requirements
-------------

No additional requirements.

Platforms
---------

Only supported on OSX (`$operatingsystem == 'darwin'`)

NOTE: Note that these are distinctly different kinds of objects to
[hosts](host.html), as they require a MAC address and can have all sorts of
policy attached to them. If you wish to manage `/etc/hosts` on Mac 
OSX,then simply use the [host type](host.html) as per other platforms.


Version Compatibility
---------------------

`TODO`

Examples
--------

`TODO`

Parameters
----------

### `en_address`

The MAC address of the primary network interface. Must match `en0`.

### `ensure`

Control the existences of this computer record. Set this attribute
to `present` to ensure the computer record exists. Set it to
`absent` to delete any computer records with this name Valid values
are `present`, `absent`.

### `ip_address`

The IP Address of the Computer object.

### `name`

The authoritative 'short' name of the computer record.

INFO: This is the `namevar` for this resource type.

### `provider`

The specific backend for provider to use. You will seldom need to
specify this -- Puppet will usually discover the appropriate
provider for your platform. Available providers are:

#### `directoryservice`

Computer object management using DirectoryService on OS X

### `realname`

The 'long' name of the computer record.
