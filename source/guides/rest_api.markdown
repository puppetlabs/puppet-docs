REST API
==================

Both puppet master and puppet agent have RESTful API's that they use to communicate.
The basic structure of the url to access this API is

    https://yourpuppetmaster:8140/{environment}/{resource}/{key}
    https://yourpuppetclient:8139/{environment}/{resource}/{key}

Details about what resources are available and the formats they return are
below.

* * *

REST API Security
==================

Puppet usually takes care of [security] (./security.html) and SSL certificate
management for you, but if you want to use the RESTful API outside of that
you'll need to manage certificates yourself when you connect.  The easiest way
to do this is to have puppet agent already authorized with a certificate that has
been signed by the puppet master and use that certificate to connect, or for
testing to set the security policy so that any request from anywhere is
allowed.

The security policy for the API can be controlled through the [rest_authconfig]
(./security.html#authconf) file, and specifically for the nodes running puppet agent
through the [namespaceauth] (./security.html#namespaceauthconf) file.

Testing the REST API using curl
=================

An example of how you can use the REST API to retrieve the catalog for a node
can be seen using [curl] (http://en.wikipedia.org/wiki/CURL).

    curl --cert /etc/puppet/ssl/certs/mymachine.pem --key /etc/puppet/ssl/private_keys/mymachine.pem --cacert /etc/puppet/ssl/ca/ca_crt.pem -H 'Accept: yaml' https://puppetmaster:8140/production/catalog/mymachine

Most of this command is just setting the appropriate ssl certificates, which
will be different depending on your where your ssldir is and your node name.
For simplicity, lets look at this command without the certificate related
options, which I'll assume you're either passing in as above or changing the
[security policy] (./security.html) so that you don't need to be authenticated.
If you are changing the security policy curl will want a -k or --insecure
option to connect to an https address without certificates.

    curl --insecure -H 'Accept: yaml' https://puppetmaster:8140/production/catalog/mymachine

Basically we just send a header specifying the format or formats we want back,
and the RESTful URI for getting a catalog for mymachine in the production
environment.  Here's a snippet of the output you might get back:

    --- &id001 !ruby/object:Puppet::Resource::Catalog
      aliases: {}
        applying: false
          classes: []
          ...

Another example to get back the CA Certificate of the puppetmaster doesn't
require you to be authenticated with your own signed SSL Certificates, since
that's something you would need before you authenticate.

    curl --insecure -H 'Accept: s' https://puppetmaster:8140/production/certificate/ca

    -----BEGIN CERTIFICATE-----
    MIICHTCCAYagAwIBAgIBATANBgkqhkiG9w0BAQUFADAXMRUwEwYDVQQDDAxwdXBw

puppet master and puppet agent shared REST API Reference
==================
### Certificate
GET `/certificate/{ca, other}

    curl -k -H "Accept: s" https://puppetmaster:8140/production/certificate/ca
    curl -k -H "Accept: s" https://puppetcleint:8139/production/certificate/puppetclient

puppet master REST API Reference
==================

## Authenticated Resources (valid, signed certificate required)

### Catalogs
GET `/{environment}/catalog/{node certificate name}`

    curl -k -H "Accept: pson" https://puppetmaster:8140/production/catalog/myclient

### Certificate Revocation List
GET `/certificate_revocation_list/ca`

    curl -k -H "Accept: s" https://puppetmaster:8140/production/certificate/ca

### Certificate Request
GET `/{environment}/certificate_requests/{anything}`
GET `/{environment}/certificate_request/{node certificate name}

    curl -k -H "Accept: yaml" https://puppetmaster:8140/production/certificate_requests/all
    curl -k -H "Accept: yaml" https://puppetmaster:8140/production/certificate_request/puppetclient

### Reports - Submit a report
PUT `/{environment}/report/{node certificate name}`

    curl -k -X PUT -H "Content-Type: text/yaml" -d "{key:value}" https://puppetclient:8139/production/report/puppetclient

### File Server
GET `/file{metadata, content, bucket}/{file}`
File serving is covered in more depth on the [wiki]
(http://projects.puppetlabs.com/projects/puppet/wiki/File_Serving_Configuration)

### Node - Returns the Facts for the specified node
GET `/{environment}/node/{node certificate name}`

    curl -k -H "Accept: yaml" https://puppetmaster:8140/production/node/puppetclient

### Status - Just used for testing
GET `/{environment}/status/{anything}`

    curl -k -H "Accept: pson" https://puppetmaster:8140/production/certificate_request/puppetclient

puppet agent REST API Reference
==================

puppet agent is by default set not to listen to HTTP requests.  To enable this you
must set 'listen = true' in the puppet.conf or pass '--listen true' to puppet agent
when starting.  The [namespaceauth] (./security.html#namespaceauthconf) file must
also exist, and the [rest_authconfig] (./security.html#authconf) must allow
access to these resources, which isn't done by default.

### Facts
GET `/{environment}/facts/{anything}`

    curl -k -H "Accept: yaml" https://puppetclient:8139/production/facts/{anything}

### Run - Cause the client to update like puppetrun or puppet kick
PUT `/{environment}/run/{node certificate name}`

    curl -k -X PUT -H "Content-Type: text/pson" -d "{}" https://puppetclient:8139/production/run/{anything}
