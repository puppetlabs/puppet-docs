---
layout: default
built_from_commit: a6789531f5d7efbde2f8e526f80e71518121b397
title: 'Resource Type: router'
canonical: "/puppet/latest/types/router.html"
---

> **NOTE:** This page was generated from the Puppet source code on 2018-02-13 10:53:05 -0800

router
-----

* [Attributes](#router-attributes)

<h3 id="router-description">Description</h3>

Manages connected router.

<h3 id="router-attributes">Attributes</h3>

<pre><code>router { 'resource title':
  <a href="#router-attribute-url">url</a> =&gt; <em># <strong>(namevar)</strong> An SSH or telnet URL at which to access the...</em>
  # ...plus any applicable <a href="{{puppet}}/metaparameter.html">metaparameters</a>.
}</code></pre>

<h4 id="router-attribute-url">url</h4>

_(**Namevar:** If omitted, this attribute's value defaults to the resource's title.)_

An SSH or telnet URL at which to access the router, in the form
`ssh://user:pass:enable@host/` or `telnet://user:pass:enable@host/`.

([↑ Back to router attributes](#router-attributes))





> **NOTE:** This page was generated from the Puppet source code on 2018-02-13 10:53:05 -0800