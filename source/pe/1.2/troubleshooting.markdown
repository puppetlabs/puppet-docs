Configuring and Troubleshooting
===============================

What follows is a short list of common problems that can prevent a Puppet site from working as expected. Additional troubleshooting information can be found at the [main Puppet documentation site](http://docs.puppetlabs.com), on the [Puppet Users mailing list](https://groups.google.com/group/puppet-users), and in `#puppet` on freenode.net. 

Furthermore, please feel free to contact Puppet Labs' enterprise technical support. When reporting issues with the installer itself, please run the installer using the `-D` debugging flag and provide a transcript of the installer's output along with your description of the problem. 

## Firewall Issues

If not configured properly, your system's firewall can interfere with access to Puppet Dashboard and with communications between the puppet master server and puppet agent nodes. In particular, CentOS and Red Hat Enterprise Linux ship with extremely restrictive `iptables` rules, which may need to be modified. 

When attempting to debug connectivity issues (especially if puppet agent nodes are generating log messages like `err: Could not request certificate: No route to host - connect(2)`), first examine your firewall rules and ensure that your master server is allowing tcp connections on port 8140 and your Dashboard server is allowing tcp connections on port 3000.

If you use the REST API and have configured puppet agent to listen for incoming connections, your agent nodes will need to allow tcp connections on port 8139. 

## Certificate Issues

The learning curve of SSL certificate management can lead to a variety of problems. Watch out for the following common scenarios: 

### Agent nodes are contacting their master server using a hostname not listed in the master's certificate

Agent nodes determine the validity of the master's certificate based on hostname; if they're contacting it using a hostname that wasn't included when the certificate was signed, they'll reject the certificate. 

**Solution:** Either modify your agent nodes' settings (and your site's DNS, if applicable) to point to one of the master's certified hostnames, or re-generate and re-sign the master's certificate.

### An agent node's OS has been re-installed, and the master will no longer communicate with it

The puppet master stores signed agent certificates based on nodes' certnames (unique IDs), which are usually fully-qualified domain names. If a node loses its certificates but retains its unique ID, as would happen if the OS and Puppet were re-installed from scratch, it will re-generate its certificate and send a signing request to the master. However, since the master already has a signed certificate cached for that node, it will ignore the signing request and expect the node to contact it using the old (and now lost) certificate. 

A similar situation can arise if an agent node is rebuilt while a previous signing request is still pending. 

**Solution:** On the master server, run `puppet cert --clean {agent certname}`. The master should now accept the node's signing request and wait for permission to sign it. 

### An agent's hostname has changed, and it can no longer contact its master

Puppet Enterprise always writes a node's unique identifier to `puppet.conf` during installation, which provides some resilience against hostname changes that might otherwise change the node's "certname." However, if a node's `puppet.conf` is modified with a new certname, or if the certname is overridden on the command line at runtime, it is possible to wind up with a mismatch that will result in the master rejecting the certificate. 

**Solution:** If the new certname is permanent, simply delete the node's `/etc/puppetlabs/puppet/ssl` directory, and the node will generate a new certificate and send a new signing request to the master. You can also clean the previous certificate on the master if you expect to re-use the old unique identifier for a new agent node. 

### The master server has been replaced, and is not recognized by any existing agent nodes

All nodes in a given domain must be using certificates signed by the same CA certificate. Since puppet master generates a new CA cert during installation, a new master node will, in its default state, be rejected by any agent nodes which were aware of the previous master. 

**Solution:** There are two main options: either delete the `/etc/puppetlabs/puppet/ssl` directory from each agent node (thereby forcing each node to re-generate certificates and issue new signing requests), or recover the CA certificate and private key from the previous master server and re-generate and re-sign the new master's certificate. The short version of how to do the latter is as follows:

* Stop puppet master using your system's service utilities (e.g., on CentOS: `service pe-httpd stop`)
* Run `puppet cert --clean {master's certname}`
* Replace the `/etc/puppetlabs/puppet/ssl/ca` directory with the same directory from the old master
* Run `puppet master --no-daemonize`, wait approximately 30 seconds, then end the process with ctrl-C
* Start puppet master using your system's service utilities

(As you can see, replacing a master server requires a certain amount of planning, and if you expect it to be a semi-regular occurrence, you may wish to investigate certificate chaining and the use of external certificate authorities.)

## Miscellaneous Issues and Additional Tasks

### Manual installation of the Ruby development libraries

If you find that you need the Ruby development libraries but skipped them during installation, Puppet Labs currently recommends installing the packages manually rather than re-running the installer. The method for this will depend on your operating system's package management tools, but in each case, you must first navigate to the directory containing the packages for your operating system and architecture, which will be inside the `packages` subdirectory of the Puppet Enterprise distribution tarball. 

For systems using apt and dpkg (Ubuntu and Debian), execute the following commands: 

	dpkg -i *ruby*dev* 

	apt-get install --fix-broken

For systems using rpm and yum (Red Hat Enterprise Linux, CentOS, and Oracle Enterprise Linux), execute the following commands: 

	yum localinstall --nogpgcheck *ruby*dev* 

### Configuring older agent nodes to work with Puppet Dashboard

Puppet Dashboard learns about your site's agent nodes from report data sent by the puppet master. If you view the Dashboard immediately after installing it, you'll notice that it has no nodes listed; a full list of nodes will be built over the course of the following check-in cycle, and Dashboard will begin to track each node's history. 

This requires that your site's agent nodes be configured to send report data. Agent nodes running Puppet Enterprise will report by default, but if you are installing PE into an existing Puppet site, it's possible that some pre-existing agent nodes are not sending report data and will not appear in the Dashboard. If you suspect this to be the case, check the missing nodes' `puppet.conf` file and ensure that the `[agent]` or `[puppetd]` section contains `report = true`. 

### Importing existing node information into Puppet Dashboard

If your previous Puppet architecture included stored reports on the puppet master (that is, if agent nodes were configured with `report = true` and the master was configured with `reports = store`), importing the reports into Puppet Dashboard can add value to this existing knowledge. 

To run the report importer, first locate the reports directory on your previous puppet master and copy it to the server running Puppet Dashboard. (N.B.: If invoked with `--configprint reportdir`, puppet master will return its reports directory and exit.) Then, on the Puppet Dashboard server, run the following commands with root privileges: 

	cd /opt/puppet/share/puppet-dashboard
	PATH=/opt/puppet/bin:$PATH REPORT_DIR={old reports directory} rake reports:import

If you have a significant number of existing reports, this task can take some time, so plan accordingly.

