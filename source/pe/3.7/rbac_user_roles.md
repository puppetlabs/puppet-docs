---
layout: default
title: "PE 3.7 » Console » Working with User Roles"
subtitle: "Creating and Managing Users and User Roles"
canonical: "/pe/latest/rbac_user_roles.html"
---

## Overview

User roles are sets of permissions you can apply to multiple users in Puppet Enterprise (PE). Role-based access control (RBAC) enables you to manage users &#8212; what they can create, edit, or view, and what they can't &#8212; in an organized, high-level way that is vastly more efficient than managing user permissions on a per-user basis.

> Note: Users must be assigned to roles before they can work in PE. You can't assign permission to single users, only to roles.

PE provides three pre-defined roles, Administrators, Operators, and Viewers, that have been given a handful of permissions based on the function of the roles. You can also define your own custom roles.

This section describes how to create a new user, create a new user role, assign permissions to a user role, and add a user to a user role. You'll also find out how to import a user group from an LDAP directory and then assign it to a user role.

### Create a New User
These steps add a local user. To add a user from an external directory, see [Working with Users and User Groups from an External Directory](./rbac_user_roles.html#working-with-user-groups-and-users-from-an-external-directory-service), below.

1. In the console, click **Access Control**, and then click **Users**.
2. On the **Users** page, in the **Full name** field, type in a user name.
3. In the **Login** field, type the user's login information.
4. Click **Add local user**.

### Enable a User to Log in
When you create new local users, you need to send them a password reset token so that they can log in for the first time.

1. Click the new local user in the **Users** list.
The new user's page opens.
2. On the upper-right of the page, click **Generate password reset**. A **Password reset link** message box opens.
3. *Copy the link* provided in the message and send it to the new user. Then you can close the message.


### Create a New User Role
Users with the appropriate permissions, for example, Administrators, can define custom roles. Only users who are allowed all permissions should be given the permission to edit user roles; otherwise, the user will be capable of privilege escalation.

1. In the console, click **Access Control** and then click **User Roles**.
2. For **Name**, type a name for the role, and then for **Description**, type a description for the role.
3. Click **Add role**.

### Assign Permissions to a User Role
Before you begin assigning permissions to a user role, make sure you have reviewed the information on [RBAC permissions](./rbac_permissions.html). In particular, see the section "What You Should Know About Assigning Permissions," to learn some important considerations about how permissions work in PE.

1. In the list of user roles, click a user role that you want to add permissions to.
2. Click the **Permissions** tab.
3. In the **Type** box, select the type of object you want to assign permissions for, such as **Node groups**.
4. In the **Permission** box, select the permission you want to assign, such as **View**.
5. In the **Object** box, select the specific object you want to assign the permission to. For example, if you are setting a permission to view the type, **Node groups**, select the specific node this user role will have permissions to view.
6. Click **Add permission**, and then click the commit button.


### Add a User to a User Role
When you add users to a role, the user gains the permissions that are applied to that role. As has been mentioned, a user can't do anything in PE until they have been assigned to a role.

1. In the list of user roles, click a user role that you want to add a user to.
2. Click the **Member users** tab.
3. In the **User name** field, from the drop-down list, select the user you want to add,  click **Add user**, and then click the commit button.

## Working with User Groups and Users from an External Directory Service

You import existing LDAP groups to PE explicitly, which means you add the group by name. Once you’ve imported a group, you can assign it to a user role, and then begin assigning permissions to it.

### Adding LDAP Users to PE

You don’t explicitly add LDAP users to PE. Instead, LDAP users must log into PE, which creates a record of the user in PE. If the user belongs to an LDAP group that has been imported into PE and then assigned to a role, the user will be assigned to that role and will gain the privileges of the role. Roles are additive: You can assign users to more than one role, and they will gain the privileges of all the roles to which they are assigned.

### Import a User Group
1. On the **Access Control** tab, click **User groups**.
2. In the **Login** field, type the name of a group from your directory service, and then click **Add group**.
The group is added to the **User group** list.
3. Click the name of the group you added.

	A new page opens with tabs for **User roles**, **Users**, and **Activity**. Note that no user roles will be listed until you add this group to a role. No users will be listed until a user who belongs to this group logs into PE. The **Activity** tab lists any changes made to the group. If you have just imported a group, the date the group was added will be listed, as well as some other pertinent information.

### Assign a User Group to a User Role

You can add user groups to existing roles, or you can create new roles, as described previously, and then add the group to the new role. Assign user groups to user roles as follows.

1. Click **User roles**, and then click the role you want to add the user group to.
Alternatively, you can create a new user role.
2. Click **Member groups**, and then on the **Group name** drop-down list, select the user group you want to add to the user role.
3. Click **Add group**, and then click the commit button.

## Troubleshooting Admin and User Access to the Console

For any number of reasons, you might need to either reset the admin password for PE console access, or the passwords of other users. The process is different in each case.

### Reset the Admin Password

In RBAC, one of the built-in users is the admin, a superuser with all available read/write privileges. In the event you need to reset the admin password for console access, you'll have to run a utility script located in the [PE 3.7.0 installer tarball](http://puppetlabs.com/misc/pe-files). Note that the PE 3.7 tarball might have moved to the [previous releases page](http://puppetlabs.com/misc/pe-files/previous-releases).

This script uses a series of API calls authenticated with a whitelisted certificate to reset the built-in admin's password.

The script can only be invoked under these conditions:

* It must be run from the command line of the console system. In a split install, it cannot be run from the Puppet master.
* It is not directly executable. It must be invoked using the version of Ruby shipped with PE, using `/opt/puppet/bin/ruby`.
* A console-services whitelisted certificate must be specified in order to run the command. The example command below dynamically specifies the correct certificate.

The reset script:

    q_puppet_enterpriseconsole_auth_password=newpassword q_puppetagent_certname=$(puppet config print certname) /opt/puppet/bin/ruby u\pdate-superuser-password.rb


The script is not installed onto the system by default. The two environment arguments in the script come from the [installation answers file](./install_answer_file_reference.html), and have the same meaning and semantics.

Admins have root access to the systems and therefore access to the whitelisted certificates needed to reset the admin password through the API.

### Generate a User Password Reset Token

When users forget passwords or lock themselves out of the console by attempting to log in with incorrect credentials too many times, you need to generate a password reset token. You can do this from the console or by using API calls. To generate a password reset token from the console, see the steps in the section, [Enable a User to Log in](./rbac_user_roles.html#enable-a-user-to-log-in). To learn more about using API calls to generate the token, see the [RBAC service password APIs](./rbac_passwords.html).

