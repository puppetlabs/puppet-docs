---
layout: default
built_from_commit: e10e5d5cf16dbce72250e685d262d9877605c7ed
title: 'Resource Type: vlan'
canonical: "/puppet/latest/types/vlan.html"
---

> **NOTE:** This page was generated from the Puppet source code on 2017-11-03 18:18:51 -0700

vlan
-----

* [Attributes](#vlan-attributes)
* [Providers](#vlan-providers)

<h3 id="vlan-description">Description</h3>

Manages a VLAN on a router or switch.

<h3 id="vlan-attributes">Attributes</h3>

<pre><code>vlan { 'resource title':
  <a href="#vlan-attribute-name">name</a>        =&gt; <em># <strong>(namevar)</strong> The numeric VLAN ID.  Allowed values:  ...</em>
  <a href="#vlan-attribute-ensure">ensure</a>      =&gt; <em># The basic property that the resource should be...</em>
  <a href="#vlan-attribute-description">description</a> =&gt; <em># The VLAN's...</em>
  <a href="#vlan-attribute-device_url">device_url</a>  =&gt; <em># The URL of the router or switch maintaining this </em>
  # ...plus any applicable <a href="{{puppet}}/metaparameter.html">metaparameters</a>.
}</code></pre>

<h4 id="vlan-attribute-name">name</h4>

_(**Namevar:** If omitted, this attribute's value defaults to the resource's title.)_

The numeric VLAN ID.

Allowed values:

* `/^\d+/`

([↑ Back to vlan attributes](#vlan-attributes))

<h4 id="vlan-attribute-ensure">ensure</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The basic property that the resource should be in.

Default: `present`

Allowed values:

* `present`
* `absent`

([↑ Back to vlan attributes](#vlan-attributes))

<h4 id="vlan-attribute-description">description</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The VLAN's name.

([↑ Back to vlan attributes](#vlan-attributes))

<h4 id="vlan-attribute-device_url">device_url</h4>

The URL of the router or switch maintaining this VLAN.

([↑ Back to vlan attributes](#vlan-attributes))


<h3 id="vlan-providers">Providers</h3>

<h4 id="vlan-provider-cisco">cisco</h4>

Cisco switch/router provider for vlans.




> **NOTE:** This page was generated from the Puppet source code on 2017-11-03 18:18:51 -0700
