---
title: "PE 3.7.1 » Release Notes >> Security Fixes"
layout: default
subtitle: "Security Fixes"
canonical: "/pe/latest/release_notes_security.html"
---

This page contains information about security fixes in the latest Puppet Enterprise (PE) release. 

For more information about this release, also see the [Known Issues](./release_notes_known_issues.html) and [New Featutes](./release_notes.html). 

### OpenSSL Security Vulnerabilities

On October 15th, the OpenSSL project announced several security vulnerabilities in OpenSSL. Puppet Enterprise versions prior to 3.7.0 contained vulnerable versions of OpenSSL. Puppet Enterprise 3.7 contains updated versions of OpenSSL that have patched the vulnerabilities.

For more information about the OpenSSL vulnerabilities, refer to the OpenSSL [security announcement](https://www.openssl.org/news/secadv_20141015.txt).

Affected Software Versions:
* Puppet Enterprise 2.x
* Puppet Enterprise 3.x

Resolved in:
Puppet Enterprise 3.7.0

### Oracle Java Security Vulnerabilities

Assessed Risk Level: Medium

On October 14th, Oracle announced several security vulnerabilities in Java. Puppet Enterprise versions prior to 3.7.0 contained a vulnerable version of Java. Puppet Enterprise 3.7.0 contains an updated version of Java that has patched the vulnerabilities.

For more information about the Java vulnerabilities, refer to the Oracle [security announcement](http://www.oracle.com/technetwork/topics/security/cpuoct2014-1972960.html).

Affected Software Versions:
Puppet Enterprise 3.x

Resolved in:
Puppet Enterprise 3.7.0

### CVE-2014-3566 - POODLE SSLv3 Vulnerability

Assessed Risk Level: Medium

On October 14th, the OpenSSL project announced CVE-2014-3566, the POODLE attack vulnerability in the SSLv3 protocol. Fixes for this vulnerability disable SSLv3 protocol negotiation to prevent fallback to the insecure protocol.

Resolved in:
Puppet Enterprise 3.7.0
Manual remediation provided for Puppet Enterprise 3.3
Puppet 3.7.2, Puppet-Server 0.3.0, PuppetDB 2.2, MCollective 2.6.1

Users of Puppet Enterprise 3.3 who cannot upgrade can follow the remediation instructions in our [impact assessment](http://puppetlabs.com/blog/impact-assessment-sslv3-vulnerability-poodle-attack).