---
layout: default
built_from_commit: c0673af42427fbe0b22ff97c8e5fa3244715eeae
title: 'Man Page: puppet device'
canonical: /puppet/latest/reference/man/device.html
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
code of '1' means at least one device had a compile failure, an exit code of
'2' means at least one device had resource changes, and an exit code of '4'
means at least one device had resource failures. Exit codes of '3', '5', '6',
or '7' means that a bitwise combination of the preceeding exit codes happened.</p></dd>
<dt class="flush">--help</dt><dd><p>Print this help message</p></dd>
<dt>--logdest</dt><dd><p>Where to send log messages. Choose between 'syslog' (the POSIX syslog
service), 'console', or the path to a log file. If debugging or verbosity is
enabled, this defaults to 'console'. Otherwise, it defaults to 'syslog'.</p>

<p>A path ending with '.json' will receive structured output in JSON format. The
log file will not have an ending ']' automatically written to it due to the
appending nature of logging. It must be appended manually to make the content
valid JSON.</p></dd>
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
