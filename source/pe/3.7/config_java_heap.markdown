---
layout: default
title: "PE 3.7 » Configuration »  Java Heap Size"
subtitle: "Changing the Java Heap Size"
canonical: "/pe/latest/config_java_heap.html"
---

Increasing the Java Heap Size for PE Java Services
-----

This page provides instructions for increasing the Java heap size for PE Java services through the Puppet Enterprise (PE) console.

## PE Console Service

To increase the Java heap size for `pe-console-services`:

1. From the console, navigate to the **Classification** page and select the **PE Console** node group.
2. Click **Classes** and scroll down to the`puppet_enterprise::profile::console` class. 
3. Click the **Parameter name** drop-down list and select `java_args`. Replace the parameter value with the JSON string `{"Xmx": "512m", "Xms": "512m"}`.
3. Click **Add Parameter**, and then click the commit button.
4. In the command line on the console node, run `puppet agent -t` to start a Puppet run. The console will be unavailable briefly while `pe-console-services` restarts.

## PE Puppet Server Service

* * *

- [Next: Accessing the Console ](./console_accessing.html)