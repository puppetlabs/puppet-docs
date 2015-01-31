---
layout: default
title: "PE 3.7 » Configuration »  Java Heap Size"
subtitle: "Changing the Java Heap Size"
canonical: "/pe/latest/config_java_heap.html"
---

Increasing the Java Heap Size For PE Java Services
-----

This page provides instructions for increasing the Java heap size for Puppet Enterprise (PE) Java services through the PE console.

## PE Console Service

To increase the Java heap size for `pe-console-services`:

1. From the console, navigate to the **Classification** page and select the **PE Console** node group.
2. Click **Classes** and scroll down to the `puppet_enterprise::profile::console` class. 
3. Click the **Parameter name** drop-down list and select `java_args`. Replace the parameter value with the JSON string `{"Xmx": "512m", "Xms": "512m"}`. This increases the heap size from the default of 256 MB to 512 MB.
4. Click **Add Parameter**, and then click the commit button.
5. In the command line on the console node, run `puppet agent -t` to start a Puppet run and apply the change. The console will be unavailable briefly while `pe-console-services` restarts.

## PE Puppet Server Service

To increase the Java heap size for `pe-puppetserver`:

1. Ensure you have enough free memory to increase the memory utilization of `pe-puppetserver`.
2. From the console, navigate to the **Classification** page and select the **PE Master** node group.
3. Click **Classes** and scroll down to the `puppet_enterprise::profile::master` class. 
4. Click the **Parameter name** drop-down list and select `java_args`. Replace the parameter value with the JSON string `{"Xmx": "4096m", "Xms": "4096m"}`. This increases the heap size from the default of 2 GB to 4 GB. 
5. In the command line on each compile master, run `puppet agent -t` to start a Puppet run and apply the change.

* * *

- [Next: Accessing the Console ](./console_accessing.html)