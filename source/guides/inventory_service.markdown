---
layout: default
title: Inventory Service
---


[puppetdb]: /puppetdb/latest/
[puppetdb_install]: /puppetdb/latest/install_via_module.html
[puppetdb_connect]: /puppetdb/latest/connect_puppet_master.html
[puppetdb_api]: /puppetdb/latest/api/index.html
[authdotconf]: ./rest_auth_conf.html
[rest]: ./rest_api.html#facts
[old_storeconfigs]: http://projects.puppetlabs.com/projects/1/wiki/Using_Stored_Configuration
[facts]: /puppet/latest/reference/lang_variables.html#facts-and-built-in-variables
[exported]: /puppet/latest/reference/lang_exported.html



> The Inventory Service is Deprecated!
> -----
>
> The inventory service is deprecated and will be removed in Puppet 4.0.
>
> We're removing it because [PuppetDB][] does the same job, many times better. If you're doing anything with the inventory service, switching to PuppetDB will let you do it faster, easier, and more reliably. For more information, see:
>
> * [Installing PuppetDB][puppetdb_install]
> * [Overview of the PuppetDB API][puppetdb_api]
>
> The parts of Puppet that will be removed as part of the inventory service deprecation are:
>
> * The puppet master server's `facts` and `facts_search` HTTP endpoints
> * The `inventory_active_record` terminus for the `facts` indirection
> * The `puppet facts upload` and `puppet facts find --terminus rest` commands


About the Inventory Service
-----

Starting with Puppet 2.6.7, puppet master servers offer API access to the [facts][] reported by every node. You can use this API to get complete info about any node, and to search for nodes whose facts meet certain criteria.

