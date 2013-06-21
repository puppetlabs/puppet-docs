---
layout: default
title: "PE 3.0 » Orchestration » Adding New Actions"
subtitle: "Adding New Orchestration Actions to Puppet Enterprise"
---

todo
You can easily add new orchestration actions by distributing custom MCollective agent plugins to your nodes.
Installing custom data plugins is similar to installing custom agent plugins;
You can extend the orchestration engine by downloading or writing new plugins and adding them to the engine with Puppet

> ### Related Topics
>
> * For an overview of orchestration topics, see [the Orchestration Overview page][fundamentals].
> * To invoke actions in the web console, see [Navigating Live Management](./console_navigating_live_mgmt.html).
> * To invoke actions on the command line, see [Invoking Actions](./orchestration_invoke_cli.html).
> * For a list of built-in actions, see [List of Built-In Orchestration Actions](./orchestration_actions.html).

[fundamentals]: ./orchestration_overview.html#orchestration-fundamentals

todo

----



Actions and Plugins
-----

### About MCollective Agent Plugins


Obtaining New Plugins
-----

### Downloading MCollective Agent Plugins

### Writing MCollective Agent Plugins


Installing Plugins on Puppet Enterprise Nodes
-----

blah blah puppet

link to /mcollective/deploy/plugins.html

### Anchoring the Class

mco package -> NOPE, package is already installed by pe installer.
    Ooh, but maybe depend on pe_mcollective::plugins, because it's doing that windows plugin directory resource and I don't know

class ~> mco service, watch out for containment probs if you're doing class(class).

  service { 'pe-mcollective':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }

so the service is what we think it is. it's in class pe_mcollective::server.



### Putting Files in Place

include pe_mcollective::params

    $plugin_basedir = $::osfamily ? {
      'windows' => "${pe_mcollective::params::mco_etc}/plugins/mcollective",
      default   => '/opt/puppet/libexec/mcollective/mcollective'
    }

or maybe you could use include pe_mcollective::plugins and reference pe_mcollective::plugins::plugin_basedir


Document our dependencies so PE team can know when to be careful changing things.

### Configuring

/etc/puppetlabs/mcollective/plugin.d -- already exists, but nothing in it.
/mcollective/configure/server.html#plugin-config-directory-optional

#### configuring clients?????? is that in /var/lib/peadmin/plugin.d? the config class sure makes it look like that.

### Assigning the Class to MCollective Nodes

the new mcollective group, see predocs
    mcollective
    no mcollective
    (with the space)

or another group if you're limiting its propagation.


### Confirming it's installed

just deep links