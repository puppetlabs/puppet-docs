---
layout: default
title: "PuppetDB 1.0.x FAQ"
subtitle: "Basic Info and Troubleshooting Tips"
canonical: "/puppetdb/latest/puppetdb-faq.html"
---


### Why is PuppetDB written in Java?

Actually, PuppetDB isn't written in Java at all! It's written in a language called Clojure, a dialect of Lisp that runs on the Java Virtual Machine. When PuppetDB was developed, other languages were prototyped, including Ruby and JRuby, but they lacked the necessary performance.  Instead, a JVM language was chosen because of its excellent libraries and high performance. Of the available JVM languages, we used Clojure because it was familiar and, mainly, because of its expressiveness and performance.

### Which versions of Java are supported?

The officially supported versions are OpenJDK and Oracle JDK, versions 1.6 and 1.7. Other versions may work, but support is not guaranteed. We will try to address issues on a best-effort basis.

### Which databases are supported?

For production use, we recommend PostgreSQL. PuppetDB also ships with an embedded HyperSQL database which can be used for very small or proof of concept deployments. As with our choice of language, we prototyped several
databases before settling on PostgreSQL. These included Neo4j, Riak, and MySQL with ActiveRecord in Ruby. At this time, there are no plans to support any other databases, including MySQL, which lacks necessary features such as array columns and recursive queries.

### Does PuppetDB support Puppet apply?

Partially. Use with `puppet apply` requires some special configuration, and due to limitations in Puppet, inventory service functionality isn't fully supported. However, catalog storage and collection queries are completely functional. You can find information about configuring `puppet apply` to work with PuppetDB in the installation guide for your version of PuppetDB.

### PuppetDB is complaining about a truststore or keystore file. What do I do?

There are several related causes for this (such as the common error of installing PuppetDB before the puppet agent has run for the first time), but they all boil down to PuppetDB being unable to read your truststore.jks or keystore.jks file. The truststore file contains the certificate for your certificate authority, and is used by PuppetDB to authenticate clients. The keystore file contains the key and certificate PuppetDB uses to identify itself to clients.

The locations of these files are set with the `keystore` and `truststore` options. For most users, these options are configured in the *jetty.ini* config file (if you are not using Puppet's default packages, or if you have modified the location of config data, you just need to find the section used for jetty configuration). 

There should also be settings for `key-password` and `trust-password`. Make sure the keystore.jks and truststore.jks files are where the config says they should be, and that they're readable by the user PuppetDB runs as (puppetdb for an open source installation, pe-puppetdb for a Puppet Enterprise installation). Additionally, you can verify that the password is correct using `keytool -keystore /path/to/keystore.jks` and and entering the `key-password`. Similarly, you can use `keytool -keystore /path/to/truststore.jks` to verify the truststore.

You can fix these problems by reinitializing the keystore and truststore, which is done by running `/usr/sbin/puppetdb-ssl-setup`. Note that this script must be run *after* a certificate has been generated for the puppet agent (that is, after the agent has run once and had its certificate request signed).  This script will repair the mis-configured keystores/truststores that are the result of installing Puppet DB before running the agent.

### The PuppetDB dashboard gives me a weird SSL error when I visit it. What gives?

There are two common error cases with the dashboard:

* You're trying to talk over plaintext (8080) and PuppetDB's not listening.

    By default, for security reasons, PuppetDB only listens for plaintext connections on localhost. In order to talk to it this way, you'll need to either
forward the plaintext port or change the interface PuppetDB binds on to one that is accessible from the outside world. In the latter case, you'll need to to secure PuppetDB by some other means (for instance, by restricting which hosts are allowed to talk to PuppetDB through a firewall).

* You're trying to talk over SSL and nobody trusts anybody else.

    Because PuppetDB uses the certificate authority of your Puppet infrastructure, and a certificate signed by it, PuppetDB doesn't trust your
browser, and your browser doesn't trust PuppetDB. In this case, you'll need to give your browser a certificate signed by your Puppet CA. Support for client certificates varies between browsers, so the preferred method is to connect over plaintext, as outlined above.

Either of these issues can also be solved through clever and judicious use of proxies, although the details of that are left as an exercise to the reader.

* * * 
