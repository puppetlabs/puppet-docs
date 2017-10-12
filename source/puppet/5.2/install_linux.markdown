---
layout: default
title: "Installing Puppet agent: Linux"
---

[master_settings]: ./config_important_settings.html#settings-for-puppet-master-servers
[agent_settings]: ./config_important_settings.html#settings-for-agents-all-nodes
[where]: ./whered_it_go.html
[dns_alt_names]: /puppet/latest/configuration.html#dnsaltnames
[server_heap]: {{puppetserver}}/install_from_packages.html#memory-allocation
[puppetserver_confd]: {{puppetserver}}/configuration.html
[server_install]: {{puppetserver}}/install_from_packages.html
[modules]: ./modules_fundamentals.html
[main manifest]: ./dirs_manifest.html
[environments]: ./environments.html
[`puppet-agent`]: ./about_agent.html

Install the Puppet agent so that your master can communicate with your Linux nodes.

**Before you begin**: Review the [pre-install tasks](./install_pre.html) and [installing Puppet Server][server_install].

1. Install a release package to [enable Puppet Platform repositories](./puppet_platform.html).

2. Confirm that you can run Puppet executables.

   The location for Puppet's executables is `/opt/puppetlabs/bin/`, which is not in your `PATH` environment variable by default.

   The executable path doesn't matter for Puppet services --- for instance, `service puppet start` works regardless of the `PATH` --- but if you're running interactive `puppet` commands, you must either add their location to your `PATH` or execute them using their full path.

   To quickly add the executable location to your `PATH` for your current terminal session, use the command `export PATH=/opt/puppetlabs/bin:$PATH`. You can also add this location wherever you configure your `PATH`, such as your `.profile` or `.bashrc` configuration files.

   For more information, see details about [file and directory locations][where].

4. Install the `puppet-agent` package on your Puppet agent nodes using the command appropriate to your system:

   * Yum -- `sudo yum install puppet-agent`.
   * Apt -- `sudo apt-get install puppet-agent`.

5. (Optional) Configure agent settings.

   For example, if your master isn't reachable at the default address, `server = puppet`, set the `server` setting to your Puppet master's hostname.

   For other settings you might want to change, see a [list of agent-related settings][agent_settings].

6. Start the `puppet` service: `sudo /opt/puppetlabs/bin/puppet resource service puppet ensure=running enable=true`.

7. (Optional) To see a sample of Puppet agent's output and verify any changes you may have made to your configuration settings in step 5, manually launch and watch a Puppet run:
   `sudo /opt/puppetlabs/bin/puppet agent --test`

8. Sign certificates on the certificate authority (CA) master.

   On the Puppet master:

   1. Run `sudo /opt/puppetlabs/bin/puppet cert list` to see any outstanding requests.
   2. Run `sudo /opt/puppetlabs/bin/puppet cert sign <NAME>` to sign a request.

   As each Puppet agent runs for the first time, it submits a certificate signing request (CSR) to the CA Puppet master. You must log into that server to check for and sign certificates. After an agent's certificate is signed, it regularly fetches and applies configuration catalogs from the Puppet master.