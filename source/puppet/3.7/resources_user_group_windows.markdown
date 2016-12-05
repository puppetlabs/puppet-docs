---
layout: default
title: "Resource Tips and Examples: User and Group on Windows"
---

[user]: ./type.html#user
[group]: ./type.html#group
[relationships]: /puppet/3.7.latest/reference/lang_relationships.html

Puppet's built-in [`user`][user] and [`group`][group] resource types can manage user and group accounts on Windows.

These resource types were originally developed for \*nix systems, and have a few unusual behaviors on Windows. Here's what you'll want to know before using them.

## What Puppet Can Manage

### Local User/Group Resources

Puppet can use the `user` and `group` resource types to manage **local** accounts.

You can't write a Puppet resource that describes a **domain** user or group. However, a local `group` resource can manage which domain users are members of that local group. See the next section for details.

### Group Membership

Puppet can use [the `members` attribute][members] of the [`group`][group] type to manage the members of a group.

A local group can include both local and domain users, so while you can't use Puppet to _manage_ domain users, you can use it to manage their local groups.

Groups can also include other groups as members.

[members]: ./type.html#group-attribute-members

### Allowed Attributes

The `user` type in particular has a lot of attributes that don't apply to Windows systems.

When managing Windows [**user**][user] accounts, you can use the following attributes:

* [`name`](./type.html#user-attribute-name)
* [`ensure`](./type.html#user-attribute-ensure)
* [`comment`](./type.html#user-attribute-comment)
* [`groups`](./type.html#user-attribute-groups) --- note that you can't use the `gid` attribute.
* [`home`](./type.html#user-attribute-home)
* [`managehome`](./type.html#user-attribute-managehome)
* [`password`](./type.html#user-attribute-password) --- note that passwords can only be specified in cleartext, since Windows has no API for setting the password hash.

Additionally, the `uid` attribute is available as a read-only property when inspecting a user with `puppet resource user <NAME>`. Its value will be the user's SID (see below).

When managing Windows [**group**][group] accounts, you can use the following attributes:

* [`name`](./type.html#group-attribute-name)
* [`ensure`](./type.html#group-attribute-ensure)
* [`members`](./type.html#group-attribute-members)

Additionally, the `gid` attribute is available as a read-only property when inspecting a group with `puppet resource group <NAME>`. Its value will be the group's SID (see below).

## Names and Security Identifiers (SIDs)

On Windows, user and group account names can take multiple forms, e.g. `Administrators`, `<host>\Administrators`, `BUILTIN\Administrators`, `S-1-5-32-544` --- the last is called a security identifier (SID). Puppet treats all these forms as equivalent: when comparing two account names, it first transforms account names into their canonical SID form and compares the SIDs instead.

If you need to refer to a user or group in multiple places in a manifest (e.g. when creating [relationships between resources][relationships]), be consistent with the case of the name. Names are case-sensitive in Puppet manifests, but case-insensitive on Windows.

## Errata

### Known Issues Prior to Puppet 3.4 / PE 3.2

Before Puppet 3.4 / Puppet Enterprise 3.2, Puppet could not:

* Add/remove domain users to a local group
* Add/remove groups to a local group
