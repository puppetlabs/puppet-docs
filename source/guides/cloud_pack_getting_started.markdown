---
layout: legacy
title: Getting Started With Cloud Provisioner
---

[fog]: http://fog.io/
[pe]: http://info.puppetlabs.com/download
[cp]: https://github.com/puppetlabs/puppetlabs-cloud-provisioner

Getting Started With Puppet Cloud Provisioner
=====================================

Learn how to install and start using Cloud Provisioner, Puppet's extension for
node bootstrapping.

* * *

Overview
--------

Puppet Cloud Provisioner is a Puppet extension that adds new actions for
creating and puppetizing new machines in Amazon's EC2.

Cloud Provisioner gives you an easy command line interface to the following
tasks:

* Create a new Amazon EC2 instance
* Install Puppet on a remote machine of your choice
* Remotely sign a node's certificate
* Do all of the above with a single `puppet node_aws bootstrap` invocation

Prerequisites
-------------

Puppet Cloud Provisioner has several requirements beyond those of Puppet.

### Software

Cloud Provisioner can only be used with **Puppet 2.7.2 or greater.**

Cloud Provisioner requires [Fog][], a Ruby cloud services library. You'll need
to **ensure that Fog is installed** on the machine running Cloud Provisioner:

    # gem install fog -v 0.7.2

Depending on your operating system and Ruby environment, you may need to
manually install some of Fog's dependencies.

Cloud Provisier also requires the GUID library for generating unique
identifiers.

    # gem install guid

### Services

Currently, Amazon EC2 is the only supported cloud platform for creating new
machine instances; you'll need a pre-existing **Amazon EC2 account** to use
this feature.

Installing
----------

Puppet Cloud Provisioner should be installed with the puppet-module tool. First
make sure that the tool is installed:

    # gem install puppet-module

Then cd to the directory where you wish to install Cloud Provisioner:

    # cd $(puppet --configprint confdir)/modules

Now use puppet-module to install Cloud Provisioner on your control node:

    # puppet-module install puppetlabs/cloud_provisioner

Add its lib directory to your `$RUBYLIB` or Ruby load path:

    # export RUBYLIB=$(pwd)/cloud_provisioner/lib:$RUBYLIB

You can verify that it is installed correctly by running:

    # puppet help node_aws

Verifying that you see the Cloud Provisioner specific commands (create,
install, ...) in the output.

Configuration
-------------

### Fog

For Cloud Provisioner to work, Fog needs to be configured with your AWS access
key ID and secret access key. Create a `~/.fog` file as follows:

    :default:
      :aws_access_key_id:     XXXXXXXXXXXXXXXXXXXXX
      :aws_secret_access_key: Xx+xxXX+XxxXXXXXXxxXxxXXXXxxxXXxXXxxxxXX

You may obtain your AWS Access key id and secret access key using the following information:
<pre>
To view your AWS Secret access key, go to http://aws.amazon.com and click on
Account > Security Credentials. From their, under the "Access Credentials"
section of the page, click on the "Access Keys" tab to view your Access Keys.
To see your Secret Access Key, just click on the "Show" link under "Secret
Access Key".

