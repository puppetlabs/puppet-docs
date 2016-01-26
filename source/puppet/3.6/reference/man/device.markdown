---
layout: default
title: puppet device Man Page
---

<div class='mp'>
<h2 id="NAME">NAME</h2>
<p class="man-name">
  <code>puppet-device</code> - <span class="man-whatis">Manage remote network devices</span>
</p>

<h2 id="SYNOPSIS">SYNOPSIS</h2>

<p>Retrieves all configurations from the puppet master and apply
them to the remote devices configured in /etc/puppet/device.conf.</p>

<p>Currently must be run out periodically, using cron or something similar.</p>

<h2 id="USAGE">USAGE</h2>

<p>  puppet device [-d|--debug] [--detailed-exitcodes] [-V|--version]
                [-h|--help] [-l|--logdest syslog|<var>file</var>|console]
                [-v|--verbose] [-w|--waitforcert <var>seconds</var>]</p>

<h2 id="DESCRIPTION">DESCRIPTION</h2>

<p>Once the client has a signed certificate for a given remote device, it will
retrieve its configuration and apply it.</p>

<h2 id="USAGE-NOTES">USAGE NOTES</h2>

<p>One need a /etc/puppet/device.conf file with the following content:</p>

<p>[remote.device.fqdn]
type <var>type</var>
url <var>url</var></p>

<p>where:
 * type: the current device type (the only value at this time is cisco)
 * url: an url allowing to connect to the device</p>

<p>Supported url must conforms to:
 scheme://user:password@hostname/?query</p>

<p> with:
  * scheme: either ssh or telnet
  * user: username, can be omitted depending on the switch/router configuration
  * password: the connection password
  * query: this is device specific. Cisco devices supports an enable parameter whose
  value would be the enable password.</p>

<h2 id="OPTIONS">OPTIONS</h2>

<p>Note that any setting that's valid in the configuration file
is also a valid long argument.  For example, 'server' is a valid configuration
parameter, so you can specify '--server <var>servername</var>' as an argument.</p>

<dl>
<dt class="flush">--debug</dt><dd><p>Enable full debugging.</p></dd>
<dt>--detailed-exitcodes</dt><dd><p>Provide transaction information via exit codes. If this is enabled, an exit
code of '2' means there were changes, an exit code of '4' means there were
failures during the transaction, and an exit code of '6' means there were both
changes and failures.</p></dd>
<dt class="flush">--help</dt><dd><p>Print this help message</p></dd>
<dt>--logdest</dt><dd><p>Where to send messages.  Choose between syslog, the console, and a log file.
Defaults to sending messages to syslog, or the console if debugging or
verbosity is enabled.</p></dd>
<dt>--verbose</dt><dd><p>Turn on verbose reporting.</p></dd>
<dt>--waitforcert</dt><dd><p>This option only matters for daemons that do not yet have certificates
and it is enabled by default, with a value of 120 (seconds).  This causes
+puppet agent+ to connect to the server every 2 minutes and ask it to sign a
certificate request.  This is useful for the initial setup of a puppet
client.  You can turn off waiting for certificates by specifying a time
of 0.</p></dd>
</dl>


<h2 id="EXAMPLE">EXAMPLE</h2>

<pre><code>  $ puppet device --server puppet.domain.com
</code></pre>

<h2 id="AUTHOR">AUTHOR</h2>

<p>Brice Figureau</p>

<h2 id="COPYRIGHT">COPYRIGHT</h2>

<p>Copyright (c) 2011 Puppet Labs, LLC
Licensed under the Apache 2.0 License</p>

</div>
