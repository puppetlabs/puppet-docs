---
layout: default
built_from_commit: a6789531f5d7efbde2f8e526f80e71518121b397
title: 'Man Page: puppet describe'
canonical: "/puppet/latest/man/describe.html"
---

<div class='mp'>
<h2 id="NAME">NAME</h2>
<p class="man-name">
  <code>puppet-describe</code> - <span class="man-whatis">Display help about resource types</span>
</p>

<h2 id="SYNOPSIS">SYNOPSIS</h2>

<p>Prints help about Puppet resource types, providers, and metaparameters.</p>

<h2 id="USAGE">USAGE</h2>

<p>puppet describe [-h|--help] [-s|--short] [-p|--providers] [-l|--list] [-m|--meta]</p>

<h2 id="OPTIONS">OPTIONS</h2>

<dl>
<dt class="flush">--help</dt><dd><p>Print this help text</p></dd>
<dt>--providers</dt><dd><p>Describe providers in detail for each type</p></dd>
<dt class="flush">--list</dt><dd><p>List all types</p></dd>
<dt class="flush">--meta</dt><dd><p>List all metaparameters</p></dd>
<dt class="flush">--short</dt><dd><p>List only parameters without detail</p></dd>
</dl>


<h2 id="EXAMPLE">EXAMPLE</h2>

<pre><code>$ puppet describe --list
$ puppet describe file --providers
$ puppet describe user -s -m
</code></pre>

<h2 id="AUTHOR">AUTHOR</h2>

<p>David Lutterkort</p>

<h2 id="COPYRIGHT">COPYRIGHT</h2>

<p>Copyright (c) 2011 Puppet Inc., LLC Licensed under the Apache 2.0 License</p>

</div>
