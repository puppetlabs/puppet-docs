---
layout: default
title: "PE 3.0 » Orchestration » Invoking Actions (Command Line)"
---

Running Actions
-----

Orchestration actions are grouped and distributed as MCollective
plugins. In the default installation of Puppet Enterprise, you can run any orchestration action from any plugin while logged in as the `peadmin` user on the puppet master node.

To open a shell as the `peadmin` user, run:

    $ sudo -i -u peadmin

To run orchestration actions, use the `mco` command:

    $ mco <PLUGIN> <FILTER> <ACTION> <ARGUMENT> <OPTIONS>

Filtering Nodes
-----

Most orchestration actions in PE can be executed
on a set of nodes determined by meta-data about the deployment.
This filtering provides a much more convenient way to manage nodes
than the traditional approach of using host names or fully
qualified domain names to identify and access machines. Node sets
can be created by filtering based on Facter facts, Puppet classes,
and host names. Filters can be specified by passing options to the
`mco` command. For example:

    $ mco find --with-fact osfamily=RedHat

This command forces the find action to only return nodes which have a
fact named osfamily with a value of RedHat.  Filter options are
case sensitive and support regular expression syntax.

TODO need more

