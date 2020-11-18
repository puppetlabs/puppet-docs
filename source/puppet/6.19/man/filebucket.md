---
layout: default
built_from_commit: 383816102aa1e875b85649986158e30bc4c2f184
title: 'Man Page: puppet filebucket'
canonical: "/puppet/latest/man/filebucket.html"
---

<div class='mp'>
<h2 id="NAME">NAME</h2>
<p class="man-name">
  <code>puppet-filebucket</code> - <span class="man-whatis">Store and retrieve files in a filebucket</span>
</p>

<h2 id="SYNOPSIS">SYNOPSIS</h2>

<p>A stand-alone Puppet filebucket client.</p>

<h2 id="USAGE">USAGE</h2>

<p>puppet filebucket <var>mode</var> [-h|--help] [-V|--version] [-d|--debug]
  [-v|--verbose] [-l|--local] [-r|--remote] [-s|--server <var>server</var>]
  [-f|--fromdate <var>date</var>] [-t|--todate <var>date</var>] [-b|--bucket <var>directory</var>]
  <var>file</var> <var>file</var> ...</p>

<p>Puppet filebucket can operate in three modes, with only one mode per call:</p>

<p>backup:
  Send one or more files to the specified file bucket. Each sent file is
  printed with its resulting md5 sum.</p>

<p>get:
  Return the text associated with an md5 sum. The text is printed to
  stdout, and only one file can be retrieved at a time.</p>

<p>restore:
  Given a file path and an md5 sum, store the content associated with
  the sum into the specified file path. You can specify an entirely new
  path to this argument; you are not restricted to restoring the content
  to its original location.</p>

<p>diff:
  Print a diff in unified format between two checksums in the filebucket
  or between a checksum and its matching file.</p>

<p>list:
  List all files in the current local filebucket. Listing remote
  filebuckets is not allowed.</p>

<h2 id="DESCRIPTION">DESCRIPTION</h2>

<p>This is a stand-alone filebucket client for sending files to a local or
central filebucket.</p>

<p>Note that 'filebucket' defaults to using a network-based filebucket
available on the server named 'puppet'. To use this, you'll have to be
running as a user with valid Puppet certificates. Alternatively, you can
use your local file bucket by specifying '--local', or by specifying
'--bucket' with a local path.</p>

<blockquote><p><strong>Note</strong>: Enabling and using the backup option, and by extension the
  filebucket resource, requires appropriate planning and management to ensure
  that sufficient disk space is available for the file backups. Generally, you
  can implement this using one of the following two options:
  - Use a <code>find</code> command and <code>crontab</code> entry to retain only the last X days
  of file backups. For example:</p></blockquote>

<pre><code class="``shell">  find /opt/puppetlabs/server/data/puppetserver/bucket -type f -mtime +45 -atime +45 -print0 | xargs -0 rm
</code></pre>

<ul>
<li>Restrict the directory to a maximum size after which the oldest items are removed.</li>
</ul>


<h2 id="OPTIONS">OPTIONS</h2>

<p>Note that any setting that's valid in the configuration
file is also a valid long argument. For example, 'ssldir' is a valid
setting, so you can specify '--ssldir <var>directory</var>' as an
argument.</p>

<p>See the configuration file documentation at
https://puppet.com/docs/puppet/latest/configuration.html for the
full list of acceptable parameters. A commented list of all
configuration options can also be generated by running puppet with
'--genconfig'.</p>

