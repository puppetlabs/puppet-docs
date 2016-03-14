---
layout: default
built_from_commit: c0673af42427fbe0b22ff97c8e5fa3244715eeae
title: 'Puppet HTTP API: Node'
canonical: /puppet/latest/reference/http_api/http_node.html
---

Node
====

The `node` endpoint is used by the puppet agent to get basic information
about a node. The returned information includes the node name and
environment, and optionally any classes set by an External Node
Classifier and a hash of parameters which may include the node's facts.
The returned node may have a different environment from the one given in
the request if Puppet is configured with an ENC.

Find
----

Retrieve data for a node

  GET /:environment/node/:certname


### Supported HTTP Methods

GET

### Supported Response Formats

PSON

### Examples

    > GET /production/node/mycertname HTTP/1.1
    > Accept: pson, b64_zlib_yaml, yaml, raw

    < HTTP/1.1 200 OK
    < Content-Type: text/pson
    < Content-Length: 4630

    {
      "document_type":"Node",
      "data":{
        "name":"thinky.corp.puppetlabs.net",
        "parameters":{
          "architecture":"amd64",
          "kernel":"Linux",
          "blockdevices":"sda,sr0",
          "clientversion":"3.3.1",
          "clientnoop":"false",
          "environment":"production",
          ...
        },
        "environment":"production"
      }
    }

Schema
------

Returned node objects conform to the [node schema](../schemas/node.json).
