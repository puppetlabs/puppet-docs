Exporting and Collecting Resources
==================================

Exporting and collecting resources is an extension of [Virtual
Resources](./virtual_resources.html) . Puppet provides an experimental superset of virtual
resources, using a similar syntax. In addition to these resources
being virtual, they're also "exported" to other hosts on your
network.

* * *

About Exported Resources
------------------------

While virtual resources can only be collected by the host that
specified them, exported resources can be collected by any host.
You **must** set the storeconfigs configuration parameter to true to
enable this functionality (you can see information about stored
configuration on the [[Using Stored Configuration]] wiki page), and
Puppet will automatically create a database for storing
configurations (using [Ruby on Rails](http://rubyonrails.org/)).

    [puppetmasterd]
    storeconfigs = true

This allows one host to configure another host; for instance, a
host could configure its services using Puppet, and then could
export Nagios configurations to monitor those services.

The key syntactical difference between virtual and exported
resources is that the special sigils (@ and \<| |>) are doubled (@@
and \<\<| |>>) when referring to an exported resource.

Here is an example with exported resources:

    class ssh {
        @@sshkey { $hostname: type => dsa, key => $sshdsakey }
        Sshkey <<| |>>
    }

As promised, we use two @ sigils here, and the angle brackets are
doubled in the collection.

The above code would have every host export its SSH public key, and
then collect every host's key and install it in the
ssh\_known\_hosts file (which is what the sshkey type does); this
would include the host doing the exporting.

It's important to mention here that you will only get exported
resources from hosts whose configurations have been compiled. If
hostB exports a resource but hostB has never connected to the
server, then no host will get that exported resource. The act of
compiling a given host's configuration puts the resources into the
database, and only resources in the database are available for
collection.

Let's look at another example, this time using a File resource:

    node a {
        @@file { "/tmp/foo": content => "fjskfjs\n", tag => "foofile", }
    }
    node b {
        File <<| tag == 'foofile' |>>
    }

This will create /tmp/foo on node b. Note that the tag is not
required, it just allows you to control which resources you want to
import.

Exported Resources with Nagios
------------------------------

Puppet includes native types for managing Nagios configuration
files. These types become very powerful when you export and collect
them. For example, you could create a class for something like
Apache that adds a service definition on your Nagios host,
automatically monitoring the web server:

    class nagios-target {
       @@nagios_host { $fqdn:
            ensure => present,
            alias => $hostname,
            address => $ipaddress,
            use => "generic-host",
       }
       @@nagios_service { "check_ping_${hostname}":
            check_command => "check_ping!100.0,20%!500.0,60%",
            use => "generic-service",
            host_name => "$fqdn",
            notification_period => "24x7",
            service_description => "${hostname}_check_ping"
       }
    }
    class nagios-monitor {
        package { [ nagios, nagios-plugins ]: ensure => installed, }
        service { nagios:
            ensure => running,
            enable => true,
            #subscribe => File[$nagios_cfgdir],
            require => Package[nagios],
        }
        # collect resources and populate /etc/nagios/nagios_*.cfg
        Nagios_host <<||>>
        Nagios_service <<||>>
    }

Exported Resources Override
---------------------------

Beginning in version 0.25, some new syntax has been introduced that
allows creation of collections of any resources, not just virtual
ones, based on filter conditions, and override of parameters in the
created collection. This feature is not constrained to the override
in inherited context, as is the case in the usual resource
override.

Ordinary resource collections can now be defined by filter
conditions, in the same way as collections of virtual or exported
resources. For example:

    file {
        "/tmp/testing": content => "whatever"
    }
    
    File<| |> {
        mode => 0600
    }

The filter condition goes in the middle of the \<| |> sigils. In
the above example the condition is empty, so all file resources
(not just virtual ones) are selected, and all file resources will
have their modes overridden to 0600.

In the past this syntax only collected virtual resources. It now
collects all matching resources, virtual or no, and allows you to
override parameters in any of the collection so defined.

As another example, one can write:

    file { "/tmp/a": content => "a" }
    file { "/tmp/b": content => "b" }
    
    File <| title != "/tmp/b" |> {
        require => File["/tmp/b"]
    }

This means that every File resource requires /tmp/b, except /tmp/b
itself. Moreover, it is now possible to define resource overriding
without respecting the override on inheritance rule:

    class a {
        file {
            "/tmp/testing": content => "whatever"
        }
    }
    
    class b {
        include a
        File<| |> {
            mode => 0600
        }
    }
    include b



