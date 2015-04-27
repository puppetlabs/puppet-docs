---
layout: default
title: "PE 3.7 » Console » RBAC Permissions"
subtitle: "About RBAC Permissions"
canonical: "/pe/latest/rbac_permissions.html"
---

## Overview

Puppet Enterprise (PE) offers role-based access control (RBAC). RBAC provides a specific set of roles you can assign to users and groups. Those roles contain permissions that can be added or removed. RBAC also provides a set of types and actions that can be combined to create new permissions based off the objects you specify. You can add new users to the console, but they can't actually do anything until they're associated with a role either explicitly, via role assignment, or implicitly, via group membership and role inheritance, at which point they receive all of the permissions of that role.

Permissions are additive. If a user is associated with multiple roles, something that's permitted in PE, that user will be able to perform all of the actions described by all of the permissions on all of the roles the user is associated with.

## Structure of Permissions

Permissions are structured as a triple of *type*, *permission*, and *object* with the following characteristics:

**Types** are everything that can be acted on, such as a node groups, users, or user roles.
**Permissions** are what you can do with each type, such as create, edit, view or view.
**Objects** are specific instances of the type.

Some permissions added to the Administrator user role might look like this:

| Type        | Permission    | Object     | Description |
|---          |---            |---           |---          |
|Node groups  | View          | PE Master    | Gives permission to view the PE Master node group.|
|User roles   | Edit          | All          | Gives permission to edit all user roles. |

When no object is specified, a permission will apply to all objects of that type. In those cases, the object is “All”. However, this is be denoted by a “*” in the API.

In both the console and the API, a “*” is used to express a permission for which an object doesn’t make sense, such as when creating users.

## Available Permissions

The table below lists the available object types and their permissions, as well as an explanation of the permission and how to use it. Note that types and permissions have both a display name, which is the name you see in the console interface, and a system name, which is the name you use to construct permissions in the API. In the following table, the display names are used.

| Type              | Permission                              | Definition |
| ---               | ---                                     | ---        |
| Node group        | Edit child group rules                  |The ability to edit the rules of descendents of a node group. This does not grant the ability to edit the rules of the group in the `object` field, only children of that group. This permission is inherited by all descendents of the node group.|
| Node group        | Set environment                         |The ability to set the environment of a node group. This permission is inherited by all descendents of the node group.|
| Node group        | Edit classes, parameters, and variables |The ability to edit every attribute of a node group except its environment and rule. This permission is inherited by all descendents of the node group.|
| Node group        | Create, edit, and delete child groups   |The ability to create new child groups, delete existing child groups, and modify every attribute of child groups, including environment and rules. This permission is inherited by all descendents of the node group.|
| Node group        | View                                    |The ability to see all attributes of a node group, most notably the values of class parameters and variables. This permission is inherited by all descendents of the node group.|
| User              | Create                                  | The ability to create new local users. Remote users are "created" by that user authenticating for the first time with RBAC. Object must always be `"*"`. |
| User              | Reset password                          | The ability to grant password reset tokens to users who have forgotten their passwords. This process also reinstates a user after the use has been revoked. This may be granted per user. |
| User              | Revoke                                  | The ability to revoke/disable a user. This means the user will no longer be able to authenticate and use the console, node classifier, or RBAC. This may be granted per user. |
| User              | Edit                                    | The ability to edit a local user's data, such as name or email. This may be granted per user. |
| User group        | Import                                  | The ability to import groups from the directory service for use in RBAC. Object must always be `"*"`. |
| User role         | Create                                  | The ability to create new roles. Object must always be `"*"`. |
| User role         | Edit                                    | The ability to edit a role. Object must always be `"*"`. |
| User role         | Edit members                            | The ability to change which users and groups a role is assigned to. This may be granted per role. |
| Directory service | View, edit, and test                     | The ability to view, edit, and test directory service settings. Object must always be `'*"`. |
| Console page      | Write                                   | Equivalent to a "read-write" user from old PE user management. Object must always be `"*"`. The console page "view" permission is also required for this to work. |
| Console page      | View                                    | Equivalent to a "read-only" user from old PE user management. Object must always be `"*"`. |


