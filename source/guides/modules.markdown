---
layout: default
title: Module Organization
---

Module Organization
===================

How to organize Puppet content inside of modules.

* * *

# General Information

A Puppet Module is a collection of resources, classes, files, definitions
and templates. It might be used to configure Apache or a Rails module, or a
Trac site or a particular Rails application.

Modules are easily re-distributable.  For example, this will
enable you to have the default site configuration under
`/etc/puppet`, with modules shipped by Puppet proper in
`/usr/share/puppet/`.  You could also have other directories containing a happy mix-and-match
of version control checkouts in various states of development and production readiness.

Modules are available in Puppet version 0.22.2 and later.

## Configuration

There are two configuration settings that pertain to modules:

1.  The search path for modules is configured as a colon-separated
    list of directories in the [puppetmasterd] (pre-2.6.0) or [master] (2.6.x and later) section of Puppet master's
    config file with the `modulepath` parameter:

        [puppetmasterd]
        ...
        modulepath = /var/lib/puppet/modules:/data/puppet/modules

    The search path can be added to at runtime by setting the PUPPETLIB
    environment variable, which must also be a colon-separated list of
    directories.

2.  Access control settings for the fileserver module modules in
    fileserver.conf, as described later in this page. The path
    configuration for that module is always ignored, and specifying a
    path will produce a warning.

## Sources of Modules

To accommodate different locations in the file system for the
different use cases, there is a configuration variable modulepath
which is a list of directories to scan in turn.

A reasonable default could be configured as
`/etc/puppet/modules:/usr/share/puppet:/var/lib/modules`.
Alternatively, the `/etc/puppet` directory could be established as a
special anonymous module which is always searched first to retain
backwards compatibility to today's layout.

For some environments it might be worthwhile to consider extending
the modulepath configuration item to contain branches checked out directly from
version control, for example:

    svn:file:///Volumes/svn/repos/management/master/puppet.testing/trunk

## Naming

Module names may only contain letters, numbers, underscores, and dashes 
(i.e. they must match the regular expression `[_-\w]+`). In particular, 
they may not contain the 
namespace separators `::` or `/`. While it might be desirable to allow
module hierarchies, for now modules cannot be nested.

In the filesystem modules are always referred to by the down-cased
version of their name to prevent the potential ambiguity that would
otherwise result.

The module name `site` is reserved for local use and should not be
used in modules meant for distribution.

# Internal Organisation

A Puppet module contains manifests, distributable files, plugins
and templates arranged in a specific directory structure:

    MODULE_PATH/
       downcased_module_name/
          files/
          manifests/
             init.pp
          lib/
             puppet/
                parser/
                   functions
                provider/
                type/
             facter/
          templates/
          README

*NOTE: In Puppet versions prior to 0.25.0 the `lib` directory was named `plugins`. Other directory names are unchanged.*

Each module must contain a `init.pp` manifest file at the specified
location. This manifest file can contain all the classes associated
with this module or additional .pp files can be added directly
under the manifests folder. If adding additional .pp files, naming
them after the class they define will allow auto lookup magic
(explained further below in Module Lookup).

One of the things to be accomplished with modules is code
sharing. A module by nature should be self-contained: one should be
able to get a module from somewhere and drop it into your module
path and have it work.

