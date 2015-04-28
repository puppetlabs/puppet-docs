---
title: "Node Classifier 1.0 >> API >> v1 >> Import Hierarchy"
layout: default
subtitle: "Importing Node Classifier Hierarchy"
canonical: "/pe/latest/nc_import-hierarchy.html"
---

## Import Hierarchy Endpoint

### POST /v1/import-hierarchy

Delete *all* existing node groups from the node classifier service and replace them with the node groups in the body of the submitted request.
The request's body must contain an array of node groups that form a valid and complete node group hierarchy.
Valid means that the hierarchy does not contain any cycles, and complete means that every node group in the hierarchy is reachable from the root.

#### Request Format

The request body must be a JSON array of node group objects as described in the [`groups` endpoint documentation](./nc_groups.html).
All fields of the node group objects must be defined; no default values will be supplied by the service.

Note that the output of the group collection endpoint, `/v1/groups`, is valid input for this endpoint.

#### Response Format

If the submitted node groups form a complete and valid hierarchy, and the replacement operation is successful, a 204 No Content response with an empty body will be returned.

#### Error Responses

If any of the node groups in the array are malformed, a 400 Bad Request response will be returned.
The response will contain the usual [JSON error payload](./nc_errors.html).
The `kind` key will be "schema-violation"; the `msg` key will contain a short description of the problems with the malformed node groups; and the `details` key will contain an object with three keys:

  * `submitted`: an array of only the malformed node groups found in the submitted request.
  * `error`: an array of structured descriptions of how the node group at the corresponding index in the `submitted` array failed to meet the schema.
  * `schema`: the structured schema for node group objects.

If the hierarchy formed by the node groups contains a cycle, then a 422 Unprocessable Entity response will be returned.
The response contains the usual JSON error payload, where the `kind` key will be "inheritance-cycle", the `msg` key will contain the names of the node groups in the cycle, and the `details` key will contain an array of the complete node group objects in the cycle.

If the hierarchy formed by the node groups contains node groups that are unreachable from the root, then a 422 Unprocessable Entity response will be returned.
The response contains the usual JSON error payload, where the `kind` key will be "unreachable-groups", the `msg` will list the names of the unreachable node groups, and the `details` key will contain an array of the unreachable node group objects.