### Display Names and Corresponding System Names

The following table provides both the display and system names for the types and all their corresponding permissions. For more information, see the [permissions API](./rbac_permissionsref.html).

| Type (display name)| Type (system name) | Permission (display name)               | Permission (system name) |
| ---                | ---                | ---                                     | ---                  |
| Node group         | node\_groups       | Edit child group rules                  | edit\_child\_rules   |
| Node group         | node\_groups       | Set environment                         | set\_environment     |
| Node group         | node\_groups       | Edit classes, parameters, and variables | edit\_classification |
| Node group         | node\_groups       | Create, edit, and delete child groups   | modify\_children     |
| Node group         | node\_groups       | View                                    | view                 |
| User               | users              | Create                                  | create               |
| User               | users              | Reset password                          | reset\_password      |
| User               | users              | Revoke                                  | disable              |
| User               | users              | Edit                                    | edit                 |
| User group         | user\_groups       | Import                                  | import               |
| User role          | user\_roles        | Create                                  | create               |
| User role          | user\_roles        | Edit                                    | edit                 |
| User role          | user\_roles        | Edit members                            | edit\_members        |
| Directory service  | directory\_service | View, edit, and test                    | edit                 |
| Console page       | console\_page      | Write                                   | write                |
| Console page       | console\_page      | View                                    | view                 |

## Working With Node Group Permissions

Node groups in the node classifier are structured hierarchically; therefore, node group permissions inherit. Users who have specific permissions on a node group will implicitly receive the permissions on any child groups below that node group in the hierarchy.

Two types of permissions affect a node group: those that affect a group itself, and those that affect the nodes child groups. For example, giving a user the "Set environment" permission on a group will allow the user to set the environment for that group and all of its children. On the other hand, assigning "Edit child group rules" to a group will allow a user to edit the rules for any child group of a specified node group, but not for the node group itself. This allows some users to edit aspects of a group, while other users can be given permissions for all children of that group without being able to affect the group itself.

Due to the hierarchical nature of node groups, if a user is given a permission on the default node group, this is functionally equivalent to giving them that permission on "*".

## What You Should Know About Assigning Permissions

Working with user permissions can be a little tricky. You don't want to grant users permissions that will essentially escalate their role, for example. The following sections describe some strategies and requirements for setting permissions.

#### Grant edit permissions to users with create permissions

Creating new objects doesn't automatically grant the creator permission to view those objects. Therefore, users who have permission to create roles, for example, must also be given permission to edit roles, or they won't be able to see new roles that they create. Our recommendation is to assign users permission to edit all objects of the type that they have permission to create. For example:

| Type              | Permission               | Object       |
| ---               | ---                      | ---          |
| User roles        | Edit members             | All (or `'*"`) |
| Users             | Edit                     | All (or `'*"`) |

#### Avoid granting overly permissive permissions

Operators, a default role in PE, have many of the same permissions as Administrators. However, we've intentionally limited this role's ability to edit user roles. This way, members of this group can do many of the same things as Administrators, but they can't edit (or enhance) their own permissions.

Similarly, be careful of granting users more permissions than their roles allow. For example, if users have the `roles:edit:*` permission, they are able to add the `node_groups:view:*` permission to the roles they belong to, and subsequently see all node groups.

#### Give permission to edit directory service settings to the appropriate users

The directory service password will not be redacted when the settings are requested in the API. Only give `directory_service:edit:*` permission to users who are allowed see the password and other settings.

Similarly, users must be given permission to view all console pages before the permission to modify all console pages will work.

#### The ability to reset passwords should only be given with other password permissions

The ability to help reset passwords for users who forgot them is granted by the `users:reset_password:<instance>` permission. This permission has the side effect of reinstating revoked users once the reset token is used. As such, the reset password permission should only be given to users who are also allowed to revoke and reinstate other users.

#### Users and User Groups are not currently deletable

When granting create/import permissions, it's important to keep in mind that users and user groups are not currently deletable, and roles are not deletable via the console, only by using the API. For this reason, we recommend that you restrict how many users have these permissions.