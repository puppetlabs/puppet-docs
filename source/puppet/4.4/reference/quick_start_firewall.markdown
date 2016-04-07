---
layout: default
title: "Quick Start » Firewall"
subtitle: "Firewall Quick Start Guide"
canonical: "/puppet/latest/quick_start_firewall.html"
---

[downloads]: https://puppetlabs.com/puppet/puppet-open-source
[sys_req]: ./install_system_requirements.html
[agent_install]: ./install_agents.html
[install_overview]: ./install_basic.html

Welcome to the Open Source Puppet Firewall Quick Start Guide. This document provides instructions for getting started managing firewall rules with Puppet.

With a firewall, admins define a set of policies (also known as firewall rules) that consist of things like application ports (TCP/UDP), network ports, IP addresses, and an accept/deny statement. These rules are applied in a "top-to-bottom" approach. For example, when a service, say SSH, attempts to access resources on the other side of a firewall, the firewall applies a list of rules to determine if or how SSH communications are handled. If a rule allowing SSH access can’t be found, the firewall will deny access to that SSH attempt.

To best manage such rules with Puppet, you want to divide these rules into `pre` and `post` groups to ensure Puppet checks firewall rules in the correct order.

Using this guide, you will learn how to do the following tasks:

* [Install the puppetlabs-firewall module][inpage_install].
* [Write a simple module to define the firewall rules for your Puppet-managed infrastructure][inpage_write].
* [Add the firewall module to the main manifest][inpage_add].
* [Enforce the desired state of the `my_firewall` class][inpage_enforce].

> Before starting this walk-through, complete the previous exercises in the [essential configuration tasks](./quick_start_essential_config.html). Log in as root or administrator on your nodes.

> **Prerequisites**: This guide assumes you've already [installed Puppet]({{puppetserver}}/install_from_packages.html), and have installed at least one [*nix agent](./install_linux.html).

> You should still be logged in as root or administrator on your nodes.


## Install the `puppetlabs-firewall` Module

[inpage_install]: #install-the-puppetlabs-firewall-module

