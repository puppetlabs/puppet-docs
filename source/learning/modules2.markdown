---
layout: legacy
title: Learning — Modules 2
---

Learning — Modules and (Parameterized) Classes (Part Two)
=========================================

Now that you have basic classes and modules under control, it's time for some more advanced code re-use. 

* * *

&larr; [Templates](./templates.html) --- [Index](./) --- [Defined Types](./definedtypes.html) &rarr;

* * * 

Investigating vs. Passing Data
-------------

Most classes have to do slightly different things on different systems. You already know some ways to do that --- all of the modules you've written so far have switched their behaviors by looking up system facts. Let's say that they "investigate:" they expect some information to be in a specific place (in the case of facts, a top-scope variable), and go looking for it when they need it. 

But this isn't always the best way to do it, and it starts to break down once you need to switch a module's behavior on information that doesn't map cleanly to system facts. Is this a database server? A local NTP server? 

You could still have your modules investigate; instead of looking at the standard set of system facts, you could just point them to an arbitrary variable and make sure it's filled if you plan on using that class. But it might be better to just tell the class what it needs to know when you declare it. 


Parameters
----------

When defining a class, you can give it a list of **parameters.** 

{% highlight ruby %}
    class mysql ($user, $port) { ... }
{% endhighlight %}

This is a doorway for passing information into the class. When you declare the class, those parameters appear as **resource attributes;** inside the definition, they appear as **local variables.**

{% highlight ruby %}
    # /etc/puppetlabs/puppet/modules/paramclassexample/manifests/init.pp
    class paramclassexample ($value1, $value2 = "Default value") {
      notify {"Value 1 is ${value1}.":}
      notify {"Value 2 is ${value2}.":}
    }
    
    # ~/learning-manifests/paramclass1.pp
    class {'paramclassexample':
      value1 => 'Something',
      value2 => 'Something else',
    }
    
    # ~/learning-manifests/paramclass2.pp
    class {'paramclassexample':
      value1 => 'Something',
    }
{% endhighlight %}

    # puppet apply ~/learning-manifests/paramclass1.pp
    notice: Value 2 is Something else.
    notice: /Stage[main]/Paramclassexample/Notify[Value 2 is Something else.]/message: defined 'message' as 'Value 2 is Something else.'
    notice: Value 1 is Something.
    notice: /Stage[main]/Paramclassexample/Notify[Value 1 is Something.]/message: defined 'message' as 'Value 1 is Something.'
    notice: Finished catalog run in 0.05 seconds
    
    # puppet apply ~/learning-manifests/paramclass2.pp
    notice: Value 1 is Something.
    notice: /Stage[main]/Paramclassexample/Notify[Value 1 is Something.]/message: defined 'message' as 'Value 1 is Something.'
    notice: Value 2 is Default value.
    notice: /Stage[main]/Paramclassexample/Notify[Value 2 is Default value.]/message: defined 'message' as 'Value 2 is Default value.'
    notice: Finished catalog run in 0.05 seconds

(As shown above, you can give any parameter a default value, which makes it optional when you declare the class. Parameters without defaults are required.)

So what's the benefit of all this? In a word, it [encapsulates][] the class. You don't have to pick unique magic variable names to use as a dead drop, and since anything affecting the function of the class has to pass through the parameters, it's much more clear _where_ the information is coming from. This pays off once you start having to think about how modules work with other modules, and it _really_ pays off if you want to download or create reusable modules. 

[encapsulates]: http://en.wikipedia.org/wiki/Information_hiding#Encapsulation

Example: NTP (Again)
--------------------

So let's get back to our NTP module. The first thing we talked about wanting to vary was the set of servers, and we already did the heavy lifting back in the [templates](./templates.html) chapter, so that's a good place to start: 

{% highlight ruby %}
    class ntp ($servers = undef) {
      ...
{% endhighlight %}

And... that's all it takes, actually. This will work. If you declare the class with no attributes...

{% highlight ruby %}
    class {'ntp':}
{% endhighlight %}

...it'll work the same way it used to. If you declare it with a `servers` attribute containing an array of servers (with or without appended `iburst` and `dynamic` statements)...

{% highlight ruby %}
    class {'ntp':
      servers => [ "ntp1.example.com dynamic", "ntp2.example.com dynamic", ],
    }
{% endhighlight %}

...it'll override the servers in the `ntp.conf` file. Nice.

There _is_ a bit of trickery to notice: setting a variable or parameter to `undef` might seem odd, and we're only doing it because we want to be able to get the default servers without asking for them. (Remember, parameters can't be optional without an explicit default value.) 

Also, remember the business with the `$servers_real` variable? That was because the Puppet language won't let us re-assign the `$servers` variable within a given scope. If the default value we wanted was the same regardless of OS, we could just use it as the parameter default, but the extra logic to accomodate the per-OS defaults means we have to make a copy.

While we're in the NTP module, what else could we make into a parameter? Well, let's say you have a mixed environment of physical and virtual machines, and some of them occasionally make the transition between VM and metal. Since NTP behaves weirdly under virtualization, you'd want it turned off on your virtual machines --- and you would have to manage the service as a resource to do that, because if you just didn't say anything about NTP (by not declaring the class, e.g.), it might actually still be running. So you could make a separate `ntp_disabled` class and declare it whenever you aren't declaring the `ntp` class... but it makes more sense to expose the service's attributes as class parameters. That way, when you move a formerly physical server into the cloud, you could just change that part of its manifests from this:

{% highlight ruby %}
    class {'ntp':}
{% endhighlight %}

