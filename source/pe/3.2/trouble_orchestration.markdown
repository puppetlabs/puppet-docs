---
layout: default
title: "PE 3.2 » Troubleshooting » Orchestration"
subtitle: "Troubleshooting the Orchestration Engine"
canonical: "/pe/latest/trouble_orchestration.html"
---

Agents Not Appearing in Live Management
-----

If you alter an agent's name in `puppet.conf` or make other changes that affect how an agent is represented on the network, you may find that while the console shows the agent certificate request and, subsequently, shows it in node views, you still cannot perform orchestration tasks on it using live management. In such cases, you can often force it to reconnect by waiting a minute or two and then running `puppet agent -t` until you see output indicating the mcollective server has picked up the node. The output should look similar to:

    Notice: /Stage[main]/Pe_mcollective::Server/File[/etc/puppetlabs/mcollective/server.cfg]/content:
    --- /etc/puppetlabs/mcollective/server.cfg	2013-06-14 15:53:41.251544110 -0700
    +++ /tmp/puppet-file20130624-42806-157zyeq	2013-06-24 14:45:09.865182380 -0700
    @@ -7,7 +7,7 @@
    loglevel        = info
    daemonize       = 1

    -identity = crm02
    +identity = agent2.example.com
    # Plugins
    securityprovider           = ssl
    plugin.ssl_server_private = /etc/puppetlabs/mcollective/ssl/mcollective-private.pem
 
>**Tip**: You should also run NTP to verify that time is in sync across your deployment.  

Accessing the ActiveMQ Console
----------

In some cases, you may need to access the ActiveMQ console to troubleshoot orchestration messages, which are handled by the `pe-activemq` service. To do this, you will need to enable the ActiveMQ console from within the PE console by editing the `activemq_enable_web_console` parameter of the `pe_mcollective::role::master` class. The ActiveMQ node can be reached from whichever node has the `pe_mcollective::role::master` class. 

To activate the ActiveMQ console:

1. In the PE console, navigate to the __Groups__ page.

2. Select the `puppet_master` group.

3. From the `puppet_master` group page, click the __Edit__ button.

4. From the class list, select `pe_mcollective::role::master`.

5. From the `pe_mcollective::role::master parameters` dialog, set the `activemq_enable_web_console` parameter to `true`. 

6. Click the __Done__ button when finished.

You can access the ActiveMQ console on port 8161.


AIX Agents Not Registering with Live Management After 3.0 Upgrade
-----

In some cases, the MCollective service on AIX agents may be stuck in the `stopping` state. In such cases, the agents will not come back up in live management after the upgrade. You can restore their connection by forcing the `pe-mcollective` process to die, by using the following commands on the agent:

    lssrc -s pe-mcollective   # note returned pid
    kill -9 <pid-of-pe-mcollective>
    
Running a 3.x Master with 2.8.x Agents is not Supported
----------
  
3.x versions of PE contain changes to the MCollective module that are not compatible with 2.8.x agents. When running a 3.x master with a 2.8.x agent, it is possible that puppet will still continue to run and check into the console, but this means puppet is running in a degraded state that is not supported.


* * * 

- [Next: Troubleshooting: Cloud Provisioner ](./trouble_cloudprovisioner.html)
