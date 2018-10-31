---
layout: default
built_from_commit: b38f8a72231c43ffcd4fe348667c7764692af9a1
title: 'Man Page: puppet lookup'
canonical: /puppet/latest/reference/man/lookup.html
---

<div class='mp'>
<h2 id="NAME">NAME</h2>
<p class="man-name">
  <code>puppet-lookup</code> - <span class="man-whatis">Data in modules lookup function</span>
</p>

<h2 id="SYNOPSIS">SYNOPSIS</h2>

<p>The lookup command is used for debugging and testing a given data
configuration. For a given data key, lookup will produce either a
value or an explanation of how that value was obtained on the standard
output stream with the specified rendering format. Lookup is designed
to be run on a puppet master or a node in a masterless setup.</p>

<h2 id="USAGE">USAGE</h2>

<p>puppet lookup [--help] [--type <var>TYPESTRING</var>] [--merge unique|hash|deep]
  [--knock-out-prefix <var>PREFIX-STRING</var>] [--sort-merged-arrays]
  [--unpack-arrays <var>STRING-VALUE</var>] [--merge-hash-arrays] [--explain]
  [--default <var>VALUE</var>] [--node <var>NODE-NAME</var>] [--facts <var>FILE</var>]
  [--render-as s|json|yaml|binary|msgpack] <var>keys</var></p>

<h2 id="DESCRIPTION">DESCRIPTION</h2>

<p>The lookup command is a CLI interface for the puppet lookup function.
When given one or more keys, the lookup command will return the first
value found when run from the puppet master or a masterless node.</p>

<p>When an explanation has not been requested and
lookup is simply looking up a value, the application will exit with 0
if a value was found and 1 otherwise. When an explanation is requested,
lookup will always exit with 0 unless there is a major error.</p>

<p>The other options are as passed into the lookup function, and the effect
they have on the lookup is described in more detail in the header
for the lookup function:</p>

<p>http://links.puppetlabs.com/lookup-docs</p>

<h2 id="OPTIONS">OPTIONS</h2>

<p>These options and their effects are decribed in more detail in
the puppet lookup function linked to above.</p>

<ul>
<li><p>--help:
Print this help message.</p></li>
<li><p>--type <var>TYPESTRING</var>:
Assert that the value has the specified type.</p></li>
<li><p>--merge unique|hash|deep:
Specify the merge strategy. 'hash' performs a simple hash-merge by
overwriting keys of lower lookup priority. 'unique' appends everything
to an array containing no nested arrays and where all duplicates have been
removed. 'deep' Performs a deep merge on values of Array and Hash type. There
are additional option flags that can be used with 'deep'.</p></li>
<li><p>--knock_out_prefix <var>PREFIX-STRING</var>
Can be used with the 'deep' merge strategy. Specify string value to signify
prefix which deletes elements from existing element.</p></li>
<li><p>--sort_merged_arrays
Can be used with the 'deep' merge strategy. When this flag is used all
merged arrays will be sorted.</p></li>
<li><p>--unpack_arrays <var>STRING-VALUE</var>
Can be used with the 'deep' merge strategy. Specify a string value used
as a deliminator to join all array values and then split them again.</p></li>
<li><p>--merge_hash_arrays
Can be used with the 'deep' merge strategy. When this flag is used arrays
and hashes will be merged.</p></li>
<li><p>--explain
Print an explanation for the details of how the lookup performed rather
than the value returned for the key. The explaination will describe how
the result was obtained or why lookup failed to obtain the result.</p></li>
<li><p>--default <var>VALUE</var>
A value produced if no value was found in the lookup.</p></li>
<li><p>--node <var>NODE-NAME</var>
Specify node which defines the scope in which the lookup will be performed.
If a node is not given, lookup will default to the machine from which the
lookup is being run (which should be the master).</p></li>
<li><p>--facts <var>FILE</var>
Specify a .json, or .yaml file holding key => value mappings that will
override the facts for the current node. Any facts not specified by the
user will maintain their original value.</p></li>
<li><p>--render-as s|json|yaml|binary|msgpack
Determines how the results will be rendered to the standard output where
s means plain text. The default when lookup is producing a value is yaml
and the default when producing an explanation is s.</p></li>
</ul>


<h2 id="EXAMPLE">EXAMPLE</h2>

<p>  If you wanted to lookup 'key_name' within the scope of the master, you would
  call lookup like this:
  $ puppet lookup key_name</p>

<p>  If you wanted to lookup 'key_name' within the scope of the agent.local node,
  you would call lookup like this:
  $ puppet lookup --node agent.local key_name</p>

<p>  If you wanted to get the first value found for 'key_name_one' and 'key_name_two'
  within the scope of the agent.local node while merging values and knocking out
  the prefix 'foo' while merging, you would call lookup like this:
  $ puppet lookup --node agent.local --merge deep --knock_out_prefix foo key_name_one key_name_two</p>

<p>  If you wanted to lookup 'key_name' within the scope of the agent.local node,
  and return a default value of 'bar' if nothing was found, you would call
  lookup like this:
  $ puppet lookup --node agent.local --default bar key_name</p>

<p>  If you wanted to see an explanation of how the value for 'key_name' would be
  obtained in the context of the agent.local node, you would call lookup like this:
  $ puppet lookup --node agent.local --explain key_name</p>

<h2 id="COPYRIGHT">COPYRIGHT</h2>

<p>Copyright (c) 2015 Puppet Labs, LLC Licensed under the Apache 2.0 License</p>

</div>
