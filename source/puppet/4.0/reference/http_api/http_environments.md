---
layout: default
built_from_commit: 08cb8b2d315a296fa404a4871f94b3703a819461
title: 'Puppet HTTP API: Environments'
canonical: /puppet/latest/reference/http_api/http_environments.html
---

Environments
============

The `environments` endpoint allows for enumeration of the environments known to the master. Each environment contains information
about itself like its modulepath, manifest directory, environment timeout, and the config version.
This endpoint is by default accessible to any client with a valid certificate, though this may be changed by `auth.conf`.

Get
---

Get the list of known environments.

    GET /puppet/v3/environments

### Parameters

None

### Example Request & Response

    GET /puppet/v3/environments

    HTTP 200 OK
    Content-Type: application/json

    {
      "search_paths": ["/etc/puppetlabs/code/environments"]
      "environments": {
        "production": {
          "settings": {
            "modulepath": ["/etc/puppetlabs/code/environments/production/modules", "/etc/puppetlabs/code/environments/development/modules"],
            "manifest": ["/etc/puppetlabs/code/environments/production/manifests"]
            "environment_timeout": 180,
            "config_version": "/version/of/config"
          }
        }
      }
    }

The `environment_timeout` attribute could also be the string "unlimited".

Schema
------

A environments response body adheres to the {file:api/schemas/environments.json
api/schemas/environments.json} schema.
