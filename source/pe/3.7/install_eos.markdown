---
layout: default
title: "PE 3.7 » Installing » Installing Arista EOS Agents"
subtitle: "Installing Arista EOS Agents"
canonical: "/pe/latest/install_eos.html"
---

Puppet Enterprise now supports agents running on Arista EOS network switches. This guide  provides instructions for installing the Puppet agent on an Arista EOS network switch. These instructions assume you've already [installed Puppet Enterprise](./install_basic.html) and have installed an EOS instance following the Arista documentation. 


## Install the Puppet Agent on the EOS Instance

>**Note**: FQDN refers to the fully qualified domain name of a node or instance. 

1. On your Puppet master, install the netdev_stdlib_eos module. Run the following command, `puppet module install aristanetworks-netdev_stdlib_eos`. This module contains the types and providers needed to run the Puppet agent on the network switch. 

2. Install the Puppet agent on your EOS instance. 

   a. Access your EOS instance as an admin user, or as a user with access to Privileged EXEC mode.

   b. Enable Privileged EXEC mode by running the following command,`enable`.
   
   c. Run the following command, `copy https://pm.puppetlabs.com/cgi-bin/download.cgi?ver=latest&dist=eos&arch=i386&rel=4 extension:`.

   > **Note**: If you’re unable to access the outside internet from your EOS instance, you may first need to download the agent package and then transfer it to your instance.
   
   d. Run the following command, `extension puppet-enterprise-3.7.2-eos-4-i386.swix`. This will install the Puppet agent on the EOS instance. 

   e. Log out as the admin user and log back into the EOS instance as `root`.
   
   f. Run the following command, `puppet config set server <PUPPET MASTER FQDN>`.  This will configure the agent to connect to your Puppet master.

   g. Run the following command,  `puppet agent --test` This will connect the agent to the Puppet master and create a certificate signing request (CSR) in the Puppet master's certificate authority (CA) for the new agent. 
  
3. On your Puppet master, sign the cert for your EOS instance. Run the following command, `puppet cert sign <EOS INSTANCE FQDN>`.

4. On the EOS instance, run the following command, `puppet agent -t`.

   The Puppet agent will retrieve its catalog and will now be fully functional. You'll see a message similar to the following: 

       Info: Retrieving pluginfacts
       Info: Retrieving plugin
       Info: Loading facts
       Info: Caching catalog for <EOS INSTANCE FQDN> 
       Info: Applying configuration version '1424214157'
       Notice: Finished catalog run in 0.46 seconds
    
## Uninstall the Puppet Agent from the EOS Instance

Note that if you are uninstalling/reinstalling the Puppet agent for testing purposes, you will need to follow these instructions completely to ensure you don't get SSL collisions when reinstalling. 

1. Access your EOS instance as an admin user. 
2. Enable Privileged EXEC mode by running the following command `enable`
3. Run the following commands:

      no extension puppet-enterprise-3.7.2-eos-4-i386.swix
      delete extension:puppet-enterprise-3.7.2-eos-4-i386.swix 
          
4. Delete the SSL keys from the EOS instance. Run the following command, `bash sudo rm -rf /persist/sys/etc/puppetlabs/`. 
5. On your Puppet master, revoke the cert for the Puppet agent on the EOS instance. Run the following command, `puppet cert clean <EOS INSTANCE FQDN>`. 

   This will revoke the agent certificate and delete related files on Puppet Master. You'll see a message similar to the following: 
   
       Notice: Revoked certificate with serial 10
       Notice: Removing file Puppet::SSL::Certificate <EOS INSTANCE FQDN> at '/etc/puppetlabs/puppet/ssl/ca/signed/<EOS INSTANCE FQDN>.pem'
       Notice: Removing file Puppet::SSL::Certificate <EOS INSTANCE FQDN> at '/etc/puppetlabs/puppet/ssl/certs/<EOS INSTANCE FQDN>.pem'
