---
layout: default
title: "PE 3.1 » Troubleshooting » Orchestration"
subtitle: "Troubleshooting the Orchestration Engine"
canonical: "/pe/latest/trouble_orchestration.html"
---

Agents Not Appearing in Live Management
-----

If you alter an agent's name in `puppet.conf` or make other changes that affect how an agent is represented on the network, you may find that while the console shows the agent certificate request and, subsequently, shows it in node views, you still cannot perform orchestration tasks on it using live management. In such cases, you can often force it to reconnect by waiting a minute or two and then running `puppet agent -t` until you see ouput indicating  the mcollective server has picked up the node. The output should look similar to:

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
 
 

AIX Agents Not Registering with Live Management After 3.0 Upgrade
-----

In some cases, the MCollective service on AIX agents may be stuck in the `stopping` state. In such cases, the agents will not come back up in live management after the upgrade. You can restore their connection by forcing the `pe-mcollective` process to die, by using the following commands on the agent:

    lssrc -s pe-mcollective   # note returned pid
    kill -9 <pid-of-pe-mcollective>


* * * 

- [Next: Troubleshooting: Cloud Provisioner ](./trouble_cloudprovisioner.html)
