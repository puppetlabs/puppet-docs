---
layout: default
title: The Puppet File Server
---

The Puppet File Server
======================

This guide covers the use of Puppet's file serving capability.

* * *

The `puppet master` service includes a file server for transferring static files. If a `file` resource declaration contains a `puppet:` URI in its `source` attribute, nodes will retrieve that file from the master's file server:

    # copy a remote file to /etc/sudoers
    file { "/etc/sudoers":
        mode   => 440,
        owner  => root,
        group  => root,
        source => "puppet:///modules/module_name/sudoers"
    }


All puppet file server URIs are structured as follows:

    puppet://{server hostname (optional)}/{mount point}/{remainder of path}

If a server hostname is omitted (i.e. `puppet:///{mount point}/{path}`; note the triple-slash), the URI will resolve to whichever server the evaluating node considers to be its master. As this makes manifest code more portable and reusable, hostnames should be omitted whenever possible.

The remainder of the `puppet:` URI maps to the server's filesystem in one of two ways, depending on whether the files are provided by a module or exposed through a custom mount point.

## Serving Module Files

As the vast majority of file serving should be done through [modules](/puppet/latest/reference/modules_fundamentals.html), the Puppet file server provides a special and semi-magical mount point called `modules`, which is available by default. If a URI's mount point is `modules`, Puppet will:

* Interpret the next segment of the path as the name of a module...[^oldmodulemounts]
* ... locate that module in the server's `modulepath` (as described [here](/puppet/latest/reference/modules_fundamentals.html) under "Module Lookup")...
* ... and resolve the remainder of the path starting in that module's `files/` directory.

That is to say, if a module named `test_module` is installed in the central server's `/etc/puppet/modules` directory, the following puppet: URI...

    puppet:///modules/test_module/testfile.txt

...will resolve to the following absolute path:

    /etc/puppet/modules/test_module/files/testfile.txt

If `test_module` were installed in `/usr/share/puppet/modules`, the same URI would instead resolve to:

    /usr/share/puppet/modules/test_module/files/testfile.txt

