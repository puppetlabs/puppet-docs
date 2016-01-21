---
layout: default
built_from_commit: f223e717763aa79a28314425fa6917eb57ec3af8
title: 'Puppet HTTP API: Status'
canonical: /puppet/latest/reference/http_api/http_status.html
---

Status
=============

The `status` endpoint provides information about a running master.

Find
----

Get status for a master

    GET /puppet/v3/status/:name?environment=:environment

The `:environment` and `:name` sections of the URL are both ignored, but a
value must be provided for both.

### Supported HTTP Methods

GET

### Supported Response Formats

PSON

### Parameters

None

### Example Response

    GET /puppet/v3/status/whatever?environment=env

    HTTP 200 OK
    Content-Type: text/pson

    {"is_alive":true,"version":"3.3.2"}

Schema
------

A status response body conforms to [the status schema.](../schemas/status.json)
