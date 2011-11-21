---
layout: pe2experimental
title: "PE 2.0 » Cloud Provisioning » Classifying and Installing"
---

Classifying New Nodes and Remotely Installing PE
=====

<!-- Summary of extra node actions goes here -->

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

