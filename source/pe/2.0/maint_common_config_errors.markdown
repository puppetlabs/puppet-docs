---
layout: default
title: "PE 2.0 » Maintenance and Troubleshooting » Common Config Errors"
canonical: "/pe/latest/trouble_install.html"
---

* * *

&larr; [PE Accounts Module: The `pe_accounts` Class](./accounts_class.html) --- [Index](./) --- [Maintenance: Console Maintenance Tasks](./maint_maintaining_console.html) &rarr;

* * *

Troubleshooting Common Configuration Errors
=====

The Installer is Failing!
-----

Here are the main problems that can cause an install to blow up.

### Is DNS Wrong?

If name resolution at your site isn't quite behaving right, PE's installer can go haywire.

* Puppet agent has to be able to reach the puppet master server at one of its valid DNS names. (Specifically, the name you identified as the master's hostname during the installer interview.)
* The puppet master also has to be able to reach **itself** at the puppet master hostname you chose during installation.
* If you've split the master and console roles onto different servers, they have to be able to talk to each other as well. 

### Are the Security Settings Wrong?

The installer fails in a similar way when the system's firewall or security group is restricting the ports Puppet uses.

* Puppet communicates on **ports 8140, 61613, and 443.** If you are installing the puppet master and the console on the same server, it must accept inbound traffic on all three ports. If you've split the two roles, the master must accept inbound traffic on 8140 and 61613, and the console must accept inbound traffic on 8140 and 443.
* If your puppet master has multiple network interfaces, make sure it is allowing traffic via the IP address that its valid DNS names resolve to, not just via an internal interface. 

### Did You Try to Install the Console Before the Puppet Master?

If you are installing the console and the puppet master on separate servers and tried to install the console first, the installer may fail. 

### How Do I Recover From a Failed Install?

[uninstaller]: ./files/puppet-enterprise-uninstaller

First, fix any configuration problem that may have caused the install to fail; see above for a list of the most common errors. 

Next, download, move, and run the uninstaller script. (This script was not included in Puppet Enterprise 2.0, but will be included in all future releases.)

* [Click here to download the uninstaller][uninstaller], or use `curl` or `wget` to download it directly to the target machine.
* Copy the uninstaller to the target machine, and move it into the directory which contains the installer script. The uninstaller and the installer _must_ be in the same directory.
* Make the uninstaller executable, then run it:

        $ sudo chmod +x puppet-enterprise-uninstaller
        $ sudo ./puppet-enterprise-uninstaller

After you have run the uninstaller, you can safely run the installer again.

Agent Nodes Can't Retrieve Their Configurations!
-----

### Is the Puppet Master Reachable From the Agents?

Although this would probably have caused a problem during installation, it's worth checking it first. You can check whether the master is reachable and active by trying:

    $ telnet <puppet master's hostname> 8140

If the puppet master is alive and reachable, you'll get something like: 

    Trying 172.16.158.132...
    Connected to screech.example.com.
    Escape character is '^]'.

Otherwise, it will return something like "nodename nor servname provided, or not known."

To fix this, make sure the puppet master server is reachable at the DNS name your agents know it by, and make sure that the `pe-httpd` service is running. 

### Can the Puppet Master Reach the Console?

The puppet master depends on the console for the names of the classes an agent node should get. If it can't reach the console, it can't compile configurations for nodes.

Check the puppet agent logs  on your nodes, or run `puppet agent --test` on one of them; if you see something like `err: Could not retrieve catalog from remote server: Error 400 on SERVER: Could not find node 'agent01.example.com'; cannot compile`, the master may be failing to find the console.

To fix this, make sure that the console is alive by [navigating to its web interface](./console_navigating.html). If it can't be reached, make sure DNS is set up correctly for the console server, and ensure that the `pe-httpd` service on it is running. 

If the console is alive and reachable from the master but the master can't retrieve node info from it, the master may be configured with the wrong console hostname. You'll need to:

* Edit the `reporturl` setting in the master's `/etc/puppetlabs/puppet/puppet.conf` file to point to the correct host.
* Edit the `ENC_BASE_URL` variable in the master's `/etc/puppetlabs/puppet-dashboard/external_node` file to point to the correct host. 

### Do Your Agents Have Signed Certificates?

Check the puppet agent logs  on your nodes and look for something like the following: 

    warning: peer certificate won't be verified in this SSL session

If you see this, it means the agent has submitted a certificate signing request which hasn't yet been signed. Run `puppet cert list` on the puppet master to see a list of pending requests, then run `puppet cert sign <NODE NAME>` to sign a given node's certificate. The node should successfully retrieve and apply its configuration the next time it runs. 

### Do Agents Trust the Master's Certificate?

Check the puppet agent logs  on your nodes and look for something like the following: 

    err: Could not retrieve catalog from remote server: SSL_connect returned=1 errno=0
    state=SSLv3 read server certificate B: certificate verify failed.  This is often
    because the time is out of sync on the server or client

This could be one of several things. 

#### Are Agents Contacting the Master at a Valid DNS Name?

When you installed the puppet master role, you approved a list of valid DNS names to be included in the master's certificate. **Agents will ONLY trust the master if they contact it at one of THESE hostnames.**

To check the hostname agents are contacting the master at, run `puppet agent --configprint server`. If this is not one of the valid DNS names you chose during installation of the master, edit the `server` setting in the agents' `/etc/puppetlabs/puppet/puppet.conf` files to point to a valid DNS name.

If you need to reset your puppet master's valid DNS names, run the following:

    $ /etc/init.d/pe-httpd stop
    $ puppet cert clean <puppet master's certname>
    $ puppet cert generate <puppet master's certname> --dns_alt_names=<comma-separated list of DNS names>
    $ /etc/init.d/pe-httpd start

#### Is Time in Sync on Your Nodes?

...and was time in sync when your certificates were created?

Compare the output of `date` on your nodes. Then, run the following command on the puppet master to check the validity dates of a given certificate:

    $ openssl x509 -text -noout -in $(puppet master --configprint ssldir)/certs/<NODE NAME>.pem

* If time is out of sync, get it in sync. Keep in mind that NTP can behave unreliably on virtual machines. 
* If you have any certificates that aren't valid until the future...
    * Delete the certificate on the puppet master with `puppet cert clean <NODE NAME>`.
    * Delete the SSL directory on the offending agent with `rm -rf $(puppet agent --configprint ssldir)`.
    * Run `puppet agent --test` on that agent to generate a new certificate request, then sign that request on the master with `puppet cert sign <NODE NAME>`.

#### Did You Previously Have an Unrelated Node With the Same Certname?

If a node re-uses an old node's certname and the master retains the previous node's certificate, the new node will be unable to request a new certificate.

Run the following on the master:

    $ puppet cert clean <NODE NAME>

Then, run the following on the agent node:

    $ rm -rf $(puppet agent --configprint ssldir)
    $ puppet agent --test

This should properly generate a new signing request.

### Can Agents Reach the Filebucket Server?

Agents attempt to back up files to the puppet master, but they get the filebucket hostname from the site manifest instead of their configuration file. If puppet agent is logging "could not back up" errors, your nodes are probably trying to back up files to the wrong hostname. These errors look like this: 

    err: /Stage[main]/Pe_mcollective/File[/etc/puppetlabs/mcollective/server.cfg]/content:
    change from {md5}778087871f76ce08be02a672b1c48bdc to
    {md5}e33a27e4b9a87bb17a2bdff115c4b080 failed: Could not back up
    /etc/puppetlabs/mcollective/server.cfg: getaddrinfo: Name or service not known

This usually happens when puppet master is installed with a certname that isn't its hostname. To fix these errors, edit `/etc/puppetlabs/puppet/manifests/site.pp` **on the puppet master** so that the following resource's `server` attribute points to the correct hostname:

~~~ ruby
    # Define filebucket 'main':
    filebucket { 'main':
      server => '<PUPPET MASTER'S DNS NAME>',
      path   => false,
    }
~~~

Changing this on the puppet master will fix the error on all agent nodes.

`node_vmware` and `node_aws` Aren't Working!
-----

If the [cloud provisioning actions](./cloudprovisioner_overview.html) are failing with an "err: Missing required arguments" message, you need to [create a `~/.fog` file and populate it with the appropriate credentials](./cloudprovisioner_configuring.html). 

* * *

&larr; [PE Accounts Module: The `pe_accounts` Class](./accounts_class.html) --- [Index](./) --- [Maintenance: Console Maintenance Tasks](./maint_maintaining_console.html) &rarr;

* * *

