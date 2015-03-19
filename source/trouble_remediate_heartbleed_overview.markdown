---
layout: default
nav: /_includes/fallback_nav.html
title: "Puppet » Troubleshooting » Remediating Heartbleed"
subtitle: "Remediation for Recovering from the Heartbleed Bug"
canonical: "/trouble_remediate_heartbleed_overview.html"
description: "This page provides an overview of remediating the Heartbleed bug in Puppet Open Source and Puppet Enterprise deployments."
---

> **Note:** For more information and links to more resources for remediating your Puppet Enterprise deployment due to [CVE-2014-0160][cve], a.k.a. the "Heartbleed" SSL vulnerability, [please see this announcement][blog] before going on to choosing a method for remediation.

[blog]: http://puppetlabs.com/blog/heartbleed-security-bug-update-puppet-users
[cve]: https://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2014-0160


### Remediating the "Heartbleed" Bug

While neither open source Puppet nor Puppet Enterprise (PE) shipped with a vulnerable version of OpenSSL, either may rely on vulnerable versions of OpenSSL that shipped as part of certain operating systems ([see the list of affected platforms][OS_list]). Consequently, Puppet Labs strongly recommends that organizations using PE or Puppet regenerate their Puppet public key infrastructure, including all certs and the certificate authority (CA). 

The steps required for a complete replacement remediation vary based on the architecture of your deployment and the version of PE you are running. Specifically, the steps differ depending on whether you have a monolithic architecture (master, console and db roles are all on one node) or a split architecture (master, console and db roles are on separate nodes) Make sure you choose the appropriate set of instructions:


* [Remediation Steps for PE 2.8.x Monolithic Architecture](./pe/2.8/trouble_regenerate_certs_monolithic.html)
* [Remediation Steps for PE 2.8.x Split Architecture](./pe/2.8/trouble_regenerate_certs_split.html)
* [Remediation Steps for PE 3.2.x Monolithic Architecture](./pe/3.2/trouble_regenerate_certs_monolithic.html)
* [Remediation Steps for PE 3.2.x Split Architecture](./pe/3.2/trouble_regenerate_certs_split.html)
* [Remediation Steps for Open Source Puppet](./puppet/latest/reference/ssl_regenerate_certificates.html)


[OS_list]: http://puppetlabs.com/blog/heartbleed-and-puppet-supported-operating-systems


