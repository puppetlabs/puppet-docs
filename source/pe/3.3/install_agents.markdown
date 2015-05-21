---
layout: default
title: "PE 3.3 » Installing » Installing PE Agents"
subtitle: "Installing Puppet Enterprise Agents"
canonical: "/pe/latest/install_agents.html"
---

Installing Agents
-----

If you have a supported OS that is capable of using remote package repos, the simplest way to install the PE agent is with standard *nix package management tools. 

> ### About Windows Agent Installation
>
> Windows cannot be installed using the package management instructions outlined below. 
>
> To install the agent on a node running the Windows OS, refer to the [installing Windows agent instructions](./install_windows.html).

### Installing Agents Using PE Package Management

If your infrastructure does not currently host a package repository, PE hosts a package repo on the master that corresponds to the OS and architecture of the master node. The repo is created during installation of the master. The repo serves packages over HTTPS using the same port as the puppet master (8140). This means agents won't require any new ports to be open other than the one they already need to communicate with the master.

You can also add repos for any PE-supported OS and architecture by creating a new repository for that platform. 

>**Warning**: Installing agents using the `pe_repo` class requires an internet connection. If you don't have access to the internet, refer to [Installing Agents in a Puppet Enterprise Infrastructure without Internet Access](#installing-agents-in-a-puppet-enterprise-infrastructure-without-internet-access).  

When you run the installation script on your agent, the script will detect the OS on which it is running, set up an apt (or yum, or zypper) repo that refers back to the master, pull down and install the `pe-agent` packages, and create a simple `puppet.conf` file. The certname for the agent node installed this way will be the value of `facter fqdn`.

Note that if install.bash can't find agent packages corresponding to the agent's platform, it will fail with an error message telling you which `pe_repo` class you need to add to the master.

