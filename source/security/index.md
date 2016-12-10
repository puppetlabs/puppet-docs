---
layout: default
title: "Security and vulnerability announcements"
toc_levels: h1, h2
---

This page contains information about security fixes from both Puppet and third-party software vendors used in Puppet products. For information about our security policies and instructions on how to report findings, refer to the [vulnerability submission process](./vulnerability_submission_process.html).

## Internal security announcements

- [CVE-2016-5715 - Arbitrary URL Redirection in Puppet Enterprise Console](https://puppet.com/security/cve/cve-2016-5715)

   Resolved in Puppet Enterprise 2016.4.0

- [Puppet Execution Protocol (PXP) Command Whitelist Validation Vulnerability](https://puppet.com/security/cve/pxp-agent-oct-2016)

   Resolved in Puppet Enterprise 2016.4.0, Puppet Agent 1.7.1

- [Puppet Communications Protocol (PCP) Broker String Validation Vulnerability](https://puppet.com/security/cve/pcp-broker-oct-2016)

   Resolved in Puppet Enterprise 2016.4.0

- [Remote Code Execution in Puppet Enterprise Console](https://puppet.com/security/cve/pe-console-oct-2016)

   Resolved in Puppet Enterprise 2016.4.0

- [CVE-2016-5714 - Unprivileged Access to Environment Catalogs](https://puppet.com/security/cve/cve-2016-5714)

   Resolved in Puppet Enterprise 2016.4.0, Puppet Agent 1.7.0

- [CVE-2016-5713 - Environment Leakage in pxp-module-puppet](https://puppet.com/security/cve/cve-2016-5713)

    Resolved in Puppet Agent 1.6.0

- [CVE-2015-7331: Remote Code Execution in mcollective-puppet-agent plugin](https://puppet.com/security/cve/cve-2015-7331)

    Resolved in Puppet Enterprise 2016.2.1

- [CVE-2016-2788: Improper validation of fields in MCollective pings](https://puppet.com/security/cve/cve-2016-2788)

    Resolved in Puppet Enterprise 3.8.6, Puppet Enterprise 2016.2.1, and MCollective 2.8.9

- [CVE-2016-2785: Incorrect URL Decoding](https://puppet.com/security/cve/cve-2016-2785)

    Resolved in Puppet Enterprise 2016.1.2, Puppet Server 2.3.2, Puppet 4.4.2, and Puppet agent 1.4.2

- [CVE-2016-2786: Incorrect Client Verification in Puppet Communications Protocol](https://puppet.com/security/cve/CVE-2016-2786)

   Resolved in Puppet Enterprise 2015.3.3 and Puppet agent 1.3.6

- [CVE-2016-2787: Incorrect Broker Verification in Puppet Communications Protocol](https://puppet.com/security/cve/CVE-2016-2787)

   Resolved in Puppet Enterprise 2015.3.3

- [Advisory: PuppetDB may have insecure permissions on configuration directory](https://puppet.com/security/cve/puppetdb-feb-2016-advisory)

   Resolved in PuppetDB 3.2.4

- [CVE-2015-7330: Non-whitelisted hosts could access Puppet communications protocol](https://puppet.com/security/cve/cve-2015-7330)

   Resolved in Puppet Enterprise 2015.3.1

- [CVE-2015-8470: Puppet Enterprise Console JSESSIONID Cookies Are Issued Without the Secure Flag](https://puppet.com/security/cve/CVE-2015-8470)

   Resolved in Puppet Enterprise 2015.3.0 and Puppet Enterprise 3.8.5

- [Advisory: puppetlabs-ntp default configuration does not fully mitigate CVE-2013-5211](https://puppet.com/security/cve/puppetlabs-ntp-nov-2015-advisory)

   Resolved in puppetlabs-ntp 4.1.1

- [CVE-2015-7328: World-Readable CA Keys in Puppet Server](https://puppet.com/security/cve/cve-2015-7328)

   Resolved in Puppet Enterprise 3.8.3 and 2015.2.3

- [CVE-2015-6501: Arbitrary URL Redirection in Puppet Enterprise Console](https://puppet.com/security/cve/CVE-2015-6501)

   Resolved in Puppet Enterprise 2015.2.1

- [CVE-2015-6502: Reflected Cross Site Scripting in Login Redirect](https://puppet.com/security/cve/CVE-2015-6502)

   Resolved in Puppet Enterprise 2015.2.1

- [CVE-2015-7224: puppetlabs-mysql can unexpectedly create database user accounts with no password](https://puppet.com/security/cve/CVE-2015-7224)

   Resolved in puppetlabs-mysql 3.6.1

- [Advisory: Use of the 'port' parameter with puppetlabs-firewall could cause unexpectedly permissive firewall rules](https://puppet.com/security/cve/puppetlabs-firewall-aug-2015-advisory)

   Resolved in puppetlabs-firewall 1.7.1

- [Advisory: `pe-java` Was Not Updated on the Console Node on Split Upgrades](https://puppet.com/security/cve/pe-java-aug-2015-split-upgrade-advisory)

   Resolved in Puppet Enterprise 3.8.2

- [CVE-2015-5686: Console XSS Vulnerability](https://puppet.com/security/cve/console-xss-vulnerabilities)

   Resolved in Puppet Enterprise 2015.2.0

- [CVE-2015-4100: Puppet Enterprise Certificate Authority Reverse Proxy Vulnerability](https://puppet.com/security/cve/CVE-2015-4100)

   Resolved in Puppet Enterprise 3.8.1

- [CWE-352: Cross-Frame Scripting (XFS) Vulnerability in Puppet Enterprise Console](https://puppet.com/security/cve/cwe-352-april-2015)

   Resolved in Puppet Enterprise 3.8.0

- [CVE-2014-9568: Potential information leakage in puppetlabs-rabbitmq facts handling](https://puppet.com/security/cve/cve-2014-9568)

   Resolved in puppetlabs-rabbitmq 5.0

- [CVE-2015-1029: Vulnerability in puppetlabs-stdlib module fact cache](https://puppet.com/security/cve/cve-2015-1029)

   Resolved in puppetlabs-stdlib 4.5.1

- [CVE-2014-9355: Information Leakage in Puppet Enterprise Console](https://puppet.com/security/cve/cve-2014-9355)

   Resolved in Puppet Enterprise 3.7.1

- [CVE-2014-7170: Puppet Server local information leakage](https://puppet.com/security/cve/cve-2014-7170)

   Resolved in Puppet Server 0.2.1

- [CVE-2014-3251: MCollective 'aes_security' plugin vulnerability](https://puppet.com/security/cve/cve-2014-3251)

   Resolved in Puppet Enterprise 3.3.0, Mcollective 2.5.3

- [CVE-2014-3249: Information leakage in Puppet Enterprise Console](https://puppet.com/security/cve/cve-2014-3249)

   Resolved in Puppet Enterprise 2.8.7

- [CVE-2013-4971: Unauthenticated read access to node endpoints could cause information leakage](https://puppet.com/security/cve/cve-2013-4971)

   Resolved in Puppet Enterprise 3.2.0

- [CVE-2013-4966: Master external node classification script vulnerable to console impersonation](https://puppet.com/security/cve/cve-2013-4966)

   Resolved in Puppet Enterprise 3.2.0

- [CVE-2013-4969: Unsafe use of temp files in File type](https://puppet.com/security/cve/cve-2013-4969)

   Resolved in Puppet 3.4.1, Puppet Enterprise 2.8.4, 3.1.1

- [CVE-2013-4965: Console user account brute force vulnerability](https://puppet.com/security/cve/cve-2013-4965)

   Resolved in Puppet Enterprise 3.1.0

- [CVE-2013-4957: Puppet Dashboard Report YAML Handling Vulnerability](https://puppet.com/security/cve/cve-2013-4957)

   Resolved in Puppet Enterprise 3.1.0

- [CVE-2013-4967: External Node Classifiers Allowed Clear Text Database Password Query](https://puppet.com/security/cve/cve-2013-4967)

   Resolved in Puppet Enterprise 3.0.1

- [CVE-2013-4956: Puppet Module Permissions Vulnerability](https://puppet.com/security/cve/cve-2013-4956)

   Resolved in Puppet 2.7.23, 3.2.4, Puppet Enterprise 2.8.3, 3.0.1

- [CVE-2013-4762: Logout Link Did Not Destroy Server Session](https://puppet.com/security/cve/cve-2013-4762)

   Resolved in Puppet Enterprise 3.0.1

- [CVE-2013-4962 – Lack of Reauthentication for Sensitive Transactions](https://puppet.com/security/cve/cve-2013-4962)

   Resolved in Puppet Enterprise 3.0.1

- [CVE-2013-4955: Phishing Through URL Redirection Vulnerability](https://puppet.com/security/cve/cve-2013-4955)

   Resolved in Puppet Enterprise 3.0.1

- [CVE-2013-4964 – Session Cookies Not Set With Secure Flag](https://puppet.com/security/cve/cve-2013-4964)

   Resolved in Puppet Enterprise 3.0.1

- [CVE-2013-4968 – Site Lacked Clickjacking Defense](https://puppet.com/security/cve/cve-2013-4968)

   Resolved in Puppet Enterprise 3.0.1

- [CVE-2013-4963 – Cross-Site Request Forgery Vulnerability](https://puppet.com/security/cve/cve-2013-4963)

   Resolved in Puppet Enterprise 3.0.1

- [CVE-2013-4958 – Lack of Session Timeout](https://puppet.com/security/cve/cve-2013-4958)

   Resolved in Puppet Enterprise 3.0.1

- [CVE-2013-4761: `resource_type` Remote Code Execution Vulnerability](https://puppet.com/security/cve/cve-2013-4761)

   Resolved in Puppet 2.7.23, 3.2.4, Puppet Enterprise 2.8.3, 3.0.1

- [CVE-2013-1653 – Agent Remote Code Execution Vulnerability](https://puppet.com/security/cve/cve-2013-1653)

   Resolved in Puppet 2.7.21, 3.1.1, Puppet Enterprise 2.7.2

- [CVE-2013-1399: Console CSRF Vulnerability](https://puppet.com/security/cve/cve-2013-1399)

   Resolved in Puppet Enterprise 2.7.1

- [CVE-2013-1398: MCO Private Key Leak](https://puppet.com/security/cve/cve-2013-1398)

   Resolved in Puppet Enterprise 2.7.1

- [CVE-2012-5158: Incorrect Session Handling](https://puppet.com/security/cve/cve-2012-5158)

   Resolved in Puppet Enterprise 2.6.1

- [CVE-2012-3864: Arbitrary File Read](https://puppet.com/security/cve/cve-2012-3864)

   Resolved in Puppet 2.6.17, 2.7.18, Puppet Enterprise Hotfixes for 1.0, 1.1, 1.2.x, and 2.0.x, Puppet Enterprise 2.5.2

- [CVE-2012-3865: Arbitrary file delete/D.O.S on Puppet Master](https://puppet.com/security/cve/cve-2012-3865)

   Resolved in Puppet 2.6.17, 2.7.18, Puppet Enterprise Hotfixes for 1.0, 1.1, 1.2.x, and 2.0.x, Puppet Enterprise 2.5.2

- [CVE-2012-3866: last_run_report.yaml is World-Readable](https://puppet.com/security/cve/cve-2012-3866)

   Resolved in Puppet 2.7.18, Puppet Enterprise Hotfixes for 2.0.x, Puppet Enterprise 2.5.2

- [CVE-2012-3867: Insufficient Input Validation](https://puppet.com/security/cve/cve-2012-3867)

   Resolved in Puppet 2.6.17, 2.7.18, Puppet Enterprise Hotfixes for 1.0, 1.1, 1.2.x, and 2.0.x, Puppet Enterprise 2.5.2

- [CVE-2012-3408: Agent Impersonation](https://puppet.com/security/cve/cve-2012-3408)

   Addressed in 2.7.18, Puppet Enterprise Hotfixes for 2.0.x, Puppet Enterprise 2.5.2

- [CVE-2012-1986 - Arbitrary File Read](https://puppet.com/security/cve/cve-2012-1986)

   Resolved in Puppet 2.6.15, 2.7.13, Puppet Enterprise Hotfixes for 1.0, 1.1, 1.2.x, and 2.0.x, Puppet Enterprise 2.5.1

- [CVE-2012-1988 - Arbitrary Code Execution](https://puppet.com/security/cve/cve-2012-1988)

   Resolved in Puppet 2.6.15, 2.7.13, Puppet Enterprise Hotfixes for 1.0, 1.1, 1.2.x, and 2.0.x, Puppet Enterprise 2.5.1

- [CVE-2012-1053: Puppet Resource Local Group Privilege Escalation](https://puppet.com/security/cve/cve-2012-1053)

   Resolved in Puppet 2.6.14, 2.7.11, Puppet Enterprise Hotfixes for 1.0, 1.1 and 1.2.x, Puppet Enterprise 2.0.3

- [CVE-2012-1906 - Arbitrary Code Execution](https://puppet.com/security/cve/cve-2012-1906)

   Resolved in Puppet 2.6.15, 2.7.13, Puppet Enterprise Hotfixes for 1.0, 1.1, 1.2.x, and 2.0.x, Puppet Enterprise 2.5.1

- [CVE-2012-1989 - Arbitrary File Write](https://puppet.com/security/cve/cve-2012-1989)

   Resolved in Puppet 2.7.13, Puppet Enterprise 2.5.1, Puppet Enterprise Hotfixes for 2.0.x; not applicable to earlier versions

- [CVE-2012-0891: Dashboard Cross Site Scripting (XSS) Vulnerability](https://puppet.com/security/cve/cve-2012-0891)

   Resolved in Puppet Dashboard 1.2.5, Puppet Enterprise Hotfixes for 1.0, 1.1 and 1.2.x, Puppet Enterprise 2.0.1

- [CVE-2011-3872: AltNames Vulnerability](https://puppet.com/security/cve/cve-2011-3872)

   Resolved in Puppet 0.25.6, 2.6.12, 2.7.6, Puppet Enterprise 1.2.4

- [CVE-2011-3871: Puppet Resource Local Privilege Escalation](https://puppet.com/security/cve/cve-2011-3871)

   Resolved in 2.7.5 and 2.6.11, Puppet Enterprise 1.2.3

- [auth-conf-2010-10: Missing Auth.conf Resource Manipulation](https://puppet.com/security/cve/auth-conf-2010-10)

   Resolved in Puppet 2.6.4

- [CVE-2010-0156: File overwrite vulnerability via symlink attack](https://puppet.com/security/cve/cve-2010-0156)

   Resolved in Puppet 0.25.2, 0.24.9

- [CVE-2009-3564: Failure to reset supplementary groups](https://puppet.com/security/cve/cve-2009-3564)

   Resolved in Puppet 0.25.2

## Third-party security announcements

- [CVE-2016-6316: Rails (Action View) XSS Vulnerability](https://puppet.com/security/cve/cve-2016-6316)

   Resolved in Puppet Enterprise 3.8.7

- [OpenSSL September 2016 Security Fixes](https://puppet.com/security/cve/openssl-sep-2016-security-fixes)

   Resolved in Puppet Enterprise 3.8.7 and Puppet Enterprise 2016.4.0, Puppet Agent 1.7.1

- [PostgreSQL August 2016 Security Fixes](https://puppet.com/security/cve/postgresql-aug-2016-security-fixes)

   Resolved in Puppet Enterprise 3.8.7 and Puppet Enterprise 2016.4.0

- [Curl 2016 Security Fixes](https://puppet.com/security/cve/curl-2016-security-fixes)

   Resolved in Puppet Enterprise 2016.4.0, Puppet Agent 1.7.1

- [Nokogiri June 2016 Security Fixes](https://puppet.com/security/cve/nokogiri-jun-2016-security-fixes)

   Resolved in Puppet Enterprise 2016.2.1 and Puppet agent 1.5.3

- [Libxml2 May 2016 Security Fixes](https://puppet.com/security/cve/libxml2-may-2016-security-fixes)

   Resolved in Puppet Enterprise 2016.2.1 and Puppet agent 1.5.3

- [Stomp June 2016 Security Fixes](https://puppet.com/security/cve/stomp-gem-jun-2016-security-fixes)

   Resolved in Puppet Enterprise 2016.2.1 and Puppet agent 1.5.3

- [Oracle Java July 2016 Security Fixes](https://puppet.com/security/cve/oracle-java-jul-2016-security-fixes)

   Resolved in Puppet Enterprise 3.8.6 and Puppet Enterprise 2016.2.1

- [CVE-2011-4971: Memcached vulnerability](https://puppet.com/security/cve/cve-2011-4971)

   Resolved in Puppet Enterprise 3.8.6

- [CVE-2015-7995: libxslt vulnerability](https://puppet.com/security/cve/cve-2015-7995)

   Resolved in Puppet Enterprise 2016.2.1 and Puppet agent 1.5.3

- [OpenSSL May 2016 Security Fixes](https://puppet.com/security/cve/openssl-may-2016-security-fixes)

   Resolved in Puppet Enterprise 2016.2

- [NGINX January 2016 Security Fixes](https://puppet.com/security/cve/nginx-jan-2016-security-fixes)

   Resolved in Puppet Enterprise 2016.1.2

- [Rails February 2016 Security Fixes](https://puppet.com/security/cve/rails-feb-2016-security-fixes)

   Resolved in Puppet Enterprise 3.8.5

- [ActiveMQ March 2016 Security Fixes](https://puppet.com/security/cve/activemq-mar-2016-security-fixes)

   Resolved in Puppet Enterprise 2016.1.2 and Puppet Enterprise 3.8.5

- [Oracle Java April 2016 Security Fixes](https://puppet.com/security/cve/oracle-java-apr-2016-security-fixes)

   Resolved in Puppet Enterprise 2016.1.2 and Puppet Enterprise 3.8.5

- [CVE-2016-0787: libssh2 Vulnerability](https://puppet.com/security/cve/CVE-2016-0787)

   Resolved in Puppet Enterprise 2015.3.3

- [CVE-2016-0739: libssh Vulnerability](https://puppet.com/security/cve/CVE-2016-0739)

   Resolved in Puppet Enterprise 2015.3.3

- [CVE-2016-0773: PostgreSQL regular expression parsing vulnerability](https://puppet.com/security/cve/CVE-2016-0773)

   Resolved in Puppet Enterprise 2015.3.3 and Puppet Enterprise 3.8.5

- [OpenSSL March 2016 Security Fixes](https://puppet.com/security/cve/openssl-mar-2016-security-fixes)

   Resolved in Puppet Enterprise 2015.3.3 and Puppet Enterprise 3.8.5

- [Oracle Java January 2016 Security Fixes](https://puppet.com/security/cve/oracle-java-jan-2016-security-fixes)

   Resolved in Puppet Enterprise 2015.3.2 and Puppet Enterprise 3.8.4

- [Rails January 2016 Security Fixes](https://puppet.com/security/cve/rails-jan-2016-security-fixes)

   Resolved in Puppet Enterprise 3.8.4

- [OpenSSL January 2016 Security Fixes](https://puppet.com/security/cve/openssl-jan-2016-security-fixes)

   Resolved in Puppet Enterprise 2015.3.2, Puppet Enterprise 3.8.4, Puppet Agent 1.3.5 and Puppet 3.8.6 (Windows)

- [Passenger December 2015 Security Fixes](https://puppet.com/security/cve/passenger-dec-2015-security-fixes)

   Resolved in Puppet Enterprise 3.8.4

- [ActiveMQ December 2015 Security Fixes](https://puppet.com/security/cve/activemq-dec-2015-security-fixes)

   Resolved in Puppet Enterprise 2015.3.2 and Puppet Enterprise 3.8.4

- [OpenSSL December 2015 Security Fixes](https://puppet.com/security/cve/openssl-dec-2015-security-fixes)

   Resolved in Puppet Agent 1.3.4

- [CVE-2015-7551: Fiddle and DL Ruby Vulnerability](https://puppet.com/security/cve/ruby-dec-2015-security-fixes)

   Resolved in Puppet Enterprise 2015.3.2, Puppet Enterprise 3.8.4, Puppet Agent 1.3.4 and Puppet 3.8.5 (Windows)

- [Oracle Java October 2015 Security Fixes](https://puppet.com/security/cve/oracle-java-october-2015-security-fixes)

   Resolved in Puppet Enterprise 3.8.3 and 2015.2.3

- [PostgreSQL October 2015 Security Fixes](https://puppet.com/security/cve/postgresql-october-2015-security-fixes)

   Resolved in Puppet Enterprise 3.8.3 and 2015.2.3

- [Ruby on Rails Project June 2015 Security Fixes](https://puppet.com/security/cve/rubyonrails-june-2015-security-fixes)

   Resolved in Puppet Enterprise 3.8.2

- [CVE-2015-3183: HTTP Request Smuggling Vulnerability in Apache HTTP Server](https://puppet.com/security/cve/CVE-2015-3183)

   Resolved in Puppet Enterprise 3.8.2

- [CVE-2014-6272: Potential Heap Overflow Vulnerability in Libevent](https://puppet.com/security/cve/CVE-2014-6272)

   Resolved in Puppet Enterprise 3.8.2

- [Oracle Java July 2015 Security Fixes](https://puppet.com/security/cve/oracle-java-july-2015-security-fixes)

   Resolved in Puppet Enterprise 3.8.2 and 2015.2.0

- [cURL June 2015 Security Fixes](https://puppet.com/security/cve/curl-june-2015-fixes)

   Resolved in Puppet Enterprise 2015.2.0

- [CVE-2015-4000: Logjam TLS Vulnerability](https://puppet.com/security/cve/CVE-2015-4000)

   Resolved in Puppet Enterprise 3.8.1

- [OpenSSL June 2015 Security Fixes](https://puppet.com/security/cve/openssl-june-2015-vulnerability-fix)

   Resolved in Puppet Enterprise 3.8.1 and Puppet-Agent 1.1.1

- [PostgreSQL May 2015 Security Fixes](https://puppet.com/security/cve/postgresql-may-2015-vulnerability-fix)

   Resolved in Puppet Enterprise 3.8.1

- [Apache ActiveMQ February 2015 Security Fixes](https://puppet.com/security/cve/activemq-february-2015-vulnerability-fix)

   Resolved in Puppet Enterprise 3.8.1

- [CVE-2015-3900, CVE-2015-4020: Request Hijacking Vulnerability in RubyGems](https://puppet.com/security/cve/CVE-2015-3900)

   Resolved in Puppet Enterprise 3.8.1, Puppet Agent 1.1.1, and Razor Server 1.0.1

- [CVE-2015-1855: Ruby OpenSSL Hostname Verification](https://puppet.com/security/cve/cve-2015-1855)

   Resolved in Puppet Enterprise 3.8.0 and Puppet-Agent 1.0.1

- [CVE-2014-9130: LibYAML vulnerability could allow denial of service](https://puppet.com/security/cve/cve-2014-9130)

   Resolved in Puppet Enterprise 3.8.0

- [Oracle Java April 2015 Security Fixes](https://puppet.com/security/cve/oracle-java-april-2015-security-fixes)

   Resolved in Puppet Enterprise 3.8.0

- [OpenSSL March 2015 Security Fixes](https://puppet.com/security/cve/openssl-march-2015-vulnerability-fix)

   Resolved in Puppet Enterprise 3.8.0

- [PostgreSQL February 2015 Security Fixes](https://puppet.com/security/cve/postgresql-february-2015-vulnerability-fixes)

   Resolved in Puppet Enterprise 3.8.0

- [OpenSSL January 2015 Security Fixes](https://puppet.com/cve/openssl-january-2015-vulnerability-fix)

   Resolved in Puppet Enterprise 3.7.2

- [Oracle Java January 2015 Security Fixes](https://puppet.com/security/cve/oracle-java-january-2015-vulnerability-fix)

   Resolved in Puppet Enterprise 3.7.2

- [CVE-2015-1426: Potential sensitive information leakage in Facter’s Amazon EC2 metadata facts handling](https://puppet.com/security/cve/cve-2015-1426)

   Resolved in Puppet Enterprise 3.7.2, Facter 2.4.1, CFacter 0.3.0

- [CVE-2014-7818 and CVE-2014-7829: Rails Action Pack Vulnerabilities](https://puppet.com/security/cve/cve-2014-7829)

   Resolved in Puppet Enterprise 3.7.1

- [OpenSSL October 2014 Security Fixes](https://puppet.com/security/cve/openssl-october-2014-vulnerability-fix)

   Resolved in Puppet Enterprise 3.7.0

- [Oracle Java October 2014 Security Fixes](https://puppet.com/security/cve/oracle-october-2014-vulnerability-fix)

   Resolved in Puppet Enterprise 3.7.0

- [CVE-2014-3566: POODLE SSLv3 Vulnerability](https://puppet.com/security/cve/poodle-sslv3-vulnerability)

   Resolved in Puppet Enterprise 3.7.0, Puppet 3.7.2, Puppet-Server 0.3.0, PuppetDB 2.2, and MCollective 2.6.1
   Manual remediation available for Puppet Enterprise 3.3

- [Puppet Forge October 2014 Vulnerability Fix](https://puppet.com/security/cve/puppet-forge-october-2014-vulnerability-fix)

   Resolved in Puppet Forge

- [OpenSSL August 2014 Vulnerability Fix](https://puppet.com/security/cve/openssl-august-2014-vulnerability-fix)

   Resolved in Puppet Enterprise 2.8.8, 3.3.2

- [CVE-2014-0226: Apache vulnerability in mod_status module could allow arbitrary code execution](https://puppet.com/security/cve/cve-2014-0226)

   Resolved in Puppet Enterprise 2.8.8, 3.3.2

- [CVE-2014-0118: Apache vulnerability in mod_deflate module could allow denial of service attacks](https://puppet.com/security/cve/cve-2014-0118)

   Resolved in Puppet Enterprise 2.8.8, 3.3.2

- [CVE-2014-0231: Apache vulnerability in mod_cgid module could allow denial of service attacks](https://puppet.com/security/cve/cve-2014-0231)

   Resolved in Puppet Enterprise 2.8.8, 3.3.2

- [Oracle Java July 2014 Vulnerability Fix](https://puppet.com/security/cve/oracle-july-2014-vulnerability-fix)

   Resolved in Puppet Enterprise 3.3.1

- [CVE-2014-0198: OpenSSL vulnerability could allow denial of service attack](https://puppet.com/security/cve/cve-2014-0198)

   Resolved in Puppet Enterprise 3.3.0

- [CVE-2014-0224: OpenSSL vulnerability in secure communications](https://puppet.com/security/cve/cve-2014-0224)

   Resolved in Puppet Enterprise 3.3.0

- [CVE-2014-3248: Arbitrary Code Execution with Required Social Engineering](https://puppet.com/security/cve/cve-2014-3248)

   Resolved in Puppet Enterprise 2.8.7, Puppet 2.7.26, 3.6.2, Facter 2.0.2, Hiera 1.3.4, Mcollective 2.5.2

- [CVE-2014-3250: Information Leakage Vulnerability](https://puppet.com/security/cve/CVE-2014-3250)

   Resolved in Puppet 3.6.2, Puppet Enterprise not affected

- [Oracle Java April 2014 Vulnerability Fix](https://puppet.com/security/cve/oracle-april-vulnerability-fix)

   Resolved in Puppet Enterprise 3.2.3

- [CVE-2014-2525: LibYAML vulnerability could allow arbitrary code execution in a URI in a YAML file](https://puppet.com/security/cve/cve-2014-2525)

   Resolved in Puppet Enterprise 3.2.2

- [CVE-2014-0098: Apache vulnerability in config module could allow denial of service attacks via cookies](https://puppet.com/security/cve/cve-2014-0098)

   Resolved in Puppet Enterprise 3.2.2, 2.8.6

- [CVE-2013-6438: Apache vulnerability in `mod_dav` module could allow denial of service attacks via DAV WRITE requests](https://puppet.com/security/cve/cve-2013-6438)

   Resolved in Puppet Enterprise 3.2.2, 2.8.6

- [CVE-2014-0082: ActionView vulnerability in Ruby on Rails](https://puppet.com/security/cve/cve-2014-0082)

   Resolved in Puppet Enterprise 3.2.0

- [CVE-2014-0060: PostgreSQL security bypass vulnerability](https://puppet.com/security/cve/cve-2014-0060)

   Resolved in Puppet Enterprise 3.2.0

- [CVE-2013-6393: Potential denial of service (daemon crash) or arbitrary code execution via libyaml](https://puppet.com/security/cve/cve-2013-6393)

   Resolved in Puppet Enterprise 3.1.3

- [CVE-2013-6450: Potential denial of service (daemon crash) via crafted traffic from a TLS 1.2 client](https://puppet.com/security/cve/cve-2013-6450)

   Resolved in Puppet Enterprise 3.1.2

- [CVE-2013-6417: Improper consideration of differences in parameter handling between Rack and Rails Requests](https://puppet.com/security/cve/cve-2013-6417)

   Resolved in Puppet Enterprise 2.8.4, 3.1.1

- [CVE-2013-6415: Cross-site scripting (XSS) vulnerability in Ruby on Rails](https://puppet.com/security/cve/cve-2013-6415)

   Resolved in Puppet Enterprise 2.8.4, 3.1.1

- [CVE-2013-6414: Action View vulnerability in Ruby on Rails](https://puppet.com/security/cve/cve-2013-6414)

   Resolved in Puppet Enterprise 3.1.1

- [CVE-2013-4491: XSS vulnerability in Ruby on Rails](https://puppet.com/security/cve/cve-2013-4491)

   Resolved in Puppet Enterprise 3.1.1

- [CVE-2013-4363: Algorithmic Complexity Vulnerability in RubyGems](https://puppet.com/security/cve/cve-2013-4363)

   Resolved in Puppet Enterprise 2.8.4, 3.1.1

- [CVE-2013-4164: Heap overflow in floating point parsing in Ruby](https://puppet.com/security/cve/cve-2013-4164)

   Resolved in Puppet Enterprise 2.8.4, 3.1.1

- [CVE-2013-4287: Rubygems Algorithmic Complexity DOS Vulnerability](https://puppet.com/security/cve/cve-2013-4287)

   Resolved in Puppet Enterprise 3.1.0

- [CVE-2013-4961: Software Version Numbers Were Revealed](https://puppet.com/security/cve/cve-2013-4961)

   Resolved in Puppet Enterprise 3.0.1

- [CVE-2013-4959: Sensitive Data Browser Caching](https://puppet.com/security/cve/cve-2013-4959)

   Resolved in Puppet Enterprise 3.0.1

- [CVE-2013-4073: Ruby SSL Vulnerability](https://puppet.com/security/cve/cve-2013-4073)

   Resolved in Puppet Enterprise 2.8.3, 3.0.1

- [CVE-2013-3567: Unauthenticated Remote Code Execution Vulnerability](https://puppet.com/security/cve/cve-2013-3567)

   Resolved in Puppet 2.7.22, 3.2.2, Puppet Enterprise 2.8.2

- [CVE-2013-2716: CAS Client Config Vulnerability](https://puppet.com/security/cve/cve-2013-2716)

   Resolved in Puppet Enterprise 2.8.0

- [CVE-2013-2275: Incorrect Default Report ACL Vulnerability](https://puppet.com/security/cve/cve-2013-2275)

   Resolved in Puppet 2.6.18, 2.7.21, 3.1.1, Puppet Enterprise 1.2.7, 2.7.2

- [CVE-2013-2274: Remote Code Execution Vulnerability](https://puppet.com/security/cve/cve-2013-2274)

   Resolved in Puppet 2.6.18, Puppet Enterprise 1.2.7

- [CVE-2013-2065: Object taint bypassing in DL and Fiddle in Ruby](https://puppet.com/security/cve/cve-2013-2065)

   Resolved in Puppet Enterprise 3.1.0

- [CVE-2013-1655: Unauthenticated Remote Code Execution Vulnerability](https://puppet.com/security/cve/cve-2013-1655)

   Resolved in Puppet 2.7.21, 3.1.1

- [CVE-2013-1654: SSL Protocol Downgrade Vulnerability](https://puppet.com/security/cve/cve-2013-1654)

   Resolved in Puppet 2.6.18, 2.7.21, 3.1.1, Puppet Enterprise 1.2.7, 2.7.2

- [CVE-2013-1652: Insufficient Input Validation Vulnerability](https://puppet.com/security/cve/cve-2013-1652)

   Resolved in Puppet 2.6.18, 2.7.21, 3.1.1, Puppet Enterprise 1.2.7, 2.7.2

- [CVE-2013-1640: Remote Code Execution Vulnerability](https://puppet.com/security/cve/cve-2013-1640)

   Resolved in Puppet 2.6.18, 2.7.21, 3.1.1, Puppet Enterprise 1.2.7, 2.7.2

- [CVE-2013-0277: Rails (ActiveRecord) YAML Serialization Vulnerability](https://puppet.com/security/cve/cve-2013-0277)

   Puppet Enterprise Hotfixes for Puppet Enterprise 1.2.6, and 2.7.1

- [CVE-2013-0269: JSON Unsafe Object Creation Vulnerability](https://puppet.com/security/cve/cve-2013-0269)

   Puppet Enterprise Hotfixes for Puppet Enterprise 1.2.6, and 2.7.1

- [CVE-2013-0263: Rack Timing Attack Vulnerability](https://puppet.com/security/cve/cve-2013-0263)

   Puppet Enterprise Hotfixes for Puppet Enterprise 1.2.6, and 2.7.1

- [CVE-2013-0169: OpenSSL Lucky Thirteen Vulnerability](https://puppet.com/security/cve/cve-2013-0169)

   Puppet Enterprise Hotfixes for Puppet Enterprise 1.2.6, and 2.7.1

- [CVE-2013-0333: Rails JSON Parser Vulnerability](https://puppet.com/security/cve/cve-2013-0333)

   Puppet Enterprise Hotfixes for Puppet Enterprise 1.2.5, and 2.7.0

- [CVE-2013-0155: Rails (ActiveRecord) Unsafe Query Generation Risk](https://puppet.com/security/cve/cve-2013-0155)

   Puppet Enterprise Hotfixes for Puppet Enterprise 1.2.5, and 2.7.0

- [CVE-2013-0156: Rails (ActionPack) SQL Injection Vulnerability](https://puppet.com/security/cve/cve-2013-0156)

   Puppet Enterprise Hotfixes for Puppet Enterprise 1.2.5, and 2.7.0

- [CVE-2012-5664: Rails (ActiveRecord) SQL Injection Vulnerability](https://puppet.com/security/cve/cve-2012-5664)

   Puppet Enterprise Hotfixes for Puppet Enterprise 1.2.5, and 2.7.0

- [CVE-2012-1987: Denial of Service](https://puppet.com/security/cve/cve-2012-1987)

   Resolved in Puppet 2.6.15, 2.7.13, Puppet Enterprise Hotfixes for 1.0, 1.1, 1.2.x, and 2.0.x, Puppet Enterprise 2.5.1

- [CVE-2012-1988: Arbitrary Code Execution](https://puppet.com/security/cve/cve-2012-1988)

   Resolved in Puppet 2.6.15, 2.7.13, Puppet Enterprise Hotfixes for 1.0, 1.1, 1.2.x, and 2.0.x, Puppet Enterprise 2.5.1

- [CVE-2012-1054: K5login Local User Privilege Escalation](https://puppet.com/security/cve/cve-2012-1054)

   Resolved in Puppet 2.6.14, 2.7.11, Puppet Enterprise Hotfixes for 1.0, 1.1 and 1.2.x, Puppet Enterprise 2.0.3

- [CVE-2011-3870: SSH Auth Key Local Privilege Escalation](https://puppet.com/security/cve/cve-2011-3870)

   Resolved in 2.7.5 and 2.6.11, Puppet Enterprise 1.2.3

- [CVE-2011-3869: K5login Local Privilege Escalation](https://puppet.com/security/cve/cve-2011-3869)

   Resolved in 2.7.5 and 2.6.11, Puppet Enterprise 1.2.3

- [CVE-2011-3848: Directory Traversal Write Vulnerability](https://puppet.com/security/cve/cve-2011-3848)

   Resolved in Puppet 2.7.4 and 2.6.10, Puppet Enterprise 1.2.2
