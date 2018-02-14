---
layout: default
built_from_commit: a6789531f5d7efbde2f8e526f80e71518121b397
title: 'Resource Type: ssh_authorized_key'
canonical: "/puppet/latest/types/ssh_authorized_key.html"
---

> **NOTE:** This page was generated from the Puppet source code on 2018-02-13 10:53:05 -0800

ssh_authorized_key
-----

* [Attributes](#ssh_authorized_key-attributes)
* [Providers](#ssh_authorized_key-providers)

<h3 id="ssh_authorized_key-description">Description</h3>

Manages SSH authorized keys. Currently only type 2 keys are supported.

In their native habitat, SSH keys usually appear as a single long line, in
the format `<TYPE> <KEY> <NAME/COMMENT>`. This resource type requires you
to split that line into several attributes. Thus, a key that appears in
your `~/.ssh/id_rsa.pub` file like this...

    ssh-rsa AAAAB3Nza[...]qXfdaQ== nick@magpie.example.com

...would translate to the following resource:

    ssh_authorized_key { 'nick@magpie.example.com':
      ensure => present,
      user   => 'nick',
      type   => 'ssh-rsa',
      key    => 'AAAAB3Nza[...]qXfdaQ==',
    }

To ensure that only the currently approved keys are present, you can purge
unmanaged SSH keys on a per-user basis. Do this with the `user` resource
type's `purge_ssh_keys` attribute:

    user { 'nick':
      ensure         => present,
      purge_ssh_keys => true,
    }

This will remove any keys in `~/.ssh/authorized_keys` that aren't being
managed with `ssh_authorized_key` resources. See the documentation of the
`user` type for more details.

**Autorequires:** If Puppet is managing the user account in which this
SSH key should be installed, the `ssh_authorized_key` resource will autorequire
that user.

<h3 id="ssh_authorized_key-attributes">Attributes</h3>

<pre><code>ssh_authorized_key { 'resource title':
  <a href="#ssh_authorized_key-attribute-name">name</a>     =&gt; <em># <strong>(namevar)</strong> The SSH key comment. This can be anything, and...</em>
  <a href="#ssh_authorized_key-attribute-ensure">ensure</a>   =&gt; <em># The basic property that the resource should be...</em>
  <a href="#ssh_authorized_key-attribute-key">key</a>      =&gt; <em># The public key itself; generally a long string...</em>
  <a href="#ssh_authorized_key-attribute-options">options</a>  =&gt; <em># Key options; see sshd(8) for possible values...</em>
  <a href="#ssh_authorized_key-attribute-provider">provider</a> =&gt; <em># The specific backend to use for this...</em>
  <a href="#ssh_authorized_key-attribute-target">target</a>   =&gt; <em># The absolute filename in which to store the SSH...</em>
  <a href="#ssh_authorized_key-attribute-type">type</a>     =&gt; <em># The encryption type used.  Valid values are...</em>
  <a href="#ssh_authorized_key-attribute-user">user</a>     =&gt; <em># The user account in which the SSH key should be...</em>
  # ...plus any applicable <a href="{{puppet}}/metaparameter.html">metaparameters</a>.
}</code></pre>

<h4 id="ssh_authorized_key-attribute-name">name</h4>

_(**Namevar:** If omitted, this attribute's value defaults to the resource's title.)_

The SSH key comment. This can be anything, and doesn't need to match
the original comment from the `.pub` file.

Due to internal limitations, this must be unique across all user accounts;
if you want to specify one key for multiple users, you must use a different
comment for each instance.

([↑ Back to ssh_authorized_key attributes](#ssh_authorized_key-attributes))

<h4 id="ssh_authorized_key-attribute-ensure">ensure</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The basic property that the resource should be in.

Valid values are `present`, `absent`.

([↑ Back to ssh_authorized_key attributes](#ssh_authorized_key-attributes))

<h4 id="ssh_authorized_key-attribute-key">key</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The public key itself; generally a long string of hex characters. The `key`
attribute may not contain whitespace.

Make sure to omit the following in this attribute (and specify them in
other attributes):

* Key headers (e.g. 'ssh-rsa') --- put these in the `type` attribute.
* Key identifiers / comments (e.g. 'joe@joescomputer.local') --- put these in
  the `name` attribute/resource title.

([↑ Back to ssh_authorized_key attributes](#ssh_authorized_key-attributes))

<h4 id="ssh_authorized_key-attribute-options">options</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Key options; see sshd(8) for possible values. Multiple values
should be specified as an array.

([↑ Back to ssh_authorized_key attributes](#ssh_authorized_key-attributes))

<h4 id="ssh_authorized_key-attribute-provider">provider</h4>

The specific backend to use for this `ssh_authorized_key`
resource. You will seldom need to specify this --- Puppet will usually
discover the appropriate provider for your platform.

Available providers are:

* [`parsed`](#ssh_authorized_key-provider-parsed)

([↑ Back to ssh_authorized_key attributes](#ssh_authorized_key-attributes))

<h4 id="ssh_authorized_key-attribute-target">target</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The absolute filename in which to store the SSH key. This
property is optional and should only be used in cases where keys
are stored in a non-standard location (i.e.` not in
`~user/.ssh/authorized_keys`).

([↑ Back to ssh_authorized_key attributes](#ssh_authorized_key-attributes))

<h4 id="ssh_authorized_key-attribute-type">type</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The encryption type used.

Valid values are `ssh-dss` (also called `dsa`), `ssh-rsa` (also called `rsa`), `ecdsa-sha2-nistp256`, `ecdsa-sha2-nistp384`, `ecdsa-sha2-nistp521`, `ssh-ed25519` (also called `ed25519`).

([↑ Back to ssh_authorized_key attributes](#ssh_authorized_key-attributes))

<h4 id="ssh_authorized_key-attribute-user">user</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The user account in which the SSH key should be installed. The resource
will autorequire this user if it is being managed as a `user` resource.

([↑ Back to ssh_authorized_key attributes](#ssh_authorized_key-attributes))


<h3 id="ssh_authorized_key-providers">Providers</h3>

<h4 id="ssh_authorized_key-provider-parsed">parsed</h4>

Parse and generate authorized_keys files for SSH.




> **NOTE:** This page was generated from the Puppet source code on 2018-02-13 10:53:05 -0800