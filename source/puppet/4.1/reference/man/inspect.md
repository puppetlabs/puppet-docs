---
layout: default
built_from_commit: c4a6a76fd219bffd689476413985ed13f40ef1dd
title: 'Man Page: puppet inspect'
canonical: /puppet/latest/reference/man/inspect.html
---

<div class='mp'>
<h2 id="NAME">NAME</h2>
<p class="man-name">
  <code>puppet-inspect</code> - <span class="man-whatis">Send an inspection report</span>
</p>

<h2 id="SYNOPSIS">SYNOPSIS</h2>

<p>Prepares and submits an inspection report to the puppet master.</p>

<h2 id="USAGE">USAGE</h2>

<p>puppet inspect [--archive_files] [--archive_file_server]</p>

<h2 id="DESCRIPTION">DESCRIPTION</h2>

<p>This command uses the cached catalog from the previous run of 'puppet
agent' to determine which attributes of which resources have been
marked as auditable with the 'audit' metaparameter. It then examines
the current state of the system, writes the state of the specified
resource attributes to a report, and submits the report to the puppet
master.</p>

<p>Puppet inspect does not run as a daemon, and must be run manually or
from cron.</p>

<h2 id="OPTIONS">OPTIONS</h2>

<p>Any configuration setting which is valid in the configuration file is
also a valid long argument, e.g. '--server=master.domain.com'. See the
configuration file documentation at
http://docs.puppetlabs.com/references/latest/configuration.html for
the full list of acceptable settings.</p>

<dl>
<dt>--archive_files</dt><dd><p>During an inspect run, whether to archive files whose contents are audited to
a file bucket.</p></dd>
<dt>--archive_file_server</dt><dd><p>During an inspect run, the file bucket server to archive files to if
archive_files is set.  The default value is '$server'.</p></dd>
</dl>


<h2 id="AUTHOR">AUTHOR</h2>

<p>Puppet Labs</p>

<h2 id="COPYRIGHT">COPYRIGHT</h2>

<p>Copyright (c) 2011 Puppet Labs, LLC Licensed under the Apache 2.0 License</p>

</div>
