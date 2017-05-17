---
layout: default
built_from_commit: ca4d947a102453a17a819a94bd01bac97f83c7e6
title: 'Resource Type: computer'
canonical: "/puppet/latest/types/computer.html"
---

> **NOTE:** This page was generated from the Puppet source code on 2017-01-31 13:37:40 -0600

computer
-----

* [Attributes](#computer-attributes)
* [Providers](#computer-providers)

<h3 id="computer-description">Description</h3>

Computer object management using DirectoryService
on OS X.

Note that these are distinctly different kinds of objects to 'hosts',
as they require a MAC address and can have all sorts of policy attached to
them.

This provider only manages Computer objects in the local directory service
domain, not in remote directories.

If you wish to manage `/etc/hosts` file on Mac OS X, then simply use the host
type as per other platforms.

This type primarily exists to create localhost Computer objects that MCX
policy can then be attached to.

**Autorequires:** If Puppet is managing the plist file representing a
Computer object (located at `/var/db/dslocal/nodes/Default/computers/{name}.plist`),
the Computer resource will autorequire it.

<h3 id="computer-attributes">Attributes</h3>

<pre><code>computer { 'resource title':
  <a href="#computer-attribute-name">name</a>       =&gt; <em># <strong>(namevar)</strong> The authoritative 'short' name of the computer...</em>
  <a href="#computer-attribute-ensure">ensure</a>     =&gt; <em># Control the existences of this computer record...</em>
  <a href="#computer-attribute-en_address">en_address</a> =&gt; <em># The MAC address of the primary network...</em>
  <a href="#computer-attribute-ip_address">ip_address</a> =&gt; <em># The IP Address of the Computer...</em>
  <a href="#computer-attribute-provider">provider</a>   =&gt; <em># The specific backend to use for this `computer...</em>
  <a href="#computer-attribute-realname">realname</a>   =&gt; <em># The 'long' name of the computer...</em>
  # ...plus any applicable <a href="{{puppet}}/metaparameter.html">metaparameters</a>.
}</code></pre>

<h4 id="computer-attribute-name">name</h4>

_(**Namevar:** If omitted, this attribute's value defaults to the resource's title.)_

The authoritative 'short' name of the computer record.

([↑ Back to computer attributes](#computer-attributes))

<h4 id="computer-attribute-ensure">ensure</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Control the existences of this computer record. Set this attribute to
`present` to ensure the computer record exists.  Set it to `absent`
to delete any computer records with this name

Valid values are `present`, `absent`.

([↑ Back to computer attributes](#computer-attributes))

<h4 id="computer-attribute-en_address">en_address</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The MAC address of the primary network interface. Must match en0.

([↑ Back to computer attributes](#computer-attributes))

<h4 id="computer-attribute-ip_address">ip_address</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The IP Address of the Computer object.

([↑ Back to computer attributes](#computer-attributes))

<h4 id="computer-attribute-provider">provider</h4>

The specific backend to use for this `computer`
resource. You will seldom need to specify this --- Puppet will usually
discover the appropriate provider for your platform.

Available providers are:

* [`directoryservice`](#computer-provider-directoryservice)

([↑ Back to computer attributes](#computer-attributes))

<h4 id="computer-attribute-realname">realname</h4>

The 'long' name of the computer record.

([↑ Back to computer attributes](#computer-attributes))


<h3 id="computer-providers">Providers</h3>

<h4 id="computer-provider-directoryservice">directoryservice</h4>

Computer object management using DirectoryService on OS X.
Note that these are distinctly different kinds of objects to 'hosts',
as they require a MAC address and can have all sorts of policy attached to
them.

This provider only manages Computer objects in the local directory service
domain, not in remote directories.

If you wish to manage /etc/hosts on Mac OS X, then simply use the host
type as per other platforms.

* Default for `operatingsystem` == `darwin`.




> **NOTE:** This page was generated from the Puppet source code on 2017-01-31 13:37:40 -0600