<dl>
<dt>--bucket</dt><dd><p>Specify a local filebucket path. This overrides the default path
set in '$clientbucketdir'.</p></dd>
<dt class="flush">--debug</dt><dd><p>Enable full debugging.</p></dd>
<dt>--fromdate</dt><dd><p>(list only) Select bucket files from 'fromdate'.</p></dd>
<dt class="flush">--help</dt><dd><p>Print this help message.</p></dd>
<dt class="flush">--local</dt><dd><p>Use the local filebucket. This uses the default configuration
information and the bucket located at the '$clientbucketdir'
setting by default. If '--bucket' is set, puppet uses that
path instead.</p></dd>
<dt>--remote</dt><dd><p>Use a remote filebucket. This uses the default configuration
information and the bucket located at the '$bucketdir' setting
by default.</p></dd>
<dt>--server_list</dt><dd><p>A list of comma separated servers; only the first entry is used for file storage.
This setting takes precidence over <code>server</code>.</p></dd>
<dt>--server</dt><dd><p>The server to use for file storage. This setting is only used if <code>server_list</code>
is not set.</p></dd>
<dt>--todate</dt><dd><p>(list only) Select bucket files until 'todate'.</p></dd>
<dt>--verbose</dt><dd><p>Print extra information.</p></dd>
<dt>--version</dt><dd><p>Print version information.</p></dd>
</dl>


<h2 id="EXAMPLES">EXAMPLES</h2>

<pre><code>## Backup a file to the filebucket, then restore it to a temporary directory
$ puppet filebucket backup /etc/passwd
/etc/passwd: 429b225650b912a2ee067b0a4cf1e949
$ puppet filebucket restore /tmp/passwd 429b225650b912a2ee067b0a4cf1e949

## Diff between two files in the filebucket
$ puppet filebucket -l diff d43a6ecaa892a1962398ac9170ea9bf2 7ae322f5791217e031dc60188f4521ef
1a2
&gt; again

## Diff between the file in the filebucket and a local file
$ puppet filebucket -l diff d43a6ecaa892a1962398ac9170ea9bf2 /tmp/testFile
1a2
&gt; again

## Backup a file to the filebucket and observe that it keeps each backup separate
$ puppet filebucket -l list
d43a6ecaa892a1962398ac9170ea9bf2 2015-05-11 09:27:56 /tmp/TestFile

$ echo again &gt;&gt; /tmp/TestFile

$ puppet filebucket -l backup /tmp/TestFile
/tmp/TestFile: 7ae322f5791217e031dc60188f4521ef

$ puppet filebucket -l list
d43a6ecaa892a1962398ac9170ea9bf2 2015-05-11 09:27:56 /tmp/TestFile
7ae322f5791217e031dc60188f4521ef 2015-05-11 09:52:15 /tmp/TestFile

## List files in a filebucket within date ranges
$ puppet filebucket -l -f 2015-01-01 -t 2015-01-11 list
&lt;Empty Output>

$ puppet filebucket -l -f 2015-05-10 list
d43a6ecaa892a1962398ac9170ea9bf2 2015-05-11 09:27:56 /tmp/TestFile
7ae322f5791217e031dc60188f4521ef 2015-05-11 09:52:15 /tmp/TestFile

$ puppet filebucket -l -f "2015-05-11 09:30:00" list
7ae322f5791217e031dc60188f4521ef 2015-05-11 09:52:15 /tmp/TestFile

$ puppet filebucket -l -t "2015-05-11 09:30:00" list
d43a6ecaa892a1962398ac9170ea9bf2 2015-05-11 09:27:56 /tmp/TestFile
## Manage files in a specific local filebucket
$ puppet filebucket -b /tmp/TestBucket backup /tmp/TestFile2
/tmp/TestFile2: d41d8cd98f00b204e9800998ecf8427e
$ puppet filebucket -b /tmp/TestBucket list
d41d8cd98f00b204e9800998ecf8427e 2015-05-11 09:33:22 /tmp/TestFile2

## From a Puppet master, list files in the master bucketdir
$ puppet filebucket -b $(puppet config print bucketdir --section master) list
d43a6ecaa892a1962398ac9170ea9bf2 2015-05-11 09:27:56 /tmp/TestFile
7ae322f5791217e031dc60188f4521ef 2015-05-11 09:52:15 /tmp/TestFile
</code></pre>

<h2 id="AUTHOR">AUTHOR</h2>

<p>Luke Kanies</p>

<h2 id="COPYRIGHT">COPYRIGHT</h2>

<p>Copyright (c) 2011 Puppet Inc., LLC Licensed under the Apache 2.0 License</p>

</div>