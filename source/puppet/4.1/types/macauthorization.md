---
layout: default
built_from_commit: c4a6a76fd219bffd689476413985ed13f40ef1dd
title: 'Resource Type: macauthorization'
canonical: /puppet/latest/reference/types/macauthorization.html
---

> **NOTE:** This page was generated from the Puppet source code on 2016-01-27 14:22:05 +0000

macauthorization
-----

* [Attributes](#macauthorization-attributes)
* [Providers](#macauthorization-providers)

<h3 id="macauthorization-description">Description</h3>

Manage the Mac OS X authorization database. See the
[Apple developer site](http://developer.apple.com/documentation/Security/Conceptual/Security_Overview/Security_Services/chapter_4_section_5.html)
for more information.

Note that authorization store directives with hyphens in their names have
been renamed to use underscores, as Puppet does not react well to hyphens
in identifiers.

**Autorequires:** If Puppet is managing the `/etc/authorization` file, each
macauthorization resource will autorequire it.

<h3 id="macauthorization-attributes">Attributes</h3>

<pre><code>macauthorization { 'resource title':
  <a href="#macauthorization-attribute-name">name</a>              =&gt; <em># <strong>(namevar)</strong> The name of the right or rule to be managed...</em>
  <a href="#macauthorization-attribute-ensure">ensure</a>            =&gt; <em># The basic property that the resource should be...</em>
  <a href="#macauthorization-attribute-allow_root">allow_root</a>        =&gt; <em># Corresponds to `allow-root` in the authorization </em>
  <a href="#macauthorization-attribute-auth_class">auth_class</a>        =&gt; <em># Corresponds to `class` in the authorization...</em>
  <a href="#macauthorization-attribute-auth_type">auth_type</a>         =&gt; <em># Type --- this can be a `right` or a `rule`. The...</em>
  <a href="#macauthorization-attribute-authenticate_user">authenticate_user</a> =&gt; <em># Corresponds to `authenticate-user` in the...</em>
  <a href="#macauthorization-attribute-comment">comment</a>           =&gt; <em># The `comment` attribute for authorization...</em>
  <a href="#macauthorization-attribute-group">group</a>             =&gt; <em># A group which the user must authenticate as a...</em>
  <a href="#macauthorization-attribute-k_of_n">k_of_n</a>            =&gt; <em># How large a subset of rule mechanisms must...</em>
  <a href="#macauthorization-attribute-mechanisms">mechanisms</a>        =&gt; <em># An array of suitable...</em>
  <a href="#macauthorization-attribute-provider">provider</a>          =&gt; <em># The specific backend to use for this...</em>
  <a href="#macauthorization-attribute-rule">rule</a>              =&gt; <em># The rule(s) that this right refers...</em>
  <a href="#macauthorization-attribute-session_owner">session_owner</a>     =&gt; <em># Whether the session owner automatically matches...</em>
  <a href="#macauthorization-attribute-shared">shared</a>            =&gt; <em># Whether the Security Server should mark the...</em>
  <a href="#macauthorization-attribute-timeout">timeout</a>           =&gt; <em># The number of seconds in which the credential...</em>
  <a href="#macauthorization-attribute-tries">tries</a>             =&gt; <em># The number of tries...</em>
  # ...plus any applicable <a href="./metaparameter.html">metaparameters</a>.
}</code></pre>

<h4 id="macauthorization-attribute-name">name</h4>

_(**Namevar:** If omitted, this attribute's value defaults to the resource's title.)_

The name of the right or rule to be managed.
Corresponds to `key` in Authorization Services. The key is the name
of a rule. A key uses the same naming conventions as a right. The
Security Server uses a rule's key to match the rule with a right.
Wildcard keys end with a '.'. The generic rule has an empty key value.
Any rights that do not match a specific rule use the generic rule.

([↑ Back to macauthorization attributes](#macauthorization-attributes))

<h4 id="macauthorization-attribute-ensure">ensure</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The basic property that the resource should be in.

Valid values are `present`, `absent`.

([↑ Back to macauthorization attributes](#macauthorization-attributes))

<h4 id="macauthorization-attribute-allow_root">allow_root</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Corresponds to `allow-root` in the authorization store. Specifies
whether a right should be allowed automatically if the requesting process
is running with `uid == 0`.  AuthorizationServices defaults this attribute
to false if not specified.

Valid values are `true`, `false`.

([↑ Back to macauthorization attributes](#macauthorization-attributes))

<h4 id="macauthorization-attribute-auth_class">auth_class</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Corresponds to `class` in the authorization store; renamed due
to 'class' being a reserved word in Puppet.

Valid values are `user`, `evaluate-mechanisms`, `allow`, `deny`, `rule`.

([↑ Back to macauthorization attributes](#macauthorization-attributes))

<h4 id="macauthorization-attribute-auth_type">auth_type</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Type --- this can be a `right` or a `rule`. The `comment` type has
not yet been implemented.

Valid values are `right`, `rule`.

([↑ Back to macauthorization attributes](#macauthorization-attributes))

<h4 id="macauthorization-attribute-authenticate_user">authenticate_user</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Corresponds to `authenticate-user` in the authorization store.

Valid values are `true`, `false`.

([↑ Back to macauthorization attributes](#macauthorization-attributes))

<h4 id="macauthorization-attribute-comment">comment</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The `comment` attribute for authorization resources.

([↑ Back to macauthorization attributes](#macauthorization-attributes))

<h4 id="macauthorization-attribute-group">group</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

A group which the user must authenticate as a member of. This
must be a single group.

([↑ Back to macauthorization attributes](#macauthorization-attributes))

<h4 id="macauthorization-attribute-k_of_n">k_of_n</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

How large a subset of rule mechanisms must succeed for successful
authentication. If there are 'n' mechanisms, then 'k' (the integer value
of this parameter) mechanisms must succeed. The most common setting for
this parameter is `1`. If `k-of-n` is not set, then every mechanism ---
that is, 'n-of-n' --- must succeed.

([↑ Back to macauthorization attributes](#macauthorization-attributes))

<h4 id="macauthorization-attribute-mechanisms">mechanisms</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

An array of suitable mechanisms.

([↑ Back to macauthorization attributes](#macauthorization-attributes))

<h4 id="macauthorization-attribute-provider">provider</h4>

The specific backend to use for this `macauthorization`
resource. You will seldom need to specify this --- Puppet will usually
discover the appropriate provider for your platform.

Available providers are:

* [`macauthorization`](#macauthorization-provider-macauthorization)

([↑ Back to macauthorization attributes](#macauthorization-attributes))

<h4 id="macauthorization-attribute-rule">rule</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The rule(s) that this right refers to.

([↑ Back to macauthorization attributes](#macauthorization-attributes))

<h4 id="macauthorization-attribute-session_owner">session_owner</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Whether the session owner automatically matches this rule or right.
Corresponds to `session-owner` in the authorization store.

Valid values are `true`, `false`.

([↑ Back to macauthorization attributes](#macauthorization-attributes))

<h4 id="macauthorization-attribute-shared">shared</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Whether the Security Server should mark the credentials used to gain
this right as shared. The Security Server may use any shared credentials
to authorize this right. For maximum security, set sharing to false so
credentials stored by the Security Server for one application may not be
used by another application.

Valid values are `true`, `false`.

([↑ Back to macauthorization attributes](#macauthorization-attributes))

<h4 id="macauthorization-attribute-timeout">timeout</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The number of seconds in which the credential used by this rule will
expire. For maximum security where the user must authenticate every time,
set the timeout to 0. For minimum security, remove the timeout attribute
so the user authenticates only once per session.

([↑ Back to macauthorization attributes](#macauthorization-attributes))

<h4 id="macauthorization-attribute-tries">tries</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The number of tries allowed.

([↑ Back to macauthorization attributes](#macauthorization-attributes))


<h3 id="macauthorization-providers">Providers</h3>

<h4 id="macauthorization-provider-macauthorization">macauthorization</h4>

Manage Mac OS X authorization database rules and rights.

* Required binaries: `/usr/bin/security`.
* Default for `operatingsystem` == `darwin`.




> **NOTE:** This page was generated from the Puppet source code on 2016-01-27 14:22:05 +0000