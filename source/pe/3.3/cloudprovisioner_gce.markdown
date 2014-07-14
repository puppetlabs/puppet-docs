---
layout: default
title: "PE 3.1 » Cloud Provisioning » GCE Provisioning"
subtitle: "Provisioning With Google Compute Engine"
canonical: "/pe/latest/cloudprovisioner_gce.html"
---
[cloudstore]: ./images/cloud/gcecloudstore.png
[noderequests]: ./images/cloud/gcenoderequests.png

Puppet Enterprise provides support for working with Google Compute Engine, a service built on the Google infrastructure that provides Linux virtual machines for large-scale computing. Using the `puppet node_gce` command, you can create new machines, view information about existing machines, classify and configure machines, and tear machines down when they're no longer needed.

The main actions for GCE cloud provisioning include:

*  `puppet node_gce list` for viewing existing instances
*  `puppet node_gce create` for creating new instances
*  `puppet node_gce delete` for destroying no longer needed instances
*  `puppet node_gce bootstrap` for creating a new GCE VM, then installing PE via SSH
*  `puppet node_gce register` for registering your cloud provisioner GCE client with Google Cloud
*  `puppet node_gce ssh` to SSH to a GCE VM
*  `puppet node_gce user` for managing user login accounts and SSH keys on an instance

If you're new to Google Compute Engine, we recommend reading their [Getting Started
documentation](https://developers.google.com/compute/docs/getting-started-with-compute).

Below, we take a quick look at these actions and their associated options. For comprehensive information, see [Getting More Help](#getting-more-help) below.

Viewing existing GCE instances
-----

Let's start by finding out about currently-running GCE instances. Run the `puppet node_gce list` command with the  `project` argument and the project name. For example, a project named 'cloud-provisioner-testing-1' would look like:

    $ puppet node_gce list --project cloud-provisioner-testing-1
    
And the output would look like:
    
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
    
The output gives you a list of instances running in each geographical zone (this example only shows two of the available zones). You can see that there is one registered instance on GCE. The information that's provided for the instance includes the SSH key used to establish the connection, the type of project--in this case, n1-standard-1--which was set during registration, and the image that the instance contains. Here, the image is a Debian Wheezy OS.

**Note:** If you have no instances running, each zone that's listed will give the message, "no instances in zone."

Creating a new GCE instance
-----

New instances are created using the `node_gce create` or the `node_gce bootstrap` actions. The `create` action simply builds a new GCE machine instance, whereas `bootstrap` is a "wrapper" action that creates, classifies, and then initializes the node.

### Using `create`

The `node_gce create` subcommand is used to build a new GCE instance based on a selected image.

It has these required arguments:

- `--project` to list the project you're working with
- `--image` The image you're using for the instance, as well as the name for the new instance, and the kind of compute engine you want

For example, if the project where the instance will be created is "cloud-provisioner-testing-1", the image is a specific version of Debian Wheezy supported by GCE (see the list of available images [here] (https://developers.google.com/compute/docs/images#availableimages)), the instance name is "myname-test-name", and the compute engine is "n1-standard-1-d", then your complete command would look like:

    $ puppet node_gce create --project cloud-provisioner-testing-1 --image debian-7-wheezy-v20130816 myname-test-name n1-standard-1-d
    
Once run, you'll get the message, "Creating the VM is pending." When it's complete, you will see the new instance listed in your Google Cloud Console.

### Using `bootstrap`

The `node_gce bootstrap` subcommand creates and installs a puppet agent. 

It includes the following options:

- `project` lists the project
-  node name (for example 'cloud-provisioner-testing-1')
-  standard compute size (for example 'n1-standard-1')
- `image` describes the image (for example, 'Debian Wheezy')
- `login` transfers the ssh key for the designated login
- `install-script` references a local install script for the instance
- `installer-answers` points to the location of the local file that provides the answers to installation questions
- `installer-payload` indicates the location of the tar.gz.  

With all of these options, the `bootstrap` subcommand looks like this:

	$ puppet node_gce --trace bootstrap --project cloud-provisioner-testing-1 pe-agent n1-standard-1 --image debian-7-wheezy-v20130816 --login myname --install-script puppet-enterprise-http --installer-answers agent_no_cloud.answer.sample --installer-payload 'http://commondatastorage.googleapis.com/pe-install%2Fpuppet-enterprise-3.3.0-rc2-8-g629db7a-debian-7-amd64.tar.gz'

In the above example, the installation tarball was uploaded to Google Cloud Storage (shown below) to make the process faster. (**Note**: By selecting the Shared Publicly check box, you can avoid having to sign in while this process runs. Don't forget to clear the check box when you're done.)
	
![GCE Cloud Storage][cloudstore]

When you run the `bootstrap` subcommand, you'll get status messages for each stage, such as: "Waiting for SSH response" and "Installing Puppet." 

If you don't have certificate autosigning turned on, you'll get a message that signing certificate failed. In this case, you can go to your Puppet Enterprise console and check the node requests. 

![PE Console with Node Request][noderequest] 

Just click the **Accept** button. Once the certificate request has been accepted, the new agent is displayed in the PE console, where you can configure and manage it.

Deleting a GCE instance
-----

Once you've finished with a GCE instance, you can easily delete it. Deleting an instance destroys the instance entirely and is a destructive, permanent action that should only be performed when you're confident the instance and its data are no longer needed.
 
To delete an instance, use the `node_gce delete` action. Provide both the project and the instance name.

    $ puppet node_gce delete --project cloud-provisioner-testing-1 myname-test-name
    
After you run this command, wait a few moments, and then you'll get the message, "Deleting the VM is done." You can confirm that the instance was deleted by checking your Google Cloud Console.

The following video demonstrates using many `node_gce` subcommands. 

<iframe width="560" height="315" src="//www.youtube.com/embed/8WgqawRK1q8" frameborder="0" allowfullscreen></iframe>

Getting more help
-----

The `puppet node_gce` command has a man page, which you can see with this command:

    $ puppet man node_gce

You can get help on individual actions by running:

    $ puppet help node_gce <ACTION>

For example,

    $ puppet help node_gce list
    
You can also get general help:

	$ puppet help node_gce



* * * 

- [Next: Provisioning with AWS](./cloudprovisioner_aws.html) 