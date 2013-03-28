---
title: "PuppetDB 0.9 » Spec » Querying Status"
layout: default
canonical: "/puppetdb/latest/api/query/v1/status.html"
---

## Query Format

Node status can be queried by making a GET request to `/status/nodes/<node>`,
accepting JSON.

## Response Format

Node status information will be returned in a JSON hash of the form:

    {"name": <node>,
     "deactivated": <timestamp>,
     "catalog_timestamp": <timestamp>,
     "facts_timestamp": <timestamp>}

If the node is active, "deactivated" will be null. If a catalog or facts are
not present, the corresponding timestamps will be null.

If no information is known about the node, the result will be a 404 with a JSON
hash containing an "error" key with a message indicating such.
