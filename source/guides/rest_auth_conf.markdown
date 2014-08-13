---
layout: default
title: HTTP Access Control
---

HTTP Access Control
===================

Learn how to configure access to Puppet's HTTP API using the `rest_authconfig` file, a.k.a. `auth.conf`. **This document is currently being checked for accuracy. If you note any errors, please email them to <faq@puppetlabs.com>.**

* * *

HTTP
----

Puppet master and puppet agent communicate with each other over a pseudo-RESTful [HTTP network API](./rest_api.html). By default, the usage of this API is limited to the standard types of master/agent communications. However, it can be exposed to other processes and used to build advanced tools on top of Puppet's existing infrastructure and functionality. (HTTP API calls are formatted as `https://{server}:{port}/{environment}/{resource}/{key}`.)

As you might guess, this can be turned into a security hazard, so access to the HTTP API is strictly controlled by a special configuration file.

auth.conf
---------

The official name of the file controlling HTTP API access, taken from the [configuration option](/references/stable/configuration.html) that sets its location, is `rest_authconfig`, but it's more frequently known by its default filename of `auth.conf`. If you don't set a different location for it, Puppet will look for the file at `$confdir/auth.conf`.

You cannot configure different environments to use multiple `rest_authconfig` files.

File Format
-----------

The auth.conf file consists of a series of ACLs (Access Control Lists); ACLs should be separated by double newlines. Lines starting with `#` are interpreted as comments.

    # This is a comment
    path /facts
    method find, search
    auth yes
    allow custominventory.site.net, devworkstation.site.net

    # A more complicated rule
    path ~ ^/file_(metadata|content)/user_files/
    auth yes
    allow /^(.+\.)?example.com$/
    allow_ip 192.168.100.0/24

    # An exception allowing one authenticated workstation to access any endpoint
    path /
    auth yes
    allow devworkstation.site.net

Due to a known bug, trailing whitespace is not permitted after any line in auth.conf in versions prior to 2.7.3.

ACL format
----------

Each auth.conf ACL is formatted as follows:

    path [~] {/path/to/resource|regex}
    [environment {list of environments}]
    [method {list of methods}]
    [auth[enthicated] {yes|no|on|off|any}]
    [allow {hostname|certname|*}]

Lists of values are comma-separated, with an optional space after the comma.

### Path

An ACL's `path` is interpreted as either a regular expression (with tilde) or a path prefix (no tilde). The root of the path in an ACL is AFTER the environment in an HTTP API call URL; that is, only put the `/{resource}/{key}` portion of the URL in the path. ACLs without a resource path are not permitted.

### Environment

The `environment` directive can contain a single [environment](/puppet/latest/reference/environments.html) or a comma-separated list (spaces after commas OK). If environment isn't explicitly specified, it will default to all environments.

### Method

Available methods are `find`, `search`, `save`, and `destroy`; you can specify one method or a comma-separated list (spaces after commas OK). If method isn't explicitly specified, it will default to all methods.

### Auth

Whether the ACL matches authenticated requests.

- **`auth yes`** (or `on`) means this ACL will **only** match requests authenticated with an agent certificate.
- **`auth any`** means this ACL will match **both** authenticated and unauthenticated requests.
- **`auth no`** (or `off`) means this ACL will **only** match requests that are **not** authenticated with an agent certificate. Authenticated requests (like from puppet agent) will skip this ACL.

Most communications between puppet agent and the puppet master are authenticated, so you will usually be using `auth yes`.

The value of `auth` must be **one** of the above options; it cannot be a list. If auth isn't explicitly specified, it will default to `yes`.

### `allow`

The node or nodes allowed to access this type of request. Can be a hostname, a certificate common name, a comma-separated list of hostnames/certnames (spaces after commas OK), or `*` (which matches all nodes). If the path for this ACL was a regular expression, `allow` directives may include backreferences to captured groups (e.g. `$1`).

An ACL may include multiple `allow` directives, which has the same effect as a single `allow` directive with a comma-separated list.

**Behavior in 0.25.x through 2.7.0:** No fine-grained globbing of hostnames/certnames is available in allow directives; you must specify exact host/certnames, or a single asterisk that matches everything.

**Behavior in 2.7.1 and later:** Hostnames/certnames can also be specified by regular expression. Unlike with path directives, you don't need to use a tilde; just use the slash-quoting used in languages like Perl and Ruby (e.g. `allow /^[\w-]+.example.com$/`). Regular expression allow directives can include backreferences to regex paths with the standard `$1, $2` etc. variables.

Any nodes which aren't specifically allowed to access the resource will be denied.

### `allow_ip`

> **Note:** The `allow_ip` directive was added in Puppet 3.0.0. Previous versions of Puppet **cannot** allow nodes by IP address.

An IP address or range of IP addresses allowed to access this type of request. Can be:

* A single IP address
* A glob representing a group of IP addresses (e.g. `192.168.100.*`)
* CIDR notation representing a group of IP addresses (e.g. `192.168.100.0/24`)

Any nodes which aren't specifically allowed to access the resource will be denied.

### Deny

A `deny` directive is syntactically permitted, but has no effect.

Matching ACLs to Requests
-------------------------

