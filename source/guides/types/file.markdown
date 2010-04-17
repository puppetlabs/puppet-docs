file
====

Manages local files.

* Sets ownership and permissions.
* Supports creation of both files and directories.
* Retrieves entire files from remote servers. 

* * *

Background
----------

As Puppet matures, it expected that the `file`
resource will be used less and less to manage content, and instead
native resources will be used to do so.


NOTE: If you find that you are often copying files in from a central
location, rather than using native resources, please contact
Puppet Labs and we can hopefully work with you to develop a
native resource to support what you are doing.

{GENERIC}

Examples
--------

Here is a simple example:

    file { "/var/www/my/file":
        source => "/path/in/nfs/or/something",
        mode   => 666
    }
{:puppet}

There are also a number of additional, more complete examples below.

Parameters
----------

### `backup`

Whether files should be backed up before being replaced. The
preferred method of backing files up is via a `filebucket`, which
stores files by their MD5 sums and allows easy retrieval without
littering directories with backups. You can specify a local
filebucket or a network-accessible server-based filebucket by
setting `backup => bucket-name`. Alternatively, if you specify any
value that begins with a `.` (e.g., `.puppet-bak`), then Puppet
will use copy the file in the same directory with that value as the
extension of the backup. Setting `backup => false` disables all
backups of the file in question.

Puppet automatically creates a local filebucket named `puppet` and
defaults to backing up there. To use a server-based filebucket, you
must specify one in your configuration:

    filebucket { main:
        server => puppet
    }
{:puppet}

The `puppetmasterd` daemon creates a filebucket by default, so you
can usually back up to your main server with this configuration.
Once you've described the bucket in your configuration, you can use
it in any `file::`

    file { "/my/file":
        source => "/path/in/nfs/or/something",
        backup => main
    }
{:puppet}

This will back the file up to the central server.

At this point, the benefits of using a filebucket are that you do
not have backup files lying around on each of your machines, a
given version of a file is only backed up once, and you can restore
any given file manually, no matter how old. Eventually,
transactional support will be able to automatically restore
filebucketed files.

### `checksum`

How to check whether a file has changed. This state is used
internally for file copying, but it can also be used to monitor
files somewhat like Tripwire without managing the file contents in
any way. You can specify that a file's checksum should be monitored
and then subscribe to the file from another object and receive
events to signify checksum changes, for instance.