The firewall module, available on the Puppet Forge, introduces the firewall resource, which is used to manage and configure firewall rules from with Puppet. Learn more about the module by visiting [http://forge.puppetlabs.com/puppetlabs/firewall](http://forge.puppetlabs.com/puppetlabs/firewall).

**To install the firewall module**:

From the Puppet master, run `puppet module install puppetlabs-firewall`.

You should see output similar to the following:

        Preparing to install into /etc/puppetlabs/puppet/environments/production/modules ...
        Notice: Downloading from https://forgeapi.puppetlabs.com ...
        Notice: Installing -- do not interrupt ...
        /etc/puppetlabs/puppet/environments/production/modules
        └── puppetlabs-firewall (v1.6.0)

> That's it! You've just installed the firewall module.

## Write the `my_firewall` Module

[inpage_write]: #write-the-myfirewall-module

Some modules can be large, complex, and require a significant amount of trial and error. This module, however, will be a very simple module to write. It contains just three classes.

> ### A Quick Note about Module Directories
>
>By default, Puppet keeps modules in an environment's [`modulepath`](./dirs_modulepath.html), which for the production environment defaults to `/etc/puppetlabs/code/environments/production/modules`. This includes modules that Puppet installs, those that you download from the Forge, and those you write yourself.
>
>**Note:** Puppet also creates another module directory: `/opt/puppetlabs/puppet/modules`. Don't modify or add anything in this directory, including modules of your own.
>
>There are plenty of resources about modules and the creation of modules that you can reference. Check out [Module Fundamentals](./modules_fundamentals.html), the [Beginner's Guide to Modules](/guides/module_guides/bgtm.html), and the [Puppet Forge](https://forge.puppetlabs.com/).

Modules are directory trees. For this task, you'll create the following files:

 - `my_firewall/` (the module name)
   - `manifests/`
     - `pre.pp`
     - `post.pp`

**To write the `my_firewall` module**:

1. From the command line on the Puppet master, navigate to the modules directory:  `cd /etc/puppetlabs/code/environments/production/modules`.

2. Run `mkdir -p my_fw/manifests` to create the new module directory and its manifests directory.

3. From the `manifests` directory, use your text editor to create `pre.pp`.

4. Edit `pre.pp` so it contains the following Puppet code. These rules allow basic networking to ensure that existing connections are not closed.

       	class my_fw::pre {
    	  Firewall {
      	    require => undef,
    	  }

    	 # Default firewall rules
		    firewall { '000 accept all icmp':
		      proto  => 'icmp',
		      action => 'accept',
		    }
		    firewall { '001 accept all to lo interface':
		      proto   => 'all',
		      iniface => 'lo',
		      action  => 'accept',
		    }
		    firewall { '002 reject local traffic not on loopback interface':
		      iniface     => '! lo',
		      proto       => 'all',
		      destination => '127.0.0.1/8',
		      action      => 'reject',
		    }
		    firewall { '003 accept related established rules':
		      proto  => 'all',
		      state  => ['RELATED', 'ESTABLISHED'],
		      action => 'accept',
		    }
		  }

5. Save and exit the file.
6. From the `manifests` directory, use your text editor to create `post.pp`.
7. Edit `post.pp` so it contains the following Puppet code. This drops any requests that don't meet the rules defined in `pre.pp` or your rules defined in `site.pp` (see [next section](#add-the-firewall-module-to-the-main-manifest)).

        class my_fw::post {
		    firewall { '999 drop all':
		      proto  => 'all',
		      action => 'drop',
		      before => undef,
		    }
		  }

8. Save and exit the file.

> That's it! You've written a module that contains a class that, once applied, ensures your firewall has rules in it that will be managed by Puppet.
> Note the following about your new class:
>
> * `pre.pp` defines the “pre” group rules the firewall applies when a service requests access. It is run before any other rules.
> * `post.pp` defines the rule for the firewall to drop any requests that haven’t met the rules defined by `pre.pp` or in `site.pp` (see [next section](#add-the-firewall-module-to-the-main-manifest)).

## Add the Firewall Module to the Main Manifest

[inpage_add]: #add-the-firewall-module-to-the-main-manifest

1. On your Puppet master, navigate to the main manifest: `cd /etc/puppetlabs/code/environments/production/manifests`.
2. Use your text editor to open `site.pp`.
3. Add the following Puppet code to your `site.pp` file. This will clear any existing rules and make sure that only rules defined in Puppet exist on the machine.

		  resources { 'firewall':
		    purge => true,
		  }

4. Add the following Puppet code to your `site.pp` file. These defaults will ensure that the `pre` and `post` classes are [run in the correct order](./lang_relationships.html) to avoid locking you out of your box during the first Puppet run, and declaring `my_fw::pre` and `my_fw::post` satisfies the specified dependencies.

		  Firewall {
		    before  => Class['my_fw::post'],
		    require => Class['my_fw::pre'],
		  }

		  class { ['my_fw::pre', 'my_fw::post']: }


5. Add the `firewall` class to your `site.pp` to ensure the correct packages are installed:

		  class { 'firewall': }

> That's it! To check your firewall configuration, run `iptables --list` from the command line of your Puppet agent. The result should look similar to this:

		Chain INPUT (policy ACCEPT)
		target     prot opt source               destination
		ACCEPT     icmp --  anywhere             anywhere            /* 000 accept all icmp */
		ACCEPT     all  --  anywhere             anywhere            /* 001 accept all to lo interface */
		REJECT     all  --  anywhere             loopback/8          /* 002 reject local traffic not on loopback interface */ reject-with icmp-port-unreachable
		ACCEPT     all  --  anywhere             anywhere            /* 003 accept related established rules */ state RELATED,ESTABLISHED
		DROP       all  --  anywhere             anywhere            /* 999 drop all */

		Chain FORWARD (policy ACCEPT)
		target     prot opt source               destination

		Chain OUTPUT (policy ACCEPT)
		target     prot opt source               destination

## Enforce the Desired State of the `my_firewall` Class

[inpage_enforce]: #enforce-the-desired-state-of-the-myfirewall-class

Lastly, let's take a look at how Puppet ensures the desired state of the `my_firewall` class on your agents. In the previous task, you applied your firewall class. Now imagine a scenario where a member of your team changes the contents of the `iptables` to allow connections on a random port that was not specified in `my_firewall`.

1. Select an agent on which you applied the `my_firewall` class, and run `iptables --list`.

2. Note that the rules from the `my_firewall` class have been applied.

3. From the command line, insert a new rule to allow connections to port **8449** by running  `iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 8449 -j ACCEPT`.

4. Run `iptables --list` again and note that this new rule is now listed.

5. Run `puppet agent -t --onetime` to trigger a Puppet run on that agent.

6. Run `iptables --list` on that node once more, and notice that Puppet has enforced the desired state you specified for the firewall rules.

> That's it--Puppet has enforced the desired state of your agent!

## Other Resources

You can learn more about the Puppet Firewall module by visiting [the Puppet Forge](http://forge.puppetlabs.com/puppetlabs/firewall).

Check out the other quick start guides in our Puppet QSG series:

- [NTP Quick Start Guide](./quick_start_ntp.html)
- [DNS Quick Start Guide](./quick_start_dns.html)
- [Sudo Users Quick Start Guide](./quick_start_sudo.html)

Puppet offers many opportunities for learning and training, from formal certification courses to guided online lessons. We've noted one below; head over to the [learning Puppet page](https://puppetlabs.com/learn) to discover more.

* The Puppet workshop contains a series of self-paced, online lessons that cover a variety of topics on Puppet basics. You can sign up at the [learning page](https://puppetlabs.com/learn).