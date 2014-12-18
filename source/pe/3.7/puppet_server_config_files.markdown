---
layout: default
title: "PE 3.7 » Puppet Server » Config Files"
subtitle: "Puppet Server Configuration Files"
canonical: "/pe/latest/puppet_server_config_files.html"
---
 
This page provides details about the configuration files and settings specific to Puppet Server. 

> **Tip**: More information about Puppet Server can be found in the [Puppet Server docs](/puppetserver/1.0/services_master_puppetserver.html). Differences between PE and open source versions of Puppet Server are typically called out. 

### `conf.d` Directory

At start up, Puppet Server will read all of the `.conf` files found in the `conf.d` directory (`/etc/puppetserver/conf.d`). This directory contains the following files:

- `ca.conf`
- `global.conf`
- `metrics.conf`
- `pe-puppetserver.conf`
- `webserver.conf`

>**Important**: When making changes to the files in this directory, you must restart Puppet Server (`service pe-puppetserver restart`) in order for the changes to take affect. 

#### `ca.conf`

This file contains settings related to the Certificate Authority service.

* `certificate-status contains` settings for the certificate_status HTTP endpoint. This endpoint allows certs to be signed, revoked, and deleted via HTTP requests. This provides full control over Puppet's security, and access should almost always be heavily restricted. Puppet Enterprise uses this endpoint to provide a cert signing interface in the PE console.
 
* `authorization-required` determines whether a client certificate is required to access the certificate status endpoints. If set to `false`, this allows plain text access, and the client-whitelist will be ignored. Defaults to `true`.

* `client-whitelist` contains a list of client certnames that are whitelisted to access to the certificate_status endpoint. Any requests made to this endpoint that do not present a valid client cert mentioned in this list will be denied access.

Here's an example:

    # CA-related settings
    certificate-authority: {
        certificate-status: { 
        authorization-required: true
        client-whitelist: [<by default pe-internal-dashboard>]
        }
    }
     
#### `global.conf`

This file contains global configuration for Puppet Server. You shouldn't  need to make changes to this file. However, you can change the `logging-config` path for the logback logging configuration file if necessary. For more information about the logback file, see the [LOGBack docs](http://logback.qos.ch/manual/configuration.html).

    global: {
   
      logging-config: /etc/puppetlabs/pe-puppetserver/logback.xml
      hostname: <the FQDN of your Puppet master>
    }

#### `metrics.conf`

This file contains settings related to Puppet Server metrics. For information about graphing Puppet Server meterics, refer to [Graphing Puppet Server Metrics](puppet_server_metrics.html).

    # metrics-related settings
    metrics: {
        # enable or disable the metrics system
        enabled: true

        # a server id that will be used as part of the namespace for metrics produced
        # by this server
        server-id: master.example.com

        # this section is used to configure reporters that will send the metrics
        # to various destinations for external viewing
        reporters: {

            # enable or disable JMX metrics reporter
            jmx: {
                enabled: true
            }

           # enable or disable graphite metrics reporter
             graphite: {
                enabled: true

           #   # graphite host
               host: "agent1.example.com"
               # graphite metrics port
               port: 2003
               # how often to send metrics to graphite
               update-interval-seconds: 5
           }
        }


#### `webserver.conf`

This file contains SSL configuration handled during PE installation, as shown in the following example:

    client-auth : want
    ssl-host    : 0.0.0.0
    ssl-port    : 8140

    ssl-cert    : /etc/puppetlabs/puppet/ssl/certs/master.example.com.pem
    ssl-key     : /etc/puppetlabs/puppet/ssl/private_keys/master.example.com.pem
    ssl-ca-cert : /etc/puppetlabs/puppet/ssl/certs/ca.pem
    ssl-crl-path : /etc/puppetlabs/puppet/ssl/crl.pem
    
By default, Puppet Server is configured to use the correct Puppet master and CA certificates. If you're using an external CA and have provided your own certificates and keys, make sure `webserver.conf` points to the correct file. 

#### `pe-puppet-server.conf`

This file contains settings related to Puppet Server. 

* The `jruby-puppet` settings configure the interpreter:

  * `gem-home`: This setting determines where JRuby looks for gems. It is also used by the puppetserver gem command line tool. If not specified, uses the Puppet default `/var/lib/puppet/jruby-gems`.
  
  * `master-conf-dir`: Sets the path to the Puppet configuration directory. Uses the PE default `/etc/puppetlabs/puppet`.
  
  * `master-var-dir`: Sets the path to the Puppet variable directory. Uses the PE default `/var/opt/lib/pe-puppet`.

The Ruby load path defaults to the directory where Puppet is installed. In this release, this directory varies depending on what OS you are using.

    jruby-puppet: {
       gem-home: /var/opt/lib/pe-puppet-server/jruby-gems
       master-conf-dir: /etc/puppetlabs/puppet
       master-var-dir: /var/opt/lib/pe-puppet
    }

    os-settings: {
       ruby-load-path: [/opt/puppet/lib/ruby/site_ruby/1.9.1]
    }
