---
layout: default
title: Inventory Service
---

Inventory Service
======

Set up and begin using the inventory service with one or more puppet master servers. **This document refers to a feature currently under development.**

* * *

[authdotconf]: ./rest_auth_conf.html
[rest]: ./rest_api.html#facts
[storeconfigs]: http://projects.puppetlabs.com/projects/1/wiki/Using_Stored_Configuration

Puppet 2.6.7 adds support for maintaining, reading, and searching an inventory of nodes. This can be used to generate reports about the composition of your site, to drastically extend the capabilities of your external node classifier, and probably to do a lot of things we haven't even thought of yet. This service is designed as a _hackable public API._

Why
---

In order to compile and serve a catalog to an agent node, the puppet master has to collect a large amount of information about that node, in the form of Facter facts. If that info is written to a persistent store whenever it's collected, it suddenly becomes a fairly detailed inventory of every node that Puppet controls or has controlled at a given site! This can be tremendously useful: Imagine being able to instantly find out which computers are still running CentOS 4.5 and need to be upgraded, or which computers have less than a certain amount of physical memory, or what percentage of your current infrastructure is in the cloud on EC2 instances. Build a good enough interface to the inventory, and the data becomes _knowledge._ That knowledge can then drive other tools; for example, you could let your provisioning system or node classifier make decisions about new hardware based on the properties of the existing infrastructure. 

Several users have built custom inventory functionality by directly reading either the puppet master's YAML fact cache or the optional [storeconfigs][] database. But both of these approaches were non-optimal:

* The YAML cache is strictly local to one puppet master, and isn't an accurate inventory in multi-master environments. Furthermore, repeatedly deserializing YAML is terribly slow, which can cause real problems depending on the use case. (Searching by fact, in particular, is basically not an option.)
* Storeconfigs, on the other hand, is global to the site, but it's essentially a private API: Since the only officially supported use of it is for sharing exported resources, the only way to get fact data out of it is to read the database directly, and there's been no guarantee against the schema changing. Furthermore, storeconfigs is too heavyweight for users who just want an inventory, since it stores every resource and tag in each node's catalog in addition to the node's facts, and even the "thin" storeconfigs option stores a LOT of data. Implementing storeconfigs at a reasonable scale demands setting up a message queue, and even that extra infrastructure doesn't necessarily make it viable at a very large scale.

Thus, the Puppet inventory service: a relatively speedy implementation that does one thing well and exposes a public network API.

What It Is
-----

The _inventory_ is a collection of node facts. The _inventory service_ is a retrieval, storage, and search API exposed to the network by the puppet master. 

The puppet master updates the inventory when agent nodes report their facts, which happens every time puppet agent requests a catalog. Optionally, additional puppet masters can use the REST API to send facts from their agents to the central inventory. 

Other tools, including Puppet Dashboard, can query the inventory via the puppet master's REST API. An API call can return:

* Complete facts for a single node

or 

* A list of nodes whose facts meet some search condition

Information in the inventory is never automatically expired, but it is timestamped. 

### Consumers of the Inventory Service

The inventory service is primarily meant for external applications, and its data is not currently read by any part of Puppet. The only application which currently consumes the inventory data is Puppet Dashboard version 1.1.0, which can display facts in node views and provides a web interface for searching the inventory by fact.

Using the Inventory Service
-----

The inventory service is plain vanilla REST: Submit HTTP requests, get back structured fact or host data. 

To read from the inventory, submit secured HTTP requests to the puppet master's `facts` and `facts_search` REST endpoints in the appropriate environment. Your API client will have to have an SSL certificate signed by the puppet master's CA.

