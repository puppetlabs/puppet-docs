---
layout: default
title: " PE 3.2 » Razor » Provision Machines"
subtitle: "Provision With Razor"
canonical: "/pe/latest/razor_using.html"

---

This page describes the process for provisioning machines with Razor. You must first create some initial objects: 

+ Repo - The container for the objects you install with Razor, such as operating systems.
+ Broker - The connector between a node and a configuration management system.
+ Tasks - The installation and configuration instructions. 
+ Policy - The instructions that tell Razor which repos, brokers, and tasks to use for provisioning.

After creating these objects, you register a node on the Razor server. To work through these steps, you must already have a Razor server up and running, as described in [Install and Set Up Razor](./razor_install.html).


Create Repos
-------------

A repo contains all of the objects you use with Razor, and is identified by a unique name, such as 'centos-6.4'. The repo contains the actual bits that are used when installing a node. The instructions for an installation are contained in *tasks*. Razor comes with some predefined tasks that can be found in the tasks/ directory in the razor-server repo, and can all be used by simply mentioning their name in a policy. You can also [write your own tasks](./razor_tasks.html). 

To load a repo onto the server, run the following command. It can take several minutes  because the server has to download the ISO and unpack the contents.

	razor create-repo --name=<repo name> --iso-url <URL>
	
For example:

	razor create-repo --name=centos-6.4 --iso-url http://some.where/centos.iso


Create Brokers
-------------

Brokers are responsible for handing a node off to a config management system, such as Puppet Enterprise. Brokers consist of two parts: a *broker type* and information that is specific for the broker type. 

The broker type is closely tied to the configuration management system that the node is being handed off to. Generally, it consists of a shell script template, and a description of what additional information must be specified to create a broker from that broker type.

For the Puppet Enterprise broker type, this information consists of the node's server, and the version of PE that a node should use. The PE version defaults to "latest" unless you stipulate a different version. 

You create brokers with the `create-broker` command. For example, the following sets up a simple noop broker that does nothing:

	razor create-broker --name=noop --broker-type=noop

**Stock Brokers**

Razor ships with these stock brokers (pun intended) for your use:  puppet-pe, noop, and puppet. 	

####Create a PE Broker

1. Create a directory on the broker_path that is set in your config.yaml file. You can call it something like sample.broker. By default, the brokers directory in Razor.root is on that path.
2. Write a template for your broker install script. For example, create a file called broker.json and add the following:

		{
			"name": "pe",
			"configuration": {
				"server": "<PUPPET_MASTER_HOST>"
			},
			"broker-type": "puppet-pe"
		}

3. Save broker.json to install.erb in the sample.broker directory. 

4. If your broker type requires configuration data, add a configuration.yaml to your sample.broker directory.


Include Tasks
-------------

Tasks describe a process or collection of actions that should be performed while provisioning machines. They can be used to designate an operating system or other software that should be installed, where to get it, and the configuration details for the installation.
 
Tasks are structurally simple. They consist of a YAML metadata file, and any number of ERB templates. You include the tasks you want to run in your policies (policies are described in the next section).

Razor provides a handful of existing tasks, or you can create your own. To learn more about tasks, see [Writing Tasks and Templates](./razor_tasks.html). 


Create Policies
-------------

Policies orchestrate the repos, brokers, and tasks for Razor to tell Razor what bits to install, where to get the bits, how they should be configured, and how to communicate between a node and PE.  

**Note** - Tags are named rule sets that identify which nodes should be attached to the given policy.

Because policies contain a good deal of information, it's handy to save them in a JSON file that you run when you create the policy. Here's an example of a policy called "centos-for-small." This policy stipulates that it should be applied to the first 20 nodes that have no more than two processors that boot. 

	{
		"name": "centos-for-small",
		"repo": { "name": "centos-6.4" },
		"task": { "name": "centos" },
		"broker": { "name": "noop" },
		"enabled": true,
		"hostname": "host${id}.example.com",
		"root_password": "secret",
		"max_count": "20",
		"tags": [{ "name": "small", "rule": ["<=", ["num", ["fact", "processorcount"]], 2]}]
	}

####Create a Policy

1. Create a file called “policy.json” and copy the following template text into it:

		{	
  			"name": "test_<NODE_ID>",
  			"repo": { "name": "<OS>" },
  			"task": { "name": "<INSTALLER>" },
  			"broker": { "name": "pe" },
  			"enabled": true,
  			"hostname": "node${id}.vm",
  			"root_password": "puppet",
  			"max_count": "20",
  			"tags": [{ "name": "<TAG_NAME>", "rule": ["in",["fact", "macaddress"],"<NODE_MAC_ADDRESS>"]}]
  		}

2. Edit the options in the policy.json template with information specific to  your environment. 
3. Apply the policy by executing the following command:

		razor create-policy --json policy.json


Identify and Register Nodes
-------------

Next, verify that your machine can PXE boot from the Razor server and register itself as a node.

1. PXE boot a node machine in the Razor environment you have constructed for testing.
2. Find out what nodes are registered by executing the command:

		razor nodes
		
	Identify a node in the list of registered nodes. The format should look like like this:

		id: "http://localhost:8080/api/collections/nodes/node1"
		name: "node1"                                            
		spec: "/razor/v1/collections/nodes/member" 

You can also inspect the registered nodes by appending the node name to the command, as follows. The name of the node is generated by the server and follows the pattern `nodeNNN` where `NNN` is an integer. This command provides information such as the log path, hardware information, associated policies, and facts. 

	razor nodes <NODE_NAME>


The following command opens a specific node's log:

	razor nodes <node name> log 


- [Next: Writing Tasks](./razor_tasks.html)


