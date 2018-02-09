---
layout: default
built_from_commit: 46e5188e3d20d712525caf5566fa2214e524637d
title: 'Man Page: puppet device'
canonical: "/puppet/latest/man/device.html"
---

<div class='mp'>
<h2 id="NAME">NAME</h2>
<p class="man-name">
  <code>puppet-device</code> - <span class="man-whatis">Manage remote network devices</span>
</p>

<h2 id="SYNOPSIS">SYNOPSIS</h2>

<p>Retrieves catalogs from the Puppet master and applies them to remote devices.</p>

<p>This subcommand can be run manually; or periodically using cron,
a scheduled task, or a similar tool.</p>

<h2 id="USAGE">USAGE</h2>

<p>  puppet device [-d|--debug] [--detailed-exitcodes]
                [-h|--help] [-l|--logdest syslog|<var>file</var>|console]
                [-v|--verbose] [-w|--waitforcert <var>seconds</var>]
                [--user=<var>user</var>] [-V|--version]</p>

<h2 id="DESCRIPTION">DESCRIPTION</h2>

<p>Devices require a proxy Puppet agent to request certificates, collect facts,
retrieve and apply catalogs, and store reports.</p>

<h2 id="USAGE-NOTES">USAGE NOTES</h2>

<p>Devices managed by the puppet-device subcommand on a Puppet agent are
configured in device.conf, which is located at $confdir/device.conf by default,
and is configurable with the $deviceconfig setting.</p>

<p>The device.conf file is an INI-like file, with one section per device:</p>

<p>[<var>DEVICE_CERTNAME</var>]
type <var>TYPE</var>
url <var>URL</var>
debug</p>

<p>The section name specifies the certname of the device.</p>

<p>The values for the type and url properties are specific to each type of device.</p>

<p>The optional debug property specifies transport-level debugging,
and is limited to telnet and ssh transports.</p>

<p>See https://docs.puppet.com/puppet/latest/config_file_device.html for details.</p>

<h2 id="OPTIONS">OPTIONS</h2>

<p>Note that any setting that's valid in the configuration file is also a valid
long argument. For example, 'server' is a valid configuration parameter, so
you can specify '--server <var>servername</var>' as an argument.</p>

<dl>
<dt class="flush">--debug</dt><dd><p>Enable full debugging.</p></dd>
<dt>--detailed-exitcodes</dt><dd><p>Provide transaction information via exit codes. If this is enabled, an exit
code of '1' means at least one device had a compile failure, an exit code of
'2' means at least one device had resource changes, and an exit code of '4'
means at least one device had resource failures. Exit codes of '3', '5', '6',
or '7' means that a bitwise combination of the preceding exit codes happened.</p></dd>
<dt class="flush">--help</dt><dd><p>Print this help message</p></dd>
<dt>--logdest</dt><dd><p>Where to send log messages. Choose between 'syslog' (the POSIX syslog
service), 'console', or the path to a log file. If debugging or verbosity is
enabled, this defaults to 'console'. Otherwise, it defaults to 'syslog'.</p>

<p>A path ending with '.json' will receive structured output in JSON format. The
log file will not have an ending ']' automatically written to it due to the
appending nature of logging. It must be appended manually to make the content
valid JSON.</p></dd>
<dt class="flush">--user</dt><dd><p>The user to run as.</p></dd>
<dt>--verbose</dt><dd><p>Turn on verbose reporting.</p></dd>
<dt>--waitforcert</dt><dd><p>This option only matters for daemons that do not yet have certificates
and it is enabled by default, with a value of 120 (seconds).  This causes
+puppet agent+ to connect to the server every 2 minutes and ask it to sign a
certificate request.  This is useful for the initial setup of a puppet
client.  You can turn off waiting for certificates by specifying a time of 0.</p></dd>
</dl>


<h2 id="EXAMPLE">EXAMPLE</h2>

<pre><code>  $ puppet device --server puppet.domain.com
</code></pre>

<h2 id="AUTHOR">AUTHOR</h2>

<p>Brice Figureau</p>

<h2 id="COPYRIGHT">COPYRIGHT</h2>

<p>Copyright (c) 2011 Puppet Inc., LLC
Licensed under the Apache 2.0 License</p>

</div>