After you’ve installed the agent on the target node, you can configure it using [`puppet config set`][config_set]. See [Configuring Agents](#Configuring-Agents) below.

#### Using the PE Agent Package Installation Script

>**Note**: The `<master hostname>` portion of the installer script--as provided in the following examples--refers to the FQDN of the puppet master. In a monolithic install, this is the same node on which you installed the puppet master, console, and PuppetDB components; in a split install, this is the node you assigned to the puppet master component. Note that if you've already logged into the console, you can find the exact script with the correct master hostname for your installation by clicking on **node requests** in the top right-hand corner of the console. (You do not need to have pending node requests to click.) 

**Scenario 1**: The OS/architecture of the Puppet master and the agent node are the same.

Simply SSH into the node where you want to install the PE agent, and run `curl -k https://<master hostname>:8140/packages/current/install.bash | sudo bash`.

This script will detect the OS on which it is running, set up an apt, yum, or zipper repo that refers back to the Puppet master, and then pull down and install the `pe-agent` packages. It will also create a basic `puppet.conf`, and kick off a puppet run.

Note that you can replace `current` in the script with a specific PE version number, in the form of `3.x.x`.

>**Note**: The `-k` flag is needed in order to get `curl` to trust the master, which it wouldn't otherwise since Puppet and its SSL infrastructure have not yet been set up on the node. 
>   
>However, users of AIX 5.3, 6.1, and 7.1 should note that the `-k` is not supported. You should replace the `-k` flag with `-tlsv1` or `-1`. 
>
>In some cases, you may be using `wget` instead of `curl`---please use the appropriate flags as needed.

> After the installation is complete, continue on to [Signing Agent Certificates](#signing-agent-certificates).

**Scenario 2**: The OS/architecture of the Puppet master and the agent node are different.  

As an example, if your master is on a node running EL6 and you want to add an agent node running Debian 6 on AMD64 hardware:

1. Use the console to add the `pe_repo::platform::debian_6_amd64` class.

   a. From the sidebar of the console, click **Add Classes**.
   
   b. From the **Available Classes** page, in the list of classes, locate `pe_repo::platform::debian_6_amd64`, and select it. 
   
   c. Click __Add selected classes__.
   
   d. Navigate to the node page for your puppet master.
   
   e. Click __Edit__ and begin typing "`pe_repo::platform::debian_6_amd64`" in the __Classes__ field; you can select the class from the list of autocomplete suggestions. 
   
   f. Click __Update__. 
   
2. To create the new repo containing the agent packages, use live management to kick off a puppet run.

   a. Navigate to the live management page, and select the __Control Puppet__ tab.
   
   b. Select only the puppet master node. (If you have other agents installed, they do not need to run at this time.)
    
   c. Click the __runonce__ action and then __Run__ to trigger a puppet run 

   The new repo is created in `/opt/puppet/packages/public`. It will be called `puppet-enterprise-3.3.0-debian-6-amd64-agent`.
   
3. SSH into the node where you want to install the agent, and run `curl -k https://<master hostname>:8140/packages/current/install.bash | sudo bash`.

    The script will install the PE agent packages, create a basic `puppet.conf`, and kick off a puppet run.

   >**Note**: The `-k` flag is needed in order to get `curl` to trust the master, which it wouldn't otherwise since Puppet and its SSL infrastructure have not yet been set up on the node. 
>   
>However, users of AIX 5.3, 6.1, and 7.1 should note that the `-k` is not supported. You should replace the `-k` flag with `-tlsv1` or `-1`. 
>
>In some cases, you may be using `wget` instead of `curl`---please use the appropriate flags as needed.

4. After the installation is complete, continue on to [Signing Agent Certificates](#signing-agent-certificates).
   
#### About the Platform-Specific Install Script

The `install.bash` script actually uses a secondary script to retrieve and install an agent package repo once it has detected the platform on which it is running. You can use this secondary script if you want to manually specify the platform of the agent packages. You can also use this script as an example or as the basis for your own custom scripts.
 
The script can be found at `https://<master hostname>:8140/packages/current/<platform>.bash`, where `<platform>` uses the form `el-6-x86_64`. Platform names are the same as those used for the PE tarballs:

     - el-{5, 6}-{i386, x86_64}
     - debian-{6, 7}-{i386, amd64}
     - ubuntu-{10.04, 12.04}-{i386, amd64}
     - sles-11-{i386, x86_64}

> **Warning**: If the puppet master and agent differ in architecture and OS type/version, the correct `pe_repo` class for the agent must be assigned to the puppet master node before running the script. If you have not added the correct agent class and run the script, you will get an error message returned by `curl` similar to, `the indirection name must be purely alphanumeric, not <'3.2.0-15-gd7f6fa6'>`. This error is safe to ignore, but you will need to be sure you add the correct `pe_repo` class for the agent to the puppet master before running the script again.

#### Installing Agents in a Puppet Enterprise Infrastructure without Internet Access

When installing agents on a platform that is different from the puppet master platform, the agent install script attempts to connect to the internet to download the appropriate agent tarball after you classify the puppet master, as described in [Installing Agents Using PE Package Management](#installing-agents-using-pe-package-management).

If your PE infrastructure does not have access to the outside internet, you will not be able to fully use the agent installation instructions.  Instead, you will need to [download](http://puppetlabs.com/misc/pe-files/agent-downloads) the appropriate agent tarball in advance and use the option below that corresponds to your deployment needs. 

* **Option 1**

    If you would like to use the PE-provided repo, you can copy the agent tarball into the `/opt/staging/pe_repo` directory on your master.

    Note that if you upgrade your server at any point, you will need to perform this task again for the new version.

* **Option 2**

    If you already have a package management/distribution system, you can use it to install agents by adding the agent packages to your own repo. In this case, you can disable the PE-hosted repo feature altogether by [removing](./console_classes_groups.html#classes) the `pe_repo` class from your master, along with any class that starts with `pe_repo::`.

    Note that if you upgrade your server, you will need to perform this task again for the new version.

* **Option 3**

    If your deployment has multiple masters and you don't wish to copy the agent tarball to each one, you can specify a path to the agent tarball. This can be done with an [answer file](./install_automated.html), by setting `q_tarball_server` to an accessible server containing the tarball, or by [using the console](./console_classes_groups.html#editing-class-parameters-on-nodes) to set the `base_path` parameter of the `pe_repo` class to an accessible server containing the tarball.


### Installing Agents Using Your Package Management Tools

If you are currently using native package management, you will need to perform the following steps:

1. Add the agent packages to the appropriate repo.

2. Configure your package manager (yum, apt) to point to that repo.

3. Install the packages as you would any other packages. 

Agent packages can be found on the puppet master, in `/opt/puppet/packages/public`. This directory contains agent packages that correspond to the puppet master's OS/architecture. For example, if your puppet master is running on Debian 7, in `/opt/puppet/packages/public`, you will find the directory `puppet-enterprise-3.3.0-debian-7-amd64-agent/debian-7-amd64`, which contains a directory with all the packages needed to install an agent. You will also find a JSON file that lists the versions of those packages. (All agent package repos follow the naming convention `<installed PE version & OS platform>-agent/agent_packages`.)

If your nodes are running an OS and/or architecture that is different from the master, [download the appropriate agent tarball](http://puppetlabs.com/misc/pe-files/agent-downloads), extract the agent packages into the appropriate repo, and then install the agents on your nodes just as you would any other package (e.g., `yum install pe-agent`). 

Alternatively, if you have internet access to your master node, you can follow the instructions above and [use the console](#installing-agents-using-pe-package-management) to classify the master with one of the built-in `pe_repo::platform::<platform>` classes. Once the master is classified and a puppet run has occurred, the appropriate agent packages will be generated and stored in `/opt/puppet/packages/public/<platform version>`. If your master does not have internet access, you will need to download the agents manually, and choose an option from [Installing Agents in a Puppet Enterprise Infrastructure without Internet Access](#installing-agents-in-a-puppet-enterprise-infrastructure-without-internet-access).

After you've installed the agent on the target node, you can configure it using `puppet config set`. See "[Configuring Agents](#Configuring-Agents)" below.

### Configuring Agents

After you follow the installation steps above, your agent should be ready for management with Puppet Enterprise once you sign its certificate. However, if you need to perform additional configurations (e.g., for a Mac OS X installed from the command line), you can configure it (point it at the correct master, assign a certname, etc.) by editing `/etc/puppetlabs/puppet/puppet.conf` directly or by using [the `puppet config set` sub-command][config_set], which will edit `puppet.conf` automatically.

For example, to point the agent at a master called "master.example.com," run `puppet config set server master.example.com`. This will add the setting `server = puppetmaster.example.com` to the `[main]` section of `puppet.conf`. To set the certname for the agent, run `puppet config set certname agent.example.com`. For more details, see [the documentation for `puppet config set`][config_set].

>**Warning for Mac OS X users**: When performing a command line install of an agent on an OS X system, you must run  `puppet config set server` and `puppet config set certname` for the agent to function correctly. 

[config_set]: ./config_set.html

### Signing Agent Certificates

Before nodes with the puppet agent component can fetch configurations or appear in the console, an administrator needs to sign their certificate requests. This helps prevent unauthorized nodes from intercepting sensitive configuration data.

After the first puppet run, which the installer should trigger at the end of installation (or it can be triggered manually with `puppet agent -t`), the agent will automatically submit a certificate request to the puppet master. Before the agent can retrieve any configurations, a user will have to approve this certificate.

Node requests can be approved or rejected using the console's [certificate management capability](./console_cert_mgmt.html). Pending node requests are indicated in the main navigation bar. Click on this indicator to go to a page where you can see current requests, and then approve or reject them as needed.

![request management view](./images/console/request_mgmt_view.png)

Alternatively, you can use the command line interface (CLI), but note that **certificate signing with the CLI is done on the puppet master node**. To view the list of pending certificate requests, run:

    $ sudo puppet cert list

To sign one of the pending requests, run:

    $ sudo puppet cert sign <name>

After signing a new node's certificate, it may take up to 30 minutes before that node appears in the console and begins retrieving configurations. You can use live management or the CLI to trigger a puppet run manually on the node if you want to see it right away.

If you need to remove certificates (e.g., during reinstallation of a node), you can use the `puppet cert clean <node name>` command.

>**Tip**: After you finish installing your agents, follow the instructions in the [NTP Quick Start Guide](./quick_start_ntp.html) to have PE ensure time is in sync across your deployment.

---------
    
- [Next: Upgrading](./install_upgrading.html)    
