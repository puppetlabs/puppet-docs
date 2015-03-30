---
layout: default
title: "PE 3.7 » Console » Connecting PE to an External Directory Service"
subtitle: "Connecting Puppet Enterprise to an External Directory Service"
canonical: "/pe/latest/rbac_ldap.html"
---

## Overview
Puppet Enterprise (PE) can connect to external Lightweight Directory Access Protocol (LDAP) directory services through PE's Role-Based Access Control (RBAC) service. This allows you to use existing users and user groups that have been set up in your external directory service. Specifically, you can use PE to:

- authenticate external directory users
- authorize access of external directory users based on RBAC permissions
- store and retrieve the groups and group membership information that has been set up in your external directory

The supported directory services are OpenLDAP and Active Directory.

User accounts that originate from an external directory are referred to as *remote users*. Users that are created in PE are referred to as *local users*. Remote users do not appear in the list of users in PE until they log in to PE for the first time.

You can add both remote and local users directly to user roles. In addition, when an external directory group is imported into PE and assigned to a user role, the remote users that belong to that group all become members of the user role. External directory groups that are imported into PE are called *user groups*. Remote user groups are not bulk imported from an external directory service into PE. Instead, you explicitly import specific user groups from the directory service.

**Note:** The connection to your external LDAP directory is read-only. If you want to make changes to remote users or user groups, you need to edit the information directly in the external directory.

### Connect to an External Directory Service

This section describes how to connect PE to your external directory service. PE only connects to the external directory service when a user logs in or when groups are imported. The table below provides examples of the settings you would use to connect to an Active Directory service and an OpenLDAP service. Each setting is explained in more detail below the table.

>**Note**: To connect to an external directory service, RBAC stores the lookup user's password in plain text in the database, without obfuscation. For security, ensure that the lookup user has read-only access and carefully consider what other people and software could have access to this password.

To connect PE to your external directory service:

1. From the console, click **Access Control**, and then click **External directory**.

2. Fill in the directory information as described in the following table. Note that the settings shown in the table are examples only. You will need to substitute these example settings with the settings used in your directory service.

All of the fields are required except for Login Help, User Relative Distinguished Name, and Group Relative Distinguished Name. If you do not enter User Relative Distinguished Name or Group Relative Distinguished Name, RBAC will search the entire base DN for the user or group.

| Field | Example Active Directory Settings | Example OpenLDAP Settings |
| ---                         | ---                      | ---          |
| **DIRECTORY NAME**    | My Active Directory | My Open LDAP Directory |
| **LOGIN HELP (OPTIONAL)** | https://myweb.com/ldaploginhelp | https://myweb.com/ldaploginhelp |
| **HOSTNAME** | myhost.delivery.exampleservice.net | myhost.delivery.exampleservice.net |
| **PORT** | 389 (636 for LDAPS) | 389 (636 for LDAPS) |
| **LOOKUP USER** | cn=queryuser,cn=Users,dc=puppetlabs,dc=com | cn=admin,dc=delivery,dc=puppetlabs,dc=net |
| **LOOKUP PASSWORD** | The lookup user's password. | The lookup user's password.
| **CONNECTION TIMEOUT (SECONDS)** | 10 | 10 |
| **Connect using SSL?** | Select or leave unchecked | Select or leave unchecked |
| **BASE DISTINGUISHED NAME** | dc=puppetlabs,dc=com | dc=puppetlabs,dc=com |
| **USER LOGIN ATTRIBUTE** | sAMAccountName | cn |
| **USER EMAIL ADDRESS**  | mail | mail |
| **USER FULL NAME**  | displayName | displayName |
| **USER RELATIVE DISTINGUISHED NAME**  | cn=users  | ou=users |
| **GROUP OBJECT CLASS**  | group  | groupOfUniqueNames  |
| **GROUP MEMBERSHIP FIELD**  | member | uniqueMember  |
| **GROUP NAME ATTRIBUTE**  | name  | displayName  |
| **GROUP LOOKUP ATTRIBUTE** | cn | cn |
| **GROUP RELATIVE DISTINGUISHED NAME**  | cn=groups  | ou=groups |


Once you’ve filled in the **External directory** form, click **Test connection** to ensure that the connection has been established. If you’re successful, a green **Success** message will be displayed at the top of the form. Save your settings after you have successfully tested them.

### Explanation of External Directory Settings

**DIRECTORY NAME**

The name that you provide here will be used to refer to the external directory service anywhere it is used in the PE console. For example, when you are viewing a remote user in the PE console, the name that you provide in this field will be listed in the console as the source for that user. Set any name of your choice.

**LOGIN HELP (OPTIONAL)**

This is intended to provide a static link that users can go to for help if they are having difficulty logging in. If you have a help page, enter it here.

#### Connection Information

The settings in this section are used by PE to connect to your external directory.

**HOSTNAME**

This is simply the FQDN of the directory service to which you are connecting.

**PORT**

This is the port that PE will use to access the directory service. The port is generally 389, unless you choose to connect using SSL, in which case it is generally 636.

**LOOKUP USER**

The distinguished name (DN) of the user account that PE will use to look up users when they log in to the console, and to look up groups when they are imported. This user must have read access for all entries that are to be used in the console. We recommend that this user has read-only access to the directory service.

**PASSWORD**

The lookup user's password. This password is **not** stored securely and may be viewed by anyone with the “View, Edit, and Test” permission for the directory service. 


**CONNECTION TIMEOUT (SECONDS)**

The number of seconds that PE will attempt to connect to the directory server before timing out. Ten seconds will be fine in the majority of cases. If you are experiencing timeout errors, make sure the directory service is up and reachable, and then increase the timeout if necessary.

**Connect using SSL?**

