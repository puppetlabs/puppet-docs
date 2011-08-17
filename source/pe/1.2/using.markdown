Using Puppet Enterprise
=======================

If you're an experienced Puppet user, we'll be brief: dive in! Dashboard works as expected, and the directory frequently known as `/etc/puppet` can be found at `/etc/puppetlabs/puppet`. 

If you're new to Puppet, here are a few quick walkthroughs to introduce you to its capabilities:

## Installing a Public Module

The Puppet platform enables sharing and reuse of modules, which can help you deploy common functionality and design patterns with a fraction of the usual time and effort. Modules can come from anywhere, but the canonical gathering place for module authors is the [Puppet Forge][forge]. In this walkthrough, you will install a simple module from the Forge. 

The first step is to find a module that suits your needs; in this case, we'll be using [puppetlabs/motd][motd], a demonstration module that sets a node's message-of-the-day file. 

Modules can be downloaded from the Forge by name and automatically untarred using the [puppet-module tool][moduletool], which ships with Puppet Enterprise:

    # puppet-module install puppetlabs-motd

(Alternately, you can download the same tarball from [the module's Forge page][motd] and manually untar it; either method will prepare the module in a new directory under your current working directory.)

Next, you must:

* Move the new module into puppet master's `modulepath` (Puppet Enterprise's default `modulepath` is located at `/etc/puppetlabs/puppet/modules`; if you ever need to discover your master's modulepath, you can do so with `puppet master --configprint modulepath`)
* Rename the module to remove the `username-` prefix

In our case, that amounts to:

    # mv puppetlabs-motd /etc/puppetlabs/puppet/modules/motd

And you're done! Your new module is installed and ready to use. Any of the module's classes and defined types can now be declared in manifests, any custom functions it offers are now available on the puppet master, and any custom facts it provides will be synced to agent nodes via pluginsync. 

[forge]: http://forge.puppetlabs.com/
[motd]: http://forge.puppetlabs.com/users/puppetlabs/modules/motd/
[moduletool]: https://github.com/puppetlabs/puppet-module-tool

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

