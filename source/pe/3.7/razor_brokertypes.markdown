---
layout: default
title: " PE 3.8 » Razor » Creating Brokers"
subtitle: "Writing Broker Types"
canonical: "/pe/latest/razor_brokertypes.html"

---

Brokers are responsible for handing a node off to a configuration
management system, and consist of two parts: a *broker type* and some
information that is specific for each broker. For the Puppet Enterprise
broker type, this information consists of the address of the server, the
version of the agent that should be installed, and the location of the
Windows agent installer to use on systems provisioned with Windows. You
create brokers with the
[`create-broker` command](https://github.com/puppetlabs/razor-server/blob/master/doc/api.md).

The broker type is closely tied to the configuration management system that
the node should be handed off to. Generally, it consists of two things: a
(templated) shell script that performs the handoff and a description of the
additional information that must be specified to create a broker from that
broker type.

>**Note**: You will generally create at least one broker on your Razor server,
but writing new broker types is only necessary to use Razor with other
configuration management systems. This is an advanced process that is possible, but not officially supported by Puppet Labs.

## Create a PE Broker

You create a broker using the `puppet-pe` broker type with the following command:

     razor create-broker --name pe --broker-type puppet-pe
        --configuration server=puppet-master.example.com

The resulting broker enrolls nodes with the Puppet master on
`puppet-master.example.com`.

## Create a New Broker Type

Writing a new broker type is an advanced topic, and not needed to use Razor
with Puppet Enterprise. You can find examples of broker types in
[Razor's upstream repo](https://github.com/puppetlabs/razor-server/tree/master/brokers).

All files for a broker type live in a directory on the `broker_path` set in
Razor's configuration file. That directory must be called
`${broker_name}.broker/` and, at a minimum, contain an install script
`install.erb`, and a configuration file `configuration.yaml`.

### Writing the Broker Install Script

The broker install script is generated from the `install.erb` template of
your broker. It should return a valid shell script because tasks generally
perform the handoff to the broker by running a command like, `curl -s <%=
broker_install_url %> | /bin/bash`. The server makes sure that the `GET`
request to `broker_install_url` returns the broker's install script after
interpolating the template.

In the `install.erb` template, you have access to two objects: `node` and
`broker`. The `node` object gives you access to things like the node's
facts (via `node.facts["example"]`) and the node's tags (via `node.tags`), etc.

The `broker` object gives you access to the configuration settings. For
example, if your `configuration.yaml` specifies that a setting `version`
must be provided when creating a broker from this broker type, you can
access the value of `version` for the current broker as `broker.version`.

### The Broker Configuration File

The `configuration.yaml` file declares what parameters the user must
specify when creating a broker. For the Puppet broker type, it looks
something like this:

    ---
    certname:
      description: "The locally unique name for this node."
      required: true
    server:
      description: "The Puppet master server to request configurations from."
      required: true
    environment:
      description: "On agent nodes, the environment to request configuration in."

For each parameter, you can provide a human-readable description and
indicate whether this parameter is required. Parameters that are not
explicitly required are optional.


* * *


[Next: Setting Up and Installing Windows](./razor_windows.html)
