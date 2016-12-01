---
layout: default
built_from_commit: e800bc25e695b8e8b58521d0a6ecdbd18aab031b
title: 'Resource Type: mcx'
canonical: /puppet/latest/reference/types/mcx.html
---

> **NOTE:** This page was generated from the Puppet source code on 2016-03-16 18:28:11 -0700

mcx
-----

* [Attributes](#mcx-attributes)
* [Providers](#mcx-providers)
* [Provider Features](#mcx-provider-features)

<h3 id="mcx-description">Description</h3>

MCX object management using DirectoryService on OS X.

The default provider of this type merely manages the XML plist as
reported by the `dscl -mcxexport` command.  This is similar to the
content property of the file type in Puppet.

The recommended method of using this type is to use Work Group Manager
to manage users and groups on the local computer, record the resulting
puppet manifest using the command `puppet resource mcx`, then deploy it
to other machines.

**Autorequires:** If Puppet is managing the user, group, or computer that these
MCX settings refer to, the MCX resource will autorequire that user, group, or computer.

<h3 id="mcx-attributes">Attributes</h3>

<pre><code>mcx { 'resource title':
  <a href="#mcx-attribute-name">name</a>     =&gt; <em># <strong>(namevar)</strong> The name of the resource being managed. The...</em>
  <a href="#mcx-attribute-ensure">ensure</a>   =&gt; <em># Create or remove the MCX setting.  Valid values...</em>
  <a href="#mcx-attribute-content">content</a>  =&gt; <em># The XML Plist used as the value of MCXSettings...</em>
  <a href="#mcx-attribute-ds_name">ds_name</a>  =&gt; <em># The name to attach the MCX Setting to. (For...</em>
  <a href="#mcx-attribute-ds_type">ds_type</a>  =&gt; <em># The DirectoryService type this MCX setting...</em>
  <a href="#mcx-attribute-provider">provider</a> =&gt; <em># The specific backend to use for this `mcx...</em>
  # ...plus any applicable <a href="./metaparameter.html">metaparameters</a>.
}</code></pre>

<h4 id="mcx-attribute-name">name</h4>

_(**Namevar:** If omitted, this attribute's value defaults to the resource's title.)_

The name of the resource being managed.
The default naming convention follows Directory Service paths:

    /Computers/localhost
    /Groups/admin
    /Users/localadmin

The `ds_type` and `ds_name` type parameters are not necessary if the
default naming convention is followed.

([↑ Back to mcx attributes](#mcx-attributes))

<h4 id="mcx-attribute-ensure">ensure</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Create or remove the MCX setting.

Valid values are `present`, `absent`.

([↑ Back to mcx attributes](#mcx-attributes))

<h4 id="mcx-attribute-content">content</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The XML Plist used as the value of MCXSettings in DirectoryService.
This is the standard output from the system command:

    dscl localhost -mcxexport /Local/Default/<ds_type>/ds_name

Note that `ds_type` is capitalized and plural in the dscl command.



Requires features manages_content.

([↑ Back to mcx attributes](#mcx-attributes))

<h4 id="mcx-attribute-ds_name">ds_name</h4>

The name to attach the MCX Setting to. (For example, `localhost`
when `ds_type => computer`.) This setting is not required, as it can be
automatically discovered when the resource name is parseable.  (For
example, in `/Groups/admin`, `group` will be used as the dstype.)

([↑ Back to mcx attributes](#mcx-attributes))

<h4 id="mcx-attribute-ds_type">ds_type</h4>

The DirectoryService type this MCX setting attaches to.

Valid values are `user`, `group`, `computer`, `computerlist`.

([↑ Back to mcx attributes](#mcx-attributes))

<h4 id="mcx-attribute-provider">provider</h4>

The specific backend to use for this `mcx`
resource. You will seldom need to specify this --- Puppet will usually
discover the appropriate provider for your platform.

Available providers are:

* [`mcxcontent`](#mcx-provider-mcxcontent)

([↑ Back to mcx attributes](#mcx-attributes))


<h3 id="mcx-providers">Providers</h3>

<h4 id="mcx-provider-mcxcontent">mcxcontent</h4>

MCX Settings management using DirectoryService on OS X.

This provider manages the entire MCXSettings attribute available
to some directory services nodes.  This management is 'all or nothing'
in that discrete application domain key value pairs are not managed
by this provider.

It is recommended to use WorkGroup Manager to configure Users, Groups,
Computers, or ComputerLists, then use 'ralsh mcx' to generate a puppet
manifest from the resulting configuration.

Original Author: Jeff McCune (mccune.jeff@gmail.com)

* Required binaries: `/usr/bin/dscl`.
* Default for `operatingsystem` == `darwin`.
* Supported features: `manages_content`.

<h3 id="mcx-provider-features">Provider Features</h3>

Available features:

* `manages_content` --- The provider can manage MCXSettings as a string.

Provider support:

<table>
  <thead>
    <tr>
      <th>Provider</th>
      <th>manages content</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>mcxcontent</td>
      <td><em>X</em> </td>
    </tr>
  </tbody>
</table>



> **NOTE:** This page was generated from the Puppet source code on 2016-03-16 18:28:11 -0700