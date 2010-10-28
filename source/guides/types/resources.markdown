---
layout: default
title: resources
---

resources
=========

Manage how other resources are handled

* * * 

About 
=======

This is a metatype that can manage other resource types. Any
metaparams specified here will be passed on to any generated
resources, so you can purge umanaged resources but set `noop` to
true so the purging is only logged and does not actually happen.

Parameters
=======

* * *

### Parameters

## name

-   **namevar**

The name of the type to be managed.

## purge

Purge unmanaged resources. This will delete any resource that is
not specified in your configuration and is not required by any
specified resources. Valid values are `true`, `false`.

## unless\_system\_user

This keeps system users from being purged. By default, it does not
purge users whose UIDs are less than or equal to 500, but you can
specify a different UID as the inclusive limit. Valid values are
`true`, `false`. Values can match `/^\d+$/`.


* * * * *

