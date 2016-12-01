---
layout: default
built_from_commit: c4a6a76fd219bffd689476413985ed13f40ef1dd
title: 'Resource Type: file'
canonical: /puppet/latest/reference/types/file.html
---

> **NOTE:** This page was generated from the Puppet source code on 2016-01-27 14:22:05 +0000

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
  <a href="#file-attribute-path">path</a>                    =&gt; <em># <strong>(namevar)</strong> The path to the file to manage.  Must be fully...</em>
  <a href="#file-attribute-ensure">ensure</a>                  =&gt; <em># Whether the file should exist, and if so what...</em>
  <a href="#file-attribute-backup">backup</a>                  =&gt; <em># Whether (and how) file content should be backed...</em>
  <a href="#file-attribute-checksum">checksum</a>                =&gt; <em># The checksum type to use when determining...</em>
  <a href="#file-attribute-content">content</a>                 =&gt; <em># The desired contents of a file, as a string...</em>
  <a href="#file-attribute-ctime">ctime</a>                   =&gt; <em># A read-only state to check the file ctime. On...</em>
  <a href="#file-attribute-force">force</a>                   =&gt; <em># Perform the file operation even if it will...</em>
  <a href="#file-attribute-group">group</a>                   =&gt; <em># Which group should own the file.  Argument can...</em>
  <a href="#file-attribute-ignore">ignore</a>                  =&gt; <em># A parameter which omits action on files matching </em>
  <a href="#file-attribute-links">links</a>                   =&gt; <em># How to handle links during file actions.  During </em>
  <a href="#file-attribute-mode">mode</a>                    =&gt; <em># The desired permissions mode for the file, in...</em>
  <a href="#file-attribute-mtime">mtime</a>                   =&gt; <em># A read-only state to check the file mtime. On...</em>
  <a href="#file-attribute-owner">owner</a>                   =&gt; <em># The user to whom the file should belong....</em>
  <a href="#file-attribute-provider">provider</a>                =&gt; <em># The specific backend to use for this `file...</em>
  <a href="#file-attribute-purge">purge</a>                   =&gt; <em># Whether unmanaged files should be purged. This...</em>
  <a href="#file-attribute-recurse">recurse</a>                 =&gt; <em># Whether to recursively manage the _contents_ of...</em>
  <a href="#file-attribute-recurselimit">recurselimit</a>            =&gt; <em># How far Puppet should descend into...</em>
  <a href="#file-attribute-replace">replace</a>                 =&gt; <em># Whether to replace a file or symlink that...</em>
  <a href="#file-attribute-selinux_ignore_defaults">selinux_ignore_defaults</a> =&gt; <em># If this is set then Puppet will not ask SELinux...</em>
  <a href="#file-attribute-selrange">selrange</a>                =&gt; <em># What the SELinux range component of the context...</em>
  <a href="#file-attribute-selrole">selrole</a>                 =&gt; <em># What the SELinux role component of the context...</em>
  <a href="#file-attribute-seltype">seltype</a>                 =&gt; <em># What the SELinux type component of the context...</em>
  <a href="#file-attribute-seluser">seluser</a>                 =&gt; <em># What the SELinux user component of the context...</em>
  <a href="#file-attribute-show_diff">show_diff</a>               =&gt; <em># Whether to display differences when the file...</em>
  <a href="#file-attribute-source">source</a>                  =&gt; <em># A source file, which will be copied into place...</em>
  <a href="#file-attribute-source_permissions">source_permissions</a>      =&gt; <em># Whether (and how) Puppet should copy owner...</em>
  <a href="#file-attribute-sourceselect">sourceselect</a>            =&gt; <em># Whether to copy all valid sources, or just the...</em>
  <a href="#file-attribute-target">target</a>                  =&gt; <em># The target for creating a link.  Currently...</em>
  <a href="#file-attribute-type">type</a>                    =&gt; <em># A read-only state to check the file...</em>
  <a href="#file-attribute-validate_cmd">validate_cmd</a>            =&gt; <em># A command for validating the file's syntax...</em>
  <a href="#file-attribute-validate_replacement">validate_replacement</a>    =&gt; <em># The replacement string in a `validate_cmd` that...</em>
  # ...plus any applicable <a href="./metaparameter.html">metaparameters</a>.
}</code></pre>

