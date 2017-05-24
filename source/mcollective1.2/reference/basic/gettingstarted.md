---
layout: default
title: Getting Started
disqus: true
canonical: "/mcollective/reference/basic/gettingstarted.html"
---
[Screencasts]: /mcollective1.2/screencasts.html
[ActiveMQ]: http://activemq.apache.org/
[EC2Demo]: /mcollective1.2/ec2demo.html
[Stomp]: http://stomp.codehaus.org/Ruby+Client
[DepRPMs]: http://www.marionette-collective.org/activemq/
[DebianBug]: http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=562954
[SecurityWithActiveMQ]: /mcollective1.2/reference/integration/activemq_security.html
[ActiveMQClustering]: http://www.devco.net/archives/2009/11/10/activemq_clustering.php
[ActiveMQSamples]: http://github.com/puppetlabs/marionette-collective/tree/master/ext/activemq/examples/
[ConfigurationReference]: /mcollective1.2/reference/basic/configuration.html
[Terminology]: /mcollective1.2/terminology.html
[SimpleRPCIntroduction]: /mcollective1.2/simplerpc/
[ControllingTheDaemon]: /mcollective1.2/reference/basic/daemon.html
[SSLSecurityPlugin]: /mcollective1.2/reference/plugins/security_ssl.html
[AESSecurityPlugin]: /mcollective1.2/reference/plugins/security_aes.html
[ConnectorStomp]: /mcollective1.2/reference/plugins/connector_stomp.html
[MessageFlowCast]: /mcollective1.2/screencasts.html#message_flow
[Plugins]: http://code.google.com/p/mcollective-plugins/
[RedHatGuide]: gettingstarted_redhat.html

# {{page.title}}

 * TOC Placeholder
 {:toc}


*NOTE:* We are currently improving the Getting Started documentation.  Red Hat and CentOS users can refer to [our new guide][RedHatGuide], others will be added in time.

Below find a rough guide to get you going, this assumes the client and server is on the same node, but servers don't need the client code installed.

For an even quicker intro to how it all works you can try our [EC2 based demo][EC2Demo]

Look at the [Screencasts] page, there are [some screencasts dealing with basic architecture, terminology and so forth][MessageFlowCast] that you might find helpful before getting started.

## Requirements
We try to keep the requirements on external Gems to a minimum, you only need:

 * A Stomp server, tested against [ActiveMQ]
 * Ruby
 * Rubygems
 * [Ruby Stomp Client][Stomp]

RPMs for these are available [here][DepRPMs].

**NOTE: You need version Stomp Gem 1.1 for mcollective up to 0.4.5.  mcollective 0.4.6 onward supports 1.1 and 1.1.6 and newer**


## ActiveMQ
I've developed this against ActiveMQ.  It should work against other Stomp servers but I suspect if you choose
one without username and password support you might have problems, please let me know if that's the case
and I'll refactor the code around that.

Full details on setting up and configuring ActiveMQ is out of scope for this, but you can follow these simple
setup instructions for initial testing (make sure JDK is installed, see below for Debian specific issue regarding JDK):

### Download and Install
 1. Download the ActiveMQ "binary" package (for Unix) from [ActiveMQ]
 1. Extract the contents of the archive:
 1. cd into the activemq directory
 1. Execute the activemq binary

{% highlight console %}
   % tar xvzf activemq-x.x.x.tar.gz
   % cd activemq-x.x.x
   % bin/activemq
{% endhighlight %}

Below should help you get stomp and a user going. For their excellent full docs please see [ActiveMQ].
There are also tested configurations in [the ext directory][ActiveMQSamples]

A spec file can be found in the *ext* directory on GitHub that can be used to build RPMs for RedHat/CentOS/Fedora
you need *tanukiwrapper* which you can find from *jpackage*, it runs fine under OpenJDK that comes with recent
versions of these Operating Systems.  I've uploaded some RPMs and SRPMs [here][DepRPMs].

