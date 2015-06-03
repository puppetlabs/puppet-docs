---
layout: default
title: "PE 3.2 » Orchestration » Adding New Actions"
subtitle: "Adding New Orchestration Actions to Puppet Enterprise"
canonical: "/pe/latest/orchestration_adding_actions.html"
---



[mco_agent]: /mcollective/simplerpc/agents.html
[mco_ddl]: /mcollective/reference/plugins/ddl.html
[mco_aggregate]: /mcollective/reference/plugins/aggregate.html
[mco_deploy_plugins]: /mcollective/deploy/plugins.html
[mco_deploy_libdir]: /mcollective/deploy/plugins.html#method-2-copying-plugins-into-the-libdir
[mco_deploy_verify]: /mcollective/deploy/plugins.html#verifying-installed-agent-plugins
[plugin_types]: /mcollective/deploy/plugins.html#about-plugins--available-plugin-types
[filter]: ./orchestration_invoke_cli.html#filtering-by-fact-class-and-agent
[plugin_dot_d]: /mcollective/configure/server.html#plugin-config-directory-optional


Actions and Plugins
-----

You can extend Puppet Enterprise (PE)'s orchestration engine by adding new **actions.** Actions are distributed in **MCollective agent plugins,** which are bundles of several related actions. You can write your own agent plugins (or download ones created by other people), and use Puppet Enterprise to install and configure them on your nodes.

> ### Related Topics
>
> * For an overview of orchestration topics, see [the Orchestration Overview page][fundamentals].
> * To invoke actions in the PE console, see [Navigating Live Management](./console_navigating_live_mgmt.html).
> * To invoke actions on the command line, see [Invoking Actions](./orchestration_invoke_cli.html).
> * For a list of built-in actions, see [List of Built-In Orchestration Actions](./orchestration_actions.html).

[fundamentals]: ./orchestration_overview.html#orchestration-fundamentals

### About MCollective Agent Plugins

#### Components

MCollective agent plugins consist of two parts:

* A `.rb` file containing the MCollective agent code
* A `.ddl` file containing a description of plugin's actions, inputs, and outputs

Every **agent node** that will be using this plugin needs **both** files. The **puppet master node** and **console node** each need the `.ddl` file.

> **Note:** Additionally, some MCollective agent plugins may be part of a bundle of related plugins, which may include new subcommands, data plugins, and more.
>
> [A full list of plugin types and the nodes they should be installed on is available here.][plugin_types] Note that in MCollective terminology, "servers" refers to Puppet Enterprise agent nodes and "clients" refers to the puppet master and console nodes.

#### Distribution

Not every agent node needs to use every plugin --- the orchestration engine is built to gracefully handle an inconsistent mix of plugins across nodes.

This means you can distribute special-purpose plugins to only the nodes that need them, without worrying about securing them on irrelevant nodes. Nodes that don't have a given plugin will ignore its actions, and you can also [filter orchestration commands by the list of installed plugins][filter].



Getting New Plugins
-----

You can write your own orchestration plugins, or download ones written by other people.

### Downloading MCollective Agent Plugins

[plugin_list]: http://projects.puppetlabs.com/projects/mcollective-plugins/wiki
[nrpe]: https://github.com/puppetlabs/mcollective-nrpe-agent
[search]: https://github.com/search?q=mcollective+agent

There isn't a central repository of MCollective agent plugins, but there are several good places to start looking:

* [A list of the plugins released by Puppet Labs is available here.][plugin_list]
* If you use Nagios, [the NRPE plugin][nrpe] (from Puppet Labs) is a good first plugin to install.
* [Searching GitHub for "mcollective agent"][search] will turn up many plugins, including ones for `vmware_tools`, libvirt, junk filters in `iptables`, and more.


### Writing MCollective Agent Plugins

Most people who use orchestration heavily will want custom actions tailored to the needs of their own infrastructure. You can get these by writing new MCollective agent plugins in Ruby.

The MCollective documentation has instructions for writing agent plugins:

* [Writing agent plugins][mco_agent]
* [Writing DDL files][mco_ddl]
* [Aggregating replies for better command line interfaces][mco_aggregate]

Additionally, you can learn a lot by reading the code of Puppet Enterprise's built-in plugins. These are located in the `/opt/puppet/libexec/mcollective/mcollective/` directory on any \*nix PE node.

Installing Plugins on Puppet Enterprise Nodes
-----

Since orchestration actions need to be installed on many nodes, and since installing or upgrading an agent should always restart the `pe-mcollective` service, you should use Puppet to install MCollective agent plugins.

This page assumes that you are **familiar with the Puppet language** and have **written modules previously.**

> ### In the MCollective Documentation
>
> The MCollective documentation [includes a guide to installing plugins][mco_deploy_plugins]. Puppet Enterprise users must use the ["copy into libdir" installation method][mco_deploy_libdir]. The remainder of this page goes into more detail about using this method with Puppet Enterprise.

