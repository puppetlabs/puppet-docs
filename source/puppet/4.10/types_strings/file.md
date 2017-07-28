---
layout: default
built_from_commit: f0a5a11ef180b0d40dbdccd5faa4dc5bf2b20221
title: 'Resource Type: file'
canonical: "/puppet/latest/types/file.html"
---

> **NOTE:** This page was generated from the Puppet source code on 2017-07-26 14:45:15 -0500

file
-----

* [Attributes](#file-attributes)
* [Providers](#file-providers)
* [Provider Features](#file-provider-features)

<h3 id="file-description">Description</h3>

Manages files, including their content, ownership, and permissions.

The `file` type can manage normal files, directories, and symlinks; the
type should be specified in the `ensure` attribute.

File contents can be managed directly with the `content` attribute, or
downloaded from a remote source using the `source` attribute; the latter
can also be used to recursively serve directories (when the `recurse`
attribute is set to `true` or `local`). On Windows, note that file
contents are managed in binary mode; Puppet never automatically translates
line endings.

**Autorequires:** If Puppet is managing the user or group that owns a
file, the file resource will autorequire them. If Puppet is managing any
parent directories of a file, the file resource will autorequire them.

<h3 id="file-attributes">Attributes</h3>

<pre><code>file { 'resource title':
  <a href="#file-attribute-path">path</a>                 =&gt; <em># <strong>(namevar)</strong> The path to the file to manage.  Must be fully...</em>
  <a href="#file-attribute-backup">backup</a>               =&gt; <em># Whether (and how) file content should be backed...</em>
  <a href="#file-attribute-force">force</a>                =&gt; <em># Perform the file operation even if it will...</em>
  <a href="#file-attribute-ignore">ignore</a>               =&gt; <em># A parameter which omits action on files matching </em>
  <a href="#file-attribute-links">links</a>                =&gt; <em># How to handle links during file actions.  During </em>
  <a href="#file-attribute-purge">purge</a>                =&gt; <em># Whether unmanaged files should be purged. This...</em>
  <a href="#file-attribute-recurse">recurse</a>              =&gt; <em># Whether to recursively manage the _contents_ of...</em>
  <a href="#file-attribute-recurselimit">recurselimit</a>         =&gt; <em># How far Puppet should descend into...</em>
  <a href="#file-attribute-replace">replace</a>              =&gt; <em># Whether to replace a file or symlink that...</em>
  <a href="#file-attribute-show_diff">show_diff</a>            =&gt; <em># Whether to display differences when the file...</em>
  <a href="#file-attribute-sourceselect">sourceselect</a>         =&gt; <em># Whether to copy all valid sources, or just the...</em>
  <a href="#file-attribute-validate_cmd">validate_cmd</a>         =&gt; <em># A command for validating the file's syntax...</em>
  <a href="#file-attribute-validate_replacement">validate_replacement</a> =&gt; <em># The replacement string in a `validate_cmd` that...</em>
  # ...plus any applicable <a href="{{puppet}}/metaparameter.html">metaparameters</a>.
}</code></pre>

<h4 id="file-attribute-path">path</h4>

_(**Namevar:** If omitted, this attribute's value defaults to the resource's title.)_

The path to the file to manage.  Must be fully qualified.

On Windows, the path should include the drive letter and should use `/` as
the separator character (rather than `\\`).

([↑ Back to file attributes](#file-attributes))

<h4 id="file-attribute-backup">backup</h4>

Whether (and how) file content should be backed up before being replaced.
This attribute works best as a resource default in the site manifest
(`File { backup => main }`), so it can affect all file resources.

* If set to `false`, file content won't be backed up.
* If set to a string beginning with `.` (e.g., `.puppet-bak`), Puppet will
  use copy the file in the same directory with that value as the extension
  of the backup. (A value of `true` is a synonym for `.puppet-bak`.)
* If set to any other string, Puppet will try to back up to a filebucket
  with that title. See the `filebucket` resource type for more details.
  (This is the preferred method for backup, since it can be centralized
  and queried.)

Default value: `puppet`, which backs up to a filebucket of the same name.
(Puppet automatically creates a **local** filebucket named `puppet` if one
doesn't already exist.)

Backing up to a local filebucket isn't particularly useful. If you want
to make organized use of backups, you will generally want to use the
puppet master server's filebucket service. This requires declaring a
filebucket resource and a resource default for the `backup` attribute
in site.pp:

    # /etc/puppetlabs/puppet/manifests/site.pp
    filebucket { 'main':
      path   => false,                # This is required for remote filebuckets.
      server => 'puppet.example.com', # Optional; defaults to the configured puppet master.
    }

    File { backup => main, }

If you are using multiple puppet master servers, you will want to
centralize the contents of the filebucket. Either configure your load
balancer to direct all filebucket traffic to a single master, or use
something like an out-of-band rsync task to synchronize the content on all
masters.

Default: `puppet`

([↑ Back to file attributes](#file-attributes))

<h4 id="file-attribute-force">force</h4>

Perform the file operation even if it will destroy one or more directories.
You must use `force` in order to:

* `purge` subdirectories
* Replace directories with files or links
* Remove a directory when `ensure => absent`

Default: `false`

Allowed values:

* `true`
* `false`
* `yes`
* `no`

([↑ Back to file attributes](#file-attributes))

<h4 id="file-attribute-ignore">ignore</h4>

A parameter which omits action on files matching
specified patterns during recursion.  Uses Ruby's builtin globbing
engine, so shell metacharacters are fully supported, e.g. `[a-z]*`.
Matches that would descend into the directory structure are ignored,
e.g., `*/*`.

([↑ Back to file attributes](#file-attributes))

<h4 id="file-attribute-links">links</h4>

How to handle links during file actions.  During file copying,
`follow` will copy the target file instead of the link and `manage`
will copy the link itself. When not copying, `manage` will manage
the link, and `follow` will manage the file to which the link points.

Default: `manage`

Allowed values:

* `follow`
* `manage`

([↑ Back to file attributes](#file-attributes))

<h4 id="file-attribute-purge">purge</h4>

Whether unmanaged files should be purged. This option only makes
sense when `ensure => directory` and `recurse => true`.

* When recursively duplicating an entire directory with the `source`
  attribute, `purge => true` will automatically purge any files
  that are not in the source directory.
* When managing files in a directory as individual resources,
  setting `purge => true` will purge any files that aren't being
  specifically managed.

If you have a filebucket configured, the purged files will be uploaded,
but if you do not, this will destroy data.

Unless `force => true` is set, purging will **not** delete directories,
although it will delete the files they contain.

If `recurselimit` is set and you aren't using `force => true`, purging
will obey the recursion limit; files in any subdirectories deeper than the
limit will be treated as unmanaged and left alone.

Default: `false`

Allowed values:

* `true`
* `false`
* `yes`
* `no`

([↑ Back to file attributes](#file-attributes))

<h4 id="file-attribute-recurse">recurse</h4>

Whether to recursively manage the _contents_ of a directory. This attribute
is only used when `ensure => directory` is set. The allowed values are:

* `false` --- The default behavior. The contents of the directory will not be
  automatically managed.
* `remote` --- If the `source` attribute is set, Puppet will automatically
  manage the contents of the source directory (or directories), ensuring
  that equivalent files and directories exist on the target system and
  that their contents match.

  Using `remote` will disable the `purge` attribute, but results in faster
  catalog application than `recurse => true`.

  The `source` attribute is mandatory when `recurse => remote`.
* `true` --- If the `source` attribute is set, this behaves similarly to
  `recurse => remote`, automatically managing files from the source directory.

  This also enables the `purge` attribute, which can delete unmanaged
  files from a directory. See the description of `purge` for more details.

  The `source` attribute is not mandatory when using `recurse => true`, so you
  can enable purging in directories where all files are managed individually.

By default, setting recurse to `remote` or `true` will manage _all_
subdirectories. You can use the `recurselimit` attribute to limit the
recursion depth.

Allowed values:

* `true`
* `false`
* `remote`

([↑ Back to file attributes](#file-attributes))

<h4 id="file-attribute-recurselimit">recurselimit</h4>

How far Puppet should descend into subdirectories, when using
`ensure => directory` and either `recurse => true` or `recurse => remote`.
The recursion limit affects which files will be copied from the `source`
directory, as well as which files can be purged when `purge => true`.

Setting `recurselimit => 0` is the same as setting `recurse => false` ---
Puppet will manage the directory, but all of its contents will be treated
as unmanaged.

Setting `recurselimit => 1` will manage files and directories that are
directly inside the directory, but will not manage the contents of any
subdirectories.

Setting `recurselimit => 2` will manage the direct contents of the
directory, as well as the contents of the _first_ level of subdirectories.

And so on --- 3 will manage the contents of the second level of
subdirectories, etc.

Allowed values:

* `/^[0-9]+$/`

([↑ Back to file attributes](#file-attributes))

<h4 id="file-attribute-replace">replace</h4>

Whether to replace a file or symlink that already exists on the local system but
whose content doesn't match what the `source` or `content` attribute
specifies.  Setting this to false allows file resources to initialize files
without overwriting future changes.  Note that this only affects content;
Puppet will still manage ownership and permissions. Defaults to `true`.

Default: `true`

Allowed values:

* `true`
* `false`
* `yes`
* `no`

([↑ Back to file attributes](#file-attributes))

<h4 id="file-attribute-show_diff">show_diff</h4>

Whether to display differences when the file changes, defaulting to
true.  This parameter is useful for files that may contain passwords or
other secret data, which might otherwise be included in Puppet reports or
other insecure outputs.  If the global `show_diff` setting
is false, then no diffs will be shown even if this parameter is true.

Default: `true`

Allowed values:

* `true`
* `false`
* `yes`
* `no`

([↑ Back to file attributes](#file-attributes))

<h4 id="file-attribute-sourceselect">sourceselect</h4>

Whether to copy all valid sources, or just the first one.  This parameter
only affects recursive directory copies; by default, the first valid
source is the only one used, but if this parameter is set to `all`, then
all valid sources will have all of their contents copied to the local
system. If a given file exists in more than one source, the version from
the earliest source in the list will be used.

Default: `first`

Allowed values:

* `first`
* `all`

([↑ Back to file attributes](#file-attributes))

<h4 id="file-attribute-validate_cmd">validate_cmd</h4>

A command for validating the file's syntax before replacing it. If
Puppet would need to rewrite a file due to new `source` or `content`, it
will check the new content's validity first. If validation fails, the file
resource will fail.

This command must have a fully qualified path, and should contain a
percent (`%`) token where it would expect an input file. It must exit `0`
if the syntax is correct, and non-zero otherwise. The command will be
run on the target system while applying the catalog, not on the puppet master.

Example:

    file { '/etc/apache2/apache2.conf':
      content      => 'example',
      validate_cmd => '/usr/sbin/apache2 -t -f %',
    }

This would replace apache2.conf only if the test returned true.

Note that if a validation command requires a `%` as part of its text,
you can specify a different placeholder token with the
`validate_replacement` attribute.

([↑ Back to file attributes](#file-attributes))

<h4 id="file-attribute-validate_replacement">validate_replacement</h4>

The replacement string in a `validate_cmd` that will be replaced
with an input file name. Defaults to: `%`

Default: `%`

([↑ Back to file attributes](#file-attributes))


<h3 id="file-providers">Providers</h3>

<h4 id="file-provider-posix">posix</h4>

Uses POSIX functionality to manage file ownership and permissions.

* Confined to: `feature == posix`

<h4 id="file-provider-windows">windows</h4>

Uses Microsoft Windows functionality to manage file ownership and permissions.

* Confined to: `operatingsystem == windows`

<h3 id="file-provider-features">Provider Features</h3>

Available features:

* `manages_symlinks` --- The provider can manage symbolic links.

Provider support:

<table>
  <thead>
    <tr>
      <th>Provider</th>
      <th>manages symlinks</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>posix</td>
      <td><em>X</em> </td>
    </tr>
    <tr>
      <td>windows</td>
      <td> </td>
    </tr>
  </tbody>
</table>



> **NOTE:** This page was generated from the Puppet source code on 2017-07-26 14:45:15 -0500