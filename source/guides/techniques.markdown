---
layout: legacy
title: Techniques
---

Techniques
==========

Here are some useful tips & tricks.

* * *

## How Can I Manage Whole Directories of Files Without Explicitly Listing the Files?

The file type has a "recurse" attribute, which can be used to
synchronize the contents of a target directory recursively with a
chosen source. In the example below, the entire /etc/httpd/conf.d
directory is synchronized recursively with the copy on the server:

    file { "/etc/httpd/conf.d":
      source => "puppet://server/vol/mnt1/adm/httpd/conf.d",
      recurse => true,
    }

You can also set `purge => true` to keep the directory clear of all files or
directories not managed by Puppet.

## How Do I Run a Command Whenever A File Changes?

The answer is to use an exec resource with refreshonly set to true,
such as in this case of telling bind to reload its configuration
when it changes:

    file { "/etc/bind": source => "/dist/apps/bind" }

    exec { "/usr/bin/ndc reload":
      subscribe => File["/etc/bind"],
      refreshonly => true
    }

The exec has to subscribe to the file so it gets notified of
changes.

## How Can I Ensure a Group Exists Before Creating a User?

In the example given below, we'd like to create a user called tim
who we want to put in the fearme group. By using the require
attribute, we can create a dependency between the user tim and the
group fearme. The result is that user tim will not be created until
puppet is certain that the fearme group exists.

    group { "fearme":
            ensure => present,
            gid => 1000
    }
    user { "tim":
            ensure => present,
            gid => "fearme",
            groups => ["adm", "staff", "root"],
            membership => minimum,
            shell => "/bin/bash",
            require => Group["fearme"]
    }

Note that Puppet will set this relationship up for you
automatically, so you should not normally need to do this.

## How Can I Require Multiple Resources Simultaneously?

Give the `require` attribute an array as its value.
In the example given below, we're again adding the user tim (just
as we did earlier in this document), but in addition to requiring
tim's primary group, fearme, we're also requiring another group,
fearmenot. Any reasonable number of resources can be required in
this way.

    user { "tim":
            ensure => present,
            gid => "fearme",
            groups => ["adm", "staff", "root", "fearmenot"],
            membership => minimum,
            shell => "/bin/bash",
            require => [ Group["fearme"],
                                Group["fearmenot"]
                              ]
            }

## Can I use complex comparisons in if statements and variables?

In Puppet version 0.24.6 onwards you can use complex expressions in
if statements and variable assignments. You can see examples of how
to do this in the [language reference](/puppet/latest/reference/lang_expressions.html).

## Can I output Facter facts in YAML?

Facter supports output of facts in YAML as well as to standard out.
You need to run:

    # facter --yaml

To get this output, which you can redirect to a file for further
processing.

## Can I check the syntax of my templates?

ERB files are easy to syntax check. For a file mytemplate.erb,
run:

    $ erb -x -T '-' -P mytemplate.erb | ruby -c

The trim option specified corresponds to what Puppet uses.

