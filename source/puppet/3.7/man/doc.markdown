---
layout: default
title: puppet doc Man Page
---

<div class='mp'>
<h2 id="NAME">NAME</h2>
<p class="man-name">
  <code>puppet-doc</code> - <span class="man-whatis">Generate Puppet documentation and references</span>
</p>

<h2 id="SYNOPSIS">SYNOPSIS</h2>

<p>Generates a reference for all Puppet types. Largely meant for internal
Puppet Labs use.</p>

<h2 id="USAGE">USAGE</h2>

<p>puppet doc [-a|--all] [-h|--help] [-l|--list] [-o|--outputdir <var>rdoc-outputdir</var>]
  [-m|--mode text|pdf|rdoc] [-r|--reference <var>reference-name</var>]
  [--charset <var>charset</var>] [<var>manifest-file</var>]</p>

<h2 id="DESCRIPTION">DESCRIPTION</h2>

<p>If mode is not 'rdoc', then this command generates a Markdown document
describing all installed Puppet types or all allowable arguments to
puppet executables. It is largely meant for internal use and is used to
generate the reference document available on the Puppet Labs web site.</p>

<p>In 'rdoc' mode, this command generates an html RDoc hierarchy describing
the manifests that are in 'manifestdir' and 'modulepath' configuration
directives. The generated documentation directory is doc by default but
can be changed with the 'outputdir' option.</p>

<p>If the command is run with the name of a manifest file as an argument,
puppet doc will output a single manifest's documentation on stdout.</p>

<h2 id="OPTIONS">OPTIONS</h2>

<dl>
<dt class="flush">--all</dt><dd><p>Output the docs for all of the reference types. In 'rdoc' mode, this also
outputs documentation for all resources.</p></dd>
<dt class="flush">--help</dt><dd><p>Print this help message</p></dd>
<dt>--outputdir</dt><dd><p>Used only in 'rdoc' mode. The directory to which the rdoc output should
be written.</p></dd>
<dt class="flush">--mode</dt><dd><p>Determine the output mode. Valid modes are 'text', 'pdf' and 'rdoc'. The 'pdf'
mode creates PDF formatted files in the /tmp directory. The default mode is
'text'.</p></dd>
<dt>--reference</dt><dd><p>Build a particular reference. Get a list of references by running
'puppet doc --list'.</p></dd>
<dt>--charset</dt><dd><p>Used only in 'rdoc' mode. It sets the charset used in the html files produced.</p></dd>
<dt>--manifestdir</dt><dd><p>Used only in 'rdoc' mode. The directory to scan for stand-alone manifests.
If not supplied, puppet doc will use the manifestdir from puppet.conf.</p></dd>
<dt>--modulepath</dt><dd><p>Used only in 'rdoc' mode. The directory or directories to scan for modules.
If not supplied, puppet doc will use the modulepath from puppet.conf.</p></dd>
<dt>--environment</dt><dd><p>Used only in 'rdoc' mode. The configuration environment from which
to read the modulepath and manifestdir settings, when reading said settings
from puppet.conf.</p></dd>
</dl>


<h2 id="EXAMPLE">EXAMPLE</h2>

<pre><code>$ puppet doc -r type &gt; /tmp/type_reference.markdown
</code></pre>

<p>or</p>

<pre><code>$ puppet doc --outputdir /tmp/rdoc --mode rdoc /path/to/manifests
</code></pre>

<p>or</p>

<pre><code>$ puppet doc /etc/puppet/manifests/site.pp
</code></pre>

<p>or</p>

<pre><code>$ puppet doc -m pdf -r configuration
</code></pre>

<h2 id="AUTHOR">AUTHOR</h2>

<p>Luke Kanies</p>

<h2 id="COPYRIGHT">COPYRIGHT</h2>

<p>Copyright (c) 2011 Puppet Labs, LLC Licensed under the Apache 2.0 License</p>

</div>
