---
layout: default
title: "PE 3.8 » Installing » Installing Cumulus Linux Agents"
subtitle: "Installing Cumulus Linux Puppet Agents"
canonical: "/pe/latest/install_cumulus.html"
---

Puppet Enterprise supports the Cumulus Linux operating system as an agent-only platform. These instructions assume you've already installed a device that supports [Cumulus Linux](http://cumulusnetworks.com/support/linux-hardware-compatibility-list/), as well as having already [installed Puppet Enterprise](./install_basic.html).

In order to install the Cumulus Linux Puppet agent, you must have access to the Cumulus account on the network device.

Before beginning, you also need to gather:

- The IP address and the fully qualified domain name (FQDN) of your Puppet master server.
- The FQDN of the network device that you're installing the Cumulus Linux on. 

## Install the Cumulus Linux Puppet Agent

1. From an admin machine, [download][downloadpe] the Cumulus Linux Puppet Agent tarball. 
2. Push the tarball to the `/home/cumulus` directory on the network device (e.g., run `scp puppet-enterprise-3.x.x-cumulus-2.2-amd64.tar cumulus@dell-s6000:/home/cumulus`).  
3. On the network device, unpack the tarball with `tar xvf puppet-enterprise-3.x.x-cumulus-2.2-amd64.tar`.
4. Navigate to the directory created when you unpacked the PE tarball with `cd puppet-enterprise-3.x.x-cumulus-2.2-amd64`.
4. Use the PE installer to install the Puppet agent. Run `sudo ./puppet-enterprise-installer`.
5. Edit `/etc/hosts` so that it includes the IP address of your Puppet master, as well as its FQDN and its default DNS alt name, `puppet`.
6. Run the Puppet agent on the switch with `sudo /opt/puppet/bin/puppet agent -t`. 

   This creates a certificate signing request (CSR) for the Puppet agent that you will need to sign from the Puppet master. 

7. On the Puppet master, sign the Puppet agent's CSR. Run `puppet cert sign <NETWORK DEVICE'S FQDN>`. 
8. On the network device, complete the installation by running Puppet with `sudo /opt/puppet/bin/puppet agent -t`.

   The Puppet agent will retrieve its catalog and will now be fully functional.
   
> **Next Steps**: Now it's time to begin managing ports, licenses, and interfaces on your network device. Refer to the [Cumulus Linux page](https://forge.puppetlabs.com/cumuluslinux/) on the Puppet Forge for information about modules to get you started. 
   
## Uninstall the Cumulus Linux Puppet Agent

1. Navigate to the directory that was created when you unpacked the PE tarball with `cd puppet-enterprise-3.x.x-cumulus-2.2-amd64`.
2. Use the PE uninstaller to uninstall the Puppet agent. Run `sudo ./puppet-enterprise-uninstaller`.  
3. On the Puppet master, revoke the cert for the Puppet agent with `puppet cert clean <NETWORK DEVICE'S FQDN>`. 

   This revokes the agent certificate and deletes related files on the Puppet master. This prevents SSL collisions should you want to reinstall the Puppet agent on the same device. 



    






























[downloadpe]: https://puppetlabs.com/download-puppet-enterprise
