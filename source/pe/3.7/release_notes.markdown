---
layout: default
title: "PE 3.8 » Release Notes"
subtitle: "Puppet Enterprise 3.8 Release Notes"
canonical: "/pe/latest/release_notes.html"
---

This page contains information about new features and general improvements and changes in the latest Puppet Enterprise (PE) release.

For more information about this release, also see the [Known Issues](./release_notes_known_issues.html) and [Security and Bug Fixes](./release_notes_security.html).

## New Features in PE 3.8.0

### Support For String Interpolation in the PE Console

Values for parameters and variables can be specified in the console using strings, booleans, numbers, hashes, and arrays. The supported syntax for specifying strings has been extended beyond literal strings, and now also includes limited support for string interpolation of fact values. You can now specify values such as `"I live at $ipaddress"`, which interpolates the result of referencing the `$ipaddress` fact, as well as values such as `${$os["release"]["full"]}`, which interpolates the result of the embedded expression.

For more information on the syntax and restrictions for string interpolation in the console, see [Tips on specifying parameter and variable values](./console_classes_groups.markdown#setting-class-parameters).

### Verifying Certificates For External LDAP Directories

In this release, we added the ability to verify an SSL certificate for a directory server when configuring the RBAC service to connect to an external directory server. For more information, see the [RBAC documentation](./rbac_ldap.html#Verify-Directory-Server-Certificates).

## Significant Changes in PE 3.8.0

### Cloud Provisioner is Deprecated

Cloud Provisioner is deprecated in this release and will eventually be removed from Puppet Enterprise. For this reason, Cloud Provisioner is not installed by default as in previous versions of PE. If you have been using Cloud Provisioner in your existing PE infrastructure and would like to continue using it, you can install it separately, as described in the [Installing section of Cloud Provisioner documentation](./cloudprovisioner_configuring.html#installing).

Instead of Cloud Provisioner, we recommend using the AWS Supported Module going forward.

### Live Management is Deprecated

Live Management is deprecated in PE 3.8.0 and will be replaced by improved resource management functionality in future releases. For this reason, Live Management is not enabled by default as in previous versions of PE. If you have been using Live Management in your existing PE infrastructure and would like to continue using it with PE 3.8, see the instructions for [enabling Live Management](./console_navigating_live_mgmt.html#disabling/enabling-live-management) in the PE documentation.

### Some Puppet Master Platforms are Deprecated

The following Puppet master platforms are deprecated in PE 3.8, and will be removed in future versions of PE:
* All 32-bit versions
* All Debian versions
* EL 5 (RHEL, CentOS, Scientific, Oracle)
* Ubuntu 10.4

See the [system requirements](./install_system_requirements.html) for more information and recommendations.