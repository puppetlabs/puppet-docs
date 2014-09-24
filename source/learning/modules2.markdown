---
layout: default
title: Learning Puppet — Class Parameters
---


Begin
-----

{% highlight ruby %}
    class echo_class ($to_echo = "default value") {
      notify {"What are we echoing? ${to_echo}.":}
    }

    class {'echo_class':
      to_echo => 'Custom value',
    }
{% endhighlight %}

There's something different about that variable.

Investigating vs. Asking For Help
-------------

Most classes have to do slightly different things on different systems. You already know some ways to do that --- all of the modules you've written so far have switched their behaviors by looking up system facts. Let's say that they "investigate:" they expect some information to be in a specific place (in the case of facts, a top-scope variable), and go looking for it when they need it.

But this isn't always the best way to do it, and it starts to break down once you need to switch a module's behavior on information that doesn't map cleanly to system facts. Is this a database server? A local NTP server? A test node? A production node? These aren't necessarily facts; usually, they're decisions made by a human.

In these cases, it's often best to just _configure_ the class, and tell it what it needs to know when you declare it. To enable this, classes need some way to ask for information from the outside world.


Class Parameters
----------

When defining a class, you can give it a list of **parameters.** Parameters go in an optional set of parentheses, between the name and the first curly brace. Each parameter is a variable name, and can have an optional default value; each parameter is separated from the next with a comma.

{% highlight ruby %}
    class mysql ($user = 'mysql', $port = 3306) {
      ...
    }
{% endhighlight %}

This is a doorway for passing information into the class:

{% highlight ruby %}
    class {'mysql':
      user => mysqlserver,
    }
{% endhighlight %}

