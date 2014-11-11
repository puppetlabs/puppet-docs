---
title: "Node Classifier 1.0 >> API >> v1 >> Update Classes"
layout: default
subtitle: "Updating Node Classifier Classes"
canonical: "/pe/latest/nc_update_classes.html"
---

## update-classes endpoint

### POST /v1/update-classes

Trigger the node classifier to update class and environment definitions from the Puppet master.

#### Response

A successful update will return a 201 response with an empty body.

#### Error Responses

If the Puppet master returns an unexpected status to the node classifier, a 500 Server Error response will be returned, with a JSON body with standard error structure as described in the [errors documentation](./nc_errors.html).
The `kind` key will contain "unexpected-response".
The `msg` key will contain a description of the error returned.
The `details` key will contain a further JSON object, which has `url`, `status`, `headers`, and `body` keys describing the response the classifier received from the Puppet master.
