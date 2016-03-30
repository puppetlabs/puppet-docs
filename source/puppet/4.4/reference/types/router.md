---
layout: default
built_from_commit: e800bc25e695b8e8b58521d0a6ecdbd18aab031b
title: 'Resource Type: router'
canonical: /puppet/latest/reference/types/router.html
---

> **NOTE:** This page was generated from the Puppet source code on 2016-03-16 18:28:11 -0700

router
-----

* [Attributes](#router-attributes)

<h3 id="router-description">Description</h3>

Manages connected router.

<h3 id="router-attributes">Attributes</h3>

<pre><code>router { 'resource title':
  <a href="#router-attribute-url">url</a> =&gt; <em># <strong>(namevar)</strong> An SSH or telnet URL at which to access the...</em>
  # ...plus any applicable <a href="./metaparameter.html">metaparameters</a>.
}</code></pre>

<h4 id="router-attribute-url">url</h4>

_(**Namevar:** If omitted, this attribute's value defaults to the resource's title.)_

An SSH or telnet URL at which to access the router, in the form
`ssh://user:pass:enable@host/` or `telnet://user:pass:enable@host/`.

([↑ Back to router attributes](#router-attributes))





> **NOTE:** This page was generated from the Puppet source code on 2016-03-16 18:28:11 -0700