Style Guide
===========

* * *

Introduction
------------

Puppet manifests, as one would expect, can be written in multiple
ways.  There are many variations on how to specify resources, multiple
legal syntaxes, etc.  These guidelines were developed at Stanford
University, where complexity drove the need for a highly formalized
and structured stylistic practice which is strictly adhered to by the
dozen Unix admins who maintain over fifty (50) unique server models
using over five hundred (00) individual manifests and over one
thousand (1,000) unique classes to maintain over four hundred (400)
servers (and those numbers are growing constantly as nearly half the
infrastructure remains to be migrated to Puppet).  With this much code
and so many individuals contributing, it was imperative that every
member of the team wrote Puppet manifests in a consistent and legible
manner.  Thus, the following Style Guide was created.

For consistent look-and-feel of Puppet manifests across the community,
it is suggested that Puppet users adhere to these stylistic
guidelines.  These guidelines are aimed to make large manifests as
legible as possible, so the style aims to columnate and align elements
as neatly as possible.

Arrow Alignment
---------------

The arrow (`=>`) should be aligned at the column one space out from the longest parameter.  Not obvious in the above example is that the arrow is only aligned per resource.  Therefore, the following is correct:

    exec { 
        "blah":
            path => "/usr/bin",
            cwd  => "/tmp";
        "test":
            subscribe   => File["/etc/test"],
            refreshonly => true;
    }
{:puppet}

But the following is incorrect:

    exec { 
        "blah":
            path        => "/usr/bin",
            cwd         => "/tmp";
        "test":
            subscribe   => File["/etc/test"],
            refreshonly => true;
    }
{:puppet}

Attributes and Values
---------------------

### Quoting

Attributes for resources should not be double quoted but their values should
be unless they are native types.  For instance, the keyword `exists` as a value
of the ensure attribute of a file resource should not be in double quotes.  In
contrast, the owner attribute of a file should have a value in double quotes as
the owner will never be a native value.

Example:

    file { "/tmp/somefile":
        ensure => exists,
        owner  => "root",
    }
{:puppet}

### Commas

The last attribute-value pair ends with a comma even though there are no other 
attribute-value pairs.

Example:

    file { "/tmp/somefile":
        ensure => exists,
        owner  => "root",
    }
{:puppet}

Resource Names
--------------

All resource names should be in double quotes.  Although Puppet supports
unquoted resource names if they do not contain spaces, placing all names in
double quotes allows for consistent look-and-feel.

Incorrect:

    package { openssh: ensure => present }
{:puppet}

Correct:

    package { "openssh": ensure => present }
{:puppet}


Resource Declaration
--------------------

### Single-Line statements

In cases where there is only one attribute-value pair, a resource can be
declared in a single line:

    file { "/tmp/somefile": ensure => exists }
{:puppet}

### Multi-Declaration resource statements

In Puppet, when multiple resources of the same type need to be defined, they
can be defined within a single semi-colon separated statement.  Observe the
formatting in the example below:

    file {
        "/tmp/app":
            ensure => directory;
        "/tmp/app/file":
            ensure => exists,
            owner  => "webapp";
        "/tmp/app/file2":
            ensure => exists,
            owner  => "webapp",
            mode   => 755;
    }
{:puppet}

Note that in this case, even though there is a file resource with only one
attribute-value pair, the single line format is not used.  Also note that the last attribute-value
pair ends with a semicolon.  

If all the file resources had only one attribute, the single line format could be used as
below:

    file {
        "/tmp/app":       ensure => directory;
        "/tmp/app/file":  ensure => file;
        "/tmp/app/file2": ensure => file;
    }
{:puppet}

As in the above example, parameter names should be aligned at the column one space out from the colon after the longest resource name (`/tmp/app/file2` in this example).


Symlinks
--------

To make the intended behavior explicitly clear, the following is recommended as the
correct way to specifiy symlinked files:

    file { "/var/log/syslog":
        ensure => link,
        target => "/var/log/messages",
    }
{:puppet}


Case Statements
---------------

A well-formed example of a case select statement:

    case $cloneid {
        "xorn": {
            include soe-workstation
            case $hostname {
                "ford",
                "holbrook",
                "trillian": {
                    include support-workstation
                }
                "mw140ma",
                "mw140mb",
                "mw140mc",
                "mw140md": {
                    include doc-scanner,
                        flat-scanner
                }
            }
        }
        "phoenix": {
            include soe-workstation,
                site-scripts:workstation
            case $hostname {
                "ford",
                "holbrook",
                "trillian": {
                    include support-workstation
                }
                "mw140ma",
                "mw140mb",
                "mw140mc",
                "mw140md": {
                    include doc-scanner,
                        flat-scanner
                    }
                "mw430ma",
                "mw430mb",
                "mw430mc": {
                    include doc-scanner
                }
            }
        }
    }
{:puppet}
