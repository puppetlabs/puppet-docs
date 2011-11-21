---
layout: pe2experimental
title: "PE 2.0 » Cloud Provisioning » AWS Provisioning"
---

Provisioning With Amazon Web Services
=====

Puppet Enterprise can also work with Amazon Web Services to create and manage new EC2 instances. 

If you are new to Amazon Web Services we recommend reading the [Getting Started
documentation](http://docs.amazonwebservices.com/AWSEC2/latest/GettingStartedGuide/).

### Listing Amazon EC2 instances

Let's start by listing our running EC2 instances.  To do this we're going to
use the `puppet node_aws list` command.

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

Here we can see we've got three running EC2 instances and the following information has been returned:

- The instance name
- The date they were created on
- The DNS host name of the instance
- The ID of the instance
- The state of the instance, for example running or terminated

**If you have no instances running then nothing will be returned**

### Creating a new Amazon EC2 instance

Let's next try to create a new instance.  Again we use the `puppet
node_aws` command this time adding the `create` option:

To create a new EC2 instance we need to add three required options:

- The AMI image we wish to start
- The name of the key pair to start the image with (in the section about credentials above we mentioned creating key pairs and making note of their name)
- The type of instance we wish to create. You can see a list of types [here](http://aws.amazon.com/ec2/instance-types/)

Let's provide this information and run the command:

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

We're we've created a new instance using an AMI of `ami-edae6384`, a key named
`cloudprovisioner` and of the type `m1.small`. If you've forgotten the
available key names on your account you can get a list using the `puppet
node_aws list_keynames` command:

    $ puppet node_aws list_keynames
    cloudprovisioner (ad:d4:04:9f:b0:8d:e5:4e:4c:46:00:bf:88:4f:b6:c2:a1:b4:af:56)

You can also specify a variety of other options, including specifying the
region to start the instance in, and you can see a full list of these options
using the `puppet help node_aws create` command.

After the instance has been created, the public DNS name of the instance will be returned: `ec2-50-18-93-82.us-east-1.compute.amazonaws.com`.

<object width="560" height="315"><param name="movie"
value="http://www.youtube.com/v/dAqbLwYzMVk?version=3&amp;hl=en_US"></param><param
name="allowFullScreen" value="true"></param><param name="allowscriptaccess"
value="always"></param><embed
src="http://www.youtube.com/v/dAqbLwYzMVk?version=3&amp;hl=en_US"
type="application/x-shockwave-flash" width="560" height="315"
allowscriptaccess="always" allowfullscreen="true"></embed></object>

### Connecting to an EC2 instance

Once you've created an EC2 instance you can then connect to it using SSH. To do
this we need the private key we downloaded earlier from the Amazon Web Services
console. Add this key to your local SSH configuration, usually in the `.ssh`
directory.

    $ cp mykey.pem ~/.ssh/mykey.pem

Ensure the `.ssh` directory and the key have appropriate permissions.

    $ chmod 0700 ~/.ssh
    $ chmod 0600 ~/.ssh/mykey.pem

We can now use this key to connect to our new instance.

    $ ssh -i ~/.ssh/mykey.pem root@ec2-50-18-93-82.us-east-1.compute.amazonaws.com

### Terminating an EC2 instance

Once you've finished with an EC2 instance you can easily terminate it.
Terminating an instance destroys the instance entirely and is a destructive
action that should only be performed when you've finished with the instance. To
terminate an instance we use the `puppet node_aws terminate` command.

    $ puppet node_aws terminate ec2-50-18-93-82.us-east-1.compute.amazonaws.com
    notice: Destroying i-df7ee898 (ec2-50-18-93-82.us-east-1.compute.amazonaws.com) ...
    notice: Destroying i-df7ee898 (ec2-50-18-93-82.us-east-1.compute.amazonaws.com) ... Done

<object width="560" height="315"><param name="movie"
value="http://www.youtube.com/v/NKisTfXuJlw?version=3&amp;hl=en_US"></param><param
name="allowFullScreen" value="true"></param><param name="allowscriptaccess"
value="always"></param><embed
src="http://www.youtube.com/v/NKisTfXuJlw?version=3&amp;hl=en_US"
type="application/x-shockwave-flash" width="560" height="315"
allowscriptaccess="always" allowfullscreen="true"></embed></object>

### Getting more help

The `puppet node_aws` command has extensive in-line help documentation and a man page.

To see the available command line options run:

    $ puppet help node_aws
    USAGE: puppet node_aws <action>

    This subcommand provides a command line interface to work with Amazon EC2
    machine instances.  The goal of these actions are to easily create new
    machines, install Puppet onto them, and tear them down when they're no longer
    required.

    OPTIONS:
      --mode MODE                    - The run mode to use (user, agent, or master).
      --render-as FORMAT             - The rendering format to use.
      --verbose                      - Whether to log verbosely.
      --debug                        - Whether to log debug information.

    ACTIONS:
      bootstrap        Create and initialize an EC2 instance using Puppet
      create           Create a new EC2 machine instance.
      fingerprint      Make a best effort to securely obtain the SSH host key
                       fingerprint
      list             List AWS EC2 node instances
      list_keynames    List available AWS EC2 key names
      terminate        Terminate an EC2 machine instance

    See 'puppet man node_aws' or 'man puppet-node_aws' for full help.

You can also view the man page for more detailed help.

    $ puppet man node_aws

You can get help on individual commands by running:

    $ puppet help node_aws commandname

For example,

    $ puppet help node_aws list