* If you declare the class with a [resource-like class declaration](./modules1.html#resource-like-class-declarations), the parameters are available as **resource attributes.**
* If you declare the class with `include` (or leave out some parameters when using a resource-like declaration), Puppet will [automatically look up values][autolookup] for the parameters in your Hiera data.
* Inside the definition of the class, they appear as **local variables.**


### Default Values

When defining the class, you can give any parameter a default value. This makes it optional when you declare the class; if you don't specify a value, it will use the default. Parameters without defaults become mandatory when declaring the class.

### The Deal With Resource-Like Class Declarations

#### In Puppet Enterprise 2.x

[resource_like]: /puppet/latest/reference/lang_classes.html#using-resource-like-declarations

In Puppet 2.7, which is used in the Puppet Enterprise 2.x series, you must use [resource-like class declarations][resource_like] if you want to specify class parameters; you cannot specify parameters with `include` or in the PE console. If every parameter has a default and you don't need to override any of them, you can declare the class with `include`; otherwise, you must use resource-like class declarations.

Resource-like declarations don't play nicely with `include`, and if you're using them, you need to organize your manifests so that they never attempt to declare a class more than once. This has traditionally been a pain, but class parameters are still superior to older ways of configuring classes, and the best practices developed over the course of the Puppet 2.7 series have made them much easier to deal with.

The best way to deal with class parameters in the Puppet Enterprise 2.x series is to create "role" and "profile" modules that combine your functional classes into more complete node descriptions. Once you find yourself managing multiple nodes with Puppet, you should [read Craig Dunn's "Roles and Profiles" essay][craigdunn_roles_profiles], which matches the best practices used by Puppet Labs's services engineers.

To make your roles and profiles more flexible and avoid repeating yourself, you can also install and configure [Hiera][] on your puppet master and specify [Hiera lookup functions][hiera_functions] as the values of class parameters.

[craigdunn_roles_profiles]: http://www.craigdunn.org/2012/05/239/

#### In Puppet Enterprise 3.x

In Puppet 3 and later, which are used in the Puppet Enterprise 3.x series, Puppet will automatically look up any unspecified class parameters in your [Hiera][] data. This means you can safely use `include` and the PE console with _any_ class (including those with mandatory no-default parameters), as long as you specify parameter values in your Hiera data.

Once you find yourself managing multiple nodes with Puppet, you should [read the section of the Hiera manual about automatic parameter lookup][autolookup]. Also, the [roles and profiles pattern][craigdunn_roles_profiles] recommended for Puppet Enterprise 2.x users remains relevant in PE 3.x.

You can also now specify class parameters directly in the PE console. However, this works best when using a small number of classes across a small number of nodes; for medium and large deployments, we recommend a combination of Hiera auto-lookup and the roles and profiles pattern.

#### Why `include` Can't Directly Take Class Parameters

The problem is that classes are singletons, parameters configure the way they behave, and `include` can declare the same class more than once.

If you were to declare a class multiple times with different parameter values, which set of values should win? The question didn't seem to have a good answer. The [older method of using magic variables](#older-ways-to-configure-classes) actually had this same problem --- depending on parse order, there could be several different scope-chains that provided a given value, and the one you actually got would be effectively random. Icky.

The solution Puppet's designers settled on was that parameter values either had to be explicit and unconflicting (the restrictions on resource-like class declarations), or had to come from somewhere _outside_ Puppet and be already resolved by the time Puppet's parsing begins (Puppet 3's [automatic parameter lookup][autolookup]).

[hiera]: /hiera/1/
[hiera_functions]: /hiera/1/puppet.html#hiera-lookup-functions
[autolookup]: /hiera/1/puppet.html#automatic-parameter-lookup

### Older Ways to Configure Classes

Class parameters were added to Puppet in version 2.6.0, to address a need for a standard and visible way to configure clases.

Prior to that, people generally configured classes by choosing an arbitrary and unique external variable name and having the class retrieve that variable with [dynamically-scoped variable lookup](/guides/scope_and_puppet.html):

    $some_variable
    include some_class
    # This class will reach outside its own scope, and hope
    # it finds a value for $some_variable.

There were a few problems with this:

* Every class was competing for variable names in an effectively global name space. If you accidentally chose a non-unique name for your magic variables, something bad would happen.
* When writing modules to share with the world, you had to be very careful to document all of your magic variables; there wasn't a standard place a user could look to see what data a class needed.
* This inspired many many people to try and make intricate data hierarchies with node inheritance, which rarely worked and had a tendency to fail dramatically and confusingly.



Example: NTP (Again)
--------------------

So let's get back to our NTP module. The first thing we talked about wanting to configure was the set of servers, so that's a good place to start. First, add a parameter:

{% highlight ruby %}
    class ntp ($servers = undef) {
      ...
{% endhighlight %}

Next, we'll change how we set that `$_servers` variable that the template uses:

{% highlight ruby %}
      if $servers == undef {
        $_servers = $default_servers
      }
      else {
        $_servers = $servers
      }
{% endhighlight %}

If we specify an array of servers, use that; otherwise, use the defaults.

And... that's all it takes. If you declare the class with no attributes...

{% highlight ruby %}
    include ntp
{% endhighlight %}

...it'll work the same way it used to. If you declare it with a `servers` attribute containing an array of servers (with or without appended `iburst` and `dynamic` statements)...

{% highlight ruby %}
    class {'ntp':
      servers => [ "ntp1.example.com dynamic", "ntp2.example.com dynamic", ],
    }
{% endhighlight %}

...it'll override the default servers in the `ntp.conf` file.

There's a bit of trickery to notice: setting a variable or parameter to `undef` might seem odd, and we're only doing it because we want to be able to get the default servers without asking for them. (Remember, parameters can't be optional without an explicit default value.)

Also, remember the business with the `$_servers` variable? That was because the Puppet language won't let us re-assign the `$servers` variable within a given scope. If the default value we wanted was the same regardless of OS, we could just use it as the parameter default, but the extra logic to accomodate the per-OS defaults means we have to make a copy of the variable.

While we're in the NTP module, what else could we make into a parameter? Well, let's say you sometimes wanted to prevent the NTP daemon from being used as a server by other nodes. Or maybe you want to install and configure NTP, but not keep the daemon running. You could expose all of these as extra class parameters, and make changes in the manifest or the templates to use them.

All of these changes are based on decisions from the free puppetlabs/ntp module. [You can browse the source of this module][puppetlabs_ntp_source] and see how these extra parameters play out in the manifest and templates.

[puppetlabs_ntp_source]: https://github.com/puppetlabs/puppetlabs-ntp


Module Documentation
--------------------

You have a fairly functional NTP module, at this point. About the only thing it's missing is some documentation:

{% highlight ruby %}
    # = Class: ntp
    #
    # This class installs/configures/manages NTP. It can optionally disable NTP
    # on virtual machines. Only supported on Debian-derived and Red Hat-derived OSes.
    #
    # == Parameters:
    #
    # $servers:: An array of NTP servers, with or without +iburst+ and
    #            +dynamic+ statements appended. Defaults to the OS's defaults.
    # $enable::  Whether to start the NTP service on boot. Defaults to true. Valid
    #            values: true and false.
    # $ensure::  Whether to run the NTP service. Defaults to running. Valid values:
    #            running and stopped.
    #
    # == Requires:
    #
    # Nothing.
    #
    # == Sample Usage:
    #
    #   class {'ntp':
    #     servers => [ "ntp1.example.com dynamic",
    #                  "ntp2.example.com dynamic", ],
    #   }
    #   class {'ntp':
    #     enable => false,
    #     ensure => stopped,
    #   }
    #
    class ntp ($servers = undef, $enable = true, $ensure = running) {
      case $operatingsystem { ...
      ...
{% endhighlight %}

[rdoc]: http://docs.seattlerb.org/rdoc/RDoc/Markup.html

This doesn't have to be Tolstoy, but you should at least write down what the parameters are and what kind of data they take. Your future self will thank you. Also! If you write your documentation in [RDoc][] format and put it in a comment block butted up directly against the start of the class definition, you can automatically generate a browsable Rdoc-style site with info for all your modules. You can test it now, actually:

    # puppet doc --mode rdoc --outputdir ~/moduledocs --modulepath /etc/puppetlabs/puppet/modules

(Then just upload that `~/moduledocs` folder to some webspace you control, or grab it onto your desktop with SFTP.)


Next
----

**Next Lesson:**

Okay, we can pass parameters into classes now and change their behavior. Great! But classes are still always singletons; you can't declare more than one copy and get two different sets of behavior simultaneously. And you'll eventually want to do that! What if you had a collection of resources that created a virtual host definition for a web server, or cloned a Git repository, or managed a user account complete with group, SSH key, home directory contents, sudoers entry, and .bashrc/.vimrc/etc. files? What if you wanted more than one Git repo, user account, or vhost on a single machine?

Well, you'd [whip up a defined resource type](./definedtypes.html).

**Off-Road:**

You've seen how to configure classes in both your Hiera data and the PE console; why not grab a module and configure it for your own systems? [Download Puppet Enterprise for free][dl], follow [the quick start guide][quick] to get a small environment installed, install a module from the Puppet Forge ([maybe puppetlabs/ntp?](http://forge.puppetlabs.com/puppetlabs/ntp)), and assign it to a node in the console; don't forget to [add parameters][console_params].

[console_params]: /pe/latest/console_classes_groups.html#editing-class-parameters-on-nodes
[dl]: http://info.puppetlabs.com/download-pe.html
[quick]: /pe/latest/quick_start.html
