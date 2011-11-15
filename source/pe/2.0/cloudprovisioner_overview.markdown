---
layout: pe2experimental
title: "PE 2.0 » Cloud Provisioning"
---

Getting Started With Puppet Enterprise Cloud Provisioning
=====================================

Puppet Enterprise provides you with the capability to provision,
configure and manage VMware virtual machines and Amazon Web Services
EC2 instances.  It allows you to create and bootstrap virtual machines,
classify those machines in your Puppet Enterprise environment,
install Puppet Enterprise on them and automatically add them to your
console.

* * *

Overview
--------

Puppet Enterprise cloud provisioning extends Puppet by adding new actions for
creating and puppetizing new machines using VMware vSphere and Amazon
Web Service's EC2.

It provides you with an easy command line interface to:

* Create a new VMware virtual machine or Amazon EC2 instance
* Classify the new virtual machine or instance in the Puppet Enterprise
  console
* Automatically install Puppet Enterprise and integrate with your
  existing Puppet infrastructure.

This provides you with a quick and efficient workflow for adding nodes
to your Puppet Enterprise environment.

Prerequisites
-------------

Cloud provisioning ships with Puppet Enterprise 2.0 and later.

### Services

The following services and credentials are required:

For VMware you will need:

- VMware vSphere 4.0 and later
- VMware vCenter

For Amazon Web Services you will need:

- An existing Amazon account with support for EC2

Installing
----------

Cloud provisioning can be installed on any Puppet master or node.
You will be prompted during the Puppet Enterprise installation to
install cloud provisioning. Answer 'yes' to ensure it is installed.

If you're using an answer file to install Puppet Enterprise this
capability can be installed by setting the `q_puppet_cloud_install` option to `y`.

    q_puppet_cloud_install=y

You can then provision from the command line of any configured
Puppet Enterprise Master or agent.

Configuration
-------------

To use cloud provisioning, we need to do some initial configuration to tell it
about the services we wish to connect to and manage. 

### VMware

To connect to a VMware vSphere server you will need the following information:

