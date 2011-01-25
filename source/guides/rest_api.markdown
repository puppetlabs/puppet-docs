---
layout: default
title: REST API
---

# REST API

Both puppet master and puppet agent have RESTful API's that they use to communicate.
The basic structure of the url to access this API is

    https://yourpuppetmaster:8140/{environment}/{resource}/{key}
    https://yourpuppetclient:8139/{environment}/{resource}/{key}

Details about what resources are available and the formats they return are
below.

## REST API Security

Puppet usually takes care of [security](./security.html) and SSL certificate
management for you, but if you want to use the RESTful API outside of that
you'll need to manage certificates yourself when you connect.  The easiest way
to do this is to have puppet agent already authorized with a certificate that has
been signed by the puppet master and use that certificate to connect, or for
testing to set the security policy so that any request from anywhere is
allowed.

The security policy for the API can be controlled through the 
[rest_authconfig](./security.html#authconf) file, and specifically for the 
nodes running puppet agent through the 
[namespaceauth](./security.html#namespaceauthconf) file.

## Testing the REST API using curl

An example of how you can use the REST API to retrieve the catalog for a node
can be seen using [curl](http://en.wikipedia.org/wiki/CURL).

    curl --cert /etc/puppet/ssl/certs/mymachine.pem --key /etc/puppet/ssl/private_keys/mymachine.pem --cacert /etc/puppet/ssl/ca/ca_crt.pem -H 'Accept: yaml' https://puppetmaster:8140/production/catalog/mymachine

Most of this command is just setting the appropriate ssl certificates, which
will be different depending on where your ssldir is and your node name.
For simplicity, lets look at this command without the certificate related
options, which I'll assume you're either passing in as above or changing the
[security policy](./security.html) so that you don't need to be authenticated.
If you are changing the security policy curl will want a -k or `--insecure`
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

## The master and agent shared API

### Certificate

Get a certficate or the master's CA certificate.

GET `/certificate/{ca, other}`

Example:

    curl -k -H "Accept: s" https://puppetmaster:8140/production/certificate/ca
    curl -k -H "Accept: s" https://puppetclient:8139/production/certificate/puppetclient

### Resources

Returns a list of resources, like executing `puppet resource` (`ralsh`) on the command line.

GET `/{environment}/resource/{resource_type}/{resource_name}`

GET `/{environment}/resources/{resource_type}`

Example:

    curl -k -H "Accept: yaml" https://puppetmaster:8140/production/resource/user/puppet
    curl -k -H "Accept: yaml" https://puppetclient:8139/production/resources/user

## The master REST API

A valid and signed certificate is required to retrieve these resourc

### Catalogs

Get a catalog from the node.

GET `/{environment}/catalog/{node certificate name}`

Example:

    curl -k -H "Accept: pson" https://puppetmaster:8140/production/catalog/myclient

### Certificate Revocation List

Get the certificate revocation list.

GET `/certificate_revocation_list/ca`

Example:

    curl -k -H "Accept: s" https://puppetmaster:8140/production/certificate/ca

### Certificate Request

Get the certificate requests.

GET `/{environment}/certificate_requests/{anything}`

GET `/{environment}/certificate_request/{node certificate name}`

Example:

    curl -k -H "Accept: yaml" https://puppetmaster:8140/production/certificate_requests/all
    curl -k -H "Accept: yaml" https://puppetmaster:8140/production/certificate_request/puppetclient

### Reports

Submit a report.

PUT `/{environment}/report/{node certificate name}`

Example:

    curl -k -X PUT -H "Content-Type: text/yaml" -d "{key:value}" https://puppetclient:8139/production/report/puppetclient

### Resource Types

Return a list of resources from the master

GET `/{environment}/resource_type/{hostclass,definition,node}`

GET `/{environment}/resource_types/*`

Example:

    curl -k -H "Accept: yaml" https://puppetmaster:8140/production/resource_type/puppetclient
    curl -k -H "Accept: yaml" https://puppetmaster:8140/production/resource_types/*

### File Bucket

Get or put a file into the file bucket.

GET `/{environment}/file_bucket_file/md5/{checksum}`

PUT `/{environment}/file_bucket_file/md5/{checksum}`

GET `/{environment}/file_bucket_file/md5/{checksum}?diff_with={checksum}` (diff 2 files: Puppet 2.6.5 and later)

HEAD /{environment}`/file_bucket_file/md5/{checksum}` (determine if a file is present: Puppet 2.6.5 and later)

Examples:

    curl -k -H "Accept: s" https://puppetmaster:8140/production/file_bucket_file/md5/e30d4d879e34f64e33c10377e65bbce6
    curl -k -X PUT -H "Content-Type: text/plain" Accept: s" https://puppetmaster:8140/production/file_bucket_file/md5/e30d4d879e34f64e33c10377e65bbce6 --data-binary @foo.txt
    curl -k -H "Accept: s" https://puppetmaster:8140/production/file_bucket_file/md5/e30d4d879e34f64e33c10377e65bbce6?diff_with=6572b5dc4c56366aaa36d996969a8885
    curl -k -I -H "Accept: s" https://puppetmaster:8140/production/file_bucket_file/md5/e30d4d879e34f64e33c10377e65bbce6

### File Server

Get a file from the file server.

GET `/file_{metadata, content}/{file}`

File serving is covered in more depth on the [wiki](http://projects.puppetlabs.com/projects/puppet/wiki/File_Serving_Configuration)

### Node

Returns the Facts for the specified node

GET `/{environment}/node/{node certificate name}`

Example:

    curl -k -H "Accept: yaml" https://puppetmaster:8140/production/node/puppetclient

### Status

Just used for testing

GET `/{environment}/status/{anything}`

Example:

    curl -k -H "Accept: pson" https://puppetmaster:8140/production/status/puppetclient

## The agent REST API

The puppet agent is by default set not to listen to HTTP requests.  To enable this you
must set `listen = true` in the puppet.conf or pass `--listen true` to puppet agent
when starting.  The [namespaceauth](./security.html#namespaceauthconf) file must
also exist, and the [rest_authconfig](./security.html#authconf) must allow
access to these resources, which isn't done by default.

### Facts

GET `/{environment}/facts/{anything}`

Example:

    curl -k -H "Accept: yaml" https://puppetclient:8139/production/facts/{anything}

### Run

Cause the client to update like puppetrun or puppet kick

PUT `/{environment}/run/{node certificate name}`

Example:

    curl -k -X PUT -H "Content-Type: text/pson" -d "{}" https://puppetclient:8139/production/run/{anything}
