---
layout: default
title: Tools
---

Tools
=====

This guide covers the major tools that comprise Puppet. 

* * *

Single binary
-------------

From version 2.6.0 and onwards all the Puppet functions are also available via a single Puppet binary, in the style of git.

List of binary changes:

* puppetmasterd &rarr; puppet master
* puppetd &rarr; puppet agent
* puppet &rarr; puppet apply
* puppetca &rarr; puppet cert
* ralsh &rarr; puppet resource
* puppetrun &rarr; puppet kick
* puppetqd &rarr; puppet queue
* filebucket &rarr; puppet filebucket
* puppetdoc &rarr; puppet doc
* pi &rarr; puppet describe

This also results in a change in the puppet.conf configuration file. The sections, previously things like \[puppetd\], now should be renamed to match the new binary names. So \[puppetd\] becomes \[agent\]. You will be prompted to do this when you start Puppet. A log message will be generated for each section that needs to be renamed. This is merely a warning – existing configuration file will work unchanged.
 
Manpage documentation
---------------------

Additional information about each tool is provided in the relevant manpage. You can consult the local version of each manpage, or [view the web versions of the manuals](/man/).

puppet master (or puppetmasterd)
--------------------------------

[Puppet master](/man/master.html) is a central management daemon.  In most installations, you'll have one puppet master
server and each managed machine will run puppet agent.   By default, puppet master operates a certificate
authority, which can be managed using puppet cert.

Puppet master serves compiled configurations, files, templates, and custom plugins to managed nodes.

The main configuration file for puppet master, puppet agent, and puppet apply is `/etc/puppet/puppet.conf`,
which has sections for each application.

puppet agent (or puppetd)
-------------------------

[Puppet agent](/man/agent.html) runs on each managed node.   By default, it will wake up every 30 minutes (configurable),
check in with puppetmasterd, send puppetmasterd new information about the system (facts), and receive a 'compiled catalog' describing the desired system configuration. Puppet agent is then responsible for making the system match the compiled catalog. If `pluginsync` is enabled in a given node's configuration, custom plugins stored on the Puppet Master server are transferred to it automatically.

The puppet master server determines what information a given managed node should see based on its unique identifier ("certname"); that node will not be able to see configurations intended for other machines. 

puppet apply (or puppet)
------------------------

When running Puppet locally (for instance, to test manifests, or in a non-networked disconnected case), [puppet apply](/man/apply.html) is run instead of puppet agent.  It then uses local files, and does not try to contact the central server.  Otherwise, it behaves the same as puppet agent.

puppet cert (or puppetca)
-------------------------

The [puppet cert](/man/cert.html) command is used to sign, list and examine certificates used by Puppet to secure the connection between the Puppet master and agents.  The most common usage is to sign the certificates of Puppet agents awaiting authorisation:

    > puppet cert --list
    agent.example.com

    > puppet cert --sign agent.example.com

You can also list all signed and unsigned certificates:

    > puppet cert --all and --list
    + agent.example.com
    agent2.example.com

Certificates with a + next to them are signed.  All others are awaiting signature.

puppet doc (or puppetdoc)
-------------------------

[Puppet doc](/man/doc.html) generates documentation about Puppet and your manifests, which it can output in HTML, Markdown and RDoc.

puppet resource (or ralsh)
--------------------------

[Puppet resource](/man/resource.html) (also known as `ralsh`, for "Resource Abstraction Layer SHell") uses Puppet's resource abstraction layer to interactively view and manipulate your local system.

For example, to list information about the user 'xyz':

    > puppet resource User "xyz"

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

    > puppet resource User "bob" ensure=present group=admin

    notice: /User[bob]/ensure: created
    user { 'bob':
        shell => '/bin/sh',
        home => '/home/bob',
        uid => '1001',
        gid => '1001',
        ensure => 'present',
        password => '!'
    }

    > puppet resource User "bob" ensure=absent
    ...

    > puppet resource  User
    ...

Puppet resource is most frequently used as a learning tool, but it can also be used to avoid memorizing differences in common commands when maintaining multiple platforms. (Note that puppet resource can be used the same way on OS X as on Linux, e.g.)

puppet inspect
--------------

[Puppet inspect](/man/inspect.html) generates an inspection report and sends it to the puppet master. It cannot be run as a daemon.

Inspection reports differ from standard Puppet reports, as they do not record the actions taken by Puppet when applying a catalog; instead, they document the current state of all resource attributes which have been marked as auditable with the [`audit` metaparameter](http://docs.puppetlabs.com/references/latest/metaparameter.html#audit). (The most recent cached catalog is used to determine which resource attributes are auditable.)

Inspection reports are handled identically to standard reports, and must be differentiated  at parse time by your report tools; see the [report format documentation](http://projects.puppetlabs.com/projects/puppet/wiki/Report_Format_2) for more details. Although a future version of Puppet Dashboard will support viewing of inspection reports, Puppet Labs does not currently ship any inspection report tools.

Puppet inspect was added in Puppet 2.6.5.

facter
------

Puppet agent nodes use a library (and associated front-end tool) called facter to provide information about the hardware and OS (version information, IP address, etc) to the puppet master server. These facts are exposed to Puppet manifests as global variables, which can be used in conditionals, string expressions, and templates.  To see a list of the facts any node offers, simply open a shell session on that node and run `facter`.  Facter is included with (and required by) all Puppet installations.