Select if you want to use SSL to connect to the external directory. If you select this option, make sure you also specify the SSL port in the **PORT** field above.

**BASE DISTINGUISHED NAME**

When PE constructs queries to your external directory (for example to look up user groups or users), the queries consist of the relative distinguished name (RDN) (optional) + the base distinguished name (DN), and are then filtered by lookup/login attributes. For example, if PE wants to authenticate a user named Bob who has the RDN `ou=bob,ou=users`, it sends a query in which the RDN is concatenated with the DN specified in this field (for example, `dc=puppetlabs,dc=com`). This gives a search base of `ou=bob,ou=users,dc=puppetlabs,dc=com`. 

The base DN that you provide in this field specifies where in the directory service tree to search for groups and users. It is the part of the DN that all users and groups that you want to use have in common. It is commonly the root DN (example `dc=example,dc=com`) but in the following example of a directory service entry, you could set the base DN to `ou=Puppet,dc=example,dc=com` since both the group and the user are also under the organizational unit `ou=Puppet`. 

**Example directory service entry**

	# A user named Harold
	dn: cn=harold,ou=Users,ou=Puppet,dc=example,dc=com
	objectClass: organizationalPerson
	cn: harold
	displayName: Harold J.
	mail: harold@example.com
	memberOf: inspectors
	sAMAccountName: harold11

	# A group Harold is in
	dn: cn=inspectors,ou=Groups,ou=Puppet,dc=example,dc=com
	objectClass: group
	cn: inspectors
	displayName: The Inspectors
	member: harold

#### Attribute Mappings

These settings tell PE which external directory attributes hold the metadata for users.

**USER LOGIN ATTRIBUTE**

This is the directory attribute that the user will use to log in to PE. For example, if you specify `sAMAccountName` as the user login attribute, Harold will log in with the username "harold11" because `sAMAccountName=harold11` in the example directory service entry provided above.

The value provided by the user login attribute must be unique among all entries under the User RDN + Base DN search base you’ve set up. For example, say you’ve selected the following settings:

	base DN = dc=example,dc=com
	user RDN = null
	user login attribute = cn

When Harold tries to log in, the console searches the external directory for any entries under `dc=example,dc=com` that have the attribute/value pair `cn=harold`. (This attribute/value pair does not need to be contained within the DN). However, if there is another user named Harold who has the DN `cn=harold,ou=OtherUsers,dc=example,dc=com`, two results will be returned and the login will not succeed because the console does not know which entry to use.

This problem can be solved in one of two ways:

1. You can narrow your search base such that only one of the entries can be found. In this case, we could set the user RDN to `ou=Puppet` because the second Harold is not in that organizational unit.

2. You can use a value for login attribute that you know to be unique. This makes sAMAccountName a good choice if you’re using Active Directory, as it must be unique across the entire directory.

**USER EMAIL ADDRESS**

This is the directory attribute to use when displaying the user's email address in PE.

**USER FULL NAME**

This is the directory attribute to use when displaying the user's full name in PE.

#### Querying Users

This setting is used by PE to query the directory service for users.

**USER RELATIVE DISTINGUISHED NAME**

The user RDN that you set here is concatenated with the base DN to form the search base when looking up a user. For example, if you specify `ou=users` for the user RDN, and your base DN setting is `ou=Puppet,dc=example,dc=com`, PE will only find users that have `ou=users,ou=Puppet,dc=example,dc=com` in their DN.

This setting is optional. If you choose not to set it, PE will search for the user in the base DN (example: `ou=Puppet,dc=example,dc=com`). Setting a user RDN is helpful in the following situations:

- When you experience long wait times for operations that contact the directory service (either when logging in or importing a group for the first time). Specifying a user RDN will reduce the number of entries that are searched.
- When you have more than one entry under your base DN with the same login value.

#### Querying Groups

These settings are used by PE to query the directory service for groups.

**GROUP OBJECT CLASS**

The name of an object class that all groups have.

**GROUP MEMBERSHIP FIELD**

Tells PE how to find which users belong to which groups. This is the name of the attribute in the external directory groups that indicates who the group members are.

**GROUP NAME ATTRIBUTE**

The attribute that stores the display name for groups. This is used for display purposes only.

**GROUP LOOKUP ATTRIBUTE**

The value used to import groups into PE. Given the example directory service entry provided above, the group lookup attribute would be `cn`. When specifying the Inspectors group in the console to import it, you would provide the name `inspectors`.

The value for this attribute must be unique under your search base. If you have users with the same login as the lookup of a group that you would like to use, you can narrow the search base, use a value for the lookup attribute that you know to be unique, or specify the **GROUP OBJECT CLASS** that all of your groups have in common but your users do not.

**GROUP RELATIVE DISTINGUISHED NAME**

The group RDN that you set here is concatenated with the base DN to form the search base when looking up a group. For example, if you specify `ou=groups` for the group RDN, and your base DN setting is `ou=Puppet,dc=example,dc=com`, PE will only find groups that have `ou=groups,ou=Puppet,dc=example,dc=com` in their DN.

This setting is optional. If you choose not to set it, PE will search for the group in the base DN (example: `ou=Puppet,dc=example,dc=com`). Setting a group RDN is helpful in the following situations:

- When you experience long wait times for operations that contact the directory service (either when logging in or importing a group for the first time). Specifying a group RDN will reduce the number of entries that are searched.
- When you have more than one entry under your base DN with the same lookup value.

>**Note**: At present, PE only supports a single Base DN. Use of multiple user RDNs or group RDNs is not supported.


See [Working with User Roles](./rbac_user_roles.html) for information about managing users and groups.

Next, see [Working with Users and User Groups from an External Directory Service](./rbac_user_roles.html#working-with-users-and-user-groups-from-an-external-directory-service).
