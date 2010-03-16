External Nodes
==============

Do you have an external database (or LDAP? or File?) that lists which of your machines
should fulfill certain functions?   Puppet's external nodes feature helps you tie that 
data into Puppet, so you have less data to enter and manage.

* * *

What's an External Node?
------------------------

External nodes allow you to store your node definitions in an
external data source. For example, a database or other similar
repository. When the Puppet client connects the master queries the
external node script and asks "Do you have a host called
insertnamehere" by passing the name of the host as the first
argument to the external nodes script.

This allows you to:

1.  to avoid defining each node in a Puppet manifest and allowing a
    greater flexibility of maintenance.
2.  potentially query external data sources (such as LDAP or asset
    management stores) that already know about your hosts meaning you
    only maintain said information in one place.

A subtle advantage of using a external nodes tool is that
parameters assigned to nodes in a an external node tool are set a
top scope not in the scope created by the node assignment in
language. This leaves you free to set default parameters for a base
node assignment and define whatever inheritance model you wish for
parameters set in the children. In the end, Puppet accepts a list
of parameters for the node and those parameters when set using an
External Node tool are set at top scope.

How to use External Nodes
-------------------------

To use an external node classifier, in addition to or rather than
having to define a node entry for each of your hosts, you need to
create a script that can take a hostname as an argument and return
information about that host for puppet to use.

NOTE: You can use node entries in your manifests together with
External nodes. You cannot however use external nodes and LDAP
nodes together. You must use one of the two types.

Limitations of External Nodes
-----------------------------

External nodes can't specify resources of any kind - they can only
specify class membership, environments and attributes. Those
classes can be in hierarchies however, so inheritance is available. 

Configuring puppetmasterd
-------------------------

First, configure your puppetmasterd to use an external nodes
script in your /etc/puppet/puppet.conf:

    [main]
    external_nodes = /usr/local/bin/puppet_node_classifier

For version 0.24 and later an additional configuration option,
node\_terminus, needs to be specified to select the appropriate
node terminus:

    [main]
    external_nodes = /usr/local/bin/puppet_node_classifier
    node_terminus = exec

There are two different versions of External Node support, the
format of the output required from the script changed drastically
(and got a lot better) in version 0.23. In both versions, after
outputting the information about the node, you should exit with
code 0 to indicate success, if you want a node to not be
recognized, and to be treated as though it was not included in the
configuration, your script should exit with a non-zero exit code.

External node scripts for version 0.23 and later
------------------------------------------------

Starting with version 0.23, the script must produce
[YAML](http://www.yaml.org/) output of a hash, which contains one
or both of the keys classes and parameters. The classes value is an
array of classes to include for the node, and the parameters value
is a hash of variables to define. If your script doesn't produce
any output, it may be called again with a different hostname, in my
testing, the script would be called up to three times, first with
hostname.example.com as an argument, then just with hostname, and
finally with default. It will only be called with the shorter
hostname or with default if the earlier run didn't produce any
output:

    #!/bin/sh
    # Super-simple external_node script for versions 0.23 and later
    cat <<"END"
    ---
    classes:
      - common
      - puppet
      - dns
      - ntp
    environment: production
    parameters:
      puppet_server: puppet.example.com
      dns_server: ns.example.com
      mail_server: mail.example.com
    END
    exit 0

This example will produce results basically equivalent to this node
entry:

    node default {
        $puppet_server = 'puppet.example.com'
        $dns_server = 'ns.example.com'
        $mail_server = 'mail.example.com'
        include common, puppet, dns, ntp
    }

In both versions, the script should exit with code 0 after
producing the desired output. Exit with a non-zero exit code if you
want the node to be treated as though it was not found in the
configuration.

External node scripts for versions before 0.23
----------------------------------------------

Before 0.23, the script had to output two lines, the first was a
parent node, and the second was a list of classes:

    #!/bin/sh
    # Super-simple external_node script for versions of puppet prior to 0.23
    echo "basenode"
    echo "common puppet dns ntp"
    exit 0

This sample script is essentially the same as this node
definition:

    node default inherits basenode {
      include common, puppet, dns, ntp
    }




