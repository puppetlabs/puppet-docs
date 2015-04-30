---
layout: default
title: "Learning Puppet — Resources and the RAL"
---

[cheat]: /puppet_core_types_cheatsheet.pdf
[notify]: ../references/stable/type.html#notify
[file]: ../references/stable/type.html#file
[package]: ../references/stable/type.html#package
[service]: ../references/stable/type.html#service
[exec]: ../references/stable/type.html#exec
[cron]: ../references/stable/type.html#cron
[user]: ../references/stable/type.html#user
[group]: ../references/stable/type.html#group
[types]: ../references/latest/type.html


Welcome to Learning Puppet! This series covers the basics of writing Puppet code and using Puppet Enterprise. You should already have a copy of the Learning Puppet VM; if you don't, you can [download it for free.][vm_download]

[vm_download]: http://info.puppetlabs.com/download-learning-puppet-VM.html

Begin
-----

Log into the Learning Puppet VM as root, and run `puppet resource service`. This command will return something like the following:


    service { 'NetworkManager':
      ensure => 'stopped',
      enable => 'false',
    }
    service { 'acpid':
      ensure => 'running',
      enable => 'true',
    }
    service { 'anacron':
      ensure => 'stopped',
      enable => 'true',
    }
    service { 'apmd':
      ensure => 'running',
      enable => 'true',
    }
    ...
    ... (etc.)

Okay! You've just met your first Puppet resources.

> ### What Just Happened?
>
> - `puppet`: Most of Puppet's functionality comes from a single `puppet` command, which has many subcommands.
> - `resource`: The `resource` subcommand can inspect and modify resources interactively.
> - `service`: The first argument to the `puppet resource` command must be a **resource type,** which you'll learn more about below. A full list of types can be found at [the Puppet type reference][types].
>
> Taken together, this command inspected every service on the system, whether running or stopped.

Resources
---------

Imagine a system's configuration as a collection of many independent atomic units; call them **"resources."**

These pieces vary in size, complexity, and lifespan. Any of the following (and more) can be modeled as a single resource:

- A user account
- A specific file
- A directory of files
- A software package
- A running service
- A scheduled cron job
- An invocation of a shell command, when certain conditions are met

Any single resource is very similar to a group of related resources:

- Every file has a path and an owner
- Every user has a name, a UID, and a group

The implementation might differ --- for example, you'd need a different command to start or stop a service on Windows than you would on Linux, and even across Linux distributions there's some variety. But conceptually, you're still starting or stopping a service, regardless of what you type into the console.

Abstraction
-----

If you think about resources in this way, there are two notable insights you can derive:

- _Similar resources can be grouped into types._ Services will tend to look like services, and users will tend to look like users.
- _The description of a resource type can be separated from its implementation._ You can talk about whether a service is started without needing to know how to start it.

To these, Puppet adds a third insight:

- With a good enough description of a resource type, _it's possible to declare a desired state for a resource_ --- instead of saying "run this command that starts a service," say "ensure this service is running."

These three insights form Puppet's resource abstraction layer (RAL). The RAL consists of **types** (high-level models) and **providers** (platform-specific implementations) --- by splitting the two, it lets you describe desired resource states in a way that isn't tied to a specific OS.

Anatomy of a Resource
---------------------

In Puppet, every resource is an instance of a **resource type** and is identified by a **title;** it has a number of **attributes** (which are defined by the type), and each attribute has a **value.**

Puppet uses its own language to describe and manage resources:

{% highlight ruby %}
    user { 'dave':
      ensure     => present,
      uid        => '507',
      gid        => 'admin',
      shell      => '/bin/ksh',
      home       => '/home/dave',
      managehome => true,
    }
{% endhighlight %}

This syntax is called a **resource declaration.** You saw it earlier when you ran `puppet resource service`, and it's the heart of the Puppet language. It describes a desired state for a resource, without mentioning any steps that must be taken to reach that state.

> Try and identify all four parts of the resource declaration above:
>
> - Type
> - Title
> - Attributes
> - Values


Resource Types
-----

As mentioned above, every resource has a **type.**

Puppet has many built-in resource types, and you can install even more as plugins. Each type can behave a bit differently, and has a different set of attributes available.

There are several ways to get information about resource types:

### The Cheat Sheet

