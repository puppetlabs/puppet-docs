user

Manage users. This type is mostly built to manage system users, so
it is lacking some features useful for managing normal users.

This resource type uses the prescribed native tools for creating
groups and generally uses POSIX APIs for retrieving information
about them. It does not directly modify /etc/passwd or anything.

### Features

-   **allows\_duplicates**: The provider supports duplicate users
    with the same UID.
-   **manages\_homedir**: The provider can create and remove home
    directories.
-   **manages\_passwords**: The provider can modify user passwords,
    by accepting a password hash.
-   **manages\_solaris\_rbac**: The provider can manage roles and
    normal users

================ ================= ===============
================= ==================== Provider allows\_duplicates
manages\_homedir manages\_passwords manages\_solaris\_rbac
================ ================= ===============
================= ==================== directoryservice **X**
hpuxuseradd **X** **X** ldap **X** pw **X** **X** user\_role\_add
**X** **X** **X** **X** useradd **X** **X** ================
================= =============== =================
====================

### Parameters

#### allowdupe

Whether to allow duplicate UIDs. Valid values are `true`, `false`.

#### auth\_membership

Whether specified auths should be treated as the only auths of
which the user is a member or whether they should merely be treated
as the minimum membership list. Valid values are `inclusive`,
`minimum`.

#### auths

The auths the user has. Multiple auths should be specified as an
array. Requires features manages\_solaris\_rbac.

#### comment

A description of the user. Generally is a user's full name.

#### ensure

The basic state that the object should be in. Valid values are
`present`, `absent`, `role`.

#### gid

The user's primary group. Can be specified numerically or by name.

#### groups

The groups of which the user is a member. The primary group should
not be listed. Multiple groups should be specified as an array.

#### home

The home directory of the user. The directory must be created
separately and is not currently checked for existence.

#### key\_membership

Whether specified key value pairs should be treated as the only
attributes of the user or whether they should merely be treated as
the minimum list. Valid values are `inclusive`, `minimum`.

#### keys

Specify user attributes in an array of keyvalue pairs Requires
features manages\_solaris\_rbac.

#### managehome

Whether to manage the home directory when managing the user. Valid
values are `true`, `false`.

#### membership

Whether specified groups should be treated as the only groups of
which the user is a member or whether they should merely be treated
as the minimum membership list. Valid values are `inclusive`,
`minimum`.

#### name

-   **namevar**

User name. While limitations are determined for each operating
system, it is generally a good idea to keep to the degenerate 8
characters, beginning with a letter.

#### password

The user's password, in whatever encrypted format the local machine
requires. Be sure to enclose any value that includes a dollar sign
($) in single quotes ('). Requires features manages\_passwords.

#### profile\_membership

Whether specified roles should be treated as the only roles of
which the user is a member or whether they should merely be treated
as the minimum membership list. Valid values are `inclusive`,
`minimum`.

#### profiles

The profiles the user has. Multiple profiles should be specified as
an array. Requires features manages\_solaris\_rbac.

#### project

The name of the project associated with a user Requires features
manages\_solaris\_rbac.

#### provider

The specific backend for provider to use. You will seldom need to
specify this -- Puppet will usually discover the appropriate
provider for your platform. Available providers are:

-   **directoryservice**: User management using DirectoryService on
    OS X. Required binaries: `/usr/bin/dscl`. Default for
    `operatingsystem` == `darwin`. Supported features:
    `manages_passwords`.
-   **hpuxuseradd**: User management for hp-ux! Undocumented switch
    to special usermod because HP-UX regular usermod is TOO STUPID to
    change stuff while the user is logged in. Required binaries:
    `/usr/sam/lbin/usermod.sam`, `/usr/sam/lbin/userdel.sam`,
    `/usr/sbin/useradd`. Default for `operatingsystem` == `hp-ux`.
    Supported features: `allows_duplicates`, `manages_homedir`.
-   **ldap**: User management via `ldap`. This provider requires that you
    :   have valid values for all of the ldap-related settings,
        including `ldapbase`. You will also almost definitely need settings
        for `ldapuser` and `ldappassword`, so that your clients can write
        to ldap.

    :   Note that this provider will automatically generate a UID for
        you if you do not specify one, but it is a potentially expensive
        operation, as it iterates across all existing users to pick the
        appropriate next one. Supported features: `manages_passwords`.


-   **pw**: User management via `pw` on FreeBSD. Required binaries:
    `pw`. Default for `operatingsystem` == `freebsd`. Supported
    features: `allows_duplicates`, `manages_homedir`.
-   **user\_role\_add**: User management inherits `useradd` and
    adds logic to manage roles on Solaris using roleadd. Required
    binaries: `usermod`, `roledel`, `rolemod`, `userdel`, `useradd`,
    `roleadd`. Default for `operatingsystem` == `solaris`. Supported
    features: `allows_duplicates`, `manages_homedir`,
    `manages_passwords`, `manages_solaris_rbac`.
-   **useradd**: User management via `useradd` and its ilk. Note
    that you will need to install the `Shadow Password` Ruby library
    often known as ruby-libshadow to manage user passwords. Required
    binaries: `usermod`, `userdel`, `useradd`. Supported features:
    `allows_duplicates`, `manages_homedir`.


#### role\_membership

Whether specified roles should be treated as the only roles of
which the user is a member or whether they should merely be treated
as the minimum membership list. Valid values are `inclusive`,
`minimum`.

#### roles

The roles the user has. Multiple roles should be specified as an
array. Requires features manages\_solaris\_rbac.

#### shell

The user's login shell. The shell must exist and be executable.

#### uid

The user ID. Must be specified numerically. For new users being
created, if no user ID is specified then one will be chosen
automatically, which will likely result in the same user having
different IDs on different systems, which is not recommended. This
is especially noteworthy if you use Puppet to manage the same user
on both Darwin and other platforms, since Puppet does the ID
generation for you on Darwin, but the tools do so on other
platforms.


* * * * *

