---
layout: default
built_from_commit: ca4d947a102453a17a819a94bd01bac97f83c7e6
title: 'Resource Type: mount'
canonical: "/puppet/latest/types/mount.html"
---

> **NOTE:** This page was generated from the Puppet source code on 2017-01-31 13:37:40 -0600

mount
-----

* [Attributes](#mount-attributes)
* [Providers](#mount-providers)
* [Provider Features](#mount-provider-features)

<h3 id="mount-description">Description</h3>

Manages mounted filesystems, including putting mount
information into the mount table. The actual behavior depends
on the value of the 'ensure' parameter.

**Refresh:** `mount` resources can respond to refresh events (via
`notify`, `subscribe`, or the `~>` arrow). If a `mount` receives an event
from another resource **and** its `ensure` attribute is set to `mounted`,
Puppet will try to unmount then remount that filesystem.

**Autorequires:** If Puppet is managing any parents of a mount resource ---
that is, other mount points higher up in the filesystem --- the child
mount will autorequire them.

**Autobefores:**  If Puppet is managing any child file paths of a mount
point, the mount resource will autobefore them.

<h3 id="mount-attributes">Attributes</h3>

<pre><code>mount { 'resource title':
  <a href="#mount-attribute-name">name</a>        =&gt; <em># <strong>(namevar)</strong> The mount path for the...</em>
  <a href="#mount-attribute-ensure">ensure</a>      =&gt; <em># Control what to do with this mount. Set this...</em>
  <a href="#mount-attribute-atboot">atboot</a>      =&gt; <em># Whether to mount the mount at boot.  Not all...</em>
  <a href="#mount-attribute-blockdevice">blockdevice</a> =&gt; <em># The device to fsck.  This is property is only...</em>
  <a href="#mount-attribute-device">device</a>      =&gt; <em># The device providing the mount.  This can be...</em>
  <a href="#mount-attribute-dump">dump</a>        =&gt; <em># Whether to dump the mount.  Not all platform...</em>
  <a href="#mount-attribute-fstype">fstype</a>      =&gt; <em># The mount type.  Valid values depend on the...</em>
  <a href="#mount-attribute-options">options</a>     =&gt; <em># A single string containing options for the...</em>
  <a href="#mount-attribute-pass">pass</a>        =&gt; <em># The pass in which the mount is...</em>
  <a href="#mount-attribute-provider">provider</a>    =&gt; <em># The specific backend to use for this `mount...</em>
  <a href="#mount-attribute-remounts">remounts</a>    =&gt; <em># Whether the mount can be remounted  `mount -o...</em>
  <a href="#mount-attribute-target">target</a>      =&gt; <em># The file in which to store the mount table....</em>
  # ...plus any applicable <a href="{{puppet}}/metaparameter.html">metaparameters</a>.
}</code></pre>

<h4 id="mount-attribute-name">name</h4>

_(**Namevar:** If omitted, this attribute's value defaults to the resource's title.)_

The mount path for the mount.

([↑ Back to mount attributes](#mount-attributes))

<h4 id="mount-attribute-ensure">ensure</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Control what to do with this mount. Set this attribute to
`unmounted` to make sure the filesystem is in the filesystem table
but not mounted (if the filesystem is currently mounted, it will be
unmounted).  Set it to `absent` to unmount (if necessary) and remove
the filesystem from the fstab.  Set to `mounted` to add it to the
fstab and mount it. Set to `present` to add to fstab but not change
mount/unmount status.

Valid values are `defined` (also called `present`), `unmounted`, `absent`, `mounted`.

([↑ Back to mount attributes](#mount-attributes))

<h4 id="mount-attribute-atboot">atboot</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Whether to mount the mount at boot.  Not all platforms
support this.

([↑ Back to mount attributes](#mount-attributes))

<h4 id="mount-attribute-blockdevice">blockdevice</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The device to fsck.  This is property is only valid
on Solaris, and in most cases will default to the correct
value.

([↑ Back to mount attributes](#mount-attributes))

<h4 id="mount-attribute-device">device</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The device providing the mount.  This can be whatever
device is supporting by the mount, including network
devices or devices specified by UUID rather than device
path, depending on the operating system.

([↑ Back to mount attributes](#mount-attributes))

<h4 id="mount-attribute-dump">dump</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Whether to dump the mount.  Not all platform support this.
Valid values are `1` or `0` (or `2` on FreeBSD). Default is `0`.

Values can match `/(0|1)/`.

([↑ Back to mount attributes](#mount-attributes))

<h4 id="mount-attribute-fstype">fstype</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The mount type.  Valid values depend on the
operating system.  This is a required option.

([↑ Back to mount attributes](#mount-attributes))

<h4 id="mount-attribute-options">options</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

A single string containing options for the mount, as they would
appear in fstab. For many platforms this is a comma delimited string.
Consult the fstab(5) man page for system-specific details.

([↑ Back to mount attributes](#mount-attributes))

<h4 id="mount-attribute-pass">pass</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The pass in which the mount is checked.

([↑ Back to mount attributes](#mount-attributes))

<h4 id="mount-attribute-provider">provider</h4>

The specific backend to use for this `mount`
resource. You will seldom need to specify this --- Puppet will usually
discover the appropriate provider for your platform.

Available providers are:

* [`parsed`](#mount-provider-parsed)

([↑ Back to mount attributes](#mount-attributes))

<h4 id="mount-attribute-remounts">remounts</h4>

Whether the mount can be remounted  `mount -o remount`.  If
this is false, then the filesystem will be unmounted and remounted
manually, which is prone to failure.

Valid values are `true`, `false`.

([↑ Back to mount attributes](#mount-attributes))

<h4 id="mount-attribute-target">target</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The file in which to store the mount table.  Only used by
those providers that write to disk.

([↑ Back to mount attributes](#mount-attributes))


<h3 id="mount-providers">Providers</h3>

<h4 id="mount-provider-parsed">parsed</h4>

* Required binaries: `mount`, `umount`.
* Supported features: `refreshable`.

<h3 id="mount-provider-features">Provider Features</h3>

Available features:

* `refreshable` --- The provider can remount the filesystem.

Provider support:

<table>
  <thead>
    <tr>
      <th>Provider</th>
      <th>refreshable</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>parsed</td>
      <td><em>X</em> </td>
    </tr>
  </tbody>
</table>



> **NOTE:** This page was generated from the Puppet source code on 2017-01-31 13:37:40 -0600