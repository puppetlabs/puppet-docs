---
layout: default
title: "PE 3.7 » Console » Connecting PE with External Directory Services"
subtitle: "Connecting Puppet Enterprise with LDAP Services"
canonical: "/pe/latest/rbac_ldap.html"
---

## Overview
Puppet Enterprise (PE) can now connect with directory services, specifically OpenLDAP and Active Directory, through the Role-Based Access Control (RBAC) service. This connection enables PE to authenticate users and manage user roles that exist in Lightweight Directory Access Protocol (LDAP) directory services. 

User accounts that originate from an LDAP service are referred to as *remote users*. Users that are created in PE are referred to as *local users*. You can assign roles directly to both remote and local users. However, remote users are also assigned to user roles through the LDAP groups they belong to. When an LDAP group is imported into PE and assigned to roles, the users that belong to that group are also assigned to those roles. LDAP groups imported into PE are called *user groups*.

Remote users are not bulk imported from the directory service into PE. Instead, you explicitly import user groups from the directory service. Remote users must log into PE before they can be seen and managed in RBAC.

If remote users aren’t assigned to a group in the directory service, they can still be added to user roles in PE. In those cases, the users must still log in to create an initial RBAC record before they can be added to roles.

This section describes how to connect PE to your external directory service. See [Working with User Roles](./rbac_user_roles.html) for information about managing users and groups. In particular, find out how to [work with users and user groups from an external directory service](./rbac_user_roles.html#working-with-users-and-user-groups-from-an-external-directory-service).

###About LDAP Queries
Queries are constructed using the LDAP Data Interchange Format (LDIF). They consist of the Relative Distinguished Name (RDN) (optional) + the base DN (distinguished name) as a search base, and are then filtered by the "lookup" (or "login") attribute.

For example, when specifying a user RDN and querying for a user, Bob, to authenticate, the user RDN (for example, `ou=bob,ou=users`) is concatenated with the base DN (for example, `dc=puppetlabs,dc=com`) to form the search base: `ou=bob,ou=users,dc=puppetlabs,dc=com`. Then the results are filtered to find an entity that has the user lookup attribute. This lookup must return only one entity or the search (for importation, authentication, or syncing) will fail. These same rules apply to the importation of groups.

There is currently an issue where group importation does not respect the group
object class setting, but the group membership syncing does. This means that
groups can be imported that do not match the specified object class type, and
as such, those groups will never be associated with their members.

If you want to use more than one group object class, to solve the above
problem or otherwise, the group object class can be set to "\*".

### Connect to an External Directory Service

You connect to an external directory service by providing the following information to the PE console.

>**Note**: At present, PE only supports a single Base DN.
>
>  * Use of multiple user RDNs or group RDNs is not supported.
>  * Cyclical group relationships in Active Directory will prevent a user from logging in.
>
>**Additionally**: To connect to an LDAP server, RBAC needs to store the username and password configured here, not just a hash of the password. This password must be recoverable in the context of PE. The password is stored in the database in plain text without obfuscation. To guarantee its security, ensure that other processes do not have OS-level read permissions for PE's database or configuration files.

1. From the console, click **Access Control**, and then click **External directory**.
2. Fill in the directory information as described in the following table. All of the fields except for **Login help**, **User relative distinguished name**, and **Group relative distinguished name** are required. If you do not enter a **User relative distinguished name** or **Group relative distinguished name**, RBAC will search the entire base DN for the user or group, rather than just the subtree specified by the user or group RDN.

| Field                     | Description        | Example       |
| ---                         | ---                      | ---          |
| Directory name    | Used to refer to the service anywhere it’s mentioned in the UI. | MyActiveDirectory |
| Login help (optional) | Static link for LDAP login assistance | https://myweb.com/ldaploginhelp |
| Hostname | FQDN of the directory service. | myhost.delivery.exampleservice.net |
| Port | The port that PE will use to access the directory service. | 636 |
| Lookup User | Distinguished name of the user to perform directory lookups. | ou=admin,dc=delivery,dc=puppetlabs,dc=com |
| Lookup password | Password of the user who performs lookups. | <password>
| Connection timeout | Number of seconds before the connection will time out. | 10 |
| Connect using SSL | Choose whether to use secure socket layer. See the [note below about validating SSL certificates](#Verify-Directory-Server-Certificates). | Select or leave unchecked |
| Base distinguished name | Where in the LDAP tree to find groups and users. | dc=puppetlabs,dc=com |
| User login attribute | Value for users who log in. | cn |
| User email address  | Email address of user | ries@example.com |
| User full name  | User’s full name. | displayName |
| User relative distinguished name  | The base distinguished name for querying users.  | ou=Users |
| Group object class  | The kind of object that represents groups.  | group  |
| Group membership field  | The way to fetch group membership information. | member  |
| Group name attribute  | The display name for a group.  | name  |
| Group lookup attribute | cn is the default. | cn |
| Group relative distinguished name  | The base distinguished name for looking up groups.  | ou=Groups |


Once you’ve filled in the **External directory** form, click **Test connection** to ensure that the connection has been established. If you’re successful, a green **Success** message will be displayed at the top of the form. Save your settings after you have successfully tested them.

### Verify Directory Server Certificates

If you select **Connect using SSL** when setting up your external directory connection, your connection to the directory will be encrypted. If you would also like to verify the directory server's SSL certificate to ensure that RBAC isn't being subjected to a Man-in-the Middle (MITM) attack, you need to take the additional step of configuring a setting in your HOCON configuration file.

The RBAC service verifies directory server certificates using a trust store file, in Java Key Store (JKS) or PKCS12 format, that contains the chain of trust for the directory server's certificate. This file needs to exist on disk in a location that is readable by the user running the RBAC service.

To turn on verification, set the value of the `ds-trust-chain` key in `/etc/puppetlabs/console-services/conf.d/rbac.conf` to be the absolute path to the trust store file. Once this value is set, the directory server's certificate will be verified whenever RBAC is configured to connect to the directory server using SSL.

Example of `rbac.conf`:


	rbac: {
  	certificate-whitelist: "/etc/puppetlabs/console-services/rbac-certificate-whitelist"
  	token-private-key: "/opt/puppet/share/console-services/certs/ubuntu1404.private_key.pem"
  	token-public-key: "/opt/puppet/share/console-services/certs/ubuntu1404.cert.pem"
  	ds-trust-chain: "/opt/puppet/share/console-services/certs/example.pem"
	}


Next, see [Working with Users and User Groups from an External Directory Service](./rbac_user_roles.html#working-with-users-and-user-groups-from-an-external-directory-service).
