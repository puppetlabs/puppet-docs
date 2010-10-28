---
layout: default
title: group
---

group
=====

Manage groups.

* * *

Platforms
---------

Supported on all platforms, though features differ.
See [providers][providers] below for more information.

Version Compatibility
---------------------

{TODO}

Examples
--------

{TODO}

Parameters
----------

### `allowdupe`

Whether to allow duplicate GIDs. This option does not work on
FreeBSD (contract to the `pw` man page). Valid values are `true`,
`false`.

### `auth_membership`

whether the provider is authoritative for group membership.

### `ensure`

Create or remove the group. Valid values are `present`, `absent`.

### `gid`

The group ID. Must be specified numerically. If not specified, a
number will be picked, which can result in ID differences across
systems and thus is not recommended. The GID is picked according to
local system standards.

### `members`

The members of the group. For directory services where group
membership is stored in the group objects, not the users. Requires
features manages\_members.

### `name`

The group name. While naming limitations vary by system, it is
advisable to keep the name to the degenerate limitations, which is
a maximum of 8 characters beginning with a letter.

NOTE: This is the `namevar` for this resource type.

### `provider`

The specific backend for provider to use. You will seldom need to
specify this -- Puppet will usually discover the appropriate
provider for your platform. 

NOTE: On most platforms this can only create groups. Group 
membership must be managed on individual users. On some platforms
such as OS X, group membership is managed as an
attribute of the group, not the user record. Providers must have
the feature `manages_members` to manage the `members` property of
a group record.


<table border="1" class="docutils">
<colgroup>
<col width="52%" />
<col width="48%" />
</colgroup>
<thead valign="bottom">
<tr><th class="head">Provider</th>

<th class="head">manages_members</th>
</tr>
</thead>
<tbody valign="top">
<tr><td>directoryservice</td>
<td><strong>X</strong></td>
</tr>
<tr><td>groupadd</td>
<td>&nbsp;</td>
</tr>
<tr><td>ldap</td>
<td>&nbsp;</td>

</tr>
<tr><td>pw</td>
<td>&nbsp;</td>
</tr>
</tbody>
</table>



Available providers are:

#### `directoryservice`

Group management using DirectoryService.

Required binaries:
* `/usr/bin/dscl`.

NOTE: Default for `operatingsystem` == `darwin`.

INFO: Can manage members of the group (supports the `manages_members` feature).

#### `groupadd`

Group management via `groupadd` and its ilk.

The default for most platforms

Required binaries:
* `groupmod`
* `groupdel`
* `groupadd`

#### `ldap`

Group management via `ldap`.

This provider requires that you have valid values for all of the
ldap-related settings, including `ldapbase`. You will also almost
definitely need settings for `ldapuser` and `ldappassword`, so that
your clients can write to ldap.

NOTE: This provider will automatically generate a GID for you
if you do not specify one, but it is a potentially expensive
operation, as it iterates across all existing groups to pick the
next available GID.

#### `pw`

Group management via `pw`.

Only works on FreeBSD.

Required binaries:

* `/usr/sbin/pw`

NOTE: Default for `operatingsystem` == `freebsd`.
