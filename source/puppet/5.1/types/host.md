---
layout: default
built_from_commit: edcda126535bd31439280bcf21402a4a4f126f71
title: 'Resource Type: host'
canonical: "/puppet/latest/types/host.html"
---

> **NOTE:** This page was generated from the Puppet source code on 2017-06-27 17:23:02 -0500

host
-----

* [Attributes](#host-attributes)
* [Providers](#host-providers)

<h3 id="host-description">Description</h3>

Installs and manages host entries.  For most systems, these
entries will just be in `/etc/hosts`, but some systems (notably OS X)
will have different solutions.

<h3 id="host-attributes">Attributes</h3>

<pre><code>host { 'resource title':
  <a href="#host-attribute-name">name</a>         =&gt; <em># <strong>(namevar)</strong> The host...</em>
  <a href="#host-attribute-ensure">ensure</a>       =&gt; <em># The basic property that the resource should be...</em>
  <a href="#host-attribute-comment">comment</a>      =&gt; <em># A comment that will be attached to the line with </em>
  <a href="#host-attribute-host_aliases">host_aliases</a> =&gt; <em># Any aliases the host might have.  Multiple...</em>
  <a href="#host-attribute-ip">ip</a>           =&gt; <em># The host's IP address, IPv4 or...</em>
  <a href="#host-attribute-provider">provider</a>     =&gt; <em># The specific backend to use for this `host...</em>
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

Valid values are `present`, `absent`.

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

<h4 id="host-attribute-provider">provider</h4>

The specific backend to use for this `host`
resource. You will seldom need to specify this --- Puppet will usually
discover the appropriate provider for your platform.

Available providers are:

* [`parsed`](#host-provider-parsed)

([↑ Back to host attributes](#host-attributes))

<h4 id="host-attribute-target">target</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The file in which to store service information.  Only used by
those providers that write to disk. On most systems this defaults to `/etc/hosts`.

([↑ Back to host attributes](#host-attributes))


<h3 id="host-providers">Providers</h3>

<h4 id="host-provider-parsed">parsed</h4>






> **NOTE:** This page was generated from the Puppet source code on 2017-06-27 17:23:02 -0500