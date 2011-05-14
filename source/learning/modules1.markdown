---
layout: default
title: Learning — Modules 1
---

Learning — Modules and Classes (Part One)
=========================================

You can write some pretty sophisticated manifests at this point, but they're still at a fairly low altitude, going resource-by-resource-by-resource. Now, zoom out with resource collections. 

* * *

&larr; [Variables, etc.](./variables.html) --- [Index](./) --- TBA &rarr;

* * * 

[smoke]: http://docs.puppetlabs.com/guides/tests_smoke.html
[manifestsdir]: #namespacing-and-autoloading

Collecting and Reusing
----------------------

At some point, you're going to have Puppet code that fits into a couple of different buckets: really general stuff that applies to all your machines, more specialized stuff that only applies to certain classes of machines, and very specific stuff that's meant for a few nodes at most. 

So... you _could_ just paste in all your more general code as boilerplate atop your more specific code. There are ways to do that and get away with it. But that's the road down into the valley of the 4,000-line manifest. Better to separate your code out into meaningful units and then call those units by name as needed. 

Thus, resource collections and modules! In a few minutes, you'll be able to maintain your manifest code in one place and declare whole groups of it like this: 

    class {'security_base': }
    class {'webserver_base': }
    class {'appserver': }

And after that, it'll get even better. But first things first.

Classes
-------

Classes are singleton collections of resources that Puppet can apply as a unit. You can think of them as blocks of code that can be turned on or off.

If you know any object-oriented programming, try to ignore it for a little while, because that's not the kind of class we're talking about. Puppet classes could also be called "roles" or "aspects;" they describe one part of what makes up a system's identity.

### Defining

Before you can use a class, you have to **define** it, which is done with the `class` keyword, a name, and a block of code: 

    class someclass { 
      ... 
    }

Well, hey: you have a block of code hanging around from last chapter's exercises, right? May as well just wrap _that_ in a class definition!

{% highlight ruby %}
    # ntp-class1.pp
    
    class ntp {
      case $operatingsystem {
        centos, redhat: { 
          $service_name = 'ntpd'
          $conf_file = 'ntp.conf.el'
        }
        debian, ubuntu: { 
          $service_name = 'ntp'
          $conf_file = 'ntp.conf.debian'
        }
      }
      
      package { 'ntp':
        ensure => installed,
      }
      
      service { 'ntp':
        name => $service_name,
        ensure => running,
        enable => true,
        subscribe => File['ntp.conf'],
      }
      
      file { 'ntp.conf':
        path => '/etc/ntp.conf',
        ensure => file,
        require => Package['ntp'],
        source => "/root/learning-manifests/${conf_file}",
      }
    }
{% endhighlight %}

Go ahead and apply that. In the meantime:

#### An Aside: Names, Namespaces, and Scope

Class names have to start with a lowercase letter, and can contain lowercase alphanumeric characters and underscores. (Just your standard slightly conservative set of allowed characters.)

