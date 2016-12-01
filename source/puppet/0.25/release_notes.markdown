---
layout: default
title: "Puppet 0.25 Release Notes"
description: "Puppet release notes for version 0.25.x"
---

# Puppet 0.25 Release Notes

## 0.25.5

### Binaries and Configuration

The default location for Puppet's dynamic files, the $vardir option,
has changed from /var/puppet to /var/lib/puppet. This is already the
default for the Fedora EPEL and Debian/Ubuntu packages and brings
Puppet into FHS compliance.

The default factpath is now $vardir/lib/facter/.

The "use_cached_catalog" option is available.  This determines whether to only use the cached catalog rather than compiling a new catalog on every run.  Puppet can be run with this enabled by default and then selectively disabled when a recompile is desired.  The option defaults to false.

### Functions

The generate function now sets the working directory to the
directory containing the specified command.

### Types and Providers

You can now specify checksum => none in the file type to disable
file check-summing.

### Error Messages

The "warning: Value of 'preferred_serialization_format' ('pson') is
invalid, using default ('yaml')" is now a debug level message.

## 0.25.4

### Binaries and Configuration

- Pre- and Post- transaction hooks.

These hooks allow you to specify commands that should be run pre
and post a Puppet configuration transaction. They are set with the
prerun\_command and postrun\_command settings in the puppet.conf
configuration file:

    prerun_command = /bin/runbeforetransaction
    postrun_command = /bin/runaftertransaction

The command must exit with 0, i.e. succeed, otherwise the
transaction will fail - if the pre command fails before the
transaction is run and if the post command fails at the end of the
transaction.

## 0.25.3

No major notes.

## 0.25.2

### Binaries and Configuration

Puppet now has the manage\_internal\_file\_permissions option which
allows you to enable or disable Puppet management of internal
files, for example those in /var/lib/puppet. When false Puppet will
NOT manage these files. Defualt is true.

The puppetdoc binary now works with Regex node names

