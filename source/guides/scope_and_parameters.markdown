---
layout: default
title: Scope and Parameters
---

From Dynamic Scope to Parameterized Classes
===========================================

Puppet 2.7 now issues deprecation warnings for dynamic variable lookup and dynamic propagation of resource defaults. Find out why, and learn how to adapt your Puppet code for the future!

* * * 

What's Changing?
----------------

Dynamic scope will be removed from the Puppet language in a future version. **This will be a major and backwards-incompatible change.** Currently, if a variable isn't defined in the local scope, Puppet looks it up along a chain of parent scopes, eventually ending at top scope; resource defaults (`File{ owner => root, }`, e.g.) travel in much the same way. In Puppet 2.8, Puppet will only examine the local scope and top scope when resolving a variable or a resource default; intervening scopes will be ignored. **In effect, all variables will be either strictly local or strictly global.** The one exception will be derived classes, which will continue to consult the scope of the base class they inherit from. 

To ease the transition, Puppet 2.7 issues deprecation warnings whenever dynamic variable lookup occurs. You should strongly consider refactoring your code to eliminate these warnings. 

Why?
----

Puppet's dynamic variable lookup has been used mainly for passing parameters into classes. It's not a very good tool for that job! If you are reading this, there's a good chance you've already learned that from personal experience. It can cause confusing action at a distance, it interacts really badly with class inheritance, and it makes the boundaries between classes a lot more porous than good programming practice demands. 

Since the introduction of parameterized classes in Puppet 2.6, the language has had a clean and unambiguous way to pass parameters, and the drawbacks of dynamic lookup are severe enough to justify abandoning it as soon as possible. 


Eliminating Dynamic Lookup in Your Manifests
--------------------------------------------

### Resource Defaults: Be Explicit

If you're using dynamic scope to propagate resource defaults, there's no way around it: you're going to have to move them to global scope or repeat yourself in each file that the defaults apply to. 

But this is not a bad thing! Resource defaults are essentially code compression, and are designed to make a single file of Puppet code more concise. Concision always has to be balanced with knowability, though, and the action at a distance that resource defaults can currently exhibit is often spooky, confusing, and infuriating to anyone trying to figure out the code more than a month after it was written. Restricting defaults to local scope or global scope makes their behavior more legible and more predictable.

It's honestly more likely that defaults have been propagating through scopes without your knowing, and the eventual elimination of dynamic scope will just make them act like you thought they were acting. 

### Variables: Use Parameterized Classes

If you're using dynamically scoped variables to change the behavior of a class when it's declared, you should almost always use a parameterized class instead.

If you've been writing Puppet code for a while, the first thing to do is adjust the way you think about module design: instead of thinking about setting variables and getting scope to act right, start thinking in terms of passing information to the class. Instead of making the class do its own research, supply it with a full dossier. The perceptual shift sounds a bit cheesy, but it'll make the entire project a lot easier. 

#### Writing a Parameterized Class

Parameterized classes are declared just like classical classes, but with a list of parameters (in parentheses) between the class name and the opening bracket: 

{% highlight ruby %}
    class webserver( $vhost_dir, $packages ) {
      ...
    }
{% endhighlight %}

The parameters you name can be used as normal local variables throughout the class definition. In fact, the first step in converting a class to use parameters is to just locate all the variables you're expecting to find in an outer scope and call them out as parameters --- you won't have to change how they're used inside the class at all. 

{% highlight ruby %}
    class webserver( $vhost_dir, $packages ) {
      packages { $packages: ensure => present }
     
      file { 'vhost_dir'
        path   => $vhost_dir,
        ensure => directory,
        mode   => '0750',
        owner  => 'www-data',
        group  => 'root',
      }
    }
{% endhighlight %}

You can also give default values for any parameter in the list:

{% highlight ruby %}
    class webserver( $vhost_dir = '/etc/httpd/conf.d', $packages = 'httpd' ) {
      ...
    }
{% endhighlight %}

Any parameter with a default value can be safely omitted when declaring the class. 

#### Declaring a Parameterized Class

This can be easy to forget when using the shorthand `include` function, but class instances are just resources. Since `include` wasn't designed for use with parameterized classes, you have to declare them like a normal resource: type, name, and attributes, in their normal order. The parameters you named when defining the class become the attributes you use when declaring it:

{% highlight ruby %}
    class {'webserver':
      packages => 'apache2',
      vhost_dir => '/etc/apache2/sites-enabled',
    }
{% endhighlight %}

Or, if declaring with all default values:

{% highlight ruby %}
    class {'webserver': }
{% endhighlight %}

As of Puppet 2.6.5, parameterized classes can be declared by external node classifiers; see the [ENC documentation](./external_nodes.html) for details. 

#### Site Design and Composition With Parameterized Classes

Once your classes are converted to use parameters, there's some work remaining to make sure your classes can work well together. 

A common pattern with standard classes is to `include` any other classes that the class requires. Since `include` ensures a class is declared without redeclaring it, this has been a convenient way to satisfy dependencies. This won't work well with parameterized classes, though, for the reasons we've mentioned above.

Instead, you should explicitly state your class's dependencies inside its definition using the relationship chaining syntax:

{% highlight ruby %}
    class webserver( $vhost_dir, $packages ) {
      ...
      # Make sure our ports are configured correctly:
      Class['iptables::webserver'] -> Class['webserver']
    }
{% endhighlight %}

