---
layout: default
built_from_commit: 4e0b2b9b2c68e41c386308d71d23d9b26fbfa154
title: 'Resource Type: group'
canonical: /puppet/latest/reference/types/group.html
---

> **NOTE:** This page was generated from the Puppet source code on 2016-08-10 20:10:55 -0500

group
-----

* [Attributes](#group-attributes)
* [Providers](#group-providers)
* [Provider Features](#group-provider-features)

<h3 id="group-description">Description</h3>

Manage groups. On most platforms this can only create groups.
Group membership must be managed on individual users.

On some platforms such as OS X, group membership is managed as an
attribute of the group, not the user record. Providers must have
the feature 'manages_members' to manage the 'members' property of
a group record.

<h3 id="group-attributes">Attributes</h3>

<pre><code>group { 'resource title':
  <a href="#group-attribute-name">name</a>                 =&gt; <em># <strong>(namevar)</strong> The group name. While naming limitations vary by </em>
  <a href="#group-attribute-ensure">ensure</a>               =&gt; <em># Create or remove the group.  Valid values are...</em>
  <a href="#group-attribute-allowdupe">allowdupe</a>            =&gt; <em># Whether to allow duplicate GIDs. Defaults to...</em>
  <a href="#group-attribute-attribute_membership">attribute_membership</a> =&gt; <em># Whether specified attribute value pairs should...</em>
  <a href="#group-attribute-attributes">attributes</a>           =&gt; <em># Specify group AIX attributes in an array of...</em>
  <a href="#group-attribute-auth_membership">auth_membership</a>      =&gt; <em># Whether the provider is authoritative for group...</em>
  <a href="#group-attribute-forcelocal">forcelocal</a>           =&gt; <em># Forces the management of local accounts when...</em>
  <a href="#group-attribute-gid">gid</a>                  =&gt; <em># The group ID.  Must be specified numerically....</em>
  <a href="#group-attribute-ia_load_module">ia_load_module</a>       =&gt; <em># The name of the I&A module to use to manage this </em>
  <a href="#group-attribute-members">members</a>              =&gt; <em># The members of the group. For directory services </em>
  <a href="#group-attribute-provider">provider</a>             =&gt; <em># The specific backend to use for this `group...</em>
  <a href="#group-attribute-system">system</a>               =&gt; <em># Whether the group is a system group with lower...</em>
  # ...plus any applicable <a href="{{puppet}}/metaparameter.html">metaparameters</a>.
}</code></pre>

<h4 id="group-attribute-name">name</h4>

_(**Namevar:** If omitted, this attribute's value defaults to the resource's title.)_

The group name. While naming limitations vary by operating system,
it is advisable to restrict names to the lowest common denominator,
which is a maximum of 8 characters beginning with a letter.

Note that Puppet considers group names to be case-sensitive, regardless
of the platform's own rules; be sure to always use the same case when
referring to a given group.

([↑ Back to group attributes](#group-attributes))

<h4 id="group-attribute-ensure">ensure</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Create or remove the group.

Valid values are `present`, `absent`.

([↑ Back to group attributes](#group-attributes))

<h4 id="group-attribute-allowdupe">allowdupe</h4>

Whether to allow duplicate GIDs. Defaults to `false`.

Valid values are `true`, `false`, `yes`, `no`.

([↑ Back to group attributes](#group-attributes))

<h4 id="group-attribute-attribute_membership">attribute_membership</h4>

Whether specified attribute value pairs should be treated as the only attributes
of the user or whether they should merely
be treated as the minimum list.

Valid values are `inclusive`, `minimum`.

([↑ Back to group attributes](#group-attributes))

<h4 id="group-attribute-attributes">attributes</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Specify group AIX attributes in an array of `key=value` pairs.



Requires features manages_aix_lam.

([↑ Back to group attributes](#group-attributes))

<h4 id="group-attribute-auth_membership">auth_membership</h4>

Whether the provider is authoritative for group membership. This
must be set to true to allow setting the group to no members with
`members => [],`.

Valid values are `true`, `false`, `yes`, `no`.

([↑ Back to group attributes](#group-attributes))

<h4 id="group-attribute-forcelocal">forcelocal</h4>

Forces the management of local accounts when accounts are also
being managed by some other NSS

Valid values are `true`, `false`, `yes`, `no`.

Requires features libuser.

([↑ Back to group attributes](#group-attributes))

<h4 id="group-attribute-gid">gid</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The group ID.  Must be specified numerically.  If no group ID is
specified when creating a new group, then one will be chosen
automatically according to local system standards. This will likely
result in the same group having different GIDs on different systems,
which is not recommended.

On Windows, this property is read-only and will return the group's security
identifier (SID).

([↑ Back to group attributes](#group-attributes))

<h4 id="group-attribute-ia_load_module">ia_load_module</h4>

The name of the I&A module to use to manage this user



Requires features manages_aix_lam.

([↑ Back to group attributes](#group-attributes))

<h4 id="group-attribute-members">members</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The members of the group. For directory services where group
membership is stored in the group objects, not the users. Use
with auth_membership to determine whether the specified members
are inclusive or the minimum.



Requires features manages_members.

([↑ Back to group attributes](#group-attributes))

<h4 id="group-attribute-provider">provider</h4>

The specific backend to use for this `group`
resource. You will seldom need to specify this --- Puppet will usually
discover the appropriate provider for your platform.

Available providers are:

* [`aix`](#group-provider-aix)
* [`directoryservice`](#group-provider-directoryservice)
* [`groupadd`](#group-provider-groupadd)
* [`ldap`](#group-provider-ldap)
* [`pw`](#group-provider-pw)
* [`windows_adsi`](#group-provider-windows_adsi)

([↑ Back to group attributes](#group-attributes))

<h4 id="group-attribute-system">system</h4>

Whether the group is a system group with lower GID.

Valid values are `true`, `false`, `yes`, `no`.

([↑ Back to group attributes](#group-attributes))


<h3 id="group-providers">Providers</h3>

<h4 id="group-provider-aix">aix</h4>

Group management for AIX.

* Required binaries: `/usr/bin/chgroup`, `/usr/bin/mkgroup`, `/usr/sbin/lsgroup`, `/usr/sbin/rmgroup`.
* Default for `operatingsystem` == `aix`.
* Supported features: `manages_aix_lam`, `manages_members`.

<h4 id="group-provider-directoryservice">directoryservice</h4>

Group management using DirectoryService on OS X.

* Required binaries: `/usr/bin/dscl`.
* Default for `operatingsystem` == `darwin`.
* Supported features: `manages_members`.

<h4 id="group-provider-groupadd">groupadd</h4>

Group management via `groupadd` and its ilk. The default for most platforms.

* Required binaries: `groupadd`, `groupdel`, `groupmod`, `lgroupadd`.
* Supported features: `system_groups`.

<h4 id="group-provider-ldap">ldap</h4>

Group management via LDAP.

This provider requires that you have valid values for all of the
LDAP-related settings in `puppet.conf`, including `ldapbase`.  You will
almost definitely need settings for `ldapuser` and `ldappassword` in order
for your clients to write to LDAP.

Note that this provider will automatically generate a GID for you if you do
not specify one, but it is a potentially expensive operation, as it
iterates across all existing groups to pick the appropriate next one.

<h4 id="group-provider-pw">pw</h4>

Group management via `pw` on FreeBSD and DragonFly BSD.

* Required binaries: `pw`.
* Default for `operatingsystem` == `freebsd, dragonfly`.
* Supported features: `manages_members`.

<h4 id="group-provider-windows_adsi">windows_adsi</h4>

Local group management for Windows. Group members can be both users and groups.
Additionally, local groups can contain domain users.

* Default for `operatingsystem` == `windows`.
* Supported features: `manages_members`.

<h3 id="group-provider-features">Provider Features</h3>

Available features:

* `libuser` --- Allows local groups to be managed on systems that also use some other remote NSS method of managing accounts.
* `manages_aix_lam` --- The provider can manage AIX Loadable Authentication Module (LAM) system.
* `manages_members` --- For directories where membership is an attribute of groups not users.
* `system_groups` --- The provider allows you to create system groups with lower GIDs.

Provider support:

<table>
  <thead>
    <tr>
      <th>Provider</th>
      <th>libuser</th>
      <th>manages aix lam</th>
      <th>manages members</th>
      <th>system groups</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>aix</td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
    </tr>
    <tr>
      <td>directoryservice</td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
    </tr>
    <tr>
      <td>groupadd</td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
    </tr>
    <tr>
      <td>ldap</td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
    </tr>
    <tr>
      <td>pw</td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
    </tr>
    <tr>
      <td>windows_adsi</td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
    </tr>
  </tbody>
</table>



> **NOTE:** This page was generated from the Puppet source code on 2016-08-10 20:10:55 -0500