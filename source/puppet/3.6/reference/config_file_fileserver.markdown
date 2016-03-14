---
layout: default
title: "Config Files: fileserver.conf"
canonical: "/puppet/latest/reference/config_file_fileserver.html"
---

[file]: ./type.html#file
[module_files]: ./modules_fundamentals.html#files
[fileserverconfig]: ./configuration.html#fileserverconfig
[auth_conf]: ./config_file_auth.html

The `fileserver.conf` file configures custom static mount points for Puppet's file server. If custom mount points are present, [`file` resources][file] can access them with their `source` attributes.

## When to Use `fileserver.conf`

By default, `fileserver.conf` isn't necessary --- Puppet automatically serves files from the `files` directory of modules, and most users find this sufficient. ([More info on serving files from modules is available here][module_files].)

However, some use cases make custom mount points more attractive: for example, large files that shouldn't be checked into version control along with your Puppet modules, or sensitive credentials that likewise shouldn't go into version control.

## Location

The `fileserver.conf` file is located at `$confdir/fileserver.conf` by default. Its location is configurable with the [`fileserverconfig` setting][fileserverconfig].

The location of the `confdir` varies; it depends on the OS, Puppet distribution, and user account. [See the confdir documentation for details.][confdir]

[confdir]: ./dirs_confdir.html

## Example

    # Files in the /path/to/files directory will be served
    # at puppet:///extra_files/.
    [extra_files]
        path /etc/puppetlabs/puppet/extra_files
        allow *

This `fileserver.conf` file would create a new mount point named `extra_files`. The `allow *` directive would leave access control to the main auth.conf file.

## Format

A `fileserver.conf` file consists of a collection of mount-point stanzas, and looks like a hybrid of `puppet.conf` and `auth.conf`. Each stanza should consist of:

* A `[mount_point_name]`, surrounded by square brackets. This will become the name used in `puppet:///` URLs for files in this mount point.
* A `path` directive, pointing to an absolute path on disk. This is where the mount point's files are stored.
* Any number of `allow` or `deny` directives. In this version of Puppet, we recommend using only a `allow *` directive in `fileserver.conf`.

### Security Directives

The `allow` and `deny` directives in a mount point stanza can be used to control which nodes may access the files in it. However, this feature predates the `auth.conf` file used in this version of Puppet, and **we recommend against using it.** If possible, you should keep all authorization rules centralized in `auth.conf`. To do this, put a single `allow *` rule in each custom mount point.

By default, `auth.conf` will allow all agent nodes with valid certificates to access files, and will block access for any client that doesn't have a certificate. For most use cases, this is good enough. However, if you are serving sensitive credentials via custom mount points, you may wish to add more restrictive rules to `auth.conf`. To do this, add a rule to `auth.conf` for each mount point. These rules should begin with:

    path ~ ^/file_(metadata|content)s?/NAME_OF_MOUNT_POINT/

You can then [configure `auth.conf` restrictions as per normal.][auth_conf]

For more information on how the old `allow` and `deny` directives in `fileserver.conf` work, see the [file serving documentation](/guides/file_serving.html).

