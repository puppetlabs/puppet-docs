---
title: "PE 3.8 » RBAC Service 1.0 >> Roles APIs"
layout: default
subtitle: "Roles APIs"
canonical: "/pe/latest/rbac_roles.html"
---

By assigning roles to users, you can manage them in sets that are granted access permissions to various PE objects. This makes tracking user access more organized and easier to manage. The Roles endpoints enable you to get lists of roles and create new roles.

### Role keys

| Key | Explanation | Example |
| --- | ----------- | ------- |
| `id`          | An integer identifying the role. | `18` |
| `display_name`| The role's name as a string. | `"Viewers"` |
| `description` | A string describing the role's function. | `"View-only permissions"` |
| `permissions` | An array containing permission objects that indicate what permissions a role grants. An empty array is valid. See "Permission keys" for more information. | `[]` |
| `user_ids`,<br />`group_ids` | An array of UUIDs indicating which users and groups are directly assigned to the role. An empty array is valid. | `["fc115750-555a-11e4-916c-0800200c9a66"]` |

### GET /roles
Fetches all roles with user and group ID lists and permission lists. Web
session authentication is required.

**Example return:**

        [{"id": 123,
          "permissions": [{"object_type":"node_groups",
                           "action":"edit_rules",
                           "instance":"*"}, ...],
          "user_ids": ["1cadd0e0-5887-11e4-8ed6-0800200c9a66","5c1ab4b0-588b-11e4-8ed6-0800200c9a66"],
          "group_ids": ["2ca57e30-5887-11e4-8ed6-0800200c9a66"],
          "display_name": "A role",
          "description": "Edit node group rules"},
        ...]

## GET /roles/:rid
Fetches a single role by its ID. Web session authentication is required.

**Returns:**

* **200 OK** The role object with a full list of permissions and user and
group IDs.

**Example return:**

        {"id": 123,
          "permissions": [{"object_type":"node_groups",
                           "action":"edit_rules",
                           "instance":"*"}, ...],
          "user_ids": ["1cadd0e0-5887-11e4-8ed6-0800200c9a66","5c1ab4b0-588b-11e4-8ed6-0800200c9a66"],
          "group_ids": ["2ca57e30-5887-11e4-8ed6-0800200c9a66"],
          "display_name": "A role",
          "description": "Edit node group rules"}

## POST /roles
Creates a role, and attaches to it the specified permissions and the specified users and groups. Web session authentication is required.

**Accepts:** A new role object. Any of the arrays can be empty and "description" can be null.

**Returns:**

* **201 Created** With a Location header pointing to the new resource.
* **409 Conflict** If the role has a name that collides with an existing role.


**Example body:**

         {"permissions": [{"object_type":"node_groups",
                           "action":"edit_rules",
                           "instance":"*"}, ...],
          "user_ids": ["1cadd0e0-5887-11e4-8ed6-0800200c9a66","5c1ab4b0-588b-11e4-8ed6-0800200c9a66"],
          "group_ids": ["2ca57e30-5887-11e4-8ed6-0800200c9a66"],
          "display_name": "A role",
          "description": "Edit node group rules"}

## PUT /roles/:rid
Replace role at the specified ID with a new role object. Web session authentication is required.

**Accepts:** The modified role object.

**Example body:**

        {"id": 123,
          "permissions": [{"object_type":"node_groups",
                           "action":"edit_rules",
                           "instance":"*"}, ...],
          "user_ids": ["1cadd0e0-5887-11e4-8ed6-0800200c9a66","5c1ab4b0-588b-11e4-8ed6-0800200c9a66"],
          "group_ids": ["2ca57e30-5887-11e4-8ed6-0800200c9a66"],
          "display_name": "A role",
          "description": "Edit node group rules"}

**Returns:**

* **200 OK** The modified role object.
* **409 Conflict** If the role has a name that collides with another existing role.

## DELETE /roles:rid
Deletes the role identified by the role ID (`:rid`). Users with this role will lose the role and all permissions granted by it immediately, but their session will be otherwise unaffected. Access to the next request that the user makes will be determined by the new set of permissions the user has without this role.

**Returns**

* **200 OK** The role identified by `:rid` has been deleted.
* **404 Not Found** No role exists for id `:rid`.
* **403 Forbidden** The current user lacks permission to delete the role identified by `:rid`.