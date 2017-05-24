---
layout: default
title: ActiveMQ TLS
disqus: true
canonical: "/mcollective/reference/integration/activemq_ssl.html"
---
[Security]: http://activemq.apache.org/security.html
[Registration]: /mcollective1.2/reference/plugins/registration.html
[Wildcard]: http://activemq.apache.org/wildcards.html

# {{page.title}}

In order to achieve end to end encryption we use TLS encryption between
ActiveMQ, the nodes and the client.

To set this up you need to Java Keystore, the instructions here work for Java
1.6 either Sun or OpenJDK based.

## Create a keystore with existing certs

If you have an exiting PKI deployment, you can probably reuse Puppet ones too the main
point is that you already have a key and signed cert signed by some CA and you
now want to create a Java Keystore follow these steps:

{% highlight bash %}
# cat /etc/pki/host.key /etc/pki/ca.pem # /etc/pki/host.cert >cert.pem
# openssl pkcs12 -export -in cert.pem -out activemq.p12 -name `hostname`
# keytool -importkeystore -deststorepass secret -destkeypass secret -destkeystore keystore.jks -srckeystore activemq.p12 -srcstoretype PKCS12 -alias `hostname`
{% endhighlight %}

The above steps will create a standard Java keystore in _keystore.jks_ which you
should store in your ActiveMQ config directory.  It will have a password
_secret_ you should change this.

## Configure ActiveMQ

To let ActiveMQ load your keystore you should add the following to the
_activemq.xml_ file:

{% highlight xml %}
<sslContext>
   <sslContext keyStore="keystore.jks" keyStorePassword="secret" />
</sslContext>
{% endhighlight %}

And you should add a SSL stomp listener, you should get port 6164 opened:

{% highlight xml %}
<transportConnectors>
    <transportConnector name="openwire" uri="tcp://0.0.0.0:6166"/>
    <transportConnector name="stomp" uri="stomp://0.0.0.0:6163"/>
    <transportConnector name="stompssl" uri="stomp+ssl://0.0.0.0:6164"/>
</transportConnectors>
{% endhighlight %}

## Configure MCollective

The last step is to tell MCollective to use the SSL connection, to do this you
need to use the new pool based configuration, even if you just have 1 ActiveMQ
in your pool:

{% highlight ini %}
plugin.stomp.pool.size = 1
plugin.stomp.pool.host1 = stomp.your.com
plugin.stomp.pool.port1 = 6164
plugin.stomp.pool.user1 = mcollective
plugin.stomp.pool.password1 = secret
plugin.stomp.pool.ssl1 = true
{% endhighlight %}

You should now verify with tcpdump or wireshark that the connection and traffic
really is all encrypted.
