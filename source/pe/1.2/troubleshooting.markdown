---
layout: default
title: "PE Manual: Troubleshooting"
---

{% include pe_nav.markdown %}

Troubleshooting
===============


This document explains several common problems that can prevent a Puppet Enterprise site from working as expected. Additional troubleshooting information can be found at the [main Puppet documentation site](http://docs.puppetlabs.com), on the [Puppet Users mailing list](https://groups.google.com/group/puppet-users), and in `#puppet` on freenode.net. 

Furthermore, please feel free to contact Puppet Labs' enterprise technical support:

* To file a support ticket, go to [support.puppetlabs.com](http://support.puppetlabs.com). 
* To reach our support staff via email, contact <support@puppetlabs.com>.
* To speak directly to our support staff, call 1-877-575-9775.

When reporting issues with the installer itself, please run the installer using the `-D` debugging flag and provide a transcript of the installer's output along with your description of the problem. 

## Firewall Issues

If not configured properly, your system's firewall can interfere with access to Puppet Dashboard and with communications between the puppet master server and puppet agent nodes. In particular, CentOS and Red Hat Enterprise Linux ship with extremely restrictive `iptables` rules, which may need to be modified. 

When attempting to debug connectivity issues (especially if puppet agent nodes are generating log messages like `err: Could not request certificate: No route to host - connect(2)`), first examine your firewall rules and ensure that your master server is allowing tcp connections on port 8140 and your Dashboard server is allowing tcp connections on port 3000.

If you use the REST API and have configured puppet agent to listen for incoming connections, your agent nodes will need to allow tcp connections on port 8139. 

## Certificate Issues

The learning curve of SSL certificate management can lead to a variety of problems. Watch out for the following common scenarios: 

### Agent Node Was Installed Before the Puppet Master

If you install the puppet agent role on a node before getting the puppet master up and running, the installer won't be able to request a certificate during installation, and you won't immediately see a pending certificate request when you run `puppet cert list`. To request a certificate manually, you can log into the agent node and run:

    # puppet agent --test

...after which you should be able to sign the certificate on the puppet master. Alternately, you can simply wait 30 minutes, as the puppet agent service will request a certificate on its next run.

### Agent Nodes Refuse to Trust the Master's Certificate

<!-- TK  this needs a revision -->

Agent nodes determine the validity of the master's certificate based on hostname; if they're contacting it using a hostname that wasn't included when the certificate was signed, they'll reject the certificate. 

**Solution:** Either modify your agent nodes' settings (and your site's DNS, if applicable) to point to one of the master's certified hostnames, or re-generate and re-sign the master's certificate.

### An agent node's OS has been re-installed, and the master will no longer communicate with it

The puppet master stores signed agent certificates based on nodes' certnames (unique IDs), which are usually fully-qualified domain names. If a node loses its certificates but retains its unique ID, as would happen if the OS and Puppet were re-installed from scratch, it will re-generate its certificate and send a signing request to the master. However, since the master already has a signed certificate cached for that node, it will ignore the signing request and expect the node to contact it using the old (and now lost) certificate. 

A similar situation can arise if an agent node is rebuilt while a previous signing request is still pending. 

**Solution:** On the master server, run `puppet cert --clean {agent certname}`. The master should now accept the node's signing request and wait for permission to sign it. 

### An agent's hostname has changed, and it can no longer contact its master

Puppet Enterprise always writes a node's unique identifier to `puppet.conf` during installation, which provides some resilience against hostname changes that might otherwise change the node's "certname." However, if a node's `puppet.conf` is modified with a new certname, or if the certname is overridden on the command line at runtime, it is possible to wind up with a mismatch that will result in the master rejecting the certificate. 

**Solution:** If the new certname is permanent, simply delete the node's `/etc/puppetlabs/puppet/ssl` directory, and the node will generate a new certificate and send a new signing request to the master. You can also clean the previous certificate on the master if you expect to re-use the old unique identifier for a new agent node. 

### Dashboard Was Installed Before the Puppet Master

[dashboardsplit]: ./installing.html#configuring-a-stand-alone-dashboard-server

If you're splitting the Dashboard and puppet master servers and you installed Dashboard first, you'll need to modify the post-installation certificate exchange. On the Dashboard server, run the following commands:

    # puppet agent --test
    # cd /opt/puppet/share/puppet-dashboard
    # export PATH=/opt/puppet/sbin:/opt/puppet/bin:$PATH
    # rake RAILS_ENV=production cert:generate

After that, you should be able to follow [the normal post-install instructions for a stand-alone Dashboard server][dashboardsplit]. 

### Puppet Master Server Was Replaced

All nodes in a given domain must be using certificates signed by the same CA certificate. Since puppet master generates a new CA cert during installation, a new master node will, in its default state, be rejected by any agent nodes which were aware of the previous master. 

You have two main options: either delete the `/etc/puppetlabs/puppet/ssl` directory from each agent node (thereby forcing each node to re-generate certificates and issue new signing requests), or recover the CA certificate and private key from the previous master server and re-generate and re-sign the new master's certificate. The short version of how to do the latter is as follows:

* Stop puppet master using your system's service utilities (e.g., on CentOS: `service pe-httpd stop`)
* Run `puppet cert --clean {master's certname}`
* Replace the `/etc/puppetlabs/puppet/ssl/ca` directory with the same directory from the old master
* Run `puppet master --no-daemonize`, wait approximately 30 seconds, then end the process with ctrl-C
* Start puppet master using your system's service utilities

(As you can see, replacing a master server requires a certain amount of planning, and if you expect it to be a semi-regular occurrence, you may wish to investigate certificate chaining and the use of external certificate authorities.)

## Miscellaneous Issues and Additional Tasks

### Import Existing Reports Into Puppet Dashboard

If you are upgrading to PE from a self-maintained Puppet environment, you can add value to your older reports by importing the reports into Puppet Dashboard. To run the report importer, first locate the reports directory on your previous puppet master (`puppet master --configprint reportdir`) and copy it to the server running Puppet Dashboard. Then, on the Dashboard server, run the following commands with root privileges: 


included stored reports on the puppet master (that is, if agent nodes were configured with `report = true` and the master was configured with `reports = store`),  can add value to this existing knowledge. 


	cd /opt/puppet/share/puppet-dashboard
	PATH=/opt/puppet/bin:$PATH REPORT_DIR={old reports directory} rake reports:import

If you have a significant number of existing reports, this task can take some time, so plan accordingly.

