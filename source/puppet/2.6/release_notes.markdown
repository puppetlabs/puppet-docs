---
layout: default
title: Puppet 2.6 Release Notes
description: Puppet release notes for version 2.6.x
---

# Puppet 2.6 Release Notes

## 2.6.18

Puppet 2.6.18 is a **security release** addressing several vulnerabilities discovered in the 2.6.x line of Puppet. These vulnerabilities have been assigned Mitre CVE numbers [CVE-2013-1640][], [CVE-2013-1652][], [CVE-2013-1654][], [CVE-2013-2274][], and [CVE-2013-2275][].

All users of Puppet 2.6.17 and earlier who cannot upgrade to the current version of Puppet, 3.1.1, are strongly encouraged to upgrade
to 2.6.18.

### 2.6.18 Downloads 

* Source: <https://downloads.puppetlabs.com/puppet/puppet-2.6.18.tar.gz>
* RPMs: <https://yum.puppetlabs.com/el> or `/fedora`
* Debs: <https://apt.puppetlabs.com>

See the Verifying Puppet Download section at:  
<http://puppetlabs.com/misc/download-options>

Please report feedback via the Puppet Labs JIRA site, using an affected puppet version of 2.6.18:  
<https://tickets.puppetlabs.com/browse/PUP>

### 2.6.18 Changelog

