---
layout: default
built_from_commit: 321d3fb313ee6513c02dac363ae3b122b6168281
title: 'Resource Type: notify'
canonical: "/puppet/latest/types/notify.html"
---

> **NOTE:** This page was generated from the Puppet source code on 2019-04-02 15:39:53 -0700

notify
-----

* [Attributes](#notify-attributes)

<h3 id="notify-description">Description</h3>

Sends an arbitrary message to the agent run-time log.

<h3 id="notify-attributes">Attributes</h3>

<pre><code>notify { 'resource title':
  <a href="#notify-attribute-name">name</a>     =&gt; <em># <strong>(namevar)</strong> An arbitrary tag for your own reference; the...</em>
  <a href="#notify-attribute-message">message</a>  =&gt; <em># The message to be sent to the...</em>
  <a href="#notify-attribute-withpath">withpath</a> =&gt; <em># Whether to show the full object path.  Default...</em>
  # ...plus any applicable <a href="{{puppet}}/metaparameter.html">metaparameters</a>.
}</code></pre>

<h4 id="notify-attribute-name">name</h4>

_(**Namevar:** If omitted, this attribute's value defaults to the resource's title.)_

An arbitrary tag for your own reference; the name of the message.

([↑ Back to notify attributes](#notify-attributes))

<h4 id="notify-attribute-message">message</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The message to be sent to the log.

([↑ Back to notify attributes](#notify-attributes))

<h4 id="notify-attribute-withpath">withpath</h4>

Whether to show the full object path.

Default: `false`

Allowed values:

* `true`
* `false`

([↑ Back to notify attributes](#notify-attributes))





> **NOTE:** This page was generated from the Puppet source code on 2019-04-02 15:39:53 -0700