There are cases, however, where the module depends on generic
things that most people will already have defines or classes for in
their regular manifests. Instead of adding these into the manifests
of your module, add them to the `depends` folder (which is basically
only documenting, it doesn't change how your module works) and
mention these in your `README`, so people can at least see exactly
what your module expects from these generic dependencies, and
possibly integrate them into their own regular manifests.

(See [Plugins In Modules](./plugins_in_modules.html) for info on how to put custom types and
facts into modules in the plugins/ subdir)

## Example

As an example, consider a autofs module that installs a fixed
auto.homes map and generates the auto.master from a template. Its
init.pp could look something like:

    class autofs {
      package { autofs: ensure => latest }
      service { autofs: ensure => running }
      file { "/etc/auto.homes":
        source => "puppet://$servername/modules/autofs/auto.homes"
      }
      file { "/etc/auto.master":
        content => template("autofs/auto.master.erb")
      }
    }

and have these files in the file system:

    MODULE_PATH/
      autofs/
        manifests/
          init.pp
        files/
          auto.homes
        templates/
          auto.master.erb

Notice that the file source path includes a `modules/` component.
In Puppet version 0.25 and later, you must include this component in
source paths in order to serve files from modules. Puppet 0.25 will
still accept source paths without it, but it will warn you with a
deprecation notice about "Files found in modules without specifying
'modules' in file path". In versions 0.24 and earlier, source paths
should *not* include the modules/ component.

Note also that you can still access files in modules when using
puppet instead of puppetd; just leave off the server name and
puppetd will fill in the server for you (using its configuration
server as its file server) and puppet will use its module path:

    file { "/etc/auto.homes":
        source => "puppet:///modules/autofs/auto.homes"
    }

## Module Lookup

Since modules contain different subdirectories for different types
of files, a little behind-the-scenes magic makes sure that the
right file is accessed in the right context. All module searches
are done within the modulepath, a colon-separated list of
directories. In most cases, searching files in modules amounts to
inserting one of manifest, files, or templates after the first
component into a path, i.e. paths can be thought of as
downcased\_module\_name/part\_path where part\_path is a path
relative to one of the subdirectories of the module module\_name.

For file references on the fileserver, a similar lookup is used so
that a reference to puppet://$servername/modules/autofs/auto.homes
resolves to the file autofs/files/auto.homes in the module's path.

Warning: This will only work if you do not have an explicit, for
example [autofs] mount already declared in your fileserver.conf.

You can apply some access controls to files in your modules by
creating a [modules] file mount, which should be specified without
a path statement, in the fileserver.conf configuration file:

    [modules]
    allow *.domain.com
    deny *.wireless.domain.com

Unfortunately, you cannot apply more granular access controls, for
example at the per module level as yet.

To make a module usable with both the command line client and a
puppetmaster, you can use a URL of the form `puppet:///path`, i.e. a
URL without an explicit server name. Such URL's are treated
slightly differently by puppet and puppetd: puppet searches for a
serverless URL in the local filesystem, and puppetd retrieves such
files from the fileserver on the puppetmaster. This makes it
possible to use the same module as part of a site
manifest on a puppetmaster and in a standalone puppet script by
running `puppet --modulepath {path} script.pp`, without any changes to the module.

Finally, template files are searched in a manner similar to
manifests and files: a mention of
template("autofs/auto.master.erb") will make the puppetmaster first
look for a file in $templatedir/autofs/auto.master.erb and then
autofs/templates/auto.master.erb on the module path. This allows
more-generic files to be provided in the templatedir and
more-specific files under the module path (see the discussion under
[Feature 1012](http://projects.puppetlabs.com/issues/1012) for
the history here).

From version Puppet 0.23.1 onwards, everything under the
modulepath is automatically imported into Puppet and is available
to be used. This is called module autoloading.  Puppet will attempt to
auto-load classes and definitions from modules, so you don't have to explicitly import
them. You can just include the module class or start using the
definition. Note that the init.pp file will always be loaded first,
so you can put all of your classes and definitions in there if you
prefer.

With namespaces, some additional magic is also available. Let's say your
autofs module has a class defined in init.pp but you
want an additional class called craziness. If you define that class
as autofs::craziness and store it in file craziness.pp under the
manifests directory, then simply using something like include
autofs::craziness will trigger puppet to search for a class called
craziness in a file named craziness.pp in a module named autofs in
the specified module paths. Hooray!

If you prefer to keep class autofs in a file named autofs.pp,
create an init.pp file containing simply:

    import "*"

And you will then be able to reference the class by using include
autofs just as if it were defined in init.pp.

## Generated Module Documentation

If you decide to make your modules available to others (and please
do!), then please also make sure you document your module so others
can understand and use them. Most importantly, make sure the
dependencies on other defines and classes not in your module are
clear.

From Puppet version 0.24.7 you can generate automated documentation
from resources, classes and modules using the puppetdoc tool. You
can find more detail at the
[Puppet Manifest Documentation](http://www.puppetlabs.com/trac/puppet/wiki/PuppetManifestDocumentation)
page.

## See Also

Distributing custom facts and types via modules: [Plugins In
Modules](./plugins_in_modules.html)