For Debian systems you'd be better off using OpenJDK than Sun JDK, there's a known issue [#562954][DebianBug].

### Configuring Stomp
First you should configure ActiveMQ to listen on the Stomp protocol

And then you should add a user or two, to keep it simple we'll just add one user, the template file will hopefully make it obvious where this goes, it should be in the _broker_ block:

*Note: This config is for ActiveMQ 5.4*

{% highlight xml %}
<beans
  xmlns="http://www.springframework.org/schema/beans"
  xmlns:amq="http://activemq.apache.org/schema/core"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans-2.0.xsd
  http://activemq.apache.org/schema/core http://activemq.apache.org/schema/core/activemq-core.xsd
  http://activemq.apache.org/camel/schema/spring http://activemq.apache.org/camel/schema/spring/camel-spring.xsd">

    <broker xmlns="http://activemq.apache.org/schema/core" brokerName="localhost" useJmx="true">
        <managementContext>
            <managementContext createConnector="false"/>
        </managementContext>

        <plugins>
          <statisticsBrokerPlugin/>
          <simpleAuthenticationPlugin>
            <users>
              <authenticationUser username="mcollective" password="marionette" groups="mcollective,everyone"/>
              <authenticationUser username="admin" password="secret" groups="mcollective,admin,everyone"/>
            </users>
          </simpleAuthenticationPlugin>
          <authorizationPlugin>
            <map>
              <authorizationMap>
                <authorizationEntries>
                  <authorizationEntry queue=">" write="admins" read="admins" admin="admins" />
                  <authorizationEntry topic=">" write="admins" read="admins" admin="admins" />
                  <authorizationEntry topic="mcollective.>" write="mcollective" read="mcollective" admin="mcollective" />
                  <authorizationEntry topic="mcollective.>" write="mcollective" read="mcollective" admin="mcollective" />
                  <authorizationEntry topic="ActiveMQ.Advisory.>" read="everyone" write="everyone" admin="everyone"/>
                </authorizationEntries>
              </authorizationMap>
            </map>
          </authorizationPlugin>
        </plugins>

        <systemUsage>
            <systemUsage>
                <memoryUsage>
                    <memoryUsage limit="20 mb"/>
                </memoryUsage>
                <storeUsage>
                    <storeUsage limit="1 gb" name="foo"/>
                </storeUsage>
                <tempUsage>
                    <tempUsage limit="100 mb"/>
                </tempUsage>
            </systemUsage>
        </systemUsage>

        <transportConnectors>
            <transportConnector name="openwire" uri="tcp://0.0.0.0:6166"/>
            <transportConnector name="stomp" uri="stomp://0.0.0.0:6163"/>
        </transportConnectors>
    </broker>
</beans>
{% endhighlight %}

This creates a user *mcollective* with the password *marionette* and give it access to read/write/admin */topic/mcollective.`*`*.

Save the above code as activemq.xml and run activemq as - if installing from a package probably _/etc/activemq/activemq.xml_:

Else your package would have a RC script:

{% highlight console %}
  # /etc/init.d/activemq start
{% endhighlight %}

For further info about ActiveMQ settings you might need see [SecurityWithActiveMQ] and [ActiveMQClustering].

There are also a few known to work and tested [configs in git][ActiveMQSamples].

## mcollective

### Download and Extract
Grab a copy of the mcollective ideally you'd use a package for your distribution else there's a tarfile that
you can use, you can extract it wherever you want, the RPMs or deps will put files in Operating System compatible
locations.  If you use the tarball you'll need to double check all the paths in the config files below.

### Configure
You'll need to tweak some configs in */etc/mcollective/client.cfg*, a full reference of config settings can be
found [here][ConfigurationReference]:

Mostly what you'll need to change is the *identity*, *plugin.stomp.`*`* and the *plugin.psk*:

{% highlight ini %}
  # main config
  topicprefix = /topic/mcollective
  libdir = /usr/libexec/mcollective
  logfile = /dev/null
  loglevel = debug
  identity = fqdn

  # connector plugin config
  connector = stomp
  plugin.stomp.host = stomp.your.net
  plugin.stomp.port = 6163
  plugin.stomp.user = unset
  plugin.stomp.password = unset

  # security plugin config
  securityprovider = psk
  plugin.psk = abcdefghj
{% endhighlight %}

You should also create _/etc/mcollective/server.cfg_ here's a sample, , a full reference of config settings can be found here [ConfigurationReference]:

{% highlight ini %}
  # main config
  topicprefix = /topic/mcollective
  libdir = /usr/libexec/mcollective
  logfile = /var/log/mcollective.log
  daemonize = 1
  keeplogs = 1
  max_log_size = 10240
  loglevel = debug
  identity = fqdn
  registerinterval = 300

  # connector plugin config
  connector = stomp
  plugin.stomp.host = stomp.your.net
  plugin.stomp.port = 6163
  plugin.stomp.user = mcollective
  plugin.stomp.password = password

  # facts
  factsource = yaml
  plugin.yaml = /etc/mcollective/facts.yaml

  # security plugin config
  securityprovider = psk
  plugin.psk = abcdefghj
{% endhighlight %}

Replace the *plugin.stomp.host* with your server running ActiveMQ and replace the *plugin.psk* with a Pre-Shared Key of your own.

The STOMP connector supports other options like failover pools, see [ConnectorStomp] for full details.

*NOTE:* If you are testing the development versions - 1.1.3 and newer - you should use make a small adjustment to both config
files above:

{% highlight ini %}
topicprefix = /topic/
{% endhighlight %}

### Create Facts
By default - and for this setup - we'll use a simple YAML file for a fact source, later on you can use Reductive Labs Facter or something else.

Create */etc/mcollective/facts.yaml* along these lines:

{% highlight yaml %}
  ---
  location: devel
  country: uk
{% endhighlight %}

### Start the Server
If you installed from a package start it with the RC script, else look in the source you'll find a LSB compatible RC script to start it.

### Test from a client
If all is setup you can test with the client code:

{% highlight console %}
% mco ping
your.domain.com                           time=74.41 ms

---- ping statistics ----
1 replies max: 74.41 min: 74.41 avg: 74.41
{% endhighlight %}

This sent a simple 'hello' packet out to the network and if you started up several of the *mcollectived.rb* processes on several machines you
would have seen several replies, be sure to give each a unique *identity* in the config.

At this point you can start exploring the discovery features for example:

{% highlight console %}
% mco find --with-fact country=uk
your.domain.com
{% endhighlight %}

This searches all systems currently active for ones with a fact *country=uk*, it got the data from the yaml file you made earlier.

If you use confiuration management tools like puppet and the nodes are setup with classes with *classes.txt* in */var/lib/puppet* then you
can search for nodes with a specific class on them - the locations will configurable soon:

{% highlight console %}
% mco find --with-class common::linux
your.domain.com
{% endhighlight %}

Chef does not yet support such a list natively but we have some details on the wiki to achieve the same with Chef.

The filter commands are important they will be the main tool you use to target only parts of your infrastructure with calls to agents.

See the *--help* option to the various *mco `*`* commands for available options.  You can now look at some of the available plugins and
play around, you might need to run the server process as root if you want to play with services etc.

### Plugins
We provide limited default plugins, you can look on our sister project [MCollective Plugins][Plugins] where you will
find various plugins to manage packages, services etc.

### Further Reading
From here you should look at the rest of the wiki pages some key pages are:

 * [Screencasts] - Get a hands-on look at what is possible
 * [Terminology]
 * [Introduction to Simple RPC][SimpleRPCIntroduction] - a simple to use framework for writing clients and agents
 * [ControllingTheDaemon] - Controlling a running daemon
 * [AESSecurityPlugin] - Using AES+RSA for secure message encryption and authentication of clients
 * [SSLSecurityPlugin] - Using SSL for secure message signing and authentication of clients
 * [ConnectorStomp] - Full details on the Stomp adapter including failover pools
