---
layout: default
title: "PE 3.7 » Quick Start » Classifying Agents (Windows)"
subtitle: "Adding Classes Quick Start Guide"
canonical: "/pe/latest/quick_start_adding_class_windows.html"
---

### Overview

[classification_selector]: ./images/quick/classification_selector.png
[windows_add_group]: ./images/quick/windows_add_group.png

Every module contains one or more **classes**. [Classes](/puppet/3.7/reference/lang_classes.html) are named chunks of Puppet code and are the primary means by which Puppet Enterprise configures nodes. The Puppet Labs Registry module you installed in the [Module Installation QSG](./quick_start_module_install_windows.html) contains a class called `registry`. In this example, you’ll use the `registry` class to supply the types and providers necessary to create and manage Windows Registry keys and values with Puppet.

In this example, we will create a group called __windows_example_ and add the `registry` class to it.

>**Prerequisites**: This guide assumes you've already [installed a monolithic PE deployment](./quick_start_install_mono.html), and have installed at least one [Windows agent node](./quick_start_install_agents_windows.html) and the [puppetlabs-registry module](./quick_start_module_install_windows.html).

>**Note**: The process for adding classes to agent nodes in the console is the same on both Windows and *nix operating systems.

### Create the windows_example Group

**To create the windows_example group**:

1. From the console, click __Classification__ in the navigation bar.
2. In the __Node group name__ field, name your group (e.g., **windows_example**).
3. Click __Add group__.
4. Select the __windows_example__ group.
5. From the __Rules__ tab, in the __Node name__ field, enter the name of the PE-managed node you'd like to add to this group.
6. Click __Pin node__.
7. Click __Commit 1 change__.

   ![adding node to windows group][windows_add_group]

8. Repeat steps 5-7 for any additional nodes you want to add.



### Add the `registry` Class to the Example Group

**To add the** `registry` **class to the example group**:

1. From the console, click __Classification__ in the top navigation bar.

   ![classification selection][classification_selector]

2. From the __Classification page__, select the __windows_example__ group.

3. Click the __Classes__ tab.

4. In the __Class name__ field, begin typing `registry`, and select it from the autocomplete list.

5. Click __Add class__.

6. Click __Commit 1 change__.

   Note that the `registry` class now appears in the list of classes for your agent node.

9. From the console, navigate to the live management page, and select the __Control Puppet__ tab.

10. Click the __runonce__ action and then __Run__. This will configure the __windows_ example__ group using the newly-assigned class. Wait one or two minutes.

-------

Next: [Quick Start: Classifying Nodes and Assigning User Permissions](./quick_start_nc_rbac.html)

