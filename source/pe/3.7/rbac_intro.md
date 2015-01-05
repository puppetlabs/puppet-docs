---
layout: default
title: "PE 3.7 » Console » Working with Role-Based Access Control"
subtitle: "Role-Based Access Control"
canonical: "/pe/latest/rbac_intro.html"
---

##Overview

Puppet Enterprise (PE) provides role-based access control (RBAC). RBAC enables you to manage users' privileges, essentially answering the question, "Is this user allowed to perform these actions?" For example, "can this user grant password reset tokens to other users who have forgotten their passwords?" Or, "can that user edit a local user's data?" Permissions are used to define what actions users can perform on designated objects.

*User roles* are a set of permissions you can assign to multiple users. Users are assigned to user roles, and that way, they inherit the permissions that are designated for that role. PE ships with three default user roles: Administrators, Operators, and Viewers. In addition, you can create custom roles.

You manage user access by assigning specific users to roles. Permissions can be set for the activity log, console, directory service, node groups, user groups, user roles, and users. For example, you might want to create a user role that grants users permission to view but not edit a specific subset of node groups. Or you might want to divide up administrative privileges so that one user role is able to reset passwords while another can edit roles and create users.

###External Directories
PE now connects with external directories, which means you only have to manage your users in one location instead of across both PE and your directory. Currently, OpenLDAP and Active Directory are supported. If you have pre-defined groups in your Active Directory or OpenLDAP instances, you can import them into the PE console and assign roles to them. Any user in the imported group will inherit membership of the role to which the group was assigned. And if new users are added to the group in the external directory, they also inherit membership of the role to which that group belongs.

### RBAC and Activity Services
RBAC functionality is handled in a large part by the RBAC and activity services. The RBAC service gets user, group, and permission information . The activity service logs events on the **Activity** pages for user roles, users, and user groups.

>**Note**: Resetting the admin password for console access relies on a utility script that's located in the installer tarball. See [Troubleshooting User Access to the Console](./rbac_user_roles.html) for steps to reset the admin password.

See the following sections for information and steps to work with RBAC:

* [Connecting Puppet Enterprise with LDAP Services](./rbac_ldap.html)
* [RBAC Permissions](./rbac_permissions.html)
* [Working with User Roles](./rbac_user_roles.html)
	* [Creating Custom Roles](./rbac_user_roles.html#create-a-new-user-role)
	* [Assigning Permissions to a User Role](./rbac_user_roles.html#assign-permissions-to-a-user-role)
	* [Adding Users to Roles](./rbac_user_roles.html#add-a-user-to-a-user-role)
	* [Working with Users and User Groups from an External Directory Service](./rbac_user_roles.html#working-with-users-and-user-groups-from-an-external-directory-service)
* [RBAC Service Endpoints](./rbac_serviceindex.html)
* [Activity Service Endpoints](./rbac_activityapis.html)

For more information about working with nodes, see [Grouping and Classifying Nodes](./console_classes_groups.html).




