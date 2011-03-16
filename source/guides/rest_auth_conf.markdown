---
layout: default
title: REST Access Control
---

REST Access Control
===================

Learn how to configure access to Puppet's REST API using the `rest_authconfig` file, a.k.a. `auth.conf`. **This document is currently being checked for accuracy. If you note any errors, please email them to <faq@puppetlabs.com>.**

* * *

REST
----

Puppet master and puppet agent communicate with each other over a [RESTful network API](./rest_api.html). By default, the usage of this API is limited to the standard types of master/agent communications. However, it can be exposed to other processes and used to build advanced tools on top of Puppet's existing infrastructure and functionality. (REST API calls are formatted as `https://{server}:{port}/{environment}/{resource}/{key}`.)


As you might guess, this can be turned into a security hazard, so access to the REST API is strictly controlled by a special configuration file.

auth.conf
---------

The official name of the file controlling REST API access, taken from the [configuration option](/references/latest/configuration.html) that sets its location, is `rest_authconfig`, but it's more frequently known by its default filename of `auth.conf`. If you don't set a different location for it, Puppet will look for the file at `$confdir/auth.conf`.

Format and Behavior
-------------------

The auth.conf file consists of a series of ACLs (Access Control Lists), each of which defines: 

* A resource path to which it applies
* An optional list of environments to which it applies
* An optional list of methods to which it applies
* Whether the requests it applies to are authenticated with SSL, unauthenticated, or either
* Whether the request should be allowed or denied, and the hostnames or IP addresses to which that directive applies

ACLs are tested in their order of appearance, and the authorization check will stop at the first ACL that matches the request. As such, auth.conf has to be arranged with the most specific paths at the top and the least specific paths at the bottom, lest the whole search get short-circuited and the (usually restrictive) fallback rule applied to every request. The resource path, environment(s), method(s), and authentication type are equal peers in matching a request; if any of them are present in a given ACL and do not match the properties of the request, that ACL will not match. 

Each auth.conf ACL is formatted as follows:

    path [~] {/path/to/resource|regex}
    [environment {list of environments}]
    [method {list of methods}]
    [auth[enthicated] {yes|no|on|off|any}]
    allow [host|ip|*]
    deny [host|ip]

Lists of environments, methods, and hosts are comma-separated. Authentication defaults to required if not specified, method defaults to all methods if not specified, and environment defaults to all environments if not specified. If neither allow or deny directives are supplied, the default is to deny. 

Paths are interpreted as either a path prefix (no tilde) or a regular expression (with tilde). 

### Path Prefixes

    path /file

The path listed above will match both /file_metadata and
/file_content.

### Regular Expression Paths

Regular expression paths don't have to match from the beginning of the resource path, though it's a good practice to use positional anchors. 

    path ~ ^/catalog/([^/]+)$
    method find
    allow $1

Using a regex in the path makes any captured groups available later in the ACL. The ACL above will allow nodes to retrieve their own catalogs but prevent them from accessing other catalogs.

Default ACLs
------------

Auth.conf doesn't exist by default, and if it isn't found, Puppet will institute sensible default settings. The following ACLs will be applied if they aren't overridden:

Allow authenticated nodes to retrieve their own catalogs:

    path ~ ^/catalog/([^/]+)$
    method find
    allow $1

Allow authenticated nodes to access any file services --- in practice, this results in fileserver.conf being consulted: 

    path /file
    allow *

Allow authenticated nodes to access the certificate revocation list:

    path /certificate_revocation_list/ca
    method find
    allow *

Allow authenticated nodes to send reports:

    path /report
    method save
    allow *

Allow unauthenticated access to certificates:

    path /certificate/ca
    auth no
    method find
    allow *

    path /certificate/
    auth no
    method find
    allow *

Allow unauthenticated nodes to submit certificate signing requests:

    path /certificate_request
    auth no
    method find, save
    allow *

Deny all other requests:

    path /
    auth any

An example auth.conf file containing these rules is provided in the Puppet source, in [conf/auth.conf](http://github.com/puppetlabs/puppet/blob/2.6.x/conf/auth.conf).

Danger Mode
-----------

If you want to test the REST API for application prototyping without worrying about specifying your final set of ACLs ahead of time, you can set a completely permissive auth.conf:

    path /
    auth no
    allow *

authconfig / namespaceauth.conf
-------------------------------

Older versions of Puppet communicated over an XMLRPC interface instead of the current RESTful interface, and access to these APIs was governed by a file known as `authconfig` (after the configuration option listing its location) or `namespaceauth.conf` (after its default filename). This legacy file will not be fully documented, but an example namespaceauth.conf file can be found in the puppet source in [conf/namespaceauth.conf](http://github.com/puppetlabs/puppet/blob/2.6.x/conf/namespaceauth.conf).

A [known bug](http://projects.puppetlabs.com/issues/6442) in the 2.6.x releases of Puppet prevents puppet agent from being started with the `listen = true` option unless namespaceauth.conf is present, even though the file is never consulted. The workaround is to create an empty file:

    # touch `puppet agent --configprint authconfig`
