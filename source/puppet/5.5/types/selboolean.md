---
layout: default
built_from_commit: 30034e39d725e0107d5e961eaf5cf0866534282b
title: 'Resource Type: selboolean'
canonical: "/puppet/latest/types/selboolean.html"
---

> **NOTE:** This page was generated from the Puppet source code on 2018-08-28 06:48:02 -0700
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

If set to true, SELinux booleans will be written to disk and persist across reboots.

Default: `false`

Allowed values:

* `true`
* `false`

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

Allowed values:

* `on`
* `off`

([↑ Back to selboolean attributes](#selboolean-attributes))


<h3 id="selboolean-providers">Providers</h3>

<h4 id="selboolean-provider-getsetsebool">getsetsebool</h4>

Manage SELinux booleans using the getsebool and setsebool binaries.

* Required binaries: `/usr/sbin/getsebool`, `/usr/sbin/setsebool`




> **NOTE:** This page was generated from the Puppet source code on 2018-08-28 06:48:02 -0700