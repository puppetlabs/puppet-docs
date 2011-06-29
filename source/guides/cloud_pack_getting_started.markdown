---
layout: default
title: Getting Started With CloudPack
---

[fog]: http://fog.io/
[pe]: http://info.puppetlabs.com/download
[cp]: https://github.com/puppetlabs/puppet-cloudpack

Getting Started With Puppet CloudPack
=====================================

Learn how to install and start using CloudPack, Puppet's preview Faces extension for node bootstrapping.

* * * 

Overview
--------

Puppet CloudPack is a Puppet extension that adds new actions for creating and puppetizing new machines, especially Amazon AWS EC2 instances. 

CloudPack gives you an easy command line interface to the following tasks:

* Create a new Amazon EC2 instance
* Install Puppet Enterprise on a remote machine of your choice
* Add a new puppet agent node to a Puppet Dashboard node group
* Do all of the above (plus sign the new node's certificate) with a single `puppet node bootstrap` invocation

Installing
----------

To install Puppet CloudPack, simply clone [the repository][cp] on your control node and add its lib directory to your `$RUBYLIB` or Ruby load path. 

Prerequisites
-------------

Puppet CloudPack has several requirements beyond those of Puppet. 

### Software

CloudPack can only be used with **Puppet 2.7 or greater.** Classification of new nodes requires Puppet Dashboard 1.1.2 (unreleased at the time of this writing) or greater.

CloudPack also requires [Fog][], a Ruby cloud services library. You'll need to **ensure that Fog is installed** on the machine running CloudPack:

    # gem install fog

Depending on your operating system and Ruby environment, you may need to manually install some of Fog's dependencies. 

If you wish to use CloudPack to install Puppet on new nodes, you'll also need **a copy of the [Puppet Enterprise][pe] universal tarball.** As of this writing, the distro-specific tarballs are not supported.

The machine running the CloudPack faces will need a working `/usr/bin/uuidgen` binary.

### Services

Currently, Amazon EC2 is the only supported cloud platform for creating new machine instances; you'll need a pre-existing **Amazon EC2 account** to use this feature. 

Configuration
-------------

### Fog

For CloudPack to work, Fog needs to be configured with your AWS access key ID and secret access key. Create a `~/.fog` file as follows: 

    :default:
      :aws_access_key_id:     XXXXXXXXXXXXXXXXXXXXX
      :aws_secret_access_key: Xx+xxXX+XxxXXXXXXxxXxxXXXXxxxXXxXXxxxxXX

To test whether Fog is working, execute the following command:

    $ ruby -rubygems -e 'require "fog"' -e 'puts Fog::Compute.new(:provider => "AWS").servers.length >= 0'

This should return "true"

If you do not have the ~/.fog configuration file correct, you may receive an
error such as the following.  In this case, please verify your
aws\_access\_key\_id and aws\_secret\_access\_key are properly set in the
~/.fog file

    fog-0.9.0/lib/fog/core/service.rb:155
    in `validate_options': Missing required arguments: aws_access_key_id, aws_secret_access_key (ArgumentError)
            from /Users/jeff/.rvm/gems/ruby-1.8.7-p334@puppet/gems/fog-0.9.0/lib/fog/core/service.rb:53:in `new'
            from /Users/jeff/.rvm/gems/ruby-1.8.7-p334@puppet/gems/fog-0.9.0/lib/fog/compute.rb:13:in `new'
            from -e:2

### EC2

Your EC2 account will need to have at least one **32-bit AMI of a supported Puppet Enterprise OS,**[^platforms] at least one Amazon-managed **SSH keypair,** and a security group that **allows outbound traffic on port 8140 and SSH traffic from the machine running the CloudPack actions.** As of this writing, all of these resources **must be in the `us-east-1` region;** this will change in a later release of the CloudPack. We also hope to support 64-bit AMIs at a later date.

Your puppet master server will also have to be reachable from your newly created instances.

[^platforms]: Currently, the supported platforms for Puppet Enterprise are CentOS 5, RHEL 5, Debian 5, and Ubuntu 10.04 LTS.

### Provisioning

In order to use the `install` action, any newly provisioned instances will need to have their root user enabled, or will need a user account configured to `sudo` as root without a password.

### puppet master

If you want to automatically sign certificates with the CloudPack, you'll have to allow the computer running the CloudPack actions to access the puppet master's `certificate_status` REST endpoint. This can be configured in the master's [auth.conf](http://docs.puppetlabs.com/guides/rest_auth_conf.html) file:

    path /certificate_status
    method save
    auth yes
    allow {certname}

If you're running the CloudPack actions on a machine other than your puppet master, you'll have to ensure it can communicate with the puppet master over port 8140 and your Puppet Dashboard server over port 3000. 

### Certificates and Keys

You'll also have to make sure the control node has a certificate signed by the puppet master's CA. If the control node is already known to the puppet master (e.g. it is or was a puppet agent node), you'll be able to use the existing certificate, but we recommend generating a per-user certificate for a more explicit and readable security policy. On the control node, run:

    puppet certificate generate {certname} --ca-location remote

Then sign the certificate as usual on the master (`puppet cert sign {certname}`). On the control node again, run:

    puppet certificate find ca --ca-location remote
    puppet certificate find {certname} --ca-location remote

This should let you operate under the new certname when you run puppet commands with the --certname {certname} option. 

The control node will also need a private key to allow SSH access to the new machine; for EC2 nodes, this is the private key from the keypair used to create the instance. If you are working with non-EC2 nodes, please note that the `install` action does not currently support keys with passphrases.

### Installer Configuration

To install Puppet Enterprise on a node, you'll need a complete answers file to be read by the installer. See the PE documentation for more details. Note that the certname from the answers file is ignored, and the new instance will be given a UUID as its certname. 

Usage
-----

Puppet CloudPack provides five new actions on the `node` face: 

* `create`: Creates a new EC2 machine instance.
* `install`: Install's Puppet Enterprise on an arbitrary machine, including non-cloud hardware.
* `classify`: Add a new node to a Puppet Dashboard node group.
* `init`: Perform the `install` and `classify` actions, and automatically sign the new agent node's certificate. 
* `bootstrap`: Create a new EC2 machine instance and perform the `init` action on it.
* `terminate`: Tear down an EC2 machine instance.

### puppet node create

Argument(s): none.

Options: 

* `--image, -i` --- The name of the AMI to use when creating the instance. **Required.**
* `--keypair` --- The Amazon-managed SSH keypair to use for accessing the instance. **Required.**
* `--group, -g, --security-group` --- The security group(s) to apply to the instance. Can be a single group or a path-separator (colon, on *nix systems) separated list of groups. 

Example:

    $ puppet node create --image ami-XxXXxXXX --keypair puppetlabs.admin

Creates a new EC2 machine instance, prints its SSH host key fingerprints, and returns its DNS name. If the process fails, Puppet will automatically clean up after itself and tear down the instance. 

For security reasons, SSH fingerprints are obtained by observing the AWS console for the machine. This entails a noticeable wait, and the console output is sometimes not provided; if this happens, the instance will be kept alive and you will have to obtain host fingerprints through AWS. 

### puppet node install

Argument(s): the hostname of the system to install Puppet on.

Options: 

* `--login, -l, --username` --- The user to log in as. **Required.**
* `--keyfile` --- The SSH private key file to use. This key cannot require a passphrase. **Required.**
* `--installer-payload, --puppet` --- The location of the [Puppet Enterprise][pe] universal tarball. **Required.**
* `--installer-answers` --- The location of an answers file to use with the PE installer. **Required.**

Example: 

    puppet node install ec2-XXX-XXX-XXX-XX.compute-1.amazonaws.com \
    --login root --keyfile ~/.ssh/puppetlabs-ec2_rsa \
    --installer-payload ~/puppet-enterprise-1.0-all.tar.gz \
    --installer-answers ~/pe-agent-answers

Install Puppet Enterprise on an arbitrary system and return the new agent node's certname. This action currently requires the universal PE tarball; per-distro tarballs are not supported. 

Interactive installation is not supported, so you'll need an answers file. See the PE manual for complete documentation of the answers file format.

This action is not restricted to cloud machine instances, and will install PE on any machine accessible by SSH. 

### puppet node classify

Argument(s): the certname of the agent node to classify. 

Options: 

* `--node-group, --as` --- The Puppet Dashboard node group to use. **Required.**
* `--report_server` --- The hostname of your Puppet Dashboard server. Required unless properly configured in puppet.conf. This is a global Puppet option.
* `--report_port` --- The port on which Puppet Dashboard is listening. Required unless properly configured in puppet.conf. This is a global Puppet option.
* `--certname` --- The certname (Subject CN) of a certificate authorized by the puppet master to remotely sign CSRs. Required unless properly configured in puppet.conf. This is a global Puppet option.

Example: 

    puppet node classify ec2-XXX-XXX-XXX-XX.compute-1.amazonaws.com \
    --as webserver_generic --report_server dashboard.puppetlabs.lan \
    --report_port 3000 --certname cloud_admin

Make Puppet Dashboard aware of a newly created agent node and add it to a node group, thus allowing it to receive proper configurations on its next run. This action will have no material effect unless you're using Puppet dashboard for node classification. 

This action is not restricted to cloud machine instances. It can be run multiple times for a single node. 

### puppet node init

Argument(s): the hostname of the system to install Puppet on.

Options: See "install" and "classify."

Example: 

    puppet node init ec2-XXX-XXX-XXX-XX.compute-1.amazonaws.com \
    --login root --keyfile ~/.ssh/puppetlabs-ec2_rsa \
    --installer-payload ~/puppet-enterprise-1.0-all.tar.gz\
     --installer-answers ~/pe-agent-answers --as webserver_generic \
    --report_server dashboard.puppetlabs.lan --report_port 3000 --certname cloud_admin

Install Puppet Enterprise on an arbitrary system (see "install"), classify it in Dashboard (see "classify"), and automatically sign its certificate request (using the `certificate` face's `sign` action). 

### puppet node bootstrap

Argument(s): none.

Options: See "create," "install," and "classify."

Example: 

    puppet node bootstrap --image ami-XxXXxXXX --keypair \
    puppetlabs.admin --login root --keyfile ~/.ssh/puppetlabs-ec2_rsa \
    --installer-payload ~/puppet-enterprise-1.0-all.tar.gz \
    --installer-answers ~/pe-agent-answers --as webserver_generic \
    --report_server dashboard.puppetlabs.lan --report_port 3000 \
    --certname cloud_admin

Create a new EC2 machine instance and pass the new node's hostname to the `init` action.

### puppet node terminate

Argument(s): the hostname of the machine instance to tear down.

Options: none.

Example: 

    puppet node terminate init ec2-XXX-XXX-XXX-XX.compute-1.amazonaws.com

Tear down an EC2 machine instance. 
