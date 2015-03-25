---
title: "Node Classifier 1.0 >> API >> v1 >> Errors"
layout: default
subtitle: "Node Classifier Errors"
canonical: "/pe/latest/nc_errors.html"
---

## Error Response Description

Every error response from the node classifier service will be a JSON response.

Each such response will be an object containing the following keys:

* `kind`: A string classifying the error.
          It should be the same for all errors that have the same kind of thing in their `details` key.
* `msg`: A human-readable message describing the error, suitable for presentation to the user.
* `details`: Additional machine-readable information about the error condition.
             The format of this key's value will vary between kinds of errors but will be the same for any given error kind.

## General Error Responses

Any endpoint may return a 500 Internal Server Error response in addition to any of its usual responses.
There are two kinds of 500 responses: `application-error` and `database-corruption`.

An `application-error` response is a catchall for when some unexpected error occurs.
The `msg` of an `application-error` 500 will always contain the underlying error's message first, followed by a description of what other things can be found in details.
The `details` will always contain the error's stack trace as an array of strings under the `trace` key, and may also contain `schema`, `value`, and `error` keys if the error was caused by a schema validation failure.

A `database-corruption` 500 response occurs when a resource that is retrieved from the database fails to conform to the schema expected of it by the application.
This is probably just a bug in the software, but it could potentially be indicative of either genuine corruption in the database or that a third party has gone and changed values directly in the database.
The `msg` of such a response contains a description of how the database corruption could have occured.
The `details` will contain `retrieved`, `schema`, and `error` keys, which have the resource as retrieved, the schema it should conform to, and a description of how it fails to conform to that schema as the respective values.

Any endpoint where a resource identifier is supplied can produce a 404 Not Found error response if a resource with that identifier could not be found.
All such 404 Not Found error responses have the same form.
The `kind` will be "not-found", the `msg` will be "The resource could not be found.", and the `details` key will contain the URI of the request that resulted in this response.

