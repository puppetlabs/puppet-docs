---
layout: default
built_from_commit: 4e0b2b9b2c68e41c386308d71d23d9b26fbfa154
title: 'Man Page: puppet doc'
canonical: /puppet/latest/reference/man/doc.html
---

<div class='mp'>
<h2 id="NAME">NAME</h2>
<p class="man-name">
  <code>puppet-doc</code> - <span class="man-whatis">Generate Puppet references</span>
</p>

<h2 id="SYNOPSIS">SYNOPSIS</h2>

<p>Generates a reference for all Puppet types. Largely meant for internal
Puppet Labs use. (Deprecated)</p>

<h2 id="USAGE">USAGE</h2>

<p>puppet doc [-h|--help] [-l|--list]
  [-r|--reference <var>reference-name</var>]</p>

<h2 id="DESCRIPTION">DESCRIPTION</h2>

<p>This deprecated command generates a Markdown document to stdout
describing all installed Puppet types or all allowable arguments to
puppet executables. It is largely meant for internal use and is used to
generate the reference document available on the Puppet Labs web site.</p>

<p>For Puppet module documentation (and all other use cases) this command
has been superseded by the "puppet-strings"
module - see https://github.com/puppetlabs/puppetlabs-strings for more information.</p>

<p>This command (puppet-doc) will be removed once the
puppetlabs internal documentation processing pipeline is completely based
on puppet-strings.</p>

<h2 id="OPTIONS">OPTIONS</h2>

<dl>
<dt class="flush">--help</dt><dd><p>Print this help message</p></dd>
<dt>--reference</dt><dd><p>Build a particular reference. Get a list of references by running
'puppet doc --list'.</p></dd>
</dl>


<h2 id="EXAMPLE">EXAMPLE</h2>

<pre><code>$ puppet doc -r type &gt; /tmp/type_reference.markdown
</code></pre>

<h2 id="AUTHOR">AUTHOR</h2>

<p>Luke Kanies</p>

<h2 id="COPYRIGHT">COPYRIGHT</h2>

<p>Copyright (c) 2011 Puppet Labs, LLC Licensed under the Apache 2.0 License</p>

</div>
