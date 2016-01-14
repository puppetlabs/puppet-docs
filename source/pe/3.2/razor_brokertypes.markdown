---
layout: default
title: " PE 3.2 » Razor » Brokers"
subtitle: "Writing Broker Types"
canonical: "/pe/latest/razor_brokertypes.html"

---

Brokers are responsible for handing a node off to a configuration management system, and consist of two parts: a *broker type* and some information that is specific for each broker type. For the Puppet broker type, this information consists of the node's certname, the address of the server, and the Puppet environment that a node should use. You create brokers with the [`create-broker` command](https://github.com/puppetlabs/razor-server/blob/master/doc/api.md)

The broker type is closely tied to the configuration management system that the node should be handed off to. Generally, it consists of two things: a (templated) shell script that performs the handoff and a description of the additional information that must be specified to create a broker from that broker type.

#### Create a PE Broker

1. Create a directory on the broker_path that is set in your `config.yaml` file. You can call it something like `sample.broker`. By default, the brokers directory in Razor.root is on that path.
2. Write a template for your broker install script. For example, create a file called `broker.json` and add the following:

		{
			"name": "pe",
			"configuration": {
				"server": "<PUPPET_MASTER_HOST>"
			},
			"broker-type": "puppet-pe"
		}

3. Save `broker.json` to `install.erb` in the `sample.broker` directory. 

4. If your broker type requires additional configuration data, add a `configuration.yaml` file to your `sample.broker` directory.


To see examples of brokers, have a look at the [stock brokers](https://github.com/puppetlabs/razor-server/tree/master/brokers) (pun intended) that ship with Razor.

## Writing the broker install script

The broker install script is generated from the `install.erb` template of your broker. It should return a valid shell script since tasks generally perform the handoff to the broker by running a command like, `curl -s <%= broker_install_url %> | /bin/bash`. The server makes sure that the `GET` request to `broker_install_url` returns the broker's install script after interpolating the template.

In the `install.erb` template, you have access to two objects: `node` and `broker`. The `node` object gives you access to things like the node's facts (via `node.facts["foo"]`) and the node's tags (via `node.tags`), etc.

The `broker` object gives you access to the configuration settings. For example, if your `configuration.yaml` specifies that a setting `version` must be provided when creating a broker from this broker type, you can access the value of `version` for the current broker as `broker.version`.

## The broker configuration file

The `configuration.yaml` file declares what parameters the user must specify when creating a broker. For the Puppet broker type, it looks something like:

    ---
    certname:
      description: "The locally unique name for this node."
      required: true
    server:
      description: "The puppet master server to request configurations from."
      required: true
    environment:
      description: "On agent nodes, the environment to request configuration in."

For each parameter, you can provide a human-readable description and indicate whether this parameter is required. Parameters that are not explicitly required are optional.


* * *


[Next: Razor Tasks](./razor_tasks.html)
