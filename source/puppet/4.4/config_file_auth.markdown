---
layout: default
title: "Config Files: auth.conf (LEGACY)"
canonical: "/puppet/latest/config_file_auth.html"
---

[rest_authconfig]: ./configuration.html#restauthconfig
[api]: ./http_api/http_api_index.html
[default_file]: https://github.com/puppetlabs/puppet/blob/4.3.0/conf/auth.conf
[environment]: ./environments.html
[server_ca]: {{puppetserver}}/config_file_ca.html
[server_master]: {{puppetserver}}/config_file_master.html
[server_auth_conf]: {{puppetserver}}/config_file_auth.html
[puppetserver.conf]: {{puppetserver}}/config_file_puppetserver.html
[Puppet Server]: {{puppetserver}}/
[confdir]: ./dirs_confdir.html


Access to Puppet's HTTPS API is configured in `auth.conf`.

> ## **Important:** This is a deprecated config file
>
> Puppet Server has a [new HOCON-formatted `auth.conf` file][server_auth_conf], which is a full replacement for the old `auth.conf` format described on this page. The old `auth.conf` file will be removed in Puppet 5.0.
>
> Until then, Puppet Server uses a combination of the new `auth.conf` file and this legacy `auth.conf` file:
>
> * For most `/puppet/v3` endpoints, it defaults to the **legacy `auth.conf`.**
>     * You can completely switch to the new `auth.conf` by setting [puppetserver.conf][] > `jruby-puppet` > `use-legacy-auth-conf: false`.
> * For `certificate_status` and `puppet-admin-api`, it uses the **new `auth.conf`.**
>     * However, it will use the old `client-whitelist` settings instead if they're present.
> * For most `/puppet-ca/v1` endpoints and any new `/puppet/v3` endpoints added during the Puppet Server 2.x series, it only uses the **new `auth.conf`.**
>
> The default location of the new `auth.conf` is `/etc/puppetlabs/puppetserver/conf.d/auth.conf`. See [the Puppet Server `auth.conf` docs][server_auth_conf] for details.


## About Puppet's HTTPS API

