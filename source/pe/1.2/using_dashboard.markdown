## Classifying Nodes With Puppet Dashboard

Since the module we just installed provides a class, we can now declare that class in any node. If we were defining nodes individually in puppet master's main manifest (default: `/etc/puppetlabs/puppet/manifests/site.pp`), we could use a simple class declaration or `include` statement:

    node 'agent1.mysite.org', 'agent2.mysite.org', 'agent3.mysite.org' {
        class {"motd": }
        # or:
        # include motd
    }

However, we can also use Puppet Dashboard to declare module classes for a group of nodes. If you selected and configured Puppet Dashboard during installation, open a web browser and navigate to http://{your dashboard server}:3000. In the sidebar, you'll see an empty list of classes, along with an "Add class" button:

![Add class button][1]

Use this button to tell Dashboard about the class; simply refer to the class by name as you would in a Puppet manifest.

![Class name][2]

Next, let's add a group of classes. We could apply the new class directly to nodes, but since groups offer a convenient way to apply a set of clases at once, let's go ahead and start building a set of classes for machines which offer shell access to users. 

![Add group button][3]

Note that, when we're choosing which classes to add to a group, Dashboard will offer suggestions based on the classes you have entered:

![Adding a group][4]

![A class successfully added to the group][5]

Then we click "Create," and can view our completed group:

![Group status page][6]

It's not doing anything right now, so let's assign a node to the group. Go to the list of currently successful nodes, and choose a node to edit:

![Currently successful nodes][7]

![The edit button on a node's status page][8]

As with classes, Dashboard will offer group name suggestions while you type:

![Typing a group name][9]

![A group successfully added to the node][10]

Then we click "Save changes," and our node will be a member of the "shell" group, inheriting all of the group's classes.

![A node status page with a group and inherited class][11]

The next time this node's puppet agent contacts the master, its `/etc/motd` file will be populated from the motd module's template. Whenever we install new modules and specify that classes they provide should be included in the "shell" group, all nodes in the group will make the necessary changes. 

[1]: ./images/dashboard/01.addclass.png
[2]: ./images/dashboard/02.classname.png
[3]: ./images/dashboard/03.addgroup.png
[4]: ./images/dashboard/04.addinggroup.png
[5]: ./images/dashboard/05.classaddedtogroup.png
[6]: ./images/dashboard/06.groupadded.png
[7]: ./images/dashboard/07.choosenode.png
[8]: ./images/dashboard/08.edit.png
[9]: ./images/dashboard/09.typinggroup.png
[10]: ./images/dashboard/10.groupaddedtonode.png
[11]: ./images/dashboard/11.nodewithgroup.png


