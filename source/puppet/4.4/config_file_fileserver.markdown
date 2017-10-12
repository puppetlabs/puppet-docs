---
layout: default
title: "Config Files: fileserver.conf"
canonical: "/puppet/latest/config_file_fileserver.html"
---

[file]: ./type.html#file
[module_files]: ./modules_fundamentals.html#files
[fileserverconfig]: ./configuration.html#fileserverconfig
[auth_conf]: {{puppetserver}}/config_file_auth.html
[deprecated]: ./deprecated_settings.html#authorization-rules-in-fileserverconf
[custom_mount]: ./file_serving.html
[mount_auth_examples]: ./file_serving.html#controlling-access-to-a-custom-mount-point-in-authconf

The `fileserver.conf` file configures custom static mount points for Puppet's file server. If custom mount points are present, [`file` resources][file] can access them with their `source` attributes.

## When to use `fileserver.conf`

This file is only necessary if you are [creating custom mount points.][custom_mount]

Puppet automatically serves files from the `files` directory of every module, and most users find this sufficient. ([More info on serving files from modules][module_files].) However, custom mount points are useful for things that shouldn't be stored in version control with your modules, like very large files and sensitive credentials.

## Location

The `fileserver.conf` file is located at `$confdir/fileserver.conf` by default. Its location is configurable with the [`fileserverconfig` setting][fileserverconfig].

The location of the `confdir` depends on your OS. [See the confdir documentation for details.][confdir]

[confdir]: ./dirs_confdir.html

## Example

```
# Files in the /path/to/files directory will be served
# at puppet:///extra_files/.
[extra_files]
    path /etc/puppetlabs/puppet/extra_files
    allow *
```

This `fileserver.conf` file would create a new mount point named `extra_files`.

> **Caution:** You should always restrict write access to mounted directories. The file server will follow any symlinks in a file server mount, including links to files that agent nodes should not access (like SSL keys).
>
> When following symlinks, the file server can access any files readable by Puppet Server's user account.

## Format

`fileserver.conf` uses a one-off format that resembles an INI file without the equals (`=`) signs. It is a series of mount-point stanzas, where each stanza consists of:

* A `[mount_point_name]` surrounded by square brackets. This will become the name used in `puppet:///` URLs for files in this mount point.
* A `path <PATH>` directive, where `<PATH>` is an absolute path on disk. This is where the mount point's files are stored.
* An `allow *` directive.

### Deprecated security directives

Before [`auth.conf`][auth_conf] existed, `fileserver.conf` could use `allow` and `deny` directives to control which nodes can access various files. This feature is now deprecated, and will be removed in Puppet 5.0.

Instead, you can use `auth.conf` to control access to mount points. [The page on setting up mount points has details and examples.][mount_auth_examples]

The only security directive that should be present in `fileserver.conf` is an `allow *` directive for every mount point.
