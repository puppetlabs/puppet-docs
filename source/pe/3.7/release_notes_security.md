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

Previously, in PE, tk-jetty `max threads` were set to a static default of 100 threads. We determined this was too low for large environments with high CPU counts, and no longer set a default for `max threads`. Unless you specify a value, we will not manage or define this setting. You can tune `max threads` for the [PE console/console API](./console_config.html#tuning-max-threads-on-the-pe-console-and-console-api) or [Puppet Server](./config_puppetserver.html#tuning-max-threads-on-puppet-server) as needed using Hiera.

#### Custom Console Cert Functionality was Broken in PE 3.7.x

In PE 3.7.x users could not set custom certificates for the PE console. This release corrects that issue, but if you're upgrading from PE 3.3.2, note that cert functionality has changed in PE 3.8. If needed, refer to [Configuring the Puppet Enterprise Console to Use a Custom SSL Certificate](./custom_console_cert.html) for instructions on re-configuring your custom console certificate.

#### Agent Installation No Longer Sets `environment = production` 

This release corrects an issue in which agents' environments were set to `production` during the installation process (in `puppet.conf`). This behavior was undesirable if users wanted to set agents' environments with the node classifier. 

#### Agent Server Setting Moved to `[main]` in `puppet.conf`

The agent server setting is now set in the `[main]` section of `puppet.conf`; in previous versions, it was set in the `[agent]` section. This fix makes it possible to use the agent installation script to install compile masters and ActiveMQ hubs and spokes in large environment installations. 

#### ActiveMQ Spokes Can Be Managed from Profile Level

ActiveMQ spokes (brokers) can now have their collectives set and managed in PE from the profile level, using the `excluded_collectives` and `included_collectives` parameters in the `puppet_enterprise::profile::amq::broker` class. This functionality was not available from the profile level in PE 3.7.x. 

#### ActiveMQ/MCollective Network Connections Failed when Sending Commands to Targeted Spokes

Due to a misconfigured setting in PE (`puppet_enterprise::amq::config::network_connector`), ActiveMQ/MCollective network connections failed on occasion. Specifically, the connections failed when a ActiveMQ hub was sending commands to targeted spokes (brokers) in large environment installations. This is fixed in PE 3.8. 

#### Changes to ActiveMQ Heap Size did not Restart `pe-activemq` Service

In PE 3.7.x, when users changed the ActiveMQ heap size, the change did not trigger the `pe-activemq` service to restart, and thus PE did not pick up the changes. PE 3.8 corrects this issue, and the service is now restarted when changes are made. 

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

#### Node Classifier Returns Activity Service Error When Importing a Large Number of Groups

In PE 3.7, an error indicating that the "index row size exceeds maximum" was returned when importing a large number of groups (for example, when upgrading a large environment to PE 3.7). This error was returned even if the import was successful. In PE 3.8, this error no longer occurs. 

#### Newly Created Node Group Does Not Appear in List of Parents

When you created a new node group in the PE 3.7 console, then immediately created another new node group and tried to select the first node group as the parent, the first node group did not appear in the list of selectable names in the **Parent name** drop-down list. The first node group would appear if you reloaded the page. This issues has been fixed in PE 3.8.

#### Can Only Accept Or Reject One Node at a Time

In PE 3.7, if you had multiple node requests pending, you could accept/reject one node, but if you then tried to accept/reject subsequent nodes a 403 Forbidden error was returned. This meant that if you wanted to accept/reject node requests one at a time, you had to refresh the page after each time you accepted/rejected a node request. In PE 3.8, this issue has been fixed and you will no longer receive a 403 Forbidden error.