<h4 id="file-attribute-path">path</h4>

_(**Namevar:** If omitted, this attribute's value defaults to the resource's title.)_

The path to the file to manage.  Must be fully qualified.

On Windows, the path should include the drive letter and should use `/` as
the separator character (rather than `\\`).

([↑ Back to file attributes](#file-attributes))

<h4 id="file-attribute-ensure">ensure</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Whether the file should exist, and if so what kind of file it should be.
Possible values are `present`, `absent`, `file`, `directory`, and `link`.

* `present` will accept any form of file existence, and will create a
  normal file if the file is missing. (The file will have no content
  unless the `content` or `source` attribute is used.)
* `absent` will make sure the file doesn't exist, deleting it
  if necessary.
* `file` will make sure it's a normal file, and enables use of the
  `content` or `source` attribute.
* `directory` will make sure it's a directory, and enables use of the
  `source`, `recurse`, `recurselimit`, `ignore`, and `purge` attributes.
* `link` will make sure the file is a symlink, and **requires** that you
  also set the `target` attribute. Symlinks are supported on all Posix
  systems and on Windows Vista / 2008 and higher. On Windows, managing
  symlinks requires puppet agent's user account to have the "Create
  Symbolic Links" privilege; this can be configured in the "User Rights
  Assignment" section in the Windows policy editor. By default, puppet
  agent runs as the Administrator account, which does have this privilege.

Puppet avoids destroying directories unless the `force` attribute is set
to `true`. This means that if a file is currently a directory, setting
`ensure` to anything but `directory` or `present` will cause Puppet to
skip managing the resource and log either a notice or an error.

There is one other non-standard value for `ensure`. If you specify the
path to another file as the ensure value, it is equivalent to specifying
`link` and using that path as the `target`:

    # Equivalent resources:

    file { "/etc/inetd.conf":
      ensure => "/etc/inet/inetd.conf",
    }

    file { "/etc/inetd.conf":
      ensure => link,
      target => "/etc/inet/inetd.conf",
    }

However, we recommend using `link` and `target` explicitly, since this
behavior can be harder to read.

Valid values are `absent` (also called `false`), `file`, `present`, `directory`, `link`. Values can match `/./`.

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

([↑ Back to file attributes](#file-attributes))

<h4 id="file-attribute-checksum">checksum</h4>

The checksum type to use when determining whether to replace a file's contents.

The default checksum type is md5.

Valid values are `md5`, `md5lite`, `sha256`, `sha256lite`, `mtime`, `ctime`, `none`.

([↑ Back to file attributes](#file-attributes))

<h4 id="file-attribute-content">content</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The desired contents of a file, as a string. This attribute is mutually
exclusive with `source` and `target`.

Newlines and tabs can be specified in double-quoted strings using
standard escaped syntax --- \n for a newline, and \t for a tab.

With very small files, you can construct content strings directly in
the manifest...

    define resolve(nameserver1, nameserver2, domain, search) {
        $str = "search $search
            domain $domain
            nameserver $nameserver1
            nameserver $nameserver2
            "

        file { "/etc/resolv.conf":
          content => "$str",
        }
    }

...but for larger files, this attribute is more useful when combined with the
[template](http://docs.puppetlabs.com/references/latest/function.html#template)
or [file](http://docs.puppetlabs.com/references/latest/function.html#file)
function.

([↑ Back to file attributes](#file-attributes))

<h4 id="file-attribute-ctime">ctime</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

A read-only state to check the file ctime. On most modern \*nix-like
systems, this is the time of the most recent change to the owner, group,
permissions, or content of the file.

([↑ Back to file attributes](#file-attributes))

<h4 id="file-attribute-force">force</h4>

Perform the file operation even if it will destroy one or more directories.
You must use `force` in order to:

* `purge` subdirectories
* Replace directories with files or links
* Remove a directory when `ensure => absent`

Valid values are `true`, `false`, `yes`, `no`.

([↑ Back to file attributes](#file-attributes))

<h4 id="file-attribute-group">group</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Which group should own the file.  Argument can be either a group
name or a group ID.

On Windows, a user (such as "Administrator") can be set as a file's group
and a group (such as "Administrators") can be set as a file's owner;
however, a file's owner and group shouldn't be the same. (If the owner
is also the group, files with modes like `0640` will cause log churn, as
they will always appear out of sync.)

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
`follow` will copy the target file instead of the link, `manage`
will copy the link itself, and `ignore` will just pass it by.
When not copying, `manage` and `ignore` behave equivalently
(because you cannot really ignore links entirely during local
recursion), and `follow` will manage the file to which the link points.

Valid values are `follow`, `manage`.

([↑ Back to file attributes](#file-attributes))

<h4 id="file-attribute-mode">mode</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The desired permissions mode for the file, in symbolic or numeric
notation. This value **must** be specified as a string; do not use
un-quoted numbers to represent file modes.

The `file` type uses traditional Unix permission schemes and translates
them to equivalent permissions for systems which represent permissions
differently, including Windows. For detailed ACL controls on Windows,
you can leave `mode` unmanaged and use
[the puppetlabs/acl module.](https://forge.puppetlabs.com/puppetlabs/acl)

Numeric modes should use the standard octal notation of
`<SETUID/SETGID/STICKY><OWNER><GROUP><OTHER>` (e.g. '0644').

* Each of the "owner," "group," and "other" digits should be a sum of the
  permissions for that class of users, where read = 4, write = 2, and
  execute/search = 1.
* The setuid/setgid/sticky digit is also a sum, where setuid = 4, setgid = 2,
  and sticky = 1.
* The setuid/setgid/sticky digit is optional. If it is absent, Puppet will
  clear any existing setuid/setgid/sticky permissions. (So to make your intent
  clear, you should use at least four digits for numeric modes.)
* When specifying numeric permissions for directories, Puppet sets the search
  permission wherever the read permission is set.

Symbolic modes should be represented as a string of comma-separated
permission clauses, in the form `<WHO><OP><PERM>`:

* "Who" should be u (user), g (group), o (other), and/or a (all)
* "Op" should be = (set exact permissions), + (add select permissions),
  or - (remove select permissions)
* "Perm" should be one or more of:
    * r (read)
    * w (write)
    * x (execute/search)
    * t (sticky)
    * s (setuid/setgid)
    * X (execute/search if directory or if any one user can execute)
    * u (user's current permissions)
    * g (group's current permissions)
    * o (other's current permissions)

Thus, mode `0664` could be represented symbolically as either `a=r,ug+w`
or `ug=rw,o=r`.  However, symbolic modes are more expressive than numeric
modes: a mode only affects the specified bits, so `mode => 'ug+w'` will
set the user and group write bits, without affecting any other bits.

See the manual page for GNU or BSD `chmod` for more details
on numeric and symbolic modes.

On Windows, permissions are translated as follows:

* Owner and group names are mapped to Windows SIDs
* The "other" class of users maps to the "Everyone" SID
* The read/write/execute permissions map to the `FILE_GENERIC_READ`,
  `FILE_GENERIC_WRITE`, and `FILE_GENERIC_EXECUTE` access rights; a
  file's owner always has the `FULL_CONTROL` right
* "Other" users can't have any permissions a file's group lacks,
  and its group can't have any permissions its owner lacks; that is, 0644
  is an acceptable mode, but 0464 is not.

([↑ Back to file attributes](#file-attributes))

<h4 id="file-attribute-mtime">mtime</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

A read-only state to check the file mtime. On \*nix-like systems, this
is the time of the most recent change to the content of the file.

([↑ Back to file attributes](#file-attributes))

<h4 id="file-attribute-owner">owner</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The user to whom the file should belong.  Argument can be a user name or a
user ID.

On Windows, a group (such as "Administrators") can be set as a file's owner
and a user (such as "Administrator") can be set as a file's group; however,
a file's owner and group shouldn't be the same. (If the owner is also
the group, files with modes like `0640` will cause log churn, as they
will always appear out of sync.)

([↑ Back to file attributes](#file-attributes))

<h4 id="file-attribute-provider">provider</h4>

The specific backend to use for this `file`
resource. You will seldom need to specify this --- Puppet will usually
discover the appropriate provider for your platform.

Available providers are:

* [`posix`](#file-provider-posix)
* [`windows`](#file-provider-windows)

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

Valid values are `true`, `false`, `yes`, `no`.

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

Valid values are `true`, `false`, `remote`.

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

Values can match `/^[0-9]+$/`.

([↑ Back to file attributes](#file-attributes))

<h4 id="file-attribute-replace">replace</h4>

Whether to replace a file or symlink that already exists on the local system but
whose content doesn't match what the `source` or `content` attribute
specifies.  Setting this to false allows file resources to initialize files
without overwriting future changes.  Note that this only affects content;
Puppet will still manage ownership and permissions. Defaults to `true`.

Valid values are `true`, `false`, `yes`, `no`.

([↑ Back to file attributes](#file-attributes))

<h4 id="file-attribute-selinux_ignore_defaults">selinux_ignore_defaults</h4>

If this is set then Puppet will not ask SELinux (via matchpathcon) to
supply defaults for the SELinux attributes (seluser, selrole,
seltype, and selrange). In general, you should leave this set at its
default and only set it to true when you need Puppet to not try to fix
SELinux labels automatically.

Valid values are `true`, `false`.

([↑ Back to file attributes](#file-attributes))

<h4 id="file-attribute-selrange">selrange</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

What the SELinux range component of the context of the file should be.
Any valid SELinux range component is accepted.  For example `s0` or
`SystemHigh`.  If not specified it defaults to the value returned by
matchpathcon for the file, if any exists.  Only valid on systems with
SELinux support enabled and that have support for MCS (Multi-Category
Security).

([↑ Back to file attributes](#file-attributes))

<h4 id="file-attribute-selrole">selrole</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

What the SELinux role component of the context of the file should be.
Any valid SELinux role component is accepted.  For example `role_r`.
If not specified it defaults to the value returned by matchpathcon for
the file, if any exists.  Only valid on systems with SELinux support
enabled.

([↑ Back to file attributes](#file-attributes))

<h4 id="file-attribute-seltype">seltype</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

What the SELinux type component of the context of the file should be.
Any valid SELinux type component is accepted.  For example `tmp_t`.
If not specified it defaults to the value returned by matchpathcon for
the file, if any exists.  Only valid on systems with SELinux support
enabled.

([↑ Back to file attributes](#file-attributes))

<h4 id="file-attribute-seluser">seluser</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

What the SELinux user component of the context of the file should be.
Any valid SELinux user component is accepted.  For example `user_u`.
If not specified it defaults to the value returned by matchpathcon for
the file, if any exists.  Only valid on systems with SELinux support
enabled.

([↑ Back to file attributes](#file-attributes))

<h4 id="file-attribute-show_diff">show_diff</h4>

Whether to display differences when the file changes, defaulting to
true.  This parameter is useful for files that may contain passwords or
other secret data, which might otherwise be included in Puppet reports or
other insecure outputs.  If the global `show_diff` setting
is false, then no diffs will be shown even if this parameter is true.

Valid values are `true`, `false`, `yes`, `no`.

([↑ Back to file attributes](#file-attributes))

<h4 id="file-attribute-source">source</h4>

A source file, which will be copied into place on the local system.
Values can be URIs pointing to remote files, or fully qualified paths to
files available on the local system (including files on NFS shares or
Windows mapped drives). This attribute is mutually exclusive with
`content` and `target`.

The available URI schemes are *puppet* and *file*. *Puppet*
URIs will retrieve files from Puppet's built-in file server, and are
usually formatted as:

`puppet:///modules/name_of_module/filename`

This will fetch a file from a module on the puppet master (or from a
local module when using puppet apply). Given a `modulepath` of
`/etc/puppetlabs/code/modules`, the example above would resolve to
`/etc/puppetlabs/code/modules/name_of_module/files/filename`.

Unlike `content`, the `source` attribute can be used to recursively copy
directories if the `recurse` attribute is set to `true` or `remote`. If
a source directory contains symlinks, use the `links` attribute to
specify whether to recreate links or follow them.

Multiple `source` values can be specified as an array, and Puppet will
use the first source that exists. This can be used to serve different
files to different system types:

    file { "/etc/nfs.conf":
      source => [
        "puppet:///modules/nfs/conf.$host",
        "puppet:///modules/nfs/conf.$operatingsystem",
        "puppet:///modules/nfs/conf"
      ]
    }

Alternately, when serving directories recursively, multiple sources can
be combined by setting the `sourceselect` attribute to `all`.

([↑ Back to file attributes](#file-attributes))

<h4 id="file-attribute-source_permissions">source_permissions</h4>

Whether (and how) Puppet should copy owner, group, and mode permissions from
the `source` to `file` resources when the permissions are not explicitly
specified. (In all cases, explicit permissions will take precedence.)
Valid values are `use`, `use_when_creating`, and `ignore`:

* `ignore` (the default) will never apply the owner, group, or mode from
  the `source` when managing a file. When creating new files without explicit
  permissions, the permissions they receive will depend on platform-specific
  behavior. On POSIX, Puppet will use the umask of the user it is running as.
  On Windows, Puppet will use the default DACL associated with the user it is
  running as.
* `use` will cause Puppet to apply the owner, group,
  and mode from the `source` to any files it is managing.
* `use_when_creating` will only apply the owner, group, and mode from the
  `source` when creating a file; existing files will not have their permissions
  overwritten.

Valid values are `use`, `use_when_creating`, `ignore`.

([↑ Back to file attributes](#file-attributes))

<h4 id="file-attribute-sourceselect">sourceselect</h4>

Whether to copy all valid sources, or just the first one.  This parameter
only affects recursive directory copies; by default, the first valid
source is the only one used, but if this parameter is set to `all`, then
all valid sources will have all of their contents copied to the local
system. If a given file exists in more than one source, the version from
the earliest source in the list will be used.

Valid values are `first`, `all`.

([↑ Back to file attributes](#file-attributes))

<h4 id="file-attribute-target">target</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The target for creating a link.  Currently, symlinks are the
only type supported. This attribute is mutually exclusive with `source`
and `content`.

Symlink targets can be relative, as well as absolute:

    # (Useful on Solaris)
    file { "/etc/inetd.conf":
      ensure => link,
      target => "inet/inetd.conf",
    }

Directories of symlinks can be served recursively by instead using the
`source` attribute, setting `ensure` to `directory`, and setting the
`links` attribute to `manage`.

Valid values are `notlink`. Values can match `/./`.

([↑ Back to file attributes](#file-attributes))

<h4 id="file-attribute-type">type</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

A read-only state to check the file type.

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

([↑ Back to file attributes](#file-attributes))


<h3 id="file-providers">Providers</h3>

<h4 id="file-provider-posix">posix</h4>

Uses POSIX functionality to manage file ownership and permissions.

* Supported features: `manages_symlinks`.

<h4 id="file-provider-windows">windows</h4>

Uses Microsoft Windows functionality to manage file ownership and permissions.

* Supported features: `manages_symlinks`.

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
      <td><em>X</em> </td>
    </tr>
  </tbody>
</table>



> **NOTE:** This page was generated from the Puppet source code on 2016-01-27 14:22:05 +0000