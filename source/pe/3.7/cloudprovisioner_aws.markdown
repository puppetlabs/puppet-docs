---
layout: default
title: "PE 3.7 » Cloud Provisioning » AWS Provisioning"
subtitle: "Provisioning With Amazon Web Services"
canonical: "/pe/latest/cloudprovisioner_aws.html"
---

Puppet Enterprise provides support for working with Elastic Compute Cloud (EC2) virtual machine instances using Amazon Web Services. Using the `puppet node_aws` sub-command, you can create new machines, view information about existing machines, classify and configure machines, and tear machines down when they're no longer needed.

The main actions used for AWS cloud provisioning include:

*  `puppet node_aws list` for viewing existing instances
*  `puppet node_aws create` for creating new instances
*  `puppet node_aws terminate` for destroying no longer needed instances

If you are new to Amazon Web Services, we recommend reading their [Getting Started
documentation](http://docs.amazonwebservices.com/AWSEC2/latest/GettingStartedGuide/).

Below, we take a quick look at these actions and their associated options. For comprehensive information, see [Getting More Help](#getting-more-help) below.

Viewing Existing EC2 Instances
-----

Let's start by finding out about the currently running EC2 instances.  You do this by running the `puppet node_aws list` command.

    $ puppet node_aws list
    i-013eb462:
      created_at: Sat Nov 12 02:10:06 UTC 2011
      dns_name: ec2-107-22-110-102.compute-1.amazonaws.com
      id: i-013eb462
      state: running
    i-019f0a62:
      created_at: Sat Nov 12 03:48:50 UTC 2011
      dns_name: ec2-50-16-145-167.compute-1.amazonaws.com
      id: i-019f0a62
      state: running
    i-01a33662:
      created_at: Sat Nov 12 04:32:25 UTC 2011
      dns_name: ec2-107-22-79-148.compute-1.amazonaws.com
      id: i-01a33662
      state: running

This shows three running EC2 instances. For each instance, the following characteristics are shown:

- The instance name
- The date the instance was created
- The DNS host name of the instance
- The ID of the instance
- The state of the instance, for example: running or terminated

**If you have no instances running, nothing will be returned.**

Creating a new EC2 instance
-----

New instances are created using the `node_aws create` or the `node_aws bootstrap` actions. The `create` action simply builds a new EC2 machine instance. The `bootstrap` "wrapper" action creates, classifies, and then initializes the node all in one command.

### Using `create`

The `node_aws create` subcommand is used to build a new EC2 instance based on a selected AMI image.

The subcommand has three required options:

- The AMI image we'd like to use. (`--image`)
- The name of the SSH key pair to start the image with (`--keyname`). [See here](./cloudprovisioner_configuring.html#additional-aws-configuration) for more about creating Amazon-managed key pairs.
- The type of machine instance we wish to create (`--type`). You can see a list of types [here](http://aws.amazon.com/ec2/instance-types/).

Provide this information and run the command:

    $ puppet node_aws create --image ami-edae6384 --keyname cloudprovisioner --type m1.small
    notice: Creating new instance ...
    notice: Creating new instance ... Done
    notice: Creating tags for instance ...
    notice: Creating tags for instance ... Done
    notice: Launching server i-df7ee898 ...
    ##################
    notice: Server i-df7ee898 is now launched
    notice: Server i-df7ee898 public dns name: ec2-50-18-93-82.us-east-1.compute.amazonaws.com
    ec2-50-18-93-82.us-east-1.compute.amazonaws.com

You've created a new instance using an AMI of `ami-edae6384`, a key named
`cloudprovisioner`, and of the machine type `m1.small`. If you've forgotten the
available key names on your account, you can get a list with the `node_aws list_keynames` action:

    $ puppet node_aws list_keynames
    cloudprovisioner (ad:d4:04:9f:b0:8d:e5:4e:4c:46:00:bf:88:4f:b6:c2:a1:b4:af:56)

You can also specify a variety of other options, including the
region in which to start the instance. You can see a full list of these options
by running `puppet help node_aws create`.

After the instance has been created, the public DNS name of the instance will be returned. In this case: `ec2-50-18-93-82.us-east-1.compute.amazonaws.com`.

### Using `bootstrap`

The `bootstrap` action is a wrapper that combines several actions, allowing you to create, classify, install Puppet on, and sign the certificate of EC2 machine instances. Classification is done via the console.

In addition to the three options required by `create` (see above), `bootstrap` also requires the following:

- The name of the user Puppet should be using when logging in to the new node.  (`--login` or `--username`)
-  The path to a local private key that allows SSH access to the node (`--keyfile`). Typically, this is the path to the private key that gets downloaded from the Amazon EC2 site.

The example below will bootstrap a node using the ami--0530e66c image, located in the US East region and running as a t1.micro machine type.

    puppet node_aws bootstrap 
    --region us-east-1 
    --image ami-0530e66c 
    --login root --keyfile ~/.ec2/ccaum_rsa.pem 
    --keyname ccaum_rsa  
    --type t1.micro


Connecting to an EC2 instance
-----

You connect to EC2 instances via SSH. To do
this you will need the private key downloaded earlier from the Amazon Web Services
console. Add this key to your local SSH configuration, usually in the `.ssh`
directory.

    $ cp mykey.pem ~/.ssh/mykey.pem

Ensure the `.ssh` directory and the key have appropriate permissions.

    $ chmod 0700 ~/.ssh
    $ chmod 0600 ~/.ssh/mykey.pem

You can now use this key to connect to our new instance.

    $ ssh -i ~/.ssh/mykey.pem root@ec2-50-18-93-82.us-east-1.compute.amazonaws.com

Terminating an EC2 instance
-----

Once you've finished with an EC2 instance, you can easily terminate it.
Terminating an instance destroys the instance entirely and is a destructive, permanent
action that should only be performed when you are confident the instance, and its data, are no longer needed.
 
To terminate an instance, use the `node_aws terminate` action.

    $ puppet node_aws terminate ec2-50-18-93-82.us-east-1.compute.amazonaws.com
    notice: Destroying i-df7ee898 (ec2-50-18-93-82.us-east-1.compute.amazonaws.com) ...
    notice: Destroying i-df7ee898 (ec2-50-18-93-82.us-east-1.compute.amazonaws.com) ... Done


Demos
-------

The following demos show how to install a Puppet master and a Puppet agent in EC2, as well as how to deploy a web app with Puppet Enterprise.

* [AWS EC2 Part 1](https://www.youtube.com/watch?v=Drl35Bpc6OE): Spin up a virtual machine and install Puppet Enterprise.
* [AWS EC2 Part 2](https://www.youtube.com/watch?v=_Cq-dzR3-v4): Spin up a new node in EC2 and then install a Puppet agent.
* [AWS EC2 Part 3](https://www.youtube.com/watch?v=ujWAKU1vYn4): Use a module from the forge to deploy a web app to an EC2 node.

Getting more help
-----

The `puppet node_aws` command has extensive in-line help documentation, as well as a man page.

To see the available actions and command line options, run:

    $ puppet help node_aws
    USAGE: puppet node_aws <action>

    This subcommand provides a command line interface to work with Amazon EC2
    machine instances.  The goal of these actions are to easily create new
    machines, install Puppet onto them, and tear them down when they're no longer
    required.

    OPTIONS:
      --render-as FORMAT             - The rendering format to use.
     --verbose                      - Whether to log verbosely.
     --debug                        - Whether to log debug information.

    ACTIONS:
     bootstrap        Create and initialize an EC2 instance using Puppet.
     create           Create a new EC2 machine instance.
     fingerprint      Make a best effort to securely obtain the SSH host key fingerprint.
     list             List AWS EC2 machine instances.
     list_keynames    List available AWS EC2 key names.
     terminate        Terminate an EC2 machine instance.

    See 'puppet man node_aws' or 'man puppet-node_aws' for full help.

For more detailed help you can also view the man page .

    $ puppet man node_aws

You can get help on individual actions by running:

    $ puppet help node_aws <ACTION>

For example,

    $ puppet help node_aws list



* * * 

- [Next: Classifying Cloud Nodes and Remotely Installing Puppet](./cloudprovisioner_classifying_installing.html)

