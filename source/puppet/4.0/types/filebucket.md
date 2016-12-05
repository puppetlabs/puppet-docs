---
layout: default
built_from_commit: 08cb8b2d315a296fa404a4871f94b3703a819461
title: 'Resource Type: filebucket'
canonical: /puppet/latest/reference/types/filebucket.html
---

> **NOTE:** This page was generated from the Puppet source code on 2016-01-27 14:24:39 +0000

filebucket
-----

* [Attributes](#filebucket-attributes)

<h3 id="filebucket-description">Description</h3>

A repository for storing and retrieving file content by MD5 checksum. Can
be local to each agent node, or centralized on a puppet master server. All
puppet masters provide a filebucket service that agent nodes can access
via HTTP, but you must declare a filebucket resource before any agents
will do so.

Filebuckets are used for the following features:

- **Content backups.** If the `file` type's `backup` attribute is set to
  the name of a filebucket, Puppet will back up the _old_ content whenever
  it rewrites a file; see the documentation for the `file` type for more
  details. These backups can be used for manual recovery of content, but
  are more commonly used to display changes and differences in a tool like
  Puppet Dashboard.
- **Content distribution.** The optional static compiler populates the
  puppet master's filebucket with the _desired_ content for each file,
  then instructs the agent to retrieve the content for a specific
  checksum. For more details,
  [see the `static_compiler` section in the catalog indirection docs](http://docs.puppetlabs.com/references/latest/indirection.html#catalog).

To use a central filebucket for backups, you will usually want to declare
a filebucket resource and a resource default for the `backup` attribute
in site.pp:

    # /etc/puppetlabs/puppet/manifests/site.pp
    filebucket { 'main':
      path   => false,                # This is required for remote filebuckets.
      server => 'puppet.example.com', # Optional; defaults to the configured puppet master.
    }

    File { backup => main, }

Puppet master servers automatically provide the filebucket service, so
this will work in a default configuration. If you have a heavily
restricted `auth.conf` file, you may need to allow access to the
`file_bucket_file` endpoint.

<h3 id="filebucket-attributes">Attributes</h3>

<pre><code>filebucket { 'resource title':
  <a href="#filebucket-attribute-name">name</a>   =&gt; <em># <strong>(namevar)</strong> The name of the...</em>
  <a href="#filebucket-attribute-path">path</a>   =&gt; <em># The path to the _local_ filebucket; defaults to...</em>
  <a href="#filebucket-attribute-port">port</a>   =&gt; <em># The port on which the remote server is...</em>
  <a href="#filebucket-attribute-server">server</a> =&gt; <em># The server providing the remote filebucket...</em>
  # ...plus any applicable <a href="./metaparameter.html">metaparameters</a>.
}</code></pre>

<h4 id="filebucket-attribute-name">name</h4>

_(**Namevar:** If omitted, this attribute's value defaults to the resource's title.)_

The name of the filebucket.

([↑ Back to filebucket attributes](#filebucket-attributes))

<h4 id="filebucket-attribute-path">path</h4>

The path to the _local_ filebucket; defaults to the value of the
`clientbucketdir` setting.  To use a remote filebucket, you _must_ set
this attribute to `false`.

([↑ Back to filebucket attributes](#filebucket-attributes))

<h4 id="filebucket-attribute-port">port</h4>

The port on which the remote server is listening. Defaults to the
value of the `masterport` setting, which is usually 8140.

([↑ Back to filebucket attributes](#filebucket-attributes))

<h4 id="filebucket-attribute-server">server</h4>

The server providing the remote filebucket service. Defaults to the
value of the `server` setting (that is, the currently configured
puppet master server).

This setting is _only_ consulted if the `path` attribute is set to `false`.

([↑ Back to filebucket attributes](#filebucket-attributes))





> **NOTE:** This page was generated from the Puppet source code on 2016-01-27 14:24:39 +0000