* Andrew Parker (2):
     * (#14093) Remove unsafe attributes from TemplateWrapper
     * (#14093) Restore access to the filename in the template

* Daniel Pittman (2):
     * (#8858) Refactor tests to use real HTTP objects
     * (#8858) Explicitly set SSL peer verification mode.

* Jeff McCune (2):
     * (#19151) Reject SSLv2 SSL handshakes and ciphers
     * (#19531) (CVE-2013-2275) Only allow report save from the node matching the certname

* Josh Cooper (8):
     * (#19391) Backport Request#remote? method
     * Run openssl from windows when trying to downgrade master
     * Remove unnecessary rubygems require
     * Don't assume puppetbindir is defined
     * Display SSL messages so we can match our regex
     * Don't require openssl client to return 0 on failure
     * Don't assume master supports SSLv2
     * (#19391) Find the catalog for the specified node name

* Justin Stoller (2):
     * Acceptance tests for CVEs 2013 (1640, 1652, 1653, 1654, 2274, 2275)
     * Separate tests for same CVEs into separate files

* Matthaus Owens (1):
     * Update CHANGELOG, lib/puppet.rb, conf/redhat/puppet.spec for 2.6.18

* Nick Lewis (2):
     * Always read request body when using Rack
     * Fix order-dependent test failure in rest\_authconfig\_spec

* Patrick Carlisle (4):
     * (#19391) (CVE-2013-1652) Disallow use\_node compiler parameter for remote requests
     * (#19392) (CVE-2013-1653) Validate instances passed to indirector
     * (#19392) (CVE-2013-1653) Validate indirection model in save handler
     * (#19392) (CVE-2013-1653) Fix acceptance test to catch unvalidated model on 2.6

## 2.6.17

This is a **security** release in the 2.6.x branch.

### Security Fixes

 CVE-2012-3864 Arbitrary file read on the puppet master from authenticated clients (high)
    It is possible to construct an HTTP get request from an authenticated
    client with a valid certificate that will return the contents of an arbitrary
    file on the Puppet master that the master has read-access to.

 CVE-2012-3865 Arbitrary file delete/D.O.S on Puppet Master from authenticated clients (high)
    Given a Puppet master with the "Delete" directive allowed in auth.conf
    for an authenticated host, an attacker on that host can send a specially
    crafted Delete request that can cause an arbitrary file deletion on the
    Puppet master, potentially causing a denial of service attack. Note that
    this vulnerability does *not* exist in Puppet as configured by default.


 CVE-2012-3867 Insufficient input validation for agent hostnames (low)
    An attacker could trick the administrator into signing an attacker's
    certificate rather than the intended one by constructing specially
    crafted certificate requests containing specific ANSI control sequences.
    It is possible to use the sequences to rewrite the order of text displayed
    to an administrator such that display of an invalid certificate and valid
    certificate are transposed. If the administrator signs the attacker's
    certificate, the attacker can then man-in-the-middle the agent.


## 2.6.16
This release addresses and reverts a behavior change related to puppet's pidfile
that was introduced in Puppet 2.6.15.

65446c9 Revert "(#5246) Puppetd does not remove it's pidfile when it exits"

## 2.6.15

This is a **security** release in the 2.6.x branch.

### Security Fixes

#####  CVE-2012-1906 (High) - appdmg and pkgdmg providers write packages to insecure location

http://puppetlabs.com/security/cve/cve-2012-1906

(\#13260)

    If a remote source is given for a package, the package is downloaded
    to a predictable filename in /tmp. It is possible to create a symlink at this
    name and use it to clobber any file on the system, or by switching
    the symlink install arbitrary packages (and package installers can
    execute arbitrary code).

#####  CVE-2012-1986 (High) - Filebucket arbitrary file read

http://puppetlabs.com/security/cve/cve-2012-1986

(\#13511)
    It is possible to construct a REST request to fetch a file from a
    filebucket that overrides the puppet master’s defined location
    for the files to be stored. If a user has access to construct directories
    and symlinks on the machine they can read any file that the user the
    puppet master is running as has access to.

#####  CVE-2012-1987 (Moderate) - Filebucket denial of service

http://puppetlabs.com/security/cve/cve-2012-1987

(\#13552,\#13553)

    By constructing a marshaled form of a Puppet::FileBucket::File
    object a user can cause it it to be written to any place on the disk
    of the puppet master. This could be used for a denial of service attack
    against the puppet master if an attacker fills a filesystem that can cause
    systems to stop working. In order to do this the attacker needs no access
    to the puppet master system, but does need access to agent SSL keys.

    Using the symlink attack described in Bug #13511 the puppet master
    can be caused to read from a stream (e.g. /dev/random) when either
    trying to save a file or read a file. Because of the way in which the puppet
    master deals with sending files on the filesystem to a remote system via a
    REST request the thread handling the request will block forever reading from
    that stream and continually consuming more memory. This can lead to the
    puppet master system running out of memory and cause a denial of service.

#####  CVE-2012-1988 (High) - Filebucket arbitrary code execution

http://puppetlabs.com/security/cve/cve-2012-1988

(\#13518)
    Filebucket arbitrary code execution
    This requires access to the cert on the agent and an unprivileged
    account on the master.  By creating a path on the master in a
    world-writable location that matches a command string, one can
    then make a file bucket request to execute that command.


## 2.6.14

This is a **security** release in the 2.6.x branch.

### Security Fixes

#####  CVE-2012-1053 (Group Privilege Escalation)

http://puppetlabs.com/security/cve/cve-2012-1053/

(\#12457, \#12458, \#12459) 
A bug in Puppet gives unexpected and improper group privileges to execs and types/providers.
When executing commands as a different user, Puppet leaves the forked
process with Puppet’s own group permissions. Specifically:

* Puppet’s primary group (usually root) is always present in a process’s supplementary groups.
* When an exec resource is assigned a user to run as but not a group,
* Puppet will set its effective GID to Puppet’s own GID (usually root).
* Permanently changing a process’s UID and GID won’t clear the supplementary groups, leaving the process with Puppet’s own supplementary groups (usually including root).

This causes any untrusted code executed by a Puppet exec resource to
be given unexpectedly high permissions.

#####  CVE-2012-1054 (User Privilege Escalation)

http://puppetlabs.com/security/cve/cve-2012-1054/

(\#12460)

If a user’s `.k5login` file is a symlink, Puppet will overwrite the
link’s target when managing that user’s login file with the k5login
resource type. This allows local privilege escalation by linking a
user’s `.k5login` file to root’s `.k5login` file.

## 2.6.13

Fix #10739 Provide default subjectAltNames while bootstrapping master

    Prior to #2848 (CVE-2011-3872), if Puppet[:certdnsnames] was not set,
    puppet would add default subjectAltNames to any non-CA cert it signed,
    including agent certs. The subjectAltNames were of the form:

      DNS:puppet, DNS:<fqdn>, DNS:puppet.<domain>

    The fix for #2848, prevented subjectAltNames from ever being
    implicitly added at signing time. But during this change, the default
    subjectAltNames behavior was accidentally removed.

    This commit restores the 'defaulting' behavior that existed
    previously, but only when bootstrapping the initial master.
    Additionally, default subjectAltNames are only ever added when
    generating the master's certificate signing request, not at signing
    time. This is important, because it ensures all subjectAltNames
    originate from the CSR and are subject to our internal signing policy.

    The code now requires that all of the following be true in order to
    add default subjectAltNames to the CSR:

     1. We are a CA and master
     2. We're signing the master's cert, not self-signing the CA
     3. The CSR is for the current host
     4. No subjectAltNames have been specified, e.g. Puppet[:dns_alt_names]
     5. The master can resolve its fqdn

    These should only ever be true when bootstrapping the initial
    master. In particular, it should never be true for the CA's
    self-signed cert, for remote agents, or for servers that are either
    masters or CAs, but not both.

    The fqdn requirement existed previously, and so the same behavior has
    been restored.

    Note if Puppet[:dns_alt_names] are specified when bootstrapping the
    master, then we do not merge the default options -- it's either one of
    the other, but not both.

Fix #10289

  Add an ext script to upload facts to inventory server

    This script, ext/upload_facts, will read facts from the master's yaml
    dir and save them to the facts terminus. The intended use of this is
    when the facts terminus is set to inventory_service, to be run
    periodically via cron to ensure facts are uploaded even if the
    inventory_service becomes temporarily unavailable. It supports a
    --minutes option, which will limit the facts uploaded to only those
    added in the last n minutes.

  Add a safe alternative to REST for inventory service

    With the default implementation of the inventory service, with a
    terminus REST and cache YAML, a failed upload to the inventory service
    would cause compilation to fail. This means the inventory service was a
    single point of failure for the entire Puppet infrastructure. Now, we
    introduce an inventory_service terminus which can be used in place of
    the REST terminus, and will absorb failures, allowing compilation to
    continue.



### 2.6.13 Changelog

* e4ee794 (#10739) Provide default subjectAltNames while bootstrapping master
* 9dfd011 (#5617)  Puppet queue logging
* a91cfa1 maint: Fix failing spec on old version of rspec
* aa2a762 (#10289) Add an ext script to upload facts to inventory server
* 5129d38 (#10289) Add a safe alternative to REST for inventory service
* 7514d32 missing includes in network XML-RPC handlers
* 397a506 (#10244) Restore Mongrel XMLRPC functionality
* 8d86e5a (9547) Minor mods to acceptance tests
* 2bf6721 Reset indirector state after configurer tests.
* bb224dd (#8770) Don't fail to set supplementary groups when changing user to root
* 2a0de12 (#8770) Always fully drop privileges when changing user
* 00c4b25 (#8662) Migrate suidmanager test case to rspec
* d7c9c76 (#8740) Do not enumerate files in the root directory.
* 0e00473 (#3553) Explain that cron resources require time attributes
* 769d432 (#8302) Improve documentation of exec providers
* c209f62 Add document outlining preferred contribution methods
* fb2ffd6 (#8596) Detect resource alias conflicts when titles do not match
* 89c021c (#8418) Fix inspect app to have the correct run_mode
* 3165364 maint: Adding logging to include environment when source fails
* f484851 maint: Add debug logging when the master receives a report
* e639868 Confine password disclosure acceptance test to hosts with required libraries
* a109c90 (maint) Cleanup and strengthen acceptance tests
* b268fb3 (#7144) Update Settings#writesub to convert mode to Fixnum
* 4a2f22c (maint) Fix platform dection for RHEL
* 111a4b5 (#6857) Password disclosure when changing a user's password

## 2.6.12

This is a security release in the 2.6.x branch.

### Security Fixes

#####  CVE-2011-3872 (AltNames vulnerability)

[(Full vulnerability and mitigation details)][cve20113872]




**This is a major security vulnerability which must be manually remediated;**
upgrading Puppet will not fully protect a site from this vulnerability.

A bug in all previous versions causes Puppet to insert the puppet master’s DNS
alt names ("certdnsnames" in puppet.conf) into the X.509 Subject Alternative
Name field of all certificates, rather than just the puppet master’s
certificate.

Since the puppet agent daemon can use the Subject Alternative Name field to
identify its puppet master, your site may contain agent certificates that can
be used in a Man in the Middle (MITM) attack to impersonate the puppet master.

This release fixes the underlying bug that caused dangerous certificates to be
issued, but **any existing certificates with improper DNS alternate names will
remain dangerous until your agent nodes have been reconfigured.**

Any site where the puppet master's `certdnsnames` setting has been enabled is
vulnerable to attack. See the [CVE-2011-3872 details page][cve20113872] for
more information, including:

* How to determine whether you are affected
* How to fully remediate the vulnerability
* How to download and use the automated remediation toolkit released by Puppet Labs


## 2.6.11

This is a security release in the 2.6.x branch.

### Security Fixes

#####  Three security vulnerabilities

This release resolves the following security vulnerabilities:

* [CVE-2011-3869 -- k5login can overwrite arbitrary files as root][cve20113869]
* [CVE-2011-3870 -- SSH auth key local privilege escalation][cve20113870]
* [CVE-2011-3871 -- Predictable temporary filename in puppet resource/ralsh][cve20113871]

Follow the links above for details on each vulnerability.




## 2.6.10

2.6.10 is a security release in the 2.6.x branch.

### Security Fixes

#####  CVE-2011-3848 (directory traversal attacks through indirections)

[(Full vulnerability details)][cve20113848]

In various versions of Puppet it was possible to cause a directory traversal
attack through the SSLFile indirection base class.  This was variously
triggered through the user-supplied key, or the Subject of the certificate, in
the code.

Now, we detect bad patterns down in the base class for our indirections, and
fail hard on them.  This reduces the attack surface with as little disruption
to the overall codebase as possible, making it suitable to deploy as part of
older, stable versions of Puppet.

In the long term we will also address this higher up the stack, to prevent
these problems from reoccurring, but for now this will suffice.

Huge thanks to Kristian Erik Hermansen <kristian.hermansen@gmail.com> for the
responsible disclosure, and useful analysis, around this defect.


### Commits

ec5a32a Update spec and lib/puppet.rb for 2.6.10 release
fe2de81 Resist directory traversal attacks through indirections. (CVE-2011-3484)


## 2.6.9

2.6.9 is a maintenance release in the 2.6.x branch.

### Notable Fixes and Features

Bug #5318

  Puppet master behind Passenger no longer requires two runs to detect changes to manifests.

Bug #7127:

  A puppet run will now stop if a prerun command fails.

Bug #650

  Puppet will now honor symlinks for configuration directories

Feature #2128

  Added support for hostname setting based on facts, also get facts before retrieving the catalog.

Bug #7139

  Accept '/' as a valid path in filesets


## 2.6.8

2.6.8 is a maintenance release in the 2.6.x branch.

### Notable Features and Bug Fixes

Bug #4884:

 Added a new `shell` exec provider that executes code as a raw shell script. Although the `posix` provider remains the default, the new provider allows the use of shell globbing and built-ins, and does not require that the path to a command be fully-qualified. The `shell` provider closely resembles the behavior of the `exec` type in Puppet 0.25.x.

Bug #5670:

 Failed resources don't improperly trigger a refresh

Feature #2331:

 New macports provider

## 2.6.7

2.6.7 is a maintenance release in the 2.6.x branch.

### Notable Features and Bug Fixes

#####  Inventory Service Available

The inventory service is a way to track facts for all nodes.  Preliminary documentation can be found [here](https://github.com/puppetlabs/puppet-docs/blob/master/source/guides/inventory_service.markdown), which will be finalized by the time 2.6.7 is released.

#####  Plugin sync works when using tags

Bug #5073 This fixes a regression from 0.25.x

#####   Don't truncate remotely-sourced files on 404

Bug #4922 Now 404s just cause a normal failure without affecting the file

#####  Storeconfigs compatibility with older version of Puppet

Bug #5428 Upgrading from 0.25.x caused problems with the data format that storeconfigs used, and previously you had to delete your old storeconfigs data to work with 2.6.x.  2.6.7 can now work with the old storeconfigs data.

#####  Selectors now can use hashes

Ticket #5516  Example:

    $int = { 'eth0' => 'bla' }
    $foo = $int['eth0'] ? {
      'bla' => 'foo',
       default => 'bleh'
    }

#####  Hashes can now be multiple levels deep

Bug #6269  The following now works:

    $hash = { 'a' => { 'b' => { 'c' => 'it works' } } }
    $out = $hash['a']['b']['c']

#####   Documented autorequire relationships

Ticket #6606

#####  Better support for multiple key attributes

Bugs #5661 #5662 #5605

#####  Better error message when realizing a non-existent virtual resource

Bug #5392 The error message you used to get when realizing a bogus virtual resource didn't give you any indication of what was happening to cause the error.  Now it should be much faster to figure out that the virtual resource was bad.

#####  Noop no longer suppresses error codes

Bug #6322  Running in noop mode used to always return 0.  It will now return the same exit code that a regular run would if possible

#####   Settings Propagate Environment

Bug #6513  The code in settings did not always propagate the environment, creating situations in which inconsistent results were produced

#####  Able to create system users

Ticket #2645 You can now create users like when running `useradd -r` if you specify `system => true` on a user resource.

#####  The reports directory is now automatically created

Bug #5794 If the reports directory didn't exist the report creation used to fail until it was manually added

#####   DESTDIR in install.rb now warns that it's deprecated in favor of `--destdir`

Ticket #5724

#####  Allow disabling of default SELinux context detection for files

Ticket #3999

#####  Add `_search` REST API aliases for plural GET requests

Ticket #6376 The plural form creates problems when the name of the indirection is already plural, e.g. “facts” pluralizes to “factss”

## 2.6.6

2.6.6 is a maintenance release in the 2.6.x branch.

### Notable Features and Bug Fixes

#####  No longer audit recursive files

Bug #6418: Files with the "source" parameter set are automatically set to audit

The audit functionality was activated unexpectedly on file resources that use the "source" parameter. This could cause spurrious notify events.  These notifications could trigger unintended refreshes of subscribed resources.

#####  No longer truncate files when given an invalid checksum

Bug #6541: File type truncates target when filebucket can not retrieve hash

In the case where a file resource had content specified using an invalid checksum (Eg: "{md5}not-a-checksum") or the valid checksum of a file not contained in the filebucket, the file would end up being truncated.  This is now properly reported as an error, instead of zeroing out the file.

## 2.6.5

2.6.5 is a maintenance release in the 2.6.x branch.

### Notable Features and Bug Fixes

#####  Faster Passenger support

Bug #6257: Rack POST and PUT request handling is very slow.

The speed of the Rack HTTP handler has been dramatically improved. This should prevent timeouts that some users were experiencing when running under Passenger.

#####  Parameterised class support in external node classifiers

Bug #5045: External node classifiers should be able to specify parameters for parameterized classes

External node classifiers can now declare parameterized classes (with parameters). To declare the following parameterized class:

    class foo($foobar='default', $foobaz, $fooblah) {
      notify { 'foobar': message => $foobar }
      notify { 'foobaz': message => $foobaz }
      notify { 'fooblahfirst': message => $fooblah[0] }
      notify { 'fooblahsecond': message => $fooblah[1] }
    }

...your external node classifier should return the following YAML:

    classes:
        foo:
          foobar: onesie
          foobaz: twosie
          fooblah:
              - one
              - two

#####  New puppet inspect application

Puppet now includes puppet inspect, an application which sends inspection reports to the puppet master. Inspection reports document the current state of resource attributes which marked for auditing in the most recently applied catalog, and are useful in certain pre-existing workflows.

#####  `$name` can now be used to set default values in defined resource types

Feature #5061: should be able to access ($name, $module_name, $title) from within defined resources type parameter list

The `$name` variable is now resolved within the scope of the resource being declared, rather than the enclosing scope. This enables usages like:

    define audited_file($filename = $name) {
        file { $filename:
            audit => all,
        }
    }

    audited_file { "/etc/hosts": }

#####  Managed resource attributes can now be audited

Bug #5408: Puppet should allow audited attributes to also be managed

The audit metaparameter can now be used on attributes which are managed by Puppet.

#####  Manifests can now specify arbitrary data for file contents

Bug #5261: Need a way to transmit binary data for file contents in manifests

Previous versions of Puppet would experience errors when file contents contained invalid UTF8.

#####  Puppet agent reliably writes valid cache YAML for very large catalogs

Bug #5755: Unable to load puppet generated catalog via YAML.load_file

In Puppet 2.6.3 and 2.6.4, puppet agent would sometimes write invalid YAML to its cache when serializing extremely large catalogs, and subsequent tasks attempting to consume this YAML would fail. This has been fixed.

#####  The environment column in storeconfigs is no longer corrupted

Bug #4487: Environment column in hosts table updating incorrectly

A bug which corrupted the environment column in storeconfigs databases has been fixed.

#####  Mount resource on AIX has been improved

Bug #5681: Puppet mount module Puppet::Provider::Mount does not properly parse AIX mount command output

#####  Puppet resource can now manage files

Bug #3165: Ralsh can't manage files

The puppet resource shell can now manage file resources.

#####  Generating puppet.conf with `--genconfig` no longer sets genconfig = true

Bug #5914: Genconfig returns genconfig=true

Using the `--genconfig` command line option now generates fully usable puppet.conf content.

Bug #5977: Puppet applications in multiple directories.

Setting RUBYLIB should no longer have the potential to break finding puppet sub-commands.

#####  License is now GPLv2

Previous versions of Puppet were licensed as GPL version 2 or greater; the license is now specified as GPL version 2.

#####  Filebucket API can now provide diffs of file contents

The filebucket service can now diff file contents specified by MD5 checksum. From [the REST API documentation](/guides/rest_api.html):

    GET /{environment}/file_bucket_file/md5/{checksum}?diff_with={checksum}

No tools using this feature are currently shipping; however, a future version of Puppet Dashboard will support viewing diffs of arbitrary file content revisions.

#####  Report format has changed; report formats are now versioned

The report format has been made more consistent, more documentatable, and less redundant. Report formats are now versioned, and inspection reports are now supported with the `kind` attribute.

See the wiki for details:

* [[Report Format 0]]
* [[Report Format 1]]
* [[Report Format 2]]

#####  "user" type now takes -1 to disable password aging

Bug #6061: password_max_age can not be set to null or -1

#####  Time and timestamp checksum options have been removed from the "file" type

These attributes, deprecated in 0.25.0, have been removed.

#####  "file" type now accepts POSIX files with multiple slashes

Bug #6091: Fix Posix file paths with multiple slashes

Valid POSIX file paths with multiple slashes are now usable.

#####  Document the `--apply` and `--compile` options to `puppet apply` and `puppet master`

Feature #3646: Updated documentation for `puppet apply`, and `puppet master`.

## 2.6.4

2.6.4 is a security release in the 2.6.x branch and contains only
security related bug fixes and one update to copyright information.

## 2.6.3

2.6.3 is a maintenance release in the 2.6.x branch and contains only
bug fixes and no new features.

## 2.6.2

This release is largely a maintenance release for the 2.6.x cycle

### Types and Providers

#####  User type now manages password age

We've add a new feature to user providers <code>manages_password_age</code>, along with the new properties <code>password_min_age</code> and <code>password_max_age</code> to the user type. These represent password minimum and maximum age in days. The useradd and user_role_add providers now support these new properties.

#####  User type now manages user expiry

We've add a new feature to user providers, <code>manages_expiry</code>, along with a new property, <code>expiry</code>.  The <code>expiry</code> property is specified in the form of YYYY-MM-DD and sets an expiration date for an account.

An example of these new features:

    user { "james":
      password_min_age => '10',
      password_max_age => '30',
      expiry => '2010-09-30',
      ...
      ensure => present,
    }

## 2.6.1

This release is largely a maintenance release for 2.6.0 but also includes basic support for running Puppet under JRuby.

### Functions

#####  Extlookup

R.I. Pienaar's extlookup function has been added to core.  This is an initial import of this function.  Additional functionality, including YAML and JSON backends, will be added in future releases.

This is a parser function to read data from external files, this version
uses CSV files but the concept can easily be adjust for databases, yaml
or any other queryable data source.

The object of this is to make it obvious when it's being used, rather than
magically loading data in when an module is loaded I prefer to look at the code
and see statements like:

    $snmp_contact = extlookup("snmp_contact")

The above snippet will load the snmp_contact value from CSV files, this in its
own is useful but a common construct in puppet manifests is something like this:

    case $domain {
       "myclient.com": { $snmp_contact = "John Doe <john@myclient.com>" }
       default:        { $snmp_contact = "My Support <support@my.com>" }
    }

Over time there will be a lot of this kind of thing spread all over your manifests
and adding an additional client involves grepping through manifests to find all the
places where you have constructs like this.

This is a data problem and shouldn't be handled in code, a using this function you
can do just that.

First you configure it in site.pp:

    $extlookup_datadir = "/etc/puppet/manifests/extdata"
    $extlookup_precedence = ["%{fqdn}", "domain_%{domain}", "common"]

The array tells the code how to resolve values, first it will try to find it in
web1.myclient.com.csv then in domain_myclient.com.csv and finally in common.csv

Now create the following data files in /etc/puppet/manifests/extdata like this:

   domain_myclient.com.csv:
     snmp_contact,John Doe <john@myclient.com>
     root_contact,support@%{domain}
     client_trusted_ips,192.168.1.130,192.168.10.0/24

   common.csv:
     snmp_contact,My Support <support@my.com>
     root_contact,support@my.com

Now you can replace the case statement with the simple single line to achieve
the exact same outcome:

    $snmp_contact = extlookup("snmp_contact")

The obove code shows some other features, you can use any fact or variable that
is in scope by simply using %{varname} in your data files, you can return arrays
by just having multiple values in the csv after the initial variable name.

In the event that a variable is nowhere to be found a critical error will be raised
that will prevent your manifest from compiling, this is to avoid accidentally putting
in empty values etc.  You can however specify a default value:

    $ntp_servers = extlookup("ntp_servers", "1.${country}.pool.ntp.org")

In this case it will default to "1.${country}.pool.ntp.org" if nothing is defined in
any data file.

You can also specify an additional data file to search first before any others at use
time, for example:

    $version = extlookup("rsyslog_version", "present", "packages")
    package{"rsyslog": ensure => $version }

This will look for a version configured in packages.csv and then in the rest as configured
by $extlookup_precedence if it's not found anywhere it will default to "present", this kind
of use case makes puppet a lot nicer for managing large amounts of packages since you do not
need to edit a load of manifests to do simple things like adjust a desired version number.

#####  md5

An md5 hashing function

### Documentation

Migration of internal Restructured Text Documentation to Markdown

### Types and Providers

Added http_refresh and cost parameters to the yumrepo type

## 2.6.0

### Language

#####  Support for parameterised classes

The Rowlf release provides an extension to the existing class
syntax to allow parameters to be passed to classes. This brings
classes more in line with definitions, with the significant
difference that definitions have multiple instances whilst classes
remain singletons.

To create a class with parameters you can now specify:

    class apache($version) {

    ... class contents ...

    }

Classes with parameters are NOT added using the include function
but rather the resulting class can then be included more like a
definition:

    node webserver {
        class { apache: version => "1.3.13" }
    }

Like definitions, you can also specify default parameter values in
your class like so:

    class apache($version="1.3.13",$home="/var/www") {

    ... class contents ...

    }

#####  New relationship syntax

You can now specify relationships directly in the language:


    File[/foo] -> Service[bar]


Specifies a normal dependency while:


    File[/foo] ~> Service[bar]


Specifies a subscription.

You can also do relationship chaining, specifying multiple
relationships on a single line:


    File[/foo] -> Package[baz] -> Service[bar]


Note that while it's confusing, you don't have to have all of the arrows be the same direction:


    File[/foo] -> Service[bar] <~ Package[baz]


This can provide some succinctness at the cost of readability.

You can also specify full resources, rather than just resource references:


    file { "/foo": ensure => present } -> package { bar: ensure => installed }


But wait! There's more!  You can also specify a subscription on either side of the relationship marker:


    yumrepo { foo: .... }
    package { bar: provider => yum, ... }
    Yumrepo <| |> -> Package <| provider == yum |>


This, finally, provides easy many to many relationships in Puppet, but it also opens the door to massive dependency cycles.  This last feature is a very powerful stick, and you can considerably hurt yourself with it.

#####  Run Stages

Run Stages are a way for you to provide coarse-grained ordering in your manifests without having to specify relationships to every resource you want in a given order.  It's most useful for setup work that needs to be done before the vast majority of your catalog even works - things like configuring yum repositories so your package installs work.

Run Stages are currently (intentionally) a bit limited - you can only put entire classes into a run stage, you can't put individual resources there.

There's a <code>main</code> stage that resources all exist in by default; if you don't use run stages, everything's in this, but it doesn't matter to you.  You can define new stages via the new <code>stage</code> resource type:


    stage { pre: before => Stage[main] }


Here we've used the <code>before</code> metaparameter but you could also use <code>after</code>, <code>require</code>, etc to establish the necessary relationships between stages.

Now you just specify that your class belongs in your new run stage:


    class yum { ... }
    class redhat {
      ...
      class { yum: stage => pre }
    }


This will make sure that all of the resources in the <code>yum</code> are applied before the main stage is applied.

Note that we're using the new parameterized classes here - this is necessary because of the class-level limitations of Run Stages.  These limitations are present because of the complication of trying to untangle resource dependencies across stage boundaries if we allowed arbitrary resources to specify stages.

On a related note, if you specify a stage for a given class, you should specify as few as possible explicit relationships to or from that class.  Otherwise you risk a greater chance of dependency cycles.

This can all be visualized relatively easily using the <code>\-\-graph</code> option to <code>puppetd</code> and opening the graphs in OmniGraffle or GraphViz.

Specifying the ordering of Run Stages also works much better when specified using the new relationship syntax, too:


    stage { [pre, post]: }
    Stage[pre] -> Stage[main] -> Stage[post]


This way it's very easy to see at a glance exactly how the stages are ordered.

#####  Support for hashes in the DSL

This brings a new container syntax to the Puppet DSL: hashes.

Hashes are defined like Ruby Hashes:


    { key1 => val1, ... }


The Hash keys are strings but hash values can be any possible right values admitted in Puppet DSL (i.e. a function call or a variable)

Currently it is possible:

* to assign hashes to a variable: <pre>
$myhash = { key1 => "myval", key2 => $b }</pre>
* to access hash members (recursively) from a variable containing a hash (works for array too): <pre>
$myhash = { key => { subkey => "b" }}
notice($myhash[key][subkey]]</pre>
* to use hash member access as resource title
* to use hash in default definition parameter or resource parameter if the type supports it (none for the moment).

It is not possible to use an hash as a resource title. This might be possible once we support compound resource title.

#####  The "in" syntax

From Puppet 2.6.0 you can also use the "in" syntax.  This operator allows
you to find if the left operand is in the right one. The left operand must
be a string, but the right operand can be:

* a string
* an array
* a hash (the search is done on the keys)

This syntax can be used in any place where an expression is supported:

    $eatme = 'eat'
    if $eatme in ['ate', 'eat'] {
    ...
    }

    $value = 'beat generation'
    if 'eat' in $value {
      notice("on the road")
    }

#####  Pure Ruby Manifests

Puppet now supports pure Ruby manifests as equivalent to Puppet's custom language.  That is, you can now have Ruby programs along side your Puppet manifests.  As is our custom, it's a limited first version, but it covers most of the specification functionality of the current language.  For instance, here's a simple ssh class:


    hostclass :ssh do
      package "ssh", :ensure => :present
      file "/etc/ssh/sshd_config", :source => "puppet:///ssh/sshd_config", :require => "Package[ssh]"
      service :sshd, :ensure => :running, :require => "File[/etc/ssh/sshd_config]"
    end


Similar to the 'hostclass' construct here, you can specify defined resource types:

    define "apache::vhost", :ip, :docroot, :modperl => false do
      file "/etc/apache2/sites-enabled/#{@name}.conf", :content => template("apache/vhost.erb")
    end


As you can see from this code, the parameters for the resources become instance variables inside of the defined resource types (and classes, now that we support parameterized classes).

We can do nodes, too:


    node "mynode" do
      include "apache"
    end


Ruby has become a first-class citizen alongside the existing external DSL.  That means anywhere you can put a manifest, you should be able to put ruby code and have it behave equivalently.  So, the 'ssh' class above could be put into '$modules/ssh/manifests/init.rb', the apache vhost type should be placed in '$modules/apache/manifests/vhost.rb', and the node should probably be in your 'site.pp' file.  You can also apply ruby manifests directly with puppet:


    puppet -e mystuff.rb


Note that the Ruby support does not yet cover all of the functionality in Puppet's language.  For instance, there is not yet support for overrides or defaults, nor for resource collections.  Virtual and exported resources are done using a separate method:

    virtual file("/my/file", :content => "something")


All of the standard functions are also pulled into Ruby and should work fine -- e.g., 'include', 'template', and 'require'.

#####  Support for an elsif syntax

Allows use of an elsif construct:

      if $server == 'mongrel' {
          include mongrel
      } elsif $server == 'nginx' {
          include nginx
      } else {
          include thin
      }


#####  Audit Metaparameter

Puppet now supports an audit metaparameter in the style of Tripwire.

Using this new metaparameter we can specify our resource like:

    file { '/etc/hosts':
       audit => [ owner, group, mode ],
    }

Now instead of changing each value (though you can change it too if you wish) Puppet will instead generate auditing log messages, which are available in your standard Puppet reports:

    audit change: previously recorded value owner root has been changed to owner james

This allows you to track any changes that occur on resources under management on your hosts. You can specify this audit metaparameter for any resource and all their attributes and track users, groups, files, services and the myriad of other resources Puppet can manage.

You can also specify the special value of all to have Puppet audit every attribute of a resource rather than needing to list all possible attributes, like so:

    file { '/etc/hosts':
       audit => all,
    }

You can also combine the audited resources with managed resources allowing you to manage some configuration items and simply track others. It is important to remember though, unlike many file integrity systems, that your audit state is not protected by a checksum or the like and is stored on the client in the state.yaml file. In future releases we will look at protecting and centralising this state data.

#####  Case and Selectors now support undef

The case and selector statements now support the undef syntax (see \#2818).

### Stored Configuration

Support is now added for using Oracle databases as a back-end for
your stored configuration.

### Facts

There are three new facts available in manifests:

* `$clientcert` - the name of the client certificate
* `$module_name` - the name of the current module (see #1545)
* `$caller_module_name` - the name of the calling module (see #1545)

In addition all `puppet.conf` configuration items are now available as facts in your manifests.  These can be accessed using the structure:

    $settings::setting_name

Where setting_name is the name of the configuration option you'd like to retrieve.

### Types and Providers

Basic Windows support has been introduced...

A new provider for pkg has been added to support Solaris and
OpenSolaris (pkgadd).

A new package provider has been added to support AIX package management.

The augeas type has added the 'incl' and 'lens' parameters. These parameters allow loading a file anywhere on the filesystem; using them also greatly speeds up processing the resource.

### Binaries and Configuration

#####  Single Binary

Puppet is now available as a single binary with sub-arguments for the functions previously provided by the separate binaries (the existing binaries remain for backwards compatibility).  This includes renaming several Puppet functions to better fit an overall model.

List of binary changes

* puppetmasterd     ->   puppet master
* puppetd           ->   puppet agent
* puppet            ->   puppet apply
* puppetca          ->   puppet cert
* ralsh             ->   puppet resource
* puppetrun         ->   puppet kick
* puppetqd          ->   puppet queue
* filebucket        ->   puppet filebucket
* puppetdoc         ->   puppet doc
* pi                ->   puppet describe

This also results in a change in the puppet.conf configuration file.  The sections, previously things like [puppetd], now should be renamed to match the new binary names.  So [puppetd] becomes [agent].  You will be prompted to do this when you start Puppet. You will be prompted to do this when you start Puppet with a log message for each section that needs to be renamed.  This is merely a warning - existing configuration file will work unchanged.

#####  New options

A new option is available, ca\_name, to specify the name to use for
the Certificate Authority certificate. It defaults to the value of
the certname option (see
[http://projects.puppetlabs.com/issues/1507](http://projects.puppetlabs.com/issues/1507)).

A new option, dbconnections, is now available that specifies a
limit for the number of database connections made to remote
databases (postgreSQL, MySQL).

A new option, dbport, is now available that specifies the database port for remote database connections.

There's also a new option/feature that lets the puppet client use HTTP
compression (\-\-http_compression):

Allow http compression in REST communication with the master. This setting might improve performance for agent -> master
communications over slow WANs. Your puppetmaster needs to support compression (usually by activating some settings in a reverse-proxy in front of the puppetmaster, which
rules out webrick).

It is harmless to activate this settings if your master doesn't support compression, but if it supports it, this setting might reduce  on high-speed LANs.

#####  Binary changes

The puppetd (or puppet agent) binary now supports the \-\-detailed-exitcodes option
available in the puppet binary.

The puppet agent will now create the ssl when passed the \-\-noop option.

Certificates cleaned with puppetca (or puppet cert) are now also revoked.

The puppetca (puppet cert) and puppetd (puppet agent) binaries now have support for certificate
fingerprinting and support for specifying digest algorithms. To
display the fingerprint of a client certificate use:

    $ puppetd --fingerprint

or

    $ puppet agent --fingerprint

To specify a particular digest algorithm use \-\-digest DIGESTNAME.

To fingerprint a certificate with puppetca use:

    $ puppetca --fingerprint host.example.com

or

    $ puppet cert --fingerprint host.example.com

Also supported is the \-\-digest option.

The puppetdoc binary now documents inheritance between nodes, shows classes added via the require function and resources added via the realize function.

### Functions

The regsubst function now takes arrays as input (see \#2491).

### Reports

There is a new report type called `http`.  If you specify:

    reports = http

Then the new report processor will make a HTTP POST of the report in YAML format to a specified URL.  By default this URL is the report import URL for a local Puppet Dashboard installation.  You can override this with the new `reporturl` setting.

    reports = http
    reporturl = http://yoururl/post/

### Puppet Runner

In order for this to run at all:

    puppetrun --foreground --host XXX

you must alter auth.conf to include:

    path /run
    method save
    allow *

otherwise you will receive:

    Host $PUPPET failed: Error 403 on SERVER: Forbidden request: $MASTER(X.X.X.X) access to /run/$PUPPET [save] authenticated  at line 101


### Incompatibilities

PID files for puppet and master used to be named:

    puppetd.pid
    puppetmasterd.pid

new names are:

    agent.pid
    master.pid

[CVE-2013-2274]: http://puppetlabs.com/security/cve/cve-2013-2274
[CVE-2013-2275]: http://puppetlabs.com/security/cve/cve-2013-2275
[CVE-2013-1655]: http://puppetlabs.com/security/cve/cve-2013-1655
[CVE-2013-1654]: http://puppetlabs.com/security/cve/cve-2013-1654
[CVE-2013-1652]: http://puppetlabs.com/security/cve/cve-2013-1652
[CVE-2013-1640]: http://puppetlabs.com/security/cve/cve-2013-1640
