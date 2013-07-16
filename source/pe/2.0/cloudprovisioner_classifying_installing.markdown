---
layout: default
title: "PE 2.0 » Cloud Provisioning » Classifying and Installing"
canonical: "/pe/latest/cloudprovisioner_classifying_installing.html"
---

* * *

&larr; [Cloud Provisioning: Provisioning with AWS](./cloudprovisioner_aws.html) --- [Index](./) --- [Cloud Provisioning: Man Page: puppet node_vmware](./cloudprovisioner_man_node_vmware.html) &rarr;

* * *

Classifying New Nodes and Remotely Installing PE
=====

In addition to the provisioning actions described in the prior chapters, Puppet Enterprise includes actions for adding nodes to a pre-existing console group and remotely installing Puppet Enterprise on new nodes. 

Classifying nodes
-----------------

Once you have created virtual machines or instances, you can add them to a group in the console right from the command line. This has the same effect as [adding nodes to a group with the console's web interface](./console_classes_groups.html#grouping-nodes), but can be more convenient if you're already at the command line and have the node's name ready at hand. 

To classify nodes and add them to a console group, use the `puppet node classify` command.

    $ puppet node classify \
    --node-group=appserver_pool \
    --enc-server=localhost \
    --enc-port=443 \
    --enc-ssl \
    --enc-auth-user=console \
    --enc-auth-passwd=password \
    ec2-50-19-149-87.compute-1.amazonaws.com

    notice: Contacting https://localhost:443/ to classify
    ec2-50-19-149-87.compute-1.amazonaws.com
    complete

Here we're adding an AWS EC2 instance to the console.

With the command's options, we specify:

* The `--node-group` we'd like to add the node to (in our case the `appserver_pool` group)
* The console's server
* The console's port
* Whether the console uses SSL
* The user name for connecting to the console
* The password for connecting to the console --- this user name and password were set when the console was installed

As the command's argument, we specify the name of the node we're classifying. If we
now navigate to the console's web interface, we can see this host has been added to the
`appserver_pool` group.

To see additional help for node classification, run `puppet help node classify`. For more about how the console groups and classifies nodes, [see the chapter of this manual about grouping and classifying](./console_classes_groups.html).

<object width="420" height="315"><param name="movie"
value="http://www.youtube.com/v/LG6WQPVsBNg?version=3&amp;hl=en_US"></param><param
name="allowFullScreen" value="true"></param><param name="allowscriptaccess"
value="always"></param><embed
src="http://www.youtube.com/v/LG6WQPVsBNg?version=3&amp;hl=en_US"
type="application/x-shockwave-flash" width="420" height="315"
allowscriptaccess="always" allowfullscreen="true"></embed></object>

Installing Puppet
-----------------

Use the `puppet node install` command to install Puppet Enterprise (or open-source Puppet) onto new nodes.

    $ puppet node install --keyfile=~/.ssh/mykey.pem --login=root ec2-50-19-207-181.compute-1.amazonaws.com 
    notice: Waiting for SSH response ...
    notice: Waiting for SSH response ... Done
    notice: Installing Puppet ...
    puppetagent_certname: ec2-50-19-207-181.compute-1.amazonaws.com-ee049648-3647-0f93-782b-9f30e387f644
    status: success

With the command's options, we specify:

* An SSH key to log in with (`--keyfile`) --- the `install` action uses SSH to connect to the host, and needs an SSH key. For VMware, this key should be loaded onto the template you used to create your virtual machine. For Amazon EC2, it should be the private key from the key pair you used to create the instance.
* The local user account to log in as (`--login`).

As the command's argument, we specify the name of the node we're installing Puppet Enterprise on. 

For the default installation, the `install` action uses packages
provided by Puppet Labs and stored in Amazon S3 storage.  You can also specify
packages located on your local host, or on a share in your local network. See `puppet help node install` or `puppet man node` for more details.

In addition to these default configuration options, we can specify a number of
additional options to control how and what we install on the host. We can
specify the specific version of Puppet Enterprise (or we can install open
source Puppet too) to install. We can also control the version of Facter to
install, the specific answers file to use to configure Puppet Enterprise, the
certificate name of the agent to be installed and a variety of other options. To
see a full list of the available options, use the `puppet help node install`
command.

<object width="420" height="315"><param name="movie"
value="http://www.youtube.com/v/F0hU94bBrQo?version=3&amp;hl=en_US"></param><param
name="allowFullScreen" value="true"></param><param name="allowscriptaccess"
value="always"></param><embed
src="http://www.youtube.com/v/F0hU94bBrQo?version=3&amp;hl=en_US"
type="application/x-shockwave-flash" width="420" height="315"
allowscriptaccess="always" allowfullscreen="true"></embed></object>

Classifying and Installing Puppet in One Command
------------------------------------------------

Rather than using multiple commands to classify and install Puppet on a
node, you can use the `init` action, which performs both actions in a
single command. For example:

    $ puppet node init \
    --node-group=appserver_pool \
    --enc-server=localhost \
    --enc-port=443 \
    --enc-ssl \
    --enc-auth-user=console \
    --enc-auth-passwd=password \
    --keyfile=~/.ssh/mykey.pem \
    --login=root \
    ec2-50-19-207-181.compute-1.amazonaws.com

The `init` action combines the options for the `classify` and
`install` actions. The invocation above will connect to the console, classify the node in the `appserver_pool` group, and then install Puppet Enterprise on this node.

* * *

&larr; [Cloud Provisioning: Provisioning with AWS](./cloudprovisioner_aws.html) --- [Index](./) --- [Cloud Provisioning: Man Page: puppet node_vmware](./cloudprovisioner_man_node_vmware.html) &rarr;

* * *

