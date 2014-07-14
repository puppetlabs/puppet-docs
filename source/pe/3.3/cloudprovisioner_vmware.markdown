---
layout: default
title: "PE 3.3 » Cloud Provisioning » VMware Provisioning"
subtitle: "Provisioning With VMware"
canonical: "/pe/latest/cloudprovisioner_vmware.html"
---

Puppet Enterprise provides support for working with VMware virtual machine instances using vSphere and vCenter. Using actions of the `puppet node_vmware` sub-command, you can create new machines, view information about existing machines, classify and configure machines, and tear machines down when they're no longer needed.

The main actions used for vSphere cloud provisioning include:

*  `puppet node_vmware list` for viewing existing instances
*  `puppet node_vmware create` for creating new instances
*  `puppet node_vmware terminate` for destroying no longer needed instances.


**Note:** The command `puppet node_vmware` assumes that data centers are located at the very top level of the inventory hierarchy. Any data centers deeper down in the hierarchy (and in effect all objects hosted by these data centers) are ignored by the command.

Here's a fix:

1. Move the data centers hosting the involved VMs/templates to the top level of the inventory hierarchy. This can be a temporary move.
2. Perform the desired `node_vmware` actions. Both `puppet node_vmware` and `puppet node_vmware create` should see the VMs/templates hosted on the moved data centers.
3. Move the data centers back, if desired.

If you're new to VMware vSphere, you should start by looking at the [vSphere
documentation](http://pubs.vmware.com/vsphere-50/index.jsp).

Permissions Required for Provisioning with VMWare 
-----

The following are the permissions needed to provision with VMWare, listed according to subcommand. In addition, you should have full admin access to your vSphere pool. 


+ `list` – Lists any VM with read-only permissions or better.
+ `find` – Requires read-only permissions or better on the target data center, data store, network, or computer, as well as the full VM folder path that contains the VM in question.
+ `start` – Requires `find` permissions + `VirtualMachine.Interact.PowerOn` on the VM in question.
+ `stop` – Requires `find` permissions + `VirtualMachine.Interact.PowerOff` on the VM in question.
+ `terminate` – Requires `find` permissions + `VirtualMachine.Inventory.Remove` on the VM in question and its parent folder.
+ `create` – Requires `find` permissions + `VirtualMachine.Inventory.CreateFromExisting`, `VirtualMachine.Provisioning.DeployTemplate`, `VirtualMachine.Inventory.CreateFromExisting` on the template in question, as well as `Datastore.AllocateSpace` on the target data store, and `Resource.AssignVMToPool` on the target resource pool (the target cluster in non-DRS enabled vCenters).


Listing VMware vSphere Instances
-----

Let's get started by listing the machines currently on our vSphere
server.  You do this by running the `puppet node_vmware list` command:

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

Confirm that you are communicating with the correct, trusted vSphere server by checking the hostname in your `~/.fog` file, then add the hash to the `.fog` file as follows:

    :vsphere_expected_pubkey_hash: 431dd5d0412aab11b14178290d9fcc5acb041d37f90f36f888de0cebfffff0a8

Now you should be able to run the `puppet node_vmware list` command and see a list of existing virtual machines:

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

This shows that you're connected to your vSphere server, and lists an available VMware template ( at `master_template`) and one virtual machine (agent.example.com). VMware templates contain the information needed to build new virtual machines, such as the operating system, hardware configuration, and other details.


Specifically, `list` will return all of the following information:

- The location of the template or machine
- The status of the machine (for example, `poweredOff` or `poweredOn`)
- The name of the template or machine on the vSphere server
- The host name of the machine
- The `instanceid` of the machine
- The IP address of the machine (note that templates don't have IP addresses)
- The type of entry - either a VMware template or a virtual machine

Creating a New VMware Virtual Machine
-----

Puppet Enterprise can create and manage virtual machines from VMware templates using the `node_vmware create` action.

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

Here `node_vmware create` has built a new virtual machine named `newpuppetmaster` with a
template of `/Datacenters/Solutions/vm/master_template`. (This is the template seen earlier with the `list` action.)  The
virtual machine will be powered on, which may take several minutes to complete.

**Important:** All ENC connections to cloud nodes now require SSL support.

The following video demonstrates the above and some other basic functions:

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

You can see we've specified the path to the virtual machine we wish to start,
in this case `/Datacenters/Solutions/vm/newpuppetmaster`.  

To stop a virtual machine, use:

    $ puppet node_vmware stop /Datacenters/Solutions/vm/newpuppetmaster

This will stop the running virtual machine (which may take a few minutes).

Lastly, we can terminate a VMware instance.  Be aware this will:

- Force-shutdown the virtual machine
- Delete the virtual machine AND its hard disk images

**This is a destructive and permanent action that should only be taken when you wish to delete
the virtual machine and its data!**

The following video demonstrates the termination process and some other related functions:

<object width="560" height="315"><param name="movie"
value="http://www.youtube.com/v/-o0h83LYSA0?version=3&amp;hl=en_US"></param><param
name="allowFullScreen" value="true"></param><param
name="allowscriptaccess" value="always"></param><embed
src="http://www.youtube.com/v/-o0h83LYSA0?version=3&amp;hl=en_US"
type="application/x-shockwave-flash" width="560" height="315"
allowscriptaccess="always" allowfullscreen="true"></embed></object>

Getting more help
-----

The `puppet node_vmware` command has extensive in-line help and a man page.

To see the available actions and command line options, run:

    $ puppet help node_vmware
    USAGE: puppet node_vmware <action> 

    This subcommand provides a command line interface to work with VMware vSphere
    Virtual Machine instances.  The goal of these actions is to easily create
    new virtual machines, install Puppet onto them, and clean up when they're
    no longer required.

    OPTIONS:
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

You can get help on individual actions by running:

    $ puppet help node_vmware <ACTION>

For example:

    $ puppet help node_vmware start



* * * 

- [Next: Provisioning with GCE](./cloudprovisioner_gce.html) 
