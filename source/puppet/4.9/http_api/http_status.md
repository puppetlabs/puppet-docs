---
layout: default
built_from_commit: ca4d947a102453a17a819a94bd01bac97f83c7e6
title: 'Puppet HTTP API: Status'
canonical: "/puppet/latest/http_api/http_status.html"
---

Status
=============

The `status` endpoint provides information about a running master.

Find
----

Get status for a master

    GET /puppet/v3/status/:name?environment=:environment

The `environment` parameter and the `:name` are both required, but have no
effect on the response. The `environment` must be a valid environment.

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
