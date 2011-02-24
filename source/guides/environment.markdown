---
layout: default
title: Environments
---

Environments
============

Manage development, stage, and production differences.

* * *

Using Multiple Environments
---------------------------

As of 0.24.0, Puppet has support for multiple environments, along
the same lines as
[Ruby on Rails](http://wiki.rubyonrails.org/rails/pages/Environments).
The idea behind these environments is to provide an easy mechanism
for managing machines at different levels of SLA --- some machines
need to be up constantly and thus cannot tolerate disruptions and
usually use older software, while other machines are more up to
date and are used for testing upgrades to more important machines.

Puppet allows you to define whatever environments you want, but it
is recommended that you stick to production, testing, and
development for community consistency.

Puppet defaults to not using an environment, and if you do not set
one on either the client or server, then it will behave as though
environments do not exist at all, so you can safely ignore this
feature if you do not need it.

**Please note:** Not using environments doesn't mean the client
doesn't have an environment set. The client's environment is per
default set to production and will only be changed by changing the
client's configuration or specifying the environment on the command line.
You can't set it to a default value on the server side. For a more
detailed discussion, have a look at:
[environment default setting](http://groups.google.com/group/puppet-users/browse_thread/thread/f97bfad1e46c83c4?hl=en#) thread on the mailing list.

Goal of Environments
--------------------

The main goal of a set-up split by environments could be that
puppet can have different sources for modules and manifests for
different environments on the same Puppet master.

For example, you could have a stable and a testing branch of your
manifests and modules. You could then test changes to your
configuration in your testing environment without impacting nodes
in your production environment.

You could also use environments to deploy infrastructure to
different segments of your network, for example a dmz environment
and a core environment. You could also use environments to specify
different physical locations,

Using Environments on the Puppet Master
---------------------------------------

The point of the environment is to choose which manifests,
templates, and files are sent to the client. Thus, Puppet must be
configured to provide environment-specific sources for this
information.

Puppet environments are implemented rather simply: You add
per-environment sections to the server's puppet.conf configuration
file, choosing different configuration sources for each
environment. These per-environment sections are then used in
preference to the main sections. For instance:

    [main]
        manifest   = /usr/share/puppet/site.pp
        modulepath = /usr/share/puppet/modules

    [development]
        manifest   = /usr/share/puppet/development/site.pp
        modulepath = /usr/share/puppet/development/modules

In this case, any clients in the development environment will use
the `site.pp` file located in the directory
`/usr/share/puppet/development` and Puppet would search for any
modules under the `/usr/share/puppet/development/modules` directory.

Running with any other environment or without an environment would
default to the `site.pp` file and directory specified in the `manifest`
and `modulepath` values in the `[main]` configuration section.

Only certain settings make sense to be configured
per-environment, and all of those settings revolve around
specifying what files to use to compile a client's configuration.
Those settings are:

-   **modulepath**: Where to look for modules. It's best to have a
    standard module directory that all environments share and then a
    per-environment directory where custom modules can be stored.
-   **templatedir**: Where to look for templates. The modulepath
    should be preferred to this setting, but it allows you to have
    different versions of a given template in each environment.
-   **manifest**: Which file to use as the main entry point for the
    configuration. The Puppet parser looks for other files to compile
    in the same directory as this manifest, so this setting also
    determines where other per-environment Puppet manifests should be
    stored. With a separate module path, it should be easy to use the
    same simple manifest in all environments.

Note that using multiple environments works much better if you rely
largely on modules, and you'll find it easier to migrate changes
between environments by encapsulating related files into a module.
It is recommended that you switch as much as possible to modules if
you plan on using environments.

Additionally, the file server uses an environment-specific module
path; if you do your file serving from modules, instead of
separately mounted directories, your clients will be able to get
environment-specific files.

Finally, the current environment is also available as the variable
`$environment` within your manifests, so you can use the same
manifests everywhere and behave differently internally depending on
the environment.

Setting The Client's Environment
--------------------------------

To specify which environment the Puppet client uses you can specify
a value for the `environment` configuration variable in the client's
`puppet.conf` file:

    [puppetd]
        environment = development

This will inform the server which environment the client is in,
here `development`.

You can also specify this on the command line:

    # puppetd --environment=development

Alternatively, rather than specifying this statically in the
configuration file, you could create a custom fact that set the
client environment based upon some other client attribute or an
external data source.

The preferred way of setting the environment is to use an external
node configuration tool; these tools can directly specify a node's
environment and are generally much better at specifying node
information than Puppet is.

Puppet Search Path
------------------

When determining what configuration to apply, Puppet uses a simple
search path for picking which value to use:

-   Values specified on the command line
-   Values specified in an environment-specific section
-   Values specified in an executable-specific section
-   Values specified in the main section

