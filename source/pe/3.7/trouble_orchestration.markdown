---
layout: default
title: "PE 3.7 » Troubleshooting » Orchestration"
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

Increasing the ulimit for the `pe-activemq` User
--------

The ulimit controls the number of processes and file handles that the `pe-activemq` user can open/process. To increase the ulimit for the `pe-activemq` user, edit `/etc/security/limits.conf` so that it contains the following: 

    pe-activemq   soft     nproc  8192
    pe-activemq   hard     nproc  8192
    pe-activemq   soft     nofile 16384
    pe-activemq   hard     nofile 16384   
  
Accessing the ActiveMQ Console
----------

In some cases, you may need to access the ActiveMQ console to troubleshoot orchestration messages, which are handled by the `pe-activemq` service. To do this, you will need to enable the ActiveMQ console from within the PE console by editing the `enable_web_console` parameter of the `puppet_enterprise::profile::amq::broker` class. The ActiveMQ node can be reached from whichever node has the `puppet_enterprise::profile::amq::broker` class. 

To activate the ActiveMQ console:

1. **On the Puppet master**, navigate to `/etc/puppetlabs/activemq/jetty.xml`. 

2. Edit `jetty.xml` so that the `"host"` value of the `"connectors"` property is set to `"0.0.0.0"`, as shown in the following example:

       <property name="connectors">
               <list>
                   <bean id="Connector" class="org.eclipse.jetty.server.nio.SelectChannelConnector">
                       <property name="host" value="0.0.0.0"/>
                       <property name="port" value="8161" />
                   </bean>
               </list>
           </property>

3. In the PE console, click **Classification**.

4. Select the `PE ActiveMQ Rboker` group.

5. Click **Classes**.

6. Under the `puppet_enterprise::profile::amq::broker` class, set the `enable_web_console` parameter to `true`. 

5. Click **Add parameter**, and then click the Commit change button. 

You can reach the the ActiveMQ console from whichever node has the `puppet_enterprise::profile::amq::broker` class on port 8161 with `/admin` (e.g., `http://hostname:8161/admin`). 


AIX Agents Not Registering with Live Management After 3.0 Upgrade
-----

In some cases, the MCollective service on AIX agents may be stuck in the `stopping` state. In such cases, the agents will not come back up in live management after the upgrade. You can restore their connection by forcing the `pe-mcollective` process to die, by using the following commands on the agent:

    lssrc -s pe-mcollective   # note returned pid
    kill -9 <pid-of-pe-mcollective>
    
Running a 3.x Master with 2.8.x Agents is not Supported
----------
  
3.x versions of PE contain changes to the MCollective module that are not compatible with 2.8.x agents. When running a 3.x master with a 2.8.x agent, it is possible that Puppet will still continue to run and check into the console, but this means Puppet is running in a degraded state that is not supported.


* * * 

- [Next: Troubleshooting: Cloud Provisioner ](./trouble_cloudprovisioner.html)
