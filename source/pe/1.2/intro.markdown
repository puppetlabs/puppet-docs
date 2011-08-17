Welcome to Puppet Enterprise!
=============================

Thank you for choosing Puppet Enterprise 1.2. This distribution is designed to help you get up and running with a fully operational and highly scalable Puppet environment as quickly as possible, and ships with a complementary ten-node license for evaluation purposes. 

Supported Systems
-----------------

This release of Puppet Enterprise supports the following operating system versions:

|     Operating system         |  Version                  |       Arch        |   Support    |
|------------------------------|---------------------------|-------------------|--------------|
| Red Hat Enterprise Linux     | 5 and 6                   | x86 and x86\_64   | master/agent |
| Red Hat Enterprise Linux     | 4                         | x86 and x86\_64   | agent        |
| CentOS                       | 5 and 6                   | x86 and x86\_64   | master/agent |
| CentOS                       | 4                         | x86 and x86\_64   | agent        |
| Ubuntu LTS                   | 10.04                     | 32- and 64-bit    | master/agent |
| Debian                       | Lenny (5) and Squeeze (6) | i386 and amd64    | master/agent |
| Oracle Enterprise Linux      | 5 and 6                   | x86 and x86\_64   | master/agent |
| Scientific Linux             | 5 and 6                   | x86 and x86\_864  | master/agent |
| SUSE Linux Enterprise Server | 11                        | x86 and x86\_864  | master/agent |
| Solaris                      | 10                        | SPARC and x86\_64 | agent        |

Future releases will support additional operating systems.

Before You Install
------------------

Puppet Enterprise is designed to support the most common structure of Puppet deployment, with a large number of agent nodes receiving configurations from a puppet master. When installing Puppet at your site, you will need to decide in advance which server will serve as puppet master and ensure that its address can be resolved by name. 

The configuration of your site can be further simplified by ensuring (usually by adding a CNAME record to your site's DNS configuration) that the puppet master server can also be reached at the hostname `puppet`.

## Licensing

Puppet Enterprise can be evaluated with a complementary ten-node license; beyond that, a commercial per-node license is required for use. A license key will have been emailed to you after your purchase, and the puppet master serving as the certificate authority will look for this key at `/etc/puppetlabs/license.key`. Puppet will log warnings if the license is expired or exceeded, and you can view the status of your license by running `puppet license` at the command line on the CA master. 

To purchase a license, please see the [Puppet Enterprise pricing page](http://www.puppetlabs.com/puppet/how-to-buy/); for more information on licensing terms, please see [the licensing FAQ](http://www.puppetlabs.com/licensing-faq/). If you have misplaced or never received your license key, please contact <sales@puppetlabs.com>. 

