---
layout: default
title: "PE 3.7 » Installing » Installing PE Overview"
subtitle: "Installing Puppet Enterprise Overview"
canonical: "/pe/latest/install_basic.html"
---


[downloadpe]: http://info.puppetlabs.com/download-pe.html

> ![windows logo](./images/windows-logo-small.jpg) This section covers \*nix operating systems. To install PE on Windows, see [Installing Windows Agents](./install_windows.html).

Installing Puppet Enterprise
-----

Your PE installation will go more smoothly if you know a few things in advance. Puppet Enterprise's functions are spread across several different components which get installed and configured when you run the installer. You can choose to install multiple components on a single node (a "monolithic install") or spread the components across multiple nodes (a "split install"), but you should note that the "agent" component gets installed on every node.

You should decide on your deployment needs before starting the install process. For each node where you will be installing a PE component, you should know the fully qualified domain name where that node can be reached and you should ensure that firewall rules are set up to allow access to the [required ports](./install_system_requirements.html#firewall-configuration).

With that knowledge in hand, the installation process will proceed in **three stages**:

1. You will choose an installation method.

2. You will install the main components of PE—the Puppet master, PuppetDB, database support, and the PE console. (Note that the Cloud Provisioner is installed by default when you run the web-based installer. If you plan on performing an installation with an answer file, you can disable the Cloud Provisioner installation.)

3. You will install the PE agent on all the nodes you wish to manage with PE. Refer to the [agent installation instructions](./install_agents.html)

### Choose an Installation Method

Before you begin, choose an installation method. We've provided a few paths to choose from.

- Perform a guided installation using the web-based interface. Think of this as an installation interview in which we ask you exactly how you want to install PE. If you're able to provide a few SSH credentials, this method will get you up and running fairly quickly. Choose from one of the following installation types:

   * [Monolithic installation](./install_pe_mono.html) (for up to 500 nodes)

   * [Split installation](./install_pe_split.html) (for 500-1500 nodes)

- Use the web-based interface to create an answer file that you can then add as an argument to the installer script to perform an installation (e.g., `sudo ./puppet-enterprise-installer -a ~/my_answers.txt`). Refer to [Installing with an Answer File](./install_automated.html), which provides an overview on installing PE with an answer file.

- Edit an answer file provided in the PE installation tarball. Check the [Answer File Reference Overview](./install_answer_file_reference.html) to get started.

See the [system requirements](./install_system_requirements.html) for any hardware-related specifications.

>**Note**: Before getting started, we recommend you read about [the Puppet Enterprise components](#about-puppet-enterprise-components) to familiarize yourself with the parts that make up a PE installation.

Downloading Puppet Enterprise
-----

Start by [downloading][downloadpe] the tarball for the current version of Puppet Enterprise, along with the GPG signature (.asc), from the Puppet Labs website.

### Choosing an Installer Tarball

Puppet Enterprise is distributed in tarballs specific to your OS version and architecture.

#### Available \*nix Tarballs

|      Filename ends with...        |                     Will install on...                 |
|-----------------------------------|-----------------------------------------------------|  |
| `-debian-<version and arch>.tar.gz`  | Debian                                           |
| `-el-<version and arch>.tar.gz`      | RHEL, CentOS, Scientific Linux, or Oracle Linux  |
| `-solaris-<version and arch>.tar.gz` | Solaris                                          |
| `-ubuntu-<version and arch>.tar.gz`  | Ubuntu LTS                                       |
| `-aix-<version and arch>.tar.gz`     | AIX                                              |
| `-sles-<version and arch>.tar.gz`    | SLES                                             |

*Note:* Bindings for SELinux are available on RHEL 5 and 6. They are not installed by default but are included in the installation tarball.

### Verifying the Installer

To verify the PE installer, you can import the Puppet Labs public key and run a cryptographic verification of the tarball you downloaded. The Puppet Labs public key is certified by Puppet Labs and is available from public keyservers, such as `pgp.mit.edu`,  as well as Puppet Labs. You'll need to have GnuPG installed and the GPG signature (.asc file) that you downloaded with the PE tarball.

To import the Puppet Labs public key, run:

    wget -O - https://downloads.puppetlabs.com/puppetlabs-gpg-signing-key.pub | gpg --import

The result should be similar to

    gpg: key 4BD6EC30: public key "Puppet Labs Release Key (Puppet Labs Release Key) <info@puppetlabs.com>" imported
    gpg: Total number processed: 1
    gpg:               imported: 1  (RSA: 1)

To print the fingerprint of our key, run:

    gpg --fingerprint 0x1054b7a24bd6ec30

You should also see an exact match of the fingerprint of our key, which is printed on the verification:

    Primary key fingerprint: 47B3 20EB 4C7C 375A A9DA  E1A0 1054 B7A2 4BD6 EC30

Next, verify the release signature on the tarball by running:

    $ gpg --verify puppet-enterprise-<version>-<platform>.tar.gz.asc

The result should be similar to

    gpg: Signature made Tue 18 Jun 2013 10:05:25 AM PDT using RSA key ID 4BD6EC30
    gpg: Good signature from "Puppet Labs Release Key (Puppet Labs Release Key)"

 **Note**: When you verify the signature but do not have a trusted path to one of the signatures on the release key, you will see a warning similar to

    Could not find a valid trust path to the key.
        gpg: WARNING: This key is not certified with a trusted signature!
        gpg:          There is no indication that the signature belongs to the owner.

This warning is generated because you have not created a trust path to certify who signed the release key; it can be ignored.

About Puppet Enterprise Components
---------

Before beginning installation, you should familiarize yourself with the following PE components.

### The Puppet Agent

The Puppet agent is most easily installed using a package manager (see [installing agents](./install_agents.html)). On platforms (Windows) that do not support remote package repos, you can use the installer script.

This component should be installed on **every node** in your deployment. When you install the Puppet master, PuppetDB, or console components, the Puppet agent component will be installed automatically on the machines assigned to those components.

Nodes with the puppet agent component can:

* run the Puppet agent daemon, which receives and applies configurations from the Puppet master.
* listen for orchestration messages and invoke orchestration actions.
* send data to the master for use by PuppetDB.

### The Puppet Master

In most deployments, you should install this component on **one node** (installing multiple Puppet masters requires additional configuration that is beyond the scope of this guide). The Puppet master must be a robust, dedicated server; see the [system requirements](./install_system_requirements.html) for details.

The Puppet master server can:

* compile and serve configuration catalogs to Puppet agent nodes.
* route orchestration messages through its ActiveMQ server.
* issue valid orchestration commands (from an administrator logged in as the `peadmin` user).

>**Note**: By default, the Puppet master will check for the availability of updates whenever the `pe-puppetserver` service restarts. In order to retrieve the correct update information, the master will pass some basic, anonymous information to Puppet Labs' servers. This behavior can be disabled. You can find the details on what is collected and how to disable upgrade checking in the correct answer file reference. If an update is available, a message will alert you.

### PuppetDB and Database Support

The PuppetDB component uses an instance of PostgreSQL that is either installed by PE or manually configured by you. In a monolithic installation, PuppetDB is installed on the same node as the console and Puppet master components. In a split install, PuppetDB is installed on its own server. During installation, you will be asked if you want this PostgreSQL instance to be installed by PE or if you want to use one you've already configured.

Database support for the console, role-based access control (RBAC), and the node classifier runs on the same instance of PostgreSQL as PuppetDB.

PuppetDB is the fast, scalable, and reliable data warehouse for PE. It caches data generated by PE, and gives you advanced features at awesome speed with a powerful API.

PuppetDB stores:

* the most recent facts from every node.
* the most recent catalog for every node.
* fourteen days (configurable) of event reports for every node (an optional, configurable setting).

If you want to set up a PuppetDB database manually, the [PuppetDB configuration documentation](/puppetdb/1.6/configure.html#using-postgresql) has more information.

### The PE Console

For a split installation, you install the console on its own dedicated server, but if you have a monolithic installation, you install it on the same server as all of the other PE components.

The console server can:

* serve the console web interface, which enables administrators to directly edit resources on nodes, trigger immediate Puppet runs, group and assign classes to nodes, view reports and graphs, view inventory information, and invoke orchestration actions.
* collect reports from and serve node information to the Puppet master.

#### Role-based Access Control (RBAC)

With RBAC, PE nodes can now be segmented so that tasks can be safely delegated to the right people. For example, RBAC allows segmenting of infrastructure across application teams so that they can manage their own servers without affecting other applications. Plus, to ease the administration of users and authentication, RBAC connects directly with standard directory services including Microsoft Active Directory and OpenLDAP.

For detailed information to get started with RBAC, see the [PE user's guide](./rbac_intro.html).


#### Node Classifier (NC)

PE 3.7.0 introduces the rules-based node classifier, which is the first part of the Node Manager app that was announced in September. The node classifier provides a powerful and flexible new way to organize and configure your nodes. We’ve built a robust, API-driven backend service and an intuitive new GUI that encourages a modern, cattle-not-pets approach to managing your infrastructure. Classes are now assigned at the group level, and nodes are dynamically matched to groups based on user-defined rules.

For a detailed overview of the new node classifier, refer to the [PE user's guide](./console_classes_groups.html).

>**Note**: Like PuppetDB and the database support components, RBAC and node classifier databases run on PostgreSQL, and you can use an existing PostgreSQL instance or have one created for you when you install PE. Note that if you are using an existing PostgreSQL instance, you will need the host name, user name, and user password for accessing these databases.

### The Console Databases

As indicated in the "Database Support" section above, the console database relies on data provided by a PostgreSQL database. You will either have PE install this database or configure one manually on your own. You only need to create the database instances---the console will populate them.

>**IMPORTANT**: If you are using an existing PostgreSQL instance, you will need the host name and port of the node you intend to use to provide database support, and you will also need the user passwords for accessing the databases.
>
>When performing split installations using an answer file, install the database support component before you install the console, so that you have access to the database users' passwords during installation of the console.

### The Cloud Provisioner

This component is automatically installed when you install PE using the web-based installation method. You can opt out of the cloud provisioning tools by performing an installation with an answers file. If you wish to use cloud provisioning, you should install PE on a system where administrators have shell access. Since it requires confidential information about your cloud accounts to function, it should be installed on a secure system.

Administrators can use the cloud provisioner tools to:

* create new VMware and Amazon EC2 virtual machine instances.
* install Puppet Enterprise on any virtual or physical system.
* add newly provisioned nodes to a group in the console.

Notes, Warnings, and Tips
---------

### Verifying Your License

When you purchased Puppet Enterprise, you should have been sent a `license.key` file that lists how many nodes you can deploy. For PE to run without logging license warnings, you should copy this file to the Puppet master node as `/etc/puppetlabs/license.key`. If you don't have your license key file, please email <sales@puppetlabs.com> and we'll re-send it.

Note that you can download and install Puppet Enterprise on up to ten nodes at no charge. No license key is needed to run PE on up to ten nodes.

### Setting Puppet in Your Default Path

PE installs its binaries in `/opt/puppet/bin` and `/opt/puppet/sbin`, which aren't included in your default `$PATH`. To include these binaries in your default `$PATH`, manually add them to your profile or run `PATH=/opt/puppet/bin:$PATH;export PATH`.

Installing Agents
-----

Agent installation instructions can be found at [Installing PE Agents](./install_agents.html).

