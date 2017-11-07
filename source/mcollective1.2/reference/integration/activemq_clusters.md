---
layout: default
title: ActiveMQ Clustering
disqus: true
canonical: "/mcollective/reference/integration/activemq_clusters.html"
---
[MessageFormat]: /mcollective1.2/reference/basic/messageformat.html
[MessageFlow]: /mcollective1.2/reference/basic/messageflow.html
[NetworksOfBrokers]: http://activemq.apache.org/networks-of-brokers.html
[UsingSSL]: http://activemq.apache.org/how-do-i-use-ssl.html
[SecurityWithActiveMQ]: /mcollective1.2/reference/integration/activemq_security.html
[SampleConfig]: http://github.com/puppetlabs/marionette-collective/tree/master/ext/activemq/

# {{page.title}}

Relying on existing middleware tools and not re-inventing the transport wheel ourselves means we can take advantage of a lot of the built in features they provide.  One such feature is clustering in ActiveMQ that allows for highly scalable and flexible network layouts.

We'll cover here how to build a multi data center network of ActiveMQ servers with a NOC, the NOC computers would not need to send any packets direct to the nodes they manage and thanks to our meta data based approach to addressing machines they do not even need to know IPs or hostnames.

There is an example of a 3 node cluster in the [ext/activemq directory][SampleConfig].

## Network Design

### Network Layout

![ActiveMQ Cluster](/mcollective1.2/images/activemq-multi-locations.png)

The diagram above shows our sample network, I am using the same techniques to put an ActiveMQ in each of 4 countries and then having local nodes communicate to in-country ActiveMQ nodes.

 * These are the terminals of your NOC staff, they run the client code, these could also be isolated web servers for running admin tools etc.
 * Each location has its own instance of ActiveMQ and nodes would only need to communicate to their local ActiveMQ.  This greatly enhances security in a setup like this.
 * The ActiveMQ instances speak to each other using a protocol called OpenWire, you can run this over IPSec or you could use the native support for SSL.
 * These are the servers being managed, they run the server code.  No direct communications needs to be in place between NOC and managed servers.

Refer to the [MessageFlow] document to see how messages would traverse the middleware in a setup like this.

### General Observations
The main design goal here is to promote network isolation, the staff in your NOC are often high churn people, you'll get replacement staff relatively often and it's a struggle to secure what information they carry and how and when you can trust them.

Our model of using middleware and off-loading authentication and authorization onto the middleware layer means you only need to give NOC people appropriate access to the middleware and not to each individual machine.

Our usage of meta data to address machines rather than hostnames or ip address means you do not need to divulge this information to NOC staff, from their point of view they access machines like this:

 * All machines in _datacenter=a_
 * AND all machines with puppet class _/webserver/_
 * AND all machines with Facter fact _customer=acmeinc_

In the end they can target the machines they need to target for maintenance commands as above without the need for any info about hostnames, ips, or even what/where data center A is.

This model works particularly well in a Cloud environment where hostnames are dynamic and not under your control, in a cloud like Amazon S3 machines are better identified by what AMI they have booted and in what availability zones they are rather than what their hostnames are.

## ActiveMQ Configuration
ActiveMQ supports many types of cluster, I think their Network of Brokers model works best for us so I'll show a sample setup of that.

There are some relevant docs on the ActiveMQ Wiki:

 * [Network of Brokers][NetworksOfBrokers]
 * [Using SSL for transport security][UsingSSL]

## Configuring Transports

First you should configure transport for that each ActiveMQ will listen on, this is the configuration for the NOC node, you'd just mirror this setup on each ActiveMQ node.

{%highlight xml linenos %}
 <broker xmlns="http://activemq.org/config/1.0" brokerName="noc1-broker" useJmx="true"
      dataDirectory="${activemq.base}/data">

      <transportConnectors>
         <transportConnector name="openwire" uri="tcp://0.0.0.0:6166"/>
         <transportConnector name="stomp"   uri="stomp://0.0.0.0:6163"/>
      </transportConnectors>
{% endhighlight %}

 * *The _brokerName_ attribute is important and should be unique.* (Leaving it set to localhost will cause message loops to occur)
 * The _openwire_ transport is the important one here, you can make it listen on specific hosts and ports as shown.

## Connecting to other ActiveMQs

Next up you should configure the _networkConnectors_:

{%highlight xml linenos %}
    <networkConnectors>
       <networkConnector name="noc1-dc1amq1" uri="static:(tcp://192.168.1.10:6166)" userName="amq" password="Afuphohxoh" duplex="true"/>
    </networkConnectors>
{% endhighlight %}

Here we're connecting the NOC to Data Center 1.

 * The _name_ on each connector should be unique, I just list the pair of hostnames involved which should be unique.
 * This is a bi-directional connection it can send and receive traffic, you can make uni directional connections too if you wanted
 * We're authenticating with a username and password

There are many more options you can set on these connectors and it varies on your topology, you can make a ring of brokers or redundant meshes etc.

### Setting up Authentication

We have an [entire page dedicated][SecurityWithActiveMQ] to the subject of users and authentication, you should check that page out for full details but here's a simple bit of config for the authentication above.

{%highlight xml linenos %}
    <plugins>
      <simpleAuthenticationPlugin>
        <users>
          <authenticationUser username="amq" password="Afuphohxoh" groups="admins,everyone"/>
        </users>
      </simpleAuthenticationPlugin>
      <authorizationPlugin>
        <map>
          <authorizationMap>
            <authorizationEntries>
              <authorizationEntry queue=">" write="admins" read="admins" admin="admins" />
              <authorizationEntry topic=">" write="admins" read="admins" admin="admins" />
            </authorizationEntries>
          </authorizationMap>
        </map>
      </authorizationPlugin>
    </plugins>
  </broker>
{% endhighlight %}

You can now duplicate this on your other nodes, the NOC will have users and NetworkConnectors for the Data Center 2 as well, you can also flip it around so the DCs connect to the NOC which might be more secure.
