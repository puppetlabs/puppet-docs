---
layout: default
title: " PE 3.8 » Razor » Provision Nodes"
subtitle: "Basic Guide to Provisioning a Single Node"
canonical: "/pe/latest/razor_using.html"

---

You're ready to provision a node after you've performed the setup described on the pages [Set Up a Razor Environment](./razor_prereqs.html) and [Install Razor](./razor_install.html). This means you have four machines or virtual machines running the following:

* A DHCP/DNS/TFTP service with SELinux configured to enable PXE boot.
* Puppet Enterprise.
* The Razor server and client.
* A node to provision; it should not be booted up when you begin the process.

The following steps walk you through the process of creating [Razor objects](./razor_objects) and provisioning a node with Centos.

### Important Info About the Machines You Provision

To successfully use a machine with Razor and install an operating system on it, the machine must:

* Be supported by the operating system that you're installing.
* Be able to successfully boot into the microkernel, which is based on [CentOS 7](http://wiki.centos.org/Manuals/ReleaseNotes/CentOS7).
* Be able to successfully boot the [iPXE](http://ipxe.org/) firmware.

In addition:

* The Razor microkernel is 64-bit only and only supports the [x86-64 Intel architecture](http://en.wikipedia.org/wiki/X86-64).
* Razor has a minimum RAM requirement of 512MB.

## Step 1: Run the Razor Server and Register a Node

1. Run `razor nodes` to see the collection of machines that Razor is managing.

   The first time you run this command, you should see no nodes.

2. Create a node to see what happens.

   To do this, boot your third machine. Without any further setup on the Razor server, the node boots into the microkernel and Razor discovers the node. You'll see the PXE boot working. After the initial PXE boot, the node downloads the microkernel.

3. Run `razor nodes` again. Now there's a node in the nodes collection. It looks something like this:

		id: "http://localhost:8150/api/collections/node/node2"
		name: "node2"
		spec: "/razor/v1/collections/nodes/member"

4. Look at the node details: `razor nodes <node name>`. In addition to the above information, you'll see hardware and DHCP information, the path to the log, and a placeholder for tags. It looks like this:

		hw_info:
				mac: ["08-00-27-8a-5e-5d"]
			 serial: "0"
			   uuid: "9a717dc3-2392-4853-89b9-27fec1aec7b2"
		dhcp_mac: "08-00-27-8a-5e-5d"
		log:
				log => http://localhost:8150/api/collections/node/node2/log
		tags: []

5. Once the microkernel is running on the machine, it will run Facter and send the facts back to the server. Type `razor nodes <node name>` again, to see the facts associated with the node. This includes standard information about the machine, like network cards, IP address, and block devices.

	Now the machine will just sit there and periodically send its facts back to the server. Since you haven't yet set up provisioning objects, the server doesn't yet do anything with the node.

## Step 2: Create a Tag

1. Create a tag called `small` that matches any machine with less than one gigabyte of memory. Tag rules are currently written as JSON arrays; the following command will do that:

		razor create-tag --name small
          --rule '["<", ["num", ["fact", "memorysize_mb"]], 1024]'

2. Run the command, `razor`. It will print the response from the server in the following way:

		 From http://razor:8151/api/collections/tags/small:
   			name: small
           	rule: ["<", ["num", ["fact", "memorysize_mb"]], 1024]
		   nodes: 0
       	policies: 0
         command: http://razor:8151/api/collections/commands/75

3. To inspect the tag on the server, run `razor tags <tag name>`. For example, `razor tags small` responds with the following:

        From http://razor:8151/api/collections/tags/small:
            name: small
            rule: ["<", ["num", ["fact", "memorysize_mb"]], 1024]
           nodes: 3
        policies: 0

	Query additional details with the command, `razor tags small [nodes, policies, rule]`.

4. To see the nodes associated with the tag, run `razor tags <tag name> nodes`. For example, `razor tags small nodes`. The result displays a table of the nodes matching this tag.

## Step 3: Create a Repository

The repo can be an image on your local machine, or you can download and unpack an ISO, or you can point to an existing resource using its URL. For example, this command downloads a Centos 6.6 ISO and creates a repo from it:

~~~
razor create-repo --name centos-6.6 --task centos
	--iso-url http://centos.sonn.com/6.6/isos/x86_64/CentOS-6.6-x86_64-bin-DVD1.iso

~~~

Each repo must be associated with a task, which serves as the default installer for that repo. A task contains all the scripts needed to perform the installation of an operating system. The repo contains the actual bits that should be installed.

## Step 4: Create a Broker

The broker hands an installed node off to the Puppet master. The details of the handoff are handled by the `puppet-pe` [broker type](./razor_brokertypes.html). A broker uses the scripts of a certain broker type, and adds configuration information, such as the hostname of the Puppet master to it. To hand Razor nodes to your Puppet Enterprise master, create a broker with the following command:

     razor create-broker --name pe --broker-type puppet-pe
         --configuration server=puppet-master.example.com

## Step 5: Create a Policy and Provision Your Node

The policy is what ties all the Razor objects together and provisions a node when it matches the policy. In this exercise, your policy contains a task called `centos` that comes with Razor.

1. Create a policy with the `create-policy` command. You can get more information about the various arguments to this command by running `razor help create-policy`.

     	razor create-policy --name centos-for-small
         --repo centos-6.6 --broker pe --tag small
         --enabled --hostname "host${id}.example.com"
         --root-password secret --max-count 20

 2. Check the details of the policy with `razor policies centos-for-small`
 and look at the table of policies with `razor policies`. The order of the
 policy table is important since Razor goes through the table in order and
 applies the first matching policy to any node. Your table only
 contains one policy so far, so order doesn't really matter yet.

	>**Note**: When you create the policy, you are essentially setting the policy free on your server to locate and match with nodes.

	When you create the policy, your node, in this example, `node2`, matches the policy. The node reboots and begins applying the policy, which in this case installs CentOS 6.6.

3. Check the node details. Run `razor nodes <node name>`. For example, `razor nodes node2`.

   The node details now show that there's a policy attached to the node, the `centos-for-small` policy.

4. Check the node's log. Run `razor nodes <node name> log`. For example, `razor nodes node2 log`.

   Each node has a log attached that keeps track of when the node rebooted and logs the important events during the installation of an operating system. This node's log shows when it initially booted into the microkernel, when it bound to the policy, and when it rebooted into the policy. You can also see things like any kickstart files or post-install scripts that are run during the install.

5. When the installation finishes and the node reboots, you can log into it using the `root_password` of the policy that it has bound to. You can also see the node and its details on the PE console. Now, you can manage the node with PE just as you would any other node.


* * *


- [Next: Writing Broker Types](./razor_brokertypes.html)


