---
layout: default
title: The Puppet File Server
---

The Puppet File Server
======================

This guide covers the use of Puppet's file serving capability.

* * *

The `puppet master` daemon includes a file server for transferring static files. If a `file` resource declaration contains a `puppet:` URI in its `source` attribute, nodes will retrieve that file from the master's file server:

    # copy a remote file to /etc/sudoers
    file { "/etc/sudoers":
        mode => 440,
        owner => root,
        group => root,
        source => "puppet:///modules/module_name/sudoers"
    }


All puppet file server URIs are structured as follows:

    puppet://{server hostname (optional)}/{mount point}/{remainder of path}

If a server hostname is omitted (i.e. `puppet:///{mount point}/{path}`; note the triple-slash), the URI will resolve to whichever server the evaluating node considers to be its master. As this makes manifest code more portable and reusable, hostnames should be omitted whenever possible. 

The remainder of the `puppet:` URI maps to the server's filesystem in one of two ways, depending on whether the files are provided by a module or exposed through a custom mount point. 

## Serving Module Files

As the vast majority of file serving should be done through [modules](modules.html), the Puppet file server provides a special and semi-magical mount point called `modules`, which is available by default. If a URI's mount point is `modules`, Puppet will:

* Interpret the next segment of the path as the name of a module...[^oldmodulemounts]
* ... locate that module in the server's `modulepath` (as described [here](modules.html) under "Module Lookup")...
* ... and resolve the remainder of the path starting in that module's `files/` directory.

That is to say, if a module named `test_module` is installed in the central server's `/etc/puppet/modules` directory, the following puppet: URI...

    puppet:///modules/test_module/testfile.txt

...will resolve to the following absolute path:

    /etc/puppet/modules/test_module/files/testfile.txt

If `test_module` were installed in `/usr/share/puppet/modules`, the same URI would instead resolve to:

    /usr/share/puppet/modules/test_module/files/testfile.txt

Although no additional configuration is required to use the `modules` mount point, some access controls can be specified in the file server configuration (see below) by adding a `[modules]` configuration block with no path specified:

    [modules]
        allow *.domain.com
        deny *.wireless.domain.com

It is not currently possible to apply more granular access controls (e.g. per module) inside the `modules` mount point. 

[^oldmodulemounts]: Older versions of Puppet generated individual mount points for each installed module; to reduce namespace conflicts, these were changed to subdirectories of the catch-all `modules` mount point in version 0.25.0. 

## Serving Files From Custom Mount Points

Puppet can also serve files from arbitrary mount points specified in the server's file server configuration (see below). When serving files from a custom mount point, Puppet does not perform the additional URI abstraction used in the `modules` mount, and will resolve the path following the mount name as a simple directory structure.

## File Server Configuration

The default location for the file server's configuration data is 
/etc/puppet/fileserver.conf; this can be changed by passing the
`--fsconfig` flag to `puppet master`. 

The format of the fileserver.conf file is almost
exactly like that of [rsync](http://samba.anu.edu.au/rsync/) (although it does not yet support the full functionality of rsync), and roughly resembles an INI file:

    [mount_point]
        path /path/to/files
        allow *.domain.com
        deny *.wireless.domain.com

These three options represent the only options currently available
in the configuration file. The path is the only required option. The
default security configuration is to deny all access, so if no
allow lines are specified, the module will be configured but
available to no one.

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

Securing the Puppet file server consists of allowing
specific access and denying specific access. By default, all nodes can access the `modules` mount point and no nodes can access custom mount points. 
Classes of nodes can be identified (for permission or denial) in three ways: by IP address, by name, or by a single global wildcard (`*`). 

If nodes are not connecting to the Puppet file server directly,
e.g. using a reverse proxy and Mongrel (see [Using Mongrel](./mongrel.html)),
then the file server will see all the connections as coming from
the proxy server rather than the Puppet client. In this case, it is best to restrict access based on hostname. Additionally, the 
machine(s) acting as reverse proxy (usually 127.0.0.0/8) will need to be 
allowed to access the mount point.

### Priority

All deny statements are parsed before all allow statements, so if
any deny statements match a node, that node will be denied. Nodes that aren't specifically denied will have an opportunity to match the allow statements, and will be denied if they do not match any. 

### Host Names

Host names can be specified using either a complete hostname, or
specifying an entire domain using the `*` wildcard:

    [export]
        path /export
        allow host.domain1.com
        allow *.domain2.com
        deny badhost.domain2.com

### IP Addresses

IP address can be specified similarly to host names, using either
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
