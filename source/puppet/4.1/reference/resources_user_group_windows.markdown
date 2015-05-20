---
layout: default
title: "Resource Tips and Examples: User and Group on Windows"
---

[user]: /references/4.1.latest/type.html#user
[group]: /references/4.1.latest/type.html#group
[relationships]: /puppet/4.1.latest/reference/lang_relationships.html
[auth_membership]: /references/latest/type.html#group-attribute-auth_membership

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

[members]: /references/4.1.latest/type.html#group-attribute-members

You can also use the [auth_membership attribute][auth_membership] to help manage members. Before Puppet 4.1.0, if you had a system with other accounts on it, Puppet would remove any members that weren’t in the manifest. Now with the `auth_membership` attribute set to `false`, the default setting, Puppet will make sure that a group contains as many members as are listed in the manifest. Setting `auth_membership` to `true` makes the list of members in the manifest the authoritative list of members in a group.

### Allowed Attributes

The `user` type in particular has a lot of attributes that don't apply to Windows systems.

When managing Windows [**user**][user] accounts, you can use the following attributes:

* [`name`](/references/4.1.latest/type.html#user-attribute-name)
* [`ensure`](/references/4.1.latest/type.html#user-attribute-ensure)
* [`comment`](/references/4.1.latest/type.html#user-attribute-comment)
* [`groups`](/references/4.1.latest/type.html#user-attribute-groups) --- note that you can't use the `gid` attribute.
* [`home`](/references/4.1.latest/type.html#user-attribute-home)
* [`managehome`](/references/4.1.latest/type.html#user-attribute-managehome)
* [`password`](/references/4.1.latest/type.html#user-attribute-password) --- note that passwords can only be specified in cleartext, since Windows has no API for setting the password hash.

Additionally, the `uid` attribute is available as a read-only property when inspecting a user with `puppet resource user <NAME>`. Its value will be the user's SID (see below).

When managing Windows [**group**][group] accounts, you can use the following attributes:

* [`name`](/references/4.1.latest/type.html#group-attribute-name)
* [`ensure`](/references/4.1.latest/type.html#group-attribute-ensure)
* [`members`](/references/4.1.latest/type.html#group-attribute-members)
* [`auth_membership`][auth_membership]

Additionally, the `gid` attribute is available as a read-only property when inspecting a group with `puppet resource group <NAME>`. Its value will be the group's SID (see below).

## Names and Security Identifiers (SIDs)

On Windows, user and group account names can take multiple forms, e.g. `Administrators`, `<host>\Administrators`, `BUILTIN\Administrators`, `S-1-5-32-544` --- the last is called a security identifier (SID). Puppet treats all these forms as equivalent: when comparing two account names, it first transforms account names into their canonical SID form and compares the SIDs instead.

If you need to refer to a user or group in multiple places in a manifest (e.g. when creating [relationships between resources][relationships]), be consistent with the case of the name. Names are case-sensitive in Puppet manifests, but case-insensitive on Windows. It's important that the cases match, however, because autorequire will attempt to match users with fully qualified names (User[BUILTIN\Administrators]) in addition to SIDs (User[S-1-5-32-544]). It might not match in cases where domain accounts and local accounts have the same name, such as Domain\Bob versus LOCAL\Bob.

>**Note**: For reporting and for `puppet resource`, groups always come back in fully qualified form when describing a user, so it looks like `BUILTIN\Administrators`. In other words, it doesn’t always look the same as in the manifest.

## Errata

### Known Issues Prior to Puppet 3.4 / PE 3.2

Before Puppet 3.4 / Puppet Enterprise 3.2, Puppet could not:

* Add/remove domain users to a local group
* Add/remove groups to a local group
