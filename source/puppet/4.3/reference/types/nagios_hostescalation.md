---
layout: default
built_from_commit: 08dbaf538d4bb530b97815b9a88857bf93a63c49
title: 'Resource Type: nagios_hostescalation'
canonical: /references/latest/types/nagios_hostescalation.html
---

> **NOTE:** This page was generated from the Puppet source code on 2016-01-15 16:54:12 +0100

nagios_hostescalation
-----

* [Attributes](#nagios_hostescalation-attributes)
* [Providers](#nagios_hostescalation-providers)

<h3 id="nagios_hostescalation-description">Description</h3>

The Nagios type hostescalation.  This resource type is autogenerated using the
model developed in Naginator, and all of the Nagios types are generated using the
same code and the same library.

This type generates Nagios configuration statements in Nagios-parseable configuration
files.  By default, the statements will be added to `/etc/nagios/nagios_hostescalation.cfg`, but
you can send them to a different file by setting their `target` attribute.

You can purge Nagios resources using the `resources` type, but *only*
in the default file locations.  This is an architectural limitation.

<h3 id="nagios_hostescalation-attributes">Attributes</h3>

<pre><code>nagios_hostescalation { 'resource title':
  <a href="#nagios_hostescalation-attribute-_naginator_name">_naginator_name</a>       =&gt; <em># <strong>(namevar)</strong> The name of this nagios_hostescalation...</em>
  <a href="#nagios_hostescalation-attribute-ensure">ensure</a>                =&gt; <em># The basic property that the resource should be...</em>
  <a href="#nagios_hostescalation-attribute-contact_groups">contact_groups</a>        =&gt; <em># Nagios configuration file...</em>
  <a href="#nagios_hostescalation-attribute-contacts">contacts</a>              =&gt; <em># Nagios configuration file...</em>
  <a href="#nagios_hostescalation-attribute-escalation_options">escalation_options</a>    =&gt; <em># Nagios configuration file...</em>
  <a href="#nagios_hostescalation-attribute-escalation_period">escalation_period</a>     =&gt; <em># Nagios configuration file...</em>
  <a href="#nagios_hostescalation-attribute-first_notification">first_notification</a>    =&gt; <em># Nagios configuration file...</em>
  <a href="#nagios_hostescalation-attribute-group">group</a>                 =&gt; <em># The desired group of the config file for this...</em>
  <a href="#nagios_hostescalation-attribute-host_name">host_name</a>             =&gt; <em># Nagios configuration file...</em>
  <a href="#nagios_hostescalation-attribute-hostgroup_name">hostgroup_name</a>        =&gt; <em># Nagios configuration file...</em>
  <a href="#nagios_hostescalation-attribute-last_notification">last_notification</a>     =&gt; <em># Nagios configuration file...</em>
  <a href="#nagios_hostescalation-attribute-mode">mode</a>                  =&gt; <em># The desired mode of the config file for this...</em>
  <a href="#nagios_hostescalation-attribute-notification_interval">notification_interval</a> =&gt; <em># Nagios configuration file...</em>
  <a href="#nagios_hostescalation-attribute-owner">owner</a>                 =&gt; <em># The desired owner of the config file for this...</em>
  <a href="#nagios_hostescalation-attribute-provider">provider</a>              =&gt; <em># The specific backend to use for this...</em>
  <a href="#nagios_hostescalation-attribute-register">register</a>              =&gt; <em># Nagios configuration file...</em>
  <a href="#nagios_hostescalation-attribute-target">target</a>                =&gt; <em># The...</em>
  <a href="#nagios_hostescalation-attribute-use">use</a>                   =&gt; <em># Nagios configuration file...</em>
  # ...plus any applicable <a href="./metaparameter.html">metaparameters</a>.
}</code></pre>

<h4 id="nagios_hostescalation-attribute-_naginator_name">_naginator_name</h4>

_(**Namevar:** If omitted, this attribute's value defaults to the resource's title.)_

The name of this nagios_hostescalation resource.

([↑ Back to nagios_hostescalation attributes](#nagios_hostescalation-attributes))

<h4 id="nagios_hostescalation-attribute-ensure">ensure</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The basic property that the resource should be in.

Valid values are `present`, `absent`.

([↑ Back to nagios_hostescalation attributes](#nagios_hostescalation-attributes))

<h4 id="nagios_hostescalation-attribute-contact_groups">contact_groups</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Nagios configuration file parameter.

([↑ Back to nagios_hostescalation attributes](#nagios_hostescalation-attributes))

<h4 id="nagios_hostescalation-attribute-contacts">contacts</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Nagios configuration file parameter.

([↑ Back to nagios_hostescalation attributes](#nagios_hostescalation-attributes))

<h4 id="nagios_hostescalation-attribute-escalation_options">escalation_options</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Nagios configuration file parameter.

([↑ Back to nagios_hostescalation attributes](#nagios_hostescalation-attributes))

<h4 id="nagios_hostescalation-attribute-escalation_period">escalation_period</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Nagios configuration file parameter.

([↑ Back to nagios_hostescalation attributes](#nagios_hostescalation-attributes))

<h4 id="nagios_hostescalation-attribute-first_notification">first_notification</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Nagios configuration file parameter.

([↑ Back to nagios_hostescalation attributes](#nagios_hostescalation-attributes))

<h4 id="nagios_hostescalation-attribute-group">group</h4>

The desired group of the config file for this nagios_hostescalation resource.

NOTE: If the target file is explicitly managed by a file resource in your manifest,
this parameter has no effect. If a parent directory of the target is managed by
a recursive file resource, this limitation does not apply (i.e., this parameter
takes precedence, and if purge is used, the target file is exempt).

([↑ Back to nagios_hostescalation attributes](#nagios_hostescalation-attributes))

<h4 id="nagios_hostescalation-attribute-host_name">host_name</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Nagios configuration file parameter.

([↑ Back to nagios_hostescalation attributes](#nagios_hostescalation-attributes))

<h4 id="nagios_hostescalation-attribute-hostgroup_name">hostgroup_name</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Nagios configuration file parameter.

([↑ Back to nagios_hostescalation attributes](#nagios_hostescalation-attributes))

<h4 id="nagios_hostescalation-attribute-last_notification">last_notification</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Nagios configuration file parameter.

([↑ Back to nagios_hostescalation attributes](#nagios_hostescalation-attributes))

<h4 id="nagios_hostescalation-attribute-mode">mode</h4>

The desired mode of the config file for this nagios_hostescalation resource.

NOTE: If the target file is explicitly managed by a file resource in your manifest,
this parameter has no effect. If a parent directory of the target is managed by
a recursive file resource, this limitation does not apply (i.e., this parameter
takes precedence, and if purge is used, the target file is exempt).

([↑ Back to nagios_hostescalation attributes](#nagios_hostescalation-attributes))

<h4 id="nagios_hostescalation-attribute-notification_interval">notification_interval</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Nagios configuration file parameter.

([↑ Back to nagios_hostescalation attributes](#nagios_hostescalation-attributes))

<h4 id="nagios_hostescalation-attribute-owner">owner</h4>

The desired owner of the config file for this nagios_hostescalation resource.

NOTE: If the target file is explicitly managed by a file resource in your manifest,
this parameter has no effect. If a parent directory of the target is managed by
a recursive file resource, this limitation does not apply (i.e., this parameter
takes precedence, and if purge is used, the target file is exempt).

([↑ Back to nagios_hostescalation attributes](#nagios_hostescalation-attributes))

<h4 id="nagios_hostescalation-attribute-provider">provider</h4>

The specific backend to use for this `nagios_hostescalation`
resource. You will seldom need to specify this --- Puppet will usually
discover the appropriate provider for your platform.

Available providers are:

* [`naginator`](#nagios_hostescalation-provider-naginator)

([↑ Back to nagios_hostescalation attributes](#nagios_hostescalation-attributes))

<h4 id="nagios_hostescalation-attribute-register">register</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Nagios configuration file parameter.

([↑ Back to nagios_hostescalation attributes](#nagios_hostescalation-attributes))

<h4 id="nagios_hostescalation-attribute-target">target</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The target.

([↑ Back to nagios_hostescalation attributes](#nagios_hostescalation-attributes))

<h4 id="nagios_hostescalation-attribute-use">use</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Nagios configuration file parameter.

([↑ Back to nagios_hostescalation attributes](#nagios_hostescalation-attributes))


<h3 id="nagios_hostescalation-providers">Providers</h3>

<h4 id="nagios_hostescalation-provider-naginator">naginator</h4>






> **NOTE:** This page was generated from the Puppet source code on 2016-01-15 16:54:12 +0100