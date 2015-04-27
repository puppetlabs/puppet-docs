---
title: "PE 3.7 » RBAC Service 1.0 >> User Groups APIs"
layout: default
subtitle: "User Groups APIs"
canonical: "/pe/latest/rbac_usergroups.html"
---

Groups are used to assign roles to a group of users more quickly than assigning
those roles to each user individually. Group membership is determined by the directory service hierarchy and as such, local users cannot be in user groups.

The User Groups endpoints enable you to get lists of groups, and to add a new remote user group.

### User Group Keys

| Key | Explanation | Example |
|--- |--- |--- |
| `id`          | A UUID string identifying the group. | `"c099d420-5557-11e4-916c-0800200c9a66"` |
| `login`       | A string used by the user to log in. Must be unique among users and groups. | `"poets"` |
| `display_name`| The user's name as a string. | `"Poets"` |
| `role_ids`    | An array of role IDs indicating which roles should be inherited by the group's members. An empty array is valid. This is the only field that can be updated via RBAC; the rest are immutable or synced from the directory service. | `[3 6 5]` |
| `is_group`,<br />`is_remote`,<br />`is_superuser`| These flags indicate that the group is a group. | `true`, `true`, `false`, respectively|
| `is_revoked`  | Setting this flag to `true` currently does nothing for a group. | `true`/`false` |
| `user_ids`    | An array of UUIDs indicating which users will inherit roles from this group. | `["3a96d280-54c9-11e4-916c-0800200c9a66"]` |

### GET /groups
Fetches all groups. Supports filtering by ID through query parameters. Web
session authentication is required.

**Example:**

The following requests all the groups

GET /groups

    [{
        "id": "65a068a0-588a-11e4-8ed6-0800200c9a66",
        "login": "hamsters",
        "display_name": "Hamster club",
        "role_ids": [2, 3],
        "is_group" : true,
        "is_remote" : true,
        "is_superuser" : false,
        "user_ids": ["07d9c8e0-5887-11e4-8ed6-0800200c9a66"]}
     },{
        "id": "75370a30-588a-11e4-8ed6-0800200c9a66",
        "login": "chinchilla",
        "display_name": "Chinchilla club",
        "role_ids": [2, 1],
        "is_group" : true,
        "is_remote" : true,
        "is_superuser" : false,
        "user_ids": ["1cadd0e0-5887-11e4-8ed6-0800200c9a66","5c1ab4b0-588b-11e4-8ed6-0800200c9a66"]
     },{
        "id": "ccdbde50-588a-11e4-8ed6-0800200c9a66",
        "login": "wombats",
        "display_name": "Wombat club",
        "role_ids": [2, 3],
        "is_group" : true,
        "is_remote" : true,
        "is_superuser" : false,
        "user_ids": []
    }]

Request only some groups

GET /groups?id=65a068a0-588a-11e4-8ed6-0800200c9a66,75370a30-588a-11e4-8ed6-0800200c9a66

    [{
        "id": "65a068a0-588a-11e4-8ed6-0800200c9a66",
        "login": "hamsters",
        "display_name": "Hamster club",
        "role_ids": [2, 3],
        "is_group" : true,
        "is_remote" : true,
        "is_superuser" : false,
        "user_ids": ["07d9c8e0-5887-11e4-8ed6-0800200c9a66"]}
     },{
        "id": "75370a30-588a-11e4-8ed6-0800200c9a66",
        "login": "chinchillas",
        "display_name": "Chinchilla club",
        "role_ids": [2,3...],
        "is_group" : true,
        "is_remote" : true,
        "is_superuser" : false,
        "user_ids": ["1cadd0e0-5887-11e4-8ed6-0800200c9a66","5c1ab4b0-588b-11e4-8ed6-0800200c9a66"]
    }]

### GET /groups/:sid
Fetches a single group by its subject ID. Web session authentication is required.

**Returns:** The response contains an id for the group and a list of role_ids the group is directly assigned to.

For user groups, the response contains the display name, the login field, a
list of role_ids directly assigned to the group, and user_ids containing IDs of
the remote users that belong to that group. For example:

    {"id": "65a068a0-588a-11e4-8ed6-0800200c9a66",
     "login": "hamsters",
     "display_name": "Hamster club",
     "role_ids": [2, 3],
     "is_group" : true,
     "is_remote" : true,
     "is_superuser" : false,
     "user_ids": ["07d9c8e0-5887-11e4-8ed6-0800200c9a66"]}

* **200 OK** Single group object.
* **401 Unauthorized** If no user is logged in.
* **403 Forbidden** If the current user does not have permissions to request the
group data.

### POST /groups
Creates a new remote group. Attach to it any roles specified in its
roles list. Web session authentication is required.

**Accepts:** A JSON body containing an entry for "login", and an array of role_ids to assign to the group initially.

**Example:**

    {"login":"Augmentators",
     "role_ids": [1,2,3]}

**Returns:**

* **201 Created** With a Location header that points to the new resource.
* **409 Conflict** If the group login collides with an existing group.

### PUT /groups/:sid
Replaces the group with the specified ID with a new group object. Web
session authentication is required.

**Accepts:**
An updated group object containing all the keys that were received
from the API intially. The only updatable field is role_ids.
An empty roles array indicates a desire to remove the group
from all the roles it was directly assigned to. Any other changed values
are ignored.

       {"id": "75370a30-588a-11e4-8ed6-0800200c9a66",
        "login": "chinchilla",
        "display_name": "Chinchillas",
        **"role_ids": [2, 1],**
        "is_group" : true,
        "is_remote" : true,
        "is_superuser" : false,
        "user_ids": ["1cadd0e0-5887-11e4-8ed6-0800200c9a66","5c1ab4b0-588b-11e4-8ed6-0800200c9a66"]}

**Returns:**

* **200 OK** The group object with updated roles.