* Puppet Dashboard and Puppet Enterprise's console use the inventory service to provide a search function and display each node's complete facts on the node's page. (PE does this by default. [See here for instructions on activating Dashboard's inventory support](/dashboard/manual/1.2/configuring.html#enabling-inventory-support).)
* Your own custom applications can access any node's facts via the inventory service.


What It Is
-----

The _inventory_ is a collection of node facts. The _inventory service_ is a retrieval, storage, and search API exposed to the network by the puppet master. The _inventory service backend_ (AKA the `facts_terminus`) is what the puppet master uses to store the inventory and do some of the heavy lifting of the inventory service.

The puppet master updates the inventory when agent nodes report their facts, which happens every time puppet agent requests a catalog. Optionally, additional puppet masters can use the HTTP API to send facts from their agents to the central inventory.

Other tools, including Puppet Dashboard, can query the inventory via the puppet master's HTTP API. An API call can return:

* Complete facts for a single node

or

* A list of nodes whose facts meet some search condition

Information in the inventory is never automatically expired, but it is timestamped.

Using the Inventory Service
-----

The inventory service is plain vanilla HTTP: Submit HTTP requests, get back structured fact or host data.

To read from the inventory, submit secured HTTP requests to the puppet master's `facts` and `facts_search` HTTP endpoints in the appropriate environment. Your API client will have to have an SSL certificate signed by the puppet master's CA.

Full documentation of these endpoints can be found [here](/guides/rest_api.html#facts), but a summary follows:

* To retrieve the facts for testnode.example.com, send a GET request to <https://puppet:8140/production/facts/testnode.example.com>.
* To retrieve a list of all Ubuntu nodes with two or more processors, send a GET request to <https://puppet:8140/production/facts_search/search?facts.processorcount.ge=2&facts.operatingsystem=Ubuntu>.

In both cases, be sure to specify an `Accept: pson` or `Accept: yaml` header.

Setting Up the Inventory Service
-----

### Configuring the Inventory Backend

There are two inventory service backends available: PuppetDB and `inventory_active_record`.

* If you are using Puppet 2.7.12 or later, **use PuppetDB.** It is faster, easier to configure and maintain, and also provides catalog storage and searching for [exported resources][exported]. Follow the installation and configuration instructions in the PuppetDB manual, and connect every puppet master to your PuppetDB server:
    * [Install PuppetDB][puppetdb_install]
    * [Connect a puppet master to PuppetDB][puppetdb_connect]
* If you are using an older version of Puppet, you can use the `inventory_active_record` backend and connect your other puppet masters to the designated inventory master. [See the appendix below to enable this backend](#appendix-enabling-the-inventoryactiverecord-backend).
    * You can upgrade to PuppetDB at a later date after upgrading Puppet; since a node's facts are replaced every time it checks in, PuppetDB should have the same data as your old inventory in a matter of hours.


### Configuring Access

By default, the inventory service is not accessible! This is a reasonable default. Because the inventory service exposes sensitive information about your infrastructure over the network, you'll need to carefully control access with the [`rest_authconfig` (a.k.a. `auth.conf`)][authdotconf] file.

For prototyping your inventory application on a scratch puppet master, you can just permit all access to the `facts` endpoint:

    path /facts
    auth any
    method find, search
    allow *

(Note that this will allow access to both `facts` and `facts_search`, since the path is read as a prefix.)

For production deployment, you'll need to allow find and search access for each application that uses the inventory and deny access to all other machines. (Since agent nodes submit their facts as part of their request to the `catalog` resource, they don't require access to the `facts` or `facts_search` resources.) One such possible ACL set would be:

    path /facts
    auth yes
    method find, search
    allow dashboard.example.com, custominventoryapp.example.com

### Configuring Certificates

To connect your application securely, you'll need a certificate signed by your site's puppet CA. There are two main ways to get this:

* **On the puppet master:**
    * Run `puppet cert --generate {certname for application}`.
    * Then, retrieve the private key (`{ssldir}/certs/{certname}.pem`) and the signed certificate (`{ssldir}/private_keys/{certname}.pem`) and move them to your application server.
* **Manually:**
    * Generate an RSA private key: `openssl genrsa -out {certname}.key 1024`.
    * Generate a certificate signing request (CSR): `openssl req -new -key {certname}.key -subj "/CN={certname}" -out request.csr`.
    * Submit the CSR to the puppet master for signing: `curl -k -X PUT -H "Content-Type: text/plain" --data-binary @request.csr https://puppet:8140/production/certificate_request/new`.
    * Sign the certificate on the puppet master: `puppet cert --sign {certname}`.
    * Retrieve the certificate: `curl -k -H "Accept: s" -o {certname}.pem https://puppet:8140/production/certificate/{certname}`

For one-off applications, generating it on the master is obviously easier, but if you're building a tool for distribution elsewhere, your users will appreciate it if you script the manual method and emulate the way puppet agent gets a cert.

Protect your application's private key appropriately, since it's the gateway to your inventory data.

In the event of a security breach, the application's certificate is revokable the same way any puppet agent certificate would be.

Testing the Inventory Service
-------

On a machine that you've authorized to access the facts and facts_search resources, you can test the API using `curl`, as described in the [HTTP API docs][rest]. To retrieve facts for a node:

    curl -k -H "Accept: yaml" https://puppet:8140/production/facts/{node certname}

To insert facts for a fictional node into the inventory:

    curl -k -X PUT -H 'Content-Type: text/yaml' --data-binary @/var/lib/puppet/yaml/facts/hostname.yaml https://puppet:8140/production/facts/{node certname}

To find out which nodes at your site are Intel Macs:

    curl -k -H "Accept: pson" https://puppet:8140/production/facts_search/search?facts.hardwaremodel=i386&facts.kernel=Darwin


Appendix: Enabling the `inventory_active_record` Backend
-----

The `inventory_active_record` backend works on older puppet masters, all the way back to Puppet 2.6.7. It has reasonable speed, but is generally inferior to [PuppetDB][], on account of being slightly slower and more difficult to configure.

Unlike PuppetDB, this backend splits your puppet masters into two groups, which must be configured differently:

* The designated inventory puppet master must be configured to access a database. (If you site only has one puppet master, this is it.)
* Every other puppet master must be configured to access the designated inventory puppet master.

### Configuring the Inventory Puppet Master

#### Step 1: Create a Database and User

The inventory puppet master will need access to both a **database** and a **user account with all privileges on that database;** setting that up is outside the scope of this document. The database server can be remote or on the local host.

Since database access is mediated by the common ActiveRecord library, you can, in theory, use any local or remote database supported by Rails. In practice, MySQL on the same server as the puppet master is the best-documented approach. See [the documentation for the legacy ActiveRecord storeconfigs backend][old_storeconfigs] for more details about setting up and configuring a database with Puppet.

Do not use sqlite except as a proof of concept. It is slow and unreliable.

#### Step 2: Install the Appropriate Ruby Database Adapter

The copy of Ruby in use by puppet master will need to be able to communicate with your chosen type of database server. This will _always_ entail ensuring that Rails is installed, and will _likely_ require installing a specific Ruby library to interface with the database (e.g. the `libmysql-ruby` package on Debian and Ubuntu or the `mysql` gem on other operating systems). As above, [see the old ActiveRecord storeconfigs docs][old_storeconfigs] for more help.

#### Step 3: Edit puppet.conf

Set the following settings in your inventory master's puppet.conf:

    [master]
        facts_terminus = inventory_active_record
        dblocation = {sqlite file path (sqlite only)}
        dbadapter = {sqlite3|mysql|postgresql|oracle_enhanced}
        dbname = {database name (all but sqlite)}
        dbuser = {database user (all but sqlite)}
        dbpassword = {database password (all but sqlite)}
        dbserver = {database server (MySQL and PostgreSQL only)}
        dbsocket = {database socket file (MySQL only; optional)}

Note that some of these are only necessary for certain databases. As above, [see the old ActiveRecord storeconfigs docs][old_storeconfigs] for more help.

#### Step 4: Edit auth.conf (multiple masters only)

Since your other puppet masters will be sending node facts to the designated inventory master, you will need to give each of them `save` access to the `facts` HTTP endpoint.

    path /facts
    auth yes
    method save
    allow puppetmaster1.example.com, puppetmaster2.example.com, puppetmaster3.example.com

### Configuring Other Puppet Masters

Edit puppet.conf on every other puppet master to contain the following:

    [master]
        facts_terminus = inventory_service
        inventory_server = {designated inventory master; defaults to "puppet"}
        inventory_port = 8140