From here, you can create new access keys or delete old ones. Just click on
"Create a new Access Key" and confirm that you'd like to generate a new pair.
This will generate both access and secret access keys. But, keep in mind that
your account is only able to have two sets of keys at any given time. If you
already have two sets created, you will not see the option to create a new set
until one has been made inactive and then deleted.
</pre>
Information from [AWS Discussion
Forums](https://forums.aws.amazon.com/thread.jspa?threadID=49738)

To test whether Fog is working, execute the following command:

    $ ruby -rubygems -e 'require "fog"' -e 'puts Fog::Compute.new(:provider => "AWS").servers.length >= 0'

This should return "true"

If you do not have the ~/.fog configuration file correct, you may receive an
error such as the following:

    fog-0.9.0/lib/fog/core/service.rb:155
    in `validate_options': Missing required arguments: aws_access_key_id, aws_secret_access_key (ArgumentError)
            from /Users/jeff/.rvm/gems/ruby-1.8.7-p334@puppet/gems/fog-0.9.0/lib/fog/core/service.rb:53:in `new'
            from /Users/jeff/.rvm/gems/ruby-1.8.7-p334@puppet/gems/fog-0.9.0/lib/fog/compute.rb:13:in `new'
            from -e:2

In this case, please verify your `aws_access_key_id` and `aws_secret_access_key` are properly set in the ~/.fog file.

### EC2

Your EC2 account will need to have at least one Amazon-managed **SSH keypair,**
and a security group that **allows outbound traffic on port 8140 and SSH
traffic from the machine running the Cloud Provisioner actions.**

Your puppet master server will also have to be reachable from your newly
created instances.

[^platforms]: Currently, supported platforms are restricted by the install
script chosen. Testing has only currently been done on Ubuntu 11.04 (Natty) and
CentOS 5.4.

### Provisioning

In order to use the `install` action, any newly provisioned instances will need
to have their root user enabled, or will need a user account configured to
`sudo` as root without a password.

### puppet master

If you want to automatically sign certificates with the Cloud Provisioner,
you'll have to allow the computer running the Cloud Provisioner actions to
access the puppet master's `certificate_status` REST endpoint. This can be
configured in the master's
[auth.conf](http://docs.puppetlabs.com/guides/rest_auth_conf.html) file:

    path /certificate_status
    method save
    auth yes
    allow {certname}

If you're running the Cloud Provisioner actions on a machine other than your
puppet master, you'll have to ensure it can communicate with the puppet master
over port 8140.

### Certificates and Keys

You'll also have to make sure the control node has a certificate signed by the
puppet master's CA. If the control node is already known to the puppet master
(e.g. it is or was a puppet agent node), you'll be able to use the existing
certificate, but we recommend generating a per-user certificate for a more
explicit and readable security policy. On the control node, run:

    puppet certificate generate {certname} --ca-location remote

Then sign the certificate as usual on the master (`puppet cert sign
{certname}`). On the control node again, run:

    puppet certificate find ca --ca-location remote
    puppet certificate find {certname} --ca-location remote

This should let you operate under the new certname when you run puppet commands
with the `--certname {certname}` option.

The control node will also need a private key to allow SSH access to the new
machine; for EC2 nodes, this is the private key from the keypair used to create
the instance. If you are working with non-EC2 nodes, please note that the
`install` action does not currently support keys with passphrases.

Usage
-----

Puppet Cloud Provisioner provides seven new actions on the `node` face:

* `create`: Creates a new EC2 machine instance.
* `install`: Install's Puppet on an arbitrary machine, including non-cloud
hardware.
* `init`: Perform the `install` and `classify` actions, and automatically sign
the new agent node's certificate.
* `bootstrap`: Create a new EC2 machine instance and perform the `init` action
on it.
* `terminate`: Tear down an EC2 machine instance.
* `list`: List running instances in the specified zone.
* `fingerprint`: Make a best effort to securely obtain the SSH host key
fingerprint.

### puppet node_aws create

Argument(s): none.

Options:

* `--image, -i` --- The name of the AMI to use when creating the instance.
**Required.**
* `--keypair` --- The Amazon-managed SSH keypair to use for accessing the
instance. **Required.**
* `--group, -g, --security-group` --- The security group(s) to apply to the
instance. Can be a single group or a path-separator (colon, on *nix systems)
separated list of groups.
* `--region` --- The geographic region of the instance. Defaults to us-east-1.
* `--type` --- Type of instance to be launched.

Example:

    $ puppet node_aws create --image ami-XxXXxXXX --keypair puppetlabs.admin --type m1.small
/
Creates a new EC2 machine instance and returns its DNS name. If the process
fails, Puppet will automatically clean up after itself and tear down the
instance.

### puppet node_aws install

Argument(s): the hostname of the system to install Puppet on.

Options:

* `--login, -l, --username` --- The user to log in as. **Required.**
* `--keyfile` --- The SSH private key file to use. This key cannot require a
passphrase. **Required.**
* `--install-script` --- The install script that should be used to install
Puppet. Currently supported options are: gems (**default**), puppet-enterprise, and puppet-enterprise-s3
* `--installer-payload, --puppet` --- The location of the [Puppet
Enterprise][pe] universal tarball. (Used with puppet-enterprise install script)
* `--installer-answers` --- The location of an answers file to use with the PE
installer. (Used with puppet-enterprise and puppet-enterprise-s3 install
scripts).
* `--puppet-version` --- The version of puppet to install with the gems install
script.
* `--facter-version` --- The version of facter to install with the gems install
script.
* `--pe-version` --- The version of PE to install with the puppet-enterprise
script (e.g. `1.1`). Defaults to `1.1`.

Example:

    puppet node_aws install ec2-XXX-XXX-XXX-XX.compute-1.amazonaws.com \
    --login root --keyfile ~/.ssh/puppetlabs-ec2_rsa \
    --install-script gems --puppet-version 2.6.9

Installs Puppet on an arbitrary system and returns the new agent
node's certname.

Interactive installation of PE is not supported, so you'll need an answers
file. See the PE manual for complete documentation of the answers file format.
A reasonable default has been supplied in Cloud Provisioner's `ext` directory.

This action is not restricted to cloud machine instances, and will install Puppet
on any machine accessible by SSH.

### puppet node_aws init

Argument(s): the hostname of the system to install Puppet on.

Options: See "install"

Example:

    puppet node_aws init ec2-XXX-XXX-XXX-XX.compute-1.amazonaws.com \
    --login root --keyfile ~/.ssh/puppetlabs-ec2_rsa \
    --certname cloud_admin

Install Puppet on an arbitrary system (see "install") and automatically sign
its certificate request (using the `certificate` face's `sign` action).

### puppet node_aws bootstrap

Argument(s): none.

Options: See "create" and "install"

Example:

    puppet node_aws bootstrap --image ami-XxXXxXXX --keypair \
    puppetlabs.admin --login root --keyfile ~/.ssh/puppetlabs-ec2_rsa \
    --certname cloud_admin

Create a new EC2 machine instance and pass the new node's hostname to the
`init` action.

### puppet node_aws terminate

Argument(s): the hostname of the machine instance to tear down.

Options:

* `--region` --- The geographic region of the instance. Defaults to us-east-1.

Example:

    puppet node_aws terminate ec2-XXX-XXX-XXX-XX.compute-1.amazonaws.com

Tear down an EC2 machine instance.

### puppet node_aws list

Argument(s): None

Options:

* `--region` --- The geographic region of the instance. Defaults to us-east-1.

Example:

    puppet node_aws list --region us-west-1

List the Amazon EC2 instances in the specified region and report on their status (pending, running, shutting down, or terminated). This is not limited to instances created by Cloud Provisioner. 
