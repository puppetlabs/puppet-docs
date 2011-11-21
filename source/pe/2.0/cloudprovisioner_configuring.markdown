---
layout: pe2experimental
title: "PE 2.0 » Cloud Provisioning » Configuring and Troubleshooting"
---

Configuring and Troubleshooting Cloud Provisioning
=====

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

