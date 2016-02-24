---
layout: default
built_from_commit: c0673af42427fbe0b22ff97c8e5fa3244715eeae
title: 'Puppet HTTP API: Index'
canonical: /puppet/latest/reference/http_api/http_api_index.html
---

V1 API Services
---------------

Puppet Agents use various network services which the Puppet Master provides in
order to manage systems. Other systems can access these services in order to
put the information that the Puppet Master has to use.

The V1 API is all based off of dispatching to puppet's internal "indirector"
framework. Every HTTP endpoint in V1 follows the form
`/:environment/:indirection/:key`, where
  * `:environment` is the name of the environment that should be in effect for
    the request. Not all endpoints need an environment, but the path component
    must always be specified.
  * `:indirection` is the indirection to dispatch the request to.
  * `:key` is the "key" portion of the indirection call.

Using this API requires a significant amount of understanding of how puppet's
internal services are structured. The following documents provide some
specification for what is available and the ways in which they can be
interacted with.

### Configuration Management Services

These services are all related to how the Puppet Agent is able to manage the
configuration of a node.

* [Catalog](./http_catalog.md)
* [File Bucket File](./http_file_bucket_file.md)
* [File Content](./http_file_content.md)
* [File Metadata](./http_file_metadata.md)
* [Report](./http_report.md)

### Informational Services

These services all provide extra information that can be used to understand how
the Puppet Master will be providing configuration management information to
Puppet Agents.

* [Facts](./http_facts.md)
* [Node](./http_node.md)
* [Resource Type](./http_resource_type.md)
* [Status](./http_status.md)

### SSL Certificate Related Services

These services are all in support of Puppet's PKI system.

* [Certificate](./http_certificate.md)
* [Certificate Signing Requests](./http_certificate_request.md)
* [Certificate Status](./http_certificate_status.md)
* [Certificate Revocation List](./http_certificate_revocation_list.md)

V2 HTTP API
-----------

The V2 HTTP API is accessed by prefixing requests with `/v2.0`. Authorization for
these endpoints is still controlled with the `auth.conf` authorization system
in puppet. When specifying the authorization of the V2 endpoints in `auth.conf`
the `/v2.0` prefix on V2 API paths must be retained; the full request path is used.

The V2 API will only accept payloads formatted as JSON and respond with JSON
(MIME application/json).

### Endpoints

* [Environments](./http_environments.md)

### Error Responses

All V2 API endpoints will respond to error conditions in a uniform manner and
use standard HTTP response code to signify those errors.

* When the client submits a malformed request, the API will return a 400 Bad
  Request response.
* When the client is not authorized, the API will return a 403 Not Authorized
  response.
* When the client attempts to use an HTTP method that is not permissible for
  the endpoint, the API will return a 405 Method Not Allowed response.
* When the client asks for a response in a format other than JSON, the API will
  return a 406 Unacceptable response.
* When the server encounters an unexpected error during the handling of a
  request, it will return a 500 Server Error response.
* When the server is unable to find an endpoint handler for the request that
  starts with `/v2.0`, it will return a 404 Not Found response

The V2 API paths are prefixed with `/v2.0` instead of `/v2` so that it is able
to respond with 404, but not interfere with any environments in the V1 API.
`v2` is a valid environment name, but `v2.0` is not.

All error responses will contain a body, except when it is a HEAD request. The
error responses will uniformly be a JSON object with the following properties:

  * `message`: [String] A human readable message explaining the error.
  * `issue_kind`: [String] A unique label to identify the error class.
  * `stacktrace` (only for 5xx errors): [Array<String>] A stacktrace to where the error occurred.

A [JSON schema for the error objects](../schemas/error.json) is also available.


Serialization Formats
---------------------

Puppet sends messages using several different serialization formats. Not all
REST services support all of the formats.

* [PSON](./pson.md)
* [YAML](http://www.yaml.org/spec/1.2/spec.html)

