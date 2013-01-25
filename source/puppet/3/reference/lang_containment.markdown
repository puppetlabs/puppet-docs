---
layout: default
title: "Language: Containment of Resources"
---

[stdlib]: http://forge.puppetlabs.com/puppetlabs/stdlib
[classes]: ./lang_classes.html
[definedtype]: ./lang_defined_types.html
[relationship]: ./lang_relationships.html
[notify]: ./lang_relationships.html#ordering-and-notification

Containment
-----

[Classes][] and [defined type][definedtype] instances **contain** the resources they declare. This means that if any resource or class forms a [relationship][] with the container, it will form the same relationship with every resource inside the container. 

{% highlight ruby %}
    class ntp {
      file {'/etc/ntp.conf':
        ...
        require => Package['ntp'],
        notify  => Service['ntp'],
      }
      service {'ntp':
        ...
      }
      package {'ntp':
        ...
      }
    }
    
    include ntp
    exec {'/usr/local/bin/update_custom_timestamps.sh':
      require => Class['ntp'],
    }
{% endhighlight %}

In this example, `Exec['/usr/local/bin/update_custom_timestamps.sh']` would happen after _every_ resource in the ntp class, including the package, the file, and the service.

This feature also allows you to [notify and subscribe to][notify] classes and defined resource types as though they were a single resource. 

Known Issues
-----

**Classes do not get contained by the class or defined type that declares them.** This is a known design problem, and can be tracked at [issue #8040](http://projects.puppetlabs.com/issues/8040).

{% highlight ruby %}
    class ntp {
      include ntp::conf_file
      
      service {'ntp':
        ...
      }
      package {'ntp':
        ...
      }
    }
{% endhighlight %}

In the above example, a resource with a `require => Class['ntp']` metaparameter would be applied after both `Package['ntp']` and `Service['ntp']`, but **would not necessarily** happen after any of the resources contained by the `ntp::conf_file` class; those resources would "float off" outside the NTP class.

### Context and Plans

Containment is a singleton and is absolute: a resource can only be contained by one container (although the container, in turn, may be contained). However, classes can be declared in multiple places with the `include` function. A naïve interpretation would thus imply that classes can be in multiple containers at once. 

Puppet 0.25 and prior would establish a containment edge with the _first_ container in which a class was declared. This made containment dependent on parse-order, which was bad. However, fixing this unpredictability in 2.6 left no native way for the main "public" class in a module to completely own its subordinate implementation classes. This makes it hard to keep very large modules readable, since it complicates and obscures logical relationships in large blocks of code.

Puppet Labs is investigating ways to resolve this for a future Puppet version. 

### Workaround: The Anchor Pattern

You can cause a class to act like it's contained in another class by "holding it in place" with both a `require` and `before` relationship to resources that ARE contained:

{% highlight ruby %}
    class ntp {
      include ntp::conf_file
      
      # anchor is a special do-nothing resource type from the stdlib module.
      anchor {'ntp_first':} -> Class['ntp::conf_file'] -> anchor {'ntp_last':}
      
      package {'ntp':
        ...
        before => Class['ntp::conf_file'],
      }
      service {'ntp':
        ...
        subscribe => Class['ntp::conf_file'], 
      }
    }
{% endhighlight %}

In this case, the `ntp::conf_file` class still isn't technically contained, but any resource can safely form a relationship with the `ntp` class and rest assured that the relationship will propagate into all relevant resources. 

Since this anchoring behavior is effectively an invisible side effect of the relationships inside the class, you should not rely on relationships with normal resources. Instead, you should use the `anchor` resource type included in the [puppetlabs-stdlib module][stdlib], which exists solely for this purpose. 