### Overview of Plugin Installation Process

To install a new agent plugin, you must write a Puppet module that does the following things:

* On agent nodes: copy the plugin's `.rb` and `.ddl` files into the `mcollective/agent` subdirectory of MCollective's libdir. This directory's location varies between \*nix and Windows nodes.
* On the console and puppet master nodes: if you will not be installing this plugin on _every_ agent node, copy the plugin's `.ddl` file into the `mcollective/agent` subdirectory of MCollective's libdir.
* If there are any other associated plugins included (such as data or validator plugins), copy them into the proper libdir subdirectories on agent nodes, the console node, and the puppet master node.
* If any of these files change, restart the `pe-mcollective` service, which is managed by the `pe_mcollective` module.

To accomplish these, you will need to write some limited interaction with the `pe_mcollective` module, which is part of Puppet Enterprise's implementation. We have kept these interactions as minimal as possible; if any of them change in a future version of Puppet Enterprise, we will provide a warning in the upgrade notes for that version's documentation.

### Step 1: Create a Module for Your Plugin(s)

You have several options for laying this out:

* **One class for all of your custom plugins.** This works fine if you have a limited number of plugins and will be installing them on every agent node.
* **One module with several classes for individual plugins or groups of plugins.** This is good for installing certain plugins on only some of your agent nodes --- you can split specialized plugins into a pair of `mcollective_plugins::<name>::agent` and `mcollective_plugins::<name>::client` classes, and assign the former to the affected agent nodes and the latter to the console and puppet master nodes.
* **A new module for each plugin.** This is maximally flexible, but can sometimes get cluttered.

Once the module is created, **put the plugin files into its `files/` directory.**

### Step 2: Create Relationships and Set Variables

For any class that will be installing plugins **on agent nodes,** you should put the following four lines near the top of the class definition:

~~~ ruby
    Class['pe_mcollective::server::plugins'] -> Class[$title] ~> Service['pe-mcollective']
    include pe_mcollective
    $plugin_basedir = $pe_mcollective::server::plugins::plugin_basedir
    $mco_etc        = $pe_mcollective::params::mco_etc
~~~

This will do the following:

* Ensure that the necessary plugin directories already exist before we try to put files into them. (In certain cases, these directories are managed by resources in the `pe_mcollective::server::plugins` class.)
* Restart the `pe-mcollective` service whenever new plugins are installed or upgraded. (This service resource is declared in the `pe_mcollective::server` class.)
* Set variables that will correctly refer to the plugins directory and configuration directory on both \*nix and Windows nodes.

> **Note:** The `Class[$title]` notation seen above is a resource reference to the class that contains this statement; it uses the `$title` variable, which always contains the name of the surrounding container.



### Step 3: Put Files in Place

First, set file defaults: all of these files should be owned by root and only writable by root (or the Administrators user, on Windows). The `pe_mcollective` module has helpful variables for setting these:

~~~ ruby
    File {
      owner => $pe_mcollective::params::root_owner,
      group => $pe_mcollective::params::root_group,
      mode  => $pe_mcollective::params::root_mode,
    }
~~~

Next, put all relevant plugin files into place, using the `$plugin_basedir` variable we set above:

~~~ ruby
    file {"${plugin_basedir}/agent/nrpe.ddl":
      ensure => file,
      source => 'puppet:///modules/mco_plugins/mcollective-nrpe-agent/agent/nrpe.ddl',
    }

    file {"${plugin_basedir}/agent/nrpe.rb":
      ensure => file,
      source => 'puppet:///modules/mco_plugins/mcollective-nrpe-agent/agent/nrpe.rb',
    }
~~~

### Step 4: Configure the Plugin (Optional)

Some agent plugins require extra configuration to work properly. If present, these settings must be present on every **agent node** that will be using the plugin.