(For full details about Puppet's HTTPS API, see [the API reference][api].)

The Puppet agent service requests configurations over HTTPS, and the Puppet master application provides several HTTPS endpoints to support this. (For example, requesting a catalog uses a different endpoint than submitting a report.) There are also a few endpoints that aren't used by Puppet agent.

Since some endpoints should have restricted access (for example, a node shouldn't request another node's configuration catalog), the Puppet master has a list of access rules for all of its HTTPS services. You can edit these rules in `auth.conf`.

## Location

The `auth.conf` file is located at `$confdir/auth.conf` by default. Its location is configurable with the [`rest_authconfig` setting][rest_authconfig].

The location of the `confdir` depends on your OS. [See the confdir documentation for details.][confdir]

## Example

~~~
path /puppet/v3/environments
method find
allow *

# allow nodes to retrieve their own catalog
path ~ ^/puppet/v3/catalog/([^/]+)$
method find
allow $1

# allow nodes to retrieve their own node definition
path ~ ^/puppet/v3/node/([^/]+)$
method find
allow $1

# allow all nodes to store their own reports
path ~ ^/puppet/v3/report/([^/]+)$
method save
allow $1

# control access to the custom user_files mount point
path ~ ^/puppet/v3/file_(metadata|content)s?/user_files/
auth yes
allow *.example.com
allow_ip 192.168.100.0/24

# Allow all nodes to access all file services.
path /puppet/v3/file
allow *

path /puppet/v3/status
method find
allow *

# allow all nodes to access the certificates services
path /puppet-ca/v1/certificate_revocation_list/ca
method find
allow *

### Unauthenticated ACLs, for clients without valid certificates; authenticated
### clients can also access these paths, though they rarely need to.

# allow access to the CA certificate; unauthenticated nodes need this
# in order to validate the puppet master's certificate
path /puppet-ca/v1/certificate/ca
auth any
method find
allow *

# allow nodes to retrieve the certificate they requested earlier
path /puppet-ca/v1/certificate/
auth any
method find
allow *

# allow nodes to request a new certificate
path /puppet-ca/v1/certificate_request
auth any
method find, save
allow *

# deny everything else; this ACL is not strictly necessary, but
# illustrates the default policy.
path /
auth any
~~~

## Access Control Behavior

Whenever Puppet master receives a valid HTTPS request, it checks it against its full list of authorization rules, in order. As soon as it finds a rule that matches the request, it will use that rule's `allow` and `allow_ip` permissions to decide whether to allow the request. If the request isn't allowed, Puppet will deny it, and will not check any further authorization rules.

In other words, authorization rules work like simple firewall rules. If you want to specifically allow a request that could be caught and rejected by some more general rule, you need to put the more specific rule earlier in the auth.conf file.

### Default Auth Rules

Puppet master uses two sets of auth rules: the rules from auth.conf, which it checks first, and a set of hardcoded default rules, which it only checks if a request doesn't match any rules in auth.conf.

If you are modifying auth.conf at all, **you should never rely on the hardcoded default rules.** Start with [a default auth.conf that explicitly includes copies of all of the default rules][default_file].

There are two reasons for this:

* Visibility. It's easier to see where your custom rules should go if you can see the whole picture.
* Poor behavior in the default rules code. If an ACL in auth.conf has the same `path` value as a default rule, Puppet will magically exclude the default rule even if the additional directives in the ACL mean they match completely disjunct sets of nodes.

## File Format

The auth.conf file is an ordered list of access control lists (ACLs). ACLs are separated by one or more empty lines.

The file can also include comments, which are lines starting with `#`. Comments do not count as empty lines for separating ACLs.

## ACL Syntax

[inpage_acl]: #acl-syntax

~~~
path ~ ^/puppet/v3/report/([^/]+)$
method save
allow $1
~~~

An ACL is a series of adjacent lines, with one directive per line. It describes some set of requests, and says who is allowed to make those requests.

The following directives describe which requests should match the ACL:

* `path`: Which URLs the ACL applies to. **Required.** Must be the first directive in the ACL.
* `environment`: Which environments the ACL applies to. Optional; defaults to all environments.
* `method`: Which HTTP methods the ACL applies to. Optional; defaults to all methods.
* `auth`: Whether the ACL applies to client-verified or non-client-verified HTTPS requests. Optional; defaults to `yes` (verified).

The following directives control who is allowed to make requests that match the ACL:

* `allow`: Which certificate names or hostnames can make matching requests. Optional; defaults to allowing no one.
* `allow_ip`: Which IP addresses can make matching requests. Optional; defaults to allowing no one.

An ACL can include multiple `allow` and `allow_ip` directives.

There are also `deny` and `deny_ip` directives, but their behavior is complicated and unintuitive. Avoid them.

### `path`

Which URLs the ACL applies to. **Required.** Must be the first directive in the ACL.

**Allowed values:** This directive must describe some set of URLs in the `puppet` or `puppet-ca` APIs. You can specify a group of URLs as a prefix, or as a regular expression.

#### URL Prefix

    path /puppet/v3/report

If the value of `path` is just an absolute path, Puppet master interprets it as a prefix. The ACL will match any URL that _begins_ with that string.

#### Regular Expression

    path ~ ^/puppet/v3/report/([^/]+)$

If the value of `path` is a tilde (`~`), a space, and then a regular expression, the ACL will match any URL that matches the regular expression. Regexps in paths should NOT be delimited with slashes.

> **Note:** You should almost always include at least a start anchor (`^`) in your regular expressions, to prevent them from matching URLs you didn't intend.

If a regular expression path includes capturing parentheses, you can reference the captures in `allow` directives with numbered variables like `$1`.

### `environment`

Which environments the ACL applies to.

**Allowed values:** A valid [environment][] or a comma-separated list of environments. Optional; defaults to all environments if omitted.

Most of Puppet's endpoints require an environment to be provided as a URL parameter. See the [HTTPS API docs][api] for details.

### `method`

Which HTTP methods the ACL applies to.

**Allowed values:** `find`, `search`, `save`, `destroy`, or a comma-separated list of those values. Optional; defaults to all methods if omitted.

This directive is kind of obfuscated, and you have to map these indirector methods to the actual HTTP methods you want to control.

Indirector | HTTP
-----------|------
find       | GET and POST
search     | GET and POST, for endpoints whose names end in "s" or "_search"
save       | PUT
destroy    | DELETE

### `auth`

Whether the ACL applies to client-verified or non-client-verified HTTPS requests.

**Allowed values:** `yes`, `any`, `no` (with `on` and `off` as synonyms). Must be a single value. Optional; defaults to `yes` (verified) if omitted.

Puppet agent makes client-verified requests to fetch configuration data and submit reports, but makes unverified requests to ask for a certificate.

If you set `auth any`, it allows nodes to access an endpoint without a valid certificate. (Setting it to `no` is not very useful, since it will _reject_ requests that have valid certificates.)

### `allow`

Which certificate names or hostnames can make requests that match the ACL. For client-verified requests, Puppet will check `allow` directives against the common name (CN) from the client's SSL certificate. For unverified requests, Puppet will use reverse DNS to figure out the client's hostname, and compare that to the `allow` directives.

**Allowed values:** One of the following (or a comma-separated list of them):

* A certificate name (for client-verified requests)
* A hostname (for unverified requests only)
* A glob of certificate names or hostnames, with an asterisk (`*`) in place of the leftmost segment of the name (e.g. `*.delivery.example.com`).
* A regular expression, delimited with slashes (`/`), matching some number of certificate names or hostnames (e.g. `/^[\w-]+.example.com$/`).
* The string `*`, which will allow _all_ requests.

Optional; if you don't specify any `allow` or `allow_ip` directives, Puppet will reject all requests matching the ACL.

If an ACL's `path` was a regular expression with capturing parentheses, its `allow` directives can reference the captured text with numbered variables like `$1`. This is useful for things like requesting catalogs, where the name of the node is included in the URL and nodes should only be able to access their own catalogs.

### `allow_ip`

Which IP addresses can make matching requests.

**Allowed values:** One of the following:

* A single IP address.
* A glob representing a group of IP addresses (e.g. `192.168.100.*`).
* CIDR notation representing a group of IP addresses (e.g. `192.168.100.0/24`).

An `allow_ip` directive will apply to both client-verified and unverified requests.

Optional; if you don't specify any `allow` or `allow_ip` directives, Puppet will reject all requests matching the ACL.
