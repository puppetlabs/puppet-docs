---
layout: default
title: Setting Up Puppet
---

Setting Up Puppet
=================

Once Puppet is installed, learn how to set it up for initial operation.

* * *

Open Firewall Ports On Server and Agent Node
--------------------------------------------

In order for the puppet master server to centrally manage agent nodes, you
may need to open port 8140 for incoming tcp connections on the puppet master.
Consult your firewall documentation for more details.

Configuration Files
-------------------

The main configuration file for Puppet is `/etc/puppet/puppet.conf`.  A package based
installation file will have created this file automatically.  Unlisted settings have
reasonable defaults.   To see all the possible values, you may run:

    $ puppet --genconfig

Configure DNS (Optional)
------------------------

The puppet agent looks for a server named `puppet` by default. If you
choose, you can set up a puppet DNS CNAME record to avoid having to
specify your puppet master hostname in the configuration of each agent node.

If you have local DNS zone files, you can add a CNAME record
pointing to the server machine in the appropriate zone file.

    puppet   IN   CNAME  crabcake.picnic.edu.

See the book "DNS and Bind" by Cricket Liu et al if you need help
with CNAME records. After adding the CNAME record, restart your
name server. You can also add a host entry in the `/etc/hosts` file
on both the server and agent nodes.

For the server:

    127.0.0.1 localhost.localdomain localhost puppet

For the agent nodes:

    192.168.1.67 crabcake.picnic.edu crabcake puppet

NOTE: If you can ping the server by the name `puppet` but
Syslog (for example `/var/log/messages`) on the agent nodes still has
entries stating the puppet agent cannot connect to the server,
verify port 8140 is open on the server.

Puppet Language Setup
---------------------

### Create Your Site Manifest

Puppet is a declarative system, so it does not make
much sense to speak of "executing" Puppet programs or scripts.
Instead, we choose to use the word *manifest* to describe
our Puppet code, and we speak of *applying* those manifests to the
managed systems. Thus, a *manifest* is a text document written in the
Puppet language and meant to describe and result in a desired configuration.

Puppet assumes that you will have one
central manifest capable of configuring an entire site, which
we call the *site manifest*. You could have multiple, separate site
manifests if you wanted, though if doing this each of them would need
their own puppet servers.  Individual system differences can be separated
out, node by node, in the site manifest.

Puppet will start with `/etc/puppet/manifests/site.pp` as the primary
manifest, so create `/etc/puppet/manifests` and add your manifest,
along with any files it includes, to that directory. It is highly
recommended that you use some form of version control (git, svn, etc)
to keep track of changes to manifests.

### Example Manifest

The site manifest can do as little or as much as you want. A
good starting point is a manifest that makes sure that your sudoers file has the
appropriate permissions:

{% highlight ruby %}
    # site.pp
    file { "/etc/sudoers":
        owner => root, group => root, mode => 440
    }
{% endhighlight %}

For more information on how to create the site manifest, see [the Manifests chapter of the Learning Puppet tutorial](/learning/manifests.html).


Start the Central Daemon
------------------------

Most sites should only need one puppet master server. Puppet Labs
will be publishing a document describing best practices for scale-out
and failover, though there are various ways to address handling
in larger infrastructures.  For now, we'll explain how to
work with the one server, and others can be added as needed.

First, decide which machine will be the central server; this is
where puppet master will be run.

The best way to start any daemon is using the local server's
service management system, often in the form of init scripts.

If you're running on Red Hat, CentOS, Fedora, Debian, Ubuntu, or
Solaris, the OS package already contains a suitable init script.
If you don't have one, you can either create your own using an existing
init script as an example, or simply run without one (though this
is not advisable for production environments).

It is also neccessary to create the puppet user and group
that the daemon will use.   Either create these manually, or start
the daemon with the `--mkusers` flag to create them.

    # puppet master --mkusers

Starting the puppet daemon will automatically create all necessary certificates, directories, and files.

NOTE:  To enable the daemon to also function as a file server, so that agent nodes can copy files from it, create a
[fileserver configuration file](./file_serving.html) and restart puppet master.

Verifying Installation
----------------------

To verify that your daemon is working as expected, pick a single
agent node to use as a testbed. Once Puppet is installed on that
machine, run the agent against the central server to verify
that everything is working appropriately. You should start the
agent in verbose mode the first time and with the `--waitforcert` flag enabled:

    # puppet agent --server myserver.example.com --waitforcert 60 --test

Adding the --test flag causes the puppet agent to stay in the foreground; print extra output; only run once, then exit; and to exit immediately if the puppet master fails to compile the configuration catalog (by default, puppet agent will use a cached configuration if there is a problem with the remote manifests).

In running the agent, you should see the message:

    info: Requesting certificate
    warning: peer certificate won't be verified in this SSL session
    notice: Did not receive certificate

INFO: This message will repeat every 60 seconds with the above
command.

This is normal, since your server is not auto-signing certificates
as a security precaution.

On your server, list the waiting certificates:

    # puppet cert --list

You should see the name of the test agent node. Now go ahead and sign
the certificate:

    # puppet cert --sign mytestagent.example.com

Within 60 seconds, your test agent should receive its certificate
from the server, receive its configuration, apply it locally, and
exit normally.

NOTE: By default, puppet agent runs with a waitforcert of five minutes; set
the value to 0 to disable this wait-polling period entirely.

Scaling your Installation
-------------------------

For more about how to tune Puppet for large environments, see [Scaling Puppet](./scaling.html).


