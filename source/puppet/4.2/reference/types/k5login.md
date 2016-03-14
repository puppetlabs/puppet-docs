---
layout: default
built_from_commit: e49293167c2a4753e3db51df5585478e3d8c8877
title: 'Resource Type: k5login'
canonical: /puppet/latest/reference/types/k5login.html
---

> **NOTE:** This page was generated from the Puppet source code on 2016-01-27 14:19:23 +0000

k5login
-----

* [Attributes](#k5login-attributes)
* [Providers](#k5login-providers)

<h3 id="k5login-description">Description</h3>

Manage the `.k5login` file for a user.  Specify the full path to
the `.k5login` file as the name, and an array of principals as the
`principals` attribute.

<h3 id="k5login-attributes">Attributes</h3>

<pre><code>k5login { 'resource title':
  <a href="#k5login-attribute-path">path</a>       =&gt; <em># <strong>(namevar)</strong> The path to the `.k5login` file to manage.  Must </em>
  <a href="#k5login-attribute-ensure">ensure</a>     =&gt; <em># The basic property that the resource should be...</em>
  <a href="#k5login-attribute-mode">mode</a>       =&gt; <em># The desired permissions mode of the `.k5login...</em>
  <a href="#k5login-attribute-principals">principals</a> =&gt; <em># The principals present in the `.k5login` file...</em>
  <a href="#k5login-attribute-provider">provider</a>   =&gt; <em># The specific backend to use for this `k5login...</em>
  # ...plus any applicable <a href="./metaparameter.html">metaparameters</a>.
}</code></pre>

<h4 id="k5login-attribute-path">path</h4>

_(**Namevar:** If omitted, this attribute's value defaults to the resource's title.)_

The path to the `.k5login` file to manage.  Must be fully qualified.

([↑ Back to k5login attributes](#k5login-attributes))

<h4 id="k5login-attribute-ensure">ensure</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The basic property that the resource should be in.

Valid values are `present`, `absent`.

([↑ Back to k5login attributes](#k5login-attributes))

<h4 id="k5login-attribute-mode">mode</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The desired permissions mode of the `.k5login` file. Defaults to `644`.

([↑ Back to k5login attributes](#k5login-attributes))

<h4 id="k5login-attribute-principals">principals</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The principals present in the `.k5login` file. This should be specified as an array.

([↑ Back to k5login attributes](#k5login-attributes))

<h4 id="k5login-attribute-provider">provider</h4>

The specific backend to use for this `k5login`
resource. You will seldom need to specify this --- Puppet will usually
discover the appropriate provider for your platform.

Available providers are:

* [`k5login`](#k5login-provider-k5login)

([↑ Back to k5login attributes](#k5login-attributes))


<h3 id="k5login-providers">Providers</h3>

<h4 id="k5login-provider-k5login">k5login</h4>

The k5login provider is the only provider for the k5login
type.




> **NOTE:** This page was generated from the Puppet source code on 2016-01-27 14:19:23 +0000