Class names can also use a double colon (`::`) as a namespace separator. (Yes, this should [look familiar](http://localhost:9292/learning/variables.html#variables).) This is a good way to show which classes are related to each other; for example, you can tell right away that something's going on between `apache::ssl` and `apache::vhost`. This will become more important about [two feet south of here][manifestsdir]. 

Also, class definitions introduce new variable scopes. That means any variables you assign within won't be accessible by their short names outside the class; to get at them from elsewhere, you would have to use the fully-qualified name (e.g. `$apache::ssl::certificate_expiration`). It also means you can localize --- mask --- variable short names in use outside the class; if you assign a `$fqdn` variable in a class, you would get the new value instead of the value of the Facter-supplied variable, unless you used the fully-qualified fact name (`$::fqdn`). 

### Declaring

Okay, back to our example, which you'll have noticed by now doesn't actually _do_ anything.

    # puppet apply ntp-class1.pp
    (...silence)

The code inside the class was properly parsed, but the compiler didn't build any of it into the catalog, so none of the resources got synced. For that to happen, the class has to be declared.

You actually already know the syntax to do that. A class definition just enables a unique instance of the `class` resource type, so you can declare it like any other resource:

{% highlight ruby %}
    # ntp-class1.pp
    
    class ntp {
      case $operatingsystem {
        centos, redhat: { 
          $service_name = 'ntpd'
          $conf_file = 'ntp.conf.el'
        }
        debian, ubuntu: { 
          $service_name = 'ntp'
          $conf_file = 'ntp.conf.debian'
        }
      }
      
      package { 'ntp':
        ensure => installed,
      }
      
      service { 'ntp':
        name => $service_name,
        ensure => running,
        enable => true,
        subscribe => File['ntp.conf'],
      }
      
      file { 'ntp.conf':
        path => '/etc/ntp.conf',
        ensure => file,
        require => Package['ntp'],
        source => "/root/learning-manifests/${conf_file}",
      }
    }
    
    # Then, declare it:
    class {'ntp': }
{% endhighlight %}

This time, all those resources will end up in the catalog:

    # puppet apply --verbose ntp-class1.pp

    info: Applying configuration version '1305066883'
    info: FileBucket adding /etc/ntp.conf as {md5}5baec8bdbf90f877a05f88ba99e63685
    info: /Stage[main]/Ntp/File[ntp.conf]: Filebucketed /etc/ntp.conf to puppet with sum 5baec8bdbf90f877a05f88ba99e63685
    notice: /Stage[main]/Ntp/File[ntp.conf]/content: content changed '{md5}5baec8bdbf90f877a05f88ba99e63685' to '{md5}dc20e83b436a358997041a4d8282c1b8'
    info: /Stage[main]/Ntp/File[ntp.conf]: Scheduling refresh of Service[ntp]
    notice: /Stage[main]/Ntp/Service[ntp]/ensure: ensure changed 'stopped' to 'running'
    notice: /Stage[main]/Ntp/Service[ntp]: Triggered 'refresh' from 1 events

Defining the class makes it available; declaring activates it.

#### Include

There's another way to declare classes, but it behaves a little bit differently:

    include ntp
    include ntp
    include ntp

The `include` function will declare a class if it hasn't already been declared, and will do nothing if it has. This means you can safely use it multiple times, whereas the resource syntax can only be used once. The drawback is that `include` can't currently be used with parameterized classes, on which more later.

So which should you choose? Neither, yet: learn to use both, and decide later, after we've covered site design and parameterized classes.

### Classes In Situ

You've probably already guessed that classes aren't enough: even with the code above, you'd still have to paste the `ntp` definition into all your other manifests. So it's time to meet the **module autoloader!**

#### An Aside: Printing Config

But first, we'll need to meet its friend, the `modulepath`.

    # puppet apply --configprint modulepath
    /etc/puppetlabs/puppet/modules

By the way, `--configprint` is basically my favorite. Puppet has a _lot_ of config options, all of which have default values and site-specific overrides in puppet.conf, and trying to memorize them all is a pain. You can use `--configprint` on  most of the Puppet tools, and they'll print a value (or a bunch, if you use `--configprint all`) and exit.

Modules
-------

So anyway, modules are re-usable bundles of code and data. Puppet autoloads manifests from the modules in its `modulepath`, which means you can declare a class stored in a module from anywhere. Let's just convert that last class to a module immediately, so you can see what I'm talking about:

    # cd /etc/puppetlabs/puppet/modules
    # mkdir ntp; cd ntp; mkdir manifests; cd manifests
    # vim init.pp

{% highlight ruby %}
    # init.pp
    
    class ntp {
      case $operatingsystem {
        centos, redhat: { 
          $service_name = 'ntpd'
          $conf_file = 'ntp.conf.el'
        }
        debian, ubuntu: { 
          $service_name = 'ntp'
          $conf_file = 'ntp.conf.debian'
        }
      }
      
      package { 'ntp':
        ensure => installed,
      }
      
      service { 'ntp':
        name => $service_name,
        ensure => running,
        enable => true,
        subscribe => File['ntp.conf'],
      }
      
      file { '/etc/ntp.conf':
        ensure => file,
        require => Package['ntp'],
        source => "/root/learning-manifests/${conf_file}",
      }
    }
    
    # (Remember not to declare the class yet.)
{% endhighlight %}

And now, the reveal:[^dashe]

    # cd ~
    # puppet apply -e "include ntp"

It just works. You can now do that from any manifest, without having to cut and paste anything. 

But we're not quite done yet. See how the manifest is referring to some files stored outside the module? Let's fix that:

    # mkdir /etc/puppetlabs/modules/ntp/files
    # mv /root/learning-manifests/ntp.conf.* /etc/puppetlabs/modules/ntp/files/
    # vim /etc/puppetlabs/modules/ntp/manifests/init.pp

{% highlight ruby %}
    # ...
      file { '/etc/ntp.conf':
        ensure => file,
        require => Package['ntp'],
        # source => "/root/learning-manifests/${conf_file}",
        source => "puppet:///modules/ntp/${conf_file}",
      }
    }
{% endhighlight %}

There --- our little example from last chapter has grown up into a self-contained blob of awesome.

[^dashe]: The `-e` flag lets you give puppet apply a line of manifest code instead of a file, same as with Perl or Ruby.

Module Structure
----------------

A module is just a directory with stuff in it, and the magic comes from putting that stuff where Puppet expects to find it. Which is to say, arranging the contents like this:

* {module}/
    * files/
    * lib/
    * manifests/
        * init.pp
        * {class}.pp
        * {defined type}.pp
        * {namespace}/
            * {class}.pp
            * {class}.pp
    * templates/
    * tests/

The main directory should be named after the module. All of the manifests go in the `manifests` directory. Each manifest contains only one class (or defined type). There's a special manifest called `init.pp` that holds the module's main class, which should have the same name as the module. That's your barest-bones module: main folder, manifests folder, init.pp, just like we used in the ntp module above. 

But if that was all a module was, it'd make more sense to just load your classes from one flat folder. Modules really come into their own with namespacing and grouping of classes. 

### Manifests, Namespacing, and Autoloading

The manifests directory can hold any number of other classes and even folders of classes, and Puppet uses [namespacing](#an-aside-names-and-namespaces) to find them. Say we have a manifests folder that looks like this: 

* foo/
    * manifests/
        * init.pp
        * bar.pp
        * bar/
            * baz.pp

The init.pp file should contain `class foo { ... }`, bar.pp should contain `class foo::bar { ... }`, and baz.pp should contain `class foo::bar::baz { ... }`. 

This can be a little disorienting at first, but I promise you'll get used to it. Basically, init.pp is special, and all of the other classes (each in its own manifest) should be under the main class's namespace. If you add more levels of directory hierarchy, they get interpreted as more levels of namespace hierarchy. 

### Files

Puppet can serve files from modules, and it works identically regardless of whether you're doing serverless or agent/master Puppet. Everything in the `files` directory in the ntp module is available under the `puppet:///modules/ntp/` URL. Likewise, a `test.txt` file in the `testing` module's `files` could be retrieved as `puppet:///modules/testing/test.txt`. 

### Tests

Once you start writing modules you plan to keep for more than a day or two, read our brief guide to [module smoke testing][smoke]. It's pretty simple, and will eventually pay off. 

### Templates

More on [templates](http://docs.puppetlabs.com/guides/templating.html) later.

### Lib

Puppet modules can also serve executable Ruby code from their `lib` directories, to extend Puppet and Facter. (Remember how I mentioned extending Facter with custom facts? This is where they live.) It'll be a while before we cover any of that.

### Module Scaffolding

Since you'll be dealing with those same five subdirectories so much, I suggest adding a function for them to your .bashrc file. 

    mkmod() {
        mkdir "$1"
        mkdir "$1/files" "$1/lib" "$1/manifests" "$1/templates" "$1/tests"
    }

Exercises
---------

> **Exercise:** Build an Apache2 module and class, which ensures Apache is installed and running and manages its config file. While you're at it, make Puppet manage the DocumentRoot and put a custom 404 page and index.html in place. 
> 
> Set any files or package/service names that might vary per distro conditionally, failing if we're not on CentOS; this'll let you cleanly shim in support for other distros once you need it.
> 
> We'll be using this module some more in future lessons. Oh yes.

Next
----

And we've reached another brief pause! There's some fun stuff ahead: come back next update, where we'll cover defined resource types, classes with parameters in 'em, and possibly inheritance, templates, functions, and/or resource defaults.