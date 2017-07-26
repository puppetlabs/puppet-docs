---
layout: default
built_from_commit: f0a5a11ef180b0d40dbdccd5faa4dc5bf2b20221
title: 'Resource Type: k5login'
canonical: "/puppet/latest/types/k5login.html"
---

> **NOTE:** This page was generated from the Puppet source code on 2017-07-26 14:45:15 -0500

k5login
-----

* [Attributes](#k5login-attributes)

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
  # ...plus any applicable <a href="{{puppet}}/metaparameter.html">metaparameters</a>.
}</code></pre>

<h4 id="k5login-attribute-path">path</h4>

_(**Namevar:** If omitted, this attribute's value defaults to the resource's title.)_

The path to the `.k5login` file to manage.  Must be fully qualified.

([↑ Back to k5login attributes](#k5login-attributes))

<h4 id="k5login-attribute-ensure">ensure</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The basic property that the resource should be in.

Default: `present`

Allowed values:

* `present`
* `absent`

([↑ Back to k5login attributes](#k5login-attributes))

<h4 id="k5login-attribute-mode">mode</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The desired permissions mode of the `.k5login` file. Defaults to `644`.

([↑ Back to k5login attributes](#k5login-attributes))

<h4 id="k5login-attribute-principals">principals</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The principals present in the `.k5login` file. This should be specified as an array.

([↑ Back to k5login attributes](#k5login-attributes))





> **NOTE:** This page was generated from the Puppet source code on 2017-07-26 14:45:15 -0500