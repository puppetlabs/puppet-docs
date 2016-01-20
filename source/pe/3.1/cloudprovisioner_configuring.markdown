---
layout: default
title: "PE 3.1 » Cloud Provisioner » Installation and Configuration"
subtitle: "Installing and Configuring Cloud Provisioning"
canonical: "/pe/latest/cloudprovisioner_configuring.html"
---

There are many options and actions associated with the main cloud provisioning sub-commands: `node`, `node_vmware`, `node_aws` and `node_gce`. This page provides an overview, but check the man pages for all the details (`puppet man node_aws`, etc.).

Prerequisites
-------------

### Software

- The cloud provisioning tools ship with Puppet Enterprise; they are an optional role in the PE installer. You must specifically choose to install cloud provisioner in order to run the cloud provisioner commands.

### Services

The following services and credentials are required:

- VMware requires: VMware vSphere 4.0 (or later) and VMware vCenter
- Amazon Web Services requires: An existing Amazon account with support for EC2
- Google Compute Engine requires: An existing Google account and billing information.


Installing
----------

Cloud provisioning tools can be installed on any puppet master or agent node.

The Puppet Enterprise installer will ask whether or not to install cloud provisioning during installation. Answer 'yes' to enable cloud provisioning actions on a given node. If you're using an answer file to install Puppet Enterprise, you can install the cloud provisioning tools by setting the `q_puppet_cloud_install` option to `y`.

If you have already installed PE without installing the cloud provisioning tools, you can install them using the package manager of your choice (Yum, APT, etc.). The packages you need are: `pe-cloud-provisioner` and `pe-cloud-provisioner-libs`. They can be found in the packages directory of the installer tarball.


Configuring
-----------

To create new virtual machines with Puppet Enterprise, you'll need to first configure the services you'll be using.

Start by creating a file called `.fog` in the home directory of the user who will be provisioning new nodes.

    $ touch ~/.fog