...to this:

{% highlight ruby %}
    class {'ntp':
      ensure => stopped,
      enable => false,
    }
{% endhighlight %}

And making that work right is almost as easy as the last edit. Here's the complete class, with all of our modifications thus far: 

{% highlight ruby %}
    #/etc/puppetlabs/puppet/modules/ntp/manifests/init.pp
    class ntp ($servers = undef, $enable = true, $ensure = running) {
      case $operatingsystem {
        centos, redhat: { 
          $service_name    = 'ntpd'
          $conf_template   = 'ntp.conf.el.erb'
          $default_servers = [ "0.centos.pool.ntp.org",
                               "1.centos.pool.ntp.org",
                               "2.centos.pool.ntp.org", ]
        }
        debian, ubuntu: { 
          $service_name    = 'ntp'
          $conf_template   = 'ntp.conf.debian.erb'
          $default_servers = [ "0.debian.pool.ntp.org iburst",
                               "1.debian.pool.ntp.org iburst",
                               "2.debian.pool.ntp.org iburst",
                               "3.debian.pool.ntp.org iburst", ]
        }
      }
      
      if $servers == undef {
        $servers_real = $default_servers
      }
      else {
        $servers_real = $servers
      }
      
      package { 'ntp':
        ensure => installed,
      }
      
      service { 'ntp':
        name      => $service_name,
        ensure    => $ensure,
        enable    => $enable,
        subscribe => File['ntp.conf'],
      }
      
      file { 'ntp.conf':
        path    => '/etc/ntp.conf',
        ensure  => file,
        require => Package['ntp'],
        content => template("ntp/${conf_template}"),
      }
    }
{% endhighlight %}

Is there anything else we could do to this class? Well, yes: its behavior under anything but Debian, Ubuntu, CentOS, or RHEL is currently undefined, so it'd be nice to, say, come up with some config templates to use under the BSDs and OS X and then fail gracefully on unrecognized OSes. And it might make sense to unify our two current templates; they were just based on the system defaults, and once you decide how NTP should be configured at your site, chances are it's going to look similar on any Unix. This could also let you simplify the default value and get rid of that `undef` and `$servers_real` dance. But as it stands, this module is pretty serviceable. 

So hey, let's throw on some documentation and be done with it! 

Module Documentation
--------------------

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

[rdoc]: http://links.puppetlabs.com/rdoc_markup

This doesn't have to be Tolstoy, but seriously, at least write down what the parameters are and what kind of data they take. Your future self will thank you. Also! If you write your documentation in [RDoc][] format and put it in a comment block butted up directly against the start of the class definition, you can automatically generate a browsable Rdoc-style site with info for all your modules. You can test it now, actually: 

    # puppet doc --mode rdoc --outputdir ~/moduledocs --modulepath /etc/puppetlabs/puppet/modules

(Then just upload that `~/moduledocs` folder to some webspace you control, or grab it onto your desktop with SFTP.)

Some Important Notes From the Dep't of Foreshadowing
--------------------

Parameterized classes are still pretty new --- they were only added to Puppet in version 2.6.0 --- and they changed the landscape of Puppet in some ways that aren't immediately obvious. 

You probably noticed that the examples in this chapter are all using the [resource-like][resourcelike] declaration syntax instead of the [include][] function. That's because **include doesn't work**[^alldefault] with parameterized classes, and likely never will. The problem is that the whole point of `include` conflicts with the idea that a class can change depending on how it's declared --- if you declare a class multiple times and the attributes don't match precisely, which set of attributes wins? 

Parameterized classes made the problem with that paradigm more explicit, but it already existed, and it was possible to run afoul of it without even noticing. A common pattern for passing information into a class was to choose an external variable and have the class retrieve it with [dynamically-scoped variable lookup](/guides/scope_and_puppet.html).[^scope] If you were also having low-level classes manage their own dependencies by including anything they might need, then a given class might have several potential scope chains resolving to different values, which would result in a race --- whichever `include` took effect first would determine the behavior of the class. 

However, there were and are a couple of other ways to get data into a class --- let's lump them together and call them **data separation** --- and if you used them well, your classes could safely manage their own dependencies with include. Using parameterized classes gives you new options for site design that we've come to believe are just plain better, but it closes off that option of self-managed dependencies. 

I'm purposely getting ahead of myself a bit --- this isn't going to be fully relevant until we start talking about class composition and site design, and we'll be covering data separation later as well. But since all these issues stem from ideas about what a class is and where it gets its information, it seemed worthwhile to mention some of these issues now, just so they don't seem so out-of-the-blue later.

[^alldefault]: Yes, you can actually `include` a parameterized class if all of its parameters have defaults, but mixing and matching declaration styles for a class is not the best plan.
[^scope]: I haven't covered dynamic scope in Learning Puppet, both because it shouldn't be necessary for someone learning today and because its days are numbered.

[resourcelike]: http://docs.puppetlabs.com/learning/modules1.html#declaring
[include]: http://docs.puppetlabs.com/learning/modules1.html#include

Next
----

Okay, we can pass parameters into classes now and change their behavior. Great! But classes are still always singletons; you can't declare more than one copy and get two different sets of behavior simultaneously. And you'll eventually want to do that! What if you had a collection of resources that created a vhost definition for a web server, or cloned a Git repository, or managed a user account complete with group, SSH key, home directory contents, sudoers entry, and .bashrc/.vimrc/etc. files? What if you wanted more than one Git repo, user account, or vhost on a single machine?

Well, you'd [whip up a defined resource type](./definedtypes.html). 
