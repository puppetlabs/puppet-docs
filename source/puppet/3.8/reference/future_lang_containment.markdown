---
layout: default
title: "Future Parser: Containment of Resources"
canonical: "/puppet/latest/reference/lang_containment.html"
---

[stdlib]: http://forge.puppetlabs.com/puppetlabs/stdlib
[classes]: ./future_lang_classes.html
[definedtype]: ./future_lang_defined_types.html
[relationship]: ./future_lang_relationships.html
[notify]: ./future_lang_relationships.html#ordering-and-notification

Containment
-----

[Classes][] and [defined type][definedtype] instances **contain** the resources they declare. Any contained resources will not be applied before the container is begun, and will be finished before the container is finished.

This effectively means that if any resource or class forms a [relationship][] with the container, it will form the same relationship with every resource inside the container.

~~~ ruby
    class ntp {
      file { '/etc/ntp.conf':
        ...
        require => Package['ntp'],
        notify  => Service['ntp'],
      }
      service { 'ntp':
        ...
      }
      package { 'ntp':
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

Containing Resources
-----

Resources of both native and defined resource types are automatically contained by the class or defined type in which they are declared.

Containing Classes
-----

Having classes contain other classes can be very useful, especially in larger modules where you want to improve code readability by moving chunks of implementation into separate files.

However, unlike resources, Puppet does not _automatically_ contain classes when they are declared inside another class. This is because classes may be declared in several places via `include` and similar functions. Most of these places shouldn't contain the class, and trying to contain it everywhere would cause huge problems.

Instead, you must _manually_ contain any classes that need to be contained.

### The `contain` Function

Use the `contain` function when a class should be contained. The `contain` function will declare the class with include-like behavior if it isn't already declared, and will cause it to be contained by the surrounding class.

In an example NTP module where service configuration is moved out into its own class:

~~~ ruby
    class ntp {
      file { '/etc/ntp.conf':
        ...
        require => Package['ntp'],
        notify  => Class['ntp::service'],
      }
      contain ntp::service
      package { 'ntp':
        ...
      }
    }

    include ntp
    exec { '/usr/local/bin/update_custom_timestamps.sh':
      require => Class['ntp'],
    }
~~~

This will ensure that the exec will happen after all the resources in both class `ntp` and class `ntp::service`. (If `ntp::service` had been declared with `include` instead of `contain`, the exec would happen after the file and the package, but wouldn't _necessarily_ happen after the service.)

To contain classes that are declared with the resource-like declaration syntax, use the contain function **after** declaring the class:

~~~ ruby
    class ntp {
      # ...
      class { 'ntp::service':
        enable => true,
      }
      contain 'ntp::service'
      # ...
    }
~~~

### Anchor Pattern Containment (for Compatibility With Puppet ≤ 3.4.0)

Versions prior to Puppet 3.4.0 and Puppet Enterprise 3.2 do not ship with the `contain` function. If your code needs to support these versions, it should contain classes with the **anchor pattern.**

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

      # roughly equivalent to "contain ntp::service":
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

In this case, the `ntp::service` class will behave like it's contained by the `ntp` class. Resources like the timestamp `exec` can form relationships with the `ntp` class and be assured that no relevant resources will float out of order.

