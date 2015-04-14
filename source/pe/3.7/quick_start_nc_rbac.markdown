---
layout: default
title: "PE 3.7 » Quick Start » Classifying Nodes and Assigning User Permissions"
subtitle: "Node Classification and Role-Based Access Control Quick Start Guide"
canonical: "/pe/latest/quick_start_nc_rbac.html"
---


## Overview

The Puppet Enterprise (PE) console enables you to manage nodes groups and users. You can create node groups and then assign classes to nodes through those node groups. You can connect with an external directory, such as Active Directory or OpenLDAP, and import users and groups, rather than creating users and groups in two locations. You can also create user roles, and assign users to those roles. Roles are granted permissions, such as permission to act on node groups. When you assign roles to users or user groups, you are essentially granting users permissions in a more organized way.

In this guide, you'll create a new node group, apply rules to the group to define the nodes it will include, and add classes to the group. You'll also create a new user role and give the role view permissions on your node group. Finally, you’ll create a new local user, and assign a user role to that user.  This guide doesn't attempt to connect with an OpenLDAP or Active Directory. For more information, see [Working with Role-Based Access Control](./rbac_intro.html).

>Note: Users and user groups are not currently deletable. And roles aren’t deletable via the console, only by API. Therefore, we recommend that you try out these steps on a virtual machine.

[assign_rule]: ./images/quick/assign_rule.png
[role_views_node_group]: ./images/quick/role_views_node_group.png

> **Prerequisites**: This guide assumes you've already [installed a monolithic PE deployment](./quick_start_install_mono.html), and have installed at least one [*nix agent node](./quick_start_install_agents_nix.html) or one [Windows node](./quick_start_install_agents_windows.html).
>
> It also assumes you’ve installed a [*nix](./quick_start_module_install_nix.html) or [Windows](./quick_start_module_install_windows.html) module. Finally, you must have admin permissions to complete these steps, which include assigning a user to a role.


## Create a New Node Group

1. In the PE console, click **Classification**.
2. In the **Node group name** field, type "web_app_servers".
3. Leave **default** as the parent to the new node group, and **production** as the environment.
4. Click **Add Group**.  The **web_app_servers** group is added to the list of node groups.

## Add Nodes to the New Node Group

To add nodes to a node group, you create rules that define which nodes should be included in the group.

1. On the **Classification** page, click to open the **web_app_servers** node group.
2. On the **Rules** tab, in the **Fact** field, type or select "osfamily."
3. On the **Operator** drop-down list, select **is**, and in the **Value** field, type "RedHat" or "Windows" depending on the type of OS you're using for your agent.

    As you type in the rule, the number in the **Node matches** column changes to indicate how many nodes this rule will affect.

    ![adding rule to node group][assign_rule]

4. Click **Add rule**, and then click the commit button.

## Add Classes to the Node Group

Now that you've created a node group, you'll add classes to give the matching nodes purpose.

1. On your **web_app_servers** page, click the **Classes** tab.
2. In the **Add new class** field, if you’re a *nix user, select `apache`. If you’re a Windows user, select `registry`.
3. Click **Add class**.
4. In the **Parameter** box, click **Parameter name** and select a parameter from the drop-down list, such as `apache_version`. Note that for many parameters, the **Value** field is automatically populated.
5. Click **Add parameter**, and then click the commit button.

You can check these changes by clicking **Nodes**, then clicking one of the nodes from your node group. In the **Classes** list, you'll see the `apache` class with the **Source group** `web_app_servers`.


## Create a New User Role

Add a user role so you can manage permissions for groups of users at once.

1. In the console, click **Access Control** and then click **User Roles**.
2. For **Name**, type "Web developers," and then for **Description**, type a description for the Web developers role, such as "web developers."
3. Click **Add role**.

## Create a New User and Add the User to Your New Role

These steps demonstrate how to create a new local user. See [Adding LDAP Users to PE](./rbac_user_roles.html#adding-ldap-users-to-pe) for information about adding existing users from your directory service.

1. On the **Access Control** page, click **Users**.
2. In the **Full name** field, type in a user name.
3. In the **Login** field, type the user's login information.
4. Click **Add local user**.

	**Note**: When you create new local users, you need to send them a login token. Do this by clicking the new user's name in the **User** list and then on the upper-right of the user's page, click **Generate password reset**. A message opens with a link that you must copy and send to the new user.

5. Click **User Roles** and then click **Web developers**.
6. On the **Member users** tab, on the **User name** list, select the new user you created, and then click **Add user** and click the commit button.

## Enable a User to Log in
When you create new local users, you need to send them a password reset token so that they can log in for the first time.

1. Click the new local user in the **Users** list.
The new user's page opens.
2. On the upper-right of the page, click **Generate password reset**. A **Password reset link** message box opens.
3. *Copy the link* provided in the message and send it to the new user. Then you can close the message.

## Give Your New Role Access to the Node Group You Created

1. From the **Web developer** role page, click the **Permissions** tab.
2. In the **Type** box, select **Node groups**.
3. In the **Permission** box, select **View**.
4. In the **Object** box, select **web-app_servers**.
5. Click **Add permission**, and then click the commit button.
Now, you have given members of the `Web developers` role permission to view the `web_app_servers` node group.

![assigning role to node group][role_views_node_group]


----------

Next: [Writing Modules (Windows)](./quick_start_module_install_windows.html) or [Writing Modules (*nix)](./quick_writing_nix.html)