The main `server.cfg` file is managed by the `pe_mcollective` module. Although editing it is possible, it is _not supported._ Instead, you should take advantage of [the MCollective daemon's plugin config directory][plugin_dot_d], which is located at `"${mco_etc}/plugin.d"`.

* File names in this directory should be of the format `<agent name>.cfg`.
* Setting names in plugin config files are slightly different:

In server.cfg                             | In ${mco\_etc}/plugin.d/nrpe.conf
------------------------------------------|-----------------------------------
`plugin.nrpe.conf_dir = /etc/nagios/nrpe` | `conf_dir = /etc/nagios/nrpe`

You can use a normal file resource to create these config files with the appropriate values. For simple configs, you can set the content directly in the manifest; for complex ones, you can use a template.

~~~ ruby
    file {"${mco_etc}/plugin.d/nrpe.cfg":
      ensure  => file,
      content => "conf_dir = /etc/nagios/nrpe\n",
    }
~~~

#### Policy Files

You can also distribute [policy files for the ActionPolicy authorization plugin][actionpolicy]. This can be a useful way to completely disable certain unused actions, limit actions so they can only be used on a subset of your agent nodes, or allow certain actions from the command line but not from the live management page.

These files should be named for the agent plugin they apply to, and should go in `${mco_etc}/policies/<plugin name>.cfg`. Policy files should be distributed to every agent node that runs the plugin you are configuring.

> **Note:** The `policies` directory doesn't exist by default; you will need to use a `file` resource with `ensure => directory` to initialize it.

[The policy file format is documented here.][actionpolicy] When configuring caller IDs in policy files, note that PE uses the following two IDs by default:

* `cert=peadmin-public` --- the command line orchestration client, as used by the `peadmin` user on the puppet master server.
* `cert=puppet-dashboard-public` --- the live management page in the PE console.

Example: This code would completely disable the package plugin's `update` option, to force users to do package upgrades through your centralized Puppet code:

~~~ ruby
    file {"${mco_etc}/policies": ensure => directory,}

    file {"${mco_etc}/policies/package.policy":
      ensure  => file,
      content => "policy default allow
    deny	*	update	*	*
    ",
    }
~~~

[actionpolicy]: https://github.com/puppetlabs/mcollective-actionpolicy-auth#readme

### Step 5: Assign the Class to Nodes

For plugins you are distributing to **all agent nodes,** you can use the PE console to assign your class to the special `mcollective` group. (This group is automatically maintained by the console, and contains all PE nodes which have not been added to the special `no mcollective` group.)

For plugins you are only distributing to **some** agent nodes, you must do the following:

* Create two Puppet classes for the plugin: a main class that installs everything, and a "client" class that only installs the `.ddl` file and the supporting plugins.
* Assign the main class to any agent nodes that should be running the plugin.
* Assign the "client" class to the `puppet_console` and `puppet_master` groups in the console. (These special groups contain all of the console and puppet master nodes in your deployment, respectively.)

### Step 6: Run Puppet

You can either wait for the next scheduled Puppet run, or [trigger an on-demand run using MCollective.](./orchestration_puppet.html)

### Step 7: Confirm the Plugin is Installed

Follow [the instructions in the MCollective documentation][mco_deploy_verify] to verify that your new plugins are properly installed.


Other Kinds of Plugins
-----

In addition to installing MCollective agent plugins, you may occasionally need to install other kinds of plugins, such as data plugins. This process is effectively identical to installing agent plugins, although the concerns about restricting distribution of certain plugins to special nodes are generally not relevant.

Example
-----

This is an example of a Puppet class that installs [the Puppet Labs nrpe plugin][nrpe]. The `files` directory of the module would simply contain a complete copy of [the nrpe plugin's Git repo][nrpe]. In this example, we are not creating separate agent and client classes.

~~~ ruby
    # /etc/puppetlabs/puppet/modules/mco_plugins/manifests/nrpe.pp
    class mco_plugins::nrpe {
      Class['pe_mcollective::server::plugins'] -> Class[$title] ~> Service['pe-mcollective']
      include pe_mcollective
      $plugin_basedir = $pe_mcollective::server::plugins::plugin_basedir
      $mco_etc        = $pe_mcollective::params::mco_etc

      File {
        owner => $pe_mcollective::params::root_owner,
        group => $pe_mcollective::params::root_group,
        mode  => $pe_mcollective::params::root_mode,
      }

      file {"${plugin_basedir}/agent/nrpe.ddl":
        ensure => file,
        source => 'puppet:///modules/mco_plugins/mcollective-nrpe-agent/agent/nrpe.ddl',
      }

      file {"${plugin_basedir}/agent/nrpe.rb":
        ensure => file,
        source => 'puppet:///modules/mco_plugins/mcollective-nrpe-agent/agent/nrpe.rb',
      }

      file {"${plugin_basedir}/aggregate/nagios_states.rb":
        ensure => file,
        source => 'puppet:///modules/mco_plugins/mcollective-nrpe-agent/aggregate/nagios_states.rb',
      }

      file {"${plugin_basedir}/application/nrpe.rb":
        ensure => file,
        source => 'puppet:///modules/mco_plugins/mcollective-nrpe-agent/application/nrpe.rb',
      }

      file {"${plugin_basedir}/data/nrpe_data.ddl":
        ensure => file,
        source => 'puppet:///modules/mco_plugins/mcollective-nrpe-agent/data/nrpe_data.ddl',
      }

      file {"${plugin_basedir}/data/nrpe_data.rb":
        ensure => file,
        source => 'puppet:///modules/mco_plugins/mcollective-nrpe-agent/data/nrpe_data.rb',
      }

      # Set config: If this setting were in the usual server.cfg file, its name would
      # be plugin.nrpe.conf_dir
      file {"${mco_etc}/plugin.d/nrpe.cfg":
        ensure  => file,
        content => "conf_dir = /etc/nagios/nrpe\n",
      }

    }
~~~

* * *

- [Next: Configuring Orchestration](./orchestration_config.html)

