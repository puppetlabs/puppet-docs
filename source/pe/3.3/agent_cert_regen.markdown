---
layout: default
title: "PE 3.3 » Deploying PE » Agent Cert Regen"
subtitle: "Regenerating a Puppet Agent Certificate"
canonical: "/pe/latest/agent_cert_regen.html"
---

From time to time, you may encounter a situation in which you need to regenerate a certificate for a puppet agent node. Perhaps there is a security vulnerability in your infrastructure that you can remediate with a certificate regeneration, or maybe you're receiving strange SSL errors on your puppet agent node that are preventing you from performing normal operations. 

The following steps explain how to regenerate a certificate for a puppet agent node using PE's built-in certificate authority (CA).

1. On the puppet master, run `puppet cert clean <node name>`.

2. On the puppet master, run `sudo /etc/init.d/pe-httpd restart.`

     Restarting pe-httpd will prevent the old cert from being used. 

3. On the puppet agent node, move `/etc/puppetlabs/puppet/ssl` to a back up directory, such as `/etc/puppetlabs/puppet/ssl_bak`. 

   >**Important**: Ensure you are on the puppet agent node when you do this. Backing up the ssl directory, as opposed to deleting it, will enable you to easily recover in the event of a problem. DO NOT perform step 3 on the puppet master.

4. On the puppet agent node, run `puppet agent -t`. 

   When you run this command, puppet will generate a new SSL key for the agent node and request a new certificate from the puppet master's built-in CA.

5. Finally, you will need to accept the puppet agent node’s certificate request [with the PE console’s request manager, or from the command line](./console_cert_mgmt.html#rejecting-and-approving-nodes). 

Once the puppet agent node’s certificate is signed, you can either manually kick off a puppet run from the console or command line, or wait for the agent to run based on the [runinterval](/puppet/latest/reference/configuration.html#runinterval), the default of which is 30 minutes. At this point, the agent will perform a full catalog run and can resume its role in your PE deployment. 
