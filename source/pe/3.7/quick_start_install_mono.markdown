---
layout: default
title: "PE 3.7 » Quick Start » Install PE (Monolithic)"
subtitle: "PE Install Quick Start Guide"
canonical: "/pe/latest/quick_start_install_mono.html"
---


## Overview

To get you started using Puppet Enterprise (PE) relatively quickly and efficiently, this guide walks you through the steps of a monolithic install. A monolithic deployment is best suited for users who want to evaluate PE, or for users managing a small number of Puppet agent nodes (up to 500 nodes). For larger installations, you’ll need to perform a [split install](./install_pe_split.html).

A monolithic PE deployment entails installing the Puppet master, the PE console, and PuppetDB all on one node. Puppet agent nodes are installed later as part of the [agent installation quick start guide for *nix](./quick_start_install_agents_nix.html) or the [agent installation quick start guide for Windows](./quick_start_install_agents_windows.html).

For more information about the components that make up your PE deployment, visit the [installation overview](./install_basic.html) in the PE docs.

Note: This guide assumes that you’ll install a monolithic PE deployment as `root`.

>### General Prerequisites and Notes
>
>- See the [system requirements](./install_system_requirements.html#monolithic-all-in-one-installation) to ensure your hardware needs are met.
>
>- Make sure that DNS is properly configured on the machines you're installing PE on. All nodes must **know their own hostnames.** This can be done by properly configuring reverse DNS on your local DNS server, or by setting the hostname explicitly. Setting the hostname usually involves the `hostname` command and one or more configuration files, while the exact method varies by platform. In addition, all nodes must be able to **reach each other by name.** This can be done with a local DNS server, or by editing the `/etc/hosts` file on each node to point to the proper IP addresses.
>
>- Please ensure that port 3000 is reachable, as the web-based installer uses this port. You can close this port when the installation is complete.

## Installing the Monolithic Puppet Enterprise Deployment

1. Review the [General Prerequisites](#general-prerequisites-and-notes).
2. [Download and verify the appropriate PE tarball](./install_basic.html#downloading-puppet-enterprise), and, if needed, copy the tarball to the machine on which you'll be installing PE.

   > **Tip**: Be sure to download the full PE tarball, not the agent-only tarball. The agent-only tarball is used for [package management-based agent installation](./install_agents.html) which is not covered by this guide.

3. Unpack the tarball. (Run `tar -xf <tarball>`.)
4. From the PE installer directory, run `sudo ./puppet-enterprise-installer`.
5. When prompted, choose "Yes" to install the setup packages. (If you choose "No," the installer will exit.)

   At this point, the PE installer will start a web server and provide a web address: `https://<install platform hostname>:3000`. Please ensure that port 3000 is reachable. If necessary, you can close port 3000 when the installation is complete. Also be sure to use `https`.

   >**Warning**: Leave your terminal connection open until the installation is complete; otherwise the installation will fail.

6. Copy the address into your browser.
7. When prompted, accept the security request in your browser.

   The web-based installation uses a default SSL certificate; you’ll have to add a security exception in order to access the web-based installer. This is safe to do.

   You'll be taken to the installer start page.

8. On the start page, click **Let's get started**.
9. Next, you'll be asked to choose your deployment type. Select **Monolithic**.
10. Choose to install the Puppet master component on the server you're running the installer from.
11. Provide the following information about the Puppet master server:

    a. **Puppet master FQDN**: provide the fully qualified domain name of the server you're installing PE on; for example, `master.example.com`.

    b. **DNS aliases**: provide a comma-separated list of aliases agent nodes can use to reach to the master; for example `master`.

12. When prompted about database support, choose the default option **Install PostgreSQL for me**.

13. Provide the following information about the PE console administrator user:

    **Console superuser password**: create a password for the console login; the password must be at least eight characters.

    **Note**: the user name for the console administrator user is __admin__.

14. Click **Submit**.
15. On the confirm plan page, review the information you provided, and, if it looks correct, click **Continue**.

    If you need to make any changes, click **Go Back** and make whatever changes are required.

16. On the validation page, the installer will verify various configuration elements (e.g., if SSH credentials are correct, if there is enough disk space, and if the OS is the same for the various components). If there aren't any outstanding issues, click **Deploy now**.

The installer will then install and configure Puppet Enterprise. It may also need to install additional packages from your OS's repository. **This process may take up to 10-15 minutes.** When the installation is complete, the installer script that was running in the terminal will close itself.

> You have now installed the Puppet master node. As indicated by the installer, the Puppet master node is also an agent node, and can configure itself the same way it configures the other nodes in a deployment. Stay logged in as root for further exercises.

### Log in to the Console

To log in to the console, you can select the **Start Using Puppet Enterprise Now** button that appears at the end of the web-based installer or follow the steps below.

1. **On your control workstation**, open a web browser and point it to the address supplied by the installer; for example, https://master.example.com.
   You will receive a warning about an untrusted certificate. This is because _you_ were the signing authority for the console's certificate, and your Puppet Enterprise deployment is not known to the major browser vendors as a valid signing authority. **Ignore the warning and accept the certificate**. The steps to do this [vary by browser](./console_accessing.html).
2. On the login page for the console, **log in** with the username **admin** and the password you provided when installing the Puppet master.

   The console GUI loads in your browser.


Next: Install Agents---[Windows](./quick_start_install_agents_windows.html) or [*nix](./quick_start_install_agents_nix.html)