Full documentation of these endpoints can be found [here](http://docs.puppetlabs.com/guides/rest_api.html#facts), but a summary follows:

* To retrieve the facts for testnode.localdomain, send a GET request to <https://puppet:8140/production/facts/testnode.localdomain>. 
* To retrieve a list of all Ubuntu nodes with two or more processors, send a GET request to <https://puppet:8140/production/facts_search/search?facts.processorcount.ge=2&facts.operatingsystem=Ubuntu>. 

In both cases, be sure to specify an `Accept: pson` or `Accept: yaml` header.

Setting Up the Inventory Service
-----

### Configuring the Inventory Backend

The inventory service's backend is configured with the `facts_terminus` setting in the puppet master's section of `puppet.conf`.

#### For Prototyping: YAML

    [master]
        facts_terminus = yaml

You can actually start using the inventory service with the YAML backend immediately --- `yaml` is the default value for `facts_terminus`, and the YAML cache of any previously used puppet master will already be populated with fact information. Just configure access (see below) and you're good to go.

#### For Production: Database

    [master]
        facts_terminus = inventory_active_record
        dblocation = {sqlite file path (sqlite only)}
        dbadapter = {sqlite3|mysql|postgresql|oracle_enhanced}
        dbname = {database name (all but sqlite)}
        dbuser = {database user (all but sqlite)}
        dbpassword = {database password (all but sqlite)}
        dbserver = {database server (MySQL and PostgreSQL only)}
        dbsocket = {database socket file (MySQL only; optional)}

Before using the database facts backend, you'll have to fulfill a number of requirements: 

* Puppet master will need access to both a database and a user account with all privileges on that database; setting that up is outside the scope of this document. The database server can be remote or on the local host. 
* You'll need to ensure that the copy of Ruby in use by puppet master is able to communicate with your chosen type of database server. This will _always_ entail ensuring that Rails is installed, and will _likely_ require installing a specific Ruby library to interface with the database (e.g. the `libmysql-ruby` package on Debian and Ubuntu or the `mysql` gem on other operating systems). 

These requirements are essentially identical to those used by storeconfigs, so [the Puppet wiki page for storeconfigs][storeconfigs] can be helpful. Getting MySQL on the local host configured is very well-documented; other options, less so.

#### For Multiple Puppet Masters: REST

    [master]
        facts_terminus = rest
        inventory_server = {inventorying puppet master; defaults to "puppet"}
        inventory_port = 8140 (unless changed)

In addition to writing to its local YAML cache, any puppet master with a `facts_terminus` of `rest` will submit facts to another puppet master, which is hopefully using the `inventory_active_record` backend. 

### Configuring Access

By default, the inventory service is not accessible! This is sane. The inventory service exposes sensitive information about your infrastructure over the network, so you'll need to carefully control access with the [`rest_authconfig` (a.k.a. `auth.conf`)][authdotconf] file.

For prototyping your inventory application on a scratch puppet master, you can just permit all access to the `facts` endpoint:

    path /facts
    auth any
    method find, search
    allow *

(Note that this will allow access to both `facts` and `facts_search`, since the path is read as a prefix.)

For production deployment, you'll need to allow find and search access for your application, allow save access for any other puppet masters at your site (so they can submit their nodes' facts), and deny access to all other machines. (Since agent nodes submit their facts as part of their request to the `catalog` resource, they don't require access to the `facts` or `facts_search` resources.) One such possible ACL set would be:

    path /facts
    auth yes
    method find, search
    allow custominventorybrowser.puppetlabs.lan

    path /facts
    auth yes
    method save
    allow puppetmaster1.puppetlabs.lan, puppetmaster2.puppetlabs.lan, puppetmaster3.puppetlabs.lan

### Configuring Certificates

To connect your application securely, you'll need a certificate signed by your site's puppet CA. There are two main ways to get this: 

* **On the puppet master:** 
    * Run `puppet cert --generate {certname for application}`.
    * Then, retrieve the private key (`{ssldir}/certs/{certname}.pem`) and the signed certificate (`{ssldir}/private_keys/{certname}.pem`) and move them to your application server. 
* **Manually:** 
    * Generate an RSA private key: `openssl genrsa -out {certname}.pem 1024`.
    * Generate a certificate signing request (CSR): `openssl req -new -key {certname}.pem -subj "/CN={certname}" -out request.csr`.
    * Submit the CSR to the puppet master for signing: `curl -k -X PUT -H "Content-Type: text/plain" --data-binary @request.csr https://puppet:8140/production/certificate_request/no_key`.
    * Sign the certificate on the puppet master: `puppet cert --sign {certname}`.
    * Retrieve the certificate: `curl -k -H -o {certname}.pem "Accept: s" https://puppet:8140/production/certificate/{certname}`

For one-off applications, generating it on the master is obviously easier, but if you're building a tool for distribution elsewhere, your users will appreciate it if you script the manual method and emulate the way puppet agent gets a cert.

Protect your application's private key appropriately, since it's the gateway to your inventory data. 

In the event of a security breach, the application's certificate is revokable the same way any puppet agent certificate would be.

Testing the Inventory Service
-------

On a machine that you've authorized to access the facts and facts_search resources, you can test the API using `curl`, as described in the [REST API docs][rest]. To retrieve facts for a node:

    curl -k -H "Accept: yaml" https://puppet:8140/production/facts/{node certname}

To insert facts for a fictional node into the inventory:

    curl -k -X PUT -H 'Content-Type: text/yaml' --data-binary @/var/lib/puppet/yaml/facts/hostname.yaml https://puppet:8140/production/facts/{node certname}

To find out which nodes at your site are Intel Macs:

    curl -k -H "Accept: pson" https://puppet:8140/production/facts_search/search?facts.hardwaremodel=i386&facts.kernel=Darwin

