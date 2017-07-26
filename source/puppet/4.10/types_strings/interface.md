---
layout: default
built_from_commit: f0a5a11ef180b0d40dbdccd5faa4dc5bf2b20221
title: 'Resource Type: interface'
canonical: "/puppet/latest/types/interface.html"
---

> **NOTE:** This page was generated from the Puppet source code on 2017-07-26 14:45:15 -0500

interface
-----

* [Attributes](#interface-attributes)
* [Providers](#interface-providers)

<h3 id="interface-description">Description</h3>

This represents a router or switch interface. It is possible to manage
interface mode (access or trunking, native vlan and encapsulation) and
switchport characteristics (speed, duplex).

<h3 id="interface-attributes">Attributes</h3>

<pre><code>interface { 'resource title':
  <a href="#interface-attribute-name">name</a>                =&gt; <em># <strong>(namevar)</strong> The interface's...</em>
  <a href="#interface-attribute-ensure">ensure</a>              =&gt; <em># The basic property that the resource should be...</em>
  <a href="#interface-attribute-access_vlan">access_vlan</a>         =&gt; <em># Interface static access vlan.  Allowed values:...</em>
  <a href="#interface-attribute-allowed_trunk_vlans">allowed_trunk_vlans</a> =&gt; <em># Allowed list of Vlans that this trunk can...</em>
  <a href="#interface-attribute-description">description</a>         =&gt; <em># Interface...</em>
  <a href="#interface-attribute-device_url">device_url</a>          =&gt; <em># The URL at which the router or switch can be...</em>
  <a href="#interface-attribute-duplex">duplex</a>              =&gt; <em># Interface duplex.  Allowed values:  * `auto` ...</em>
  <a href="#interface-attribute-encapsulation">encapsulation</a>       =&gt; <em># Interface switchport encapsulation.  Allowed...</em>
  <a href="#interface-attribute-etherchannel">etherchannel</a>        =&gt; <em># Channel group this interface is part of....</em>
  <a href="#interface-attribute-ipaddress">ipaddress</a>           =&gt; <em># IP Address of this interface. Note that it might </em>
  <a href="#interface-attribute-mode">mode</a>                =&gt; <em># Interface switchport mode.  Allowed values:  ...</em>
  <a href="#interface-attribute-native_vlan">native_vlan</a>         =&gt; <em># Interface native vlan when trunking.  Allowed...</em>
  <a href="#interface-attribute-speed">speed</a>               =&gt; <em># Interface speed.  Allowed values:  * `auto` ...</em>
  # ...plus any applicable <a href="{{puppet}}/metaparameter.html">metaparameters</a>.
}</code></pre>

<h4 id="interface-attribute-name">name</h4>

_(**Namevar:** If omitted, this attribute's value defaults to the resource's title.)_

The interface's name.

([↑ Back to interface attributes](#interface-attributes))

<h4 id="interface-attribute-ensure">ensure</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The basic property that the resource should be in.

Default: `present`

Allowed values:

* `present`
* `absent`
* `shutdown`
* `no_shutdown`

([↑ Back to interface attributes](#interface-attributes))

<h4 id="interface-attribute-access_vlan">access_vlan</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Interface static access vlan.

Allowed values:

* `/^\d+/`

([↑ Back to interface attributes](#interface-attributes))

<h4 id="interface-attribute-allowed_trunk_vlans">allowed_trunk_vlans</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Allowed list of Vlans that this trunk can forward.

Allowed values:

* `all`
* `/./`

([↑ Back to interface attributes](#interface-attributes))

<h4 id="interface-attribute-description">description</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Interface description.

([↑ Back to interface attributes](#interface-attributes))

<h4 id="interface-attribute-device_url">device_url</h4>

The URL at which the router or switch can be reached.

([↑ Back to interface attributes](#interface-attributes))

<h4 id="interface-attribute-duplex">duplex</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Interface duplex.

Allowed values:

* `auto`
* `full`
* `half`

([↑ Back to interface attributes](#interface-attributes))

<h4 id="interface-attribute-encapsulation">encapsulation</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Interface switchport encapsulation.

Allowed values:

* `none`
* `dot1q`
* `isl`
* `negotiate`

([↑ Back to interface attributes](#interface-attributes))

<h4 id="interface-attribute-etherchannel">etherchannel</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Channel group this interface is part of.

Allowed values:

* `/^\d+/`

([↑ Back to interface attributes](#interface-attributes))

<h4 id="interface-attribute-ipaddress">ipaddress</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

IP Address of this interface. Note that it might not be possible to set
an interface IP address; it depends on the interface type and device type.

Valid format of ip addresses are:

* IPV4, like 127.0.0.1
* IPV4/prefixlength like 127.0.1.1/24
* IPV6/prefixlength like FE80::21A:2FFF:FE30:ECF0/128
* an optional suffix for IPV6 addresses from this list: `eui-64`, `link-local`

It is also possible to supply an array of values.

([↑ Back to interface attributes](#interface-attributes))

<h4 id="interface-attribute-mode">mode</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Interface switchport mode.

Allowed values:

* `access`
* `trunk`
* `dynamic auto`
* `dynamic desirable`

([↑ Back to interface attributes](#interface-attributes))

<h4 id="interface-attribute-native_vlan">native_vlan</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Interface native vlan when trunking.

Allowed values:

* `/^\d+/`

([↑ Back to interface attributes](#interface-attributes))

<h4 id="interface-attribute-speed">speed</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Interface speed.

Allowed values:

* `auto`
* `/^\d+/`

([↑ Back to interface attributes](#interface-attributes))


<h3 id="interface-providers">Providers</h3>

<h4 id="interface-provider-cisco">cisco</h4>

Cisco switch/router provider for interface.




> **NOTE:** This page was generated from the Puppet source code on 2017-07-26 14:45:15 -0500