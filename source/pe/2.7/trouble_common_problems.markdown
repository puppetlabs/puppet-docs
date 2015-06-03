---
layout: default
title: "PE 2.7  » Troubleshooting » Common Problems & Solutions"
subtitle: "Troubleshooting Common Errors"
canonical: "/pe/latest/trouble_install.html"
---

The Installer is Failing
-----

Here are the main problems that can cause an install to blow up.

### Is DNS Wrong?

If name resolution at your site isn't quite behaving right, PE's installer can go haywire.

* Puppet agent has to be able to reach the puppet master server at one of its valid DNS names. (Specifically, the name you identified as the master's hostname during the installer interview.)
* The puppet master also has to be able to reach **itself** at the puppet master hostname you chose during installation.
* If you've split the master and console roles onto different servers, they have to be able to talk to each other as well.

### Are the Security Settings Wrong?

The installer fails in a similar way when the system's firewall or security group is restricting the ports Puppet uses.

* Puppet communicates on **ports 8140, 61613, and 443.** If you are installing the puppet master and the console on the same server, it must accept inbound traffic on all three ports. If you've split the two roles, the master must accept inbound traffic on 8140 and 61613 and the console must accept inbound traffic on 8140 and 443.
* If your puppet master has multiple network interfaces, make sure it is allowing traffic via the IP address that its valid DNS names resolve to, not just via an internal interface.

### Did You Try to Install the Console Before the Puppet Master?

If you are installing the console and the puppet master on separate servers and tried to install the console first, the installer may fail.

### How Do I Recover From a Failed Install?

First, fix any configuration problem that may have caused the install to fail. See above for a list of the most common errors.

Next, run the uninstaller script. [See the uninstallation instructions in this guide](./install_uninstalling.html) for full details.

After you have run the uninstaller, you can safely run the installer again.

Agent Nodes Can't Retrieve Their Configurations
-----

### Is the Puppet Master Reachable From the Agents?

Although this would probably have caused a problem during installation, it's worth checking it first. You can check whether the master is reachable and active by trying:

    $ telnet <puppet master's hostname> 8140

If the puppet master is alive and reachable, you'll get something like:

    Trying 172.16.158.132...
    Connected to screech.example.com.
    Escape character is '^]'.

Otherwise, it will return something like "name or service not known."

To fix this, make sure the puppet master server is reachable at the DNS name your agents know it by and make sure that the `pe-httpd` service is running.

### Can the Puppet Master Reach the Console?

The puppet master depends on the console for the names of the classes an agent node should get. If it can't reach the console, it can't compile configurations for nodes.

Check the puppet agent logs  on your nodes, or run `puppet agent --test` on one of them; if you see something like `err: Could not retrieve catalog from remote server: Error 400 on SERVER: Could not find node 'agent01.example.com'; cannot compile`, the master may be failing to find the console.

To fix this, make sure that the console is alive by [navigating to its web interface](./console_navigating.html). If it can't be reached, make sure DNS is set up correctly for the console server and ensure that the `pe-httpd` service on it is running.

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

To see the hostname agents are using to contact the master, run `puppet agent --configprint server`. If this does not return one of the valid DNS names you chose during installation of the master, edit the `server` setting in the agents' `/etc/puppetlabs/puppet/puppet.conf` files to point to a valid DNS name.

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
* If you have any certificates that aren't valid until the future:
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

Agents attempt to back up files to the filebucket on the puppet master, but they get the filebucket hostname from the site manifest instead of their configuration file. If puppet agent is logging "could not back up" errors, your nodes are probably trying to back up files to the wrong hostname. These errors look like this:

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

`node_vmware` and `node_aws` Aren't Working
-----

If the [cloud provisioning actions](./cloudprovisioner_overview.html) are failing with an "err: Missing required arguments" message, you need to [create a `~/.fog` file and populate it with the appropriate credentials](./cloudprovisioner_configuring.html).

The Console Has Too Many Pending Tasks
-----

The console either does not have enough worker processes, or the worker processes have died and need to be restarted.

* [See here to restart the worker processes](./console_maintenance.html#restarting-the-background-tasks)
* [See here to tune the number of worker processes](./config_advanced.html#fine-tuning-the-delayedjob-queue)

Console Account Confirmation Emails Have Incorrect Links
-----

This can happen if the console's authentication layer thinks it lives on a hostname that isn't accessible to the rest of the world. The authentication system's hostname is automatically detected during installation, and the installer can sometimes choose an internal-only hostname.

To fix this:

1. Open the `/etc/puppetlabs/console-auth/cas_client_config.yml` file for editing. Locate the `cas_host` line, which is likely commented-out:

        authentication:

          ## Use this configuration option if the CAS server is on a host different
          ## from the console-auth server.
          # cas_host: console.example.com:443

    Change its value to contain the **public hostname** of the console server, including the correct port.
2. Open the `/etc/puppetlabs/console-auth/config.yml` file for editing. Locate the `console_hostname` line:

        authentication:
          console_hostname: console.example.com

    Change its value if necessary. If you are serving the console on a port other than 443, be sure to add the port. (For example: `console.example.com:3000`)

InnoDB is Taking Up Too Much Disk Space
-----

Over time, the innodb database can get quite hefty, especially in larger deployments with many nodes. In some cases it can get large enough to consume all the space in `var`, which makes bad things happen. When this happens, you can follow the steps below to slim it back down.

1. Move your existing data to a backup file by running: `# mysqldump -p --databases console console_auth console_inventory_service > /path/to/backup.sql`

2. Stop the MySQL service

3. Remove *just* the PE-specific database files. If you have no other databases, you can run `# cd /var/lib/mysql # rm -rf ./ib*`. *Warning:* this will remove everything, including any db's you may have added.

4. Restart the MySQL service.

5. Create new, empty databases by running this rake task: `# /opt/puppet/bin/rake -f /opt/puppet/share/puppet-dashboard/Rakefile RAILS_ENV=production /opt/puppet/bin/rake db:reset`.

6. Repopulate the databases by importing the data from the backup you created in step 1 by running: `# mysql -p < /path/to/backup.sql`.

Troubleshooting Issues on Windows
-----

Refer to the [Windows Troubleshooting page](/windows/troubleshooting.html) for tips and  advice to help you resolve common issues when running PE on Windows.

* * *

- [Next: Appendix](./appendix.html)
