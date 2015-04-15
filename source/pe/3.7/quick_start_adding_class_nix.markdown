---
layout: default
title: "PE 3.7 » Quick Start » Classifying Agents (*nix)"
subtitle: "Adding Classes Quick Start Guide"
canonical: "/pe/latest/quick_start_adding_class_nix.html"
---


## Overview

[classification_selector]: ./images/quick/classification_selector.png
[apache_add_group]: ./images/quick/apache_add_group.png

Every module contains one or more **classes**. [Classes](/puppet/3.7/reference/lang_classes.html) are named chunks of Puppet code and are the primary means by which Puppet Enterprise configures nodes. The puppetlabs-apache module you installed in the [Module Installation QSG](./quick_start_module_install_nix.html) contains a class called `apache`. In this example, you'll use the `apache` class to launch the default Apache virtual host. You'll create a group called __apache_example__ and add the `apache` class to it.

> **Prerequisites**: This guide assumes you've already [installed a monolithic PE deployment](./quick_start_install_mono.html), and have installed at least one [*nix agent node](./quick_start_install_agents_nix.html) and the [puppetlabs-apache module](./quick_start_module_install_nix.html).


## Create the apache_example Group

1. From the console, click __Classification__ in the navigation bar.
2. In the __Node group name__ field, name your group (e.g., **apache_example**).
3. Click __Add group__.
4. Click the __apache_example__ group.
5. From the __Rules__ tab, in the __Certname__ area, in the __Node name__ field, enter the name of the PE-managed node you'd like to add to this group.
6. Click __Pin node__.
7. Click __Commit 1 change__.

   ![adding node to apache group][apache_add_group]

8. Repeat steps 5-7 for any additional nodes you want to add.


## Add the `apache` Class to the Example Group

Unless you have navigated elsewhere in the console, the __apache example__ node group should still be displayed in the __Classification__ area.

**To add the `apache` class to the example group:**

1. Click the __Classes__ tab.

2. In the __Class name__ field, begin typing `apache`, and select it from the autocomplete list.

3. Click __Add class__ and then click __Commit 1 change__.

   The `apache` class now appears in the list of classes for your agent node. You can see this list by clicking __Nodes__ and then clicking your node in the __Nodes__ list. A page opens with your node's details.

4. From your agent node, navigate to `/var/www/html/`, and create a file named `index.html`.

5. Open `index.html` with the text editor of your choice and fill it with some content (e.g., "Hello World").

6. From the console, navigate to the __Live Management__ page, and select the __Control Puppet__ tab.

7. Click __runonce__ and then __Run__. This will configure the node using the newly-assigned class. Wait one or two minutes.

8. Open a browser and enter the IP address for the agent node, adding port 80 on the end (e.g., `www.myagentnodeIP:80`).

   You will see the contents of `/var/www/html/index.html` displayed.

> Puppet Enterprise is now managing the default Apache vhost on your agent node. At this point, you can check out the Apache "ReadMe" on the Forge to explore options for managing your Apache instances as needed. The [*Nix module writing QSG](./quick_writing_nix.html) discusses how to write your own class that manages a web app running on an Apache virtual host.

## Editing Class Parameters in the Console

You can use the console to set or edit the values of a class's parameters without needing to edit the module's code directly.

**To edit the parameters of the** `apache` **class**:

1. From the console, click __Classification__ in the navigation bar.
2. From the __Classification page__, click the __apache_example__ group.
3. Click the __Classes__ tab, and find `apache` in the list of classes.

4. From the __Parameter Name__ drop-down list, choose the parameter you’d like to edit. (For this example, we will use `docroot`.)

   **Note**: The grey text that appears as values for some parameters is the default value, which can be either a literal value or a Puppet variable. You can restore this value by selecting __Discard changes__ after you have added the parameter.

5. In the __Value__ field, enter `"/var/www"`.
6. Click __Add parameter__.
7. Click __Commit 1 change__.
8. Navigate to the Live Management page, and select the __Control Puppet__ tab.
9. Click __runonce__  and then __Run__ to trigger a Puppet run to have Puppet Enterprise create the new configuration.

----------

Next: [Quick Start: Classifying Nodes and Assigning User Permissions](./quick_start_nc_rbac.html)
