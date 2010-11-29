---
layout: default
title: Techniques
---

Techniques
==========

Here are some useful tips & tricks.

* * *

## How Can I Manage Whole Directories of Files Without Explicitly Listing the Files?

The file type has a parameter recurse which can be used to
synchronize the contents of a target directory recursively with a
chosen source. In the example below, the entire /etc/httpd/conf.d
directory is synchronized recursively with the copy on the server:

    file { "/etc/httpd/conf.d":
      source => "puppet://server/vol/mnt1/adm/httpd/conf.d",
      recurse => "true"
    }

## I Want To Manage A Directory and Purge Its Contents

Many people try to do something like this:

    file { "/etc/nagios/conf.d":
      owner   => nagios,
      group   => nagios,
      purge   => true,
      recurse => true,
      force   => true,
    }

It seems what most people expect to happen here is create the named
directory, set the owner and group, then purge any files or
directories that are not managed by puppet underneath that. But
this is not the behaviour puppet will display. In fact the purge
will silently fail.

The workaround is to define a source for the directory that doesn't
exist.

    file { "/etc/nagios/conf.d":
       owner   => nagios,
       group   => nagios,
       purge   => true,
       recurse => true,
       force   => true,
       source  => "puppet:///nagios/emtpy",
    }

The fileserver context (here 'nagios') must exist and be created by
the fileserver and an empty directory must also exist, and puppet
will purge the files as expected.

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
parameter, we can create a dependency between the user tim and the
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
to do this in the [Language Tutorial](./language_tutorial.html) .

In versions prior to 0.24.6 Puppet does not support complex
conditionals: if can only test for the existence of a variable, and
case can only switch on a defined string.

However, a workaround is possible by using the generate() function
to call out to Ruby or Perl to perform the comparison, eg:

    if generate('/usr/bin/env', 'ruby', '-e', 'puts :true if eval ARGV[0]', "'$operatingsystem' =~ /redhat/") {
         # do stuff
    }

The Perl equivalent is:

    if generate('/usr/bin/env', 'perl', '-e', 'print("true") if (eval shift)', "'$operatingsystem' =~ /redhat/") {
         # do stuff
    }

Note that the generate() function is executed on the Puppet master
at manifest compilation, so cannot be used client-side. Also note
the quoting around the final option - this is to ensure that
$operatingsystem variable is interpolated by the parser and passed
to the Ruby or Perl interpreter as a string.

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

