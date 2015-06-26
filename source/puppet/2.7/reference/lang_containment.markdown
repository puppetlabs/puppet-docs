---
layout: default
title: "Language: Containment of Resources"
canonical: "/puppet/latest/reference/lang_containment.html"
---

[stdlib]: http://forge.puppetlabs.com/puppetlabs/stdlib
[classes]: ./lang_classes.html
[definedtype]: ./lang_defined_types.html
[relationship]: ./lang_relationships.html
[notify]: ./lang_relationships.html#ordering-and-notification

Containment
-----

[Classes][] and [defined type][definedtype] instances **contain** the resources they declare. This means that if any resource or class forms a [relationship][] with the container, it will form the same relationship with every resource inside the container.

~~~ ruby
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
~~~

In this example, `Exec['/usr/local/bin/update_custom_timestamps.sh']` would happen after _every_ resource in the ntp class, including the package, the file, and the service.

This feature also allows you to [notify and subscribe to][notify] classes and defined resource types as though they were a single resource.

Known Issues
-----

**Classes do not get contained by the class or defined type that declares them.** This is a known design problem, and can be tracked at [issue #8040](http://projects.puppetlabs.com/issues/8040).

~~~ ruby
    class ntp {
      include ntp::conf_file

      service {'ntp':
        ...
      }
      package {'ntp':
        ...
      }
    }
~~~

In the above example, a resource with a `require => Class['ntp']` metaparameter would be applied after both `Package['ntp']` and `Service['ntp']`, but **would not necessarily** happen after any of the resources contained by the `ntp::conf_file` class; those resources would "float off" outside the NTP class.

### Context and Plans

Containment is a singleton and is absolute: a resource can only be contained by one container (although the container, in turn, may be contained). However, classes can be declared in multiple places with the `include` function. A naïve interpretation would thus imply that classes can be in multiple containers at once.

Puppet 0.25 and prior would establish a containment edge with the _first_ container in which a class was declared. This made containment dependent on parse-order, which was bad. However, fixing this unpredictability in 2.6 left no native way for the main "public" class in a module to completely own its subordinate implementation classes. This makes it hard to keep very large modules readable, since it complicates and obscures logical relationships in large blocks of code.

This is resolved as of Puppet 3.4.0, which adds a special `contain` function for forming class-to-class containment relationships.

### Workaround: The Anchor Pattern

To mimic class containment in Puppet 2.7, you must use the **anchor pattern.**

> **Note:** To use the anchor pattern, [the `puppetlabs/stdlib` module][stdlib] must be installed. This module includes the dummy `anchor` resource type.

To use the anchor pattern:

* The _containing_ class must include two uniquely-named `anchor` resources. (Anchor resources don't have any effect on the target system, and only exist to form relationships with.)
* Any _contained_ classes must have relationships ensuring they happen _after_ one anchor and _before_ the other.

In an example NTP module where service configuration is moved out into its own class:

~~~ ruby
    class ntp {
      file { '/etc/ntp.conf':
        ...
        require => Package['ntp'],
        notify  => Class['ntp::service'],
      }
      include ntp::service
      anchor { 'ntp_first': } -> Class['ntp::service'] -> anchor { 'ntp_last': }
      package { 'ntp':
        ...
      }
    }

    include ntp
    exec { '/usr/local/bin/update_custom_timestamps.sh':
      require => Class['ntp'],
    }
~~~

In this case, the `ntp::service` class still isn't technically contained, but any resource can safely form a relationship with the `ntp` class and be assured that the relationship will propagate into all relevant resources.

