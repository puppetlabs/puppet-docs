---
layout: default
title: maillist
---

maillist
========

Manage email lists. This resource type currently can only create
and remove lists, it cannot reconfigure them.

* * *

{GENERIC}

Examples
--------

{TODO}

Parameters
----------

### `admin`

The email address of the administrator.

### `description`

The description of the mailing list.

### `ensure`

The basic property that the resource should be in. Valid values are
`present`, `absent`, `purged`.

### `mailserver`

The name of the host handling email for the list.

### `name`

The name of the email list.

INFO: This is the `namevar` for this resource type.

### `password`

The admin password.

### `provider`

The specific backend for provider to use. You will seldom need to
specify this -- Puppet will usually discover the appropriate
provider for your platform. Available providers are:

#### `mailman`

Required binaries:

* `newlist`
* `/var/lib/mailman/mail/mailman`
* `list_lists`
* `rmlist`.

### `webserver`

The name of the host providing web archives and the administrative
interface.
