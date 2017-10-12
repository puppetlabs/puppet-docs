---
layout: default
title: "Environments and Puppet's HTTPS Interface"
canonical: "/puppet/latest/environments_https.html"
---

[http_api]: ./http_api/http_api_index.html
[auth.conf file]: ./config_file_auth.html

Puppet's environments interact in several ways with Puppet's HTTPS interface.

Environments are Embedded in Puppet's HTTPS Requests
-----

Puppet's agent and master applications communicate via an HTTPS API. Most of the HTTPS URLs used today by Puppet agent include an environment. See the [HTTP API reference][http_api] for details about how to provide environments in requests.

For some endpoints, making a request "in" an environment is meaningless; for others, it influences which modules and manifests the configuration data will come from. Regardless, the API requires an environment to be provided.

Endpoints where the requested environment can be overridden by the ENC/node terminus:

- [Catalog](./http_api/http_catalog.html) --- For this endpoint, the environment is just a request, as described above in the section on assigning nodes to environments; if the ENC specifies an environment for the node, it will override the environment in the request.

Endpoints where the requested environment is always used:

- [File content](./http_api/http_file_content.html) and [file metadata](./http_api/http_file_metadata.html) --- Files in modules, including plugins like custom facts and resource types, will always be served from the requested environment. Puppet agent has to account for this when fetching files; it does so by fetching its node object (see "node" below), then resetting the environment it will request to whatever the ENC specified and using that new environment for all subsequent requests. (Since custom facts might influence the decision of the ENC, the agent will repeat this process up to three times before giving up.)
- [Resource type](./http_api/http_resource_type.html) --- Puppet agent doesn't use this; it's just for extensions. The Puppet master will always respond with information for the requested environment.

Endpoints where environment makes no difference:

- [File Bucket File](./http_api/http_file_bucket_file.html) --- There's only one filebucket.
- [Report](./http_api/http_report.html) --- Reports already contain environment info, and each report handler can decide what, if anything, to do with it.
- [Node](./http_api/http_node.html) --- Puppet agent uses this to learn whether the master's ENC has overridden its preferred environment. Theoretically, a node terminus could use the environment of the first node object request to decide whether to override the environment, but we're not aware of anyone doing that and there wouldn't seem to be much point to it.
- [Status](./http_api/http_status.html)
- [Certificate](./http_api/http_certificate.html), [certificate signing request](./http_api/http_certificate_request.html), [certificate status](./http_api/http_certificate_status.html), and [certificate revocation list](./http_api/http_certificate_revocation_list.html) --- The CA doesn't differ by environment.)

### Controlling HTTPS Access Based on Environment

The Puppet master's [auth.conf file][] can use the environment of a request to help decide whether to authorize a request. This generally isn't necessary or useful, but it's there if the need arises. See the [auth.conf documentation][auth.conf file] for details.

You Can Query Environment Info via the Master's HTTP API
-----

If you are extending Puppet and need a way to query information about the available environments, you can do this via the [environments endpoint.][env_endpoint]

[env_endpoint]: ./http_api/http_environments.html

