---
layout: default
built_from_commit: e49293167c2a4753e3db51df5585478e3d8c8877
title: 'Resource Type: zpool'
canonical: /puppet/latest/reference/types/zpool.html
---

> **NOTE:** This page was generated from the Puppet source code on 2016-01-27 14:19:23 +0000

zpool
-----

* [Attributes](#zpool-attributes)
* [Providers](#zpool-providers)

<h3 id="zpool-description">Description</h3>

Manage zpools. Create and delete zpools. The provider WILL NOT SYNC, only report differences.

Supports vdevs with mirrors, raidz, logs and spares.

<h3 id="zpool-attributes">Attributes</h3>

<pre><code>zpool { 'resource title':
  <a href="#zpool-attribute-pool">pool</a>        =&gt; <em># <strong>(namevar)</strong> The name for this...</em>
  <a href="#zpool-attribute-ensure">ensure</a>      =&gt; <em># The basic property that the resource should be...</em>
  <a href="#zpool-attribute-disk">disk</a>        =&gt; <em># The disk(s) for this pool. Can be an array or a...</em>
  <a href="#zpool-attribute-log">log</a>         =&gt; <em># Log disks for this pool. This type does not...</em>
  <a href="#zpool-attribute-mirror">mirror</a>      =&gt; <em># List of all the devices to mirror for this pool. </em>
  <a href="#zpool-attribute-provider">provider</a>    =&gt; <em># The specific backend to use for this `zpool...</em>
  <a href="#zpool-attribute-raid_parity">raid_parity</a> =&gt; <em># Determines parity when using the `raidz...</em>
  <a href="#zpool-attribute-raidz">raidz</a>       =&gt; <em># List of all the devices to raid for this pool...</em>
  <a href="#zpool-attribute-spare">spare</a>       =&gt; <em># Spare disk(s) for this...</em>
  # ...plus any applicable <a href="./metaparameter.html">metaparameters</a>.
}</code></pre>

<h4 id="zpool-attribute-pool">pool</h4>

_(**Namevar:** If omitted, this attribute's value defaults to the resource's title.)_

The name for this pool.

([↑ Back to zpool attributes](#zpool-attributes))

<h4 id="zpool-attribute-ensure">ensure</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The basic property that the resource should be in.

Valid values are `present`, `absent`.

([↑ Back to zpool attributes](#zpool-attributes))

<h4 id="zpool-attribute-disk">disk</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The disk(s) for this pool. Can be an array or a space separated string.

([↑ Back to zpool attributes](#zpool-attributes))

<h4 id="zpool-attribute-log">log</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Log disks for this pool. This type does not currently support mirroring of log disks.

([↑ Back to zpool attributes](#zpool-attributes))

<h4 id="zpool-attribute-mirror">mirror</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

List of all the devices to mirror for this pool. Each mirror should be a
space separated string:

    mirror => ["disk1 disk2", "disk3 disk4"],

([↑ Back to zpool attributes](#zpool-attributes))

<h4 id="zpool-attribute-provider">provider</h4>

The specific backend to use for this `zpool`
resource. You will seldom need to specify this --- Puppet will usually
discover the appropriate provider for your platform.

Available providers are:

* [`zpool`](#zpool-provider-zpool)

([↑ Back to zpool attributes](#zpool-attributes))

<h4 id="zpool-attribute-raid_parity">raid_parity</h4>

Determines parity when using the `raidz` parameter.

([↑ Back to zpool attributes](#zpool-attributes))

<h4 id="zpool-attribute-raidz">raidz</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

List of all the devices to raid for this pool. Should be an array of
space separated strings:

    raidz => ["disk1 disk2", "disk3 disk4"],

([↑ Back to zpool attributes](#zpool-attributes))

<h4 id="zpool-attribute-spare">spare</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Spare disk(s) for this pool.

([↑ Back to zpool attributes](#zpool-attributes))


<h3 id="zpool-providers">Providers</h3>

<h4 id="zpool-provider-zpool">zpool</h4>

Provider for zpool.

* Required binaries: `zpool`.




> **NOTE:** This page was generated from the Puppet source code on 2016-01-27 14:19:23 +0000