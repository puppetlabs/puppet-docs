---
layout: default
title: HTTP API
---

HTTP API
========

Both puppet master and puppet agent have pseudo-RESTful HTTP API's that they use to communicate.
The basic structure of the url to access this API is

    https://yourpuppetmaster:8140/{environment}/{resource}/{key}
    https://yourpuppetclient:8139/{environment}/{resource}/{key}

Details about what resources are available and the formats they return are
below.

## HTTP API Security

Puppet usually takes care of security and SSL certificate
management for you, but if you want to use the HTTP API outside of that
you'll need to manage certificates yourself when you connect. This can be done by using
a pre-existing signed agent certificate, by generating and signing a certificate on the puppet
master and manually distributing it to the connecting host, or by re-implementing puppet
agent's generate / submit signing request / received signed certificate behavior in your custom app.

The security policy for the HTTP API can be controlled through the
[`rest_authconfig`][authconf] file. For testing purposes, it is also possible to
permit unauthenticated connections from all hosts or a subset of hosts; see the
[`rest_authconfig` documentation][authconf] for more details.

[authconf]: ./rest_auth_conf.html

## Testing the HTTP API using curl

An example of how you can use the HTTP API to retrieve the catalog for a node
can be seen using [curl](http://en.wikipedia.org/wiki/CURL).

    curl --cert /etc/puppet/ssl/certs/mymachine.pem --key /etc/puppet/ssl/private_keys/mymachine.pem --cacert /etc/puppet/ssl/ca/ca_crt.pem -H 'Accept: yaml' https://puppetmaster:8140/production/catalog/mymachine

Most of this command consists of pointing curl to the appropriate SSL certificates, which
will be different depending on your ssldir location and your node's certname.
For simplicity and brevity, future invocations of curl will be provided in insecure mode, which
is specified with the `-k` or `--insecure` flag.
Insecure connections can be enabled for one or more nodes in the [`rest_authconfig`][authconf]
file. The above curl invocation without certificates would be as follows:

    curl --insecure -H 'Accept: yaml' https://puppetmaster:8140/production/catalog/mymachine

Basically we just send a header specifying the format or formats we want back,
and the HTTP URI for getting a catalog for mymachine in the production
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

### Resources

Returns a list of resources, like executing `puppet resource` (`ralsh`) on the command line.

GET `/{environment}/resource/{resource_type}/{resource_name}`

GET `/{environment}/resources/{resource_type}`

Example:

    curl -k -H "Accept: yaml" https://puppetmaster:8140/production/resource/user/puppet
    curl -k -H "Accept: yaml" https://puppetclient:8139/production/resources/user

### Certificate

Get a certficate or the master's CA certificate.

GET `/certificate/{ca, other}`

Example:

    curl -k -H "Accept: s" https://puppetmaster:8140/production/certificate/ca
    curl -k -H "Accept: s" https://puppetclient:8139/production/certificate/puppetclient

## The master HTTP API

A valid and signed certificate is required to retrieve these resources.

### Catalogs

Get a catalog from the node.

GET `/{environment}/catalog/{node certificate name}`

Example:

    curl -k -H "Accept: pson" https://puppetmaster:8140/production/catalog/myclient

### Certificate Revocation List

Get the certificate revocation list.

GET `{environment}/certificate_revocation_list/ca`

Example:

    curl -k -H "Accept: s" https://puppetmaster:8140/production/certificate_revocation_list/ca

### Certificate Request

Retrieve or save certificate requests.

GET `/{environment}/certificate_requests/no_key`

GET `/{environment}/certificate_request/{node certificate name}`

PUT `/{environment}/certificate_request/no_key`

Example:

    curl -k -H "Accept: yaml" https://puppetmaster:8140/production/certificate_requests/all
    curl -k -H "Accept: yaml" https://puppetmaster:8140/production/certificate_request/{agent certname}
    curl -k -X PUT -H "Content-Type: text/plain" --data-binary @cert_request.csr https://puppetmaster:8140/production/certificate_request/no_key


To manually generate a CSR from an existing private key:

    openssl req -new -key private_key.pem -subj "/CN={node certname}" -out request.csr

The subject can only include a /CN=, nothing else. Puppet master will determine the certname from the body of the cert, so the request can be pointed to any key for this endpoint.

### Certificate Status

**Puppet 2.7.0 and later.**

Read or alter the status of a certificate or pending certificate request. This endpoint is roughly equivalent to the puppet cert command; rather than returning complete certificates, signing requests, or revocation lists, this endpoint returns information about the various certificates (and potential and former certificates) known to the CA.

GET `/{environment}/certificate_status/{certname}`

Retrieve a PSON hash containing information about the specified host's
certificate. Similar to `puppet cert --list {certname}`.

GET `/{environment}/certificate_statuses/no_key`

Retrieve a list of PSON hashes containing information about all
known certificates. Similar to `puppet cert --list --all`.

PUT `/{environment}/certificate_status/{certname}`

Change the status of the specified host's certificate. The desired state is sent in the body of the PUT request as a one-item PSON hash; the two allowed complete hashes are `{"desired_state":"signed"}` (for signing a certificate signing request; similar to `puppet cert --sign`) and `{"desired_state":"revoked"}` (for revoking a certificate; similar to `puppet cert --revoke`); see examples below for details.

When revoking certificates, you may wish to use a
DELETE request instead, which will also clean up other info about the
host.

DELETE `/{environment}/certificate_status/{hostname}`

Cause the certificate authority to discard all SSL information regarding a host (including
any certificates, certificate requests, and keys). This **does not** revoke the certificate if one is present; if you wish to emulate the behavior of `puppet cert --clean`, you must PUT a `desired_state` of revoked before deleting the host's SSL information.

Examples:

    curl -k -H "Accept: pson" https://puppetmaster:8140/production/certificate_status/testnode.localdomain
    curl -k -H "Accept: pson" https://puppetmaster:8140/production/certificate_statuses/all
    curl -k -X PUT -H "Content-Type: text/pson" --data '{"desired_state":"signed"}' https://puppetmaster:8140/production/certificate_status/client.network.address
    curl -k -X PUT -H "Content-Type: text/pson" --data '{"desired_state":"revoked"}' https://puppetmaster:8140/production/certificate_status/client.network.address
    curl -k -X DELETE -H "Accept: pson" https://puppetmaster:8140/production/certificate_status/client.network.address

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

GET `/{environment}/file_bucket_file/md5/{checksum}?diff_with={checksum}` (diff 2 files; **Puppet 2.6.5 and later**)

HEAD `/{environment}/file_bucket_file/md5/{checksum}` (determine if a file is present; **Puppet 2.6.5 and later**)

Examples:

    curl -k -H "Accept: s" https://puppetmaster:8140/production/file_bucket_file/md5/e30d4d879e34f64e33c10377e65bbce6
    curl -k -X PUT -H "Content-Type: text/plain" Accept: s" https://puppetmaster:8140/production/file_bucket_file/md5/e30d4d879e34f64e33c10377e65bbce6 --data-binary @foo.txt
    curl -k -H "Accept: s" https://puppetmaster:8140/production/file_bucket_file/md5/e30d4d879e34f64e33c10377e65bbce6?diff_with=6572b5dc4c56366aaa36d996969a8885
    curl -k -I -H "Accept: s" https://puppetmaster:8140/production/file_bucket_file/md5/e30d4d879e34f64e33c10377e65bbce6

### File Server

Get a file from the file server.

GET `/file_{metadata, content}/{file}`

File serving is covered in more depth in the [fileserver configuration documentation](/guides/file_serving.html)

### Node

Returns the Puppet::Node information (including facts) for the specified node

GET `/{environment}/node/{node certificate name}`

Example:

    curl -k -H "Accept: yaml" https://puppetmaster:8140/production/node/puppetclient

### Status

Just used for testing

GET `/{environment}/status/no_key`

Example:

    curl -k -H "Accept: pson" https://puppetmaster:8140/production/status/puppetclient

### Facts

GET `/{environment}/facts/{node certname}`

    curl -k -H "Accept: yaml" https://puppetmaster:8140/production/facts/{node certname}

PUT `/{environment}/facts/{node certname}`

    curl -k -X PUT -H 'Content-Type: text/yaml' --data-binary @/var/lib/puppet/yaml/facts/hostname.yaml https://localhost:8140/production/facts/{node certname}


### Facts Search

GET `/{environment}/facts_search/search?{facts search string}`

    curl -k -H "Accept: pson" https://puppetmaster:8140/production/facts_search/search?facts.processorcount.ge=2&facts.operatingsystem=Ubuntu

Facts search strings are constructed as a series of terms separated by `&`; if there is more than one term, the search combines the terms with boolean AND. There is currently no API for searching with boolean OR. Each term is composed as follows:

    facts.{name of fact}.{comparison type}={string for comparison}

If you leave off the `.{comparison type}`, the comparison will default to simple equality. The following comparison types are available:

#### String/general comparison

* `eq` --- `==` (default)
* `ne` --- `!=`

#### Numeric comparison

* `lt` --- `<`
* `le` --- `<=`
* `gt` --- `>`
* `ge` --- `>=`

## The agent HTTP API

By default, puppet agent is set not to listen to HTTP requests.  To enable this you
must set `listen = true` in the puppet.conf or pass `--listen true` to puppet agent
when starting. Due to a known bug in the 2.6.x releases of Puppet, puppet agent will not start
with `listen = true` unless a namespaceauth.conf file exists, even though this file
is not consulted. The node's [rest_authconfig][authconf] file must also allow
access to the agent's resources, which isn't permitted by default.

### Facts

GET `/{environment}/facts/no_key`

Example:

    curl -k -H "Accept: yaml" https://puppetclient:8139/production/facts/no_key

### Run

Cause the client to update like puppetrun or puppet kick

PUT `/{environment}/run/no_key`

Example:

    curl -k -X PUT -H "Content-Type: text/pson" -d "{}" https://puppetclient:8139/production/run/no_key
