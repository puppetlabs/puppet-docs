---
layout: default
built_from_commit: c0673af42427fbe0b22ff97c8e5fa3244715eeae
title: 'Puppet HTTP API: Status'
canonical: /puppet/latest/reference/http_api/http_status.html
---

Status
=============

The `status` endpoint provides information about a running master.

Find
----

Get status for a master

    GET /:environment/status/:name

The `:environment` and `:name` sections of the URL are both ignored, but a
value must be provided for both.

### Supported HTTP Methods

GET

### Supported Response Formats

PSON

### Parameters

None

### Example Response

    GET /env/status/whatever

    HTTP 200 OK
    Content-Type: text/pson

    {"is_alive":true,"version":"3.3.2"}

Schema
------

The returned status conforms to the
[status schema](../schemas/status.json).
