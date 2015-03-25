---
layout: default
title: Learning Puppet — Modules and Classes
---


[smoke]: /guides/tests_smoke.html
[manifestsdir]: #manifests-namespacing-and-autoloading


Begin
-----

{% highlight ruby %}
    class my_class {
      notify {"This actually did something":}
    }
{% endhighlight %}

This manifest does nothing.

{% highlight ruby %}
    class my_class {
      notify {"This actually did something":}
    }

    include my_class
{% endhighlight %}

This one actually does something.

Spot the difference?


The End of the One Huge Manifest
-----

You can write some pretty sophisticated manifests at this point, but so far you've just been putting them in one file (either `/etc/puppetlabs/puppet/manifests/site.pp` or a one-off to use with puppet apply).

Past a handful of resources, this gets unwieldy. You can probably already see the road to the three thousand line manifest of doom, and you don't want to go there. It's much better to split chunks of logically related code out into their own files, and then refer to those chunks by name when you need them.

**Classes** are Puppet's way of separating out chunks of code, and **modules** are Puppet's way of organizing classes so that you can refer to them by name.


Classes
-------

Classes are named blocks of Puppet code, which can be created in one place and invoked elsewhere.

* **Defining** a class makes it available by name, but doesn't automatically evaluate the code inside it.
* **Declaring** a class evaluates the code in the class, and applies all of its resources.

For the next five minutes, we'll keep working in a single manifest file; either a one-off, or site.pp. In a few short paragraphs, we'll start separating code out into additional files.

### Defining a Class

Before you can use a class, you must **define** it, which is done with the `class` keyword, a name, curly braces, and a block of code:

    class my_class {
      ... puppet code ...
    }

What goes in that block of code? How about your answer from last chapter's NTP exercise? It should look a little like this:


{% highlight ruby %}
    # /root/examples/modules1-ntp1.pp

    class ntp {
      case $operatingsystem {
        centos, redhat: {
          $service_name = 'ntpd'
          $conf_file    = 'ntp.conf.el'
        }
        debian, ubuntu: {
          $service_name = 'ntp'
          $conf_file    = 'ntp.conf.debian'
        }
      }

      package { 'ntp':
        ensure => installed,
      }
      file { 'ntp.conf':
        path    => '/etc/ntp.conf',
        ensure  => file,
        require => Package['ntp'],
        source  => "/root/examples/answers/${conf_file}"
      }
      service { 'ntp':
        name      => $service_name,
        ensure    => running,
        enable    => true,
        subscribe => File['ntp.conf'],
      }
    }
{% endhighlight %}

That's a working class definition!

> Note: You can download some basic NTP config files here: [Debian version](./files/examples/modules/ntp/files/ntp.conf.debian), [Red Hat version](./files/examples/modules/ntp/files/ntp.conf.el).

