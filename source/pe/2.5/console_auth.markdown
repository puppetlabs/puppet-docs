---
layout: pe2experimental
title: "PE 2.5 » Console » Managing Users"
---

* * *

&larr; [Console: Viewing Reports and Inventory Data](./console_reports.html) --- [Index](./) --- [Console: Grouping and Classifying Nodes](./console_classes_groups.html) &rarr;

* * *

Managing Console Users
=====

Starting with PE 2.5, the Console supports role-based access control. Instead of a single, shared username and password authenticated over HTTP with SSL, the console now allows individual user accounts. Moreover, these accounts now allow the assignment of one of three user roles: read-only, read-write, or admin.

Following standard security practices, user passwords are hashed with a salt and then stored in a database separated from other console data. Authentication is built on CAS, an industry standard, single sign-on protocol.

User Roles and Access Privileges
-----
Depending on the role assigned to them, users will be able to see and access different parts of the console. Specifically:

_Read-Only Users_ can only view information on the console, but cannot perform any actions. In particular, read-only users are restricted from:

* cloning resources in Live Management
* accessing the Control Puppet tab in Live Management
* accessing the Advanced Tasks tab in Live Management
* accepting or rejecting changes to the baseline in Compliance
* adding, editing, or removing nodes, groups, or classes

_Read-Write Users_ have access to all parts of the console EXCEPT the user-management interface. Read-write users can interact with console and use it to perform node management tasks. 

_Admin Users_ have unrestricted access to all parts of the console, including the user-management interface. Through this interface, admin users can:

* add a new user
* delete a user
* change a user's role
* re-enable a disabled user
* disable an enabled user
* edit a user's email
* prompt a change to the user's password

There is one exception to this: admin users cannot disable, delete or change the privileges of their own accounts. Only another admin user can make these changes.

_Anonymous Users_ In addition to authenticated, per-user access, the console can also be configured to allow anonymous, read-only access. When so configured, the console can be viewed by anyone with a web browser who can access the site URL.

User Management Tab
======


* * *

&larr; [Console: Viewing Reports and Inventory Data](./console_reports.html) --- [Index](./) --- [Console: Grouping and Classifying Nodes](./console_classes_groups.html) &rarr;

* * *

