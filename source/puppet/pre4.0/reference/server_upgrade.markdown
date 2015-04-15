# 3.x to 4.0 Server Upgrade Steps

## Monolithic installation

### Summary

This is for sites which have all master-related functions (puppetmaster, certificate authority, file server) on one 
system. In summary, the steps to start serving a Puppet 4 server are:

1. Install the puppet-agent-1.0 and puppetserver-2.0 packages for your operating system.
1. Copy your certificate authority files to the new filesystem location (`/etc/puppetlabs/puppet/ssl`)
2. Migrate your code (modules + manifests + hiera) to the new location and directory structure (`/etc/puppetlabs/code`) 
   and prepare the server for Directory Environments.
3. Transfer any custom settings that were in your previous puppet.conf to `/etc/puppetlabs/puppet/puppet.conf`; do not 
   simply copy the file in-place as many older settings are removed or their defaults have changed.
4. Start running your puppetmaster under Puppet Server 2.0 (if you were previously using Apache)

While it is possible to do an in-place upgrade over a running Puppet 3.x server, we recommend that you set up a new VM 
or physical system to start fresh, and migrate only those pieces of data which are required to ensure continuity of your 
infrastructure such as modules and certificates. That way, your existing Puppet masters continue to run as-is and 
rollback becomes much simpler.

### Install packages

This is simply a matter of following the [Linux installation guide](install_linux.html) for Puppet 4: add the release
package, then install the puppetserver package (which will automatically add the puppet-agent as well)

### Set up SSL

On the 3.x master installation, find the SSL directory tree and copy it into the new location: 
`/etc/puppetlabs/puppet/ssl`. We recommend using `rsync -a` if you're setting up a new master server, as this will 
preserve the permissions on the files, which SSL is picky about.

If this is a new host, you'll also need to generate a certificate for it, so that it will be able to answer requests 
from agents. Once the puppet-agent package is installed and the CA files are in place, run

    /opt/puppetlabs/bin/puppet cert generate --dns_alt_names=puppet,puppet.mydomain myhostname.mydomain

### Migrate code


