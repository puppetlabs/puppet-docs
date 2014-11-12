---
title: "PE 3.7 » RBAC Service 1.0 >> Endpoints"
layout: default
subtitle: "RBAC Endpoints"
canonical: "/pe/latest/rbac_serviceindex.html"
---

The role-based access control (RBAC) service enables you to manage users, user groups, and roles.

## Forming RBAC Service Requests

To make well-formed HTTP(S) requests to the RBAC v1 API, use the following port and path:

    https://localhost:4433/rbac-api/v1

In the request path, `localhost:4433` are the machine and port if you're making the call from the console machine. If you're not making the call from the console machine, then use the console machine's hostname in place of `localhost`.

For example:

	GET	http://localhost:4433/rbac-api/v1/users


#### Content-Type Headers

All `PUT` and `POST` requests with non-empty bodies should have the `Content-Type` header set to `application/json`.

The service consists of the endpoints below.

## [Users](./rbac_users.html)
RBAC enables you to manage local users as well as those who are created remotely, on a directory service. With the users endpoints, you can get lists of users, and you can create new local users.

## [User Groups](./rbac_usergroups.html)
The `user groups` endpoints enable you to get lists of groups and add a new remote user group.

## [Roles](./rbac_roles.html)
By assigning roles to users, you can manage them in sets that are granted access permissions to various Puppet Enterprise (PE) objects. This makes tracking user access more organized and easier to manage. The `roles` endpoints enable you to get lists of roles and create new roles.

## [Permissions](./rbac_permissionsref.html)
You assign permissions to user roles to manage user access to objects in PE. The `permissions` endpoints enable you to get information about available objects and the permissions that can be constructed for those objects. You can also check an array of permissions.

## [Directory Service](./rbac_dsref.html)
RBAC enables you to connect with a directory service and work with users and groups already established on your directory service. The `ds` endpoints enable you to get information about the directory service, test your directory service connection, and replace directory service connection settings.

## [Passwords](./rbac_passwords.html)
When users forget passwords or lock themselves out of PE by attempting to log in with incorrect credentials 10 times, you'll have to generate a password reset token for them. The `password` endpoints enable you to generate password reset tokens for a specific user or with a token that contains a temporary password in the body.

##Additional RBAC Service Information

## [Errors](./rbac_serviceerrors.html)
Describes the errors you might receive when making RBAC service calls.

## [Configuration Options](./rbac_config.html)
Describes RBAC configuration options for things, such as how long a password reset token remains valid or how long before a session will time out.


