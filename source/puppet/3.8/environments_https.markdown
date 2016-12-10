---
layout: default
title: "Environments and Puppet's HTTPS Interface"
canonical: "/puppet/latest/reference/environments_https.html"
---

[v1 api]: ./yard/file.http_api_index.html#V1_API_Services
[http_api]: ./yard/file.http_api_index.html
[auth.conf file]: ./config_file_auth.html
[config_file_envs]: ./environments_classic.html


Puppet's environments interact in several ways with Puppet's HTTPS interface.

Environments are Embedded in Puppet's HTTPS Requests
-----

Puppet's agent and master applications communicate via an HTTP API. All of the URLs used today by Puppet agent (the [v1 API][]) start with an environment. See the [HTTP API reference][http_api] for details.

For some endpoints, making a request "in" an environment is meaningless; for others, it influences which modules and manifests the configuration data will come from. Regardless, the API dictates that an environment always be included.

Endpoints where the requested environment can be overridden by the ENC/node terminus:

- [Catalog](./yard/file.http_catalog.html) --- For this endpoint, the environment is just a request, as described above in the section on assigning nodes to environments; if the ENC specifies an environment for the node, it will override the environment in the request.

Endpoints where the requested environment is always used:

- [File content](./yard/file.http_file_content.html) and [file metadata](./yard/file.http_file_metadata.html) --- Files in modules, including plugins like custom facts and resource types, will always be served from the requested environment. Puppet agent has to account for this when fetching files; it does so by fetching its node object (see "node" below), then resetting the environment it will request to whatever the ENC specified and using that new environment for all subsequent requests. (Since custom facts might influence the decision of the ENC, the agent will repeat this process up to three times before giving up.)
- [Resource type](./yard/file.http_resource_type.html) --- Puppet agent doesn't use this; it's just for extensions. The Puppet master will always respond with information for the requested environment.

Endpoints where environment makes no difference:

- [File Bucket File](./yard/file.http_file_bucket_file.html) --- There's only one filebucket.)
- [Report](./yard/file.http_report.html) --- Reports already contain environment info, and each report handler can decide what, if anything, to do with it.)
- [Facts](./yard/file.http_facts.html) --- Puppet agent doesn't actually use this endpoint. When used as the inventory service, environment has no effect.)
- [Node](./yard/file.http_node.html) --- Puppet agent uses this to learn whether the master's ENC has overridden its preferred environment. Theoretically, a node terminus could use the environment of the first node object request to decide whether to override the environment, but we're not aware of anyone doing that and there wouldn't seem to be much point to it.)
- [Status](./yard/file.http_status.html)
- [Certificate](./yard/file.http_certificate.html), [certificate signing request](./yard/file.http_certificate_request.html), [certificate status](./yard/file.http_certificate_status.html), and [certificate revocation list](./yard/file.http_certificate_revocation_list.html) --- The CA doesn't differ by environment.)

### Controlling HTTPS Access Based on Environment

The Puppet master's [auth.conf file][] can use the environment of a request to help decide whether to authorize a request. This generally isn't necessary or useful, but it's there if the need arises. See the [auth.conf documentation][auth.conf file] for details.

You Can Query Environment Info via the Master's HTTP API
-----

If you are extending Puppet and need a way to query information about the available environments, you can do this via the [environments endpoint.][env_endpoint] (This endpoint uses the new [v2 HTTP API.][v2_api])

This _only works for directory environments._ When you query environments via the API, any [config file environments][config_file_envs] will be omitted.

For more details, see [the reference page about the environments endpoint.][env_endpoint]

[v2_api]: ./yard/file.http_api_index.html#V2_HTTP_API
[env_endpoint]: ./yard/file.http_environments.html

