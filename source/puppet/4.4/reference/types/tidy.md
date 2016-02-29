---
layout: default
built_from_commit: 3b5d15cb1c5ed830cb460f2687fde710e5383e69
title: 'Resource Type: tidy'
canonical: /puppet/latest/reference/types/tidy.html
---

> **NOTE:** This page was generated from the Puppet source code on 2016-01-27 14:15:19 +0000

tidy
-----

* [Attributes](#tidy-attributes)

<h3 id="tidy-description">Description</h3>

Remove unwanted files based on specific criteria.  Multiple
criteria are OR'd together, so a file that is too large but is not
old enough will still get tidied.

If you don't specify either `age` or `size`, then all files will
be removed.

This resource type works by generating a file resource for every file
that should be deleted and then letting that resource perform the
actual deletion.

<h3 id="tidy-attributes">Attributes</h3>

<pre><code>tidy { 'resource title':
  <a href="#tidy-attribute-path">path</a>    =&gt; <em># <strong>(namevar)</strong> The path to the file or directory to manage....</em>
  <a href="#tidy-attribute-age">age</a>     =&gt; <em># Tidy files whose age is equal to or greater than </em>
  <a href="#tidy-attribute-backup">backup</a>  =&gt; <em># Whether tidied files should be backed up.  Any...</em>
  <a href="#tidy-attribute-matches">matches</a> =&gt; <em># One or more (shell type) file glob patterns...</em>
  <a href="#tidy-attribute-recurse">recurse</a> =&gt; <em># If target is a directory, recursively descend...</em>
  <a href="#tidy-attribute-rmdirs">rmdirs</a>  =&gt; <em># Tidy directories in addition to files; that is...</em>
  <a href="#tidy-attribute-size">size</a>    =&gt; <em># Tidy files whose size is equal to or greater...</em>
  <a href="#tidy-attribute-type">type</a>    =&gt; <em># Set the mechanism for determining age. Default...</em>
  # ...plus any applicable <a href="./metaparameter.html">metaparameters</a>.
}</code></pre>

<h4 id="tidy-attribute-path">path</h4>

_(**Namevar:** If omitted, this attribute's value defaults to the resource's title.)_

The path to the file or directory to manage.  Must be fully
qualified.

([↑ Back to tidy attributes](#tidy-attributes))

<h4 id="tidy-attribute-age">age</h4>

Tidy files whose age is equal to or greater than
the specified time.  You can choose seconds, minutes,
hours, days, or weeks by specifying the first letter of any
of those words (e.g., '1w').

Specifying 0 will remove all files.

([↑ Back to tidy attributes](#tidy-attributes))

<h4 id="tidy-attribute-backup">backup</h4>

Whether tidied files should be backed up.  Any values are passed
directly to the file resources used for actual file deletion, so consult
the `file` type's backup documentation to determine valid values.

([↑ Back to tidy attributes](#tidy-attributes))

<h4 id="tidy-attribute-matches">matches</h4>

One or more (shell type) file glob patterns, which restrict
the list of files to be tidied to those whose basenames match
at least one of the patterns specified. Multiple patterns can
be specified using an array.

Example:

    tidy { "/tmp":
      age     => "1w",
      recurse => 1,
      matches => [ "[0-9]pub*.tmp", "*.temp", "tmpfile?" ]
    }

This removes files from `/tmp` if they are one week old or older,
are not in a subdirectory and match one of the shell globs given.

Note that the patterns are matched against the basename of each
file -- that is, your glob patterns should not have any '/'
characters in them, since you are only specifying against the last
bit of the file.

Finally, note that you must now specify a non-zero/non-false value
for recurse if matches is used, as matches only apply to files found
by recursion (there's no reason to use static patterns match against
a statically determined path).  Requiering explicit recursion clears
up a common source of confusion.

([↑ Back to tidy attributes](#tidy-attributes))

<h4 id="tidy-attribute-recurse">recurse</h4>

If target is a directory, recursively descend
into the directory looking for files to tidy.

Valid values are `true`, `false`, `inf`. Values can match `/^[0-9]+$/`.

([↑ Back to tidy attributes](#tidy-attributes))

<h4 id="tidy-attribute-rmdirs">rmdirs</h4>

Tidy directories in addition to files; that is, remove
directories whose age is older than the specified criteria.
This will only remove empty directories, so all contained
files must also be tidied before a directory gets removed.

Valid values are `true`, `false`, `yes`, `no`.

([↑ Back to tidy attributes](#tidy-attributes))

<h4 id="tidy-attribute-size">size</h4>

Tidy files whose size is equal to or greater than
the specified size.  Unqualified values are in kilobytes, but
*b*, *k*, *m*, *g*, and *t* can be appended to specify *bytes*,
*kilobytes*, *megabytes*, *gigabytes*, and *terabytes*, respectively.
Only the first character is significant, so the full word can also
be used.

([↑ Back to tidy attributes](#tidy-attributes))

<h4 id="tidy-attribute-type">type</h4>

Set the mechanism for determining age. Default: atime.

Valid values are `atime`, `mtime`, `ctime`.

([↑ Back to tidy attributes](#tidy-attributes))





> **NOTE:** This page was generated from the Puppet source code on 2016-01-27 14:15:19 +0000