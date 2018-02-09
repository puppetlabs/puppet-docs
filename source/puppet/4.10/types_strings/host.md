---
layout: default
built_from_commit: 46e5188e3d20d712525caf5566fa2214e524637d
title: 'Resource Type: host'
canonical: "/puppet/latest/types/host.html"
---

> **NOTE:** This page was generated from the Puppet source code on 2018-02-05 13:47:04 -0800

host
-----

* [Attributes](#host-attributes)
* [Providers](#host-providers)

<h3 id="host-description">Description</h3>

The host's IP address, IPv4 or IPv6.

<h3 id="host-attributes">Attributes</h3>

<pre><code>host { 'resource title':
  <a href="#host-attribute-name">name</a>         =&gt; <em># <strong>(namevar)</strong> The host...</em>
  <a href="#host-attribute-ensure">ensure</a>       =&gt; <em># The basic property that the resource should be...</em>
  <a href="#host-attribute-comment">comment</a>      =&gt; <em># A comment that will be attached to the line with </em>
  <a href="#host-attribute-host_aliases">host_aliases</a> =&gt; <em># Any aliases the host might have.  Multiple...</em>
  <a href="#host-attribute-ip">ip</a>           =&gt; <em># The host's IP address, IPv4 or...</em>
  <a href="#host-attribute-target">target</a>       =&gt; <em># The file in which to store service information.  </em>
  # ...plus any applicable <a href="{{puppet}}/metaparameter.html">metaparameters</a>.
}</code></pre>

<h4 id="host-attribute-name">name</h4>

_(**Namevar:** If omitted, this attribute's value defaults to the resource's title.)_

The host name.

([↑ Back to host attributes](#host-attributes))

<h4 id="host-attribute-ensure">ensure</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The basic property that the resource should be in.

Default: `present`

Allowed values:

* `present`
* `absent`

([↑ Back to host attributes](#host-attributes))

<h4 id="host-attribute-comment">comment</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

A comment that will be attached to the line with a # character.

([↑ Back to host attributes](#host-attributes))

<h4 id="host-attribute-host_aliases">host_aliases</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Any aliases the host might have.  Multiple values must be
specified as an array.

([↑ Back to host attributes](#host-attributes))

<h4 id="host-attribute-ip">ip</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The host's IP address, IPv4 or IPv6.

([↑ Back to host attributes](#host-attributes))

<h4 id="host-attribute-target">target</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The file in which to store service information.  Only used by
those providers that write to disk. On most systems this defaults to `/etc/hosts`.

([↑ Back to host attributes](#host-attributes))


<h3 id="host-providers">Providers</h3>

<h4 id="host-provider-parsed">parsed</h4>



* Confined to: `exists == hosts`




> **NOTE:** This page was generated from the Puppet source code on 2018-02-05 13:47:04 -0800