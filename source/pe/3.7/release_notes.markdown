---
layout: default
title: "PE 3.8 » Release Notes"
subtitle: "Puppet Enterprise 3.8 Release Notes"
canonical: "/pe/latest/release_notes.html"
---

This page contains information about new features and general improvements in the latest Puppet Enterprise (PE) release.

For more information about this release, also see the [Known Issues](./release_notes_known_issues.html) and [Security Fixes](./release_notes_security.html).

This page contains information about new features and general improvements and changes in the latest Puppet Enterprise (PE) release.

For more information about this release, also see the [Known Issues](./release_notes_known_issues.html) and [Security and Bug Fixes](./release_notes_security.html).

## New Features in PE 3.8.0

### Deleting a User From RBAC

In this release, there is a new endpoint in the Role-Based Access Control API that allows you to delete a local or remote user from PE. For more information, see the [API documentation](./rbac_users.html#delete-userssid).

### Deleting a User Group From RBAC

In this release, there is a new endpoint in the Role-Based Access Control API that allows you to delete a local or remote user group from PE. For more information, see the [API documentation](./rbac_usergroups.html#delete-groupssid).

### Support For String Interpolation in the PE Console

Values for parameters and variables can be specified in the console using strings, booleans, numbers, hashes, and arrays. The supported syntax for specifying strings has been extended beyond literal strings, and now also includes limited support for string interpolation of fact values. You can now specify values such as `"I live at $ipaddress"`, which interpolates the result of referencing the `$ipaddress` fact, as well as values such as `${$os["release"]["full"]}`, which interpolates the result of the embedded expression.

For more information on the syntax and restrictions for string interpolation in the console, see [Tips on specifying parameter and variable values](./console_classes_groups.markdown#setting-class-parameters).

### Verifying Certificates For External LDAP Directories

In this release, we added the ability to verify an SSL certificate for a directory server when configuring the RBAC service to connect to an external directory server. For more information, see the [RBAC documentation](./rbac_ldap.html#Verify-Directory-Server-Certificates).

### New RBAC Permission to Edit Parameters and Variables

This permission allows a user in the given user role to tune classification by editing parameters and variables in a class, without giving the user permission to add or delete classes.

## Deprecations in PE 3.8.0

### Cloud Provisioner is Deprecated

Cloud Provisioner is deprecated in this release and will eventually be removed from Puppet Enterprise. For this reason, Cloud Provisioner is not installed by default as in previous versions of PE. If you have been using Cloud Provisioner in your existing PE infrastructure and would like to continue using it, you can install it separately, as described in the [Installing section of Cloud Provisioner documentation](./cloudprovisioner_configuring.html#installing).

Instead of Cloud Provisioner, we recommend using the AWS Supported Module going forward.

### Live Management is Deprecated

Live Management is deprecated in PE 3.8.0 and will be replaced by improved resource management functionality in future releases. For this reason, Live Management is not enabled by default as in previous versions of PE. If you have been using Live Management in your existing PE infrastructure and would like to continue using it with PE 3.8, see the instructions for [enabling Live Management](./console_navigating_live_mgmt.html#disabling/enabling-live-management) in the PE documentation.

### Some Puppet Master Platforms are Deprecated

A number of master platforms have been deprecated in PE 3.8 and will be removed in future versions of PE. Agents on these platforms will continue. The deprecated platforms include all 32-bit versions, all Debian versions, EL 5 versions, and Ubuntu 10.4. The complete list is as follows:

*	centos-5-i386
*   centos-5-x86_64
* 	centos-6-i386
* 	debian-6-i386
* 	debian-6-x86_64
* 	debian-7-i386
* 	debian-7-x86_64
* 	oracle-5-i386
* 	oracle-5-x86_64
*  	oracle-6-i386
*  	redhat-5-i386
*  	redhat-5-x86_64
*  	redhat-6-i386
*  	scientific-5-i386
*  	scientific-6-i386
*  	sles-11-i386
*  	ubuntu-1004-i386
*  	ubuntu-1004-x86_64
*  	ubuntu-1204-i386
*  	ubuntu-1404-i386


See the [system requirements](./install_system_requirements.html) for a list of supported platforms.
