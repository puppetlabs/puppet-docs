---
layout: default
title: " PE 3.2 » Razor » Provisioning Setup"
subtitle: "Set Up Razor Provisioning"
canonical: "/pe/latest/razor_using.html"

---

This page describes the provisioning setup process. You must first create some initial objects: 

+ **Repo**: the container for the objects you install with Razor, such as operating systems.
+ **Broker**: the connector between a node and a configuration management system.
+ **Tasks**: the installation and configuration instructions. 
+ **Policy**: the instructions that tell Razor which repos, brokers, and tasks to use for provisioning.

After creating these objects, you register a node on the Razor server. To work through these steps, you must already have a Razor server up and running, as described in [Install and Set Up Razor](./razor_install.html).


Include Repos
-------------

A repo contains all of the actual bits used when installing a node with Razor. The repo is identified by a unique name, such as 'centos-6.4'. The instructions for an installation are contained in *tasks*, which are described below.

To load a repo onto the server, you use: `razor create-repo --name=<repo name> --iso-url <URL>`.
	
For example: `razor create-repo --name=centos-6.4 --iso-url http://mirrors.usc.edu/pub/linux/distributions/centos/6.4/isos/x86_64/CentOS-6.4-x86_64-minimal.iso`.

**Note**: Creating the repo can take five or so minutes, plus however long it takes to download the ISO and unpack the contents. Currently, the best way to find out the status is to check the log file.


Include Brokers
-------------

Brokers are responsible for handing a node off to a config management system like Puppet Enterprise. Brokers consist of two parts: a *broker type* and information that is specific for the broker type. 

The broker type is closely tied to the configuration management system that the node is being handed off to. Generally, it consists of a shell script template and a description of what additional information must be specified to create a broker from that broker type.

For the Puppet Enterprise broker type, this information consists of the node's server, and the version of PE that a node should use. The PE version defaults to "latest" unless you stipulate a different version. 

You create brokers with the `create-broker` command. For example, the following sets up a simple no-op broker that does nothing: 
`razor create-broker --name=noop --broker-type=noop`.
	
This command sets up the PE broker, which requires the server parameter. 

	razor create-broker --name foo --broker-type puppet-pe --configuration '{ "server": "puppet.example.com" }'

**Stock Broker Types**

Razor ships with some stock broker types for your use:  puppet-pe, noop, and puppet.

**Note:** The puppet-pe broker type depends on the package-based simplified agent installation method. For details, see  [Installing Agents](./install_basic.html#installing-agents). 	


Include Tasks
-------------

Tasks describe a process or collection of actions that should be performed while provisioning machines. They can be used to designate an operating system or other software that should be installed, where to get it, and the configuration details for the installation.
 
Tasks are structurally simple. They consist of a YAML metadata file and any number of ERB templates. You include the tasks you want to run in your policies (policies are described in the next section).

Razor provides a handful of existing tasks, or you can create your own. To learn more about tasks, see [Writing Tasks and Templates](./razor_tasks.html). 


Create Policies
-------------

Policies orchestrate repos, brokers, and tasks to tell Razor what bits to install, where to get the bits, how they should be configured, and how to communicate between a node and PE.  

**Note**: Tags are named rule-sets that identify which nodes should be attached to a given policy.

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

**Policy Tables**
You might create multiple policies, and then retrieve the policies collection. The policies are listed in order in a policy table. You can influence the order of policies as follows:

+ When you create a policy, you can include a `before` or `after` parameter in the request to indicate where the new policy should appear in the policy table.
+ Using the `move-policy` command with `before` and `after` parameters, you can put an existing policy before or after another one.

See [Razor Command Reference](./razor_reference.html) for more information.

#### Create a Policy

1. Create a file called `policy.json` and copy the following template text into it:

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

2. Edit the options in the `policy.json` template with information specific to  your environment. 
3. Apply the policy by executing:	`razor create-policy --json policy.json`.


Identify and Register Nodes
-------------

Next, verify that your machine can PXE boot from the Razor server and register itself as a node.

1. PXE boot a node machine in the Razor environment you have constructed for testing.
2. Find out what nodes are registered by executing `razor nodes`.
		
	Identify a node in the list of registered nodes. The format should look like this:

		id: "http://localhost:8080/api/collections/nodes/node1"
		name: "node1"                                            
		spec: "/razor/v1/collections/nodes/member" 

You can also inspect the registered nodes by appending the node name to the command as follows. The name of the node is generated by the server and follows the pattern `nodeNNN` where `NNN` is an integer. This command provides information such as the log path, hardware information, associated policies, and facts. 

	razor nodes <NODE_NAME>


The following command opens a specific node's log: `razor nodes <node name> log`.


* * *


- [Next: Razor Command Reference](./razor_reference.html)


