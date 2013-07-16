---
layout: default
title: "PE 2.5 » Console » User Management and Authorization"
subtitle: "Managing Console Users"
canonical: "/pe/latest/console_auth.html"
---

Starting with PE 2.5, the console supports individual user management, access and authentication. Instead of a single, shared username and password authenticated over HTTP with SSL, the console now allows secure individual user accounts with different access privileges. Specifically, user accounts now allow the assignment of one of three access levels: read-only, read-write, or admin.

Following standard security practices, user passwords are hashed with a salt and then stored in a database separated from other console data. Authentication is built on CAS, an industry standard, single sign-on protocol.

**Note:** By default, CAS authentication for the console runs over port 443. If your console needs to access CAS on a different host/port, you can configure that in `/etc/puppetlabs/console-auth/cas_client_config_yml`.

User Access and Privileges
-----
Depending on the access privileges assigned to them, users will be able to see and access different parts of the console:

_Read-Only Users_ can only view information on the console, but cannot perform any actions. In particular, read-only users are restricted from:

* cloning resources in Live Management
* accessing the Control Puppet tab in Live Management
* accessing the Advanced Tasks tab in Live Management
* accepting or rejecting changes to the baseline in Compliance
* adding, editing, or removing nodes, groups, or classes

_Read-Write Users_ have access to all parts of the console EXCEPT the user-management interface. Read-write users can interact with the console and use it to perform node management tasks. 

_Admin Users_ have unrestricted access to all parts of the console, including the user-management interface. Through this interface, admin users can:

* add a new user
* delete a user
* change a user's role
* re-enable a disabled user
* disable an enabled user
* edit a user's email
* prompt a change to the user's password

There is one exception to this: admin users cannot disable, delete or change the privileges of their own accounts. Only another admin user can make these changes.

_Anonymous Users_ In addition to authenticated, per-user access, the console can also be configured to allow anonymous, read-only access. When so configured, the console can be viewed by anyone with a web browser who can access the site URL. For instructions on how to do this, visit the [advanced configuration page](./config_advanced.html).

Managing Accounts and Users
------

### Signing Up

In order to sign up as a console user at any access level, an account must be created for you by an admin. Upon account creation, you will receive an email containing an activation link. You must follow this link in order to set your password and activate your account. The link will take you to a screen where you can enter and confirm your password, thereby completing account activation. Once you have completed activation you will be taken to the Login screen where you can enter your new credentials.

![activation screen](./images/console/user_activation.jpg)

### Logging In

You will encounter the login screen whenever you try to access a protected part of the console. The screen will ask for your email address and password. After successfully authenticating, you will be taken to the part of the console you were trying to access.

When you're done working in the console, choose *Logout* from the user account menu. Note that you will be logged out automatically after 48 hours.

![login screen](./images/console/login.jpg)

### Viewing Your User Account

To view your user information, access the user account menu by clicking on your username (the first part of your email address) at the top right of the navigation bar. 

![account menu](./images/console/user_account_menu.jpg)

Choose *My account* to open a page where you can see your username/email and your user access level (admin, read-write or read-only) and text boxes for changing your password.

![user account screen](./images/console/user_account_signin.jpg)

### User Administration Tools

Users with admin level access can view information about users and manage their access, including adding and deleting users as needed. Admin level users will see an additional menu choice in the user account menu: *Admin Tools*. Users with read-write or read-only accounts will NOT see the *Admin Tools* menu item.

![admin account menu](./images/console/admin_account_menu.jpg)

#### Viewing Users and Settings

Selecting *Admin Tools* will open a screen showing a list of users by email address, their access role and  status. Note that users who have not yet activated their accounts by responding to the activation email and setting a password will show a status of *pending*. 

![user listing screen](./images/console/user_admin_screen.jpg)

Click on a user's row to open a pop-up pane with information about that user. The pop-up will show the user's name/email, their current role, their status and other information. If the user has not yet validated their account, you will also see the link that was generated and included in the validation email. Note that if there is an SMTP issue and the email fails to send, you can manually send this link to the user.

![user listing screen](./images/console/user_popup_pending.jpg)

#### Modifying User Settings

To modify the settings for a given user, click on the user's row to open the pop-up pane. In this pane, you can change their role and their email address or reset their password. Don't forget to click the *Save changes* button after making your edits. 

Note that resetting a password or changing an email address will change that user's status back to *Pending*, which will send them another validation email and require them to complete the validation and password setting process again.

For users who have completed the validation process, you can also enable or disable a user's account. Disabling the account will prevent that user from accessing the console, but will not remove them from the users database.

![user listing screen](./images/console/user_popup_active.jpg)

#### Adding/Deleting Users

To add a new user, open the user admin screen by choosing *Admin Tools* in the user menu. Enter the user's email address and their desired role, then click the "Add user" button. The user will be added to the list with a *pending* status and an activation email will be automatically sent to them.

To delete an existing user (including pending users), click on the user's name in the list and then click the *Delete account* button. Note that deleting a user cannot be undone, so be sure this is what you want to do before proceeding.

### Creating Users From the Command Line

From PE 2.5.2 onward, you can create new console users from the command line. This can be used to automate user creation or import large numbers of users from an external source at once. 

Command line user creation is done with a rake task. Due to a bug in PE 2.5.2 and 2.5.3, this task must be performed from a specific working directory, so keep this in mind if building scripts around it. 

On the console server, the following commands will add a new user:

    $ cd /opt/puppet/share/console-auth
    $ sudo /opt/puppet/bin/rake db:create_user EMAIL="<email address>" PASSWORD="<password>" ROLE="< Admin | Read-Only | Read-Write >"

Thus, to add a read-write user named jones@example.com, you would run:

    $ cd /opt/puppet/share/console-auth
    $ sudo /opt/puppet/bin/rake db:create_user EMAIL="jones@example.com" PASSWORD="good_password_1" ROLE="Read-Write"

You cannot currently delete or disable users or reset passwords from the command line. 

* * * 

- [Next: Grouping and Classifying Nodes](./console_classes_groups.html) 
