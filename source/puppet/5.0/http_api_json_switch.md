---
layout: default
title: "The PSON to JSON switch"
---

PSON is our vendored version of `pure_json` with Puppet patches applied. It is much slower than the native compiled versions of JSON available in nearly all modern Ruby distributions versions 1.9.3 and newer. By moving to JSON, it ensures maximum interoperability with other languages and tools, and better performance, especially when the master is parsing JSON facts and reports from agents.

### What changed

* Puppet 5 agents prefer JSON over PSON when requesting node, catalog and `file_metadata` objects. You'll see this in an agent's HTTP header as `Accept: application/json, text/pson`.

* Puppet 5 servers return JSON encoded objects in the body of the HTTP response.

* Puppet 5 agents send facts and reports in JSON by default, including App Orchestration deployments when agents are running from a cached catalog.

* Puppet 5 agents and servers include a charset encoding when using JSON or other text-based content-types, similar to `Content-Type: application/json; charset=utf-8`. This is necessary so that the receiving side understands what encoding was used.

### What is staying the same

* Puppet 3 and 4 agents will continue to use PSON for network communication when communicating with Puppet 5 servers. This is important so that you can upgrade older agents to Puppet 5.

* All Puppet agents will continue to use `application/octet-stream` for binary file content, such as when using the `source` parameter for `file` resources and file bucket operations.

* All Puppet agents will continue to use `text/plain` for cert related PEM files. Technically, Puppet 5 now uses the correct `text/plain` MIME type in the HTTP `Accept` and `Content-Type` headers, instead of `s`, but Puppet 5 is really only changing the "label", not the serialization format.

* Puppet 5 agents and servers will include a charset encoding when using JSON or other text-based content-types, e.g. `Content-Type: application/json; charset=utf-8`. This is necessary so that the receiving side understands what encoding was used.

### What to configure

Puppet 5 agents default the `preferred_serialization_format` setting to `json`. If you wants to instead use `pson`, then you can set that option on each agent. Puppet uses the preferred serialization format as the first entry in the `Accept` header, and as the default format when submitting facts and reports.

Setting `preferred_serialization_format=pson` is recommended if your catalogs contain binary data, because Puppet attempts to use JSON, fails, and then will fallback to PSON. Puppet does have a `Binary` data type, and in the future, this will be the way to encode binary data in a JSON catalog. We will likely then deprecate and eventually remove PSON functionality.

### Server error responses

| Error | Description                                                                                                                                                                                                                      |
|-------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 400   | An agent uploaded a report without specifying a `Content-Type` header, or an agent set `Content-Type: application/json`, but the body is not valid JSON.                                                                         |
| 406   | The client requested data from the server, but the server doesn't support at least one format specified in the request's `Accepts` header.                                                                                       |
| 415   | The client sent data in the body of the request (report), but the server doesn't support the specified `Content-Type`. For example, an agent supports msgpack and is configured to prefer it, but the server doesn't support it. |
| 500   | The HTTP request's `Content-Type` header is missing or the server failed to parse the body of the request. For example if it tries to read the submitted report using the specified `Content-Type`, but it fails to deserialize. |

### Binary data

PSON supports binary content, but JSON only supports Unicode characters, typically encoded in UTF-8. The move to JSON will break your setup if you're relying on PSON for inlining binary content in the catalog.

PSON can encode a Ruby string consisting of two bytes `[\xC0, xFF]`, but JSON cannot:

~~~
irb(main):001:0> "\xC0\xFF".to_pson
=> "\"\xC0\xFF\""
irb(main):002:0> "\xC0\xFF".to_json
JSON::GeneratorError: source sequence is illegal/malformed utf-8
~~~

The error occurs because the JSON generator expects the input to contain valid Unicode characters that can be encoded in UTF-8 if they aren't already. However, the string "\xC0\xFF" is not a valid UTF-8 sequence, because UTF-8 requires 2-byte sequences to be of the form `[110xxxxx, 10xxxxxx]` in binary. However, the second byte (0xFF) is 11111111, so the JSON generator rejects it.

Trying to force encoding to ASCII_8BIT doesn't help either, since Ruby cannot transcode from binary to UTF-8:

~~~
irb(main):003:0> "\xC0\xFF".force_encoding('binary').to_json
Encoding::UndefinedConversionError: "\xC0" from ASCII-8BIT to UTF-8
~~~

JSON also fails if the continuation byte is missing:

~~~
irb(main):010:0> "\xC0".to_json
JSON::GeneratorError: partial character in source, but hit end
~~~

PSON avoids this problem, because it considers the input text to be a sequence of bytes not characters, and it replaces any unprintable character with the 6-byte unicode escape sequence `\uXXXX`.
