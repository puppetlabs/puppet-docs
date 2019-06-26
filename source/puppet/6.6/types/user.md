---
layout: default
built_from_commit: 321d3fb313ee6513c02dac363ae3b122b6168281
title: 'Resource Type: user'
canonical: "/puppet/latest/types/user.html"
---

> **NOTE:** This page was generated from the Puppet source code on 2019-06-20 13:09:20 -0700

user
-----

* [Attributes](#user-attributes)
* [Providers](#user-providers)
* [Provider Features](#user-provider-features)

<h3 id="user-description">Description</h3>

Manage users.  This type is mostly built to manage system
users, so it is lacking some features useful for managing normal
users.

This resource type uses the prescribed native tools for creating
groups and generally uses POSIX APIs for retrieving information
about them.  It does not directly modify `/etc/passwd` or anything.

**Autorequires:** If Puppet is managing the user's primary group (as
provided in the `gid` attribute) or any group listed in the `groups`
attribute then the user resource will autorequire that group. If Puppet
is managing any role accounts corresponding to the user's roles, the
user resource will autorequire those role accounts.

<h3 id="user-attributes">Attributes</h3>

<pre><code>user { 'resource title':
  <a href="#user-attribute-name">name</a>                 =&gt; <em># <strong>(namevar)</strong> The user name. While naming limitations vary by...</em>
  <a href="#user-attribute-ensure">ensure</a>               =&gt; <em># The basic state that the object should be in....</em>
  <a href="#user-attribute-allowdupe">allowdupe</a>            =&gt; <em># Whether to allow duplicate UIDs.  Default...</em>
  <a href="#user-attribute-attribute_membership">attribute_membership</a> =&gt; <em># Whether specified attribute value pairs should...</em>
  <a href="#user-attribute-attributes">attributes</a>           =&gt; <em># Specify AIX attributes for the user in an array...</em>
  <a href="#user-attribute-auth_membership">auth_membership</a>      =&gt; <em># Whether specified auths should be considered the </em>
  <a href="#user-attribute-auths">auths</a>                =&gt; <em># The auths the user has.  Multiple auths should...</em>
  <a href="#user-attribute-comment">comment</a>              =&gt; <em># A description of the user.  Generally the user's </em>
  <a href="#user-attribute-expiry">expiry</a>               =&gt; <em># The expiry date for this user. Provide as either </em>
  <a href="#user-attribute-forcelocal">forcelocal</a>           =&gt; <em># Forces the management of local accounts when...</em>
  <a href="#user-attribute-gid">gid</a>                  =&gt; <em># The user's primary group.  Can be specified...</em>
  <a href="#user-attribute-groups">groups</a>               =&gt; <em># The groups to which the user belongs.  The...</em>
  <a href="#user-attribute-home">home</a>                 =&gt; <em># The home directory of the user.  The directory...</em>
  <a href="#user-attribute-ia_load_module">ia_load_module</a>       =&gt; <em># The name of the I&A module to use to manage this </em>
  <a href="#user-attribute-iterations">iterations</a>           =&gt; <em># This is the number of iterations of a chained...</em>
  <a href="#user-attribute-key_membership">key_membership</a>       =&gt; <em># Whether specified key/value pairs should be...</em>
  <a href="#user-attribute-keys">keys</a>                 =&gt; <em># Specify user attributes in an array of key ...</em>
  <a href="#user-attribute-loginclass">loginclass</a>           =&gt; <em># The name of login class to which the user...</em>
  <a href="#user-attribute-managehome">managehome</a>           =&gt; <em># Whether to manage the home directory when Puppet </em>
  <a href="#user-attribute-membership">membership</a>           =&gt; <em># If `minimum` is specified, Puppet will ensure...</em>
  <a href="#user-attribute-password">password</a>             =&gt; <em># The user's password, in whatever encrypted...</em>
  <a href="#user-attribute-password_max_age">password_max_age</a>     =&gt; <em># The maximum number of days a password may be...</em>
  <a href="#user-attribute-password_min_age">password_min_age</a>     =&gt; <em># The minimum number of days a password must be...</em>
  <a href="#user-attribute-password_warn_days">password_warn_days</a>   =&gt; <em># The number of days before a password is going to </em>
  <a href="#user-attribute-profile_membership">profile_membership</a>   =&gt; <em># Whether specified roles should be treated as the </em>
  <a href="#user-attribute-profiles">profiles</a>             =&gt; <em># The profiles the user has.  Multiple profiles...</em>
  <a href="#user-attribute-project">project</a>              =&gt; <em># The name of the project associated with a user.  </em>
  <a href="#user-attribute-provider">provider</a>             =&gt; <em># The specific backend to use for this `user...</em>
  <a href="#user-attribute-purge_ssh_keys">purge_ssh_keys</a>       =&gt; <em># Whether to purge authorized SSH keys for this...</em>
  <a href="#user-attribute-role_membership">role_membership</a>      =&gt; <em># Whether specified roles should be considered the </em>
  <a href="#user-attribute-roles">roles</a>                =&gt; <em># The roles the user has.  Multiple roles should...</em>
  <a href="#user-attribute-salt">salt</a>                 =&gt; <em># This is the 32-byte salt used to generate the...</em>
  <a href="#user-attribute-shell">shell</a>                =&gt; <em># The user's login shell.  The shell must exist...</em>
  <a href="#user-attribute-system">system</a>               =&gt; <em># Whether the user is a system user, according to...</em>
  <a href="#user-attribute-uid">uid</a>                  =&gt; <em># The user ID; must be specified numerically. If...</em>
  # ...plus any applicable <a href="{{puppet}}/metaparameter.html">metaparameters</a>.
}</code></pre>

<h4 id="user-attribute-name">name</h4>

_(**Namevar:** If omitted, this attribute's value defaults to the resource's title.)_

The user name. While naming limitations vary by operating system,
it is advisable to restrict names to the lowest common denominator,
which is a maximum of 8 characters beginning with a letter.

Note that Puppet considers user names to be case-sensitive, regardless
of the platform's own rules; be sure to always use the same case when
referring to a given user.

([↑ Back to user attributes](#user-attributes))

<h4 id="user-attribute-ensure">ensure</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The basic state that the object should be in.

Allowed values:

* `present`
* `absent`
* `role`

([↑ Back to user attributes](#user-attributes))

<h4 id="user-attribute-allowdupe">allowdupe</h4>

Whether to allow duplicate UIDs.

Default: `false`

Allowed values:

* `true`
* `false`
* `yes`
* `no`

([↑ Back to user attributes](#user-attributes))

<h4 id="user-attribute-attribute_membership">attribute_membership</h4>

Whether specified attribute value pairs should be treated as the
**complete list** (`inclusive`) or the **minimum list** (`minimum`) of
attribute/value pairs for the user.

Default: `minimum`

Allowed values:

* `inclusive`
* `minimum`

([↑ Back to user attributes](#user-attributes))

<h4 id="user-attribute-attributes">attributes</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Specify AIX attributes for the user in an array or hash of attribute = value pairs.

 For example:

 ```
 ['minage=0', 'maxage=5', 'SYSTEM=compat']
 ```

 or

```
attributes => { 'minage' => '0', 'maxage' => '5', 'SYSTEM' => 'compat' }
```

Requires features manages_aix_lam.

([↑ Back to user attributes](#user-attributes))

<h4 id="user-attribute-auth_membership">auth_membership</h4>

Whether specified auths should be considered the **complete list**
(`inclusive`) or the **minimum list** (`minimum`) of auths the user
has. This setting is specific to managing Solaris authorizations.

Default: `minimum`

Allowed values:

* `inclusive`
* `minimum`

([↑ Back to user attributes](#user-attributes))

<h4 id="user-attribute-auths">auths</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The auths the user has.  Multiple auths should be
specified as an array.

Requires features manages_solaris_rbac.

([↑ Back to user attributes](#user-attributes))

<h4 id="user-attribute-comment">comment</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

A description of the user.  Generally the user's full name.

([↑ Back to user attributes](#user-attributes))

<h4 id="user-attribute-expiry">expiry</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The expiry date for this user. Provide as either the special
value `absent` to ensure that the account never expires, or as
a zero-padded YYYY-MM-DD format -- for example, 2010-02-19.

Allowed values:

* `absent`
* `/^\d{4}-\d{2}-\d{2}$/`

Requires features manages_expiry.

([↑ Back to user attributes](#user-attributes))

<h4 id="user-attribute-forcelocal">forcelocal</h4>

Forces the management of local accounts when accounts are also
being managed by some other NSS

Default: `false`

Allowed values:

* `true`
* `false`
* `yes`
* `no`

Requires features libuser.

([↑ Back to user attributes](#user-attributes))

<h4 id="user-attribute-gid">gid</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The user's primary group.  Can be specified numerically or by name.

This attribute is not supported on Windows systems; use the `groups`
attribute instead. (On Windows, designating a primary group is only
meaningful for domain accounts, which Puppet does not currently manage.)

([↑ Back to user attributes](#user-attributes))

<h4 id="user-attribute-groups">groups</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The groups to which the user belongs.  The primary group should
not be listed, and groups should be identified by name rather than by
GID.  Multiple groups should be specified as an array.

([↑ Back to user attributes](#user-attributes))

<h4 id="user-attribute-home">home</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The home directory of the user.  The directory must be created
separately and is not currently checked for existence.

([↑ Back to user attributes](#user-attributes))

<h4 id="user-attribute-ia_load_module">ia_load_module</h4>

The name of the I&A module to use to manage this user.

Requires features manages_aix_lam.

([↑ Back to user attributes](#user-attributes))

<h4 id="user-attribute-iterations">iterations</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

This is the number of iterations of a chained computation of the
[PBKDF2 password hash](https://en.wikipedia.org/wiki/PBKDF2). This parameter
is used in OS X, and is required for managing passwords on OS X 10.8 and
newer.

Requires features manages_password_salt.

([↑ Back to user attributes](#user-attributes))

<h4 id="user-attribute-key_membership">key_membership</h4>

Whether specified key/value pairs should be considered the
**complete list** (`inclusive`) or the **minimum list** (`minimum`) of
the user's attributes.

Default: `minimum`

Allowed values:

* `inclusive`
* `minimum`

([↑ Back to user attributes](#user-attributes))

<h4 id="user-attribute-keys">keys</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Specify user attributes in an array of key = value pairs.

Requires features manages_solaris_rbac.

([↑ Back to user attributes](#user-attributes))

<h4 id="user-attribute-loginclass">loginclass</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The name of login class to which the user belongs.

Requires features manages_loginclass.

([↑ Back to user attributes](#user-attributes))

<h4 id="user-attribute-managehome">managehome</h4>

Whether to manage the home directory when Puppet creates or removes the user.
This creates the home directory if Puppet also creates the user account, and deletes the
home directory if Puppet also removes the user account.

This parameter has no effect unless Puppet is also creating or removing the user in the
resource at the same time. For instance, Puppet creates a home directory for a managed
user if `ensure => present` and the user does not exist at the time of the Puppet run.
If the home directory is then deleted manually, Puppet will not recreate it on the next
run.

Note that on Windows, this manages creation/deletion of the user profile instead of the
home directory. The user profile is stored in the `C:\Users\<username>` directory.

Default: `false`

Allowed values:

* `true`
* `false`
* `yes`
* `no`

([↑ Back to user attributes](#user-attributes))

<h4 id="user-attribute-membership">membership</h4>

If `minimum` is specified, Puppet will ensure that the user is a
member of all specified groups, but will not remove any other groups
that the user is a part of.

If `inclusive` is specified, Puppet will ensure that the user is a
member of **only** specified groups.

Default: `minimum`

Allowed values:

* `inclusive`
* `minimum`

([↑ Back to user attributes](#user-attributes))

<h4 id="user-attribute-password">password</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The user's password, in whatever encrypted format the local system
requires. Consult your operating system's documentation for acceptable password
encryption formats and requirements.

* Mac OS X 10.5 and 10.6, and some older Linux distributions, use salted SHA1
  hashes. You can use Puppet's built-in `sha1` function to generate a salted SHA1
  hash from a password.
* Mac OS X 10.7 (Lion), and many recent Linux distributions, use salted SHA512
  hashes. The Puppet Labs [stdlib][] module contains a `str2saltedsha512` function
  which can generate password hashes for these operating systems.
* OS X 10.8 and higher use salted SHA512 PBKDF2 hashes. When managing passwords
  on these systems, the `salt` and `iterations` attributes need to be specified as
  well as the password.
* Windows passwords can be managed only in cleartext, because there is no Windows
  API for setting the password hash.

[stdlib]: https://github.com/puppetlabs/puppetlabs-stdlib/

Enclose any value that includes a dollar sign ($) in single quotes (') to avoid
accidental variable interpolation.

To redact passwords from reports to PuppetDB, use the `Sensitive` data type. For
example, this resource protects the password:

```puppet
user { 'foo':
  ensure   => present,
  password => Sensitive("my secret password")
}
```

This results in the password being redacted from the report, as in the
`previous_value`, `desired_value`, and `message` fields below.

```yaml
    events:
    - !ruby/object:Puppet::Transaction::Event
      audited: false
      property: password
      previous_value: "[redacted]"
      desired_value: "[redacted]"
      historical_value:
      message: changed [redacted] to [redacted]
      name: :password_changed
      status: success
      time: 2017-05-17 16:06:02.934398293 -07:00
      redacted: true
      corrective_change: false
    corrective_change: false
```

Requires features manages_passwords.

([↑ Back to user attributes](#user-attributes))

<h4 id="user-attribute-password_max_age">password_max_age</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The maximum number of days a password may be used before it must be changed.

Requires features manages_password_age.

([↑ Back to user attributes](#user-attributes))

<h4 id="user-attribute-password_min_age">password_min_age</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The minimum number of days a password must be used before it may be changed.

Requires features manages_password_age.

([↑ Back to user attributes](#user-attributes))

<h4 id="user-attribute-password_warn_days">password_warn_days</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The number of days before a password is going to expire (see the maximum password age) during which the user should be warned.

Requires features manages_password_age.

([↑ Back to user attributes](#user-attributes))

<h4 id="user-attribute-profile_membership">profile_membership</h4>

Whether specified roles should be treated as the **complete list**
(`inclusive`) or the **minimum list** (`minimum`) of roles
of which the user is a member.

Default: `minimum`

Allowed values:

* `inclusive`
* `minimum`

([↑ Back to user attributes](#user-attributes))

<h4 id="user-attribute-profiles">profiles</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The profiles the user has.  Multiple profiles should be
specified as an array.

Requires features manages_solaris_rbac.

([↑ Back to user attributes](#user-attributes))

<h4 id="user-attribute-project">project</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The name of the project associated with a user.

Requires features manages_solaris_rbac.

([↑ Back to user attributes](#user-attributes))

<h4 id="user-attribute-provider">provider</h4>

The specific backend to use for this `user`
resource. You will seldom need to specify this --- Puppet will usually
discover the appropriate provider for your platform.

Available providers are:

* [`aix`](#user-provider-aix)
* [`directoryservice`](#user-provider-directoryservice)
* [`hpuxuseradd`](#user-provider-hpuxuseradd)
* [`ldap`](#user-provider-ldap)
* [`openbsd`](#user-provider-openbsd)
* [`pw`](#user-provider-pw)
* [`user_role_add`](#user-provider-user_role_add)
* [`useradd`](#user-provider-useradd)
* [`windows_adsi`](#user-provider-windows_adsi)

([↑ Back to user attributes](#user-attributes))

<h4 id="user-attribute-purge_ssh_keys">purge_ssh_keys</h4>

Whether to purge authorized SSH keys for this user if they are not managed
with the `ssh_authorized_key` resource type. This parameter is a noop if the
ssh_authorized_key type is not available.

Allowed values are:

* `false` (default) --- don't purge SSH keys for this user.
* `true` --- look for keys in the `.ssh/authorized_keys` file in the user's
  home directory. Purge any keys that aren't managed as `ssh_authorized_key`
  resources.
* An array of file paths --- look for keys in all of the files listed. Purge
  any keys that aren't managed as `ssh_authorized_key` resources. If any of
  these paths starts with `~` or `%h`, that token will be replaced with
  the user's home directory.

Default: `false`

Allowed values:

* `true`
* `false`

([↑ Back to user attributes](#user-attributes))

<h4 id="user-attribute-role_membership">role_membership</h4>

Whether specified roles should be considered the **complete list**
(`inclusive`) or the **minimum list** (`minimum`) of roles the user
has.

Default: `minimum`

Allowed values:

* `inclusive`
* `minimum`

([↑ Back to user attributes](#user-attributes))

<h4 id="user-attribute-roles">roles</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The roles the user has.  Multiple roles should be
specified as an array.

Requires features manages_solaris_rbac.

([↑ Back to user attributes](#user-attributes))

<h4 id="user-attribute-salt">salt</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

This is the 32-byte salt used to generate the PBKDF2 password used in
OS X. This field is required for managing passwords on OS X >= 10.8.

Requires features manages_password_salt.

([↑ Back to user attributes](#user-attributes))

<h4 id="user-attribute-shell">shell</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The user's login shell.  The shell must exist and be
executable.

This attribute cannot be managed on Windows systems.

Requires features manages_shell.

([↑ Back to user attributes](#user-attributes))

<h4 id="user-attribute-system">system</h4>

Whether the user is a system user, according to the OS's criteria;
on most platforms, a UID less than or equal to 500 indicates a system
user. This parameter is only used when the resource is created and will
not affect the UID when the user is present.

Default: `false`

Allowed values:

* `true`
* `false`
* `yes`
* `no`

([↑ Back to user attributes](#user-attributes))

<h4 id="user-attribute-uid">uid</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The user ID; must be specified numerically. If no user ID is
specified when creating a new user, then one will be chosen
automatically. This will likely result in the same user having
different UIDs on different systems, which is not recommended. This is
especially noteworthy when managing the same user on both Darwin and
other platforms, since Puppet does UID generation on Darwin, but
the underlying tools do so on other platforms.

On Windows, this property is read-only and will return the user's
security identifier (SID).

([↑ Back to user attributes](#user-attributes))


<h3 id="user-providers">Providers</h3>

<h4 id="user-provider-aix">aix</h4>

User management for AIX.

* Required binaries: `/usr/sbin/lsuser`, `/usr/bin/mkuser`, `/usr/sbin/rmuser`, `/usr/bin/chuser`, `/bin/chpasswd`
* Confined to: `operatingsystem == aix`
* Default for `operatingsystem` == `aix`.
* Supported features: `manages_aix_lam`, `manages_expiry`, `manages_homedir`, `manages_password_age`, `manages_passwords`, `manages_shell`.

<h4 id="user-provider-directoryservice">directoryservice</h4>

User management on OS X.

* Required binaries: `/usr/bin/uuidgen`, `/usr/bin/dsimport`, `/usr/bin/dscl`, `/usr/bin/dscacheutil`
* Confined to: `operatingsystem == darwin`, `feature == cfpropertylist`
* Default for `operatingsystem` == `darwin`.
* Supported features: `manages_password_salt`, `manages_passwords`, `manages_shell`.

<h4 id="user-provider-hpuxuseradd">hpuxuseradd</h4>

User management for HP-UX. This provider uses the undocumented `-F`
switch to HP-UX's special `usermod` binary to work around the fact that
its standard `usermod` cannot make changes while the user is logged in.
New functionality provides for changing trusted computing passwords and
resetting password expirations under trusted computing.

* Required binaries: `/usr/sam/lbin/usermod.sam`, `/usr/sam/lbin/userdel.sam`, `/usr/sam/lbin/useradd.sam`
* Confined to: `operatingsystem == hp-ux`
* Default for `operatingsystem` == `hp-ux`.
* Supported features: `allows_duplicates`, `manages_homedir`, `manages_passwords`.

<h4 id="user-provider-ldap">ldap</h4>

User management via LDAP.

This provider requires that you have valid values for all of the
LDAP-related settings in `puppet.conf`, including `ldapbase`.  You will
almost definitely need settings for `ldapuser` and `ldappassword` in order
for your clients to write to LDAP.

Note that this provider will automatically generate a UID for you if
you do not specify one, but it is a potentially expensive operation,
as it iterates across all existing users to pick the appropriate next one.

* Confined to: `feature == ldap`, `false == (Puppet[:ldapuser] == "")`
* Supported features: `manages_passwords`, `manages_shell`.

<h4 id="user-provider-openbsd">openbsd</h4>

User management via `useradd` and its ilk for OpenBSD. Note that you
will need to install Ruby's shadow password library (package known as
`ruby-shadow`) if you wish to manage user passwords.

* Required binaries: `useradd`, `userdel`, `usermod`, `passwd`
* Confined to: `operatingsystem == openbsd`
* Default for `operatingsystem` == `openbsd`.
* Supported features: `manages_expiry`, `manages_homedir`, `manages_shell`, `system_users`.

<h4 id="user-provider-pw">pw</h4>

User management via `pw` on FreeBSD and DragonFly BSD.

* Required binaries: `pw`
* Confined to: `operatingsystem == [:freebsd, :dragonfly]`
* Default for `operatingsystem` == `freebsd, dragonfly`.
* Supported features: `allows_duplicates`, `manages_expiry`, `manages_homedir`, `manages_passwords`, `manages_shell`.

<h4 id="user-provider-user_role_add">user_role_add</h4>

User and role management on Solaris, via `useradd` and `roleadd`.

* Required binaries: `useradd`, `userdel`, `usermod`, `passwd`, `roleadd`, `roledel`, `rolemod`
* Default for `osfamily` == `solaris`.
* Supported features: `allows_duplicates`, `manages_homedir`, `manages_password_age`, `manages_passwords`, `manages_shell`, `manages_solaris_rbac`.

<h4 id="user-provider-useradd">useradd</h4>

User management via `useradd` and its ilk.  Note that you will need to
install Ruby's shadow password library (often known as `ruby-libshadow`)
if you wish to manage user passwords.

* Required binaries: `useradd`, `userdel`, `usermod`, `chage`
* Supported features: `allows_duplicates`, `manages_expiry`, `manages_homedir`, `manages_shell`, `system_users`.

<h4 id="user-provider-windows_adsi">windows_adsi</h4>

Local user management for Windows.

* Confined to: `operatingsystem == windows`
* Default for `operatingsystem` == `windows`.
* Supported features: `manages_homedir`, `manages_passwords`.

<h3 id="user-provider-features">Provider Features</h3>

Available features:

* `allows_duplicates` --- The provider supports duplicate users with the same UID.
* `libuser` --- Allows local users to be managed on systems that also use some other remote NSS method of managing accounts.
* `manages_aix_lam` --- The provider can manage AIX Loadable Authentication Module (LAM) system.
* `manages_expiry` --- The provider can manage the expiry date for a user.
* `manages_homedir` --- The provider can create and remove home directories.
* `manages_loginclass` --- The provider can manage the login class for a user.
* `manages_password_age` --- The provider can set age requirements and restrictions for passwords.
* `manages_password_salt` --- The provider can set a password salt. This is for providers that implement PBKDF2 passwords with salt properties.
* `manages_passwords` --- The provider can modify user passwords, by accepting a password hash.
* `manages_shell` --- The provider allows for setting shell and validates if possible
* `manages_solaris_rbac` --- The provider can manage roles and normal users
* `system_users` --- The provider allows you to create system users with lower UIDs.

Provider support:

<table>
  <thead>
    <tr>
      <th>Provider</th>
      <th>allows duplicates</th>
      <th>libuser</th>
      <th>manages aix lam</th>
      <th>manages expiry</th>
      <th>manages homedir</th>
      <th>manages loginclass</th>
      <th>manages password age</th>
      <th>manages password salt</th>
      <th>manages passwords</th>
      <th>manages shell</th>
      <th>manages solaris rbac</th>
      <th>system users</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>aix</td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
    </tr>
    <tr>
      <td>directoryservice</td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
    </tr>
    <tr>
      <td>hpuxuseradd</td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
    </tr>
    <tr>
      <td>ldap</td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
    </tr>
    <tr>
      <td>openbsd</td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td><em>X</em> </td>
    </tr>
    <tr>
      <td>pw</td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
    </tr>
    <tr>
      <td>user_role_add</td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
    </tr>
    <tr>
      <td>useradd</td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
    </tr>
    <tr>
      <td>windows_adsi</td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
    </tr>
  </tbody>
</table>



> **NOTE:** This page was generated from the Puppet source code on 2019-06-20 13:09:20 -0700