Puppet composes a full list of ACLs by combining auth.conf with a list of default ACLs. When a request is received, ACLs are tested in their order of appearance, and **matching will stop at the first ACL that matches the request.**

An ACL matches a request only if its path, environment, method, and authentication **all** match that of the request. These four elements are equal peers in determining the match.

### Matching Paths

If an ACL's `path` does not start with a tilde and a space, it matches the beginning of the resource path; an ACL with the line:

    path /file

...will match both `/file_metadata` and `/file_content` resources.

Regular expression paths don't have to match from the beginning of the resource path, but it's good practice to use positional anchors.

    path ~ ^/catalog/([^/]+)$
    method find
    allow $1

Captured groups from a regex path are available in the allow directive. The ACL above will allow nodes to retrieve their own catalog but prevent them from accessing other catalogs.

### Determining Whether a Request is Allowed

Once an ACL has been determined to match an incoming request, Puppet consults the `allow` directive(s). If the request was unauthenticated, reverse DNS is used to determine the requesting node's hostname; the request is allowed if that hostname is allowed. If the request was authenticated, the certificate common name is read from the SSL certificate, and the hostname is ignored; the request is allowed if that certname is allowed.

Consequences of ACL Matching Behavior
-------------------------------------

Since ACLs are matched in linear order, auth.conf has to be manually arranged with the most specific paths at the top and the least specific paths at the bottom, lest the whole search get short-circuited and the (usually restrictive) fallback rule be applied to every request. Furthermore, since the default ACLs required for normal Puppet functionality are appended to the ACLs read from auth.conf, **you must manually interleave copies of the default ACLs into your auth.conf if you are specifying _any_ ACLs that are less specific than any of the default ACLs.**

Default ACLs
------------

Puppet appends a list of default ACLs to the ACLs read from auth.conf. However, if any custom ACLs have a path identical to that of a default ACL, that default ACL will be omitted when composing the full list of ACLs. **Note that this is not the same criteria for determining whether the two ACLs match the same requests,** as only the paths are compared:

    # A custom ACL
    path /file
    auth no
    allow magpie.example.com

    # This default ACL will not be appended to the rules
    path /file
    allow *

These two ACLs match completely disjoint sets of requests (unauthenticated for the custom one, authenticated for the default one), but since the mechanism that appends default ACLs is not examining the authentication/methods/environments of the ACLs, it considers the one to override the other, even though they're effectively unrelated. Puppet agent will break if you only declare the custom ACL, will work if you manually declare the default ACL, and will work if you only declare the custom one but change its path to `/fil`. When in doubt, manually re-declare all default ACLs in your auth.conf file.

The following is a list of the default ACLs used by Puppet:

    # Allow authenticated nodes to retrieve their own catalogs:

    path ~ ^/catalog/([^/]+)$
    method find
    allow $1

    # allow nodes to retrieve their own node definition

    path ~ ^/node/([^/]+)$
    method find
    allow $1

    # Allow authenticated nodes to access any file services --- in practice, this results in fileserver.conf being consulted:

    path /file
    allow *

    # Allow authenticated nodes to access the certificate revocation list:

    path /certificate_revocation_list/ca
    method find
    allow *

    # Allow authenticated nodes to send reports:

    path /report
    method save
    allow *

    # Allow unauthenticated access to certificates:

    path /certificate/ca
    auth no
    method find
    allow *

    path /certificate/
    auth no
    method find
    allow *

    # Allow unauthenticated nodes to submit certificate signing requests:

    path /certificate_request
    auth no
    method find, save
    allow *

    # Deny all other requests:

    path /
    auth any

An example auth.conf file containing these rules is provided in the Puppet source, in [conf/auth.conf](http://github.com/puppetlabs/puppet/blob/2.6.x/conf/auth.conf).

Danger Mode
-----------

If you want to test the HTTP API for application prototyping without worrying about specifying your final set of ACLs ahead of time, you can set a completely permissive auth.conf:

    path /
    auth any
    allow *

**Note** Make sure any testing configurations using this pattern do not make it to production systems.

authconfig / namespaceauth.conf
-------------------------------

Older versions of Puppet communicated over an XMLRPC interface instead of the current HTTP interface, and access to these APIs was governed by a file known as `authconfig` (after the configuration option listing its location) or `namespaceauth.conf` (after its default filename). This legacy file will not be fully documented, but an example namespaceauth.conf file can be found in the puppet source at [conf/namespaceauth.conf](http://github.com/puppetlabs/puppet/blob/2.6.x/conf/namespaceauth.conf).

puppet agent and the HTTP API
-----------------------------

If started with the `listen = true` configuration option, puppet agent will accept incoming HTTP API requests. This is most frequently used to trigger puppet runs with the `run` endpoint. Several caveats apply:

* A [known bug](http://projects.puppetlabs.com/issues/6442) in the 2.6.x releases of Puppet prevents puppet agent from being started with the `listen = true` option unless namespaceauth.conf is present, even though the file is never consulted. The workaround is to create an empty file: `# touch $(puppet agent --configprint authconfig)`
* Puppet agent uses the same default ACLs as puppet master, which allow access to several useless endpoints while denying access to any agent-specific ones. For best results, you should short-circuit the defaults by denying access to `/` at the end of your auth.conf file.
