---
layout: default
title: Exported Resource Design Patterns
---

Exported Resource Design Patterns
==================================

Exported resources allow nodes to share information with each other. This is useful when one node has information that another node needs in order to manage a resource --- the node with the information can construct and publish the resource, and the node managing the resource can collect it.

**Note**: Exported resources only include node-specific data, and the catalog compiler constructs and publishes exported resources from that data. This means you can only export node-specific resources stored in the catalog. Generic data not stored in the catalog, such as an entire arbitrary file on a node's filesystem, can't be exported even if referenced by the source parameter of a file resource.

[For more information on the syntax, behavior, and prerequisites of exported resources, see the Exported Resources section of the Puppet language reference.][lang_exported]

[lang_exported]: /puppet/latest/reference/lang_exported.html

This page does not explain how exported resources work; instead, it covers common use cases.

Exported Resources with Nagios
------------------------------

Puppet includes native types for managing Nagios configuration
files. These types become very powerful when you export and collect
them. For example, you could create a class for something like
Apache that adds a service definition on your Nagios host,
automatically monitoring the web server:

    # /etc/puppetlabs/puppet/modules/nagios/manifests/target/apache.pp
    class nagios::target::apache {
       @@nagios_host { $fqdn:
            ensure  => present,
            alias   => $hostname,
            address => $ipaddress,
            use     => "generic-host",
       }
       @@nagios_service { "check_ping_${hostname}":
            check_command       => "check_ping!100.0,20%!500.0,60%",
            use                 => "generic-service",
            host_name           => "$fqdn",
            notification_period => "24x7",
            service_description => "${hostname}_check_ping"
       }
    }

    # /etc/puppetlabs/puppet/modules/nagios/manifests/monitor.pp
    class nagios::monitor {
        package { [ nagios, nagios-plugins ]: ensure => installed, }
        service { nagios:
            ensure     => running,
            enable     => true,
            #subscribe => File[$nagios_cfgdir],
            require    => Package[nagios],
        }
        # collect resources and populate /etc/nagios/nagios_*.cfg
        Nagios_host <<||>>
        Nagios_service <<||>>
    }

