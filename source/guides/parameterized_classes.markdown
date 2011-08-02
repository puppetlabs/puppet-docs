---
layout: default
title: Using Parameterized Classes
---

Using Parameterized Classes
=====

Use parameterized classes to write more effective, versatile, and encapsulated code. 

* * * 

Why, and Some History
---------------------

Well-written and reusable classes often have to change their behavior based on where and how they're declared. However, due to the organic way the Puppet language grew, there was a long period where it didn't have a specific means to do this. 

Most Puppet coders solved this by using dynamic variable lookup to pass parameters into classes. By making the class's effects pivot on a handful of variables not defined in the class, you could later set those variables at node scope or in another class, then declare the class and assign its [parent scope][parent]; at that point, the class would go looking for the information it needed and react accordingly. 

[parent]: ./scope_and_puppet.html#appendix-how-scope-works-in-puppet--27x

This approach did the job and solved some really important problems, but it had major drawbacks: 

* **It basically exploded all variables into the global namespace.** Since classes had to look outside their own scope for parameters, parameters were effectively global. That meant you had to anticipate what every other module author was going to name their variables and try to guess something safe. 
* **Understanding how to declare a class was not exactly straightforward.** There was no built-in way to tell what parameters a class needed to have set, so you were on your own for documenting it and following the rules to the letter. Optional parameters in particular could bite you at exactly the wrong time. 
* **It was just plain confusing.** The rules for how a parent scope is assigned can fit on an index card, but they can interact in some extraordinarily hairy ways. ([ibid.][parent])

So to shorten a long story, Puppet 2.6 introduced a better and more direct way to pass parameters into a class.
 
Philosophy
----------

A class that depends on dynamic scope for its parameters has to do its own research. Instead, you should supply it with a full dossier when you declare it. Start thinking in terms of passing information to the class, instead of in terms of setting variables and getting scope to act right. 

Using Parameterized Classes
---------------------------

### Writing a Parameterized Class

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

### Declaring a Parameterized Class

This can be easy to forget when using the shorthand `include` function, but class instances are just resources. Since `include` wasn't designed for use with parameterized classes, you have to declare them like a normal resource: type, name, and attributes, in their normal order. The parameters you named when defining the class become the attributes you use when declaring it:

{% highlight ruby %}
    class {'webserver':
      packages  => 'apache2',
      vhost_dir => '/etc/apache2/sites-enabled',
    }
{% endhighlight %}

Or, if declaring with all default values:

{% highlight ruby %}
    class {'webserver': }
{% endhighlight %}

As of Puppet 2.6.5, parameterized classes can be declared by external node classifiers; see the [ENC documentation](./external_nodes.html) for details. 

### Site Design and Composition With Parameterized Classes

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

Instead of implicitly declaring the required class, this will make sure that compilation throws an error if it's absent. From one perspective, this is less convenient; from another, it's less magical and more knowable. For those who prefer implicit declaration, we're working on a safe way to implicitly declare parameterized classes, but the design work isn't finished at the time of this writing.

Once you've stated your class's dependencies, you'll need to declare the required classes when composing your node or wrapper class:

{% highlight ruby %}
    class tacoma_webguide_application_server {
      class {'webserver': 
        packages  => 'apache2',
        vhost_dir => '/etc/apache2/sites-enabled',
      }
      class {'iptables::webserver':}
    }
{% endhighlight %}

The general rule of thumb here is that you should only be declaring other classes in your outermost node or class definitions. 

Further Reading
---------------

For more information on modern Puppet class and module design, see the [Puppet Labs style guide](./style_guide.html). 

Appendix: Smart Parameter Defaults
------------------------------------

This design pattern can make for significantly cleaner code while enabling some really sophisticated behavior around default values.

{% highlight ruby %}
    # /etc/puppet/modules/webserver/manifests/params.pp
    
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
    
    # /etc/puppet/modules/webserver/manifests/init.pp
    
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
    # /etc/puppet/modules/webserver/manifests/init.pp
    
    class webserver( $packages = 'UNSET', $vhost_dir = 'UNSET' ) {
     
     if $packages == 'UNSET' {
       $real_packages = $operatingsystem ? {
         /(?i-mx:ubuntu|debian)/        => 'apache2',
         /(?i-mx:centos|fedora|redhat)/ => 'httpd',
       }
     }
     else {
        $real_packages = $packages
     }
     
     if $vhost_dir == 'UNSET' {
       $real_vhost_dir = $operatingsystem ? {
         /(?i-mx:ubuntu|debian)/        => '/etc/apache2/sites-enabled',
         /(?i-mx:centos|fedora|redhat)/ => '/etc/httpd/conf.d',
       }
     }
     else {
        $real_vhost_dir = $vhost_dir
    }
     
     packages { $real_packages: ensure => present }
    
     file { 'vhost_dir'
       path   => $real_vhost_dir,
       ensure => directory,
       mode   => '0750',
       owner  => 'www-data',
       group  => 'root',
     }
    }
{% endhighlight %}

... but it's a significant readability win, especially if the amount of logic or the number of parameters gets any higher than what's shown in the example.
