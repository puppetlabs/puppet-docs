---
title: "Node Classifier 1.0 >> API >> v1 >> Environments"
layout: default
subtitle: "Node Classifier Environments"
canonical: "/pe/latest/nc_environments.html"
---

## Environments Endpoint

### GET /v1/environments

Retrieve a list of all environments known to the node classifier.

#### Response Format

The response is a JSON array of environment objects.
Each environment object contains one key:

* `name`: the name of the environment (a string).

#### Error Responses

No error responses specific to this request are expected.

### GET /v1/environments/\<name\>

Retrieve the environment with the given name.

#### Response Format

If the environment exists, the server will return a 200 response with an environment object as described above, in JSON format.

As the response does not contain any more information about the environment than was specified in the request, the only reason to make this request is to check whether the environment actually exists.

#### Error Responses

If the environment with the given name cannot be found, the server will return a 404 Not Found response with an empty body.

### PUT /v1/environments/\<name\>

Create a new environment with the given name.

#### Request Format

No further information is required in the request besides the `name` portion of the URL.

#### Response Format

If the environment creation is successful, the server will return a 201 Created response whose body is the environment object in JSON format.
[See above](#get-v1environmentsname) for a complete description of an environment object.

#### Error Responses

No error responses specific to this operation are expected.
