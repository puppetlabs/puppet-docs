---
layout: default
title: "PE 3.7 » Installing » Installing PE Agents"
subtitle: "Installing Puppet Enterprise Agents"
canonical: "/pe/latest/install_agents.html"
---

If you have a supported OS that is capable of using remote package repos, the simplest way to install the PE agent is with standard *nix package management tools. 

> ### About Windows Agent Installation
>
> Windows cannot be installed using the package management instructions outlined below. 
>
> To install the agent on a node running the Windows OS, refer to the [installing Windows agent instructions](./install_windows.html).

## Installing Agents Using PE Package Management

If your infrastructure does not currently host a package repository, PE hosts a package repo on the master that corresponds to the OS and architecture of the master node. The repo is created during installation of the master. The repo serves packages over HTTPS using the same port as the Puppet master (8140). This means agents won't require any new ports to be open other than the one they already need to communicate with the master.

You can also add repos for any PE-supported OS and architecture by creating a new repository for that platform. 

>**Warning**: Installing agents using the `pe_repo` class requires an internet connection. If you don't have access to the internet, refer to [Installing Agents in a Puppet Enterprise Infrastructure without Internet Access](#installing-agents-in-a-puppet-enterprise-infrastructure-without-internet-access).  

When you run the installation script on your agent, the script will detect the OS on which it is running, set up an apt (or yum, or zypper) repo that refers back to the master, pull down and install the `pe-agent` packages, and create a simple `puppet.conf` file. The certname for the agent node installed this way will be the value of `facter fqdn`.

Note that if install.bash can't find agent packages corresponding to the agent's platform, it will fail with an error message telling you which `pe_repo` class you need to add to the master.

