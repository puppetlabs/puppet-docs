---
layout: default
title: "PE 3.2 » Cloud Provisioning » Classifying Nodes and Installing Puppet"
subtitle: "Classifying New Nodes and Remotely Installing Puppet"
canonical: "/pe/latest/cloudprovisioner_classifying_installing.html"
---

Nodes in a cloud infrastructure can be classified and managed as easily as any other machine in a Puppet Enterprise deployment. You can install a puppet agent (or other role) on them and add new nodes to pre-existing console groups, further classify and configure those nodes, and manipulate them with live management.

Many of these tasks are accomplished using the `puppet node` subcommand. While `puppet node` can be applied to physical or virtual machines, several actions have been created specifically for working with virtual machine instances in the cloud. For complete details, view the `puppet node` man page.

Classifying nodes
-----------------

Once you have created instances for your cloud infrastructure, you need to start configuring them and adding the files, settings, and/or services needed for their intended purposes. The fastest and easiest way to do this is to add them to your existing console groups.  You can do this by [assigning groups to nodes][g2n] or [nodes to groups][n2g] with the console's web interface. However, you can also work right from the command line, which can be more convenient if you're already at your terminal and have the node's name ready at hand.

[g2n]: ./console_classes_groups.html#assigning-classes-and-groups-to-nodes
[n2g]: ./console_classes_groups.html#adding-nodes-to-a-group

To classify nodes and add them to a console group, run `puppet node classify` as follows.

**Note** - With `classify` and `init`, you need to specify the `--insecure` option because the PE console uses the internal certificate name, `pe-internal-dashboard`, which fails verification because it doesn't match the host name of the host where the console is running.

    $ puppet node classify \
    --insecure \
    --node-group=appserver_pool \
    --enc-server=localhost \
    --enc-port=443 \
    --enc-auth-user=console \
    --enc-auth-passwd=password \
    ec2-50-19-149-87.compute-1.amazonaws.com

    notice: Contacting https://localhost:443/ to classify
    ec2-50-19-149-87.compute-1.amazonaws.com
    complete

The above example adds an AWS EC2 instance to the console. Note that you use the name of the node you are classifying as the command's argument and the `--node-group` option to specify the group you want to add your new node to. The other options contain the connection and authentication data needed to properly connect to the node.

**Important:** All ENC connections to cloud nodes now require SSL support.

Note that until the first puppet run is performed on this node, Puppet itself will not yet be installed. (Unless one of the "wrapper" commands has been used. [See below](#installing-puppet).)

To see additional help for node classification, run `puppet help node classify`. For more about how the console groups and classifies nodes, [see the section on grouping and classifying](./console_classes_groups.html).

You may also wish review the [basics of Puppet classes and configuration](./puppet_overview.html) to help you understand how groups and classes interact.

The process of adding a node to the console is demonstrated in the following video:

<object width="420" height="315"><param name="movie"
value="http://www.youtube.com/v/LG6WQPVsBNg?version=3&amp;hl=en_US"></param><param
name="allowFullScreen" value="true"></param><param name="allowscriptaccess"
value="always"></param><embed
src="http://www.youtube.com/v/LG6WQPVsBNg?version=3&amp;hl=en_US"
type="application/x-shockwave-flash" width="420" height="315"
allowscriptaccess="always" allowfullscreen="true"></embed></object>

Installing Puppet
-----------------

Use the `puppet node install` command to install PE roles onto the new instances.

    $ puppet node install --install-script=puppet-enterprise --keyfile=~/.ssh/mykey.pem --login=root ec2-50-19-207-181.compute-1.amazonaws.com
    notice: Waiting for SSH response ...
    notice: Waiting for SSH response ... Done
    notice: Installing Puppet ...
    puppetagent_certname: ec2-50-19-207-181.compute-1.amazonaws.com-ee049648-3647-0f93-782b-9f30e387f644
    status: success

This command's options specify:

* The PE Installer script should be used.
* The path to a private SSH key that can be used log in to the VM, specified with the `--keyfile` option. The `install` action uses SSH to connect to the host and so needs access to an SSH key. For Amazon EC2 or GCE, point to the private key from the key pair you used to create the instance. In most cases, the private key is in the `~/.ssh` directory. (Note that for VMware, the public key should have been loaded onto the template you used to create your virtual machine.)
* The local user account used to log in, specified with the `--login` option.

For the command's argument, specify the name of the node on which you're installing Puppet Enterprise.

For the default installation, the `install` action uses the installation packages provided by Puppet Labs and stored in Amazon S3 storage.  You can also specify packages located on a local host or on a share in your local network. Use `puppet help node install` or `puppet man node` to see more details.

In addition to these default configuration options, you can specify a number of additional options to control how and what we install on the host. You can control the version of Facter to install, the specific answers file to use to configure Puppet Enterprise, the
certificate name of the agent to be installed, and a variety of other options. To see a full list of the available options, use the `puppet help node install` command.

The process of installing Puppet on a node is demonstrated in detail in the following video:

<object width="420" height="315"><param name="movie"
value="http://www.youtube.com/v/F0hU94bBrQo?version=3&amp;hl=en_US"></param><param
name="allowFullScreen" value="true"></param><param name="allowscriptaccess"
value="always"></param><embed
src="http://www.youtube.com/v/F0hU94bBrQo?version=3&amp;hl=en_US"
type="application/x-shockwave-flash" width="420" height="315"
allowscriptaccess="always" allowfullscreen="true"></embed></object>

Classifying and Installing Puppet in One Command
------------------------------------------------

### Using `node init`

Rather than using multiple commands to classify and install Puppet on a node, there are a couple of other options that combine actions into a "wrapper" command. Note that you will need access to the PE installer, which is typically specified with the `--installer-payload` argument.

If a node has been prepared to remotely sign certificates, you can use the `init` action which will `install` Puppet, `classify` the node and sign the certificate in one step. 

**Note** - With `classify` and `init`, you need to specify the `--insecure` option because the PE console uses the internal certificate name, `pe-internal-dashboard`, which fails verification because it doesn't match the host name of the host where the console is running.

For example:

    $ puppet node init \
    --insecure \
    --node-group=appserver_pool \
    --enc-server=localhost \
    --enc-port=443 \
    --enc-auth-user=console \
    --enc-auth-passwd=password \
    --install-script=puppet-enterprise \
    --keyfile=~/.ssh/mykey.pem \
    --login=root \
    ec2-50-19-207-181.compute-1.amazonaws.com

The invocation above will connect to the console, classify the node in the `appserver_pool` group, and then install Puppet Enterprise on this node.

### Using `autosign.conf`

Alternatively, if your CA puppet master has the `autosign` setting configured, it can sign certificates automatically. While this can greatly simplify the process, there are some security issues associated with going this route, so be sure you are comfortable with the process and know the risks.

* * *

- [Next: Sample Cloud Provisioning Workflow](./cloudprovisioner_workflow.html)

