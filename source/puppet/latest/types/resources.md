---
layout: default
built_from_commit: 4c1b0ace7275f9646c9f6630e11f41556d88d2ac
title: 'Resource Type: resources'
canonical: "/puppet/latest/types/resources.html"
---

> **NOTE:** This page was generated from the Puppet source code on 2019-09-06 09:16:04 -0700

resources
-----

* [Attributes](#resources-attributes)

<h3 id="resources-description">Description</h3>

This is a metatype that can manage other resource types.  Any
metaparams specified here will be passed on to any generated resources,
so you can purge unmanaged resources but set `noop` to true so the
purging is only logged and does not actually happen.

<h3 id="resources-attributes">Attributes</h3>

<pre><code>resources { 'resource title':
  <a href="#resources-attribute-name">name</a>               =&gt; <em># <strong>(namevar)</strong> The name of the type to be...</em>
  <a href="#resources-attribute-purge">purge</a>              =&gt; <em># Whether to purge unmanaged resources.  When set...</em>
  <a href="#resources-attribute-unless_system_user">unless_system_user</a> =&gt; <em># This keeps system users from being purged.  By...</em>
  <a href="#resources-attribute-unless_uid">unless_uid</a>         =&gt; <em># This keeps specific uids or ranges of uids from...</em>
  # ...plus any applicable <a href="{{puppet}}/metaparameter.html">metaparameters</a>.
}</code></pre>

<h4 id="resources-attribute-name">name</h4>

_(**Namevar:** If omitted, this attribute's value defaults to the resource's title.)_

The name of the type to be managed.

([↑ Back to resources attributes](#resources-attributes))

<h4 id="resources-attribute-purge">purge</h4>

Whether to purge unmanaged resources.  When set to `true`, this will
delete any resource that is not specified in your configuration and is not
autorequired by any managed resources. **Note:** The `ssh_authorized_key`
resource type can't be purged this way; instead, see the `purge_ssh_keys`
attribute of the `user` type.

Default: `false`

Allowed values:

* `true`
* `false`
* `yes`
* `no`

([↑ Back to resources attributes](#resources-attributes))

<h4 id="resources-attribute-unless_system_user">unless_system_user</h4>

This keeps system users from being purged.  By default, it
does not purge users whose UIDs are less than the minimum UID for the system (typically 500 or 1000), but you can specify
a different UID as the inclusive limit.

Allowed values:

* `true`
* `false`
* `/^\d+$/`

([↑ Back to resources attributes](#resources-attributes))

<h4 id="resources-attribute-unless_uid">unless_uid</h4>

This keeps specific uids or ranges of uids from being purged when purge is true.
Accepts integers, integer strings, and arrays of integers or integer strings.
To specify a range of uids, consider using the range() function from stdlib.

([↑ Back to resources attributes](#resources-attributes))





> **NOTE:** This page was generated from the Puppet source code on 2019-09-06 09:16:04 -0700