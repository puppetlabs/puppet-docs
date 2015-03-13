---
layout: default
title: "PE 3.7 » Console » Working with Role-Based Access Control"
subtitle: "Role-Based Access Control"
canonical: "/pe/latest/rbac_intro.html"
---

##Overview

In Puppet Enterprise (PE), you can use role-based access control (RBAC) to manage user permissions. Permissions define what actions users can perform on designated objects. For example, "can the user grant password reset tokens to other users who have forgotten their passwords?" Or, "can the user edit a local user's metadata?" Or "can the user edit class parameters in a node group?"

Permissions are managed through *user roles*. To grant a permission to a user, you first need to assign the user to one or more user roles. Users inherit all of the permissions from each user role they are in. PE ships with three default user roles: Administrators, Operators, and Viewers. In addition, you can create custom roles.

Permissions can be set for the activity log, console, directory service, node groups, user groups, user roles, and users. For example, you might want to create a user role that grants users permission to view but not edit a specific subset of node groups. Or you might want to divide up administrative privileges so that one user role is able to reset passwords while another can edit roles and create users. A full list of available permissions is available in [About RBAC Permissions](./rbac_permissions.html).

###External Directories
PE can connect to external LDAP directories. This means that you can create and manage users locally in PE, import users and groups from an existing directory, or do a combination of both. PE supports OpenLDAP and Active Directory. If you have predefined groups in your Active Directory or OpenLDAP directory, you can import the groups into the PE console and assign user roles to them. Users in an imported group will inherit the permissions specified in assigned user roles. If new users are added to the group in the external directory, they also inherit the permissions of the role to which that group belongs.

### RBAC and Activity Services
Access control is handled by the RBAC and activity services. You can interact with these two services through the PE console. Alternatively, you can use the [RBAC service API](./rbac_serviceindex.html) and the [activity service API](./rbac_activityapis.html). The RBAC service manages users, user groups, user roles, permissions, external directory connections, and passwords. The activity service logs events for user roles, users, and user groups.

>**Note**: Resetting the admin password for console access relies on a utility script that's located in the installer tarball. See [Troubleshooting User Access to the Console](./rbac_user_roles.html) for steps to reset the admin password.

For more information about using RBAC, see:

* [Connecting Puppet Enterprise with LDAP Services](./rbac_ldap.html)
* [RBAC Permissions](./rbac_permissions.html)
* [Working with User Roles](./rbac_user_roles.html)
	* [Creating Custom Roles](./rbac_user_roles.html#create-a-new-user-role)
	* [Assigning Permissions to a User Role](./rbac_user_roles.html#assign-permissions-to-a-user-role)
	* [Adding Users to Roles](./rbac_user_roles.html#add-a-user-to-a-user-role)
	* [Working with Users and User Groups from an External Directory Service](./rbac_user_roles.html#working-with-users-and-user-groups-from-an-external-directory-service)
* [RBAC Service Endpoints](./rbac_serviceindex.html)
* [Activity Service Endpoints](./rbac_activityapis.html)

For information about classifying nodes, see [Grouping and Classifying Nodes](./console_classes_groups.html).




