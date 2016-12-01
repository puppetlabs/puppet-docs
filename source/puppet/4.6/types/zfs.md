---
layout: default
built_from_commit: 4e0b2b9b2c68e41c386308d71d23d9b26fbfa154
title: 'Resource Type: zfs'
canonical: /puppet/latest/reference/types/zfs.html
---

> **NOTE:** This page was generated from the Puppet source code on 2016-08-10 20:10:55 -0500

zfs
-----

* [Attributes](#zfs-attributes)
* [Providers](#zfs-providers)

<h3 id="zfs-description">Description</h3>

Manage zfs. Create destroy and set properties on zfs instances.

**Autorequires:** If Puppet is managing the zpool at the root of this zfs
instance, the zfs resource will autorequire it. If Puppet is managing any
parent zfs instances, the zfs resource will autorequire them.

<h3 id="zfs-attributes">Attributes</h3>

<pre><code>zfs { 'resource title':
  <a href="#zfs-attribute-name">name</a>           =&gt; <em># <strong>(namevar)</strong> The full name for this filesystem (including the </em>
  <a href="#zfs-attribute-ensure">ensure</a>         =&gt; <em># The basic property that the resource should be...</em>
  <a href="#zfs-attribute-aclinherit">aclinherit</a>     =&gt; <em># The aclinherit property. Valid values are...</em>
  <a href="#zfs-attribute-aclmode">aclmode</a>        =&gt; <em># The aclmode property. Valid values are...</em>
  <a href="#zfs-attribute-atime">atime</a>          =&gt; <em># The atime property. Valid values are `on`...</em>
  <a href="#zfs-attribute-canmount">canmount</a>       =&gt; <em># The canmount property. Valid values are `on`...</em>
  <a href="#zfs-attribute-checksum">checksum</a>       =&gt; <em># The checksum property. Valid values are `on`...</em>
  <a href="#zfs-attribute-compression">compression</a>    =&gt; <em># The compression property. Valid values are `on`, </em>
  <a href="#zfs-attribute-copies">copies</a>         =&gt; <em># The copies property. Valid values are `1`, `2`...</em>
  <a href="#zfs-attribute-dedup">dedup</a>          =&gt; <em># The dedup property. Valid values are `on`...</em>
  <a href="#zfs-attribute-devices">devices</a>        =&gt; <em># The devices property. Valid values are `on`...</em>
  <a href="#zfs-attribute-exec">exec</a>           =&gt; <em># The exec property. Valid values are `on`...</em>
  <a href="#zfs-attribute-logbias">logbias</a>        =&gt; <em># The logbias property. Valid values are...</em>
  <a href="#zfs-attribute-mountpoint">mountpoint</a>     =&gt; <em># The mountpoint property. Valid values are...</em>
  <a href="#zfs-attribute-nbmand">nbmand</a>         =&gt; <em># The nbmand property. Valid values are `on`...</em>
  <a href="#zfs-attribute-primarycache">primarycache</a>   =&gt; <em># The primarycache property. Valid values are...</em>
  <a href="#zfs-attribute-provider">provider</a>       =&gt; <em># The specific backend to use for this `zfs...</em>
  <a href="#zfs-attribute-quota">quota</a>          =&gt; <em># The quota property. Valid values are `&lt;size>`...</em>
  <a href="#zfs-attribute-readonly">readonly</a>       =&gt; <em># The readonly property. Valid values are `on`...</em>
  <a href="#zfs-attribute-recordsize">recordsize</a>     =&gt; <em># The recordsize property. Valid values are powers </em>
  <a href="#zfs-attribute-refquota">refquota</a>       =&gt; <em># The refquota property. Valid values are...</em>
  <a href="#zfs-attribute-refreservation">refreservation</a> =&gt; <em># The refreservation property. Valid values are...</em>
  <a href="#zfs-attribute-reservation">reservation</a>    =&gt; <em># The reservation property. Valid values are...</em>
  <a href="#zfs-attribute-secondarycache">secondarycache</a> =&gt; <em># The secondarycache property. Valid values are...</em>
  <a href="#zfs-attribute-setuid">setuid</a>         =&gt; <em># The setuid property. Valid values are `on`...</em>
  <a href="#zfs-attribute-shareiscsi">shareiscsi</a>     =&gt; <em># The shareiscsi property. Valid values are `on`...</em>
  <a href="#zfs-attribute-sharenfs">sharenfs</a>       =&gt; <em># The sharenfs property. Valid values are `on`...</em>
  <a href="#zfs-attribute-sharesmb">sharesmb</a>       =&gt; <em># The sharesmb property. Valid values are `on`...</em>
  <a href="#zfs-attribute-snapdir">snapdir</a>        =&gt; <em># The snapdir property. Valid values are `hidden`, </em>
  <a href="#zfs-attribute-version">version</a>        =&gt; <em># The version property. Valid values are `1`, `2`, </em>
  <a href="#zfs-attribute-volsize">volsize</a>        =&gt; <em># The volsize property. Valid values are...</em>
  <a href="#zfs-attribute-vscan">vscan</a>          =&gt; <em># The vscan property. Valid values are `on`...</em>
  <a href="#zfs-attribute-xattr">xattr</a>          =&gt; <em># The xattr property. Valid values are `on`...</em>
  <a href="#zfs-attribute-zoned">zoned</a>          =&gt; <em># The zoned property. Valid values are `on`...</em>
  # ...plus any applicable <a href="{{puppet}}/metaparameter.html">metaparameters</a>.
}</code></pre>

<h4 id="zfs-attribute-name">name</h4>

_(**Namevar:** If omitted, this attribute's value defaults to the resource's title.)_

The full name for this filesystem (including the zpool).

([↑ Back to zfs attributes](#zfs-attributes))

<h4 id="zfs-attribute-ensure">ensure</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The basic property that the resource should be in.

Valid values are `present`, `absent`.

([↑ Back to zfs attributes](#zfs-attributes))

<h4 id="zfs-attribute-aclinherit">aclinherit</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The aclinherit property. Valid values are `discard`, `noallow`, `restricted`, `passthrough`, `passthrough-x`.

([↑ Back to zfs attributes](#zfs-attributes))

<h4 id="zfs-attribute-aclmode">aclmode</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The aclmode property. Valid values are `discard`, `groupmask`, `passthrough`.

([↑ Back to zfs attributes](#zfs-attributes))

<h4 id="zfs-attribute-atime">atime</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The atime property. Valid values are `on`, `off`.

([↑ Back to zfs attributes](#zfs-attributes))

<h4 id="zfs-attribute-canmount">canmount</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The canmount property. Valid values are `on`, `off`, `noauto`.

([↑ Back to zfs attributes](#zfs-attributes))

<h4 id="zfs-attribute-checksum">checksum</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The checksum property. Valid values are `on`, `off`, `fletcher2`, `fletcher4`, `sha256`.

([↑ Back to zfs attributes](#zfs-attributes))

<h4 id="zfs-attribute-compression">compression</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The compression property. Valid values are `on`, `off`, `lzjb`, `gzip`, `gzip-[1-9]`, `zle`.

([↑ Back to zfs attributes](#zfs-attributes))

<h4 id="zfs-attribute-copies">copies</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The copies property. Valid values are `1`, `2`, `3`.

([↑ Back to zfs attributes](#zfs-attributes))

<h4 id="zfs-attribute-dedup">dedup</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The dedup property. Valid values are `on`, `off`.

([↑ Back to zfs attributes](#zfs-attributes))

<h4 id="zfs-attribute-devices">devices</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The devices property. Valid values are `on`, `off`.

([↑ Back to zfs attributes](#zfs-attributes))

<h4 id="zfs-attribute-exec">exec</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The exec property. Valid values are `on`, `off`.

([↑ Back to zfs attributes](#zfs-attributes))

<h4 id="zfs-attribute-logbias">logbias</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The logbias property. Valid values are `latency`, `throughput`.

([↑ Back to zfs attributes](#zfs-attributes))

<h4 id="zfs-attribute-mountpoint">mountpoint</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The mountpoint property. Valid values are `<path>`, `legacy`, `none`.

([↑ Back to zfs attributes](#zfs-attributes))

<h4 id="zfs-attribute-nbmand">nbmand</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The nbmand property. Valid values are `on`, `off`.

([↑ Back to zfs attributes](#zfs-attributes))

<h4 id="zfs-attribute-primarycache">primarycache</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The primarycache property. Valid values are `all`, `none`, `metadata`.

([↑ Back to zfs attributes](#zfs-attributes))

<h4 id="zfs-attribute-provider">provider</h4>

The specific backend to use for this `zfs`
resource. You will seldom need to specify this --- Puppet will usually
discover the appropriate provider for your platform.

Available providers are:

* [`zfs`](#zfs-provider-zfs)

([↑ Back to zfs attributes](#zfs-attributes))

<h4 id="zfs-attribute-quota">quota</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The quota property. Valid values are `<size>`, `none`.

([↑ Back to zfs attributes](#zfs-attributes))

<h4 id="zfs-attribute-readonly">readonly</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The readonly property. Valid values are `on`, `off`.

([↑ Back to zfs attributes](#zfs-attributes))

<h4 id="zfs-attribute-recordsize">recordsize</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The recordsize property. Valid values are powers of two between 512 and 128k.

([↑ Back to zfs attributes](#zfs-attributes))

<h4 id="zfs-attribute-refquota">refquota</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The refquota property. Valid values are `<size>`, `none`.

([↑ Back to zfs attributes](#zfs-attributes))

<h4 id="zfs-attribute-refreservation">refreservation</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The refreservation property. Valid values are `<size>`, `none`.

([↑ Back to zfs attributes](#zfs-attributes))

<h4 id="zfs-attribute-reservation">reservation</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The reservation property. Valid values are `<size>`, `none`.

([↑ Back to zfs attributes](#zfs-attributes))

<h4 id="zfs-attribute-secondarycache">secondarycache</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The secondarycache property. Valid values are `all`, `none`, `metadata`.

([↑ Back to zfs attributes](#zfs-attributes))

<h4 id="zfs-attribute-setuid">setuid</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The setuid property. Valid values are `on`, `off`.

([↑ Back to zfs attributes](#zfs-attributes))

<h4 id="zfs-attribute-shareiscsi">shareiscsi</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The shareiscsi property. Valid values are `on`, `off`, `type=<type>`.

([↑ Back to zfs attributes](#zfs-attributes))

<h4 id="zfs-attribute-sharenfs">sharenfs</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The sharenfs property. Valid values are `on`, `off`, share(1M) options

([↑ Back to zfs attributes](#zfs-attributes))

<h4 id="zfs-attribute-sharesmb">sharesmb</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The sharesmb property. Valid values are `on`, `off`, sharemgr(1M) options

([↑ Back to zfs attributes](#zfs-attributes))

<h4 id="zfs-attribute-snapdir">snapdir</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The snapdir property. Valid values are `hidden`, `visible`.

([↑ Back to zfs attributes](#zfs-attributes))

<h4 id="zfs-attribute-version">version</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The version property. Valid values are `1`, `2`, `3`, `4`, `current`.

([↑ Back to zfs attributes](#zfs-attributes))

<h4 id="zfs-attribute-volsize">volsize</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The volsize property. Valid values are `<size>`

([↑ Back to zfs attributes](#zfs-attributes))

<h4 id="zfs-attribute-vscan">vscan</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The vscan property. Valid values are `on`, `off`.

([↑ Back to zfs attributes](#zfs-attributes))

<h4 id="zfs-attribute-xattr">xattr</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The xattr property. Valid values are `on`, `off`.

([↑ Back to zfs attributes](#zfs-attributes))

<h4 id="zfs-attribute-zoned">zoned</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The zoned property. Valid values are `on`, `off`.

([↑ Back to zfs attributes](#zfs-attributes))


<h3 id="zfs-providers">Providers</h3>

<h4 id="zfs-provider-zfs">zfs</h4>

Provider for zfs.

* Required binaries: `zfs`.




> **NOTE:** This page was generated from the Puppet source code on 2016-08-10 20:10:55 -0500