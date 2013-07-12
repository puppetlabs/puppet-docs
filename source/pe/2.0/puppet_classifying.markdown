---
layout: default
title: "PE 2.0 » Puppet » Assigning a Class to a Node"
canonical: "/pe/latest/puppet_assign_configurations.html"
---

* * *

&larr; [Puppet: Your First Module](./puppet_first_module.html) --- [Index](./) --- [Puppet: Next Steps](./puppet_next_steps.html) &rarr;

* * *

Puppet For New Users: Assigning a Class to a Node
=====

In Puppet Enterprise, you assign classes to nodes using the console. 

Adding a Class to the Console
-----

The console doesn't automatically load classes from the puppet master's modules, so you must tell the console about a new class before you can use it. Use the "Add class" button in the console's sidebar.

The "Add class" button: 

![The console's Add class button][classbutton]

Typing a class name:

![The console's Add node class page][classname]

Done: 

![The list of classes with the new class highlighted][classexists]

[classbutton]: ./images/puppet_classifying/add_class_button.png
[classexists]: ./images/puppet_classifying/class_exists.png
[classname]: ./images/puppet_classifying/class_name.png

Assigning a Class to a Single Node
-----

To assign the new class to one node at a time: 

* Go to that node's page (by finding and clicking its name in one of the console's lists of nodes)
* Click "Edit"
* Start typing the name of the class in its "Classes" field, then select the class you want from the auto-completion list
* Save your changes

The edit button: 

![The edit button on a node's page][singlebefore]

Typing a class name:

![Typing a class name][singletyping]

A confirmed class name:

![Selecting an auto-completed class name][singletyped]

Done: 

![The node's page, now with the new class assigned][singleafter]

[singleafter]: ./images/puppet_classifying/single_after.png
[singlebefore]: ./images/puppet_classifying/single_before.png
[singletyped]: ./images/puppet_classifying/single_typed.png
[singletyping]: ./images/puppet_classifying/single_typing.png

Assigning a Class to a Group
-----

Assigning a class to a group of nodes is nearly identical: go to that group's page, and use the edit button and classes field as described above.

After adding a class to a group:

![A group page with our class added][groupafter]

[groupafter]: ./images/puppet_classifying/group_after.png


Making a Node Pull its Configuration
-----

Nodes with your class will pull and apply their configurations within the next half hour. But if you want to make them run immediately, you can use the console's live management page to control puppet agent. 

* Navigate to the live management page, then navigate to the "Control Puppet" section
* In the sidebar, click "select none" and then re-select the handful of nodes that need to run
* Click the "runonce" action, then confirm with the red "Run" button.

Preparing to trigger three runs:

![Live management with three nodes selected and displaying the Control Puppet section][pull_ready]

Confirming the runonce action:

![The runonce action's "Run" confirmation button revealed][pull_run]

[pull_ready]: ./images/puppet_classifying/pull_ready.png
[pull_run]: ./images/puppet_classifying/pull_run.png

Viewing the Results of a Run
-----

A few minutes after triggering a run, the selected nodes should be the most recent nodes appearing in the node list. In our case, we can see that this run **made changes to one node,** which has a blue checkmark by its name:

![The list of nodes, with the three nodes we just ran at the top and a blue checkmark by one of them.][view_onechanged]

If we go to that node's page, we can go to the most recent report and view what happened in the "log" tab:

![The list of most recent reports for the changed node; the one at the top has a blue checkmark][view_lastreport]

![The log tab for the most recent report. Puppet changed the mode of /etc/passwd were changed from 0666 to 0644.][view_log]

For some reason, `/etc/passwd` had a permissions mode of 0666, which meant anyone could write to it! Puppet corrected that, and it now has the proper mode of 0644.

[view_lastreport]: ./images/puppet_classifying/view_lastreport.png
[view_log]: ./images/puppet_classifying/view_log.png
[view_onechanged]: ./images/puppet_classifying/view_onechanged.png

* * *

&larr; [Puppet: Your First Module](./puppet_first_module.html) --- [Index](./) --- [Puppet: Next Steps](./puppet_next_steps.html) &rarr;

* * *

