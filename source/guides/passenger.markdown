---
layout: legacy
title: Passenger
---

Passenger
=========

Using Passenger instead of WEBrick for web services offers numerous performance
advantages.  This guide shows how to set it up.

* * *

Supported Versions
------------------

Passenger support is present in release 0.24.6 and later versions only.  For earlier
versions, consider [Using Mongrel](./mongrel.html).

Why Passenger
-------------

Traditionally, the puppetmaster would embed a WEBrick or Mongrel
Web Server to serve the puppet clients. This may work well for you,
but a few people feel like using a proven web server like Apache
would be superior for this purpose.

What is Passenger?
------------------

[Passenger](http://www.modrails.com/) (AKA mod\_rails or mod\_rack)
is the Apache 2.x Extension which lets you run Rails or Rack
applications inside Apache.

Puppet (>0.24.6) now ships with a Rack application which can embed
a puppetmaster. While it should be compatible with every Rack
application server, it has only been tested with Passenger.

Depending on your operating system, the versions of Puppet, Apache
and Passenger may not support this implementation. Specifically,
Ubuntu Hardy ships with an older version of puppet (0.24.4) and
doesn't include passenger at all, however updated packages for
puppet can be found
[here](https://launchpad.net/~bitpusher/+archive/ppa). There are
also some passenger packages there, but as of 2009-09-28 they do
not seem to have the latest passenger (2.2.5), so better install
passenger from a gem as per the instructions at [modrails.com].

Note: Passenger versions 2.2.3 and 2.2.4 have known bugs regarding
to the SSL environment variables, which make them unsuitable for
hosting a puppetmaster. So use either 2.2.2, or 2.2.5. Note that
while it was expected that Passenger 2.2.2 would be the last
version which can host a 0.24.x puppetmaster, that turns out to be
not true, cf.
[this bug report](http://projects.puppetlabs.com/issues/2386#change-9238).
So, passenger 2.2.5 works fine.

Installation Instructions for Puppet 0.25.x and 2.6.x
-----------------------------------------------------

Please see
[ext/rack/README in the puppet source](http://github.com/puppetlabs/puppet/tree/master/ext/rack)
tree for instructions.

Whatever you do, make sure your config.ru file is owned by the
puppet user! Passenger will setuid to that user.

Installation Instructions for Puppet 0.24.x for Debian/Ubuntu and RHEL5
------------------------------------------------------------------

Make sure puppetmasterd ran at least once, so puppetmasterd SSL
certificates are setup intially.

### Install Apache 2, Rack and Passenger

For Debian/Ubuntu:

    apt-get install apache2
    apt-get install ruby1.8-dev

For RHEL5 (needs the [EPEL](https://fedoraproject.org/wiki/EPEL)
repository enabled):

    yum install httpd httpd-devel ruby-devel rubygems

### Install Rack/Passenger

The latest version of Passenger (2.2.5) appears to work fine on
RHEL5:

    gem install rack
    gem install passenger
    passenger-install-apache2-module

If you want the older 2.2.2 gem, you could manually download the
.gem file from
[RubyForge](http://rubyforge.org/frs/?group_id=5873). Or, you could
just add the correct versions to your gem command:

      gem install -v 0.4.0 rack
      gem install -v 2.2.2 passenger

### Enable Apache modules "ssl" and "headers":

    # for Debian or Ubuntu:
    a2enmod ssl
    a2enmod headers

    # for RHEL5
    yum install mod_ssl

### Configure Apache

For Debian/Ubuntu:

    cp apache2.conf /etc/apache2/sites-available/puppetmasterd  (see below for the file contents)
    ln -s /etc/apache2/sites-available/puppetmasterd /etc/apache2/sites-enabled/puppetmasterd
    vim /etc/apache2/conf.d/puppetmasterd (replace the hostnames)

For RHEL5:

    cp puppetmaster.conf /etc/httpd/conf.d/ (see below for file contents)
    vim /etc/httpd/conf.d/puppetmaster.conf (replace hostnames with corrent values)

Install the rack application [1]:

    mkdir -p /usr/share/puppet/rack/puppetmasterd
    mkdir /usr/share/puppet/rack/puppetmasterd/public /usr/share/puppet/rack/puppetmasterd/tmp
    cp config.ru /usr/share/puppet/rack/puppetmasterd
    chown puppet /usr/share/puppet/rack/puppetmasterd/config.ru

Go:

    # For Debian/Ubuntu
    /etc/init.d/apache2 restart

    # For RHEL5
    /etc/init.d/httpd restart

If all works well, you'll want to make sure your puppmetmasterd
init script does not get called anymore:

    # For Debian/Ubuntu
    update-rc.d -f puppetmaster remove

    # For RHEL5
    chkconfig puppetmaster off
    chkconfig httpd on

[1] Passenger will not let applications run as root or the Apache
user, instead an implicit setuid will be done, to the user whom
owns config.ru. Therefore, config.ru shall be owned by the puppet
user.

Apache Configuration for Puppet 0.24.x
--------------------------------------

This Apache Virtual Host configures the puppetmaster on the default
puppetmaster port (8140).

    Listen 8140
    <VirtualHost *:8140>

        SSLEngine on
        SSLCipherSuite SSLv2:-LOW:-EXPORT:RC4+RSA
        SSLCertificateFile      /var/lib/puppet/ssl/certs/puppet-server.inqnet.at.pem
        SSLCertificateKeyFile   /var/lib/puppet/ssl/private_keys/puppet-server.inqnet.at.pem
        SSLCertificateChainFile /var/lib/puppet/ssl/ca/ca_crt.pem
        SSLCACertificateFile    /var/lib/puppet/ssl/ca/ca_crt.pem
        # CRL checking should be enabled; if you have problems with Apache complaining about the CRL, disable the next line
        SSLCARevocationFile     /var/lib/puppet/ssl/ca/ca_crl.pem
        SSLVerifyClient optional
        SSLVerifyDepth  1
        SSLOptions +StdEnvVars

        # The following client headers allow the same configuration to work with Pound.
        RequestHeader set X-SSL-Subject %{SSL_CLIENT_S_DN}e
        RequestHeader set X-Client-DN %{SSL_CLIENT_S_DN}e
        RequestHeader set X-Client-Verify %{SSL_CLIENT_VERIFY}e

        RackAutoDetect On
        DocumentRoot /usr/share/puppet/rack/puppetmasterd/public/
        <Directory /usr/share/puppet/rack/puppetmasterd/>
            Options None
            AllowOverride None
            Order allow,deny
            allow from all
        </Directory>
    </VirtualHost>

If the current puppetmaster is not a certificate authority, you may
need to change the following lines. The certs/ca.pem file should
exist as long as the puppetmaster has been signed by the CA.

      SSLCertificateChainFile /var/lib/puppet/ssl/certs/ca.pem
        SSLCACertificateFile    /var/lib/puppet/ssl/certs/ca.pem

For Debian hosts you might wish to add:

      LoadModule passenger_module /var/lib/gems/1.8/gems/passenger-2.2.5/ext/apache2/mod_passenger.so
        PassengerRoot /var/lib/gems/1.8/gems/passenger-2.2.5
        PassengerRuby /usr/bin/ruby1.8

For RHEL hosts you may need to add:

       LoadModule passenger_module /usr/lib/ruby/gems/1.8/gems/passenger-2.2.5/ext/apache2/mod_passenger.so
       PassengerRoot /usr/lib/ruby/gems/1.8/gems/passenger-2.2.5
       PassengerRuby /usr/bin/ruby

For details about enabling and configuring Passenger, see the
[Passenger install guide](http://www.modrails.com/install.html).

The config.ru file for Puppet 0.24.x
------------------------------------

    # This file is mostly based on puppetmasterd, which is part of
    # the standard puppet distribution.

    require 'rack'
    require 'puppet'
    require 'puppet/network/http_server/rack'

    # startup code stolen from bin/puppetmasterd
    Puppet.parse_config
    Puppet::Util::Log.level = :info
    Puppet::Util::Log.newdestination(:syslog)
    # A temporary solution, to at least make the master work for now.
    Puppet::Node::Facts.terminus_class = :yaml
    # Cache our nodes in yaml.  Currently not configurable.
    Puppet::Node.cache_class = :yaml


    # The list of handlers running inside this puppetmaster
    handlers = {
        :Status => {},
        :FileServer => {},
        :Master => {},
        :CA => {},
        :FileBucket => {},
        :Report => {}
    }

    # Fire up the Rack-Server instance
    server = Puppet::Network::HTTPServer::Rack.new(handlers)

    # prepare the rack app
    app = proc do |env|
        server.process(env)
    end

    # Go.
    run app

If you don't want to run with the CA enabled, you could drop the
':CA => {}' line from the config.ru above.

The config.ru file for 0.25.x
-----------------------------

Please see ext/rack in the 0.25 source tree for the proper
config.ru file.

Suggested Tweaks
----------------

Larry Ludwig's testing of passenger/puppetmasterd recommends
adjusting these options in your apache configuration:

-   PassengerPoolIdleTime 300 - Set to 5 min (300 seconds) or less.
    The shorting this option allows for puppetmasterd to get refreshed
    at some interval. This option is also somewhat dependent upon the
    amount of puppetd nodes connecting and at what interval.
-   PassengerMaxPoolSize 15 - to 15% more instances than what's
    needed. This will allow idle puppetmasterd to get recycled. The net
    effect is less memory will be used, not more.
-   PassengerUseGlobalQueue on - Since communication with the
    puppetmaster from puppetd is a long process (more than 20 seconds
    in most cases) and will allow for processes to get recycled better
-   PassengerHighPerformance on - The additional Passenger features
    for apache compatibility are not needed with Puppet.

As is expected with traditional web servers, once your service
starts using swap, performance degradation will occur --- so be mindful
of your memory/swap usage on your Puppetmaster.

To monitor the age of your puppetmasterd processes within
Passenger, run

    passenger-status | grep PID | sort

      PID: 14590   Sessions: 1    Processed: 458     Uptime: 3m 40s
      PID: 7117    Sessions: 0    Processed: 10980   Uptime: 1h 43m 41s
      PID: 7355    Sessions: 0    Processed: 9736    Uptime: 1h 38m 38s
      PID: 7575    Sessions: 0    Processed: 9395    Uptime: 1h 32m 27s
      PID: 9950    Sessions: 0    Processed: 6581    Uptime: 1h 2m 35s

Passenger can be configured to be recycling puppetmasterd
every few hours to ensure memory/garbage collection from Ruby is
not a factor.




