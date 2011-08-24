---
layout: default
title: "PE Manual: Introduction"
---

Welcome to Puppet Enterprise!
=============================

Thank you for choosing Puppet Enterprise 1.2. This distribution is designed to help you get up and running with a fully operational and highly scalable Puppet environment as quickly as possible.

About This Manual
-----------------

This manual covers Puppet Enterprise version 1.2, and documents its installation and maintenance. In its current form, it is not intended to teach the use of Puppet or MCollective to new users. For an introduction to Puppet, we recommend starting with the [Learning Puppet][lp] series; for an introduction to MCollective, we recommend starting with the [MCollective documentation][mco]. 

[lp]: http://docs.puppetlabs.com/learning/
[mco]: http://docs.puppetlabs.com/mcollective/index.html
[docs]: http://docs.puppetlabs.com

System Requirements
-----------------

Puppet Enterprise 1.2 supports the following operating system versions:

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

Puppet's hardware requirements will depend heavily on the number of resources you are managing, but in general, you can expect a 2-4 CPU puppet master with 4GB of RAM to manage approximately 1,000 agent nodes. <!-- TK get this vetted -->

Licensing
------

Puppet Enterprise can be evaluated with a complementary ten-node license; beyond that, a commercial per-node license is required for use. A license key file will have been emailed to you after your purchase, and the puppet master serving as the certificate authority will look for this key at `/etc/puppetlabs/license.key`. Puppet will log warnings if the license is expired or exceeded, and you can view the status of your license by running `puppet license` at the command line on the puppet master. 

To purchase a license, please see the [Puppet Enterprise pricing page](http://www.puppetlabs.com/puppet/how-to-buy/), or contact Puppet Labs at <sales@puppetlabs.com> or (877) 575-9775. For more information on licensing terms, please see [the licensing FAQ](http://www.puppetlabs.com/licensing-faq/). If you have misplaced or never received your license key, please contact <sales@puppetlabs.com>. 

What's New in PE 1.2
----------

Version 1.2 is a major release of Puppet Enterprise, which adds the following high-level features:

### MCollective integration

Puppet Enterprise now bundles Marionette Collective, Puppet Labs' server orchestration framework.  <!-- TK what version are we using? -->

### Puppet 2.6.9

This release updates Puppet to version 2.6.9, the latest release in the stable 2.6 series. <!--tk vet this -->

### Accounts 1.0 Module

PE now includes a ready-to-use Puppet module for managing user accounts. This module provides both a standard defined type, and a class that lets you store all account data in an external YAML file. 

### Stdlib 2.0 Module 

This helper module extends Puppet with:

* A new `facts.d` Facter extension that can read system facts from an arbitrary mix of text, yaml, json, and executable script files stored in `/etc/puppetlabs/facter/facts.d` or `/etc/facter/facts.d`. 
* Several data validation functions, including `validate_array`, `validate_bool`, `validate_hash`, `validate_re`, `validate_string`, and `has_key`.
* Two data loading functions: `getvar` and `loadyaml`. 
* The `file_line` resource type, which ensures that a given line exists verbatim somewhere in a file. 
* The `anchor` resource type, which is used to enhance readability in certain Puppet Labs modules. 
* A set of standardized run stages (available when class `sdlib` is declared).

How to Get Help and Support
--------------

<!-- TK I'm not sure what goes here. -->

### Other Documentation

For help with features not specific to Puppet Enterprise, please see the [main Puppet documentation][docs] and the [MCollective documentation][mco].
