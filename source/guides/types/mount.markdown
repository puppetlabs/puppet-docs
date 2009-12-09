mount
=====

Manages mounted filesystems

* Mounts/unmounts filesystems.
* Persists mount information in the mount table.

* * *

Background
----------

The actual behavior depends on the value of
the [`ensure`][ensure] parameter.

Requirements
-------------

No additional requirements.

Platforms
---------

Supported on all platforms with the `mount` and `umount` executables
needed by the [provider][provider].

Version Compatibility
---------------------

{TODO}

Examples
--------

{TODO}

Parameters
----------

### `atboot`

Whether to mount the mount at boot. Not all platforms support
this.

### `blockdevice`

The device to fsck. This is property is only valid on Solaris, and
in most cases will default to the correct value.

### `device`

The device providing the mount. This can be whatever device is
supporting by the mount, including network devices or devices
specified by UUID rather than device path, depending on the
operating system.

### `dump`

Whether to dump the mount. Not all platforms + support this. Valid
values are `1` or `0`. or `2` on FreeBSD, Default is `0`. Values
can match `/(0|1)/`, `/(0|1)/`.

### `ensure`

Control what to do with this mount. Set this attribute to `present`
to make sure the filesystem is in the filesystem table but not
mounted (if the filesystem is currently mounted, it will be
unmounted). Set it to `absent` to unmount (if necessary) and remove
the filesystem from the fstab. Set to `mounted` to add it to the
fstab and mount it. Valid values are `present` (also called
`unmounted`), `absent`, `mounted`.

NOTE: If a `mount` receives an event from another resource, it
will try to remount the filesystems if `ensure` is set to
`mounted`.

### `fstype`

The mount type. Valid values depend on the operating system.

### `name`

The mount path for the mount.

INFO: This is the `namevar` for this resource type.

### `options`

Mount options for the mounts, as they would appear in the fstab.

### `pass`

The pass in which the mount is checked.

### `path`

WARNING: The deprecated name for the mount point. Please use `name`.

{TODO}

### `provider`

The specific backend for provider to use. You will seldom need to
specify this -- Puppet will usually discover the appropriate
provider for your platform. Available providers are:

#### `parsed`

Required binaries:

* `mount`
* `umount`

### `remounts`

Whether the mount can be remounted with:

    mount -o remount
{:shell}

If this is `false`, then the filesystem will be unmounted and remounted
manually, which is prone to failure. Valid values are `true`, `false`.

### `target`

The file in which to store the mount table. Only used by those
providers that write to disk.