> #### Aside: Class Names
>
> [Class names](/puppet/latest/reference/lang_reserved.html#classes-and-types) must start with a lowercase letter, and can contain lowercase letters, numbers, and underscores.
>
> Class names can also use a double colon (`::`) as a namespace separator. (This should [look familiar](./variables.html#variables).) Namespaces must map to module layout, which we'll cover below.

> #### Aside: Variable Scope
>
> Each class definition introduces a new variable scope. This means:
>
> * Any variables you assign inside the class won't be accessible by their short names outside the class; to get at them from elsewhere, you would have to use the fully-qualified name (e.g. `$ntp::service_name`, from our example above).
> * You can assign new, local values to variable names that were already used at top scope. For example, you could specify a new local value for $fqdn.

### Declaring

Okay, remember how we said that _defining_ makes a class available, and _declaring_ evaluates it? We can see that in action by trying to apply our manifest above:

    # puppet apply /root/examples/modules1-ntp1.pp
    notice: Finished catalog run in 0.04 seconds

...which does nothing, because we only defined the class.

To **declare** a class, use the `include` function with the class's name:

{% highlight ruby %}
    # /root/examples/modules1-ntp2.pp

    class ntp {
      case $operatingsystem {
        centos, redhat: {
          $service_name = 'ntpd'
          $conf_file    = 'ntp.conf.el'
        }
        debian, ubuntu: {
          $service_name = 'ntp'
          $conf_file    = 'ntp.conf.debian'
        }
      }

      package { 'ntp':
        ensure => installed,
      }
      file { 'ntp.conf':
        path    => '/etc/ntp.conf',
        ensure  => file,
        require => Package['ntp'],
        source  => "/root/examples/answers/${conf_file}"
      }
      service { 'ntp':
        name      => $service_name,
        ensure    => running,
        enable    => true,
        subscribe => File['ntp.conf'],
      }
    }

    include ntp
{% endhighlight %}

This time, Puppet will actually apply all those resources:

    # puppet apply /root/examples/ntp-class2.pp

    notice: /Stage[main]/Ntp/File[ntp.conf]/content: content changed '{md5}5baec8bdbf90f877a05f88ba99e63685' to '{md5}dc20e83b436a358997041a4d8282c1b8'
    notice: /Stage[main]/Ntp/Service[ntp]/ensure: ensure changed 'stopped' to 'running'
    notice: /Stage[main]/Ntp/Service[ntp]: Triggered 'refresh' from 1 events
    notice: Finished catalog run in 0.76 seconds


Classes: Define, then declare.

Modules
-------

You know how to define and declare classes, but we're still doing everything in a single manifest, where they're not very useful.

To help you split up your manifests into an easier to understand structure, Puppet uses **modules** and the **module autoloader.**

[modulepath]: /references/stable/configuration.html#modulepath

It works like this:

* Modules are just directories with files, arranged in a specific, predictable structure. The manifest files within a module have to obey certain naming restrictions.
* Puppet looks for modules in a specific place (or list of places). This set of directories is known as the `modulepath`, which is a [configurable setting][modulepath].
* If a class is defined in a module, you can declare that class by name in _any_ manifest. Puppet will automatically find and load the manifest that contains the class definition.

This means you can have a pile of modules with sophisticated Puppet code, and your site.pp manifest can look like this:

{% highlight ruby %}
    # /etc/puppetlabs/puppet/manifests/site.pp
    include ntp
    include apache
    include mysql
    include mongodb
    include build_essential
{% endhighlight %}

By stowing the _implementation_ of a feature in a module, your main manifest can become much smaller, more readable, and policy-focused --- you can tell at a glance what will be configured on your nodes, and if you need implementation details on something, you can delve into the module.

### The Modulepath

Before we make a module, we need to know where to put it. So we'll find our modulepath, the set of directories that Puppet searches for modules.

The Puppet config file is called puppet.conf, and in Puppet Enterprise it is located at `/etc/puppetlabs/puppet/puppet.conf`:

    # less /etc/puppetlabs/puppet/puppet.conf

    [main]
        vardir = /var/opt/lib/pe-puppet
        logdir = /var/log/pe-puppet
        rundir = /var/run/pe-puppet
        modulepath = /etc/puppetlabs/puppet/modules:/opt/puppet/share/puppet/modules
        user = pe-puppet
        group = pe-puppet
        archive_files = true
        archive_file_server = learn.localdomain

    [master]
        ... etc.

The format of puppet.conf [is explained in the configuration docs](/puppet/latest/reference/config_file_main.html), but in short, the `[main]` section has settings that apply to everything (puppet master, puppet apply, puppet agent, etc.), and it sets the value of `modulepath` to a colon-separated list of two directories:

* `/etc/puppetlabs/puppet/modules`
* `/opt/puppet/share/puppet/modules`

The first, `/etc/puppetlabs/puppet/modules`, is the main module directory we'll be using. (The other one contains special modules that Puppet Enterprise uses to configure its own features; you can look in these, but shouldn't change them or add to them.)

> #### Aside: Configprint
>
> You can also get the value of the modulepath by running `puppet master --configprint modulepath`. The `--configprint` option lets you get the value of any Puppet [setting](/references/latest/configuration.html); by using the `master` subcommand, we're making sure we get the value the puppet master will use.


### Module Structure

* A module is a directory.
* The module's name must be the name of the directory.
* It contains a `manifests` directory, which can contain any number of .pp files.
* The `manifests` directory should always contain an `init.pp` file.
    * This file must contain a single class definition. The class's name must be the same as the module's name.

There's more to know, but this will get us started. Let's turn our NTP class into a real module:

    # cd /etc/puppetlabs/puppet/modules
    # mkdir -p ntp/manifests
    # touch ntp/manifests/init.pp

Edit this init.pp file, and paste your ntp class definition into it. Be sure not to paste in the `include` statement; it's not necessary here.

{% highlight ruby %}
    # /etc/puppetlabs/puppet/modules/ntp/manifests/init.pp

    class ntp {
      case $operatingsystem {
        centos, redhat: {
          $service_name = 'ntpd'
          $conf_file    = 'ntp.conf.el'
        }
        debian, ubuntu: {
          $service_name = 'ntp'
          $conf_file    = 'ntp.conf.debian'
        }
      }

      package { 'ntp':
        ensure => installed,
      }
      file { 'ntp.conf':
        path    => '/etc/ntp.conf',
        ensure  => file,
        require => Package['ntp'],
        source  => "/root/examples/answers/${conf_file}"
      }
      service { 'ntp':
        name      => $service_name,
        ensure    => running,
        enable    => true,
        subscribe => File['ntp.conf'],
      }
    }
{% endhighlight %}


### Declaring Classes From Modules

Now that we have a working module, you can edit your site.pp file: if there are any NTP-related resources left in it, be sure to delete them, then add one line:

    include ntp

Turn off the NTP service, then do a foreground puppet agent run so you can see the action:

    # service ntpd stop
    # puppet agent --test

    notice: /Stage[main]/Ntp/Service[ntp]/ensure: ensure changed 'stopped' to 'running'

It worked!


More About Declaring Classes
-----

Once a class is stored in a module, there are actually several ways to declare or assign it. You should try each of these right now by manually turning off the ntpd service, declaring or assigning the class, and doing a Puppet run in the foreground.

### Include

We already saw this: you can declare classes by putting `include ntp` in your main manifest.

The `include` function declares a class, if it hasn't already been declared somewhere else. If a class HAS already been declared, `include` will notice that and do nothing.

This lets you safely declare a class in several places. If some class depends on something in another class, it can declare that class without worrying whether it's also being declared in site.pp.

### Resource-Like Class Declarations

These look like resource declarations, except with a resource type of "class:"

{% highlight ruby %}
    class {'ntp':}
{% endhighlight %}

These behave differently, acting more like resources than like the `include` function. Remember we've seen that you can't declare the same resource more than once? The same holds true for resource-like class declarations. If Puppet tries to evaluate one and the class has already been declared, it will **fail compilation** with an error.

However, unlike `include`, resource-like declarations let you specify _class parameters._ We'll cover those [in a later chapter](./modules2.html), and go into more detail about why resource-like declarations are so strict.

### The PE Console

You can also assign classes to specific nodes using PE's web console. You'll have to [add the class to the console][pe_classes], then navigate to a node's page and [assign the class to that node][pe_node_class].

We'll go into more detail later about working with multiple nodes.

[pe_classes]: /pe/latest/console_classes_groups.html#adding-classes-to-a-node-group
[pe_node_class]: /pe/latest/console_classes_groups.html#adding-classes-to-a-node-group



Module Structure, Part 2
-----

We're not quite done with this module yet. Notice how the `source` attribute of the config file is pointing to an arbitrary local path? We can move those files inside the module, and make everything self-contained:

    # mkdir /etc/puppetlabs/puppet/modules/ntp/files
    # mv /root/examples/answers/ntp.conf.* /etc/puppetlabs/puppet/modules/ntp/files/

Then, edit the init.pp manifest; we'll use the special `puppet:///` URL format to tell Puppet where the files are:

{% highlight ruby %}
    # ...
      file { 'ntp.conf':
        path    => '/etc/ntp.conf',
        ensure  => file,
        require => Package['ntp'],
        source  => "puppet:///modules/ntp/${conf_file}",
      }
    }
{% endhighlight %}

Now, everything the module needs is in one place. Even better, a puppet master can actually serve those files to agent nodes over the network now --- when we were using `/root/examples/etc...` paths, Puppet would only find the source files if they already existed on the target machine.

### The Other Subdirectories

We've seen two of the subdirectories in a module, but there are several more available:

* `manifests/` --- Contains all of the manifests in the module.
* `files/` --- Contains static files, which managed nodes can download.
* `templates/` --- Contains templates, which can be referenced from the module's manifests. [More on templates later](./templates.html).
* `lib/` --- Contains plugins, like custom facts and custom resource types.
* `tests/` or `examples/` --- Contains example manifests showing how to declare the module's classes and defined types.
* `spec/` --- Contains test files written with rspec-puppet.

> Our printable [Module Cheat Sheet](/module_cheat_sheet.pdf) shows how to lay out a module and explains how in-manifest names map to the underlying files; it's a good quick reference when you're getting started. The Puppet reference manual also has [a page of info about module layout](/puppet/latest/reference/modules_fundamentals.html).

This is a good time to explain more about how the `manifests` and `files` directories work:

### Organizing and Referencing Manifests

Each manifest in a module should contain exactly one class or defined type. (More on defined types later.)

Each manifest's filename must map to the name of the class or defined type it contains. The init.pp file, which we used above, is special --- it always contains a class (or defined type) with the same name as the module. Every other file must contain a class (or defined type) named as follows:

`<MODULE NAME>::<FILENAME>`

...or, if the file is inside a subdirectory of `manifests/`, it should be named:

`<MODULE NAME>::<SUBDIRECTORY NAME>::<FILENAME>`

So for example, if we had an apache module that contained a mod_passenger class:

* File on disk: `apache/manifests/mod_passenger.pp`
* Name of class in file: `apache::mod_passenger`

You can see more detail about this mapping at [the namespaces and autoloading page of the Puppet reference manual](/puppet/latest/reference/lang_namespaces.html).

### Organizing and Referencing Files

Static files can be arranged in any directory structure inside the `files/` directory.

When referencing these files in Puppet manifests, as the `source` attributes of file resources, you should use `puppet:///` URLs. These have to be structured in a certain way:

 Protocol | 3 slashes | "modules"/ | Name of module/ |  Name of file
----------|-----------|------------|-----------------|---------------
`puppet:` |   `///`   | `modules/` |     `ntp/`      | `ntp.conf.el`

Note that the final segment of the URL starts inside the `files/` directory of the module. If there are any extra subdirectories, they work like you'd expect, so you could have something like `puppet:///modules/ntp/config_files/linux/ntp.conf.el`.



The Puppet Forge: How to Avoid Writing Modules
-----

Now that you know how modules work, you can also use modules written by other users.

The [Puppet Forge](http://forge.puppetlabs.com) is a repository of free modules you can install and use. Most of these modules are open source, and you can easily contribute updates and changes to improve or enhance these modules. You can also contribute your own modules.

### The Puppet Module Subcommand

Puppet ships with a module subcommand for installing and managing modules from the Puppet Forge. Detailed instructions for using it can be found in [the Puppet reference manual's "installing modules" page][installing]. Some quick examples:

Install the puppetlabs-mysql module:

    $ sudo puppet module install puppetlabs-mysql

List all installed modules:

    $ sudo puppet module list

[installing]: /puppet/latest/reference/modules_installing.html


> #### User Name Prefixes
>
> Modules from the Puppet Forge have a user name prefix in their names; this is done to avoid name clashes between, for example, all of the Apache modules out there.
>
> The puppet module subcommand handles these user name prefixes automatically --- it preserves them as metadata, but installs the module under its common name. That is, your Puppet manifests would refer to a `mysql` module instead of the `puppetlabs-mysql` module.


Exercises
---------

> ### Exercise: Apache Again
>
> Building on your work from two chapters ago, create an Apache module and class, which ensures Apache is installed and running and manages its config file. **Bonus work:** Make Puppet manage the DocumentRoot folder, and put a custom 404 page and default index.html in place. You can also use conditional statements to set any files or package/service names that might vary per OS; if you don't want to research the names used by other OSes, you can just have the class fail if it's not used on CentOS.

Next
----

**Next Lesson:**

What's with that `templates/` folder in the module structure? And can we do anything more interesting with config files than just replacing them with static content? [Find out in the Templates chapter.](./templates.html)

**Off-Road:**

Since you know how to install free modules from the Puppet Forge, and how to declare the classes inside those modules, search around and try to find some modules that might be useful in your infrastructure. Then [download Puppet Enterprise for free][dl], follow [the quick start guide][quick] to get a small environment installed, and try managing complex services on some of your test nodes.


[dl]: http://info.puppetlabs.com/download-pe.html
[quick]: /pe/latest/quick_start.html
