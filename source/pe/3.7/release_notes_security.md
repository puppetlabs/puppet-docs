---
title: "PE 3.8 » Release Notes >> Security and Bug Fixes"
layout: default
subtitle: "Security Fixes"
canonical: "/pe/latest/release_notes_security.html"
---

This page contains information about security fixes in Puppet Enterprise (PE) 3.8. It also contains a select list of those bug fixes that we believe you'll want to learn about.

For more information about this release, also see the [Known Issues](./release_notes_known_issues.html) and [New Features](./release_notes.html).

## Puppet Enterprise 3.8 (??/04/15)

### Security Fixes

### Bug Fixes

Puppet Enterprise 3.8 contains a number of performance and documentation improvements, in addition to the fixes that are highlighted below.

#### Static Defaults were Set for TK-Jetty `max threads`

Previously, in PE, tk-jetty `max threads` were set to a static default of 100 threads. We determined this was too low for large environments with high CPU counts. We no longer set a default for `max threads`, and this setting will be undefined and unmanaged unless the user specifies a value. You can tune `max threads` for the [PE console/console API](./console_config.html#tuning-max-threads-on-the-pe-console-and-console-api) or [Puppet Server](./config_puppetserver.html#tuning-max-threads-on-puppet-server) as needed using Hiera. 

#### Fix for Tuning Classifier Synchronization Period

This fix raises the node classifier's default synchronization period from 180 to 600 seconds. It also introduces a [tunable setting](./console_config.html#tuning-the-classifier-synchronization-period) via the PE console. 

#### Setting `https_proxy` Prevented Service Checks during Installation/Upgrade with `curl`

When users ran the PE installer/upgrader behind a proxy, PE could not properly `curl` PE services during installation/upgrade. This fix corrects the issue by unsetting `HTTPS_PROXY`, `https_proxy`, `HTTP_PROXY`, and `http_proxy` before performing `curl` commands to PE services during installs/upgrades. 
 

#### Node Classifier Ignores Facts That Are False

When creating node matching rules in PE 3.7, the node classifier ignored all facts with a boolean value of `false`. For example, if you created a rule like `is_virtual` `is` `false`, the rule would never match a node. This issue has been resolved in PE 3.8.

#### Browser Crashing Issue When Returning a Null Value for `inherited_role_ids`

In PE 3.7.2, the browser would crash when the `users` endpoint for Role-Based Access Control (RBAC) returned a `NULL` value for `inherited_role_ids`. A `NULL` value is returned when you delete the user roles for a user group and then view the user. In PE 3.8, this has been fixed and the browser no longer crashes.

#### Browser Crashing Issue When Deleting a Node Group That Has a Permission Assigned

In PE 3.7, if you take the following steps:

- create a new user role in RBAC
- add a permission to the user role that has the **Node groups** permission type
- select a specific node group instance that the permission applies to
- delete the node group instance that the permission applies to
- try to go to the **Permissions** tab for the new user role 

the result is that the javascript rendering the page stops prematurely and the page is not rendered completely. 

In PE 3.8, this has been fixed so that the page renders properly. In the PE 3.8 console, if you go to the **Permissions** tab for the new role that was added, the deleted node group instance is displayed as a dash in the **Object** column.

#### Node Classifier Returns Activity Service Error When Importing a Large Number of groups

In PE 3.7, an error would be returned when importing a large number of groups (for example, when upgrading a large environment to PE 3.7). This error was returned even if the import was successful. In PE 3.8, this error no longer occurs. 

#### Newly Created Node Group Does Not Appear in List of Parents

When you created a new node group in the PE 3.7 console, then immediately created another new node group and tried to select the first node group as the parent, the first node group did not appear in the list of selectable names in the **Parent name** drop-down list. The first node group would appear if you reloaded the page. This issues has been fixed in PE 3.8.

###  New PE 3.7.x MCO Servers Were Not Connecting With Older MCollective Agents (posted 12/17/14)

Some customers experienced problems connecting PE 3.7 MCO clients, such as Live Management, with older MCO servers (Puppet agents). Specifically, any MCO servers running on PE 3.3.2 agents and older. To fix this problem, we recommend upgrading your PE agents to 3.7.x so you can continue using activemq heartbeats.


