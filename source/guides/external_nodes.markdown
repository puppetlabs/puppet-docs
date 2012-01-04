---
layout: default
title: External Nodes
---

External Nodes
==============

Traditionally, puppet master uses the `node` definitions in the main site manifest (`site.pp`) to choose which classes to apply to a node. But you can also classify nodes based on a pre-existing external data source, like an LDAP database or a set of flat files describing your infrastructure. Depending on the data you've collected, building an external node classifier (ENC) can be one of the easiest and most high-value ways to extend Puppet. 

* * * 

What Is an ENC?
---------------

An external node classifier is an executable that can be called by puppet master; it doesn't have to be written in Ruby. Its only argument is the name of the node to be classified, and it returns a YAML document describing the node. 

Inside the ENC, you can reference any data source you want, including some of Puppet's own data sources, but from Puppet's perspective, it just puts in a node name and gets back a hash of information. 

Considerations and Limitations
------------------------------

* The YAML returned by an ENC isn't an exact equivalent of a node definition in `site.pp` --- it can't declare individual resources, declare relationships, or do conditional logic. The only things an ENC can do are **declare classes, assign top-scope variables, and set an environment.** This means an ENC is most effective if you've done a good job of separating your configurations out into classes and modules.
* Although ENCs can set an [environment](./environment.html) for a node, this is not very well supported --- currently, the server-set environment will win during catalog compilation, but the client-set environment will win when downloading files. (See [issue 3910](http://projects.puppetlabs.com/issues/3910) for more details.) We hope to make server-side environments work well in the future, but if you need them right now, the workaround is to use Puppet to manage `puppet.conf` on the agent and set the environment for the next run based on what the ENC thinks it should be.
* You can optionally combine an ENC with regular node definitions in `site.pp`. This works on the "I hope you brought enough for everybody" rule: things will work correctly if you have an ENC and no node definitions, but if there's at least one node definition, you need to have a default node defined or account for every node with a definition; Puppet will fail compilation with an error if a definition for a given node can't be found. 
* Even if you aren't using node definitions, you can still use site.pp to do things like set global resource defaults. 
* Unlike regular node definitions, where a node may match a less specific definition if an exactly matching one isn't found (depending on the puppet master's `strict_hostname_checking` setting), an ENC is called only once, with the node's full name. 


Connecting an ENC
-----------------

To tell puppet master to use an ENC, you need to set two [configuration](./configuring.html) options: `node_terminus` has to be set to "exec", and `external_nodes` should have the path to the executable. 

    [master]
      node_terminus = exec
      external_nodes = /usr/local/bin/puppet_node_classifier


ENC Output Format
-----------------

There have been three versions of the ENC output format. 

### Puppet 2.6.5 and Higher

ENCs MUST return either a [YAML](http://www.yaml.org) hash or nothing. This hash MAY contain `classes`, `parameters`, and `environment` keys, and MUST contain at least either `classes` or `parameters`. ENCs SHOULD exit with an exit code of 0 when functioning normally, and MAY exit with a non-zero exit code if you wish puppet master to behave as though the requested node was not found. 

If an ENC returns nothing or exits with a non-zero exit code, the catalog compilation will fail with a "could not find node" error, and the node will be unable to retrieve configurations.

#### Classes

If present, the value of `classes` MUST be either an array of class names or a hash whose keys are class names. That is, the following are equivalent:

    classes:
      - common
      - puppet
      - dns
      - ntp

    classes:
      common:
      puppet:
      dns:
      ntp:

Parameterized classes cannot be used with the array syntax. When using the hash key syntax, the value for a parameterized classe SHOULD be a hash of the class's attributes and values. Each value MAY be a string, number, array, or hash. Non-parameterized classes MAY have empty values.

    classes:
        common:
        puppet:
        ntp:
            ntpserver: 0.pool.ntp.org
        aptsetup:
            additional_apt_repos:
                - deb localrepo.magpie.lan/ubuntu lucid production
                - deb localrepo.magpie.lan/ubuntu lucid vendor

#### Parameters

If present, the value of the `parameters` key MUST be a hash of valid variable names and associated values; these will be exposed to the compiler as top scope variables. Each value MAY be a string, number, array, or hash. 

    parameters: 
        ntp_servers:
            - 0.pool.ntp.org
            - ntp.puppetlabs.lan
        mail_server: mail.puppetlabs.lan
        iburst: true
        

#### Environment

If present, the value of `environment` MUST be a string representing the desired environment for this node. As noted above, ENC-set environments are not currently reliable, although this can be worked around by managing `puppet.conf` as a resource. 

    environment: production

#### Complete Example

    ---
    classes:
        common:
        puppet:
        ntp:
            ntpserver: 0.pool.ntp.org
        aptsetup:
            additional_apt_repos:
                - deb localrepo.magpie.lan/ubuntu lucid production
                - deb localrepo.magpie.lan/ubuntu lucid vendor
    parameters: 
        ntp_servers:
            - 0.pool.ntp.org
            - ntp.puppetlabs.lan
        mail_server: mail.puppetlabs.lan
        iburst: true
    environment: production

### Puppet 0.23.0 through 2.6.4

As above, with the following exception: 

#### Classes

If present, the value of `classes` MUST be an array of class names. Parameterized classes cannot be used with an ENC. 

### Puppet 0.22.4 and Lower

ENCs MUST return two lines of text, separated by a newline (LF). The first line MUST be the name of a parent node defined in the main site manifest. The second line MUST be a space-separated list of classes. ENCs MUST exit with exit code 0; Puppet's behavior when faced with a non-zero ENC exit code is undefined. 

#### Complete example

    basenode
    common puppet dns ntp

Tricks, Notes, and Further Reading
----------------------------------

* Although only the node name is directly passed to an ENC, it can make decisions based on other facts about the node by querying the [inventory service](./inventory_service.html) REST API or using the puppet facts subcommand shipped with Puppet 2.7. 
* Puppet's "exec" `node_terminus` is just one way for Puppet to build node objects, and it's optimized for flexibility and for the simplicity of its API. There are situations where it can make more sense to design a native node terminus instead of an ENC, one example being the "ldap" node terminus that ships with Puppet. See [the LDAP nodes documentation on the wiki](http://projects.puppetlabs.com/projects/puppet/wiki/LDAP_Nodes) for more info. 
