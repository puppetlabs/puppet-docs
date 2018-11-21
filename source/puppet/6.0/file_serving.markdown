---
title: "Adding file server mount points"
---

[module_files]: ./modules_fundamentals.html#files
[fileserver.conf]: ./config_file_fileserver.html
[deprecated]: ./deprecated_settings.html#authorization-rules-in-fileserverconf
[auth.conf]: {{puppetserver}}/config_file_auth.html
[auth_legacy]: ./config_file_auth.html
[disable_legacy]: {{puppetserver}}/config_file_puppetserver.html
[external facts]: {{facter}}/custom_facts.html#external-facts

Puppet Server includes a file server for transferring static file content to agents; this is what's used whenever a `file` resource has a `source => puppet:///...` attribute specified.

Generally, [files are stored in modules][module_files]. But if you need to serve larger files that shouldn't be in source control or shouldn't be distributed with a module, you can make a custom file server mount point and let Puppet serve those files from another directory.

## Summary

To create a new mount point, you must:

-   Choose a directory on disk for the mount point. Make sure Puppet Server can access it, and put files in it as needed.
-   Edit `fileserver.conf` on your Puppet Server node, so Puppet knows which directory to associate with the new mount point.
-   Edit `auth.conf` if you want to restrict which nodes can access this mount point.

Once the mount point is working, you can reference its files at `puppet:///<MOUNT POINT>/<PATH>`.

## Puppet URIs

Puppet URIs are constructed like this:

`puppet://<SERVER>/<MOUNT POINT>/<PATH>`

-   `<SERVER>` is optional, which is why you usually see `puppet:///` URIs with three slashes. There's little reason to specify a server, since the default is almost always what you want. (It's the value of the `server` setting in Puppet agent, and a special mock server with a `modules` mount point in Puppet apply.)
-   `<MOUNT POINT>` is a unique identifier for some collection of files. There are several types:
    -   Custom mount points correspond to an arbitrary directory. The rest of this page is about these.
    -   The special `modules` mount point serves files from the `files` directory of every module. It behaves as if someone had copied the `files` directory from every module into one big directory, renaming each of them with the name of their module. (So the files in `apache/files/...` are available at `puppet:///modules/apache/...`)
    - The `task` mount point works in a similar way to the `modules` mount point but for files that live under the modules `tasks` directory, rather than the `files` directory.  
    -   The special `plugins` mount point serves files from the `lib` directory of every module. It behaves as if someone had copied the _contents_ of every `lib` directory into one big directory, with no additional namespacing. Puppet agent uses this mount point when syncing plugins before a run, but there's no reason to use it in a `file` resource.
    -   The special `pluginfacts` mount point serves files from the `facts.d` directory of every module, to support [external facts][]. It behaves like the `plugins` mount point, but with a different source directory.
    -   The special `locales` mount point serves files from the `locales` directory of every module, to support automatic downloading of module translations to agents. It also behaves like the `plugins` mount point, and also has a different source directory.
-   `<PATH>` is the remainder of the path to the file, starting from the directory (or imaginary directory) that corresponds to the mount point.

## Creating a new mount point in `fileserver.conf`

`fileserver.conf` uses an INI-like syntax. [The `fileserver.conf` page][fileserver.conf] has a complete description, but all you need to know is:

```
[<NAME OF MOUNT POINT>]
    path <PATH TO DIRECTORY>
    allow *

[installer_files]
    path /etc/puppetlabs/puppet/installer_files
    allow *
```

In the example above, a file at `/etc/puppetlabs/puppet/installer_files/oracle.pkg` would be available in manifests as `puppet:///installer_files/oracle.pkg`.

Make sure that the `puppet` user can access that directory and its contents.

Always include the `allow *` line, since the default behavior is to deny all access. If you need to control access to a custom mount point, do so in [`auth.conf`][auth.conf]. [Putting authorization rules in `fileserver.conf` is deprecated.][deprecated]

> **Caution:** You should always restrict write access to mounted directories. The file server will follow any symlinks in a file server mount, including links to files that agent nodes should not access (like SSL keys).
>
> When following symlinks, the file server can access any files readable by Puppet Server's user account.

## Controlling access to a custom mount point in `auth.conf`

By default, any node with a valid certificate can access the files in your new mount point --- if it can fetch a catalog, it can fetch files; if it can't, it can't. This is the same behavior as the special `modules` and `plugins` mount points.

If necessary, you can restrict access to a custom mount point in [`auth.conf`][auth.conf].

### New-style `auth.conf`

If you've [disabled the legacy `auth.conf` file by setting `jruby-puppet.use-legacy-auth-conf: false`][disable_legacy], you'll be adding a rule to [Puppet Server's HOCON-format `auth.conf` file][auth.conf], located at `/etc/puppetlabs/puppetserver/conf.d/auth.conf`.

Your new auth rule must meet the following requirements:

-   It matches requests to all four of these prefixes:
    -   `/puppet/v3/file_metadata/<MOUNT POINT>`
    -   `/puppet/v3/file_metadatas/<MOUNT POINT>`
    -   `/puppet/v3/file_content/<MOUNT POINT>`
    -   `/puppet/v3/file_contents/<MOUNT POINT>`
-   Its `sort-order` must be lower than 500, so that it overrides the default rule for the file server.

For example:

```
{
    # Allow limited access to files in /etc/puppetlabs/puppet/installer_files:
    match-request: {
        path: "^/puppet/v3/file_(content|metadata)s?/installer_files"
        type: regex
    }
    allow: "*.dev.example.com"
    sort-order: 400
    name: "dev.example.com large installer files"
},
```

### Legacy `auth.conf`

If you haven't disabled the legacy `auth.conf` file, you'll be adding a stanza to `/etc/puppetlabs/puppet/auth.conf`.

Your new auth rule must meet the following requirements:

-   It matches requests to all four of these prefixes:
    -   `/puppet/v3/file_metadata/<MOUNT POINT>`
    -   `/puppet/v3/file_metadatas/<MOUNT POINT>`
    -   `/puppet/v3/file_content/<MOUNT POINT>`
    -   `/puppet/v3/file_contents/<MOUNT POINT>`
-   It is located earlier in the `auth.conf` file than the default `/puppet/v3/file` rule.

For example:

```
# Allow limited access to files in /etc/puppetlabs/puppet/installer_files:
path ~ ^/file_(metadata|content)s?/installer_files/
auth yes
allow *.dev.example.com
allow_ip 192.168.100.0/24
```

