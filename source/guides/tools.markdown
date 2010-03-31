Tools
=====

Here's an overview of the major tools in the Puppet solution.

* * *

Manpage documentation
---------------------

Additional information about the options supported by the various tools listed below
are listed in the manpages for those tools.   Please consult the manpages to learn
more.

puppetmasterd
-------------

Puppetmasterd is a central management daemon.  In most installations, you'll have one puppetmasterd
server and each managed machine will run 'puppetd'.   By default, puppetmasterd runs a certificate
authority, which you can read more about in the [security section](./security.html).

Puppetmasterd will automatically serve up puppet orders to managed systems, as well as files and
templates.   

The main configuration file for both puppetmasterd and puppetd/puppet is /etc/puppet/puppet.conf,
which has sections for each application.

puppetd
-------

Puppetd runs on each managed node.   By default, it will wake up every 30 minutes (configurable),
check in with puppetmasterd, send puppetmasterd new information about the system (facts), and
then recieve a 'compiled catalog' containing the desired system configuration that should be applied
as ordered by the central server.   Servers only see the information that the central server tells
them they should see, for instance, the server does not see configuration orders for other servers.
It is then the responsibility of the puppet daemon to make the system match the orders given.  Modules
and custom plugins stored on the puppetmasterd server are transferred down to managed nodes automatically.

puppet
------

When running puppet locally (for instance, to test manifests, or in a non-networked disconnected case), puppetdis run instead of puppet.  It then uses local files, and does not try to contact the central server.  Otherwise, it behaves the same as puppetd. 

facter
------

Clients use a library/tool called facter to provide information about the OS (version information, IP information, etc) to the central server.   These variables can then be used in conditionals, string expressions, and in templates.  To see a list of facts any node offers, simply run 'facter' on that node.  Facter is a required/included part of all Puppet installations.

ralsh
-----

Ralsh is a the "Resource Abstraction Layer SHell".  It can be used to try out Puppet concepts, or simply to manipulate your local system.

There are two main usage modes.   For example, to list information about the user 'xyz':

    > ralsh User "xyz"

    user { 'xyz':
       home => '/home/xyz',
       shell => '/bin/bash',
       uid => '1000',
       comment => 'xyz,,,',
       gid => '1000',
       groups => ['adm','dialout','cdrom','sudo','plugdev','lpadmin','admin','sambashare','libvirtd'],
       ensure => 'present'
    }

It can also be used to make additions and removals, as well as to list resources found on a system:

    > ralsh User "bob" ensure=present group=admin
 
    notice: /User[bob]/ensure: created
    user { 'bob':
        shell => '/bin/sh',
        home => '/home/bob',
        uid => '1001',
        gid => '1001',
        ensure => 'present',
        password => '!'
    }
 
    > ralsh User "bob" ensure=absent
    ...

    > ralsh User
    ...

Ralsh, therefore, can be a handy tool for admins who have to maintain various platforms.  It's possible to use ralsh the exact same way on OS X as it is Linux; eliminating the need to remember differences between commands.  You'll also see that it aggregrates information from multiple files and shows them together in a unified context.  Thus, for new Puppet users, ralsh can make a great introduction to the power of the resource abstraction layer.





