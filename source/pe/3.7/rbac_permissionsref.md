---
title: "PE 3.7 » RBAC Service 1.0 >> Permission APIs"
layout: default
subtitle: "Permissions APIs"
canonical: "/pe/latest/rbac_permissions.html"
---

You assign permissions to user roles to manage user access to objects in PE. The Permissions endpoints enable you to get information about available objects and the permissions that can be constructed for those objects. You can also check an array of permissions.

### Permission keys

The available values for these keys are available from the "/types" endpoint (see below).

| Key | Explanation | Example |
| --- | ----------- | ------- |
| `object_type` | A string identifying the type of object this permission applies to. | `"node_groups"` |
| `action`      | A string indicating the type of action this permission permits. | `"modify_children"` |
| `instance`    | A string containing the primary ID of the object instance this permission applies to, or `"*"` indicating that it applies to all instances. If the given action does not allow instance specification, `"*"` should always be used. | `"cec7e830-555b-11e4-916c-0800200c9a66"` or `"*"` |

### GET /types
Lists the objects that integrate with RBAC and demonstrates the permissions
that can be constructed, by picking the appropriate `object_type`, `action`,
and `instance` triple. Web session authentication is required.

The `has_instances` flag indicates that the action permission is instance-specific
if `true`, or `false` if this action permission does not require instance
specification.

**Returns:**

* **200 OK** A listing of types.
* **401 Unauthorized** If no user is logged in.
* **403 Forbidden** If the current user lacks permissions to view the types.

**Example return:**

        [{ "object_type": "node_groups",
           "display_name": "Node Groups",
           "description": "Groups that nodes can be assigned to."
           "actions": [
                {
                    "name": "view",
                    "display_name": "View",
                    "description": "View the node groups",
                    "has_instances": true
                },{
                    "name":"modify",
                    "display_name": "Configure",
                    "description": "Modify description, variables and classes",
                    "has_instances": true
                }, ...]
          },...]

## POST /permitted
Checks an array of permissions for the subject identified by the
submitted token.

This endpoint takes a "token" in the form of a user or a user
group's UUID and a list of permissions. This will return true or false for each
permission queried, representing whether the subject is permitted to take the
given action. This takes into account the full evaluation of permissions,
including inherited roles and matching general permissions against more
specific queries. A query for `users:edit:1` will return `true` if the subject
has `users:edit:1` and/or `users:edit:*`.

**Example Body:**

    {"token": "<subject uuid>",
     "permissions": [{"object_type": "node_groups",
                      "action": "edit_rules",
                      "instance": "4"},
                     {"object_type": "users",
                      "action": "disable",
                      "instance": "1"}]}

The first permission is querying whether the subject specified by the token is
permitted to perform the `edit_rules` action on the instance of `node_groups`
identified by the ID `4`. Note that in reality, node groups and users use UUIDs as
their IDs.

**Example Return:**

    [true, false]

Each queried permission has a corresponding boolean in the
returned array. The indexes of the submitted array of permissions and
returned array of booleans will match. Given the above example
submission, this return means the subject is permitted
`node_groups:edit_rules:4` but not permitted `users:disable:1`.

**Returns:**

* **200 OK** An array of boolean values representing whether each
  submitted action on a specific object type and instance is permitted
  for the subject. The array will always have the same length as the
  submitted array and each returned value corresponds to the submitted
  permission query at the same index.