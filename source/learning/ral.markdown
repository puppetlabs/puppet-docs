---
layout: legacy
title: Learning — Resources
---

Learning — Resources and the RAL
================================

Resources are the building blocks of Puppet, and the division of resources into types and providers is what gives Puppet its power.

* * *

You are at the beginning. --- [Index](./) --- [Manifests](./manifests.html) &rarr;

* * *

[cheat]: http://docs.puppetlabs.com/puppet_core_types_cheatsheet.pdf

Molecules
---------

Imagine a system's configuration as a collection of molecules; call them **"resources."**

These pieces vary in size, complexity, and lifespan: a user account can be a resource, as can a specific file, a software package, a running service, or a scheduled cron job. Even a single invocation of a shell command can be a resource.

Any resource is very similar to a class of related things: every file has a path and an owner, and every user has a name, a UID, and a group. Which is to say: _similar resources can be grouped into types._ Furthermore, the most important attributes of a resource type are usually conceptually identical across operating systems, regardless of how the implementations differ. That is, _the description of a resource can be abstracted away from its implementation._

These two insights form Puppet's resource abstraction layer (RAL). The RAL splits resources into **types** (high-level models) and **providers** (platform-specific implementations), and lets you describe resources in a way that can apply to any system.

Sync: Read, Check, Write
------------------------

Puppet uses the RAL to both read and modify the state of resources on a system. Since it's a declarative system, Puppet starts with an understanding of what state a resource _should_ have. To sync the resource, it uses the RAL to query the current state, compares that against the desired state, then uses the RAL again to make any necessary changes.

Anatomy of a Resource
---------------------

In Puppet, every resource is an instance of a **resource type** and is identified by a **title;** it has a number of **attributes** (which are defined by its type), and each attribute has a **value.**

The Puppet language represents a resource like this:

{% highlight ruby %}
    user { 'dave':
      ensure     => present,
      uid        => '507',
      gid        => 'admin',
      shell      => '/bin/zsh',
      home       => '/home/dave',
      managehome => true,
    }
{% endhighlight %}

This syntax is the heart of the Puppet language, and you'll be seeing it a lot. Hopefully you can already see how it lays out all of the resource's parts (type, title, attributes, and values) in a fairly straightforward way.

The Resource Shell
------------------

Puppet ships with a tool called puppet resource, which uses the RAL to let you query and modify your system from the shell. Use it to get some experience with the RAL before learning to write and apply manifests.

Puppet resource's first argument is a resource type. If executed with no further arguments...

    $ puppet resource user

... it will query the system and return every resource of that type it can recognize in the system's current state.

You can retrieve a specific resource's state by providing a resource name as a second argument.

    $ puppet resource user root

    user { 'root':
        home => '/var/root',
        shell => '/bin/sh',
        uid => '0',
        ensure => 'present',
        password => '*',
        gid => '0',
        comment => 'System Administrator'
    }

Note that puppet resource returns Puppet code when it reads a resource from the system! You can use this code later to restore the resource to the state it's in now.

If any attribute=value pairs are provided as additional arguments to puppet resource, it will modify the resource, which can include creating it or destroying it:

    $ puppet resource user dave ensure=present shell="/bin/zsh" home="/home/dave" managehome=true

    notice: /User[dave]/ensure: created

    user { 'dave':
        ensure => 'present',
        home => '/home/dave',
        shell => '/bin/zsh'
    }

(Note that this command line assignment syntax differs from the Puppet language's normal attribute => value syntax.)

Finally, if you specify a resource and use the `--edit` flag, you can change that resource in your text editor; after the buffer is saved and closed, puppet resource will modify the resource to match your changes.

The Core Resource Types
-----------------------

Puppet has a number of built-in types, and new native types can be distributed with modules. Puppet's core types, the ones you'll get familiar with first, are [notify][], [file][], [package][], [service][], [exec][], [cron][], [user][], and [group][]. Don't worry about memorizing them immediately, since we'll be covering various resources as we use them, but do take a second to print out a copy of the [core types cheat sheet][cheat], a double-sided page covering these eight types. It is doctor-recommended[^doctor] and has been clinically shown to treat reference inflammation.

<!-- TODO: Change that to a link to the PDF. -->

[notify]: ../references/stable/type.html#notify
[file]: ../references/stable/type.html#file
[package]: ../references/stable/type.html#package
[service]: ../references/stable/type.html#service
[exec]: ../references/stable/type.html#exec
[cron]: ../references/stable/type.html#cron
[user]: ../references/stable/type.html#user
[group]: ../references/stable/type.html#group

Documentation for all of the built-in types [can always be found in the reference section of this site][types], and can be generated on the fly with the puppet describe utility.

[types]: ../references/stable/type.html

[^doctor]: The core types cheat sheet is not actually doctor-recommended. If you're a sysadmin with an M.D., please email me so I can change this footnote.

An Aside: puppet describe -s
----------------------------

You can get help for any of the Puppet executables by running them with the `--help` flag, but it's worth pausing for an aside on puppet describe's `-s` flag.

    $ puppet describe -s user

    user
    ====
    Manage users.  This type is mostly built to manage system
    users, so it is lacking some features useful for managing normal
    users.

    This resource type uses the prescribed native tools for creating
    groups and generally uses POSIX APIs for retrieving information
    about them.  It does not directly modify `/etc/passwd` or anything.


    Parameters
    ----------
        allowdupe, auth_membership, auths, comment, ensure, expiry, gid, groups,
        home, key_membership, keys, managehome, membership, name, password,
        password_max_age, password_min_age, profile_membership, profiles,
        project, role_membership, roles, shell, uid

    Providers
    ---------
        directoryservice, hpuxuseradd, ldap, pw, user_role_add, useradd

`-s` makes puppet describe dump a compact list of the given resource type's attributes and providers. This isn't useful when learning about a type for the first time or looking up allowed values, but it's fantastic when you have the name of an attribute on the tip of your tongue or you can't remember which two out of "group," "groups," and "gid" are applicable for the user type.

<!-- Todo: add more exercises, potentially elaborate on a first few resource types. -->

Next
----

Puppet resource can be useful for one-off jobs, but Puppet was born for greater things. [Time to write some manifests](./manifests.html).