Although no additional configuration is required to use the `modules` mount point, some access controls can be specified in the file server configuration by adding a `[modules]` configuration block; see [Security](#security).


[^oldmodulemounts]: Older versions of Puppet generated individual mount points for each installed module; to reduce namespace conflicts, these were changed to subdirectories of the catch-all `modules` mount point in version 0.25.0.

## Serving Files From Custom Mount Points

Puppet can also serve files from arbitrary mount points specified in the server's file server configuration (see below). When serving files from a custom mount point, Puppet does not perform the additional URI abstraction used in the `modules` mount, and will resolve the path following the mount name as a simple directory structure.

## File Server Configuration

The default location for the file server's configuration data is
/etc/puppet/fileserver.conf; this can be changed by passing the
`--fsconfig` flag to `puppet master`.

The format of the fileserver.conf file is almost
exactly like that of [rsync](http://samba.anu.edu.au/rsync/), and roughly resembles an INI file:

    [mount_point]
        path /path/to/files
        allow *.example.com
        deny *.wireless.example.com

The following options can currently be specified for a given mount point:

* The `path` to the mount's location on the disk
* Any number of `allow` directives
* Any number of `deny` directives

`path` is the only required option, but since the
default security configuration is to deny all access, a mount point with no
`allow` directives would not be available to any nodes.

The path can contain any or all of %h, %H, and %d, which are
dynamically replaced by the client's hostname, its fully qualified
domain name and its domain name, respectively. All are taken from
the client's SSL certificate (so be careful if you've got
hostname/certname mismatches). This is useful in creating modules
where files for each client are kept completely separately, e.g.
for private ssh host keys. For example, with the configuration

    [private]
        path /data/private/%h
        allow *

the request for file /private/file.txt from client
client1.example.com will look for a file
/data/private/client1/file.txt, while the same request from
client2.example.com will try to retrieve the file
/data/private/client2/file.txt on the fileserver.

Currently paths cannot contain trailing slashes or an error will
result. Also take care that in puppet.conf you are not specifying
directory locations that have trailing slashes.

## Security

Securing the Puppet file server consists of allowing and denying access (at varying levels of specificity) per mount point. Groups of nodes can be identified for permission or denial in three ways: by IP address, by name, or by a single global wildcard (`*`). Custom mount points default to denying all access.

In addition to custom mount points, there are two special mount points which can be managed with `fileserver.conf`: `modules` and `plugins`. Neither of these mount points should have a `path` option specified. The behavior of the `modules` mount point is described above under [Serving Files From Custom Mount Points](#serving-files-from-custom-mount-points). The `plugins` mount is not a true mount point, but is rather a hook to allow `fileserver.conf` to specify which nodes are permitted to sync plugins from the Puppet Master. Both of these mount points exist by default, and both default to allowing all access; if **any** `allow` or `deny` directives are set for one of these special mounts, its security settings will behave like those of a normal mount (i.e., it will default to denying all access). Note that these are the only mount points for which `deny *` is not redundant.

If nodes are not connecting to the Puppet file server directly,
then the file server will see all the connections as coming from
the proxy server's IP address rather than that of the Puppet Agent node. In this case, it is best to restrict access based on hostname. Additionally, the
machine(s) acting as reverse proxy (usually 127.0.0.0/8) will need to be
allowed to access the applicable mount points.

### Priority

More specific `deny` and `allow` statements take precedence over less specific statements; that is, an `allow` statement for `node.example.com` would let it connect despite a `deny` statement for `*.example.com`. At a given level of specificity, `deny` statements take precedence over `allow` statements.

Unpredictable behavior can result from mixing IP address directives with hostname and domain name directives, so try to avoid doing that.  (Currently, if node.example.com's IP address is 192.168.1.80 and `fileserver.conf` contains `allow 192.168.1.80` and `deny node.example.com`, the IP-based `allow` directive will actually take precedence. This behavior may be changed in the future and should not be relied upon.)

### Host Names

Host names can be specified using either a complete hostname, or
specifying an entire domain using the `*` wildcard:

    [export]
        path /export
        allow host.domain1.com
        allow *.domain2.com
        deny badhost.domain2.com

### IP Addresses

> **Note:** Puppet 3.0.0 broke IP address filtering in fileserver.conf, and it is currently broken in all 3.0.x versions of Puppet. This is [issue #16686](http://projects.puppetlabs.com/issues/16686).
>
> If you rely on IP address filtering for custom file server mount points, you can implement it in Puppet 3 by simplifying fileserver.conf and adding a new rule to [auth.conf][authconf]:
>
> [authconf]: /guides/rest_auth_conf.html
>
> Original 2.x fileserver.conf:
>
>     [files]
>       path /etc/puppet/files
>       allow *.example.com
>       allow 192.168.100.0/24
>
> Workaround:
>
>     # fileserver.conf
>     [files]
>       path /etc/puppet/files
>       allow *
>
>     # auth.conf
>     path ~ ^/file_(metadata|content)s?/files/
>     auth yes
>     allow /^(.+\.)?example.com$/
>     allow_ip 192.168.100.0/24
>
> In short, fileserver.conf must allow all access, but only authorized nodes will be allowed to reach fileserver.conf. The `file_metadata/<mount point>` and `file_content/<mount point>` endpoints control file access in [auth.conf][authconf]. You must also make sure to catch the pluralized version of each, to enable recursive directory copies.

IP addresses can be specified similarly to host names, using either
complete IP addresses or wildcarded addresses. You can also use
CIDR-style notation:

    [export]
        path /export
        allow 127.0.0.1
        allow 192.168.0.*
        allow 192.168.1.0/24

### Global allow

Specifying a single wildcard will let any node access a mount point:

    [export]
        path /export
        allow *

Note that the default behavior for custom mount points is equivalent to `deny *`.

