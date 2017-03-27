---
layout: default
built_from_commit: ca4d947a102453a17a819a94bd01bac97f83c7e6
title: 'Resource Type: selboolean'
canonical: "/puppet/latest/types/selboolean.html"
---

> **NOTE:** This page was generated from the Puppet source code on 2017-01-31 13:37:41 -0600

selboolean
-----

* [Attributes](#selboolean-attributes)
* [Providers](#selboolean-providers)

<h3 id="selboolean-description">Description</h3>

Manages SELinux booleans on systems with SELinux support.  The supported booleans
are any of the ones found in `/selinux/booleans/`.

<h3 id="selboolean-attributes">Attributes</h3>

<pre><code>selboolean { 'resource title':
  <a href="#selboolean-attribute-name">name</a>       =&gt; <em># <strong>(namevar)</strong> The name of the SELinux boolean to be...</em>
  <a href="#selboolean-attribute-persistent">persistent</a> =&gt; <em># If set true, SELinux booleans will be written to </em>
  <a href="#selboolean-attribute-provider">provider</a>   =&gt; <em># The specific backend to use for this...</em>
  <a href="#selboolean-attribute-value">value</a>      =&gt; <em># Whether the SELinux boolean should be enabled or </em>
  # ...plus any applicable <a href="{{puppet}}/metaparameter.html">metaparameters</a>.
}</code></pre>

<h4 id="selboolean-attribute-name">name</h4>

_(**Namevar:** If omitted, this attribute's value defaults to the resource's title.)_

The name of the SELinux boolean to be managed.

([↑ Back to selboolean attributes](#selboolean-attributes))

<h4 id="selboolean-attribute-persistent">persistent</h4>

If set true, SELinux booleans will be written to disk and persist across reboots.
The default is `false`.

Valid values are `true`, `false`.

([↑ Back to selboolean attributes](#selboolean-attributes))

<h4 id="selboolean-attribute-provider">provider</h4>

The specific backend to use for this `selboolean`
resource. You will seldom need to specify this --- Puppet will usually
discover the appropriate provider for your platform.

Available providers are:

* [`getsetsebool`](#selboolean-provider-getsetsebool)

([↑ Back to selboolean attributes](#selboolean-attributes))

<h4 id="selboolean-attribute-value">value</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Whether the SELinux boolean should be enabled or disabled.

Valid values are `on`, `off`.

([↑ Back to selboolean attributes](#selboolean-attributes))


<h3 id="selboolean-providers">Providers</h3>

<h4 id="selboolean-provider-getsetsebool">getsetsebool</h4>

Manage SELinux booleans using the getsebool and setsebool binaries.

* Required binaries: `/usr/sbin/getsebool`, `/usr/sbin/setsebool`.




> **NOTE:** This page was generated from the Puppet source code on 2017-01-31 13:37:41 -0600