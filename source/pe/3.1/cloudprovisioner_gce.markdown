---
layout: default
title: "PE 3.1 » Cloud Provisioning » GCE Provisioning"
subtitle: "Provisioning With Google Compute Engine"
canonical: "/pe/latest/cloudprovisioner_gce.html"
---

Puppet Enterprise provides support for working with Google Compute Engine. Using the `puppet node_gce` sub-command, you can create new machines, view information about existing machines, classify and configure machines, and tear machines down when they're no longer needed.

The main actions used for GCE cloud provisioning include:

*  `puppet node_gce list` for viewing existing instances
*  `puppet node_gce create` for creating new instances
*  `puppet node_gce delete` for destroying no longer needed instances
*  `puppet node_gce bootstrap` for creating a new GCE VM, and then installing PE via SSH
*  `puppet node_gce register` for registering your cloud provisioner GCE client with Google Cloud.
*  `puppet node_gce ssh` to SSH to a GCE VM
*  `puppet node_gce user to manage user login accounts and SSH keys on an instance

If you're new to Google Compute Engine, we recommend reading their [Getting Started
documentation](https://developers.google.com/compute/docs/getting-started-with-compute).

Below, we take a quick look at these actions and their associated options. For comprehensive information, see [Getting More Help](#getting-more-help) below.

Viewing Existing GCE Instances
-----

Let's start by finding out about the currently running GCE instances.  You do this by running the `puppet node_gce list` command and including `project` and the project name as follows.

    $ puppet node_gce list --project cloud-provisioner-testing-1
    #### zone: zones/europe-west1-a
    <no instances in zone>
    
    #### zone: zones/us-central1-a
    name: gce-test-project
    status: running
    metadata: sshKeys: myname:ssh-rsa AABB3NrpC2xAEEEEEIOu...
    type: https://www.googleapis.com/compute/v1beta15/projects/cloud-provisioner-testing-1/zones/us-central1-a/machineTypes/n1-standard-1
    kernal: https://www.googleapis.com/compute/v1beta15/projects/google/global/kernals/gce-v20130813
    image: https://www.googleapis.com/compute/v1beta15/projects/debian-cloud/global/images/debian-7-wheezy-v20130816
    router: false
    networks: nic0: 10.240.229.40
    disks: : scratch read-write
    

The result gives you a list of the instances running in each geographical zone (this example only shows two of the available zones). You can see that there is one registered instance on GCE. The information that's provided for the instance includes the SSH key used to establish the connection, the type of project--n1-standard-1--which was set during registration, and the image that the instance contains. In this case, the image is a Debian Wheezy OS.


**If you have no instances running, each zone that's listed will give the message, "no instances in zones."**

Creating a new GCE instance
-----

New instances are created using the `node_gce create` or the `node_gce bootstrap` actions. The `create` action simply builds a new GCE machine instance. The `bootstrap` "wrapper" action creates, classifies, and then initializes the node all in one command.

### Using `create`

The `node_gce create` subcommand is used to build a new GCE instance based on a selected image.

The subcommand has these required options:

- `--project` to list the project you're working with.
- `--image` The image you're using for the instance, as well as the name for the new instance, and the kind of compute engine you want.

In this example, the project where the instance will be created is "cloud-provisioner-testing-1." The image is a specific version of Debian Wheezy supported by GCE (see the list of available images [here] (https://developers.google.com/compute/docs/images#availableimages)). The instance name is "aaron-test-name" and the compute engine is "n1-standard-1-d."

    $ puppet node_gce create --project cloud-provisioner-testing-1 --image debian-7-wheezy-v20130816 aaron-test-name n1-standard-1-d
    
You'll get the message, "Creating the VM is pending" and when it's complete, you can see the new instance listed in your Google Cloud Console.

<image -- newly created instance here>

### Using `bootstrap`

**NOTE -- this section to be written**


Deleting a GCE instance
-----

Once you've finished with a GCE instance, you can easily delete it.
Deleting an instance destroys the instance entirely and is a destructive, permanent
action that should only be performed when you're confident the instance, and its data, are no longer needed.
 
To delete an instance, use the `node_gce delete` action. Provide both the project and the instance name.

    $ puppet node_gce delete --project cloud-provisioner-testing-1 aaron-test-name
    
After you run this command, wait a few moments, and then you'll get the message, "Deleting the VM is done."
You can confirm that the instance was deleted by checking your Google Cloud Console.



Getting more help
-----

The `puppet node_gce` command has a man page, which you can see with this command:

    $ puppet man node_gce

You can get help on individual actions by running:

    $ puppet help node_gce <ACTION>

For example,

    $ puppet help node_gce list



* * * 

- [Next: Provisioning with AWS](./cloudprovisioner_aws.html) 