---
layout: legacy
title: Passenger
---

Passenger
=========

Using Passenger instead of WEBrick for web services offers numerous performance
advantages.  This guide shows how to set it up in an Apache web server.

* * *

Why Passenger
-------------

Traditionally, the puppetmaster would embed a WEBrick
Web Server to serve the Puppet clients. This may work well for
testing and small deployments, but it's recommended to use a more
scalable server for production environments.

What is Passenger?
------------------

[Passenger](http://www.modrails.com/) (AKA mod\_rails or mod\_rack)
is the Apache 2.x module which lets you run Rails or Rack
applications inside a general purpose web server, like
[Apache httpd](http://httpd.apache.org/) or [nginx](http://nginx.org/).

Passenger is the recommended deployment method for modern versions
of puppet masters, but you may run into compatibility issues with
Puppet versions older than 0.24.6 and Passenger versions older than
2.2.5.

* * *

Apache and Passenger Installation
---------------------------------

Make sure `puppet master` has been run at least once (or
`puppet agent`, if this master is not the CA), so that all required
SSL certificates are in place.

### Install Apache 2

Debian/Ubuntu:

    apt-get install apache2 ruby1.8-dev rubygems
    a2enmod ssl
    a2enmod headers

RHEL/CentOS (needs the Puppet Labs repository enabled, or the
[EPEL](https://fedoraproject.org/wiki/EPEL) repository):

    yum install httpd httpd-devel mod_ssl ruby-devel rubygems

### Install Rack/Passenger

    gem install rack passenger
    passenger-install-apache2-module

### Configure Apache

Debian/Ubuntu:

    # See Apache Configuration below for contents of puppetmaster file
    cp puppetmaster /etc/apache2/sites-available/
    a2ensite puppetmaster

RHEL/CentOS:

    # See Apache Configuration below for contents of puppetmaster.conf file
    cp puppetmaster.conf /etc/httpd/conf.d/

### Install the Rack Application

    mkdir -p /usr/share/puppet/rack/puppetmasterd
    mkdir /usr/share/puppet/rack/puppetmasterd/public /usr/share/puppet/rack/puppetmasterd/tmp
    cp /usr/share/puppet/ext/rack/files/config.ru /usr/share/puppet/rack/puppetmasterd/
    # This step is important - the owner of this file is the user the process will run under:
    chown puppet /usr/share/puppet/rack/puppetmasterd/config.ru

Apache Configuration
--------------------

### Example Configuration

This Apache Virtual Host configures the puppetmaster on the default
puppetmaster port (8140).

    # You'll need to adjust the paths in the Passenger config depending on which OS
    # you're using, as well as the installed version of Passenger.
    
    # Debian/Ubuntu:
    #LoadModule passenger_module /var/lib/gems/1.8/gems/passenger-3.0.x/ext/apache2/mod_passenger.so
    #PassengerRoot /var/lib/gems/1.8/gems/passenger-3.0.x
    #PassengerRuby /usr/bin/ruby1.8
    
    # RHEL/CentOS:
    #LoadModule passenger_module /usr/lib/ruby/gems/1.8/gems/passenger-3.0.x/ext/apache2/mod_passenger.so
    #PassengerRoot /usr/lib/ruby/gems/1.8/gems/passenger-3.0.x
    #PassengerRuby /usr/bin/ruby
    
    # And the passenger performance tuning settings:
    PassengerHighPerformance On
    PassengerUseGlobalQueue On
    # Set this to about 1.5 times the number of CPU cores in your master:
    PassengerMaxPoolSize 12
    # Recycle master processes after they service 1000 requests
    PassengerMaxRequests 1000
    # Stop processes if they sit idle for 10 minutes
    PassengerPoolIdleTime 600
    
    Listen 8140
    <VirtualHost *:8140>
        SSLEngine On
        
        # Only allow high security cryptography. Alter if needed for compatibility.
        SSLProtocol             All -SSLv2
        SSLCipherSuite          HIGH:!ADH:RC4+RSA:-MEDIUM:-LOW:-EXP
        SSLCertificateFile      /var/lib/puppet/ssl/certs/puppet-server.example.com.pem
        SSLCertificateKeyFile   /var/lib/puppet/ssl/private_keys/puppet-server.example.pem
        SSLCertificateChainFile /var/lib/puppet/ssl/ca/ca_crt.pem
        SSLCACertificateFile    /var/lib/puppet/ssl/ca/ca_crt.pem
        SSLCARevocationFile     /var/lib/puppet/ssl/ca/ca_crl.pem
        SSLVerifyClient         optional
        SSLVerifyDepth          1
        SSLOptions              +StdEnvVars +ExportCertData
        
        # These request headers are used to pass the client certificate
        # authentication information on to the puppet master process
        RequestHeader set X-SSL-Subject %{SSL_CLIENT_S_DN}e
        RequestHeader set X-Client-DN %{SSL_CLIENT_S_DN}e
        RequestHeader set X-Client-Verify %{SSL_CLIENT_VERIFY}e

        RackAutoDetect On
        DocumentRoot /usr/share/puppet/rack/puppetmasterd/public/
        <Directory /usr/share/puppet/rack/puppetmasterd/>
            Options None
            AllowOverride None
            Order Allow,Deny
            Allow from All
        </Directory>
    </VirtualHost>

If this puppet master is not the certificate authority, you will
need to use different paths to the CA certificate and CRL:

    SSLCertificateChainFile /var/lib/puppet/ssl/certs/ca.pem
    SSLCACertificateFile    /var/lib/puppet/ssl/certs/ca.pem
    SSLCARevocationFile     /var/lib/puppet/ssl/crl.pem

For additional details about enabling and configuring Passenger, see the
[Passenger install guide](http://www.modrails.com/install.html).

### Start the Apache service

Ensure that the puppet master service is stopped before starting
the Apache service; only one can be bound to TCP port 8140.

Debian/Ubuntu:

    /etc/init.d/apache2 restart

RHEL/CentOS:

    /etc/init.d/httpd restart

If all works well, you'll want to make sure the WEBrick service no longer starts:

Debian/Ubuntu:

    update-rc.d -f puppetmaster remove

RHEL/CentOS:

    chkconfig puppetmaster off
    chkconfig httpd on
