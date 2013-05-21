---
layout: default
title: Puppet 0.24 Release Notes
description: Puppet release notes for version 0.24.x
---

# Puppet 0.24 Release Notes

## 0.24.9

### Binaries and Configuration

Fix for temporary file issues
([https://bugzilla.redhat.com/show\_bug.cgi?id=502881](https://bugzilla.redhat.com/show_bug.cgi?id=502881))

## 0.24.8

### Functions

Added sprintf function

Added regsubst function

## 0.24.7

### Binary and Configuration

The puppetdoc binary has been updated to output manifest and module
documentation

Removed conf/debian directory and Debian packaging information now
maintained downstream

The puppetca binary can now clean unsigned certificates

Removed all the vendor gems

Added Rake tasks to support continuous integration

### Types and Providers

Added augeas type

Added MCX type

Add the macauthorization type

Add the directoryservice type

Deprecated the NetInfo nameservice provider

Added zfs, zpool types and branded zones support to the zones type

Added uninstall functionality to yum provider

Added preseed support to apt provider's uninstall and purge
functions

Added versionable feature to the RPM provider

Replaced SELInux calls to binaries with Ruby SELinux bindings

Updates to the Nagios types

### Language and Facts

Added support for @doc type and manifest documentation support

Added multiline comment support

Classes and nodes should set $name variables

### Functions

Add inline\_template function

### Stored Configuration

The environment has been added to the stored configuration database
structure. You will need to specify the dbmigrate = true in your
puppet.conf to ensure your database is upgraded to the new schema.

### Errata

\#1922: Severe breakage when using parser functions with complex
arguments.

## 0.24.6

### Dependencies

\#1553: Depends on Facter 1.5

### Binary and Configuration

Added \-\-detailed-exits option to puppet binary that adds specific
exit codes after runs.

Log messages are now tagged with the log level, making it easier to
match messages in the tagmail report.

Added support for running Puppet inside a Rack application
(mod\_rails) with Passenger and Apache

Fixed the puppetca \-\-clean \-\-all binary so that both signed and
unsigned certificates are cleaned.

Moved individual functions out of functions.rb into
lib/puppet/parser/functions directory. New functions should be
created in this directory.

Added the -P/\-\-ping option to puppetrun.

Allow specification of \-\-bindir \-\-sbindir \-\-sitelibdir \-\-mandir
\-\-destdir in installation

### Language and Facts

Allow multiple overrides in one statement

Fixed \#1585 - Allow complex 'if' and variable expressions

Fixed \#1584 - Added support for appended variables

### Types and Providers

Feature \#1624 - Added RBAC roles to solaris user provider

Fixed \#1586 - Specifying "fully qualified" package names in Gentoo

Fixed \#1530 - ssh\_authorized\_keys provider does not crash anymore
on SSH type 1 keys

Fixes \#1455 - Adds HP-UX support for user type

Added daemontools and runit providers for service type

Fixed \#1508 - Added HP-UX package provider

Fixed \#1456 - add proxy configuration capability to yum repo

## 0.24.5

### Binary and Configuration

Added the catalog_format configuration option which accepts the
yaml or marshal options. This option allows you to switch the
catalog formatting from YAML to Marshal. Marshal formatting should
provide significant performance enhancement over YAML.

The return code from waitpid now right shifted 8 bits.

Added support for the \-\-all option to puppetca \-\-clean. If puppetca
\-\-clean \-\-all is issued then all client certificates are removed.

### Environments

The default environment is now production.

### Types and Providers

The interface type is buggy and has been disabled.

A native type type for managing ssh authorized\_keys files is
available

The gem package type can now specify source repositories.

The service type now supports HP-UX.

On Red Hat instead of deleting the init scripts (with chkconfig
\-\-del) we disable it with chkconfig service off, and do the same
for enable => true;

Added LDAP providers for users and groups.

### Functions

Added SHA1 function from DavidS to core

### Language and Facts

Facts in plugin directories should now be autoloaded, as long as
you're using Facter 1.5.

Aliases to titles now work for resources.

Modified the 'factpath' setting to automatically configure Facter
to load facts there if a new enough version of Facter is used.

### Modules

Templates in the templatedir are preferred to module templates.

### LDAP

Removed support for the 'node\_name' setting in LDAP and external
node lookups.

### Nodes

Removed support for 'default' nodes in external nodes. LDAP nodes
now use the certificate name, the short name, and 'default', but
external nodes just use the certificate name and any custom
terminus types will use just the certificate name.

### Virtual and Exported/Collected Resources

Exporting or collecting resources no longer raises an exception
when no storeconfigs is enabled, it just produces a warning.

## 0.24.4

### Binary and Configuration

The http keep-alive is now disabled by default. There is now a
constant in Puppet::Network::HttpPool that will disable or enable
this feature but it you enable it you may be at risk of corruption,
especially in file serving.

The yamldir is automatically created by the server now that it's in
the puppetmasterd section rather than a separate yaml section.

### Types and Providers

In the OpenBSD package provider, assume a source ending in a /
indicates it is a directory, and pass it to pkg\_add via PKG\_PATH.
Allows pkg\_add to resolve dependencies, and make it possible to
specify packages without version numbers.

Provider suitability is now checked at resource evaluation time,
rather than resource instantiation time. This means that you don't
catch your "errors" as early, but it also means you should be able
to realistically configure a whole host in one run.

### Documentation

Puppet now has man pages available. These are recreated at each
release. They are located in the man directory and are installed
into mandir.

## 0.24.3

### Languages and Facts

Downloading plugins and facts now ignores noop. Note that this
changes the behaviour of a resource's noop setting. The resources
noop setting will now alway override the global setting
(previously, whichever was true would win).

Host names can now have dashes anywhere.

### Binaries and Configuration

The CA serial file will no longer ever be owned by root.

### External Nodes

External node commands can specify an environment and Puppet will
now use it.

### LDAP Nodes

LDAP nodes now support environments, and the schema has been
updated accordingly.

## 0.24.2

### Plugins

Autoloading now searches the plugins directory in each module, in
addition to the libdir directory. The libdir directory is also
deprecated, but supported for now to give people a chance to
convert.

### Virtual Resources

Virtual defined types are no longer evaluated. This introduces a
behaviour change, in that you previously could realize a resource
within a virtual defined resource, and now you must realize the
entire defined resource, rather than just the contained resource.

### Tags

The full name of qualified classes and the class parts are now
added as tags. This is supported by the new Tagging module.

### Binaries and Configuration

The rundir directory permissions are again set to 1777.

The yamldir setting has been moved to its own yaml section. This
should keep the yamldir from being created on clients.

### Language and Facts

Classes can once again be included multiple times.

Exec resources must now have unique names, although the commands
can still be duplicated. This is easily accomplished by just
specifying a unique name with whatever (unique or otherwise)
command you need.

There is a change in Puppet's parser - the order of statement
evaluation is no longer changed. This means case statements can now
set variables that can be used by other variables.

### Types and Providers

Added built-in support for Nagios types using Naginator to parse
and generate the files.

The package type (and Puppet overall) is now compatible with gems
1.0.1.

You can now copy links using the file type.

Removed the loglevels from the valid values for logoutput in the
exec resource type -- the log levels are specified using the
loglevel parameter, not logoutput.

## 0.24.1

### Binaries and Configuration

Removed the ability to disable http keep-alive.

Removed warning about deprecated explicit plugins mounts.

## 0.24.0 (misspiggy)

### External Nodes

External node support now requires that you set the node\_terminus
setting to exec:

    node_terminus = exec

External nodes can now co-exist with manifest-based nodes.
Previously you had to select one or the other.

### LDAP Nodes

LDAP nodes can now co-exist with manifest-based nodes. Previously
you had to select one or the other.

### Plugins

Added plugins mount - see PluginsInModules on the wiki for
information.

### Certificates

Certificates now always specify a subjectAltName, but it defaults
to \*\`, meaning that it doesn't require DNS names to match.&nbsp;
You can override that behaviour by specifying a value for the
\`\`certdnsnames configuration option which will then require that
hostname as a match.

The behaviour of the certdnsnames setting has changed. It now
defaults to an empty string, and will only be used if it is set to
something else. If it is set, then the host's FQDN will also be
added as an alias. The default behaviour is now to add puppet and
puppet.$domain as DNS aliases when the name for the cert being
signed is equal to the signing machine's name, which will only be
the case for CA servers. This should result in servers always
having the alias set up and no one else, but you can still override
the aliases if you want.

### Mongrel

Changed the behaviour of \-\-debug to include Mongrel client
debugging information. Mongrel output will be written to the
terminal only, not to the puppet debug log.

### Language and Facts

The node scope is now above all other scopes besides the main
scope, which should help make its variables visible to other
classes, assuming those classes were not included in the node's
parent.

Relationship metaparameters :notify, :require, :subscribe, and
:before now stack when they are collecting metaparameter values
from their containers. For instance, if a resource inside a
definition has a value set for require, and you call the definition
with require, the resource gets both requires, where before it
would only retain its initial value.

### Binaries and Configuration

Added the \-\-no-daemonize option to puppetd and puppetmasterd which
prevents both binaries from daemonizing. If you use daemontools or
runit you must pass the \-\-no-daemonize to puppetd and
puppetmasterd. Additionally, the default behavior of \-\-verbose and
\-\-debug no longer cause puppetd and puppetmasterd to not
daemonize.

The \-\-use-nodes and \-\-no-nodes options are now obsolete. Puppet
automatically detects when nodes are defined, and if they are
defined it will require that a node be found, else it will not look
for a node nor will it fail if it fails to find one.

You now must specify an environment and you are required to specify
the valid environments for your site.

The http\_enable\_post\_connection\_check added as a configuration
option for puppetd. This defaults to true, which validates the
server SSL certificate against the requested host name in new
versions of Ruby.

### Types and Providers

Added k5login type.

Removed type and running as valid attributes from the service types
as they are both deprecated.

Modified how services manage their list of paths. Services now
default to the paths specified by the provider classes.
