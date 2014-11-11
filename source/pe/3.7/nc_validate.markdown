---
title: "Node Classifier 1.0 >> API >> v1 >> Validation"
layout: default
subtitle: "Validating Node Classifier Endpoints"
canonical: "/pe/latest/nc_validate.html"
---

# Validation Endpoints

These endpoints can be used to validate resources without writing anything to the database.
There is one validation endpoint, for groups.

### POST /v1/validate/group

#### Request Format

The request should contain a group object.
The structure of a group object is described in the "Request Format" section of the [documentation for POSTing a new group](./nc_groups.html#post-v1groups).

### Response Format

If the group is valid, then the server will return a 200 OK response with the validated group as the body.

If a validation error was encountered, the server will return one of the 400-level error responses described under the "Error Responses" section of the [documentation for POSTing a new group](./nc_groups.html#post-v1groups).
