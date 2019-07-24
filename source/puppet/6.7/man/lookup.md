---
layout: default
built_from_commit: 922313f3b1cc7f14c799bddb4e354e45b29be180
title: 'Man Page: puppet lookup'
canonical: "/puppet/latest/man/lookup.html"
---

<div class='mp'>
<h2 id="NAME">NAME</h2>
<p class="man-name">
  <code>lookup</code> - <span class="man-whatis">Interactive Hiera lookup</span>
</p>

<h2 id="SYNOPSIS">SYNOPSIS</h2>

<p>Does Hiera lookups from the command line.</p>

<p>Since this command needs access to your Hiera data, make sure to run it on a
node that has a copy of that data. This usually means logging into a Puppet
Server node and running 'puppet lookup' with sudo.</p>

<p>The most common version of this command is:</p>

<p>'puppet lookup <var>KEY</var> --node <var>NAME</var> --environment <var>ENV</var> --explain'</p>

<h2 id="USAGE">USAGE</h2>

<p>puppet lookup [--help] [--type <var>TYPESTRING</var>] [--merge first|unique|hash|deep]
  [--knock-out-prefix <var>PREFIX-STRING</var>] [--sort-merged-arrays]
  [--merge-hash-arrays] [--explain] [--environment <var>ENV</var>]
  [--default <var>VALUE</var>] [--node <var>NODE-NAME</var>] [--facts <var>FILE</var>]
  [--compile]
  [--render-as s|json|yaml|binary|msgpack] <var>keys</var></p>

<h2 id="DESCRIPTION">DESCRIPTION</h2>

<p>The lookup command is a CLI for Puppet's 'lookup()' function. It searches your
Hiera data and returns a value for the requested lookup key, so you can test and
explore your data. It is a modern replacement for the 'hiera' command.</p>

<p>Hiera usually relies on a node's facts to locate the relevant data sources. By
default, 'puppet lookup' uses facts from the node you run the command on, but
you can get data for any other node with the '--node <var>NAME</var>' option. If
possible, the lookup command will use the requested node's real stored facts
from PuppetDB; if PuppetDB isn't configured or you want to provide arbitrary
fact values, you can pass alternate facts as a JSON or YAML file with '--facts
<var>FILE</var>'.</p>

<p>If you're debugging your Hiera data and want to see where values are coming
from, use the '--explain' option.</p>

<p>If '--explain' isn't specified, lookup exits with 0 if a value was found and 1
otherwise. With '--explain', lookup always exits with 0 unless there is a major
error.</p>

<p>You can provide multiple lookup keys to this command, but it only returns a
value for the first found key, omitting the rest.</p>

<p>For more details about how Hiera works, see the Hiera documentation:
https://puppet.com/docs/puppet/latest/hiera_intro.html</p>

<h2 id="OPTIONS">OPTIONS</h2>

<ul>
<li><p>--help:
Print this help message.</p></li>
<li><p>--explain
Explain the details of how the lookup was performed and where the final value
came from (or the reason no value was found).</p></li>
<li><p>--node <var>NODE-NAME</var>
Specify which node to look up data for; defaults to the node where the command
is run. Since Hiera's purpose is to provide different values for different
nodes (usually based on their facts), you'll usually want to use some specific
node's facts to explore your data. If the node where you're running this
command is configured to talk to PuppetDB, the command will use the requested
node's most recent facts. Otherwise, you can override facts with the '--facts'
option.</p></li>
<li><p>--facts <var>FILE</var>
Specify a .json or .yaml file of key => value mappings to override the facts
for this lookup. Any facts not specified in this file maintain their
original value.</p></li>
<li><p>--environment <var>ENV</var>
Like with most Puppet commands, you can specify an environment on the command
line. This is important for lookup because different environments can have
different Hiera data.</p></li>
<li><p>--merge first|unique|hash|deep:
Specify the merge behavior, overriding any merge behavior from the data's
lookup_options. 'first' returns the first value found. 'unique' appends
everything to a merged, deduplicated array. 'hash' performs a simple hash
merge by overwriting keys of lower lookup priority. 'deep' performs a deep
merge on values of Array and Hash type. There are additional options that can
be used with 'deep'.</p></li>
<li><p>--knock-out-prefix <var>PREFIX-STRING</var>
Can be used with the 'deep' merge strategy. Specifies a prefix to indicate a
value should be removed from the final result.</p></li>
<li><p>--sort-merged-arrays
Can be used with the 'deep' merge strategy. When this flag is used, all
merged arrays are sorted.</p></li>
<li><p>--merge-hash-arrays
Can be used with the 'deep' merge strategy. When this flag is used, hashes
WITHIN arrays are deep-merged with their counterparts by position.</p></li>
<li><p>--explain-options
Explain whether a lookup_options hash affects this lookup, and how that hash
was assembled. (lookup_options is how Hiera configures merge behavior in data.)</p></li>
<li><p>--default <var>VALUE</var>
A value to return if Hiera can't find a value in data. For emulating calls to
the 'lookup()' function that include a default.</p></li>
<li><p>--type <var>TYPESTRING</var>:
Assert that the value has the specified type. For emulating calls to the
'lookup()' function that include a data type.</p></li>
<li><p>--compile
Perform a full catalog compilation prior to the lookup. If your hierarchy and
data only use the $facts, $trusted, and $server_facts variables, you don't
need this option; however, if your Hiera configuration uses arbitrary
variables set by a Puppet manifest, you might need this option to get accurate
data. No catalog compilation takes place unless this flag is given.</p></li>
<li><p>--render-as s|json|yaml|binary|msgpack
Specify the output format of the results; "s" means plain text. The default
when producing a value is yaml and the default when producing an explanation
is s.</p></li>
</ul>


<h2 id="EXAMPLE">EXAMPLE</h2>

<p>  To look up 'key_name' using the Puppet Server node's facts:
  $ puppet lookup key_name</p>

<p>  To look up 'key_name' with agent.local's facts:
  $ puppet lookup --node agent.local key_name</p>

<p>  To get the first value found for 'key_name_one' and 'key_name_two'
  with agent.local's facts while merging values and knocking out
  the prefix 'foo' while merging:
  $ puppet lookup --node agent.local --merge deep --knock-out-prefix foo key_name_one key_name_two</p>

<p>  To lookup 'key_name' with agent.local's facts, and return a default value of
  'bar' if nothing was found:
  $ puppet lookup --node agent.local --default bar key_name</p>

<p>  To see an explanation of how the value for 'key_name' would be found, using
  agent.local's facts:
  $ puppet lookup --node agent.local --explain key_name</p>

<h2 id="COPYRIGHT">COPYRIGHT</h2>

<p>Copyright (c) 2015 Puppet Inc., LLC Licensed under the Apache 2.0 License</p>

</div>
