---
layout: default
title: "PE 3.2 » Overview » Getting Support"
subtitle: "Getting Support for Puppet Enterprise"
canonical: "/pe/latest/overview_getting_support.html"
---

Getting support for Puppet Enterprise is easy; it is available both from Puppet Labs and the community of Puppet Enterprise users. We provide responsive, dependable, quality support to resolve any issues regarding the installation, operation, and use of Puppet.

There are three primary ways to get support for Puppet Enterprise:

- Reporting issues to the [Puppet Labs customer support portal][portal].
- Joining the Puppet Enterprise user group.
- Seeking help from the Puppet open source community.

[portal]: https://support.puppetlabs.com
[lifecycle]: https://puppetlabs.com/misc/puppet-enterprise-lifecycle/

Support Lifecycle
-----

Puppet Enterprise 3.x will receive feature updates through June 25, 2014 (or the release of Puppet Enterprise 4, whichever is longer), and will receive security updates through June 25, 2015 (or 1 year from the release of Puppet Enterprise 4, whichever is longer). [See the support lifecycle page for more details.][lifecycle]

After Puppet Enterprise 3.x reaches end-of-life, customers can still contact Puppet Labs support for best-effort help, although we will recommend upgrading as soon as you are able.

Reporting Issues to the Customer Support Portal
-----

### Paid Support

Puppet Labs provides two levels of [commercial support offerings for Puppet Enterprise](http://puppetlabs.com/services/support/): Standard and Premium.  Both offerings allow you to report your support issues to our confidential [customer support portal][portal].  You will receive an account and log-on for this portal when you purchase Puppet Enterprise.

**Customer support portal: [https://support.puppetlabs.com][portal]**

#### The PE Support Script

When seeking support, you may be asked to run an information-gathering support script named, "`puppet-enterprise-support`". The script is located in the root of the unzipped Puppet Enterprise installer tarball; it is also installed on any master, PuppetDB, or console node and can be run via `/opt/puppet/bin/puppet-enterprise-support`.

This script will collect a large amount of system information, compress it, and print the location of the zipped tarball when it finishes running; an uncompressed directory (named `support`) containing the same data will be left in the same directory as the compressed copy. We recommend that you examine the collected data before forwarding it to Puppet Labs, as it may contain sensitive information that you will wish to redact.

The information collected by the support script includes:

- iptables info (is it loaded? what are the inbound and outbound rules?) (both ipv4 and ipv6)
- a full run of Facter (if installed)
- SELinux status
- the amount of free disk and memory on the system
- hostname info (`/etc/hosts` and the output of `hostname --fqdn`)
- the umask of the system
- NTP configuration (what servers are available, the offset from them)
- a listing (no content) of the files in `/opt/puppet`,
`/var/opt/lib/pe-puppet` and `/var/opt/lib/pe-puppetmaster`
- the OS and kernel
- a list of installed packages
- the current process list
- a listing of puppet certs
- a listing of all services (except on Debian, which lacks the equivalent command)
- current environment variables
- whether the puppet master is reachable
- the output of `mco ping` and `mco inventory`
- a list of all modules on the system
- the output of `puppet module changes` (shows if any modules installed by PE have been modified)
- the output of `/nodes.csv` from the console (includes a list of known nodes and metadata about their most recent puppet runs)

It also copies the following files:

- system logs
- the contents of `/etc/puppetlabs`
- the contents of `/var/log/pe-*`


Join the Puppet Enterprise User Group
-----

<http://groups.google.com/a/puppetlabs.com/group/pe-users>

- Click on “Sign in and apply for membership.”
- Click on “Enter your email address to access the document.”
- Enter your email address.


Your request to join will be sent to Puppet Labs for authorization and you will receive an email when you’ve been added to the user group.

Getting Support From the Existing Puppet Community
-----

As a Puppet Enterprise customer you are more than welcome to participate in our large and helpful open source community as well as report issues against the open source project.

- Puppet open source user group:

    <http://groups.google.com/group/puppet-users>
- Puppet Developers group:

    <http://groups.google.com/group/puppet-dev>
- Report issues with the open source Puppet project:

    <https://tickets.puppetlabs.com/browse/PUP>



* * *

- [Next: Quick Start](./quick_start.html)
