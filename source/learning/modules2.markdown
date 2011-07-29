---
layout: default
title: Learning — Modules 2
---

Learning — Modules, Classes, and Defined Types (Part Two)
=========================================

Now that you have basic classes and modules under control, it's time for some more advanced code re-use. 

* * *

&larr; [Templates](./templates.html) --- [Index](./) --- TBA &rarr;

* * * 

Investigators
-------------

Most classes have to do slightly different things on different systems. You already know some ways to do that --- all of the modules you've written so far have switched their behaviors by looking up system facts. Let's say that they "investigate:" they expect some information to be in a specific place (in the case of facts, a top-scope variable), and go looking for it when they need it. 

But this isn't always the best way to do it, and it starts to break down once you need to switch a module's behavior on information that doesn't map cleanly to system facts. Is this a database server? A local NTP server? 

You could still have your modules investigate; instead of looking at the standard set of system facts, you could just point them to an arbitrary variable and make sure it's filled if you plan on using that class.[^olderversions] But it might be better to just tell the class what it needs to know when you declare it. 

[^olderversions]: This was the only way to do things in older versions of Puppet, and later I'll go into more detail about how to do this sanely.

Passing Parameters
------------------

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
{% endhighlight %}

    # puppet apply -e "class {'paramclassexample': value1 => 'Something', value2 => 'Something else',}"
    notice: Value 2 is Something else.
    notice: /Stage[main]/Paramclassexample/Notify[Value 2 is Something else.]/message: defined 'message' as 'Value 2 is Something else.'
    notice: Value 1 is Something.
    notice: /Stage[main]/Paramclassexample/Notify[Value 1 is Something.]/message: defined 'message' as 'Value 1 is Something.'
    notice: Finished catalog run in 0.05 seconds
    
    # puppet apply -e "class {'paramclassexample': value1 => 'Something',}"notice: Value 1 is Something.
    notice: /Stage[main]/Paramclassexample/Notify[Value 1 is Something.]/message: defined 'message' as 'Value 1 is Something.'
    notice: Value 2 is Default value.
    notice: /Stage[main]/Paramclassexample/Notify[Value 2 is Default value.]/message: defined 'message' as 'Value 2 is Default value.'
    notice: Finished catalog run in 0.05 seconds

(As shown above, you can give any parameter a default value, which makes it optional when you declare the class. Parameters without defaults are required.)

So what's the benefit of all this? In a word, it **[encapsulates][]** the class. You don't have to pick unique magic variable names to use as a dead drop, and it makes the behaviors that can vary much more legible at a glance.

But! This is probably going to be more clear with a more legit example. 

[encapsulates]: http://en.wikipedia.org/wiki/Information_hiding#Encapsulation

Example: NTP (Again)
--------------------

So let's get back to our NTP module. The first thing we talked about wanting to vary was the set of servers, and we already did the heavy lifting back in the [templates](./templates.html) chapter, so that's the place to start: 

{% highlight ruby %}
    class ntp ($servers = undef) {
      ...
{% endhighlight %}

And... that's all it takes, actually. This will work. If you declare the class with no attributes...

{% highlight ruby %}
    class {'ntp':}
{% endhighlight %}

...it'll work the same way it used to. If you declare it with a `server` attribute containing an array of servers (with or without appended `iburst` and `dynamic` statements)...

{% highlight ruby %}
    class {'ntp':
      servers => [ "ntp1.puppetlabs.lan dynamic", "ntp2.puppetlabs.lan dynamic", ],
    }
{% endhighlight %}

...it'll override the servers in the `ntp.conf` file. Nice. There _is_ a bit of trickery to notice: setting a variable or parameter to `undef` might seem odd, and we're only doing it because we want to be able to get the default servers without asking for them. (Remember, parameters can't be optional without an explicit default value.) Also, remember the business with the `$servers_real` variable? That was because the Puppet language won't let you re-assign a variable within a given scope. Since `$servers` is always going to be assigned before we can do anything in the class, we have to make a copy of it if we want to smartly handle default values like this.

What else could we make into a parameter? Well, let's say you have a mixed environment of physical and virtual machines, and some of them occasionally make the transition between VM and metal. Since NTP behaves weirdly under virtualization, you'd want it turned off on your virtual machines --- and you would have to manage it as a service resource to do that, because if you just didn't say anything about NTP (by not declaring the class, e.g.), it might actually still be running. So you could make an `ntp_disabled` class and declare that whenever you aren't declaring the `ntp` class... but it makes more sense to expose the service's attributes as class parameters. That way, when you move a formerly physical server into the cloud, you could just change its manifests to declare the class like this:

{% highlight ruby %}
    class {'ntp':
      ensure => stopped,
      enable => false,
    }
{% endhighlight %}

And you've probably already guessed how easy that is. Here's the complete class, with all of our modifications thus far: <!-- TODO: add puppetdoc to this. -->

{% highlight ruby %}
    #/etc/puppetlabs/puppet/modules/ntp/manifests/init.pp
    class ntp ($servers = undef, $enable = true, $ensure = running) {
      case $operatingsystem {
        centos, redhat: { 
          $service_name  = 'ntpd'
          $conf_template = 'ntp.conf.el.erb'
          $default_servers = [ "0.centos.pool.ntp.org",
                               "1.centos.pool.ntp.org",
                               "2.centos.pool.ntp.org", ]
        }
        debian, ubuntu: { 
          $service_name  = 'ntp'
          $conf_template = 'ntp.conf.debian.erb'
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

Is there anything else we could do to this class? Well, yes: its behavior under anything but Debian, Ubuntu, CentOS, or RHEL is currently undefined, so it'd be nice to either fail gracefully or come up with some config templates we wouldn't mind being used under OS X or a BSD. And it might make sense to unify our two current templates; they're just based on the system defaults, and once you decide how NTP should be configured at your site, chances are it's going to look similar on any Linux. But as it stands, the module is pretty serviceable. 
