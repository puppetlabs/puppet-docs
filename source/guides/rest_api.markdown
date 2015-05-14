---
layout: default
title: HTTP API
---

The current HTTP API docs

HTTP API
========

Puppet Agents use various network services which the Puppet Master provides in order to manage systems. Other systems can access these services in order to put the information that the Puppet master has to use. For more about more Puppet's API, refer to the following:

* [The current Puppet API docs](/puppet/latest/reference/http_api/http_api_index.html)
* [The Puppet 3.8 API docs](https://github.com/puppetlabs/puppet/blob/3.8.0/api/docs/http_api_index.md)

## Testing the HTTP API using curl

An example of how you can use the HTTP API to retrieve the catalog for a node
can be seen using [curl](http://en.wikipedia.org/wiki/CURL).

~~~
curl --cert /etc/puppetlabs/puppet/ssl/certs/mymachine.pem --key /etc/puppetlabs/puppet/ssl/private_keys/mymachine.pem --cacert /etc/puppetlabs/puppet/ssl/ca/ca_crt.pem -H 'Accept: pson' https://puppetmaster:8140/puppet/v3/catalog/mymachine?environment=production
~~~

Most of this command consists of pointing curl to the appropriate SSL certificates, which
will be different depending on your ssldir location and your node's certname.
