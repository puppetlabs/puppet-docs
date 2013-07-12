---
layout: default
title: "PE 2.7  » Console » Live Mgmt: Advanced Tasks"
subtitle: "Live Management: Advanced Tasks"
canonical: "/pe/latest/console_navigating_live_mgmt.html"
---

> ![windows-only](./images/windows-logo-small.jpg) **NOTE:** Live management and MCollective are not yet supported on Windows nodes.

Use the "Advanced Tasks" tab to invoke actions from any MCollective agent installed on your nodes. 

![The advanced tasks page][live_advanced_main]

Agents and Actions
-----

This tab is a direct interface to your nodes' MCollective agents. It automatically generates a GUI for every agent installed on your systems, exposing all of their actions through the console. If you install any custom MCollective agents, they'll appear in the "Advanced Tasks" tab.

Puppet Enterprise ships with the following MCollective agents:

* **package** --- installs and uninstalls software packages.
* **rpcutil** --- performs miscellaneous meta-tasks.
* **service** --- starts and stops services.
* **puppetral** --- the agent used to implement the manage resources tab. When used from the advanced tasks tab, it can only inspect resources, not clone them.

Each agent view includes explanatory text for each action.

Invoking Actions
-----

Navigate to an agent to see a list of actions. To invoke an action, click its name, enter any required arguments, and confirm with the red "Run" button.

Invoking an action with no arguments:

![Invoking the rpcutil agent's inventory action][live_advanced_noargs]

Invoking an action with an argument:

![Invoking the service agent's status action with httpd as an argument][live_advanced_args]

An action in progress:

![The running action spinner][live_advanced_running]

Results:

![Four nodes with a stopped httpd service][live_advanced_results]

[live_advanced_args]: ./images/console/live_advanced_args.png
[live_advanced_main]: ./images/console/live_advanced_main.png
[live_advanced_noargs]: ./images/console/live_advanced_noargs.png
[live_advanced_results]: ./images/console/live_advanced_results.png
[live_advanced_running]: ./images/console/live_advanced_running.png


* * * 

- [Next: Console Maintenance](./console_maintenance.html)