After you’ve installed the agent on the target node, you can configure it using [`puppet config set`][config_set]. See [Configuring Agents](#Configuring-Agents) below.

### About the Platform-Specific Install Script

The `install.bash` script actually uses a secondary script to retrieve and install an agent package repo once it has detected the platform on which it is running. You can use this secondary script if you want to manually specify the platform of the agent packages. You can also use this script as an example or as the basis for your own custom scripts.
 
The script can be found at `https://<master hostname>:8140/packages/current/<platform>.bash`, where `<platform>` uses the form `el-6-x86_64`. Platform names are the same as those used for the PE tarballs:

     - el-{5, 6}-{i386, x86_64}
     - debian-{6, 7}-{i386, amd64}
     - ubuntu-{10.04, 12.04}-{i386, amd64}
     - sles-11-{i386, x86_64}

> **Warning**: If the Puppet master and agent differ in architecture and OS type/version, the correct `pe_repo` class for the agent must be assigned to the Puppet master node before running the script. If you have not added the correct agent class and run the script, you will get an error message returned by `curl` similar to, `the indirection name must be purely alphanumeric, not <'3.2.0-15-gd7f6fa6'>`. This error is safe to ignore, but you will need to be sure you add the correct `pe_repo` class for the agent to the Puppet master before running the script again.

## Using the PE Agent Package Installation Script

>**Note**: The `<master hostname>` portion of the installer script--as provided in the following examples--refers to the FQDN of the Puppet master. In a monolithic install, this is the same node on which you installed the Puppet master, console, and PuppetDB components; in a split install, this is the node you assigned to the Puppet master component. Note that if you've already logged into the console, you can find the exact script with the correct master hostname for your installation by clicking on **node requests** in the top right-hand corner of the console. (You do not need to have pending node requests to click.) 

### Scenario 1: The OS/architecture of the Puppet master and the agent node are the same.

Simply SSH into the node where you want to install the PE agent, and run `curl -k https://<master hostname>:8140/packages/current/install.bash | sudo bash`.

You can replace `current` in the script with a specific PE version number, in the form of `3.x.x`.

>**Note**: Depending on your platform, the method for downloading the script may vary. 

This script will detect the OS on which it is running, set up an apt, yum, or zipper repo that refers back to the Puppet master, and then pull down and install the `pe-agent` packages. It will also create a basic `puppet.conf`, and kick off a Puppet run.

**Tip**: see [Passing Configuration Parameters to the Install Script](#passing-configuration-parameters-to-the-install-script). 

> After the installation is complete, continue on to [Signing Agent Certificates](#signing-agent-certificates).

### Scenario 2: The OS/architecture of the Puppet master and the agent node are different. 

[classification_selector]: ./images/quick/classification_selector.png
[add_repo]: ./images/quick/add_repo.png
[commit_repo]: ./images/quick/commit_repo.png 

As an example, if your master is on a node running EL6 and you want to add an agent node running Debian 6 on AMD64 hardware:

1. From the console, click __Classification__ in the top navigation bar.

   ![classification selection][classification_selector]

2. From the __Classification page__, select the __PE Masters__ group.

3. Click the __Classes__ tab. 
   
4. In the __Class name__ field, begin typing `pe::repo`, and select the repo class from the list of classes.

   > **Note**: the repo classes are listed as `pe_repo::platform::<agent_os_version_architecture>`

   ![adding the repo class][add_repo]

5. Click __Add class__. 

6. Click __Commit 1 change__.

   ![committing the repo][commit_repo]

   **Note**: The `pe_repo::platform::debian_6_amd_64` class now appears in the list of classes for the __PE Masters__ group, but it has not yet been configured on your nodes. For that to happen, you need to kick off a Puppet run. 
   
7. Navigate to the live management page, and select the __Control Puppet__ tab. 

8. Click the __runonce__ action and then __Run__. This will configure the Puppet master node using the newly-assigned class.

   The new repo is created in `/opt/puppet/packages/public`. It’scalled `puppet-enterprise-3.7.0-<os-version-architecture>-agent`.

9. SSH into the Debian node where you want to install the agent, and run `curl -k https://<master.example.com>:8140/packages/current/install.bash | sudo bash`.

    The script will install the PE agent packages, create a basic `puppet.conf`, and kick off a Puppet run.
    
    **Tip**: see [Passing Configuration Parameters to the Install Script](#passing-configuration-parameters-to-the-install-script). 

   >**Note**: The `-k` flag is needed in order to get `curl` to trust the master, which it wouldn't otherwise since Puppet and its SSL infrastructure have not yet been set up on the node. 
>
>In some cases, you may be using `wget` instead of `curl`. Please use the appropriate flags as needed.

10. After the installation is complete, continue on to [Signing Agent Certificates](#signing-agent-certificates).

### Passing Configuration Parameters to the Install Script

ON *nix-based systems, you can pass parameters to the end of the install script to specify configuration settings, such as specifying a cert name, which will be added to `puppet.conf`. In this case you would run, `curl -k https://master.example.com:8140/packages/current/install.bash | sudo bash -s agent:certname=<certnameotherthanFQDN>`. 

You can pass as many parameters as you need to; be sure to follow the `section:key=value` pattern and just leave one space between parameters. Vist the [Configuration Reference](/references/3.7.latest/configuration.html) for a complete list of values. 
   
### Installing Agents in a Puppet Enterprise Infrastructure without Internet Access

When installing agents on a platform that is different from the Puppet master platform, the agent install script attempts to connect to the internet to download the appropriate agent tarball after you classify the Puppet master, as described in [Installing Agents Using PE Package Management](#installing-agents-using-pe-package-management).

If your PE infrastructure does not have access to the outside internet, you will not be able to fully use the agent installation instructions. Instead, you will need to [download](http://puppetlabs.com/misc/pe-files/agent-downloads) the appropriate agent tarball in advance and use the option below that corresponds to your deployment needs. 

* **Option 1**

    If you would like to use the PE-provided repo, you can copy the agent tarball into the `/opt/staging/pe_repo` directory on your master, and then follow the steps in [Using the PE Agent Package Installation Script](#using-the-pe-agent-package-installation-script) to complete the process. 

    Note that if you upgrade your server at any point, you will need to perform this task again for the new version.

* **Option 2**

    If you already have a package management/distribution system, you can use it to install agents by adding the agent packages to your own repo. In this case, you can disable the PE-hosted repo feature altogether by [removing](./console_classes_groups_making_changes.html#removing-classes-from-a-node-group) the `pe_repo` class from your master, along with any class that starts with `pe_repo::`.

    Note that if you upgrade your server, you will need to perform this task again for the new version.

* **Option 3**

    If your deployment has multiple masters and you don't wish to copy the agent tarball to each one, you can specify a path to the agent tarball. This can be done with an [answer file](./install_automated.html), by setting `q_tarball_server` to an accessible server containing the tarball, or by [using the console](./console_classes_groups.html#defining-the-data-used-by-classes) to set the `base_path` parameter of the `pe_repo` class to an accessible server containing the tarball.

## Installing Agents Using Your Package Management Tools

If you are currently using native package management, you will need to perform the following steps:

1. Add the agent packages to the appropriate repo.

2. Configure your package manager (yum, apt) to point to that repo.

3. Install the packages as you would any other packages. 

Agent packages can be found on the Puppet master, in `/opt/puppet/packages/public`. This directory contains agent packages that correspond to the Puppet master's OS/architecture. For example, if your Puppet master is running on Debian 7, in `/opt/puppet/packages/public`, you will find the directory `puppet-enterprise-3.7.0-debian-7-amd64-agent/debian-7-amd64`, which contains a directory with all the packages needed to install an agent. You will also find a JSON file that lists the versions of those packages. (All agent package repos follow the naming convention `<installed PE version & OS platform>-agent/agent_packages`.)

If your nodes are running an OS and/or architecture that is different from the master, [download the appropriate agent tarball](http://puppetlabs.com/misc/pe-files/agent-downloads), extract the agent packages into the appropriate repo, and then install the agents on your nodes just as you would any other package (e.g., `yum install pe-agent`). 

Alternatively, if you have internet access to your master node, you can follow the instructions above and [use the console](#installing-agents-using-pe-package-management) to classify the master with one of the built-in `pe_repo::platform::<platform>` classes. Once the master is classified and a Puppet run has occurred, the appropriate agent packages will be generated and stored in `/opt/puppet/packages/public/<platform version>`. If your master does not have internet access, you will need to download the agents manually, and choose an option from [Installing Agents in a Puppet Enterprise Infrastructure without Internet Access](#installing-agents-in-a-puppet-enterprise-infrastructure-without-internet-access).

After you've installed the agent on the target node, you can configure it using `puppet config set`. See "[Configuring Agents](#configuring-agents)" below.

## Signing Agent Certificates

Before nodes with the Puppet agent component can fetch configurations or appear in the console, an administrator needs to sign their certificate requests. This helps prevent unauthorized nodes from intercepting sensitive configuration data.

After the first Puppet run, which the installer should trigger at the end of installation (or it can be triggered manually with `puppet agent -t`), the agent will automatically submit a certificate request to the Puppet master. Before the agent can retrieve any configurations, a user will have to approve this certificate.

Node requests can be approved or rejected using the console. Pending node requests are indicated in the main navigation bar. 

[node_request]: ./images/console/request_indicator.png

**To sign certificates using the console**:

1. From the console, note the pending __node requests__ indicator in the upper right corner. Click it to load a list of currently pending node requests.

   ![Node Request Indicator][node_request]

2. Click the __Accept All__ button to approve all the requests and add the nodes.

   ![request management view](./images/console/request_mgmt_view.png)

Alternatively, you can use the command line interface (CLI), but note that **certificate signing with the CLI is done on the Puppet master node**. To view the list of pending certificate requests, run:

    $ sudo puppet cert list

To sign one of the pending requests, run:

    $ sudo puppet cert sign <name>

After signing a new node's certificate, it may take up to 30 minutes before that node appears in the console and begins retrieving configurations. You can use live management or the CLI to trigger a Puppet run manually on the node if you want to see it right away.

If you need to remove certificates (e.g., during reinstallation of a node), you can use the `puppet cert clean <node name>` command.

## Configuring Agents

After you follow the installation steps above, your agent should be ready for management with Puppet Enterprise once you sign its certificate. However, if you need to perform additional configurations (e.g., for a Mac OS X installed from the command line), you can configure it (point it at the correct master, assign a certname, etc.) by editing `/etc/puppetlabs/puppet/puppet.conf` directly or by using [the `puppet config set` sub-command][config_set], which will edit `puppet.conf` automatically.

For example, to point the agent at a master called "master.example.com," run `puppet config set server master.example.com`. This will add the setting `server = puppetmaster.example.com` to the `[main]` section of `puppet.conf`. To set the certname for the agent, run `puppet config set certname agent.example.com`. For more details, see [the documentation for `puppet config set`][config_set].

>**Warning for Mac OS X users**: When performing a command line install of an agent on an OS X system, you must run  `puppet config set server` and `puppet config set certname` for the agent to function correctly. 

[config_set]: /puppet/3.7/reference/config_set.html

>**Tip**: After you finish installing your agents, follow the instructions in the [NTP Quick Start Guide](./quick_start_ntp.html) to have PE ensure time is in sync across your deployment.

---------
    
- [Next: Upgrading](./install_upgrading.html)    