Not all resource types are equally common or useful, so we've made a printable cheat sheet that explains the eight most useful types. [Download the core types cheat sheet here.][cheat]

### The Type Reference

Experienced Puppet users spend most of their time in [the type reference][types].

This page lists _all_ of Puppet's built-in resource types, in extreme detail. It can be a bit overwhelming for a new user, but it has most of the info you'll need in a normal day of writing Puppet code.

We generate a new type reference for every new version of Puppet, to help ensure that the descriptions stay accurate.

### Puppet Describe

The `puppet describe` subcommand can list info about the _currently installed_ resource types on a given machine. This is different from the type reference because it also catches plugins installed by a user, in addition to the built-in types.

* `puppet describe -l` --- List all of the resource types available on the system.
* `puppet describe -s <TYPE>` --- Print short information about a type, without describing every attribute
* `puppet describe <TYPE>` --- Print long information, similar to what appears in the [type reference][types].



Browsing and Inspecting Resources
-----

In the next few chapters, we'll talk about using the Puppet language to manage resources. For now, though, let's just look at them for a while.

### Live Management in the Console

>**Important**: Live Management is deprecated in PE 3.8, and will be replaced with improved resource management capabilities in future versions of PE. For more information about these changes, see the [PE 3.8 release notes](./release_notes.html#live-management-is-deprecated).

Puppet Enterprise includes a web console for controlling many of its features. One of the things it can do is browse and inspect resources on any PE systems the console can reach. This supports a limited number of resource types, but has some useful comparison features for correlating data across a large number of nodes.

> #### Logging In
>
> When you first started your VM, it gave you the URL, username, and password for accessing the console. The user and password should always be `puppet@example.com` and `learningpuppet`. The URL will be `https://<IP ADDRESS>`; you can get your VM's IP address by running `facter ipaddress` at the command line.

Once logged in, navigate to "Live Management" in the top menu bar, then click the "Browse Resources" tab. From here, you can [use orchestration to find and inspect resources][live_resources].

Since you're only using a single node, you won't see much in the way of comparisons, but you can see the current states of packages, user accounts, etc.

[live_resources]: /pe/3.0/orchestration_resources.html

### The Puppet Resource Command

Puppet includes a command called `puppet resource`, which can interactively inspect and modify resources on a single system.

Usage of puppet resource is as follows:

    # puppet resource <TYPE> [<NAME>] [ATTRIBUTE=VALUE ...]

* The first argument must be a resource type. If no other arguments are given, it will inspect every resource of that type it can find.
* The second argument (optional) is the name of a resource. If no other arguments are given, it will inspect that resource.
* After the name, you can optionally specify any number of attributes and values. This will sync those attributes to the desired state, then inspect the final state of the resource.
* Alternately, if you specify a resource name and use the `--edit` flag, you can change that resource in your text editor; after the buffer is saved and closed, Puppet will modify the resource to match your changes.

> #### Exercises
>
> Inspecting a single resource:
>
>     # puppet resource user root
>
>     user { 'root':
>       ensure           => 'present',
>       comment          => 'root',
>       gid              => '0',
>       groups           => ['root', 'bin', 'daemon', 'sys', 'adm', 'disk', 'wheel'],
>       home             => '/root',
>       password         => '$1$jrm5tnjw$h8JJ9mCZLmJvIxvDLjw1M/',
>       password_max_age => '99999',
>       password_min_age => '0',
>       shell            => '/bin/bash',
>       uid              => '0',
>     }
>
> Setting a new desired state for a resource:
>
>     # puppet resource user katie ensure=present shell="/bin/bash" home="/home/katie" managehome=true
>
>     notice: /User[katie]/ensure: created
>
>     user { 'katie':
>       ensure => 'present',
>       home   => '/home/katie',
>       shell  => '/bin/bash'
>     }


Next
----

**Next Lesson:**

The puppet resource command can be useful for one-off jobs, but Puppet was born for greater things. [Time to write some manifests](./manifests.html).

**Off-Road:**

The LP VM is a tiny sandbox system, and it doesn't have much going on. If you have some dev machines that look more like your actual servers, why not [download Puppet Enterprise for free][dl] and inspect them? Follow [the quick start guide][quick] to get a small environment installed, then try using the console to inspect resources for many systems at once.

[dl]: http://info.puppetlabs.com/download-pe.html
[quick]: /pe/latest/quick_start.html
