---
layout: default
title: "Resource Tips and Examples: User and Group on Windows"
---

[user]: ./type.html#user
[groups]: ./type.html#user-attribute-groups
[auth_membership_user]: /puppet/latest/type.html#user-attribute-auth_membership
[group]: ./type.html#group
[members]: ./type.html#group-attribute-members
[auth_membership_group]: /puppet/latest/type.html#group-attribute-auth_membership
[relationships]: /puppet/4.3.latest/reference/lang_relationships.html

Puppet's built-in [`user`][user] and [`group`][group] resource types can manage user and group accounts on Windows.

This page describes what you'll want to know before using them.

## What Puppet Can Manage

### Local User/Group Resources

Puppet can use the `user` and `group` resource types to manage **local** accounts.

You can't write a Puppet resource that describes a **domain** user or group. However, a local `group` resource can manage which domain accounts belong to the local group. See the next section for details.

### Group Membership

Windows can manage group membership by specifying the groups to which a user belongs, or specifying the members of a group. Puppet supports both cases.

If Puppet is managing a local [`user`][user], you can list the [`groups`][groups] that the user belongs to. Each group can be a local group account, e.g. `Administrators`, or a domain group account.

If Puppet is managing a local [`group`][group], you can list the [`members`][members] that belong to the group. Each member can be a local account, e.g. `Administrator`, or a domain account, where each account can be a user or group account.

When managing a `user`, Puppet will make sure the user belongs to all of the `groups` listed in the manifest. If the user belongs to a group not specified in the manifest, Puppet will not remove the user from the group.

If you want to ensure a `user` belongs to only the `groups` listed in the manifest, and no more, you can specify the [`auth_membership`][auth_membership_user] attribute for the `user`. If set to `inclusive`, Puppet will remove the user from any group not listed in the manifest.

Similarly, when managing a `group`, Puppet will make sure all of the `members` listed in the manifest are added to the group. Existing members of the group not listed in the manifest will be ignored. If you want to ensure a `group` contains only the `members` listed in the manifest, and no more, you can specify the [`auth_membership`][auth_membership_group] attribute for the `group`. If set to `true`, Puppet will remove existing members of the group that are not listed in the manifest.

### Allowed Attributes

When managing Windows [**user**][user] accounts, you can use the following attributes:

* [`name`](./type.html#user-attribute-name)
* [`ensure`](./type.html#user-attribute-ensure)
* [`comment`](./type.html#user-attribute-comment)
* [`groups`](./type.html#user-attribute-groups) --- note that you can't use the `gid` attribute.
* [`home`](./type.html#user-attribute-home)
* [`managehome`](./type.html#user-attribute-managehome)
* [`password`](./type.html#user-attribute-password) --- note that passwords can only be specified in cleartext, since Windows has no API for setting the password hash.
*[`auth_membership`][auth_membership_user]

Additionally, the `uid` attribute is available as a read-only property when inspecting a user with `puppet resource user <NAME>`. Its value will be the user's SID (see below).

When managing Windows [**group**][group] accounts, you can use the following attributes:

* [`name`](./type.html#group-attribute-name)
* [`ensure`](./type.html#group-attribute-ensure)
* [`members`](./type.html#group-attribute-members)
* [`auth_membership`][auth_membership_group]

Additionally, the `gid` attribute is available as a read-only property when inspecting a group with `puppet resource group <NAME>`. Its value will be the group's SID (see below).

## Names and Security Identifiers (SIDs)

On Windows, user and group account names can take multiple forms, e.g. `Administrators`, `<host>\Administrators`, `BUILTIN\Administrators`, `S-1-5-32-544` --- the last is called a security identifier (SID). Puppet treats all these forms as equivalent: when comparing two account names, it first transforms account names into their canonical SID form and compares the SIDs instead.

If you need to refer to a user or group in multiple places in a manifest (e.g. when creating [relationships between resources][relationships]), be consistent with the case of the name. Names are case-sensitive in Puppet manifests, but case-insensitive on Windows. It's important that the cases match, however, because autorequire will attempt to match users with fully qualified names (`User[BUILTIN\Administrators]`) in addition to SIDs (`User[S-1-5-32-544]`). It might not match in cases where domain accounts and local accounts have the same name, such as `Domain\Bob` versus `LOCAL\Bob`.

>**Note**: For reporting and for `puppet resource`, groups always come back in fully qualified form when describing a user, so it looks like `BUILTIN\Administrators`. In other words, it doesn’t always look the same as in the manifest.

## Errata

### Known Issues Prior to Puppet 4

* Before 4.0, Puppet would, by default, remove members of a group that were not specified in the manifest.

### Known Issues Prior to Puppet 3.4 / PE 3.2

Before Puppet 3.4 / Puppet Enterprise 3.2, Puppet could not:

* Add/remove domain users to a local group
* Add/remove groups to a local group
