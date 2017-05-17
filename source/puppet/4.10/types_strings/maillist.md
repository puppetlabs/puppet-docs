---
layout: default
built_from_commit: 6ff9b4626a7ffa75e145e1e91f879dfda897989b
title: 'Resource Type: maillist'
canonical: "/puppet/latest/types/maillist.html"
---

> **NOTE:** This page was generated from the Puppet source code on 2017-05-17 16:08:46 -0700

maillist
-----

* [Attributes](#maillist-attributes)
* [Providers](#maillist-providers)

<h3 id="maillist-description">Description</h3>

Manage email lists.  This resource type can only create
and remove lists; it cannot currently reconfigure them.

<h3 id="maillist-attributes">Attributes</h3>

<pre><code>maillist { 'resource title':
  <a href="#maillist-attribute-name">name</a>        =&gt; <em># <strong>(namevar)</strong> The name of the email...</em>
  <a href="#maillist-attribute-ensure">ensure</a>      =&gt; <em># The basic property that the resource should be...</em>
  <a href="#maillist-attribute-admin">admin</a>       =&gt; <em># The email address of the...</em>
  <a href="#maillist-attribute-description">description</a> =&gt; <em># The description of the mailing...</em>
  <a href="#maillist-attribute-mailserver">mailserver</a>  =&gt; <em># The name of the host handling email for the...</em>
  <a href="#maillist-attribute-password">password</a>    =&gt; <em># The admin...</em>
  <a href="#maillist-attribute-webserver">webserver</a>   =&gt; <em># The name of the host providing web archives and...</em>
  # ...plus any applicable <a href="{{puppet}}/metaparameter.html">metaparameters</a>.
}</code></pre>

<h4 id="maillist-attribute-name">name</h4>

_(**Namevar:** If omitted, this attribute's value defaults to the resource's title.)_

The name of the email list.

([↑ Back to maillist attributes](#maillist-attributes))

<h4 id="maillist-attribute-ensure">ensure</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The basic property that the resource should be in.

Default: `present`

Allowed values:

* `present`
* `absent`
* `purged`

([↑ Back to maillist attributes](#maillist-attributes))

<h4 id="maillist-attribute-admin">admin</h4>

The email address of the administrator.

([↑ Back to maillist attributes](#maillist-attributes))

<h4 id="maillist-attribute-description">description</h4>

The description of the mailing list.

([↑ Back to maillist attributes](#maillist-attributes))

<h4 id="maillist-attribute-mailserver">mailserver</h4>

The name of the host handling email for the list.

([↑ Back to maillist attributes](#maillist-attributes))

<h4 id="maillist-attribute-password">password</h4>

The admin password.

([↑ Back to maillist attributes](#maillist-attributes))

<h4 id="maillist-attribute-webserver">webserver</h4>

The name of the host providing web archives and the administrative interface.

([↑ Back to maillist attributes](#maillist-attributes))


<h3 id="maillist-providers">Providers</h3>

<h4 id="maillist-provider-mailman">mailman</h4>






> **NOTE:** This page was generated from the Puppet source code on 2017-05-17 16:08:46 -0700