---
title: "PuppetDB 1 » Spec » Querying Facts"
layout: default
canonical: "/puppetdb/latest/api/query/v1/facts.html"
---


Querying facts occurs via an HTTP request to the
`/facts` REST endpoint.

## Query format

Facts are queried by making a request to a URL in the following form:

The HTTP request must conform to the following format:

* The URL requested is `/facts/<node>`
* A `GET` is used.
* There is an `Accept` header containing `application/json`.

The supplied `<node>` path component indicates the certname for which
facts should be retrieved.

## Response format

    {"name": "<node>",
     "facts": {
         "<fact name>": "<fact value>",
         "<fact name>": "<fact value>",
         ...
        }
    }

If no facts are known for the supplied node, an HTTP 404 is returned.

## Example

[Using `curl` from localhost](./spec_curl.html#using-curl-from-localhost-non-sslhttp):

    curl -H "Accept: application/json" 'http://localhost:8080/facts/<node>'

Where `<node>` is the name of the node from which you wish to retrieve facts.