There are a number of checksum types available including MD5
hashing (and an md5lite variation that only hashes the first 500
characters of the file.

The default checksum parameter, if checksums are enabled, is md5.
Valid values are `md5`, `md5lite`, `timestamp`, `mtime`, `time`.
Values can match `/^\{md5|md5lite|timestamp|mtime|time\}/`.

### `content`

Specify the contents of a file as a string. Newlines, tabs, and
spaces can be specified using the escaped syntax (e.g., n for a
newline). The primary purpose of this parameter is to provide a
kind of limited templating:

    define resolve(nameserver1, nameserver2, domain, search) {
        $str = "search $search
                domain $domain
                nameserver $nameserver1
                nameserver $nameserver2"
        file { "/etc/resolv.conf":
            content => $str
        }
    }
{:puppet}

This attribute is especially useful when used with templating.

### `ensure`

Whether to create files that don't currently exist. Possible values
are *absent*, *present*, *file*, and *directory*. Specifying
`present` will match any form of file existence, and if the file is
missing will create an empty file. Specifying `absent` will delete
the file (and directory if recurse =\> true).

Anything other than those values will be considered to be a
symlink. For instance, the following text creates a link:

    # Useful on solaris
    file { "/etc/inetd.conf":
        ensure => "/etc/inet/inetd.conf"
    }
{:puppet}

You can make relative links:

    # Useful on solaris
    file { "/etc/inetd.conf":
        ensure => "inet/inetd.conf"
    }
{:puppet}

If you need to make a relative link to a file named the same as one
of the valid values, you must prefix it with `./` or something
similar.

You can also make recursive symlinks, which will create a directory
structure that maps to the target directory, with directories
corresponding to each directory and links corresponding to each
file. Valid values are `absent` (also called `false`), `file`,
`present`, `directory`, `link`. Values can match `/./`.

### `force`

Force the file operation. Currently only used when replacing
directories with links. Valid values are `true`, `false`.

### `group`

Which group should own the file. Argument can be either group name
or group ID.

### `ignore`

A parameter which omits action on files matching specified patterns
during recursion. Uses Ruby's builtin globbing engine, so shell
metacharacters are fully supported, e.g. `[a-z]*`. Matches that
would descend into the directory structure are ignored, e.g.,
`*/*`.

### `links`

How to handle links during file actions. During file copying,
`follow` will copy the target file instead of the link, `manage`
will copy the link itself, and `ignore` will just pass it by. When
not copying, `manage` and `ignore` behave equivalently (because you
cannot really ignore links entirely during local recursion), and
`follow` will manage the file to which the link points. Valid
values are `follow`, `manage`.

### `mode`

Mode the file should be. Currently relatively limited: you must
specify the exact mode the file should be.

### `owner`

To whom the file should belong. Argument can be user name or user
ID.

### `path`

The path to the file to manage. Must be fully qualified.

INFO: This is the `namevar` for this resource type.

### `purge`

Whether unmanaged files should be purged. If you have a filebucket
configured the purged files will be uploaded, but if you do not,
this will destroy data. Only use this option for generated files
unless you really know what you are doing. This option only makes
sense when recursively managing directories.

Note that when using `purge` with `source`, Puppet will purge any
files that are not on the remote system. Valid values are `true`,
`false`.

### `recurse`

Whether and how deeply to do recursive management. Valid values are
`true`, `false`, `inf`, `remote`. Values can match `/^[0-9]+$/`.

### `recurselimit`

How deeply to do recursive management. Values can match
`/^[0-9]+$/`.

### `replace`

Whether or not to replace a file that is sourced but exists. This
is useful for using file sources purely for initialization. Valid
values are `true` (also called `yes`), `false` (also called `no`).

### `selrange`

What the SELinux range component of the context of the file should
be. Any valid SELinux range component is accepted. For example `s0`
or `SystemHigh`. If not specified it defaults to the value returned
by matchpathcon for the file, if any exists. Only valid on systems
with SELinux support enabled and that have support for MCS
(Multi-Category Security).

### `selrole`

What the SELinux role component of the context of the file should
be. Any valid SELinux role component is accepted. For example
`role_r`. If not specified it defaults to the value returned by
matchpathcon for the file, if any exists. Only valid on systems
with SELinux support enabled.

### `seltype`

What the SELinux type component of the context of the file should
be. Any valid SELinux type component is accepted. For example
`tmp_t`. If not specified it defaults to the value returned by
matchpathcon for the file, if any exists. Only valid on systems
with SELinux support enabled.

### `seluser`

What the SELinux user component of the context of the file should
be. Any valid SELinux user component is accepted. For example
`user_u`. If not specified it defaults to the value returned by
matchpathcon for the file, if any exists. Only valid on systems
with SELinux support enabled.

### `source`

Copy a file over the current file. Uses `checksum` to determine
when a file should be copied. Valid values are either fully
qualified paths to files, or URIs. Currently supported URI types
are *puppet* and *file*.

This is one of the primary mechanisms for getting content into
applications that Puppet does not directly support and is very
useful for those configuration files that don't change much across
sytems. For instance:

    class sendmail {
        file { "/etc/mail/sendmail.cf":
            source => "puppet://server/module/sendmail.cf"
        }
    }
{:puppet}

You can also leave out the server name, in which case `puppetd`
will fill in the name of its configuration server and `puppet` will
use the local filesystem. This makes it easy to use the same
configuration in both local and centralized forms.

Currently, only the `puppet` scheme is supported for source URL's.
Puppet will connect to the file server running on `server` to
retrieve the contents of the file. If the `server` part is empty,
the behavior of the command-line interpreter (`puppet`) and the
client demon (`puppetd`) differs slightly: `puppet` will look such
a file up on the module path on the local host, whereas `puppetd`
will connect to the puppet server that it received the manifest
from.

See the fileserver configuration documentation for information on
how to configure and use file services within Puppet.

If you specify multiple file sources for a file, then the first
source that exists will be used. This allows you to specify what
amount to search paths for files:

    file { "/path/to/my/file":
        source => [
            "/nfs/files/file.$host",
            "/nfs/files/file.$operatingsystem",
            "/nfs/files/file"
        ]
    }
{:puppet}

This will use the first found file as the source.

NOTE: You cannot currently copy links using this mechanism; set `links`
to `follow` if any remote sources are links.

### `sourceselect`

Whether to copy all valid sources, or just the first one. This
parameter is only used in recursive copies; by default, the first
valid source is the only one used as a recursive source, but if
this parameter is set to `all`, then all valid sources will have
all of their contents copied to the local host, and for sources
that have the same file, the source earlier in the list will be
used. Valid values are `first`, `all`.

### `target`

The target for creating a link. Currently, symlinks are the only
type supported. Valid values are `notlink`. Values can match
`/./`.

### `type`

A read-only state to check the file type.