Fix for temporary file issues
([https://bugzilla.redhat.com/show\_bug.cgi?id=502881](https://bugzilla.redhat.com/show_bug.cgi?id=502881))

### Types and Providers

Cron type now supported on AIX

Mailist type is now working again

SELinux now supports contexts with upper case titles

When setting aliases using the host and sshkey types now use the host\_aliases attribute rather than alias.

### Error Messages

File serving permissions error messages enhanced

The debug format message has been changed and clarified from:

    debug: Format s not supported for Puppet::FileServing::Metadata; has not implemented method 'from_s'

to:

    debug: file_metadata supports formats: b64_zlib_yaml marshal pson raw yaml; using pson

### Dependencies

When running the tests you no longer need to use RSpec version
1.2.2 but rather versions including and newer than.

### LDAP

There are now valid and proper OIDs in the LDAP puppet.schema that
are unique and registered for Puppet.

## 0.25.1

### Functions

We've clarified that the new 'require' function only works for
0.25.x clients. If the function is specified with 0.24.x or earlier
clients the class will be included but the inherent dependency will
not be created. A warning message will be generated informing you
of this.

### Language

Node regular expression matching rules have been clarified you can
see the rules
[[Language\_Tutorial#matching-nodes-with-regular-expressions|Language
Tutorial]] .

### Types and Providers

The Nagios serviceescalation type now supports the use of the
servicegroup\_name attribute.

### Binaries and Configuration

The Puppet gem now installs all binaries to the 'bin' directory
because Gems lack support for both a bin and sbin directory. Facter
(version later than 1.5.1) is now also a dependency for the gem.

## 0.25.0

### Migration to REST

There are substantial changes in Puppet 0.25.0 and more changes to
come in the future. Most of the changes in 0.25.0 are internal
refactoring rather than behavioural. The 0.25.0 release should be
fully backwards compatible behaviourally with the 0.24.x branch.

This means a 0.25.0 master will be able to manage 0.24.x clients.
You will need, however, to upgrade both your master and your
clients to take advantage of all the new features and the
substantial gains in performance offered by 0.25.0.

The principal change is the introduction of Indirected REST to
replace XML-RPC as the underlying Puppet communications mechanism.

This is a staged change with some functions migrated in this
release and some in the next release. In the first stage of the
Indirected REST implementation the following functions have been
migrated:

-   Certificates
-   Catalogue
-   Reports
-   Files

In 0.26.0 (the next release) the following remaining functions will
be migrated:

-   Filebucket
-   Resource handler
-   Runner handler
-   Status handler

The new REST implementation also comes with authorisation
configuration in a similar style to the namespaceauth used for
XML-RPC. This new authorisation is managed through the auth.conf
file (there is an example file in the conf directory of the
tarball). This does not yet fully replace the namespaceauth.conf
file but will when the remaining handlers are migrated to REST. It
works in a similar way to the namespaceauth.conf file and the
example file contains additional documentation.

As a result of the introduction of REST and other changes you
should see substantial performance improvements in this release.
These particularly include improvements in:

-   File serving
-   The performance of large graphs with lots of edges
-   Stored configuration (see also Puppet Queuing below)

Other new features include (this is not a complete list - please
see the Roadmap for all tickets closed in this release):

### Deprecations

Custom types and facts in modules have been moved from the
module/plugins to module/lib. Please rename your directories.

The modules share and the module name must now be specified in source attributes of the
file type, i.e:

    file { "file":
        source => "puppet://server/modules/module_name/file",
    }

Binary-specific configuration files, such as puppetd.conf or
puppetmasterd.conf are now totally deprecated and ignored.

### New Language Features

Regular expression matching is now possible in node definitions:

    node /web|db/ {
        include blah
    }

    node /^(foo|bar)\.example\.com$/ {
        include blah
    }

Puppet now also allows regular expressions in if statements with
the use of the =\~ (match) and !\~ (not match) operators:

    if $uname =~ /Linux|Debian/ {
       ...
    }

Also available are ephemeral variables ($0 to $9) in the current
scope which contain regex captures:

    if $uname =~ /(Linux|Debian)/ {
        notice("this is a $1 system")
    }

Similar functionality is available in case and selector
statements:

    $var = "foobar"
    case $var {
        "foo": {
             notify { "got a foo": }
        }
        /(.*)bar$/: {
             notify{ "hey we got a $1": }
        }
    }

    $val = $test ? {
            /^match.*$/ => "matched",
            default => "default"
    }

### New functions

There are four new functions:

require - Similar to the include function but creates a dependency
on the required class in the current class. This means the required
class will be loaded before the current class is processed.

split - allows you to split strings and arrays

versioncmp - allows you to compare versions

shellquote - Quote and concatenate arguments for use in the shell,
for example as part of Exec type commands.

### Configuration Versioning

A new configuration option, config\_version, is now available:

    config_version = /usr/local/bin/return_version

The option allows you to specify a command that returns a version
for the configuration that is being applied to your hosts. The
command should return a string, such as a version number or name.

Puppet then runs this command at compile time. Each resource is
marked with the value returned from this command. This value is
also added to the log instance, serialised and sent along with any
report generated. This allows you to parse your report output and
ascertain which configuration version was used to generate the
resource.

### Command Line Compile & Apply

Puppet now has the capability to compile a catalogue and output it
in JSON from the Puppet master. You can do this via the `--compile`
command line option.

    # puppetmasterd --compile nodename

Corresponding with this feature is the ability to apply a JSON
configuration from the puppet binary using the `--apply` option.

    $ puppet --apply cataloguefile

Or you can use - to read the JSON in from standard input. Puppet
will then compile and apply the configuration.

### Thin Stored Configuration

0.25.0 also introduces the concept of "thin" stored configurations.
This is a version of stored configuration that only stores the
facts and exported resources in the database. This will perform
better than full stored configuration but because not all resources
are available this may not suit all purposes.

Thin stored configurations are initiated by setting the
thin\_storeconfigs option on the Puppet master or on the
puppetmasterd command line using \-\-thin\_storedconfigs.

### Puppet Queuing

There is a new binary called puppetqd that supports queuing for
stored configurations. You can read about how it works and how to
implement it at:

[[Using Stored Configuration]]

Further documentation is in the README.queuing file in the
tarball.

### Application Controller

All the logic has been moved out of the binary commands and added
to an Application Controller. You can see the controller code at
lib/puppet/application.rb and the logic for each application at
lib/puppet/application/binaryname.rb.

### Types and Providers

The return values from the Exec type can now be specified as an
array.

The SMF and daemontools service providers can now import a
configuration file.

The mailist type is now supported on Red Hat, CentOS and Fedora
distributions

The NetInfo provider has been deprecated for OSX in favour of the
Directory Services provider.

### Binary Location Move

To bring Puppet more in line with general packaging standards the
puppetd, puppetca, puppetrun, puppetmasterd, and puppetqd binaries
now reside in the sbin directory rather than the bin directory when
installed from the source package.

### Passenger

Ensure you have the latest version of the config.ru file from the
ext/rack/files/ directory in the tarball.

### Rails

Rails versions up to 2.3.x are now supported. Rails version 2.2.2
or greater is required.