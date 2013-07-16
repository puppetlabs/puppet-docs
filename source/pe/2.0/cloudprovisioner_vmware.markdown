---
layout: default
title: "PE 2.0 » Cloud Provisioning » VMware Provisioning"
canonical: "/pe/latest/cloudprovisioner_vmware.html"
---

* * *

&larr; [Cloud Provisioning: Configuring and Troubleshooting](./cloudprovisioner_configuring.html) --- [Index](./) --- [Cloud Provisioning: Provisioning with AWS](./cloudprovisioner_aws.html) &rarr;

* * *

Provisioning With VMware
=====

Puppet Enterprise can create and manage VMware virtual machines on your
vSphere server using vCenter.

If you're new to VMware vSphere then we recommend looking at the [vSphere
documentation](http://www.vmware.com/support/pubs/vs_pages/vsp_pubs_esx40_vc40.html).

Listing VMware vSphere Instances
-----

Let's get started by listing the machines currently on our vSphere
server.  We do this by running the `puppet node_vmware list` command.

    $ puppet node_vmware list

If you haven't yet [confirmed your vSphere server's public key hash in your `~/.fog` file](./cloudprovisioner_configuring.html#adding-vmware-credentials), you'll receive an error message containing said hash: 

    $ puppet node_vmware list
    notice: Connecting ...·
    err: The remote system presented a public key with hash
    431dd5d0412aab11b14178290d9fcc5acb041d37f90f36f888de0cebfffff0a8 but
    we're expecting a hash of <unset>.  If you are sure the remote system is
    authentic set vsphere_expected_pubkey_hash: <the hash printed in this
    message> in ~/.fog
    err: Try 'puppet help node_vmware list' for usage

Confirm that you are communicating with a trusted vSphere server by checking the hostname in your `~/.fog`
file, then add the hash to your `.fog` file as follows:

    :vsphere_expected_pubkey_hash: 431dd5d0412aab11b14178290d9fcc5acb041d37f90f36f888de0cebfffff0a8

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
to build new virtual machines, such as the operating system, hardware
configuration, and other details. A virtual
machine is an existing machine that has already been provisioned on the vSphere
server.

The following information is returned:

- The location of the template or machine
- The status of the machine (for example, poweredOff or poweredOn)
- The name of the template or machine on the vSphere server
- The host name of the machine
- The instanceid of the machine
- The IP address of the machine (note that templates don't have IP addresses)
- The type of entry - either a VMware template or a virtual machine

Creating a New VMware Virtual Machine
-----

Puppet Enterprise can create and manage virtual machines from VMware
templates. This is done with the `node_vmware create` action.

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
template of `/Datacenters/Solutions/vm/master_template`. (We saw this template
earlier when we listed all the resources available on our vSphere server.)  The
virtual machine is now created and will be powered on. Powering on may take
several minutes to complete.

<object width="420" height="315"><param name="movie"
value="http://www.youtube.com/v/dIVOS53ZPFc?version=3&amp;hl=en_US"></param><param
name="allowFullScreen" value="true"></param><param
name="allowscriptaccess" value="always"></param><embed
src="http://www.youtube.com/v/dIVOS53ZPFc?version=3&amp;hl=en_US"
type="application/x-shockwave-flash" width="420" height="315"
allowscriptaccess="always" allowfullscreen="true"></embed></object>

Starting, Stopping and Terminating VMware Virtual Machines
-----

You can start, stop, and terminate virtual machines with the `start`, `stop`, and `terminate` actions.

To start a virtual machine:

    $ puppet node_vmware start /Datacenters/Solutions/vm/newpuppetmaster

You can see we've specified the path to the virtual machine we wish to start;
in this case `/Datacenters/Solutions/vm/newpuppetmaster`.  

To stop a virtual machine:

    $ puppet node_vmware stop /Datacenters/Solutions/vm/newpuppetmaster

This will stop the running virtual machine (it may take a few minutes).

Lastly, we can terminate a VMware instance.  Be aware this will:

- Force-shutdown the virtual machine
- Delete the virtual machine AND its hard disk images

**This is a destructive action that should only be taken when you wish to delete
the virtual machine!**

<object width="560" height="315"><param name="movie"
value="http://www.youtube.com/v/-o0h83LYSA0?version=3&amp;hl=en_US"></param><param
name="allowFullScreen" value="true"></param><param
name="allowscriptaccess" value="always"></param><embed
src="http://www.youtube.com/v/-o0h83LYSA0?version=3&amp;hl=en_US"
type="application/x-shockwave-flash" width="560" height="315"
allowscriptaccess="always" allowfullscreen="true"></embed></object>

Getting more help
-----

The `puppet node_vmware` command has extensive in-line help documentation and a man page.

To see the available actions and command line options, run:

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

You can get help on individual actions by running:

    $ puppet help node_vmware <ACTION>

For example:

    $ puppet help node_vmware start

* * *

&larr; [Cloud Provisioning: Configuring and Troubleshooting](./cloudprovisioner_configuring.html) --- [Index](./) --- [Cloud Provisioning: Provisioning with AWS](./cloudprovisioner_aws.html) &rarr;

* * *

