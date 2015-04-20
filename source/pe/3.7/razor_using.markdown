---
layout: default
title: " PE 3.8 » Razor » Provision a Node"
subtitle: "Basic Guide to Provision a Single Node"
canonical: "/pe/latest/razor_using.html"

---

You're ready to provision a node after you've performed the setup described on the pages [Set Up a Razor Environment](./razor_prereq.html) and [Install Razor](./razor_install.html). This means you have three machines or virtual machines:

* The first is running a DHCP/DNS/TFTP service with SELinux configured to enable PXE boot.
* The second is running Puppet Enterprise and the Razor server and client.
* The third is the node that you'll provision; it should not be booted up when you begin the process.

The following steps walk you through the process of creating [Razor objects](./razor_objects) and provisioning a node with Centos.

### Important Info About the Machines You provision

To successfully use a machine with Razor and install an operating system on it, the machine must:

+ Be supported by the operating system that you're installing.
+ Be able to successfully boot into the microkernel, which is based on Fedora 19.
+ Be able to successfully boot the iPXE firmware.

In addition:

+ The Razor microkernel is 64-bit only. Razor can only provision 64-bit machines.
+ Razor has a minimum RAM requirement of 512MB.

## Run the Razor Server and Register a Node

1. Run the Razor client.
2. Type `razor nodes` to see the collection of machines that Razor is managing.
The first time you run this command, you should see no nodes.
3. Create a node to see what happens. To do this, boot your third machine. Without any further setup on the Razor server, the node boots into the microkernel and Razor discovers the node. You'll see the PXE boot working. After the initial PXE boot, the node downloads the microkernel.
4. Run `razor nodes` again. Now there's a node in the nodes collection. It looks something like this:

		id: "http://localhost:8150/api/collections/node/node2"
		name: "node2"
		spec: "/razor/v1/collections/nodes/member"

5. Look at the node details: `razor nodes <node name>`. In addition to the above information, you'll see hardware and DHCP information, the path to the log and a placeholder for tags. It looks like this:

		hw_info:
				mac: ["08-00-27-8a-5e-5d"]
			 serial: "0"
			   uuid: "9a717dc3-2392-4853-89b9-27fec1aec7b2"
		dhcp_mac: "08-00-27-8a-5e-5d"
		log:
				log => http://localhost:8150/api/collections/node/node2/log
		tags: []

6. Once the microkernel is running on the machine, it will run Facter and send the facts back to the server. Type `razor nodes <node name>` again, to see the facts associated with the node. This includes standard information about the machine, like network cards, IP address, and block devices.

	Now the machine will just sit there and periodically send its facts back to the server. Since you haven't yet set up provisioning objects, the server doesn't yet do anything with the node.

## Create a Tag

1. Create a JSON file for your tag and save it at this location: http://localhost:8150/api/collections/tags/small. Give the tag a name and a rule. For this example, the JSON file is called `tag.json`. The tag is called `small` and the rule says that any machine that has less than one gigabyte of memory should be tagged with this tag.


		{
			"name": "small",
			"rule": ["<", ["num", ["fact", "memorysize_mb"]],
						  1024]
		}

	You can see your tag by running `cat <JSON file name>`. For example, `cat tag.json`.

2. To send the tag to the server, run `razor create-tag --json <JSON file name>`. For example, `razor create-tag --json tag.json`.

	The output looks like this, indicating that the tag has been created:

		From http://localhost:8150/api/collections/tags/small

			id: "http://localhost:8150/api/collections/tags/small"
		  name: "small"
		  spec: "/razor/v1/collections/tags/member"


3. To inspect the tag on the server, run `razor tags <tag name`. For example, `razor tags small`.

	The output contains information like the name of the tag and the rule. But also that one node has already been tagged with the tag. This is the node you registered in the previous section. There's also policy information for the tag. Currently, no policies use this tag.
4. To see the nodes associated with the tag, run `razor tags <tag name> nodes`. For example, `razor tags small nodes`. The result displays the ID, name, and spec for the node registered previously.

## Create a Repository

The repo can be an image on your local machine, or you can download and unpack and ISO, or you can point to an existing resource using its URL.

* Run `razor create-repo --<name of repo> --<type and location of image>. For example:
		razor create-repo --name centos-6.4 --iso-url file:///vagrant/installers/CentOS-6.4-x86_64-bin-DVD1.iso`
	This command creates a repo for an ISO image for CentOS 6.4. It takes a few minutes for the ISO import to complete.

## Create a broker

The broker hands an installed node off to the PE master. PE comes with a few brokers. The settings for configuration depend on the broker type, and are declared in the broker type's configuration.yaml.

1. Run `razor create-broker --name <Puppet master name> --broker-type <broker type> --configuration '{"<configuration info>"}'`. For example:
`razor create-broker --name pe --broker-type puppet-pe --configuration '{"server": "puppet-master"}'`

	This example uses the `puppet-pe` broker type.

## Create a Policy

The policy is what ties all the Razor objects together and provisions a node that matches the policy. In this exercise, your policy contains a task called `centos` that comes with Razor.

1. Create a JSON file for you policy to make it more manageable. The following example creates a policy called `centos6`. It uses the repo that you just set up, and the `pe` broker that you created previously. It uses a stock Razor task `centos`. The `enabled` field is set to true, because you want to use this policy. The `max_count` limits the number of nodes that can match with the policy, and `tags` identifies any tags associated with the policy.

		{
		"name": "centos6",
		"repo": {"name": "centos-6.4"},
		"task": {"name": "centos"},
		"broker": {"name": "pe"},
		"enabled": true,
		"hostname": "centos${id}.example.com",
		"root_password": "secret",
		"max_count": "1",
		"tags": [{"name":"small"}]
		}

2. Create the policy. Run `razor create-policy --json <name of JSON policy file>`. For example, `Razor create-policy --json policy.json`.

	>**Note**: When you create the policy, you are essentially setting the policy free on your server to locate and match with nodes.

	When you create the policy, your node, in this example, `node2`, matches. It reboots and begins applying the policy, which in this case is installing CentOS 6.4.

3. Check the node details. Run `razor nodes <node name>`. For example, `razor nodes node2`. The node details now show that there's a policy attached to the node, the `centos6` policy.

4. Check the node's log. Run `razor nodes <node name> log`. For example, `razor nodes node2 log`. Each node has a log attached that keeps track of when the node rebooted, and the important events during the installation of an operating system. This node's log shows when it initially booted into the microkernel, when it bound to the policy, and then rebooted into the policy. You can also see things like any kickstart files or post-install scripts that are run during the install.

5. When the installation finishes and the node reboots, you can log into it using the password you created during Razor setup. You can also see the node and its details on the PE console. Now, you can manage the node with PE just as you would any other node.


* * *


- [Next: Razor Command Reference](./razor_reference.html)


