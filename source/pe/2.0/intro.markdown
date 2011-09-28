---
layout: default
title: "PE 2.0 Manual: Introduction"
---

{% include pe_2.0_nav.markdown %}

Welcome to Puppet Enterprise!
=============================

Thank you for choosing Puppet Enterprise 1.2. This distribution is designed to help you get up and running with a fully operational and highly scalable Puppet environment as quickly as possible.

About This Manual
-----------------

This user's guide covers Puppet Enterprise version 2.0, and documents its installation and use. It In its current form, it is not intended to teach the use of Puppet or MCollective to new users. For an introduction to Puppet, we recommend starting with the [Learning Puppet][lp] series; for an introduction to MCollective, we recommend starting with the [MCollective documentation][mco]. 

[lp]: http://docs.puppetlabs.com/learning/
[mco]: http://docs.puppetlabs.com/mcollective/index.html
[docs]: http://docs.puppetlabs.com


What's New in PE 1.2
----------

Version 1.2 is a major release of Puppet Enterprise, which adds the following new features:

### MCollective integration

Puppet Enterprise now bundles version 1.2.1 of Marionette Collective, Puppet Labs' server orchestration framework. 

### Puppet Compliance

Puppet Compliance is a new auditing workflow that uses Puppet Dashboard to track changes to resources.

### Puppet Dashboard 1.2

This release upgrades Puppet Dashboard to version 1.2, which boasts vastly improved performance and can export most node views to CSV. 

### Puppet 2.6.9

This release updates Puppet to version 2.6.9, the latest release in the stable 2.6 series. 

Notable new features and fixes since the last version of Puppet Enterprise (which shipped with Puppet 2.6.4) include:

* A new `shell` exec provider that passes the command through `/bin/sh`, mimicking the behavior of Puppet 0.25.
* Dramatically improved puppet master performance under Passenger.
* Puppet master under Passenger no longer requires two runs to detect changes to manifests.
* A stable inventory service API, which is used by the new version of Puppet Dashboard.
* Selectors can now use hashes.
* Nested hashes are now allowed.
* Creation of system users is now allowed.
* External node classifiers can now support parameterized classes.
* New puppet inspect application for the Puppet Compliance workflow.
* $name can now be used to set default values in defined resource types

For more detailed information about the differences between Puppet 2.6.4 and 2.6.9, please see the [Puppet release notes][puppetreleasenotes]. 

[puppetreleasenotes]: http://projects.puppetlabs.com/projects/puppet/wiki/Release_Notes#2.6.9

### Accounts 1.0 Module

PE now includes a ready-to-use Puppet module for managing user accounts. This module provides an account defined type and an optional wrapper class that lets you store all account data in an external YAML file. 

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

If you run into trouble, you can take advantage of Puppet Labs' enterprise technical support.

* To file a support ticket, go to [support.puppetlabs.com](http://support.puppetlabs.com). 
* To reach our support staff via email, contact <support@puppetlabs.com>.
* To speak directly to our support staff, call 1-877-575-9775.

Other Documentation
-----

For help with features not specific to Puppet Enterprise, please see the [main Puppet documentation][docs] and the [MCollective documentation][mco].
