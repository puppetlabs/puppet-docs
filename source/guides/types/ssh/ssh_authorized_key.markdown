---
layout: default
title: ssh_authorized_key
---

ssh_authorized_key
==================

Manages SSH authorized keys.

* Currently only type 2 keys are supported.

* * *

### Parameters

#### ensure

The basic property that the resource should be in. Valid values are
`present`, `absent`.

#### key

The key itself; generally a long string of hex digits.

#### name

-   **namevar**

The SSH key comment. This attribute is currently used as a
system-wide primary key and therefore has to be unique.

#### options

Key options, see sshd(8) for possible values. Multiple values
should be specified as an array.

#### provider

The specific backend for provider to use. You will seldom need to
specify this -- Puppet will usually discover the appropriate
provider for your platform. Available providers are:

-   **parsed**: Parse and generate authorized\_keys files for SSH.

#### target

The absolute filename in which to store the SSH key. This property
is optional and should only be used in cases where keys are stored
in a non-standard location (ie not in
\~user/.ssh/authorized\_keys).

#### type

The encryption type used: ssh-dss or ssh-rsa. Valid values are
`ssh-dss` (also called `dsa`), `ssh-rsa` (also called `rsa`).

#### user

The user account in which the SSH key should be installed. The
resource will automatically depend on this user.


* * * * *