Instead of implicitly declaring the required class, this will make sure that the catalog throws an error if it's absent. From one perspective, this is less convenient; from another, it's less magical and more knowable. We're working on a safe way to implicitly declare parameterized classes, but the design work isn't finished at the time of this writing.

Once you've stated your class's dependencies, you'll need to declare the required classes when composing your node or wrapper class:

{% highlight ruby %}
    class tacoma_webguide_application_server {
      class {'webserver': 
        packages => 'apache2',
        vhost_dir => '/etc/apache2/sites-enabled',
      }
      class {'iptables::webserver':}
    }
{% endhighlight %}

The general rule of thumb here is that you should only be declaring other classes in your outermost node or class definitions. 


Appendix A: Smart Parameter Defaults
------------------------------------

This design pattern can make for significantly cleaner code while enabling some really sophisticated behavior around default values.

{% highlight ruby %}
    # /etc/modules/webserver/manifests/params.pp
    
    class webserver::params {
     $packages = $operatingsystem ? {
       /(?i-mx:ubuntu|debian)/        => 'apache2',
       /(?i-mx:centos|fedora|redhat)/ => 'httpd',
     }
     $vhost_dir = $operatingsystem ? {
       /(?i-mx:ubuntu|debian)/        => '/etc/apache2/sites-enabled',
       /(?i-mx:centos|fedora|redhat)/ => '/etc/httpd/conf.d',
     }
    }
    
    # /etc/modules/webserver/manifests/init.pp
    
    class webserver(
     $packages  = $webserver::params::packages,
     $vhost_dir = $webserver::params::vhost_dir
    ) inherits $webserver::params {
    
     packages { $packages: ensure => present }
    
     file { 'vhost_dir'
       path   => $vhost_dir,
       ensure => directory,
       mode   => '0750',
       owner  => 'www-data',
       group  => 'root',
     }
    }
{% endhighlight %}

To summarize what's happening here: When a class inherits from another class, it implicitly declares the base class. Since the base class's local scope already exists before the new class's parameters get declared, those parameters can be set based on information in the base class. 

This is functionally equivalent to doing the following:

{% highlight ruby %}
    # /etc/modules/webserver/manifests/init.pp
    
    class webserver( $packages = 'UNSET', $vhost_dir = 'UNSET' ) {
     
     if $packages == 'UNSET' {
       $packages = $operatingsystem ? {
         /(?i-mx:ubuntu|debian)/        => 'apache2',
         /(?i-mx:centos|fedora|redhat)/ => 'httpd',
       }
     }
     if $vhost_dir == 'UNSET' {
       $vhost_dir = $operatingsystem ? {
         /(?i-mx:ubuntu|debian)/        => '/etc/apache2/sites-enabled',
         /(?i-mx:centos|fedora|redhat)/ => '/etc/httpd/conf.d',
       }
     }
     
     packages { $packages: ensure => present }
    
     file { 'vhost_dir'
       path   => $vhost_dir,
       ensure => directory,
       mode   => '0750',
       owner  => 'www-data',
       group  => 'root',
     }
    }
{% endhighlight %}

... but it's a significant readability win, especially if the amount of logic or the number of parameters gets any higher than what's shown in the example.

Appendix B: How Scope Works in Puppet ≤ 2.7.x
---------------------------------------------

(An aside before I start: nodes defined in the Puppet DSL function identically to classes.) 

* Classes, nodes, and instances of defined types introduce new scopes. 
* When you declare a variable in a scope, it is local to that scope.
* Every scope has one and only one "parent scope."
    * If it's a class that inherits from a base class, its parent scope is the base class.
    * Otherwise, its parent scope is the FIRST scope where that class was declared. (If you are declaring classes in multiple places with `include`, this can be unpredictable. Furthermore, declaring a derived class will implicitly declare the base class in that same scope.)
* If you try to resolve a variable that doesn't exist in the current local scope, lookup proceeds through the chain of parent scopes -- its parent, the parent's parent, and so on, stopping at the first place it finds that variable. 

These rules seem simple enough, so an example is in order:

    # manifests/site.pp
    $nodetype = "base"
    
    node "base" {
        include postfix
        ...snip...
    
    }
    
    node "www01", "www02", ... , "www10" inherits "base" {
         $nodetype = "wwwnode"
         include postfix::custom
    
    }
    
    # modules/postfix/manifests/init.pp
    class postfix {
         package {"postfix": ensure => installed}
         file {"/etc/postfix/main.cf":
              content => template("puppet:///files/main.cf.erb")
         }
    
    }
    
    # modules/postfix/manifests/custom.pp
    class postfix::custom inherits postfix {
         File ["/etc/postfix/main.cf"] {
              content => undef,
              source => ["puppet:///files/$hostname/main.cf",
                               "puppet:///files/$nodetype/main.cf" ]
         }
    
    } 

When nodes www01 through www10 connect to the puppet master, `$nodetype` will always be set to "base" and main.cf will always be served from files/base/. This is because `postfix::custom`'s chain of parent scopes is `postfix::custom < postfix < base < top scope`; the combination of inheritance and dynamic scope causes lookup of the `$nodetype` variable to bypass `node 01-10` entirely. 

Thanks to Ben Beuchler for contributing this example.
