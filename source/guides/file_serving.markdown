---
layout: default
title: The Puppet File Server
---

The Puppet File Server
======================

Learn how to use Puppet's file serving capability.

* * * 

Puppet comes with both a client and server for copying files
around. The file serving function is provided as part of the
central Puppet daemon, puppetmasterd, and the client function is
used through the source attribute of file objects:

    # copy a remote file to /etc/sudoers
    file { "/etc/sudoers":
        mode => 440,
        owner => root,
        group => root,
        source => "puppet://server/modules/module_name/sudoers"
    }

As the example implies, Puppet's fileserving function abstracts
local filesystem topology by supporting fileservice "modules".  

In release 0.25.0 and later you must specify your source statements 
in the format:

    source => "puppet://server/modules/module_name/file"

Note the addition of the "modules" statement which differs from the earlier 
0.24.x releases.

Specifying a path to serve and a name for the path, clients may
request by name instead of by path. This provides the ability to
conceal from the client unnecessary details like the local
filesystem configuration.

## File Format

The default location for the file service is
/etc/puppet/fileserver.conf; this can be changed using the
--fsconfig flag to puppetmasterd. The format of the file is almost
exactly like that of [rsync](http://samba.anu.edu.au/rsync/),
although it does not yet support the full functionality of rsync.
The configuration file resembles INI files, but it is not exactly
the same:

    [module]
        path /path/to/files
        allow *.domain.com
        deny *.wireless.domain.com

These three options represent the only options currently available
in the configuration file. The module name, somewhat obviously,
goes in the brackets. The path is the only required option. The
default security configuration is to deny all access, so if no
allow lines are specified, the module will be configured but
available to no one.

The path can contain any or all of %h, %H, and %d, which are
dynamically replaced by the client's hostname, its fully qualified
domain name and it's domain name, respectively. All are taken from
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

There are two aspects to securing the Puppet file server: allowing
specific access, and denying specific access. By default no access
is allowed. There are three ways to specify a class of clients who
are allowed or denied access: by IP address, by name, or a global
allow using \*.

If clients are not connecting to the Puppet file server directly,
eg. using a reverse proxy and Mongrel (see [Using Mongrel](./mongrel.html) ),
then the file server will see all the connections as coming from
the proxy server and not the Puppet client. In this case it is
probably best to restrict access based on the hostname, as
explained above. Also in this case you will need to allow access to
machine(s) acting as reverse proxy, usually 127.0.0.0/8.

### Priority

All deny statements are parsed before all allow statements, so if
any deny statements match a host, then that host will be denied,
and if no allow statements match a host, it will be denied.

### Host Names

Host names can be specified using either a complete hostname, or
specifying an entire domain using the \* wildcard:

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

Specifying a single wildcard will let anyone into a module:

    [export]
        path /export
        allow *
