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

The auth.conf file consists of a series of ACLs (Access Control Lists). 

Due to a known bug, trailing whitespace is not permitted after any line in auth.conf. 

### ACL format

Each auth.conf ACL is formatted as follows:

    path [~] {/path/to/resource|regex}
    [environment {list of environments}]
    [method {list of methods}]
    [auth[enthicated] {yes|no|on|off|any}]
    [allow {hostname|certname|*}]
    [deny {hostname|certname|*}]

Lists of environments, methods, and hosts are comma-separated, with an optional space after the comma. 

More than one allow or deny directive is allowed; this has the same effect as supplying one such directive with a comma-separated list of hostnames or certnames. The only globbing allowed in allow/deny directives is a single `*` that applies to all hosts; no subdomain globbing is available. Hosts cannot be allowed or denied by IP address. 

Paths are interpreted as either a path prefix (no tilde) or a regular expression (with tilde). 

#### Path Prefixes

    path /file

The path listed above will match both `/file_metadata` and
`/file_content` resources.

#### Regular Expression Paths

Regular expression paths don't have to match from the beginning of the resource path, though it's a good practice to use positional anchors. 

    path ~ ^/catalog/([^/]+)$
    method find
    allow $1

Using a regex in the path makes any captured groups available in the allow or deny directives. The ACL above will allow nodes to retrieve their own catalogs but prevent them from accessing other catalogs.


### Matching an ACL

When a request is received, ACLs are tested in their order of appearance in the file, and the authorization check will stop at the first ACL that matches the request. (As such, auth.conf has to be arranged with the _most_ specific paths at the top and the _least_ specific paths at the bottom, lest the whole search get short-circuited and the \[usually restrictive\] fallback rule applied to every request.)

An ACL is considered to match a request if their **resource path,** **environment(s),** **method(s),** and **authentication** match. Any of the latter three properties that are not specified are given a default value: `method` defaults to all methods if not specified, `environment` defaults to all environments if not specified, and `auth` defaults to authentication required if not specified. ACLs without a resource path are not permitted.

Resource path matches are described above; environment and method are both considered to match if the request's environment and method are members of the provided lists thereof. Authentication matching is self-explanatory. 

All four of these properties are equal peers in matching a request to an ACL; if any of them do not match the properties of the request, that ACL will not match. Once an ACL that matches the incoming request has been found, the request will be allowed if its hostname (if the connection is not authenticated) or certname (if the connection IS authenticated) matches an allow directive. Since the default behavior is to deny all hosts with the allow directive specifying exceptions to this rule, since the connection is governed by the first ACL to match it, and since the allow and deny directives play no part in the process of determining whether an ACL matches, **the deny directive is functionally inert and there is no reason to ever explicitly specify it.** If a given ACL allows `*` but denies a specific set of hosts, the `allow *` will be given precedence and all of the explicitly denied hosts will be allowed to connect. 


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

These default ACLs are appended to the ACLs found in auth.conf. Because ACL matching procedes linearly, **you must paste these ACLs at the top of your auth.conf if you are specifying _any_ ACLs that are less specific than any of the default ACLs.** Otherwise, incoming requests that must match the default ACLs in order for Puppet to function properly will instead be caught by a more general (and likely more restrictive) ACL. 

Danger Mode
-----------

If you want to test the REST API for application prototyping without worrying about specifying your final set of ACLs ahead of time, you can set a completely permissive auth.conf:

    path /
    auth any
    allow *

authconfig / namespaceauth.conf
-------------------------------

Older versions of Puppet communicated over an XMLRPC interface instead of the current RESTful interface, and access to these APIs was governed by a file known as `authconfig` (after the configuration option listing its location) or `namespaceauth.conf` (after its default filename). This legacy file will not be fully documented, but an example namespaceauth.conf file can be found in the puppet source in [conf/namespaceauth.conf](http://github.com/puppetlabs/puppet/blob/2.6.x/conf/namespaceauth.conf).

A [known bug](http://projects.puppetlabs.com/issues/6442) in the 2.6.x releases of Puppet prevents puppet agent from being started with the `listen = true` option unless namespaceauth.conf is present, even though the file is never consulted. The workaround is to create an empty file:

    # touch `puppet agent --configprint authconfig`
