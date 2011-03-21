---
layout: default
title: puppet inspect Manual Page
---

puppet inspect Manual Page
======

<div class='mp'>
<h2 id="NAME">NAME</h2>
<p class="man-name">
  <code>puppet-inspect</code> - <span class="man-whatis">Send an inspection report</span>
</p>

<h2 id="SYNOPSIS">SYNOPSIS</h2>

<p>Prepares and submits an inspection report to the puppet master.</p>

<h2 id="USAGE">USAGE</h2>

<p>puppet inspect</p>

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

<h2 id="AUTHOR">AUTHOR</h2>

<p>Puppet Labs</p>

<h2 id="COPYRIGHT">COPYRIGHT</h2>

<p>Copyright (c) 2011 Puppet Labs, LLC
Licensed under the GNU General Public License version 2</p>

</div>