This will be the configuration file for [Fog](https://github.com/fog/fog), the cloud abstraction library that powers PE's provisioning tools. Once it is filled out, it will consist of a YAML hash indicating the locations of your cloud services and the credentials necessary to control them. For example:

    :default:
      :vsphere_server: vc01.example.com
      :vsphere_username: cloudprovisioner
      :vsphere_password: abc123
      :vsphere_expected_pubkey_hash: 431dd5d0412aab11b14178290d9fcc5acb041d37f90f36f888de0cebfffff0a8
      :aws_access_key_id: AKIAIISJV5TZ3FPWU3TA
      :aws_secret_access_key: ABCDEFGHIJKLMNOP1234556/s

See below to learn how to find these credentials.

### Adding VMware Credentials

To connect to a VMware vSphere server, you must put the following information in your `~/.fog` file:

`:vsphere_server`
: The name of your vCenter host (for example: `vc1.example.com`). You should already know the value for this setting.

`:vsphere_username`
: Your vCenter username. You should already know the value for this setting.

`:vsphere_password`
: Your vCenter password. You should already know the value for this setting.

`:vsphere_expected_pubkey_hash`
: A public key hash for your vSphere server. The value for this setting can be obtained by entering the other three settings and then running the following command:

        $ puppet node_vmware list

    This will result in an error message containing the server's public key hash...

        notice: Connecting ...·
        err: The remote system presented a public key with hash
        431dd5d0412aab11b14178290d9fcc5acb041d37f90f36f888de0cebfffff0a8 but
        we're expecting a hash of <unset>.  If you are sure the remote system is
        authentic set vsphere_expected_pubkey_hash: <the hash printed in this
        message> in ~/.fog
        err: Try 'puppet help node_vmware list' for usage

    ...which can then be entered as the value of this setting.


### Adding Amazon Web Services

To connect to Amazon Web Services, you must put the following information in your `~/.fog` file:

`:aws_access_key_id`
: Your AWS Access Key ID. See below for how to find this.

`:aws_secret_access_key`
: Your AWS Secret Key ID. See below for how to find this.

For *AWS installations*, you can find your Amazon Web Services credentials online in your Amazon account. To view them, go to [Amazon AWS](http://aws.amazon.com) and click on the Account tab.

![AWS Account tab](./images/cloud/awsaccount.png)

Select the "Security Credentials" menu and choose "Access Credentials." Click on the "Access Keys" tab to view your Access Keys.

You need to record two pieces of information: the Access Key ID and the Secret Key ID. To see your Secret Access Key, click the "Show" link under "Secret Access Key".

Put both keys in your `~/.fog` file as described above. You will also need to generate an SSH private key using Horizon, or simply import a selected public key.


### Additional AWS Configuration

For Puppet to provision nodes in Amazon Web Services, you will need an EC2 account with the following::

* At least one Amazon-managed SSH key pair.
* A security group that allows outbound traffic on ports **8140** and **61613,** and inbound SSH traffic on port 22 from the machine being used for provisioning.

You'll need to provide the names of these resources as arguments when running the provisioning commands.

#### Key Pairs

To find or create your Amazon SSH key pair, browse to the [Amazon Web Service
EC2 console](https://console.aws.amazon.com/ec2/).

![AWS EC2 Console](./images/cloud/ec2console.png)

Select the "Key Pairs" menu item from the dashboard. If you don't have any existing key pairs, you can create one with the "Create Key Pairs" button. Specify a new name for the key pair to create it; the private key file will be automatically downloaded to your host.

Make a note of the name of your key pair, since you will need to know it when creating new instances.

#### Security Group

To add or edit a security group, select the "Security Groups" menu item
from the dashboard. You should see a list of the available security
groups.  If no groups exist, you can create a new one by clicking the
"Create Security Groups" button. Otherwise, you can edit an existing group.

![AWS Security Groups](./images/cloud/awssecgroup.png)

To add the required rules, select the "Inbound" tab and add an SSH rule. Make sure that inbound SSH traffic is using port 22.
You can also indicate a specific source to lock the source IP down to an appropriate source IP or network.  Click "Add Rule" to add the rule,
then click "Apply Rule Changes" to save.

You should also ensure that your security group allows outbound traffic on ports **8140** and **61613.** These are the ports PE uses to request configurations and listen for orchestration messages.


Demonstration

-----------

The following video demonstrates the setup process and some basic functions:

<object width="560" height="315"><param name="movie"
value="http://www.youtube.com/v/pc-LFM2-nwQ?version=3&amp;hl=en_US"></param><param
name="allowFullScreen" value="true"></param><param
name="allowscriptaccess" value="always"></param><embed
src="http://www.youtube.com/v/pc-LFM2-nwQ?version=3&amp;hl=en_US"
type="application/x-shockwave-flash" width="560" height="315"
allowscriptaccess="always" allowfullscreen="true"></embed></object>

### Adding Google Compute Engine Credentials

The following steps describe how to create a Google Compute Engine account, obtain a client ID and secret, and register `node_gce` with your GCE account.
**Note** These steps don't cover setting up a billing method for your GCE account. To set up billing, click **Billing** in the Google Cloud Console, and follow the instructions there.

Go to https://cloud.google.com and sign in with your Google credentials.
Click the **Create Project** button, and give your project a name. This creates your project in the Google Cloud Console. Some options for working with your project are displayed in the left navigation bar.

In the left-hand navigation bar, click **APIs and auth** and then click **Registered Apps**.
 
Click the **REGISTER APP** button. Give your app a name--it can be whatever you like--and click **Native** as the platform.

Click **Register**. Your app's page opens, and a CLIENT ID and CLIENT SECRET are provided. **Note** You'll need the ID and secret, so capture these for future reference.

Now, in PE, run `puppet node_gce register <client ID> <client secret>` and follow the online instructions. You'll get a URL to visit in your browser. There, you'll log into your Google account and grant permission for your node to access GCE.

Once permission is granted, you'll get a token of about 64 characters. Copy this token as requested into your `node_gce` run to complete the registration.
* * *

- [Next: Classifying Cloud Nodes and Remotely Installing Puppet](./cloudprovisioner_classifying_installing.html)
