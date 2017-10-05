---
layout: default
built_from_commit: ab595327c42b4fbafdd669d8a0208ce081c03133
title: 'Resource Type: selmodule'
canonical: "/puppet/latest/types/selmodule.html"
---

> **NOTE:** This page was generated from the Puppet source code on 2017-10-04 17:17:52 -0700

selmodule
-----

* [Attributes](#selmodule-attributes)
* [Providers](#selmodule-providers)

<h3 id="selmodule-description">Description</h3>

Manages loading and unloading of SELinux policy modules
on the system.  Requires SELinux support.  See man semodule(8)
for more information on SELinux policy modules.

**Autorequires:** If Puppet is managing the file containing this SELinux
policy module (which is either explicitly specified in the `selmodulepath`
attribute or will be found at {`selmoduledir`}/{`name`}.pp), the selmodule
resource will autorequire that file.

<h3 id="selmodule-attributes">Attributes</h3>

<pre><code>selmodule { 'resource title':
  <a href="#selmodule-attribute-name">name</a>          =&gt; <em># <strong>(namevar)</strong> The name of the SELinux policy to be managed....</em>
  <a href="#selmodule-attribute-ensure">ensure</a>        =&gt; <em># The basic property that the resource should be...</em>
  <a href="#selmodule-attribute-selmoduledir">selmoduledir</a>  =&gt; <em># The directory to look for the compiled pp module </em>
  <a href="#selmodule-attribute-selmodulepath">selmodulepath</a> =&gt; <em># The full path to the compiled .pp policy module. </em>
  <a href="#selmodule-attribute-syncversion">syncversion</a>   =&gt; <em># If set to `true`, the policy will be reloaded if </em>
  # ...plus any applicable <a href="{{puppet}}/metaparameter.html">metaparameters</a>.
}</code></pre>

<h4 id="selmodule-attribute-name">name</h4>

_(**Namevar:** If omitted, this attribute's value defaults to the resource's title.)_

The name of the SELinux policy to be managed.  You should not
include the customary trailing .pp extension.

([↑ Back to selmodule attributes](#selmodule-attributes))

<h4 id="selmodule-attribute-ensure">ensure</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The basic property that the resource should be in.

Default: `present`

Allowed values:

* `present`
* `absent`

([↑ Back to selmodule attributes](#selmodule-attributes))

<h4 id="selmodule-attribute-selmoduledir">selmoduledir</h4>

The directory to look for the compiled pp module file in.
Currently defaults to `/usr/share/selinux/targeted`.  If the
`selmodulepath` attribute is not specified, Puppet will expect to find
the module in `<selmoduledir>/<name>.pp`, where `name` is the value of the
`name` parameter.

Default: `/usr/share/selinux/targeted`

([↑ Back to selmodule attributes](#selmodule-attributes))

<h4 id="selmodule-attribute-selmodulepath">selmodulepath</h4>

The full path to the compiled .pp policy module.  You only need to use
this if the module file is not in the `selmoduledir` directory.

([↑ Back to selmodule attributes](#selmodule-attributes))

<h4 id="selmodule-attribute-syncversion">syncversion</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

If set to `true`, the policy will be reloaded if the
version found in the on-disk file differs from the loaded
version.  If set to `false` (the default) the only check
that will be made is if the policy is loaded at all or not.

Allowed values:

* `true`
* `false`

([↑ Back to selmodule attributes](#selmodule-attributes))


<h3 id="selmodule-providers">Providers</h3>

<h4 id="selmodule-provider-semodule">semodule</h4>

Manage SELinux policy modules using the semodule binary.

* Required binaries: `/usr/sbin/semodule`




> **NOTE:** This page was generated from the Puppet source code on 2017-10-04 17:17:52 -0700