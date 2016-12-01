---
layout: default
built_from_commit: c0673af42427fbe0b22ff97c8e5fa3244715eeae
title: 'Resource Type: yumrepo'
canonical: /puppet/latest/reference/types/yumrepo.html
---

> **NOTE:** This page was generated from the Puppet source code on 2016-01-15 16:31:56 +0100

yumrepo
-----

* [Attributes](#yumrepo-attributes)
* [Providers](#yumrepo-providers)

<h3 id="yumrepo-description">Description</h3>

The client-side description of a yum repository. Repository
configurations are found by parsing `/etc/yum.conf` and
the files indicated by the `reposdir` option in that file
(see `yum.conf(5)` for details).

Most parameters are identical to the ones documented
in the `yum.conf(5)` man page.

Continuation lines that yum supports (for the `baseurl`, for example)
are not supported. This type does not attempt to read or verify the
exinstence of files listed in the `include` attribute.

<h3 id="yumrepo-attributes">Attributes</h3>

<pre><code>yumrepo { 'resource title':
  <a href="#yumrepo-attribute-name">name</a>                =&gt; <em># <strong>(namevar)</strong> The name of the repository.  This corresponds to </em>
  <a href="#yumrepo-attribute-ensure">ensure</a>              =&gt; <em># The basic property that the resource should be...</em>
  <a href="#yumrepo-attribute-bandwidth">bandwidth</a>           =&gt; <em># Use to specify the maximum available network...</em>
  <a href="#yumrepo-attribute-baseurl">baseurl</a>             =&gt; <em># The URL for this repository. Set this to...</em>
  <a href="#yumrepo-attribute-cost">cost</a>                =&gt; <em># Cost of this repository. Set this to `absent` to </em>
  <a href="#yumrepo-attribute-descr">descr</a>               =&gt; <em># A human-readable description of the repository...</em>
  <a href="#yumrepo-attribute-enabled">enabled</a>             =&gt; <em># Whether this repository is enabled. Valid values </em>
  <a href="#yumrepo-attribute-enablegroups">enablegroups</a>        =&gt; <em># Whether yum will allow the use of package groups </em>
  <a href="#yumrepo-attribute-exclude">exclude</a>             =&gt; <em># List of shell globs. Matching packages will...</em>
  <a href="#yumrepo-attribute-failovermethod">failovermethod</a>      =&gt; <em># The failover method for this repository; should...</em>
  <a href="#yumrepo-attribute-gpgcakey">gpgcakey</a>            =&gt; <em># The URL for the GPG CA key for this repository...</em>
  <a href="#yumrepo-attribute-gpgcheck">gpgcheck</a>            =&gt; <em># Whether to check the GPG signature on packages...</em>
  <a href="#yumrepo-attribute-gpgkey">gpgkey</a>              =&gt; <em># The URL for the GPG key with which packages from </em>
  <a href="#yumrepo-attribute-http_caching">http_caching</a>        =&gt; <em># What to cache from this repository. Set this to...</em>
  <a href="#yumrepo-attribute-include">include</a>             =&gt; <em># The URL of a remote file containing additional...</em>
  <a href="#yumrepo-attribute-includepkgs">includepkgs</a>         =&gt; <em># List of shell globs. If this is set, only...</em>
  <a href="#yumrepo-attribute-keepalive">keepalive</a>           =&gt; <em># Whether HTTP/1.1 keepalive should be used with...</em>
  <a href="#yumrepo-attribute-metadata_expire">metadata_expire</a>     =&gt; <em># Number of seconds after which the metadata will...</em>
  <a href="#yumrepo-attribute-metalink">metalink</a>            =&gt; <em># Metalink for mirrors. Set this to `absent` to...</em>
  <a href="#yumrepo-attribute-mirrorlist">mirrorlist</a>          =&gt; <em># The URL that holds the list of mirrors for this...</em>
  <a href="#yumrepo-attribute-mirrorlist_expire">mirrorlist_expire</a>   =&gt; <em># Time (in seconds) after which the mirrorlist...</em>
  <a href="#yumrepo-attribute-priority">priority</a>            =&gt; <em># Priority of this repository from 1-99. Requires...</em>
  <a href="#yumrepo-attribute-protect">protect</a>             =&gt; <em># Enable or disable protection for this...</em>
  <a href="#yumrepo-attribute-provider">provider</a>            =&gt; <em># The specific backend to use for this `yumrepo...</em>
  <a href="#yumrepo-attribute-proxy">proxy</a>               =&gt; <em># URL of a proxy server that Yum should use when...</em>
  <a href="#yumrepo-attribute-proxy_password">proxy_password</a>      =&gt; <em># Password for this proxy. Set this to `absent` to </em>
  <a href="#yumrepo-attribute-proxy_username">proxy_username</a>      =&gt; <em># Username for this proxy. Set this to `absent` to </em>
  <a href="#yumrepo-attribute-repo_gpgcheck">repo_gpgcheck</a>       =&gt; <em># Whether to check the GPG signature on repodata...</em>
  <a href="#yumrepo-attribute-retries">retries</a>             =&gt; <em># Set the number of times any attempt to retrieve...</em>
  <a href="#yumrepo-attribute-s3_enabled">s3_enabled</a>          =&gt; <em># Access the repo via S3. Valid values are...</em>
  <a href="#yumrepo-attribute-skip_if_unavailable">skip_if_unavailable</a> =&gt; <em># Should yum skip this repository if unable to...</em>
  <a href="#yumrepo-attribute-sslcacert">sslcacert</a>           =&gt; <em># Path to the directory containing the databases...</em>
  <a href="#yumrepo-attribute-sslclientcert">sslclientcert</a>       =&gt; <em># Path  to the SSL client certificate yum should...</em>
  <a href="#yumrepo-attribute-sslclientkey">sslclientkey</a>        =&gt; <em># Path to the SSL client key yum should use to...</em>
  <a href="#yumrepo-attribute-sslverify">sslverify</a>           =&gt; <em># Should yum verify SSL certificates/hosts at all. </em>
  <a href="#yumrepo-attribute-target">target</a>              =&gt; <em># The filename to write the yum repository...</em>
  <a href="#yumrepo-attribute-throttle">throttle</a>            =&gt; <em># Enable bandwidth throttling for downloads. This...</em>
  <a href="#yumrepo-attribute-timeout">timeout</a>             =&gt; <em># Number of seconds to wait for a connection...</em>
  # ...plus any applicable <a href="./metaparameter.html">metaparameters</a>.
}</code></pre>

<h4 id="yumrepo-attribute-name">name</h4>

_(**Namevar:** If omitted, this attribute's value defaults to the resource's title.)_

The name of the repository.  This corresponds to the
`repositoryid` parameter in `yum.conf(5)`.

([↑ Back to yumrepo attributes](#yumrepo-attributes))

<h4 id="yumrepo-attribute-ensure">ensure</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The basic property that the resource should be in.

Valid values are `present`, `absent`.

([↑ Back to yumrepo attributes](#yumrepo-attributes))

<h4 id="yumrepo-attribute-bandwidth">bandwidth</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Use to specify the maximum available network bandwidth
      in bytes/second. Used with the `throttle` option. If `throttle`
      is a percentage and `bandwidth` is `0` then bandwidth throttling
      will be disabled. If `throttle` is expressed as a data rate then
      this option is ignored.
Set this to `absent` to remove it from the file completely.

Valid values are `absent`. Values can match `/^\d+[kMG]?$/`.

([↑ Back to yumrepo attributes](#yumrepo-attributes))

<h4 id="yumrepo-attribute-baseurl">baseurl</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The URL for this repository. Set this to `absent` to remove it from the file completely.

Valid values are `absent`. Values can match `/.*/`.

([↑ Back to yumrepo attributes](#yumrepo-attributes))

<h4 id="yumrepo-attribute-cost">cost</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Cost of this repository. Set this to `absent` to remove it from the file completely.

Valid values are `absent`. Values can match `/^\d+$/`.

([↑ Back to yumrepo attributes](#yumrepo-attributes))

<h4 id="yumrepo-attribute-descr">descr</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

A human-readable description of the repository.
This corresponds to the name parameter in `yum.conf(5)`.
Set this to `absent` to remove it from the file completely.

Valid values are `absent`. Values can match `/.*/`.

([↑ Back to yumrepo attributes](#yumrepo-attributes))

<h4 id="yumrepo-attribute-enabled">enabled</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Whether this repository is enabled.
Valid values are: False/0/No or True/1/Yes.
Set this to `absent` to remove it from the file completely.

Valid values are `absent`. Values can match `/^(True|False|0|1|No|Yes)$/i`.

([↑ Back to yumrepo attributes](#yumrepo-attributes))

<h4 id="yumrepo-attribute-enablegroups">enablegroups</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Whether yum will allow the use of package groups for this
repository.
Valid values are: False/0/No or True/1/Yes.
Set this to `absent` to remove it from the file completely.

Valid values are `absent`. Values can match `/^(True|False|0|1|No|Yes)$/i`.

([↑ Back to yumrepo attributes](#yumrepo-attributes))

<h4 id="yumrepo-attribute-exclude">exclude</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

List of shell globs. Matching packages will never be
considered in updates or installs for this repo.
Set this to `absent` to remove it from the file completely.

Valid values are `absent`. Values can match `/.*/`.

([↑ Back to yumrepo attributes](#yumrepo-attributes))

<h4 id="yumrepo-attribute-failovermethod">failovermethod</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The failover method for this repository; should be either
`roundrobin` or `priority`. Set this to `absent` to remove it from the file completely.

Valid values are `absent`. Values can match `/^roundrobin|priority$/`.

([↑ Back to yumrepo attributes](#yumrepo-attributes))

<h4 id="yumrepo-attribute-gpgcakey">gpgcakey</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The URL for the GPG CA key for this repository. Set this to `absent` to remove it from the file completely.

Valid values are `absent`. Values can match `/.*/`.

([↑ Back to yumrepo attributes](#yumrepo-attributes))

<h4 id="yumrepo-attribute-gpgcheck">gpgcheck</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Whether to check the GPG signature on packages installed
from this repository.
Valid values are: False/0/No or True/1/Yes.
Set this to `absent` to remove it from the file completely.

Valid values are `absent`. Values can match `/^(True|False|0|1|No|Yes)$/i`.

([↑ Back to yumrepo attributes](#yumrepo-attributes))

<h4 id="yumrepo-attribute-gpgkey">gpgkey</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The URL for the GPG key with which packages from this
repository are signed. Set this to `absent` to remove it from the file completely.

Valid values are `absent`. Values can match `/.*/`.

([↑ Back to yumrepo attributes](#yumrepo-attributes))

<h4 id="yumrepo-attribute-http_caching">http_caching</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

What to cache from this repository. Set this to `absent` to remove it from the file completely.

Valid values are `absent`. Values can match `/^(packages|all|none)$/`.

([↑ Back to yumrepo attributes](#yumrepo-attributes))

<h4 id="yumrepo-attribute-include">include</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The URL of a remote file containing additional yum configuration
settings. Puppet does not check for this file's existence or validity.
Set this to `absent` to remove it from the file completely.

Valid values are `absent`. Values can match `/.*/`.

([↑ Back to yumrepo attributes](#yumrepo-attributes))

<h4 id="yumrepo-attribute-includepkgs">includepkgs</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

List of shell globs. If this is set, only packages
matching one of the globs will be considered for
update or install from this repo. Set this to `absent` to remove it from the file completely.

Valid values are `absent`. Values can match `/.*/`.

([↑ Back to yumrepo attributes](#yumrepo-attributes))

<h4 id="yumrepo-attribute-keepalive">keepalive</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Whether HTTP/1.1 keepalive should be used with this repository.
Valid values are: False/0/No or True/1/Yes.
Set this to `absent` to remove it from the file completely.

Valid values are `absent`. Values can match `/^(True|False|0|1|No|Yes)$/i`.

([↑ Back to yumrepo attributes](#yumrepo-attributes))

<h4 id="yumrepo-attribute-metadata_expire">metadata_expire</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Number of seconds after which the metadata will expire.
Set this to `absent` to remove it from the file completely.

Valid values are `absent`. Values can match `/^([0-9]+[dhm]?|never)$/`.

([↑ Back to yumrepo attributes](#yumrepo-attributes))

<h4 id="yumrepo-attribute-metalink">metalink</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Metalink for mirrors. Set this to `absent` to remove it from the file completely.

Valid values are `absent`. Values can match `/.*/`.

([↑ Back to yumrepo attributes](#yumrepo-attributes))

<h4 id="yumrepo-attribute-mirrorlist">mirrorlist</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The URL that holds the list of mirrors for this repository.
Set this to `absent` to remove it from the file completely.

Valid values are `absent`. Values can match `/.*/`.

([↑ Back to yumrepo attributes](#yumrepo-attributes))

<h4 id="yumrepo-attribute-mirrorlist_expire">mirrorlist_expire</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Time (in seconds) after which the mirrorlist locally cached
      will expire.
Set this to `absent` to remove it from the file completely.

Valid values are `absent`. Values can match `/^[0-9]+$/`.

([↑ Back to yumrepo attributes](#yumrepo-attributes))

<h4 id="yumrepo-attribute-priority">priority</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Priority of this repository from 1-99. Requires that
the `priorities` plugin is installed and enabled.
Set this to `absent` to remove it from the file completely.

Valid values are `absent`. Values can match `/.*/`.

([↑ Back to yumrepo attributes](#yumrepo-attributes))

<h4 id="yumrepo-attribute-protect">protect</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Enable or disable protection for this repository. Requires
that the `protectbase` plugin is installed and enabled.
Valid values are: False/0/No or True/1/Yes.
Set this to `absent` to remove it from the file completely.

Valid values are `absent`. Values can match `/^(True|False|0|1|No|Yes)$/i`.

([↑ Back to yumrepo attributes](#yumrepo-attributes))

<h4 id="yumrepo-attribute-provider">provider</h4>

The specific backend to use for this `yumrepo`
resource. You will seldom need to specify this --- Puppet will usually
discover the appropriate provider for your platform.

Available providers are:

* [`inifile`](#yumrepo-provider-inifile)

([↑ Back to yumrepo attributes](#yumrepo-attributes))

<h4 id="yumrepo-attribute-proxy">proxy</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

URL of a proxy server that Yum should use when accessing this repository.
This attribute can also be set to `'_none_'`, which will make Yum bypass any
global proxy settings when accessing this repository.
Set this to `absent` to remove it from the file completely.

Valid values are `absent`. Values can match `/.*/`.

([↑ Back to yumrepo attributes](#yumrepo-attributes))

<h4 id="yumrepo-attribute-proxy_password">proxy_password</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Password for this proxy. Set this to `absent` to remove it from the file completely.

Valid values are `absent`. Values can match `/.*/`.

([↑ Back to yumrepo attributes](#yumrepo-attributes))

<h4 id="yumrepo-attribute-proxy_username">proxy_username</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Username for this proxy. Set this to `absent` to remove it from the file completely.

Valid values are `absent`. Values can match `/.*/`.

([↑ Back to yumrepo attributes](#yumrepo-attributes))

<h4 id="yumrepo-attribute-repo_gpgcheck">repo_gpgcheck</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Whether to check the GPG signature on repodata.
Valid values are: False/0/No or True/1/Yes.
Set this to `absent` to remove it from the file completely.

Valid values are `absent`. Values can match `/^(True|False|0|1|No|Yes)$/i`.

([↑ Back to yumrepo attributes](#yumrepo-attributes))

<h4 id="yumrepo-attribute-retries">retries</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Set the number of times any attempt to retrieve a file should
      retry before returning an error. Setting this to `0` makes yum
     try forever.
Set this to `absent` to remove it from the file completely.

Valid values are `absent`. Values can match `/^[0-9]+$/`.

([↑ Back to yumrepo attributes](#yumrepo-attributes))

<h4 id="yumrepo-attribute-s3_enabled">s3_enabled</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Access the repo via S3.
Valid values are: False/0/No or True/1/Yes.
Set this to `absent` to remove it from the file completely.

Valid values are `absent`. Values can match `/^(True|False|0|1|No|Yes)$/i`.

([↑ Back to yumrepo attributes](#yumrepo-attributes))

<h4 id="yumrepo-attribute-skip_if_unavailable">skip_if_unavailable</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Should yum skip this repository if unable to reach it.
Valid values are: False/0/No or True/1/Yes.
Set this to `absent` to remove it from the file completely.

Valid values are `absent`. Values can match `/^(True|False|0|1|No|Yes)$/i`.

([↑ Back to yumrepo attributes](#yumrepo-attributes))

<h4 id="yumrepo-attribute-sslcacert">sslcacert</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Path to the directory containing the databases of the
certificate authorities yum should use to verify SSL certificates.
Set this to `absent` to remove it from the file completely.

Valid values are `absent`. Values can match `/.*/`.

([↑ Back to yumrepo attributes](#yumrepo-attributes))

<h4 id="yumrepo-attribute-sslclientcert">sslclientcert</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Path  to the SSL client certificate yum should use to connect
to repos/remote sites. Set this to `absent` to remove it from the file completely.

Valid values are `absent`. Values can match `/.*/`.

([↑ Back to yumrepo attributes](#yumrepo-attributes))

<h4 id="yumrepo-attribute-sslclientkey">sslclientkey</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Path to the SSL client key yum should use to connect
to repos/remote sites. Set this to `absent` to remove it from the file completely.

Valid values are `absent`. Values can match `/.*/`.

([↑ Back to yumrepo attributes](#yumrepo-attributes))

<h4 id="yumrepo-attribute-sslverify">sslverify</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Should yum verify SSL certificates/hosts at all.
Valid values are: False/0/No or True/1/Yes.
Set this to `absent` to remove it from the file completely.

Valid values are `absent`. Values can match `/^(True|False|0|1|No|Yes)$/i`.

([↑ Back to yumrepo attributes](#yumrepo-attributes))

<h4 id="yumrepo-attribute-target">target</h4>

The filename to write the yum repository to.

([↑ Back to yumrepo attributes](#yumrepo-attributes))

<h4 id="yumrepo-attribute-throttle">throttle</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Enable bandwidth throttling for downloads. This option
      can be expressed as a absolute data rate in bytes/sec or a
      percentage `60%`. An SI prefix (k, M or G) may be appended
      to the data rate values.
Set this to `absent` to remove it from the file completely.

Valid values are `absent`. Values can match `/^\d+[kMG%]?$/`.

([↑ Back to yumrepo attributes](#yumrepo-attributes))

<h4 id="yumrepo-attribute-timeout">timeout</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Number of seconds to wait for a connection before timing
out. Set this to `absent` to remove it from the file completely.

Valid values are `absent`. Values can match `/^\d+$/`.

([↑ Back to yumrepo attributes](#yumrepo-attributes))


<h3 id="yumrepo-providers">Providers</h3>

<h4 id="yumrepo-provider-inifile">inifile</h4>

Manage yum repo configurations by parsing yum INI configuration files.

## Fetching instances

When fetching repo instances, directory entries in '/etc/yum/repos.d',
'/etc/yum.repos.d', and the directory optionally specified by the reposdir
key in '/etc/yum.conf' will be checked. If a given directory does not exist it
will be ignored. In addition, all sections in '/etc/yum.conf' aside from
'main' will be created as sections.

## Storing instances

When creating a new repository, a new section will be added in the first
yum repo directory that exists. The custom directory specified by the
'/etc/yum.conf' reposdir property is checked first, followed by
'/etc/yum/repos.d', and then '/etc/yum.repos.d'. If none of these exist, the
section will be created in '/etc/yum.conf'.




> **NOTE:** This page was generated from the Puppet source code on 2016-01-15 16:31:56 +0100