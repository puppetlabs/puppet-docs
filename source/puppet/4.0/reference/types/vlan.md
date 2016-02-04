---
layout: default
built_from_commit: 08cb8b2d315a296fa404a4871f94b3703a819461
title: 'Resource Type: vlan'
canonical: /puppet/latest/reference/types/vlan.html
---

> **NOTE:** This page was generated from the Puppet source code on 2016-01-27 14:24:39 +0000

vlan
-----

* [Attributes](#vlan-attributes)
* [Providers](#vlan-providers)

<h3 id="vlan-description">Description</h3>

Manages a VLAN on a router or switch.

<h3 id="vlan-attributes">Attributes</h3>

<pre><code>vlan { 'resource title':
  <a href="#vlan-attribute-name">name</a>        =&gt; <em># <strong>(namevar)</strong> The numeric VLAN ID.  Values can match...</em>
  <a href="#vlan-attribute-ensure">ensure</a>      =&gt; <em># The basic property that the resource should be...</em>
  <a href="#vlan-attribute-description">description</a> =&gt; <em># The VLAN's...</em>
  <a href="#vlan-attribute-device_url">device_url</a>  =&gt; <em># The URL of the router or switch maintaining this </em>
  <a href="#vlan-attribute-provider">provider</a>    =&gt; <em># The specific backend to use for this `vlan...</em>
  # ...plus any applicable <a href="./metaparameter.html">metaparameters</a>.
}</code></pre>

<h4 id="vlan-attribute-name">name</h4>

_(**Namevar:** If omitted, this attribute's value defaults to the resource's title.)_

The numeric VLAN ID.

Values can match `/^\d+/`.

([↑ Back to vlan attributes](#vlan-attributes))

<h4 id="vlan-attribute-ensure">ensure</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The basic property that the resource should be in.

Valid values are `present`, `absent`.

([↑ Back to vlan attributes](#vlan-attributes))

<h4 id="vlan-attribute-description">description</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The VLAN's name.

([↑ Back to vlan attributes](#vlan-attributes))

<h4 id="vlan-attribute-device_url">device_url</h4>

The URL of the router or switch maintaining this VLAN.

([↑ Back to vlan attributes](#vlan-attributes))

<h4 id="vlan-attribute-provider">provider</h4>

The specific backend to use for this `vlan`
resource. You will seldom need to specify this --- Puppet will usually
discover the appropriate provider for your platform.

Available providers are:

* [`cisco`](#vlan-provider-cisco)

([↑ Back to vlan attributes](#vlan-attributes))


<h3 id="vlan-providers">Providers</h3>

<h4 id="vlan-provider-cisco">cisco</h4>

Cisco switch/router provider for vlans.




> **NOTE:** This page was generated from the Puppet source code on 2016-01-27 14:24:39 +0000