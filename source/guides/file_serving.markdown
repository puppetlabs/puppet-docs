---
layout: default
title: The Puppet File Server
---

The Puppet File Server
======================

This guide covers the use of Puppet's file serving capability.

* * * 

The Puppet master daemon includes a server for copying files to nodes, which can be used in the source attributes of file objects with the puppet: URI protocol.

    # copy a remote file to /etc/sudoers
    file { "/etc/sudoers":
        mode => 440,
        owner => root,
        group => root,
        source => "puppet:///modules/module_name/sudoers"
    }


All puppet file server URIs are structured as follows:

    puppet://{server hostname (optional)}/{mount point}/{remainder of path}

If a server hostname is omitted (i.e. `puppet:///{mount point}/{path}`; note the triple-slash), the hostname will resolve to whichever server the current node considers to be its master. As this makes manifest code more portable and reusable, hostnames should be omitted whenever possible. 

A puppet: URI maps to the filesystem on the central server in one of two ways. 

## Serving Module Files

The vast majority of file serving should be done through modules, and the Puppet file server is pre-configured for this primary use-case. If a URI's mount point is the semi-magical `modules`, Puppet will:

* Interpret the path segment that follows as the name of a module[^oldmodulemounts]
* Locate that module in the server's configured modulepath
* Resolve the remainder of the path against that module's `files/` directory.

That is to say, if a module named `test_module` is installed in the central server's `/etc/puppet/modules` directory, the following puppet: URI...

    puppet:///modules/test_module/static_files/testfile.txt

...will resolve to the following absolute path:

    /etc/puppet/modules/test_module/files/static_files/testfile.txt

If `test_module` were instead installed in the `/usr/share/puppet/modules` directory, the same URI would instead resolve to:

    /usr/share/puppet/modules/test_module/files/static_files/testfile.txt

Serving module files in this fashion requires no additional configuration, beyond ensuring that the necessary files are installed in the relevant module's `files/` directory. 

[^oldmodulemounts]: Older versions of Puppet generated individual mount points for each installed module; to avoid namespace conflicts, these were changed to subdirectories of the catchall `modules` mount point in version 0.25.0. 

## Serving Files From Arbitrary Mount Points

If necessary, Puppet can serve files from arbitrary mount points as specified in the server's file server configuration. The default location for this configuration data is 
/etc/puppet/fileserver.conf; this can be changed by passing the
--fsconfig flag to `puppet master`. 

### Configuration File Format

The format of the fileserver.conf file is almost
exactly like that of [rsync](http://samba.anu.edu.au/rsync/) (although it does not yet support the full functionality of rsync), and resembles an INI file:

    [arbitrary_mount_point]
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

### Security

There are two aspects to securing custom mount points in the Puppet file server: allowing
specific access, and denying specific access. By default no access
is allowed. There are three ways to specify a class of clients who
are allowed or denied access: by IP address, by name, or a global
allow using \*.

If clients are not connecting to the Puppet file server directly,
eg. using a reverse proxy and Mongrel (see [Using Mongrel](http://projects.puppetlabs.com/projects/1/wiki/Using_Mongrel) ),
then the file server will see all the connections as coming from
the proxy server and not the Puppet client. In this case it is
probably best to restrict access based on the hostname, as
explained above. Also in this case you will need to allow access to
machine(s) acting as reverse proxy, usually 127.0.0.0/8.

#### Priority

All deny statements are parsed before all allow statements, so if
any deny statements match a host, then that host will be denied,
and if no allow statements match a host, it will be denied.

#### Host Names

Host names can be specified using either a complete hostname, or
specifying an entire domain using the \* wildcard:

    [export]
        path /export
        allow host.domain1.com
        allow *.domain2.com
        deny badhost.domain2.com

#### IP Addresses

IP address can be specified similarly to host names, using either
complete IP addresses or wildcarded addresses. You can also use
CIDR-style notation:

    [export]
        path /export
        allow 127.0.0.1
        allow 192.168.0.*
        allow 192.168.1.0/24

#### Global allow

Specifying a single wildcard will let anyone into a module:

    [export]
        path /export
        allow *
