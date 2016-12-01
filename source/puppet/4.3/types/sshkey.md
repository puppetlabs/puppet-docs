---
layout: default
built_from_commit: 3b5d15cb1c5ed830cb460f2687fde710e5383e69
title: 'Resource Type: sshkey'
canonical: /puppet/latest/reference/types/sshkey.html
---

> **NOTE:** This page was generated from the Puppet source code on 2016-01-27 14:15:19 +0000

sshkey
-----

* [Attributes](#sshkey-attributes)
* [Providers](#sshkey-providers)

<h3 id="sshkey-description">Description</h3>

Installs and manages ssh host keys.  At this point, this type
only knows how to install keys into `/etc/ssh/ssh_known_hosts`.  See
the `ssh_authorized_key` type to manage authorized keys.

<h3 id="sshkey-attributes">Attributes</h3>

<pre><code>sshkey { 'resource title':
  <a href="#sshkey-attribute-name">name</a>         =&gt; <em># <strong>(namevar)</strong> The host name that the key is associated...</em>
  <a href="#sshkey-attribute-ensure">ensure</a>       =&gt; <em># The basic property that the resource should be...</em>
  <a href="#sshkey-attribute-host_aliases">host_aliases</a> =&gt; <em># Any aliases the host might have.  Multiple...</em>
  <a href="#sshkey-attribute-key">key</a>          =&gt; <em># The key itself; generally a long string of...</em>
  <a href="#sshkey-attribute-provider">provider</a>     =&gt; <em># The specific backend to use for this `sshkey...</em>
  <a href="#sshkey-attribute-target">target</a>       =&gt; <em># The file in which to store the ssh key.  Only...</em>
  <a href="#sshkey-attribute-type">type</a>         =&gt; <em># The encryption type used.  Probably ssh-dss or...</em>
  # ...plus any applicable <a href="./metaparameter.html">metaparameters</a>.
}</code></pre>

<h4 id="sshkey-attribute-name">name</h4>

_(**Namevar:** If omitted, this attribute's value defaults to the resource's title.)_

The host name that the key is associated with.

([↑ Back to sshkey attributes](#sshkey-attributes))

<h4 id="sshkey-attribute-ensure">ensure</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The basic property that the resource should be in.

Valid values are `present`, `absent`.

([↑ Back to sshkey attributes](#sshkey-attributes))

<h4 id="sshkey-attribute-host_aliases">host_aliases</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Any aliases the host might have.  Multiple values must be
specified as an array.

([↑ Back to sshkey attributes](#sshkey-attributes))

<h4 id="sshkey-attribute-key">key</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The key itself; generally a long string of uuencoded characters.

([↑ Back to sshkey attributes](#sshkey-attributes))

<h4 id="sshkey-attribute-provider">provider</h4>

The specific backend to use for this `sshkey`
resource. You will seldom need to specify this --- Puppet will usually
discover the appropriate provider for your platform.

Available providers are:

* [`parsed`](#sshkey-provider-parsed)

([↑ Back to sshkey attributes](#sshkey-attributes))

<h4 id="sshkey-attribute-target">target</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The file in which to store the ssh key.  Only used by
the `parsed` provider.

([↑ Back to sshkey attributes](#sshkey-attributes))

<h4 id="sshkey-attribute-type">type</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The encryption type used.  Probably ssh-dss or ssh-rsa.

Valid values are `ssh-dss` (also called `dsa`), `ssh-ed25519` (also called `ed25519`), `ssh-rsa` (also called `rsa`), `ecdsa-sha2-nistp256`, `ecdsa-sha2-nistp384`, `ecdsa-sha2-nistp521`.

([↑ Back to sshkey attributes](#sshkey-attributes))


<h3 id="sshkey-providers">Providers</h3>

<h4 id="sshkey-provider-parsed">parsed</h4>

Parse and generate host-wide known hosts files for SSH.




> **NOTE:** This page was generated from the Puppet source code on 2016-01-27 14:15:19 +0000