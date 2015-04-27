---
title: "PE 3.8 » RBAC Service 1.0 >> Errors"
layout: default
subtitle: "RBAC Service Errors"
canonical: "/pe/latest/rbac_serviceerrors.html"
---

The RBAC service generates the following errors.
## Format

When the client accepts `application/json` the RBAC service returns errors in a standard format. Each such response is an object containing the following keys:

* `kind`: A string classifying the error. It should be the same for all errors that have the same kind of thing in their `details` key.
* `msg`: A human-readable message describing the error.
* `details`: Additional machine-readable information about the error condition. The format of this key's value varies between kinds of errors, but is the same for each kind of error.

When returning errors in `text/html` the body is the contents of the `msg` field.

## General Error Responses

Any endpoint accepting a JSON body can return several kinds of 400
Bad Request responses.

### `malformed-request`

**Status:** 400

Occurs when the submitted data is not valid JSON. The `details` key consists of one field, `error`, which contains the error message from the JSON parser.

### `schema-violation`

**Status:** 400

Occurs when the submitted data has an unexpected structure, such as invalid fields, or missing required fields. The `msg` contains a description of the problem. The `details` are an object with three keys:

  * `submitted`: The submitted data as it was seen during schema validation.
  * `schema`: The expected structure of the data.
  * `error`: A structured description of the error.

### `inconsistent-id`

**Status:** 400

Occurs when data is submitted to an endpoint where the ID of the object is a part of the URL and the submitted data contains an `id` field with a different value. The `details` consist of two fields, `url-id` and `body-id`, showing the IDs from both sources.

### `invalid-id-filter`

**Status:** 400

Occurs when a URL contains a filter on the ID with an invalid format. There are no details given with this error.

### `invalid-uuid`

**Status:** 400

Occurs when an invalid UUID was submitted. There are no details given with this error.

### `user-unauthenticated`

**Status:** 401

Occurs when an unauthenticated user attempts to access a route that requires authentication. This error will likely never be seen by a user as they should be redirected to the login page.

### `user-revoked`

**Status:** 401

Occurs when a user who has been revoked attempts to access a route that requires authentication.

### `api-user-login`

**Status:** 401

Occurs when a person attempts to log in as the api_user with a password, because api_user does not support username/password authentication.

### `remote-user-conflict`

**Status:** 401

Occurs when a remote user who is not yet known to RBAC attempts to authenticate, but a local user with that login already exists. The solution is to change either the local user's login in RBAC, or change the remote user's login either by changing the user_lookup_attr in the DS settings or by changing
the value in the directory service itself.

### `permission-denied`

**Status:** 403

Occurs when a user attempts an action that they are not permitted to perform.

### `admin-user-immutable`, `admin-user-not-in-admin-role`, `default-roles-immutable`

**Status:** 403

Occurs when a user attempts to edit metadata or associations belonging to
the default roles ("Administrators", "Operators", or "Viewers") or default users
("admin" or "api_user") that they are not allowed to change.

### `conflict`

**Status:** 409

Occurs when a value for a field that is supposed to be unique is
submitted to the service and another object has that value. For example, when a user is
created with a login that another existing user already has.

### `invalid-associated-id`

**Status:** 422

Occurs when an object is submitted with a list of associated IDs (for example,
`user_ids`) and one or more of those IDs does not correspond to an object of the
correct type.

### `no-such-user-LDAP`, `no-such-group-LDAP`

**Status:** 422

Occurs when an object is submitted with a list of associated IDs (for example,
`user_ids`) and one or more of those IDs does not correspond to an object of the
correct type.

#### `non-unique-lookup-attr`

**Status:** 422

Occurs when a login is attempted but multiple users are found via
LDAP for the given username. To fix it, the directory server settings
must use a `user_lookup_attr` that is guaranteed to be unique within
the provided users RDN.

### `server-error`

**Status:** 500

Occurs when the server throws an unspecified exception. A message and stack
trace should be available in the logs.