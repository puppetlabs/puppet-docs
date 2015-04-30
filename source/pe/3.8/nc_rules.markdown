---
title: "Node Classifier 1.0 >> API >> v1 >> Rules"
layout: default
subtitle: "Node Classifier Rules"
canonical: "/pe/latest/nc_rules.html"
---

## Rules Endpoint

### POST /v1/rules/translate

Translate a group's rule condition into [PuppetDB query syntax](http://docs.puppetlabs.com/puppetdb/1.6/api/query/v3/query.html).

#### Request Format

The request's body should contain a rule condition as it would appear in the `rule` field of a group object.
See the [documentation on rule grammar](./nc_groups.html#rule-condition-grammar) for a complete description of how these conditions can be structured.

#### Response Format

The response is a PuppetDB query string that can be used with PuppetDB's nodes endpoint in order to see which nodes would satisfy the rule condition (i.e., would be classified into a group with that rule).

#### Error Responses

Rules that use structured or trusted facts cannot be converted into PuppetDB queries, because PuppetDB does not yet support structured or trusted facts.
If the rule cannot be translated into a PuppetDB query, the server will return a 422 Unprocessable Entity response containing the usual JSON error object.
The error object will have a `kind` of "untranslatable-rule", a `msg` that describes why the rule cannot be translated, and contain the received rule in `details`.

If the request does not contain a valid rule, the server will return a 400 Bad Request response with the usual JSON error object.
If the rule was not valid JSON, the error's `kind` will be "malformed-request", the `msg` will state that the request's body could not be parsed as JSON, and the `details` will contain the request's body as received by the server.

If the rule does not conform to the [rule grammar](./nc_groups.html#rule-condition-grammar), the `kind` key will be "schema-violation, and the `details` key will be an object with `submitted`, `schema`, and `error` keys which respectively describe the submitted object, the schema that object should conform to, and how the submitted object failed to conform to the schema.