- The name of your vCenter host, for example `vc1.example.com`
- Your vCenter username
- Your vCenter password
- A public key hash (we'll get this when we first connect to the vCenter below)

<object width="560" height="315"><param name="movie"
value="http://www.youtube.com/v/06Er_8dHbOM?version=3&amp;hl=en_US"></param><param
name="allowFullScreen" value="true"></param><param
name="allowscriptaccess" value="always"></param><embed
src="http://www.youtube.com/v/06Er_8dHbOM?version=3&amp;hl=en_US"
type="application/x-shockwave-flash" width="560" height="315"
allowscriptaccess="always" allowfullscreen="true"></embed></object>

### Amazon Web Services

To connect to Amazon Web Services you will need the following information:

- AWS Access Key ID
- AWS Secret Key ID
- AWS SSH key pair
- A properly configured security group. Security groups control access to the Amazon instances you create.

#### Amazon Web Service credentials

You can get find your Amazon Web Services credentials online in your Amazon account.

To view your credentials, go to [Amazon AWS](http://aws.amazon.com) and click on the Account tab.

![AWS Account tab](./images/cloud/awsaccount.png)

Select the Security Credentials menu and from there the "Access Credentials"
section of the page, click on the "Access Keys" tab to view your Access Keys.

You need to record two pieces of information:

- Access Key ID
- Secret Key ID

To see your Secret Access Key, just click on the "Show" link under "Secret
Access Key".

<object width="560" height="315"><param name="movie"
value="http://www.youtube.com/v/pc-LFM2-nwQ?version=3&amp;hl=en_US"></param><param
name="allowFullScreen" value="true"></param><param
name="allowscriptaccess" value="always"></param><embed
src="http://www.youtube.com/v/pc-LFM2-nwQ?version=3&amp;hl=en_US"
type="application/x-shockwave-flash" width="560" height="315"
allowscriptaccess="always" allowfullscreen="true"></embed></object>

#### Amazon Web Service keys

Your Amazon Web Services EC2 account will need to have at least one Amazon-managed SSH
keypair, and a security group that allows outbound traffic on port 8140 and SSH (port 22)
traffic from the machine that is provisioning your cloud instances.

To find or create your Amazon key-pair browse to the [Amazon Web Service
EC2 console](https://console.aws.amazon.com/ec2/).

![AWS EC2 Console](./images/cloud/ec2console.png)

Select the Key Pairs menu item from the dashboard. If you don't have any
existing key pairs you can create one with the `Create Key Pairs` button.
Specify a new name for the key pair and it will be created and the private key
file automatically downloaded to your host.  Make a note of the name of your
key pair because we're going to use that later when creating new instances.

To add or edit a security group select the Security Groups menu item
from the dashboard. You should see a list of the available security
groups.  If no groups exist you can create a new one by clicking the
`Create Security Groups` button or you can edit an existing group.

![AWS Security Groups](./images/cloud/awssecgroup.png)

To add the required rules select the `Inbound` tab and add an SSH rule.
You can also specify a specific `Source` to lock the source IP down to
an appropriate source IP or network.  Click `Add Rule` to add the rule
and then `Apply Rule Changes` to save.

### Adding your credentials

Our provisioning capability takes advantage of a cloud abstraction tool called Fog.  We
provide Fog as part of your Puppet Enterprise install, and all you need to do is configure it.

Firstly, create a file called `.fog` in your home directory, for example:

    $ touch ~/.fog

Populate this file with the credentials we've just recorded for VMware vSphere or Amazon Web
Services (or both).  Your `.fog` file should look something like this:

    :default:
      :vsphere_server: vc01.example.com
      :vsphere_username: cloudprovisioner
      :vsphere_password: abc123
      :aws_access_key_id: AKIAIISJV5TZ3FPWU3TA
      :aws_secret_access_key: ABCDEFGHIJKLMNOP1234556/s

Replace `:vsphere_server` with the host name or IP address of your
vSphere server and populate the other options with the appropriate
credentials.

Provisioning with VMware
-----------------------------------

Puppet Enteprise can help with creating and managing VMware virtual machines on your
vSphere server using vCenter.

If you're new to VMware vSphere then we recommend looking at the [vSphere
documentation](http://www.vmware.com/support/pubs/vs_pages/vsp_pubs_esx40_vc40.html).

### Listing VMware vSphere instances

Let's get started by listing the machines currently on our vSphere
server.  We do this by running the `puppet node_vmware list` command.

    $ puppet node_vmware list

The first time we run this command, we be asked to
confirm we're communicating with a trusted vSphere server:

    $ puppet node_vmware list
    notice: Connecting ...·
    err: The remote system presented a public key with hash
    431dd5d0412aab11b14178290d9fcc5acb041d37f90f36f888de0cebfffff0a8 but
    we're expecting a hash of <unset>.  If you are sure the remote system is
    authentic set vsphere_expected_pubkey_hash: <the hash printed in this
    message> in ~/.fog
    err: Try 'puppet help node_vmware list' for usage

Confirm you've specified the right vSphere host in your `.fog`
configuration file and then add the following option with the public key
hash that is returned to your `.fog` file:

    :vsphere_expected_pubkey_hash:431dd5d0412aab11b14178290d9fcc5acb041d37f90f36f888de0cebfffff0a8

Now we can run the `puppet node_vmware list` command and see a list of
our existing virtual machines:

    $ puppet node_vmware list
    notice: Connecting ...
    notice: Connected to vc01.example.com as cloudprovisioner (API version 4.1)
    notice: Finding all Virtual Machines ... (Started at 12:16:01 PM)
    notice: Control will be returned to you in 10 minutes at 12:26 PM if locating is unfinished.
    Locating:          100% |ooooooooooooooooooooooooooooooooooooooooooooooooooo| Time: 00:00:34
    notice: Complete
    /Datacenters/Solutions/vm/master_template
    powerstate: poweredOff
    name:       master_template
    hostname:   puppetmaster.example.com
    instanceid: 5032415e-f460-596b-c55d-6ca1d2799311
    ipaddress:  ---.---.---.---
    template:   true

    /Datacenters/Solutions2/vm/puppetagent
    powerstate: poweredOn
    name:       puppetagent
    hostname:   agent.example.com
    instanceid: 5032da5d-68fd-a550-803b-aa6f52fbf854
    ipaddress:  192.168.100.218
    template:   false

We can see that we've connected to our vSphere server and returned a VMware
template and a virtual machine. VMware templates contain the information needed
to build new virtual machines, for example the operating system, hardware
configuration and other details needed to provision a machine. A virtual
machine is an existing machine that has already been provisioned on the vSphere
server.

The following information is returned:

- The location of the template or machine
- The status of the machine, for example poweredOff or poweredOn
- The name of the template or machine on the vSphere server
- The host name of the machine
- The instanceid of the machine
- The IP address of the machine (templates don't have IP addresses)
- The type of entry - either a VMware template or a virtual machine

### Creating a new VMware virtual machine

Puppet Enterprise can also create and manage virtual machines from VMware
templates. To do this we can run the `puppet node_vmware` command with the `create` option.

    $ puppet node_vmware create --name=newpuppetmaster --template="/Datacenters/Solutions/vm/master_template"
    notice: Connecting ...
    notice: Connected to vc01.example.com as cloudprovisioner (API version 4.1)
    notice: Locating VM at /Datacenters/Solutions/vm/master_template (Started at 12:38:58 PM)
    notice: Control will be returned to you in 10 minutes at 12:48 PM if locating (1/2) is unfinished.
    Locating (1/2):    100% |ooooooooooooooooooooooooooooooooooooooooooooooooooooooooo| Time: 00:00:16
    notice: Starting the clone process (Started at 12:39:15 PM)
    notice: Control will be returned to you in 10 minutes at 12:49 PM if starting (2/2) is unfinished.
    Starting (2/2):    100% |ooooooooooooooooooooooooooooooooooooooooooooooooooooooooo| Time: 00:00:03
    ---
    name: newpuppetmaster
    power_state: poweredOff
    ...
    status: success

Here we've created a new virtual machine named `newpuppetmaster` with a
template of `/Datacenters/Solutions/vm/master_template` (we saw this template
earlier when we listed all the resources available on our vSphere server).  The
virtual machine is now created and will be powered on. Powering on may take
several minutes to complete.

<object width="420" height="315"><param name="movie"
value="http://www.youtube.com/v/dIVOS53ZPFc?version=3&amp;hl=en_US"></param><param
name="allowFullScreen" value="true"></param><param
name="allowscriptaccess" value="always"></param><embed
src="http://www.youtube.com/v/dIVOS53ZPFc?version=3&amp;hl=en_US"
type="application/x-shockwave-flash" width="420" height="315"
allowscriptaccess="always" allowfullscreen="true"></embed></object>

### Starting, stopping and terminating VMware virtual machines

We've created our virtual machine and it's started. We can also start and stop
virtual machines using the command `puppet node_vmware start` and `puppet
node_vmware stop` respectively:

The `start` and `stop` commands can be used like so:

    $ puppet node_vmware start /Datacenters/Solutions/vm/newpuppetmaster

You can see we've specified the path to the virtual machine we wish to start,
in this case `/Datacenters/Solutions/vm/newpuppetmaster`.  

We can also stop this virtual machine:

    $ puppet node_vmware stop /Datacenters/Solutions/vm/newpuppetmaster

This will stop the running virtual machine (it may take a few minutes).

Lastly, we can terminate a VMware instance.  Be aware this will:

- Force-shutdown the virtual machine
- Delete the virtual machine AND it's hard disk images

**This is a destructive action that should only be taken when you wish to delete
the virtual machine!**

<object width="560" height="315"><param name="movie"
value="http://www.youtube.com/v/-o0h83LYSA0?version=3&amp;hl=en_US"></param><param
name="allowFullScreen" value="true"></param><param
name="allowscriptaccess" value="always"></param><embed
src="http://www.youtube.com/v/-o0h83LYSA0?version=3&amp;hl=en_US"
type="application/x-shockwave-flash" width="560" height="315"
allowscriptaccess="always" allowfullscreen="true"></embed></object>

### Getting more help

The `puppet node_vmware` command has extensive in-line help documentation and a man page.

To see the available command line options run:

    $ puppet help node_vmware
    USAGE: puppet node_vmware <action> 

    This subcommand provides a command line interface to work with VMware vSphere
    Virtual Machine instances.  The goal of these actions is to easily create
    new virtual machines, install Puppet onto them, and clean up when they're
    no longer required.

    OPTIONS:
    --mode MODE                    - The run mode to use (user, agent, or master).
    --render-as FORMAT             - The rendering format to use.
    --verbose                      - Whether to log verbosely.
    --debug                        - Whether to log debug information.

    ACTIONS:
    create       Create a new VM from a template
    find         Find a VMware Virtual Machine
    list         List VMware Virtual Machines
    start        Start a Virtual Machine
    stop         Stop a running Virtual Machine
    terminate    Terminate (destroy) a VM

    See 'puppet man node_vmware' or 'man puppet-node_vmware' for full help.

You can also view the man page for more detailed help.

    $ puppet man node_vmware

You can get help on individual commands by running:

    $ puppet help node_vmware commandname

For example:

    $ puppet help node_vmware start

Provisioning with Amazon Web Services
------------------------------------------------

Puppet Enterprise can also work with Amazon Web Services to create and manage new EC2 instances. 

If you are new to Amazon Web Services we recommend reading the [Getting Started
documentation](http://docs.amazonwebservices.com/AWSEC2/latest/GettingStartedGuide/).

### Listing Amazon EC2 instances

Let's start by listing our running EC2 instances.  Do do this we're going to
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

Classifying nodes
-----------------

Once you have created virtual machines or instances you can add them to
a group in the Puppet Enterprise console using the same command line
tools. In Puppet Enterprise this is called node classification.

To classify nodes and add them to your console groups we use the `puppet
node classify` command.

    $ puppet node classify \
    --node-group=default \
    --enc-server=localhost \
    --enc-port=443 \
    --enc-ssl \
    --enc-auth-user=console \
    --enc-auth-passwd=password \
    ec2-50-19-149-87.compute-1.amazonaws.com

    notice: Contacting https://localhost:443/ to classify
    ec2-50-19-149-87.compute-1.amazonaws.com
    complete

Here we're adding an AWS EC2 instance to the Puppet Enterprise console.
We specify the `--node-group` we'd like to add the node to, in our case
the `default` group.

We also specify the user name, password, server, port and whether to use
SSL to connect. The user name and password we've specified is set when
the Puppet Enterprise console is installed and if you don't know them can
be found in the `/etc/puppetlabs/installer/answers.install` file
generated during installation.

Lastly, we've specified the name of the host we're classifying. If we
now navigate to the console we can see this host is added to the
`default` group.

To see additional help for node classification you can use the `puppet
help node classify` command.

<object width="420" height="315"><param name="movie"
value="http://www.youtube.com/v/LG6WQPVsBNg?version=3&amp;hl=en_US"></param><param
name="allowFullScreen" value="true"></param><param name="allowscriptaccess"
value="always"></param><embed
src="http://www.youtube.com/v/LG6WQPVsBNg?version=3&amp;hl=en_US"
type="application/x-shockwave-flash" width="420" height="315"
allowscriptaccess="always" allowfullscreen="true"></embed></object>

Installing Puppet
-----------------

In addition to the other actions we've shown you we can also install Puppet
Enterprise (or Puppet) onto these new nodes. To do this we use the `puppet node
install` command.

    $ puppet node install --keyfile=~/.ssh/mykey.pem --login=root ec2-50-19-207-181.compute-1.amazonaws.com 
    notice: Waiting for SSH response ...
    notice: Waiting for SSH response ... Done
    notice: Installing Puppet ...
    puppetagent_certname: ec2-50-19-207-181.compute-1.amazonaws.com-ee049648-3647-0f93-782b-9f30e387f644
    status: success

The `puppet node install` command uses SSH to connect to the host and install
Puppet Enterprise. By default it needs an SSH key, here specified using the
`--keyfile` option. For VMware this key should be loaded onto the template you
used to create your virtual machine. For Amazon EC2 it should be the key file
you used to create the instance. You also need to specify the account to login
as using the `--login` option. Lastly, we need to specify the specific host you
wish to install Puppet Enterprise on. 

For the default installation Puppet Enterprise uses packages
provided by Puppet Labs and stored in Amazon S3 storage.  You can also specify
packages located on your local host or on a share in your local network.

In addition to these default configuration options we can specify a number of
additional options to control how and what we install on the host. We can
specify the specific version of Puppet Enterprise (or we can install open
source Puppet too) to install. We can also control the version of Facter to
install, the specific answers file to use to configure Puppet Enterprise, the
certificate name of the agent to be install and a variety of other options. To
see a full list of the available options use the `puppet help node install`
command.

<object width="420" height="315"><param name="movie"
value="http://www.youtube.com/v/F0hU94bBrQo?version=3&amp;hl=en_US"></param><param
name="allowFullScreen" value="true"></param><param name="allowscriptaccess"
value="always"></param><embed
src="http://www.youtube.com/v/F0hU94bBrQo?version=3&amp;hl=en_US"
type="application/x-shockwave-flash" width="420" height="315"
allowscriptaccess="always" allowfullscreen="true"></embed></object>

Classifying and Installing Puppet in one command
------------------------------------------------

Rather than using multiple commands to classify and install Puppet on a
node we can run the `init` command which performs both actions in a
single command. Let's look at an example of that:

    $ puppet node init \
    --node-group=default \
    --enc-server=localhost \
    --enc-port=443 \
    --enc-ssl \
    --enc-auth-user=console \
    --enc-auth-passwd=password \
    --keyfile=~/.ssh/mykey.pem \
    --login=root \
    ec2-50-19-207-181.compute-1.amazonaws.com

Here we've combined the options for the `puppet node classify` and
`puppet node install` commands. This will connect to the Puppet
Enterprise console, classify the node in the `default` group and then
install Puppet Enterprise on this node.

Troubleshooting
---------------

### Missing .fog file or credentials

If you attempt to provision without creating a `.fog` file or without
populating the file with appropriate credentials:

For VMware you'll see the following error:

    $ puppet node_vmware list
    notice: Connecting ...
    err: Missing required arguments: vsphere_username, vsphere_password, vsphere_server
    err: Try 'puppet help node_vmware list' for usage

For Amazon Web Services you'll see the following error:

    $ puppet node_aws list
    err: Missing required arguments: aws_access_key_id,
    aws_secret_access_key
    err: Try 'puppet help node_aws list' for usage

Add the appropriate file or missing credentials to the file to resolve
this issue.

