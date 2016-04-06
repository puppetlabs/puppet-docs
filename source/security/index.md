---
layout: default
title: "Security and vulnerability announcements"
---

This page collects security announcements related to both internal and third-party software. 

This page contains information about security fixes from both Puppet and third-party software vendors used in Puppet products. For information about our security policies and instructions on how to report findings, refer to the [vulnerability submission process](./vulnerability_submission_process.html).

# Internal Security Announcements

- [CVE-2016-2786: Incorrect Client Verification in Puppet Communications Protocol](https://puppetlabs.com/security/cve/CVE-2016-2786)

   Resolved in Puppet Enterprise 2015.3.3 and Puppet agent 1.3.6

- [CVE-2016-2787: Incorrect Broker Verification in Puppet Communications Protocol](https://puppetlabs.com/security/cve/CVE-2016-2787)

   Resolved in Puppet Enterprise 2015.3.3

- [Advisory: PuppetDB may have insecure permissions on configuration directory](https://puppetlabs.com/security/cve/puppetdb-feb-2016-advisory)

   Resolved in PuppetDB 3.2.4

- [CVE-2015-7330: Non-whitelisted hosts could access Puppet communications protocol](https://puppetlabs.com/security/cve/cve-2015-7330)
   
   Resolved in Puppet Enterprise 2015.3.1

- [CVE-2015-8470: Puppet Enterprise Console JSESSIONID Cookies Are Issued Without the Secure Flag](https://puppetlabs.com/security/cve/CVE-2015-8470)
   
   Resolved in Puppet Enterprise 2015.3.0

- [Advisory: puppetlabs-ntp default configuration does not fully mitigate CVE-2013-5211](https://puppetlabs.com/security/cve/puppetlabs-ntp-nov-2015-advisory)

   Resolved in puppetlabs-ntp 4.1.1

- [CVE-2015-7328: World-Readable CA Keys in Puppet Server](https://puppetlabs.com/security/cve/cve-2015-7328)

   Resolved in Puppet Enterprise 3.8.3 and 2015.2.3

- [CVE-2015-6501: Arbitrary URL Redirection in Puppet Enterprise Console](https://puppetlabs.com/security/cve/CVE-2015-6501)

   Resolved in Puppet Enterprise 2015.2.1

- [CVE-2015-6502: Reflected Cross Site Scripting in Login Redirect](https://puppetlabs.com/security/cve/CVE-2015-6502)

   Resolved in Puppet Enterprise 2015.2.1

- [CVE-2015-7224: puppetlabs-mysql can unexpectedly create database user accounts with no password](https://puppetlabs.com/security/cve/CVE-2015-7224)

   Resolved in puppetlabs-mysql 3.6.1

- [Advisory: Use of the 'port' parameter with puppetlabs-firewall could cause unexpectedly permissive firewall rules](https://puppetlabs.com/security/cve/puppetlabs-firewall-aug-2015-advisory)

   Resolved in puppetlabs-firewall 1.7.1

- [Advisory: `pe-java` Was Not Updated on the Console Node on Split Upgrades](https://puppetlabs.com/security/cve/pe-java-aug-2015-split-upgrade-advisory)

   Resolved in Puppet Enterprise 3.8.2

- [CVE-2015-5686: Console XSS Vulnerability](https://puppetlabs.com/security/cve/console-xss-vulnerabilities)

   Resolved in Puppet Enterprise 2015.2.0

- [CVE-2015-4100: Puppet Enterprise Certificate Authority Reverse Proxy Vulnerability](https://puppetlabs.com/security/cve/CVE-2015-4100)

   Resolved in Puppet Enterprise 3.8.1

- [CWE-352: Cross-Frame Scripting (XFS) Vulnerability in Puppet Enterprise Console](https://puppetlabs.com/security/cve/cwe-352-april-2015)

   Resolved in Puppet Enterprise 3.8.0

- [CVE-2014-9568: Potential information leakage in puppetlabs-rabbitmq facts handling](https://puppetlabs.com/security/cve/cve-2014-9568)

   Resolved in puppetlabs-rabbitmq 5.0

- [CVE-2015-1029: Vulnerability in puppetlabs-stdlib module fact cache](https://puppetlabs.com/security/cve/cve-2015-1029)

   Resolved in puppetlabs-stdlib 4.5.1

- [CVE-2014-9355: Information Leakage in Puppet Enterprise Console](https://puppetlabs.com/security/cve/cve-2014-9355)

   Resolved in Puppet Enterprise 3.7.1

- [CVE-2014-7170: Puppet Server local information leakage](https://puppetlabs.com/security/cve/cve-2014-7170)

   Resolved in Puppet Server 0.2.1

- [CVE-2014-3251: MCollective 'aes_security' plugin vulnerability](https://puppetlabs.com/security/cve/cve-2014-3251?_ga=1.89941202.892778398.1448482056)

   Resolved in Puppet Enterprise 3.3.0, Mcollective 2.5.3

- [CVE-2014-3249: Information leakage in Puppet Enterprise Console](https://puppetlabs.com/security/cve/cve-2014-3249?_ga=1.123956419.892778398.1448482056)

   Resolved in Puppet Enterprise 2.8.7

- [CVE-2013-4971: Unathenticated read access to node endpoints could cause information leakage](https://puppetlabs.com/security/cve/cve-2013-4971?_ga=1.123956419.892778398.1448482056)

   Resolved in Puppet Enterprise 3.2.0

- [CVE-2013-4966: Master external node classification script vulnerable to console impersonation](https://puppetlabs.com/security/cve/cve-2013-4966?_ga=1.123956419.892778398.1448482056)

   Resolved in Puppet Enterprise 3.2.0

- [CVE-2013-4969: Unsafe use of temp files in File type](https://puppetlabs.com/security/cve/cve-2013-4969?_ga=1.11380093.892778398.1448482056)

   Resolved in Puppet 3.4.1, Puppet Enterprise 2.8.4, 3.1.1

- [CVE-2013-4965: Console user account brute force vulnerability](https://puppetlabs.com/security/cve/cve-2013-4965?_ga=1.11380093.892778398.1448482056)

   Resolved in Puppet Enterprise 3.1.0

- [CVE-2013-4957: Puppet Dashboard Report YAML Handling Vulnerability](https://puppetlabs.com/security/cve/cve-2013-4957?_ga=1.82444511.892778398.1448482056)

   Resolved in Puppet Enterprise 3.1.0

- [CVE-2013-4967: External Node Classifiers Allowed Clear Text Database Password Query](http://www.puppetlabs.com/security/cve/cve-2013-4967/?_ga=1.82444511.892778398.1448482056)

   Resolved in Puppet Enterprise 3.0.1

- [CVE-2013-4956: Puppet Module Permissions Vulnerability](https://puppetlabs.com/security/cve/cve-2013-4956?_ga=1.47907310.892778398.14484820560)

   Resolved in Puppet 2.7.23, 3.2.4, Puppet Enterprise 2.8.3, 3.0.1

- [CVE-2013-4762: Logout Link Did Not Destroy Server Session](https://puppetlabs.com/security/cve/cve-2013-4762?_ga=1.47907310.892778398.1448482056)

   Resolved in Puppet Enterprise 3.0.1
   
- [CVE-2013-4962 – Lack of Reauthentication for Sensitive Transactions](https://puppetlabs.com/security/cve/cve-2013-4962?_ga=1.44393069.892778398.1448482056)

   Resolved in Puppet Enterprise 3.0.1

- [CVE-2013-4955: Phishing Through URL Redirection Vulnerability](https://puppetlabs.com/security/cve/cve-2013-4955?_ga=1.94216660.892778398.1448482056)

   Resolved in Puppet Enterprise 3.0.1

- [CVE-2013-4964 – Session Cookies Not Set With Secure Flag](https://puppetlabs.com/security/cve/cve-2013-4964?_ga=1.47400174.892778398.1448482056)

   Resolved in Puppet Enterprise 3.0.1

- [CVE-2013-4968 – Site Lacked Clickjacking Defense](https://puppetlabs.com/security/cve/cve-2013-4968?_ga=1.47400174.892778398.1448482056)

   Resolved in Puppet Enterprise 3.0.1

- [CVE-2013-4963 – Cross-Site Request Forgery Vulnerability](https://puppetlabs.com/security/cve/cve-2013-4963?_ga=1.44393069.892778398.1448482056)

   Resolved in Puppet Enterprise 3.0.1

- [CVE-2013-4958 – Lack of Session Timeout](https://puppetlabs.com/security/cve/cve-2013-4958?_ga=1.48065006.892778398.1448482056)

   Resolved in Puppet Enterprise 3.0.1

- [CVE-2013-4761: `resource_type` Remote Code Execution Vulnerability](https://puppetlabs.com/security/cve/cve-2013-4761?_ga=1.94216660.892778398.1448482056)

   Resolved in Puppet 2.7.23, 3.2.4, Puppet Enterprise 2.8.3, 3.0.1

- [CVE-2013-1653 – Agent Remote Code Execution Vulnerability](https://puppetlabs.com/security/cve/cve-2013-1653?_ga=1.123961923.892778398.1448482056)

   Resolved in Puppet 2.7.21, 3.1.1, Puppet Enterprise 2.7.2

- [CVE-2013-1399: Console CSRF Vulnerability](https://puppetlabs.com/security/cve/cve-2013-1399?_ga=1.118844736.892778398.1448482056)

   Resolved in Puppet Enterprise 2.7.1

- [CVE-2013-1398: MCO Private Key Leak](https://puppetlabs.com/security/cve/cve-2013-1398?_ga=1.118844736.892778398.1448482056)

   Resolved in Puppet Enterprise 2.7.1

- [CVE-2012-5158: Incorrect Session Handling](https://puppetlabs.com/security/cve/cve-2012-5158?_ga=1.47474926.892778398.1448482056)

   Resolved in Puppet Enterprise 2.6.1

- [CVE-2012-3864: Arbitrary File Read](https://puppetlabs.com/security/cve/cve-2012-3864?_ga=1.47474926.892778398.1448482056)

   Resolved in Puppet 2.6.17, 2.7.18, Puppet Enterprise Hotfixes for 1.0, 1.1, 1.2.x, and 2.0.x, Puppet Enterprise 2.5.2

- [CVE-2012-3865: Arbitrary file delete/D.O.S on Puppet Master](https://puppetlabs.com/security/cve/cve-2012-3865?_ga=1.47474926.892778398.1448482056)

   Resolved in Puppet 2.6.17, 2.7.18, Puppet Enterprise Hotfixes for 1.0, 1.1, 1.2.x, and 2.0.x, Puppet Enterprise 2.5.2

- [CVE-2012-3866: last_run_report.yaml is World-Readable](https://puppetlabs.com/security/cve/cve-2012-3866?_ga=1.53316065.892778398.1448482056)

   Resolved in Puppet 2.7.18, Puppet Enterprise Hotfixes for 2.0.x, Puppet Enterprise 2.5.2

- [CVE-2012-3867: Insufficient Input Validation](https://puppetlabs.com/security/cve/cve-2012-3867?_ga=1.53316065.892778398.1448482056)

   Resolved in Puppet 2.6.17, 2.7.18, Puppet Enterprise Hotfixes for 1.0, 1.1, 1.2.x, and 2.0.x, Puppet Enterprise 2.5.2

- [CVE-2012-3408: Agent Impersonation](https://puppetlabs.com/security/cve/cve-2012-3408?_ga=1.53316065.892778398.1448482056)

   Addressed in 2.7.18, Puppet Enterprise Hotfixes for 2.0.x, Puppet Enterprise 2.5.2

- [CVE-2012-1986 - Arbitrary File Read](https://puppetlabs.com/security/cve/cve-2012-1986?_ga=1.119768641.892778398.1448482056)

   Resolved in Puppet 2.6.15, 2.7.13, Puppet Enterprise Hotfixes for 1.0, 1.1, 1.2.x, and 2.0.x, Puppet Enterprise 2.5.1

- [CVE-2012-1988 - Arbitrary Code Execution](https://puppetlabs.com/security/cve/cve-2012-1988?_ga=1.114518606.892778398.1448482056)

   Resolved in Puppet 2.6.15, 2.7.13, Puppet Enterprise Hotfixes for 1.0, 1.1, 1.2.x, and 2.0.x, Puppet Enterprise 2.5.1

- [CVE-2012-1053: Puppet Resource Local Group Privilege Escalation](https://puppetlabs.com/security/cve/cve-2012-1053?_ga=1.11169277.892778398.1448482056)

   Resolved in Puppet 2.6.14, 2.7.11, Puppet Enterprise Hotfixes for 1.0, 1.1 and 1.2.x, Puppet Enterprise 2.0.3

- [CVE-2012-1906 - Arbitrary Code Execution](https://puppetlabs.com/security/cve/cve-2012-1906?_ga=1.19768817.892778398.1448482056)

   Resolved in Puppet 2.6.15, 2.7.13, Puppet Enterprise Hotfixes for 1.0, 1.1, 1.2.x, and 2.0.x, Puppet Enterprise 2.5.1

- [CVE-2012-1989 - Arbitrary File Write](https://puppetlabs.com/security/cve/cve-2012-1989?_ga=1.53194209.892778398.1448482056)

   Resolved in Puppet 2.7.13, Puppet Enterprise 2.5.1, Puppet Enterprise Hotfixes for 2.0.x; not applicable to earlier versions

- [CVE-2012-0891: Dashboard Cross Site Scripting (XSS) Vulnerability](https://puppetlabs.com/security/cve/cve-2012-0891?_ga=1.81439070.892778398.1448482056)

   Resolved in Puppet Dashboard 1.2.5, Puppet Enterprise Hotfixes for 1.0, 1.1 and 1.2.x, Puppet Enterprise 2.0.1

- [CVE-2011-3872: AltNames Vulnerability](https://puppetlabs.com/security/cve/cve-2011-3872?_ga=1.81439070.892778398.1448482056)

   Resolved in Puppet 0.25.6, 2.6.12, 2.7.6, Puppet Enterprise 1.2.4

- [CVE-2011-3871: Puppet Resource Local Privilege Escalation](https://puppetlabs.com/security/cve/cve-2011-3871?_ga=1.81439070.892778398.1448482056)

   Resolved in 2.7.5 and 2.6.11, Puppet Enterprise 1.2.3

- [auth-conf-2010-10: Missing Auth.conf Resource Manipulation](https://puppetlabs.com/security/cve/auth-conf-2010-10?_ga=1.120278465.892778398.1448482056)

   Resolved in Puppet 2.6.4

- [CVE-2010-0156: File overwrite vulnerability via symlink attack](https://puppetlabs.com/security/cve/cve-2010-0156?_ga=1.120278465.892778398.1448482056)

   Resolved in Puppet 0.25.2, 0.24.9

- [CVE-2009-3564: Failure to reset supplementary groups](https://puppetlabs.com/security/cve/cve-2009-3564?_ga=1.49055215.892778398.1448482056)

   Resolved in Puppet 0.25.2


# Third-party Security Announcments

- [CVE-2016-0787: libssh2 Vulnerability](https://puppetlabs.com/security/cve/CVE-2016-0787)

   Resolved in Puppet Enterprise 2015.3.3
   
- [CVE-2016-0739 - libssh Vulnerability](https://puppetlabs.com/security/cve/CVE-2016-0739)

   Resolved in Puppet Enterprise 2015.3.3
   
- [CVE-2016-0773: PostgreSQL Regular Expression Parsing Vulnerability](https://puppetlabs.com/security/cve/CVE-2016-0773)

   Resolved in Puppet Enterprise 2015.3.3
   
- [OpenSSL March 2016 Security Fixes](https://puppetlabs.com/security/cve/openssl-mar-2016-security-fixes)

   Resolved in Puppet Enterprise 2015.3.3

- [Oracle Java January 2016 Security Fixes](https://puppetlabs.com/security/cve/oracle-java-jan-2016-security-fixes)

   Resolved in Puppet Enterprise 2015.3.2 and Puppet Enterprise 3.8.4

- [Rails January 2016 Security Fixes](https://puppetlabs.com/security/cve/rails-jan-2016-security-fixes)

   Resolved in Puppet Enterprise 3.8.4

- [OpenSSL January 2016 Security Fixes](https://puppetlabs.com/security/cve/openssl-jan-2016-security-fixes)

   Resolved in Puppet Enterprise 2015.3.2, Puppet Enterprise 3.8.4, Puppet Agent 1.3.5 and Puppet 3.8.6 (Windows)

- [Passenger December 2015 Security Fixes](https://puppetlabs.com/security/cve/passenger-dec-2015-security-fixes)
   
   Resolved in Puppet Enterprise 3.8.4

- [ActiveMQ December 2015 Security Fixes](https://puppetlabs.com/security/cve/activemq-dec-2015-security-fixes)

   Resolved in Puppet Enterprise 2015.3.2 and Puppet Enterprise 3.8.4

- [OpenSSL December 2015 Security Fixes](https://puppetlabs.com/security/cve/openssl-dec-2015-security-fixes)

   Resolved in Puppet Agent 1.3.4

- [CVE-2015-7551: Fiddle and DL Ruby Vulnerability](https://puppetlabs.com/security/cve/ruby-dec-2015-security-fixes)

   Resolved in Puppet Enterprise 2015.3.2, Puppet Enterprise 3.8.4, Puppet Agent 1.3.4 and Puppet 3.8.5 (Windows)

- [Oracle Java October 2015 Security Fixes](https://puppetlabs.com/security/cve/oracle-java-october-2015-security-fixes)

   Resolved in Puppet Enterprise 3.8.3 and 2015.2.3

- [PostgreSQL October 2015 Security Fixes](https://puppetlabs.com/security/cve/postgresql-october-2015-security-fixes)

   Resolved in Puppet Enterprise 3.8.3 and 2015.2.3

- [Ruby on Rails Project June 2015 Security Fixes](https://puppetlabs.com/security/cve/rubyonrails-june-2015-security-fixes)

   Resolved in Puppet Enterprise 3.8.2

- [CVE-2015-3183: HTTP Request Smuggling Vulnerability in Apache HTTP Server](https://puppetlabs.com/security/cve/CVE-2015-3183)

   Resolved in Puppet Enterprise 3.8.2

- [CVE-2014-6272: Potential Heap Overflow Vulnerability in Libevent](https://puppetlabs.com/security/cve/CVE-2014-6272)

   Resolved in Puppet Enterprise 3.8.2

- [Oracle Java July 2015 Security Fixes](https://puppetlabs.com/security/cve/oracle-java-july-2015-security-fixes)

   Resolved in Puppet Enterprise 3.8.2 and 2015.2.0

- [cURL June 2015 Security Fixes](https://puppetlabs.com/security/cve/curl-june-2015-fixes)

   Resolved in Puppet Enterprise 2015.2.0

- [CVE-2015-4000: Logjam TLS Vulnerability](https://puppetlabs.com/security/cve/CVE-2015-4000)

   Resolved in Puppet Enterprise 3.8.1

- [OpenSSL June 2015 Security Fixes](https://puppetlabs.com/security/cve/openssl-june-2015-vulnerability-fix)

   Resolved in Puppet Enterprise 3.8.1 and Puppet-Agent 1.1.1

- [PostgreSQL May 2015 Security Fixes](https://puppetlabs.com/security/cve/postgresql-may-2015-vulnerability-fix)

   Resolved in Puppet Enterprise 3.8.1

- [Apache ActiveMQ February 2015 Security Fixes](https://puppetlabs.com/security/cve/activemq-february-2015-vulnerability-fix)

   Resolved in Puppet Enterprise 3.8.1

- [CVE-2015-3900, CVE-2015-4020: Request Hijacking Vulnerability in RubyGems](https://puppetlabs.com/security/cve/CVE-2015-3900)

   Resolved in Puppet Enterprise 3.8.1, Puppet Agent 1.1.1, and Razor Server 1.0.1

- [CVE-2015-1855: Ruby OpenSSL Hostname Verification](https://puppetlabs.com/security/cve/cve-2015-1855)

   Resolved in Puppet Enterprise 3.8.0 and Puppet-Agent 1.0.1

- [CVE-2014-9130: LibYAML vulnerability could allow denial of service](https://puppetlabs.com/security/cve/cve-2014-9130)

   Resolved in Puppet Enterprise 3.8.0

- [Oracle Java April 2015 Security Fixes](https://puppetlabs.com/security/cve/oracle-java-april-2015-security-fixes)

   Resolved in Puppet Enterprise 3.8.0

- [OpenSSL March 2015 Security Fixes](https://puppetlabs.com/security/cve/openssl-march-2015-vulnerability-fix)

   Resolved in Puppet Enterprise 3.8.0

- [PostgreSQL February 2015 Security Fixes](https://puppetlabs.com/security/cve/postgresql-february-2015-vulnerability-fixes)

   Resolved in Puppet Enterprise 3.8.0

- [OpenSSL January 2015 Security Fixes](https://puppetlabs.com/cve/openssl-january-2015-vulnerability-fix)

   Resolved in Puppet Enterprise 3.7.2

- [Oracle Java January 2015 Security Fixes](https://puppetlabs.com/security/cve/oracle-java-january-2015-vulnerability-fix)

   Resolved in Puppet Enterprise 3.7.2

- [CVE-2015-1426: Potential sensitive information leakage in Facter’s Amazon EC2 metadata facts handling](http://puppetlabs.com/security/cve/cve-2015-1426)

   Resolved in Puppet Enterprise 3.7.2, Facter 2.4.1, CFacter 0.3.0

- [CVE-2014-7818 and CVE-2014-7829: Rails Action Pack Vulnerabilities](http://puppetlabs.com/security/cve/cve-2014-7818)

   Resolved in Puppet Enterprise 3.7.1

- [OpenSSL October 2014 Security Fixes](http://puppetlabs.com/security/cve/openssl-october-2014-vulnerability-fix)

   Resolved in Puppet Enterprise 3.7.0

- [Oracle Java October 2014 Security Fixes](http://puppetlabs.com/security/cve/oracle-october-2014-vulnerability-fix)

   Resolved in Puppet Enterprise 3.7.0

- [CVE-2014-3566: POODLE SSLv3 Vulnerability](https://puppetlabs.com/security/cve/poodle-sslv3-vulnerability)

   Resolved in Puppet Enterprise 3.7.0, Puppet 3.7.2, Puppet-Server 0.3.0, PuppetDB 2.2, and MCollective 2.6.1
   Manual remediation available for Puppet Enterprise 3.3

- [Puppet Forge October 2014 Vulnerability Fix](http://puppetlabs.com/security/cve/puppet-forge-october-2014-vulnerability-fix/)

   Resolved in Puppet Forge

- [OpenSSL August 2014 Vulnerability Fix](https://puppetlabs.com/security/cve/openssl-august-2014-vulnerability-fix)

   Resolved in Puppet Enterprise 2.8.8, 3.3.2

- [CVE-2014-0226: Apache vulnerability in mod_status module could allow arbitrary code execution](https://puppetlabs.com/security/cve/cve-2014-0226)

   Resolved in Puppet Enterprise 2.8.8, 3.3.2

- [CVE-2014-0118: Apache vulnerability in mod_deflate module could allow denial of service attacks](https://puppetlabs.com/security/cve/cve-2014-0118)

   Resolved in Puppet Enterprise 2.8.8, 3.3.2

- [CVE-2014-0231: Apache vulnerability in mod_cgid module could allow denial of service attacks](https://puppetlabs.com/security/cve/cve-2014-0231)

   Resolved in Puppet Enterprise 2.8.8, 3.3.2

- [Oracle Java July 2014 Vulnerability Fix](http://puppetlabs.com/security/cve/oracle-july-2014-vulnerability-fix/)

   Resolved in Puppet Enterprise 3.3.1

- [CVE-2014-0198: OpenSSL vulnerability could allow denial of service attack](https://puppetlabs.com/security/cve/cve-2014-0198?_ga=1.123381314.892778398.1448482056)

   Resolved in Puppet Enterprise 3.3.0

- [CVE-2014-0224: OpenSSL vulnerability in secure communications](http://www.puppetlabs.com/security/cve/cve-2014-0224/?_ga=1.123381314.892778398.1448482056)

   Resolved in Puppet Enterprise 3.3.0

- [CVE-2014-3248: Arbitrary Code Execution with Required Social Engineering](http://www.puppetlabs.com/security/cve/cve-2014-3248/?_ga=1.81961439.892778398.1448482056)

   Resolved in Puppet Enterprise 2.8.7, Puppet 2.7.26, 3.6.2, Facter 2.0.2, Hiera 1.3.4, Mcollective 2.5.2

- [CVE-2014-3250: Information Leakage Vulnerability](http://www.puppetlabs.com/security/cve/cve-2014-3250/?_ga=1.81961439.892778398.1448482056)

   Resolved in Puppet 3.6.2, Puppet Enterprise not affected

- [Oracle Java April 2014 Vulnerability Fix](https://puppetlabs.com/security/cve/oracle-april-vulnerability-fix)

   Resolved in Puppet Enterprise 3.2.3

- [CVE-2014-2525: LibYAML vulnerability could allow arbitrary code execution in a URI in a YAML file](https://puppetlabs.com/security/cve/cve-2014-2525?_ga=1.261923268.892778398.1448482056)

   Resolved in Puppet Enterprise 3.2.2

- [CVE-2014-0098: Apache vulnerability in config module could allow denial of service attacks via cookies](https://puppetlabs.com/security/cve/cve-2014-0098?_ga=1.261923268.892778398.1448482056)

   Resolved in Puppet Enterprise 3.2.2, 2.8.6

- [CVE-2013-6438: Apache vulnerability in `mod_dav` module could allow denial of service attacks via DAV WRITE requests](https://puppetlabs.com/security/cve/cve-2013-6438?_ga=1.85166672.892778398.1448482056)

   Resolved in Puppet Enterprise 3.2.2, 2.8.6

- [CVE-2014-0082: ActionView vulnerability in Ruby on Rails](https://puppetlabs.com/security/cve/cve-2014-0082?_ga=1.85166672.892778398.1448482056)

   Resolved in Puppet Enterprise 3.2.0

- [CVE-2014-0060: PostgreSQL security bypass vulnerability](https://puppetlabs.com/security/cve/cve-2014-0060?_ga=1.123470018.892778398.1448482056)

   Resolved in Puppet Enterprise 3.2.0

- [CVE-2013-6393: Potential denial of service (daemon crash) or arbitrary code execution via libyaml](https://puppetlabs.com/security/cve/cve-2013-6393?_ga=1.57296355.892778398.1448482056)

   Resolved in Puppet Enterprise 3.1.3

- [CVE-2013-6450: Potential denial of service (daemon crash) via crafted traffic from a TLS 1.2 client](https://puppetlabs.com/security/cve/cve-2013-6450?_ga=1.119826881.892778398.1448482056)

   Resolved in Puppet Enterprise 3.1.2

- [CVE-2013-6417: Improper consideration of differences in parameter handling between Rack and Rails Requests](https://puppetlabs.com/security/cve/cve-2013-6417?_ga=1.44326509.892778398.1448482056)

   Resolved in Puppet Enterprise 2.8.4, 3.1.1

- [CVE-2013-6415: Cross-site scripting (XSS) vulnerability in Ruby on Rails](https://puppetlabs.com/security/cve/cve-2013-6415?_ga=1.44326509.892778398.1448482056)

   Resolved in Puppet Enterprise 2.8.4, 3.1.1

- [CVE-2013-6414: Action View vulnerability in Ruby on Rails](https://puppetlabs.com/security/cve/cve-2013-6414?_ga=1.52797793.892778398.1448482056)

   Resolved in Puppet Enterprise 3.1.1

- [CVE-2013-4491: XSS vulnerability in Ruby on Rails](https://puppetlabs.com/security/cve/cve-2013-4491?_ga=1.52797793.892778398.1448482056)

   Resolved in Puppet Enterprise 3.1.1

- [CVE-2013-4363: Algorithmic Complexity Vulnerability in RubyGems](https://puppetlabs.com/security/cve/cve-2013-4363?_ga=1.52797793.892778398.1448482056)

   Resolved in Puppet Enterprise 2.8.4, 3.1.1

- [CVE-2013-4164: Heap overflow in floating point parsing in Ruby](https://puppetlabs.com/security/cve/cve-2013-4164?_ga=1.47400174.892778398.1448482056)

   Resolved in Puppet Enterprise 2.8.4, 3.1.1

- [CVE-2013-4287: Rubygems Algorithmic Complexity DOS Vulnerability](https://puppetlabs.com/security/cve/cve-2013-4287?_ga=1.47400174.892778398.1448482056)

   Resolved in Puppet Enterprise 3.1.0

- [CVE-2013-4961: Software Version Numbers Were Revealed](https://puppetlabs.com/security/cve/cve-2013-4961?_ga=1.52799841.892778398.1448482056)

   Resolved in Puppet Enterprise 3.0.1

- [CVE-2013-4959: Sensitive Data Browser Caching](https://puppetlabs.com/security/cve/cve-2013-4959?_ga=1.48065006.892778398.1448482056)

   Resolved in Puppet Enterprise 3.0.1

- [CVE-2013-4073: Ruby SSL Vulnerability](https://puppetlabs.com/security/cve/cve-2013-4073?_ga=1.51668192.892778398.1448482056)

   Resolved in Puppet Enterprise 2.8.3, 3.0.1

- [CVE-2013-3567: Unauthenticated Remote Code Execution Vulnerability](https://puppetlabs.com/security/cve/cve-2013-3567?_ga=1.85172816.892778398.1448482056)

   Resolved in Puppet 2.7.22, 3.2.2, Puppet Enterprise 2.8.2

- [CVE-2013-2716: CAS Client Config Vulnerability](https://puppetlabs.com/security/cve/cve-2013-2716?_ga=1.85172816.892778398.1448482056)

   Resolved in Puppet Enterprise 2.8.0

- [CVE-2013-2275: Incorrect Default Report ACL Vulnerability](https://puppetlabs.com/security/cve/cve-2013-2275?_ga=1.85172816.892778398.1448482056)

   Resolved in Puppet 2.6.18, 2.7.21, 3.1.1, Puppet Enterprise 1.2.7, 2.7.2

- [CVE-2013-2274: Remote Code Execution Vulnerability](https://puppetlabs.com/security/cve/cve-2013-2274?_ga=1.23299443.892778398.1448482056)

   Resolved in Puppet 2.6.18, Puppet Enterprise 1.2.7

- [CVE-2013-2065: Object taint bypassing in DL and Fiddle in Ruby](https://puppetlabs.com/security/cve/cve-2013-2065?_ga=1.23299443.892778398.1448482056)

   Resolved in Puppet Enterprise 3.1.0

- [CVE-2013-1655: Unauthenticated Remote Code Execution Vulnerability](https://puppetlabs.com/security/cve/cve-2013-1655?_ga=1.23299443.892778398.1448482056)

   Resolved in Puppet 2.7.21, 3.1.1

- [CVE-2013-1654: SSL Protocol Downgrade Vulnerability](https://puppetlabs.com/security/cve/cve-2013-1654?_ga=1.123961923.892778398.1448482056)

   Resolved in Puppet 2.6.18, 2.7.21, 3.1.1, Puppet Enterprise 1.2.7, 2.7.2

- [CVE-2013-1652: Insufficient Input Validation Vulnerability](https://puppetlabs.com/security/cve/cve-2013-1652?_ga=1.78424413.892778398.1448482056)

   Resolved in Puppet 2.6.18, 2.7.21, 3.1.1, Puppet Enterprise 1.2.7, 2.7.2

- [CVE-2013-1640: Remote Code Execution Vulnerability](http://www.puppetlabs.com/security/cve/cve-2013-1640/?_ga=1.78424413.892778398.1448482056)

   Resolved in Puppet 2.6.18, 2.7.21, 3.1.1, Puppet Enterprise 1.2.7, 2.7.2

- [CVE-2013-0277: Rails (ActiveRecord) YAML Serialization Vulnerability](https://puppetlabs.com/security/cve/cve-2013-0277?_ga=1.81021534.892778398.1448482056)

   Puppet Enterprise Hotfixes for Puppet Enterprise 1.2.6, and 2.7.1

- [CVE-2013-0269: JSON Unsafe Object Creation Vulnerability](https://puppetlabs.com/security/cve/cve-2013-0269?_ga=1.81021534.892778398.1448482056)

   Puppet Enterprise Hotfixes for Puppet Enterprise 1.2.6, and 2.7.1

- [CVE-2013-0263: Rack Timing Attack Vulnerability](https://puppetlabs.com/security/cve/cve-2013-0263?_ga=1.81021534.892778398.1448482056)

   Puppet Enterprise Hotfixes for Puppet Enterprise 1.2.6, and 2.7.1

- [CVE-2013-0169: OpenSSL Lucky Thirteen Vulnerability](https://puppetlabs.com/security/cve/cve-2013-0169?_ga=1.56460642.892778398.1448482056)

   Puppet Enterprise Hotfixes for Puppet Enterprise 1.2.6, and 2.7.1

- [CVE-2013-0333: Rails JSON Parser Vulnerability](https://puppetlabs.com/security/cve/cve-2013-0333?_ga=1.56460642.892778398.1448482056)

   Puppet Enterprise Hotfixes for Puppet Enterprise 1.2.5, and 2.7.0

- [CVE-2013-0155: Rails (ActiveRecord) Unsafe Query Generation Risk](https://puppetlabs.com/security/cve/cve-2013-0155?_ga=1.56460642.892778398.1448482056)

   Puppet Enterprise Hotfixes for Puppet Enterprise 1.2.5, and 2.7.0

- [CVE-2013-0156: Rails (ActionPack) SQL Injection Vulnerability](https://puppetlabs.com/security/cve/cve-2013-0156?_ga=1.119776577.892778398.1448482056)

   Puppet Enterprise Hotfixes for Puppet Enterprise 1.2.5, and 2.7.0

- [CVE-2012-5664: Rails (ActiveRecord) SQL Injection Vulnerability](https://puppetlabs.com/security/cve/cve-2012-5664?_ga=1.119776577.892778398.1448482056)

   Puppet Enterprise Hotfixes for Puppet Enterprise 1.2.5, and 2.7.0

- [CVE-2012-1987: Denial of Service](https://puppetlabs.com/security/cve/cve-2012-1987?_ga=1.114518606.892778398.1448482056)

   Resolved in Puppet 2.6.15, 2.7.13, Puppet Enterprise Hotfixes for 1.0, 1.1, 1.2.x, and 2.0.x, Puppet Enterprise 2.5.1

- [CVE-2012-1988: Arbitrary Code Execution](https://puppetlabs.com/security/cve/cve-2012-1988?_ga=1.114518606.892778398.1448482056)

   Resolved in Puppet 2.6.15, 2.7.13, Puppet Enterprise Hotfixes for 1.0, 1.1, 1.2.x, and 2.0.x, Puppet Enterprise 2.5.1

- [CVE-2012-1054: K5login Local User Privilege Escalation](https://puppetlabs.com/security/cve/cve-2012-1054?_ga=1.23896691.892778398.1448482056)

   Resolved in Puppet 2.6.14, 2.7.11, Puppet Enterprise Hotfixes for 1.0, 1.1 and 1.2.x, Puppet Enterprise 2.0.3

- [CVE-2011-3870: SSH Auth Key Local Privilege Escalation](https://puppetlabs.com/security/cve/cve-2011-3870?_ga=1.23896691.892778398.1448482056)

   Resolved in 2.7.5 and 2.6.11, Puppet Enterprise 1.2.3

- [CVE-2011-3869: K5login Local Privilege Escalation](https://puppetlabs.com/security/cve/cve-2011-3869?_ga=1.116108623.892778398.1448482056)

   Resolved in 2.7.5 and 2.6.11, Puppet Enterprise 1.2.3

- [CVE-2011-3848: Directory Traversal Write Vulnerability](https://puppetlabs.com/security/cve/cve-2011-3848?_ga=1.116108623.892778398.1448482056)

   Resolved in Puppet 2.7.4 and 2.6.10, Puppet Enterprise 1.2.2






