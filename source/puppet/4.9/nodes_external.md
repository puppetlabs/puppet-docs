---
title: "Writing external node classifiers"
---

[environment]: ./environments.html
[node definition]: ./lang_node_definitions.html
[main manifest]: ./dirs_manifest.html

An external node classifier (ENC) is an arbitrary script or application which can tell Puppet which classes a node should have. It can replace or work in concert with the `node` definitions in the main site manifest (`site.pp`).

Depending on the external data sources you use in your infrastructure, building an external node classifier can be a valuable way to extend Puppet.

## What is an ENC?

An external node classifier is an executable that Puppet Server or Puppet apply can call; it doesn't have to be written in Ruby. Its only argument is the name of the node to be classified, and it returns a YAML document describing the node.

Inside the ENC, you can reference any data source you want, including [PuppetDB]({{puppetdb}}). But from Puppet's perspective, it just puts in a node name and gets back a hash of information.

ENCs can co-exist with standard node definitions in `site.pp`, and the classes declared in each source are merged together.

### How merging works

Every node always gets a **node object** (which might be empty or might contain classes, parameters, and an environment) from the configured `node_terminus`. (This setting takes effect where the catalog is compiled; on Puppet Server when using an agent/master arrangement, and on the node itself when using Puppet apply. The default node terminus is `plain`, which returns an empty node object; the `exec` terminus calls an ENC script to determine what should go in the node object.) Every node **might** also get a [node definition][] from the [main manifest][].

When compiling a node's catalog, Puppet includes **all** of the following:

* Any classes specified in the node object it received from the node terminus
* Any classes or resources which are in the site manifest but outside any node definitions
* Any classes or resources in the most specific node definition in site.pp that matches the current node (if site.pp contains any node definitions)
    * Note 1: If site.pp contains at least one node definition, it **must** have a node definition that matches the current node; compilation fails if a match can't be found.
    * Note 2: If the node name resembles a dot-separated fully qualified domain name, Puppet makes multiple attempts to match a node definition, removing the right-most part of the name each time. Thus, Puppet would first try `agent1.example.com`, then `agent1.example`, then `agent1`. This behavior isn't mimicked when calling an ENC, which is invoked only once with the agent's full node name.
    * Note 3: If no matching node definition can be found with the node's name, Puppet tries one last time with a node name of `default`; most users include a `node default {}` statement in their site.pp file. This behavior isn't mimicked when calling an ENC.


## Considerations and differences from node definitions

[above]: #considerations-and-differences-from-node-definitions

* The YAML returned by an ENC isn't an exact equivalent of a node definition in `site.pp` --- it can't declare individual resources, declare relationships, or do conditional logic. The only things an ENC can do are **declare classes, assign top-scope variables, and set an environment.** This means an ENC is most effective if you've done a good job of separating your configurations out into classes and modules.
* In Puppet 3 and later, ENCs can set an [environment][] for a node,  overriding whatever environment the node requested. However, previous versions of Puppet use ENC-set and node-set environments inconsistently, with the ENC's used during catalog compilation and the node's used when downloading files.
* Even if you aren't using node definitions, you can still use site.pp to do things like set global resource defaults.
* Unlike regular node definitions, where a node can match a less specific definition if an exactly matching one isn't found (depending on Puppet's `strict_hostname_checking` setting), an ENC is called only once, with the node's full name.


## Connecting an ENC

To tell Puppet Server to use an ENC, you need to set two [settings](./config_about_settings.html): `node_terminus` has to be set to "exec", and `external_nodes` must have the path to the executable.

    [master]
      node_terminus = exec
      external_nodes = /usr/local/bin/puppet_node_classifier


## ENC output format

ENCs must return either a [YAML](http://www.yaml.org) hash or nothing. This hash can contain `classes`, `parameters`, and `environment` keys, and must contain at least either `classes` or `parameters`. ENCs should exit with an exit code of 0 when functioning normally, and can exit with a non-zero exit code if you want Puppet to behave as though the requested node was not found.

If an ENC returns nothing or exits with a non-zero exit code, the catalog compilation fails with a "could not find node" error, and the node is unable to retrieve configurations.

### Classes

If present, the value of `classes` must be either an array of class names or a hash whose keys are class names. That is, the following are equivalent:

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

Parameterized classes cannot be used with the array syntax. When using the hash key syntax, the value for a parameterized class should be a hash of the class's parameters and values. Each value can be a string, number, array, or hash. String values should be quoted, since YAML parsers like to treat certain magical unquoted strings (like `on`) as booleans. Non-parameterized classes can have empty values.

    classes:
        common:
        puppet:
        ntp:
            ntpserver: 0.pool.ntp.org
        aptsetup:
            additional_apt_repos:
                - deb localrepo.example.com/ubuntu lucid production
                - deb localrepo.example.com/ubuntu lucid vendor

### Parameters

If present, the value of the `parameters` key must be a hash of valid variable names and associated values; these are exposed to the compiler as top scope variables. Each value can be a string, number, array, or hash.

    parameters:
        ntp_servers:
            - 0.pool.ntp.org
            - ntp.example.com
        mail_server: mail.example.com
        iburst: true


### Environment

If present, the value of `environment` must be a string representing the desired [environment][] for this node. In Puppet 3 and later, this is the only environment used by the node in its requests for catalogs and files. In Puppet 2.7 ENC-set environments are not reliable, [as noted above.][above]

    environment: production

### Complete example

    ---
    classes:
        common:
        puppet:
        ntp:
            ntpserver: 0.pool.ntp.org
        aptsetup:
            additional_apt_repos:
                - deb localrepo.example.com/ubuntu lucid production
                - deb localrepo.example.com/ubuntu lucid vendor
    parameters:
        ntp_servers:
            - 0.pool.ntp.org
            - ntp.example.com
        mail_server: mail.example.com
        iburst: true
    environment: production

