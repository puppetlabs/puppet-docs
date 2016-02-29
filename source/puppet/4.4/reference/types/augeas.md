---
layout: default
built_from_commit: 3b5d15cb1c5ed830cb460f2687fde710e5383e69
title: 'Resource Type: augeas'
canonical: /puppet/latest/reference/types/augeas.html
---

> **NOTE:** This page was generated from the Puppet source code on 2016-01-27 14:15:19 +0000

augeas
-----

* [Attributes](#augeas-attributes)
* [Providers](#augeas-providers)
* [Provider Features](#augeas-provider-features)

<h3 id="augeas-description">Description</h3>

Apply a change or an array of changes to the filesystem
using the augeas tool.

Requires:

- [Augeas](http://www.augeas.net)
- The ruby-augeas bindings

Sample usage with a string:

    augeas{"test1" :
      context => "/files/etc/sysconfig/firstboot",
      changes => "set RUN_FIRSTBOOT YES",
      onlyif  => "match other_value size > 0",
    }

Sample usage with an array and custom lenses:

    augeas{"jboss_conf":
      context   => "/files",
      changes   => [
          "set etc/jbossas/jbossas.conf/JBOSS_IP $ipaddress",
          "set etc/jbossas/jbossas.conf/JAVA_HOME /usr",
        ],
      load_path => "$/usr/share/jbossas/lenses",
    }

<h3 id="augeas-attributes">Attributes</h3>

<pre><code>augeas { 'resource title':
  <a href="#augeas-attribute-name">name</a>       =&gt; <em># <strong>(namevar)</strong> The name of this task. Used for...</em>
  <a href="#augeas-attribute-changes">changes</a>    =&gt; <em># The changes which should be applied to the...</em>
  <a href="#augeas-attribute-context">context</a>    =&gt; <em># Optional context path. This value is prepended...</em>
  <a href="#augeas-attribute-force">force</a>      =&gt; <em># Optional command to force the augeas type to...</em>
  <a href="#augeas-attribute-incl">incl</a>       =&gt; <em># Load only a specific file, e.g. `/etc/hosts`...</em>
  <a href="#augeas-attribute-lens">lens</a>       =&gt; <em># Use a specific lens, e.g. `Hosts.lns`. When this </em>
  <a href="#augeas-attribute-load_path">load_path</a>  =&gt; <em># Optional colon-separated list or array of...</em>
  <a href="#augeas-attribute-onlyif">onlyif</a>     =&gt; <em># Optional augeas command and comparisons to...</em>
  <a href="#augeas-attribute-provider">provider</a>   =&gt; <em># The specific backend to use for this `augeas...</em>
  <a href="#augeas-attribute-returns">returns</a>    =&gt; <em># The expected return code from the augeas...</em>
  <a href="#augeas-attribute-root">root</a>       =&gt; <em># A file system path; all files loaded by Augeas...</em>
  <a href="#augeas-attribute-show_diff">show_diff</a>  =&gt; <em># Whether to display differences when the file...</em>
  <a href="#augeas-attribute-type_check">type_check</a> =&gt; <em># Whether augeas should perform typechecking...</em>
  # ...plus any applicable <a href="./metaparameter.html">metaparameters</a>.
}</code></pre>

<h4 id="augeas-attribute-name">name</h4>

_(**Namevar:** If omitted, this attribute's value defaults to the resource's title.)_

The name of this task. Used for uniqueness.

([↑ Back to augeas attributes](#augeas-attributes))

<h4 id="augeas-attribute-changes">changes</h4>

The changes which should be applied to the filesystem. This
can be a command or an array of commands. The following commands are supported:

* `set <PATH> <VALUE>` --- Sets the value `VALUE` at loction `PATH`
* `setm <PATH> <SUB> <VALUE>` --- Sets multiple nodes (matching `SUB` relative to `PATH`) to `VALUE`
* `rm <PATH>` --- Removes the node at location `PATH`
* `remove <PATH>` --- Synonym for `rm`
* `clear <PATH>` --- Sets the node at `PATH` to `NULL`, creating it if needed
* `clearm <PATH> <SUB>` --- Sets multiple nodes (matching `SUB` relative to `PATH`) to `NULL`
* `touch <PATH>` --- Creates `PATH` with the value `NULL` if it does not exist
* `ins <LABEL> (before|after) <PATH>` --- Inserts an empty node `LABEL` either before or after `PATH`.
* `insert <LABEL> <WHERE> <PATH>` --- Synonym for `ins`
* `mv <PATH> <OTHER PATH>` --- Moves a node at `PATH` to the new location `OTHER PATH`
* `move <PATH> <OTHER PATH>` --- Synonym for `mv`
* `rename <PATH> <LABEL>` --- Rename a node at `PATH` to a new `LABEL`
* `defvar <NAME> <PATH>` --- Sets Augeas variable `$NAME` to `PATH`
* `defnode <NAME> <PATH> <VALUE>` --- Sets Augeas variable `$NAME` to `PATH`, creating it with `VALUE` if needed

If the `context` parameter is set, that value is prepended to any relative `PATH`s.

([↑ Back to augeas attributes](#augeas-attributes))

<h4 id="augeas-attribute-context">context</h4>

Optional context path. This value is prepended to the paths of all
changes if the path is relative. If the `incl` parameter is set,
defaults to `/files + incl`; otherwise, defaults to the empty string.

([↑ Back to augeas attributes](#augeas-attributes))

<h4 id="augeas-attribute-force">force</h4>

Optional command to force the augeas type to execute even if it thinks changes
will not be made. This does not overide the `onlyif` parameter.

([↑ Back to augeas attributes](#augeas-attributes))

<h4 id="augeas-attribute-incl">incl</h4>

Load only a specific file, e.g. `/etc/hosts`. This can greatly speed
up the execution the resource. When this parameter is set, you must also
set the `lens` parameter to indicate which lens to use.

([↑ Back to augeas attributes](#augeas-attributes))

<h4 id="augeas-attribute-lens">lens</h4>

Use a specific lens, e.g. `Hosts.lns`. When this parameter is set, you
must also set the `incl` parameter to indicate which file to load.
The Augeas documentation includes [a list of available lenses](http://augeas.net/stock_lenses.html).

([↑ Back to augeas attributes](#augeas-attributes))

<h4 id="augeas-attribute-load_path">load_path</h4>

Optional colon-separated list or array of directories; these directories are searched for schema definitions. The agent's `$libdir/augeas/lenses` path will always be added to support pluginsync.

([↑ Back to augeas attributes](#augeas-attributes))

<h4 id="augeas-attribute-onlyif">onlyif</h4>

Optional augeas command and comparisons to control the execution of this type.

Note: `values` is not an actual augeas API command. It calls `match` to retrieve an array of paths
       in <MATCH_PATH> and then `get` to retrieve the values from each of the returned paths.

Supported onlyif syntax:

* `get <AUGEAS_PATH> <COMPARATOR> <STRING>`
* `values <MATCH_PATH> include <STRING>`
* `values <MATCH_PATH> not_include <STRING>`
* `values <MATCH_PATH> == <AN_ARRAY>`
* `values <MATCH_PATH> != <AN_ARRAY>`
* `match <MATCH_PATH> size <COMPARATOR> <INT>`
* `match <MATCH_PATH> include <STRING>`
* `match <MATCH_PATH> not_include <STRING>`
* `match <MATCH_PATH> == <AN_ARRAY>`
* `match <MATCH_PATH> != <AN_ARRAY>`

where:

* `AUGEAS_PATH` is a valid path scoped by the context
* `MATCH_PATH` is a valid match syntax scoped by the context
* `COMPARATOR` is one of `>, >=, !=, ==, <=,` or `<`
* `STRING` is a string
* `INT` is a number
* `AN_ARRAY` is in the form `['a string', 'another']`

([↑ Back to augeas attributes](#augeas-attributes))

<h4 id="augeas-attribute-provider">provider</h4>

The specific backend to use for this `augeas`
resource. You will seldom need to specify this --- Puppet will usually
discover the appropriate provider for your platform.

Available providers are:

* [`augeas`](#augeas-provider-augeas)

([↑ Back to augeas attributes](#augeas-attributes))

<h4 id="augeas-attribute-returns">returns</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The expected return code from the augeas command. Should not be set.

([↑ Back to augeas attributes](#augeas-attributes))

<h4 id="augeas-attribute-root">root</h4>

A file system path; all files loaded by Augeas are loaded underneath `root`.

([↑ Back to augeas attributes](#augeas-attributes))

<h4 id="augeas-attribute-show_diff">show_diff</h4>

Whether to display differences when the file changes, defaulting to
true.  This parameter is useful for files that may contain passwords or
other secret data, which might otherwise be included in Puppet reports or
other insecure outputs.  If the global `show_diff` setting
is false, then no diffs will be shown even if this parameter is true.

Valid values are `true`, `false`, `yes`, `no`.

([↑ Back to augeas attributes](#augeas-attributes))

<h4 id="augeas-attribute-type_check">type_check</h4>

Whether augeas should perform typechecking. Defaults to false.

Valid values are `true`, `false`.

([↑ Back to augeas attributes](#augeas-attributes))


<h3 id="augeas-providers">Providers</h3>

<h4 id="augeas-provider-augeas">augeas</h4>

* Supported features: `execute_changes`, `need_to_run?`, `parse_commands`.

<h3 id="augeas-provider-features">Provider Features</h3>

Available features:

* `execute_changes` --- Actually make the changes
* `need_to_run?` --- If the command should run
* `parse_commands` --- Parse the command string

Provider support:

<table>
  <thead>
    <tr>
      <th>Provider</th>
      <th>execute changes</th>
      <th>need to run?</th>
      <th>parse commands</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>augeas</td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
    </tr>
  </tbody>
</table>



> **NOTE:** This page was generated from the Puppet source code on 2016-01-27 14:15:19 +0000