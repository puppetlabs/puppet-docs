Security Infrastructure
=======================

Learn about Puppet's built in security systems.

* * *

SSL
---

In centrally managed server context, Puppet uses SSL for security, which is the same thing your
browser uses.   We find this system is much easier to distribute than relying on SSH keys for
bi-directional communication, and is better suited to writing applications (as opposed to 
just doing remote scripting).

puppetca
--------

When a node starts up that does not have a certificate, it checks in with the configured
puppetmaster (central management daemon) and sends a certificate request.  Puppet can
either be configured to autosign the certificate (generally not recommended for 
production environmnets), or a list of certificates that need to be signed can be 
shown with:

    puppetca --list

To sign a certificate, use the following:

    puppetca --sign servername.example.org

Puppetca can also be used to revoke certificates, see the puppetca manpage for further information.

Firewall details
----------------

If a firewall is present, you should open port 8140, both tcp and udp, on the server and client machines.

File Serving Configuration
--------------------------

Puppet's fileserver is used to serve up files (and directories full of files) to the client. It can be configured in /etc/puppet/fileserver.conf (default path location):

    [modulename]
    path /path/to/files
    allow *.domain.com
    deny *.wireless.domain.com

These three options represent the only options currently available in the configuration file. The module name, somewhat obviously, goes in the brackets. The path is the only required option. The default security configuration is to deny all access, so if no allow lines are specified, the module will be configured but available to no one.

The path can contain any or all of %h, %H, and %d, which are dynamically replaced by the client’s hostname, its fully qualified domain name and it’s domain name, respectively. All are taken from the client’s SSL certificate (so be careful if you’ve got hostname/certname mismatches). This is useful in creating modules where files for each client are kept completely separately, e.g. for private ssh host keys. For example, with the configuration

    [private]
    path /data/private/%h
    allow *

The request for file /private/file.txt from client client1.example.com will look for a file /data/private/client1/file.txt, while the same request from client2.example.com will try to retrieve the file /data/private/client2/file.txt on the fileserver.

Currently paths cannot contain trailing slashes or an error will result. Also take care that in puppet.conf youare not specifying directory locations that have trailing slashes.

auth.conf
---------

Documentation for auth.conf is pending.

namespaceauth.conf
------------------

Documentation for namespaceauth.conf is pending

Serverless operation
--------------------

In maximum security environments, or disconnected setups, it is possible to run puppet without the central management daemon.  In this case, run 'puppet' locally instead of puppetd, and make sure the manifests are transferrred to the managed machine before running puppet, as there is no 'puppetmasterd' to serve up the manifests and source material.


