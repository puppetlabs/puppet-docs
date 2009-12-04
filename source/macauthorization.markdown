macauthorization
================

Manage the Mac OS X authorization database. 

* * *

Background
----------

See the Apple [Security Service
page](http://developer.apple.com/documentation/Security/Conceptual/Security_Overview/Security_Services/chapter_4_section_5.html)
for more information.

Requirements
------------

No additional requirements.

Platforms
---------

OSX is the only supported platform.

Parameters
----------

### `allow_root`

Corresponds to 'allow-root' in the authorization store, renamed due
to hyphens being problematic. Specifies whether a right should be
allowed automatically if the requesting process is running with uid ==
0. AuthorizationServices defaults this attribute to `false` if not
specified. Valid values are `true`, `false`.

### `auth_class`

Corresponds to 'class' in the authorization store, renamed due to
'class' being a reserved word. Valid values are `user`,
`evaluate-mechanisms`, `allow`, `deny`, `rule`.

### `auth_type`

Can be a 'right' or a 'rule'. 'comment' has not yet been
implemented. Valid values are `right`, `rule`.

### `authenticate_user`

Corresponds to 'authenticate-user' in the authorization store,
renamed due to hyphens being problematic. Valid values are `true`,
`false`.

### `comment`

The 'comment' attribute for authorization resources.

### `ensure`

The basic property that the resource should be in. Valid values are
`present`, `absent`.

### `group`

The user must authenticate as a member of this group. This
attribute can be set to any one group.

### `k_of_n`

*k-of-n* describes how large a subset of rule mechanisms must succeed
for successful authentication. If there are 'n' mechanisms, then
'k' (the integer value of this parameter) mechanisms must succeed.
The most common setting for this parameter is '1'. If k-of-n is not
set, then 'n-of-n' mechanisms must succeed.

### `mechanisms`

an array of suitable mechanisms.

### `name`

The name of the right or rule to be managed. Corresponds to 'key'
in Authorization Services. The key is the name of a rule. A key
uses the same naming conventions as a right. The Security Server
uses a rule’s key to match the rule with a right. Wildcard keys end
with a ‘.’. The generic rule has an empty key value. Any rights
that do not match a specific rule use the generic rule.

INFO: This is the `namevar` for this resource type.

### `provider`

The specific backend for provider to use. You will seldom need to
specify this -- Puppet will usually discover the appropriate
provider for your platform. Available providers are:

#### `macauthorization`

Manage Mac OS X authorization database rules and rights.

Required binaries:
* `/usr/bin/security`
* `/usr/bin/sw_vers`

NOTE: Default for `operatingsystem` == `darwin`.

### `rule`

The rule(s) that this right refers to.

### `session_owner`

Corresponds to 'session-owner' in the authorization store, renamed
due to hyphens being problematic. Whether the session owner
automatically matches this rule or right. Valid values are `true`,
`false`.

### `shared`

If this is set to `true`, then the Security Server marks the
credentials used to gain this right as shared. The Security Server
may use any shared credentials to authorize this right. For maximum
security, set sharing to false so credentials stored by the
Security Server for one application may not be used by another
application. Valid values are `true`, `false`.

### `timeout`

The credential used by this rule expires in the specified number of
seconds. For maximum security where the user must authenticate
every time, set the timeout to 0. For minimum security, remove the
timeout attribute so the user authenticates only once per session.

### `tries`

The number of tries allowed.
