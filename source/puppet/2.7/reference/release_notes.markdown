---
layout: default
title: Puppet 2.7 Release Notes
description: Puppet release notes for version 2.7.x.
canonical: "/puppet/latest/reference/release_notes.html"
---

Puppet 2.7 Release Notes
------------------------

[CVE-2014-3248]: http://puppetlabs.com/security/cve/cve-2014-3248

## Puppet 2.7.26

Released June 10, 2014.

2.7.26 is a security fix release in the Puppet 2.7 series. It has no other bug fixes or new features.

### Security Fix

#### [CVE-2014-3248 (An attacker could convince an administrator to unknowingly execute malicious code on platforms with Ruby 1.9.1 and earlier)][CVE-2014-3248]

On platforms running Ruby 1.9.1 or earlier, previous code would load Ruby source files from the current working directory. This could lead to the execution of arbitrary code during a puppet run.

## Puppet 2.7.25

2.7.25 is a bug fix release of the Puppet 2.7 series. It contains an important
fix for a regression from the fix for CVE-2013-4969, which caused the default
file mode to be 0600 instead of 0644.

* Andrew Parker (1):
     * 233e80 (Maint) Add rake task for running specs on win

* Dominic Cleal (1):
     * 3ea78c (PUP-1255) Fix assumed default file mode to 0644

* Kylo Ginsberg (1):
     * 4e10a0 (PUP-1255) Don't use POSIX defaults on Windows

* Sam Kottler (2):
     * c2acac (PUP-1351) Load ext/packaging/packaging.rake instead of ext/packaging/tasks/**
     * b1b29a Bump the version to 2.7.25


## Puppet 2.7.24

2.7.24 is a security fix release of the Puppet 2.7 series. It has no other bug
fixes or new features.

### Security fixes

#### [CVE-2013-4969 (Unsafe use of temp files in File type)](http://puppetlabs.com/security/cve/cve-2013-4969)

Previous code used temp files unsafely by looking for a name it could use in a directory, and then later writing to that file, creating a vulnerability in which an attacker could make the name a symlink to another file and thereby cause puppet agent to overwrite something that it did not intend to.

Puppet 2.7.23
-----

Released August 15, 2013.

2.7.23 is a security fix release of the Puppet 2.7 series. It has no other bug fixes or new features.

### Security Fixes

#### [CVE-2013-4761 (`resource_type` Remote Code Execution Vulnerability)](http://puppetlabs.com/security/cve/cve-2013-4761/)

By using the `resource_type` service, an attacker could cause Puppet to load
arbitrary Ruby files from the puppet master server's file system. While this behavior is not
enabled by default, `auth.conf` settings could be modified to allow it. The exploit requires
local file system access to the Puppet Master.


#### [CVE-2013-4956 (Puppet Module Permissions Vulnerability)](http://puppetlabs.com/security/cve/cve-2013-4956/)

The puppet module subcommand did not correctly control permissions of modules it installed, instead transferring permissions that existed when the module was built.


## Puppet 2.7.22

2.7.22 is a security fix release of the Puppet 2.7 series. It has no other bug fixes or new features.

### Security Fix

*[CVE-2013-3567 Unauthenticated Remote Code Execution Vulnerability](http://puppetlabs.com/security/cve/cve-2013-3567/).*

A critical vulnerability was found in puppet wherein it was possible for the puppet master to take YAML from an untrusted client via the REST API. This YAML could be deserialized to construct an object containing arbitrary code.

## Puppet 2.7.21

Puppet 2.7.21 is a **security release** addressing several security vulnerabilities discovered in
the 2.7.x line of Puppet. These vulnerabilities have been assigned Mitre CVE numbers [CVE-2013-1640][], [CVE-2013-1652][], [CVE-2013-1653][], [CVE-2013-1654][], [CVE-2013-1655][] and [CVE-2013-2275][].

All users of Puppet 2.7.20 and earlier who cannot upgrade to the current version of Puppet, 3.1.1, are strongly encouraged to upgrade
to 2.7.21.

### 2.7.21 Downloads

* Source: <https://downloads.puppetlabs.com/puppet/puppet-2.7.21.tar.gz>
* Windows package: <https://downloads.puppetlabs.com/windows/puppet-2.7.21.msi>
* RPMs: <https://yum.puppetlabs.com/el> or `/fedora`
* Debs: <https://apt.puppetlabs.com>
* Mac package: <http://downloads.puppetlabs.com/mac/puppet-2.7.21.dmg>
* Gems are available via rubygems: <https://rubygems.org/downloads/puppet-2.7.21.gem> or by using `gem
install puppet --version=2.7.21`

See the Verifying Puppet Download section at:
<http://puppetlabs.com/misc/download-options>

Please report feedback via the Puppet Labs JIRA site, using an affected puppet version of 2.7.21:
<https://tickets.puppetlabs.com/browse/PUP>



### 2.7.21 Changelog

* Andrew Parker (2):
     * (#14093) Remove unsafe attributes from TemplateWrapper
     * (#14093) Restore access to the filename in the template

* Jeff McCune (2):
     * (#19151) Reject SSLv2 SSL handshakes and ciphers
     * (#19531) (CVE-2013-2275) Only allow report save from the node matching the certname

* Josh Cooper (8):
     * Fix module tool acceptance test
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

* Moses Mendoza (2):
     * Add missing 2.7.20 CHANGELOG entries
     * Update CHANGELOG, PUPPETVERSION for 2.7.21

* Nick Lewis (3):
     * (#19393) Safely load YAML from the network
     * Always read request body when using Rack
     * Fix order-dependent test failure in rest\_authconfig\_spec

* Patrick Carlisle (3):
     * (#19391) (CVE-2013-1652) Disallow use\_node compiler parameter for remote requests
     * (#19392) (CVE-2013-1653) Validate instances passed to indirector
     * (#19392) Don't validate key for certificate_status

* Pieter van de Bruggen (1):
     * Updating module tool acceptance tests with new expectations.

## Puppet 2.7.20

2.7.20 is a bug fix release with some performance improvements ported back from 3.0.x line.
For a list of bug fixes targeted for this release, see the [bug tracker](http://projects.puppetlabs.com/versions/307)

### Important notes about 2.7.20

Regarding (\#15560):
If you had specifically enabled

    `managehome => true`

for user resources expecting it not to work on Windows, be aware that (\#15560) has been resolved,
and this works now for both creation with `ensure => present` **AND deletion** with `ensure => absent`.
Previously deleted users (deleted with Puppet < 2.7.20-rc1) will not have their orphaned home directories
removed, however.


Puppet 2.7.20 also addresses concerns regarding a change introduced in Puppet 2.7.16,
"[b26699a](https://github.com/puppetlabs/puppet/commit/b26699a2b89f3724b4322a3723d2c700fb7e4dd3)
(#10146) `-` is not legal in variable names.", which disallowed the use of dashes in variable names.
Puppet 2.7.20 introduces a new configuration option, `allow_variables_with_dashes`, which can be set to
`true` to allow variables with dashes. The option is set to false by default to maintain existing behavior. The
following commit message includes additional information:

> Commit 5ee2558
>
> (#10146) `-` in variable names should be deprecated!
>
> In commit b26699a2 I fixed an accidentally introduced change to the lexer,
> allowing `-` to be part of a variable name.  That had lasted for a while and
> was surprisingly popular.  It was also hugely ambiguous around `-` as minus,
> and led to all sorts of failures - unexpected interpolations to nothing -
> because of that.
>
> A much better strategy would have been to deprecate the feature, issue proper
> warnings, and include an option to allow users to toggle the behaviour.
>
> Initially defaulting that to "permit", and eventually toggling over to "deny",
> would have made the whole experience much smoother - even if this was totally
> documented as not working, and was a clear bug that it changed.
>
> So, thanks to prompting from Benjamin Irizarry, we do just that: introduce the
> configuration option, default it to "deny" to match current behaviour, but
> allow users the choice to change this back.
>
> Please be aware that allowing variables with `-` might break all sorts of
> things around, for example, Forge modules though.  Most people write code to
> the documented standard, and their code might well totally fail to work with
> this changed away from the default!


### Contributors
Adrien Thebo, Andrew Parker, Ashley Penney, Branan Purvine-Riley, Dan Bode, Daniel Pittman, Dominic Cleal, Dustin J. Mitchell, Eric Sorenson, Eric Stonfer, Gleb Arshinov, James Turnbull, Jeff McCune, Jeff Weiss, Josh Cooper, Ken Barber, Ken Dreyer, Lee Lowder, Markus Roberts, Matthaus Owens, Michael Stahnke, Moses Mendoza, Neil Hemingway, Nick Fagerlund, Patrick Carlisle, Roman Barczyński, S. Zachariah Sprackett, Sean E. Millichamp, Stefan Schulte, Todd Zullinger


## Puppet 2.7.19

Ruby 1.9.3 has a different error when `require` fails.

    The text of the error message when load fails has changed, resulting in the
    test failing.  This adapts that to catch the different versions, allowing this
    to pass in all cases.

(\#15291) Add Vendor tag to Puppet spec file

    Previously the spec file had no Vendor tag, which left it undefined. This
    commit adds a Vendor tag that references the _host_vendor macro, so that it can
    be easily set to 'Puppet Labs' internally and customized by users easily. The
    Vendor tag makes it easier for users to tell where the package came from.

Add packaging support for fedora 17

    This commit modifies the puppet.spec file to use
    the ruby vendorlib instead of sitelib if building
    for fedora 17, which ships with ruby 1.9. Mostly
    borrowed from the official Fedora 17 package.

(\#15471) Fix setting mode of last_run_summary

    The writlock function didn't work with setting the mode on the
    last_run_summary file. This backports some of the work in commit
    7d8fd144949f21eff924602c2a6b7f130f1c0b69. Specifically, the changes
    from using writelock to replace_file for saving the summary file. This
    builds on top of the backport of getting replace_file to work on
    windows.

(\#15471) Ensure non-root can read report summary

    The security fix for locking down the last_run_report, which contains
    sensitive information, also locked down the last_run_summary, which does
    not contain sensitive information. Unfortunately this file is often used
    by monitoring systems so that they can track puppet runs. Since the
    agent runs as root and the monitoring systems do not, this caused the
    summary to become unreadable by the monitoring systems.

    This commit returns the summary to being world readable which undoes
    part of the change done in fd44bf5e6d0d360f6a493d663b653c121fa83c3f

Use Win32 API atomic replace in `replace_file`

    The changes to enable Windows support in `replace_file` were not actually
    complete, and it didn't work when the file didn't exist - because of
    limitations of the emulation done on our side, rather than anything else.

    Windows has a bunch of quirks, and Ruby doesn't actually abstract over the
    underlying platform a great deal.  We can use the Windows API ReplaceFile, and
    MoveFileEx, to achieve the desired behaviour though.

    This adds even more conditional code inside the `replace_file` method to
    handle multiple platforms - but it really isn't very clean.  Better to get
    this working now, then refactor, though.

(\#11868) Use `Installer` automation interface to query package state

    Previously, Puppet recorded MSI packages it had installed in a YAML
    file. However, if the file was deleted or the system modified, e.g.
    Add/Remove Programs, then Puppet did not know the package state had
    changed.

    Also, if the name of the package did not change across versions, e.g.
    VMware Tools, then puppet would report the package as insync even though
    the installed version could be different than the one pointed to by the
    source parameter.

    Also, `msiexec.exe` returns non-zero exit codes when either the package
    requests a reboot (194), the system requires a reboot (3010), e.g. due
    to a locked file, or the system initiates a reboot (1641). This would
    cause puppet to think the install failed, and it would try to reinstall
    the packge the next time it ran (since the YAML file didn't get
    updated).

    This commit changes the msi package provider to use the `Installer`
    Automation (COM) interface to query the state of the system[1]. It will
    now accurately report on installed packages, even those it did not
    install, including Puppet itself (#13444). If a package is removed via
    Add/Remove Programs, Puppet will re-install it the next time it runs.

    The MSI package provider will now warn in the various reboot scenarios,
    but report the overall install/uninstall as successful (#14055).

    When using the msi package resource, the resource title should match the
    'ProductName' property in the MSI Property table, which is also the
    value displayed in Add/Remove Programs, e.g.

        package { 'Microsoft Visual C++ 2008 Redistributable - x86 9.0.30729.4148':
          ensure => installed,
          ...
        }

    In cases where the ProductName does not change across versions, e.g.
    VMware Tools, you MUST use the PackageCode as the name of the resource
    in order for puppet to accurately determine the state of the system:

        package { '{0E3AA38E-EAD3-4348-B5C5-051B6852CED6}':
          ensure => installed,
          ...
        }

    You can obtain the PackageCode in ruby using:

        require 'win32ole'
        installer = WIN32OLE.new('WindowsInstaller.Installer')
        db = installer.OpenDatabase(path, 0)
        puts db.SummaryInformation.Property(9)

    where <path> is the path to the MSI.

    The msi provider does not automatically compare PackageCodes when
    determining if the resource is insync, because the source MSI could be
    on a network share, and we do not want to copy the potentially large
    file just to see if changes need to be made.

    The msi provider does not use the `Installer` interface to perform
    install and uninstall, because I have not found a way to obtain useful
    error codes when reboots are requested. Instead the methods
    `InstallProduct` and `ConfigureProduct` raise exceptions with the
    general 0x80020009 error, which means 'Exception occurred'. So for now
    we continue to use msiexec.exe for install and uninstall, though the msi
    provider may not uninstall multi-instance transforms correctly, since
    the transform (MST) used to install the package needs to be respecified
    during uninstall. This could be resolved by allowing uninstall_options
    to be specified, or figuring out how to obtain useful error codes when
    using the `Installer` interface.

    [1] http://msdn.microsoft.com/en-us/library/windows/desktop/aa369432(v=vs.85).aspx

(\#14964) Unlink Tempfiles consistently across different ruby versions

    The previous fix for #14964 relied on inconsisent behavior of ruby 1.8's
    `Tempfile#close!` method, which is called by `close(true)`.  Although
    the ruby documentation says `close!` is the same as `delete` followed by
    `unlink`, the exact semantics are different.  The former calls the
    Tempfile's finalizer callback directly and can raise an `Errno::EACCES`,
    while `unlink` never does.

    In ruby 1.9, the `Tempfile#close!` method was changed to call `unlink`,
    making the two APIs consistent.  As a result, the begin-ensure block
    added previously to fix #14964 was wrong.

    Also, previously if the call to `read` failed, then the Tempfile would
    not be closed and deleted until its finalizer ran.

    This commit changes the `wait_for_output` method to close and unlink the
    Tempfile in two steps.  The `unlink` method will not raise an
    `Errno::EACCES` in either ruby 1.8 or 1.9.   It also changes the `read`
    call to occur within the begin-ensure block, so that the Tempfile is
    closed and unlinked as soon as we are done with it.

(Maint) Require the right file for md5

    md5 doesn't exist on 1.9.3. It seems to have been an alias in previous
    versions of ruby for digest/md5. Requiring the other file directly
    allows this to work on all supported rubies.

Don't allow resource titles which aren't strings

    It was possible to create resources whose titles weren't strings, by
    using a variable containing a hash, or the result of a function which
    doesn't return a string. This can cause problems resolving relationships
    when the stringified version of the title differs between master and
    agent.

    Now we will only accept primitives, and will stringify them. That is:
    string, symbol, number, boolean. Arrays or nested arrays will still be
    flattened and used to create multiple resources. Any other value (for
    instance: a hash) will cause a parse error.

Eliminate require calls at runtime.

    Calling `require` is a surprisingly expensive operation, especially if
    ActiveRecord has been loaded.  Consequently, the places where we do that in
    the body of a function are hot-spots in the profile.

    They are also, generally, pretty simple and clear wins: almost all of them can
    simply require the library the first time they are loaded and everything will
    work fine.

    In my testing with a complex, real-world set of manifests this reduces time
    spent by ~ 3 wall-clock seconds in require and all children.

Fix broken ability to remove resources from the catalog.

    For the last forever, the Puppet catalog object has unable to remove resources
    correctly - they used the wrong key to remove items from an internal map.

    Because the test was broken we also ran into a situation where this simply
    wasn't noticed - and, presumably, we simply didn't depend on this in the real
    world enough to actually discover the failure.

    This fixes that, as well as the bad test, to ensure that the feature works
    correctly, and that it stays that way.

(\#14962) PMT doesn't support setting a relative modulepath

    We previously fixed expansion for the target_dir, but this only worked when the
    target_dir was set explicitly, it didn't support relative paths being passed in
    the modulepath. This patch fixes that and adds tests.

    As a side-effect, this should also fixes cases where the first modulepath
    defined in the configuration file is relative.

    It also corrects the tests previously applied for expanding the target_dir, as
    it used to rely on expanding the target_dir before adding it to the modulepath.
    This wasn't necessary, so now we don't bother testing that the targetdir is
    expanded in the modulepath after being added.

    Acceptance tests have been added for testing modulepath, with absolute
    and relative paths.

(\#15221) Create /etc/puppet/modules directory for puppet module tool

    Previously, this directory was not created by the package,
    which caused errors when the puppet module tool was used
    to install modules. This commit updates the RPM spec file
    to create this directory upon installation of the package.

(\#13070) Mark files as loaded before we load

    There is a loading cycle that occurs in some situations. It showed up as
    not being able to describe certain types because the description
    depended on the name of the type's class. For some reason (that is not
    entirely clear) the multiple loading of code seems to cause the name of
    the class to be wrong.

    This patch changes it to mark the file as loaded first, so that we don't
    get into a loading cycle.

 Extract host validation in store report processor

    Extract the validation step and refactor tests around this. Tests now don't
    touch the filesystem which avoids a corner case on windows that caused test
    failures.

 Enforce "must not should" on Puppet::Type instances in tests.

    Because we define a `should` method on Puppet::Type, and that conflicts with
    the identically named method in RSpec, we have an alias for `must` defined in
    the test helper.

    Sadly, this isn't *complete*: if you call `should` on those instances you
    actually get no failure, it just silently ignores your actual test.

    This change monkey-patches Puppet::Type in the spec helper, and adds a type
    check to fail hard if you supply something "illegal" as the argument to
    Puppet::Type.

(\#14531) Change default ensure value from symlink to link

    If ensure on a file resource is omitted, puppet will set the should value
    to :symlink in the initialize method of the file type but the ensure property
    does not use :symlink but :link to identify a link.

    As a result, puppet will always treat a resource with a specific target
    property but no ensure property as out of sync:

        file { '/tmp/a':
          target => '/tmp/b',
        }

    When puppet now calls sync on the ensure property, the fileresource
    (`/tmp/a`) is removed first (method `remove_existing`) but we do not
    execute the block passed to `newvalue(:link)` to recreate it. Because
    there is no `newvalue(:symlink)` block, we instead run the block in
    `newvalue(/./)` which is just a dummy and does nothing at all. As a
    result puppet will *always* say it created something while in fact
    making sure that the resource is *removed*.

    Change the default ensure value from :symlink to :link if target is
    set.

 Upstart code cleanup, init provider improvement

    This commit adds an is_init? function to the init provider, to prevent the init
    provider from handling upstart jobs redundantly (which happens with services
    such as network-interface and network-interface-security). It also adds tests
    for the exlusion of instances in the upstart provider and exclusion of upstart
    services from the init instances. It also cleans up some upstart provider code
    (self.instances, self.search), eliminating redundant code and refactoring some
    methods (upstart_status, status, normal_status).
    This also removes the custom status command from upstart, which almost
    certainly wasn't doing what it was expected. The upstart status command is
    effective at gauging the status of upstart services.

 Handle network-interface-security in upstart

    Similar to network-interface, network-interface-security is an upstart job that
    requires special handling to get status information. While network-interface
    takes and interface argument, network-interface-security takes a job argument.
    This commit adds that special case, and also updates the search method with a
    corresponding special case so the jobs can be recognized as upstart jobs.

Add exclude list to upstart provider

    The wait-for-state service seems to be a helper that is used by upstart, but
    doesn't have a useful status or consistent way to call. Trying to use that
    upstart service generally results in an error. This commit adds an exclude list
    similar to the redhat provider so that services like 'wait-for-state' can be
    excluded from the service instances.

(\#15027, \#15028, \#15029) Fix upstart version parsing

    A leading space in the --version argument would confuse upstart, and the
    version returned would not always be a semantic version, which caused the
    upstart provider to fail. This commit updates the initctl call to remove the
    leading space from the --version argument, and also replaces the implicit
    SemVer comparisons with wrapper functions that call out to
    Puppet::Util::Package.versioncmp to do version comparisons. It also fixes a
    subtly broken regex to grab the full version string.

(\#13489) Synchronously start and stop services

    Previously, we were using the `win32-service` gem to start and stop
    services.  It uses Win32 APIs to programmatically send start and stop
    requests.  The actual service starts/stops asynchronously with respect
    to the request.  As a result, when refreshing a service, puppet would
    issue a stop request, immediately followed by a start request, and that
    would race as the service would often still be running when the start
    request occurred, leading to 'An instance of the service is already
    running'.

    This commit changes the windows service provider to use `net.exe` to
    start and stop services.  This command will block until the service
    start/stops, and returns 0 on success, making it easy to adapt to the
    provider command pattern.  The one downside is that the exit codes don't
    have the same resolution that we can get via the `sc.exe` or by calling
    the Service Control Manager programmatically.  But that is not too
    critical because we do capture the output of the `net.exe` command, e.g.
    'The service name is invalid.' and include it in the exception message.

 (\#14964) Don't fail if we can't unlink the Tempfile on Windows

    Previously, if the exec resource created a process, e.g. start.exe, that
    executed another process asynchronously, then the grandchild would inherit
    the tempfile handle, preventing puppet from being able to unlink it. This
    is not an issue on POSIX systems.

    This commit changes the `wait_for_output` method to ignore Errno::EACCES
    exceptions caused when closing and unlinking the stdout tempfile. The
    behavior on POSIX systems is unchanged.

\(#14860) Fix puppet cert exit status on failures

    Without this patch applied the following command errors out but does not
    correctly set the exit status:

        puppet cert generate foo.bar.com --dns_alt_names foo,foo.bar.com

    The error returned is:

        err: Could not call generate: CSR 'pe-internal-broker-test'
          contains subject alternative names (DNS:pe-centos6, \
          DNS:pe-centos6.puppetlabs.vm, DNS:pe-internal-broker-test, \
          DNS:stomp), which are disallowed. Use `puppet cert \
          --allow-dns-alt-names sign pe-internal-broker-test` to sign this \
          request.

    However, the exit status is 0.

    This is a problem because we need to easily detect if certificate
    generation from the command line failed or succeeded.  The most natural
    and expected way to check this is by looking at the exit status.

    The root cause of the problem is that
    Puppet::SSL::CertificateAuthority::InterFace#apply incorrectly catches
    and masks the exception raised by the generate method because it simply
    logs an error with Puppet.err and continues along happily.

    This patch fixes the problem by re-raising the error produced by
    generate, allowing the application controller to catch the error
    appropriately and exit with the non-zero exit status.

(\#13379) Add path of pluginsync'd lenses to Augeas load_path automatically

    The path $libdir/augeas/lenses is added to the Augeas load_path initialisation
    option automatically to support lenses being pluginsynced.  Lenses should be
    added into the <module>/lib/augeas/lenses directory inside a module.

    The load_path parameter has been expanded to support an array of paths as well
    as a colon-separated list.

Fixes for \#10915 and \#11200 - user provider for AIX

    The user provider on AIX fails to set the password for local users
    using chpasswd.

    This commit includes the code in ticket #11200 suggested by Josh
    Cooper. It works in my environment (AIX 5.3 + 6.1).

    chpasswd can also return 1 even on success; it's not clear if this is
    by design, as the manpage doesn't mention it. The lack of output from
    chpasswd indicates success; if there's a problem it dumps output to
    stderr/stdout.

## Puppet 2.7.18

This is a **security** release in the 2.7.x branch.

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

 CVE-2012-3866 last_run_report.yaml is world readable (medium)
    The most recent Puppet run report is stored on the Puppet master
    with world-readable permissions. The report file contains the context
    diffs of any changes to configuration on an agent, which may contain
    sensitive information that an attacker can then access. The last run
    report is overwritten with every Puppet run.

 Arbitrary file read on the Puppet master by an agent (medium)
    This vulnerability is dependent upon CVE-2012-3866 "last_run_report.yml
    is world readable" above. By creating a hard link of a Puppet-managed
    file to an arbitrary file that the Puppet master can read, an attacker forces
    the contents to be written to the puppet run summary. The context diff is
    stored in last_run_report.yaml, which can then be accessed by the
    attacker.

 CVE-2012-3867 Insufficient input validation for agent hostnames (low)
    An attacker could trick the administrator into signing an attacker's
    certificate rather than the intended one by constructing specially
    crafted certificate requests containing specific ANSI control sequences.
    It is possible to use the sequences to rewrite the order of text displayed
    to an administrator such that display of an invalid certificate and valid
    certificate are transposed. If the administrator signs the attacker's
    certificate, the attacker can then man-in-the-middle the agent.

 CVE-2012-3408 Agents with certnames of IP addresses can be impersonated (low)
    If an authenticated host with a certname of an IP address changes IP
    addresses, and a second host assumes the first host's former IP
    address, the second host will be treated by the puppet master as the
    first one, giving the second host access to the first host's catalog.
    Note: This will not be fixed in Puppet versions prior to the forthcoming
    3.x. Instead, with this Puppet 2.7.18, IP-based authentication in
    Puppet < 3.x is deprecated, and a warning will be issued when used.


## Puppet 2.7.17

(#15027, #15028, #15029) Fix upstart version parsing

    A leading space in the --version argument would confuse upstart, and the
    version returned would not always be a semantic version, which caused the
    upstart provider to fail. This commit updates the initctl call to remove the
    leading space from the --version argument, and also replaces the implicit
    SemVer comparisons with wrapper functions that call out to
    Puppet::Util::Package.versioncmp to do version comparisons. It also fixes a
    subtly broken regex to grab the full version string.

Add exclude list to upstart provider

    The wait-for-state service seems to be a helper that is used by upstart, but
    doesn't have a useful status or consistent way to call. Trying to use that
    upstart service generally results in an error. This commit adds an exclude list
    similar to the redhat provider so that services like 'wait-for-state' can be
    excluded from the service instances.

Handle network-interface-security in upstart

    Similar to network-interface, network-interface-security is an upstart job that
    requires special handling to get status information. While network-interface
    takes and interface argument, network-interface-security takes a job argument.
    This commit adds that special case, and also updates the search method with a
    corresponding special case so the jobs can be recognized as upstart jobs.

## Puppet 2.7.16

(\#8858) Explicitly set SSL peer verification mode.

    In Ruby 1.8 the Net::HTTP library defaults to skipping peer verification when
    no mode is explicitly set.  Ruby 1.9, on the other hand, does not: it defaults
    to verification of the peer certificate - leading to failure when we depended
    on the default value in our HTTP setup.

    This changes to explicitly set the verification mode, ensuring we get
    consistent results across all Ruby versions.

*Significantly improve compilation performance when using modules
    When autoloading classes/defines, the typeloader constructs a set of
    possible locations for the class, based on its name. Effectively, it
    will look in the canonical locations corresponding to each namespace in
    the fully-qualified name. So for each namespace, it will ask the
    environment for a Puppet::Module instance for that module, to ask it
    which of the module's potentially manifests match the class it's looking
    for. To answer that request, the environment instantiates a
    Puppet::Module.

    This amounts to potentially thousands of Puppet::Module instances being
    created, because it does this many times (based on nesting of the class
    name) per include/autoload/import. When Puppet::Module instances are
    created, they parse and load their metadata.json file, in part to
    validate their use. This implies that each compilation results in
    metadata.json being parsed thousands of times, which is extremely slow
    (and obviously provides no actual benefit).

    Fortunately, the environment object already keeps a list of
    Puppet::Module instances for every module in its modulepath. The fix
    applied here is simply to change the environment such that it provides
    modules by looking them up in its cached list, resulting in up to an
    order of magnitude improvement in compilation time.

*Colorize console output on Windows
    Previously, `Puppet[:color]` was false on Windows, because the Windows
    console does not support ANSI escape sequences.

    The win32console gem converts ANSI color escape sequences into Win32
    console API calls to change the foreground color, etc. If the output
    stream has been redirected to a file, then the gem does not translate
    the sequences, instead preserving them in the stream, as is done on
    Unix.

    To disable colorized output specify `color=false` or `--color=false` on
    the command line.

    This commit adds a `Puppet.features.ansicolor?` feature that defines
    whether ANSI color escape sequences are supported. On Windows, this is
    only true if the win32console gem can be loaded. On other platforms, the
    value is always true.

    The win32console gem will be packaged into the Windows installer, and
    so, `Puppet[:color]` now defaults to true. If the gem can't be loaded,
    then puppet will revert to its previous behavior.

(\#8174) Allow defines to reference topscope

    Because the compiler re-assigned the topscope, looking up topscope vars
    or facts from a defined resource type was causing deprecation warnings
    when it should not be. By cherry-picking commits
    b02aa930a03a282588e81f65e14f47a138a4b9f0 and
    c995be16bc9e3ad8dbad9d21b49df76de5b72ea9 the topscope is no longer
    re-assigned and so defined resource types can now lookup these kinds of
    variables without problem.

Evaluate node classes either in top or node scope

    Classes that are tied to a node should be preferred to be evaluated in
    the node scope, but if we don't have one then they should be in the top
    scope

(\#14297) Handle upstart services better

    The previous changes to the upstart provider didn't take into account services
    that may have upstart jobs in /etc/init with no corresponding symlink to
    upstart-job in /etc/init.d. This fix adds /etc/init/$service.conf to the search
    path in the upstart provider.

    In order to allow upstart to use debian as its parent, this commit adds methods
    for enabled?, enable and disable. Without this fix, using a debian style init
    script on ubuntu requires manually specifying the debian provider be used.
    With this commit, the upstart provider can be the default for ubuntu and
    still fail up to its parent, debian.

    The enabled?, disable, and enable methods are complicated because upstart has 3
    behaviors to account for. Upstart < 0.6.7 have only the conf file and start on
    stanzas to worry about, 0.6.7 < upstart < 0.9.0 has a manual stanza which
    removes any previous start on declaration, and upstart >= 0.9.0 has an override
    file. In upstart >= 0.9.0, the provider does all of its work using override files
    to leave the upstart conf file for the service intact and unchanged.

    Because of the need to know which upstart version is being used, this commit
    also adds a method and a class variable to hold and access the upstart version,
    obtained by a call to `initctl --version`.

(\#14343) Lookup in correct inherited scope

    The previous twoscope lookup of the inheritied scope tried to find the
    inherited scope by looking up the class_scope() directly. Unfortunately,
    this does not work correctly in cases where the inherited scope is
    qualified to the topscope (::parent) or where the scope is implicitly
    qualified (class a { class b {} class c inherits b {} }).

    By using the same mechanism that variables use for looking up scope (the
    qualified_scope() method) variable lookup will find a scope consistent
    with what qualified variable lookups will find.

(\#14761) Add boot, reboot to excludes list for redhat provider

    On sles, the reboot init script would be triggered during a `puppet resource
    service` call, which would ignore the status argument and proceed
    to reboot the
    system. It would also call the boot init script, which could hang the puppet
    call indefinitely. This commit adds both the boot and reboot services to the
    redhat provider's exclude list. It also updates the redhat
    provider spec test
    to test for those changes.

(\#14615) Exclude helperscripts in gentoo service provider

    The directory `/etc/init.d` does not only store normal initscripts but
    also a few helper scripts (like `functions.sh`). The former behaviour was
    to treat them as regular initscripts which can lead to dangerous results
    especially when running `puppet resource service`. This command will
    issue `/etc/init.d/<script> status` on every script inside
    `/etc/init.d`. Because the helperscripts don't care about arguments,
    this will cause the system to reboot when `/etc/init.d/reboot.sh status` is
    executed.
    Exclude helperscripts when searching inside `/etc/init.d`.

## Puppet 2.7.15

Puppet 2.7.15 was never released, and its commits were rolled into 2.7.16.

## Puppet 2.7.14

### Contributors
Andrew Parker, Chris Price, Daniel Pittman, Dominic Cleal, Gary
Larizza, Hunter Haugen, Jeff McCune, Jeff Weiss, Josh Cooper, Justin
Stoller, Kelsey Hightower, Ken Barber, Lauri Tirkkonen, Matt Robinson,
Matthaus Litteken, Moses Mendoza, Nicholas Hubbard, Nick Lewis, Nick
Fagerlund, Nigel Kersten, Patrick Carlisle, Pieter van de Bruggen,
Reid Vandewiele, and Stefan Schulte

### Features
    Puppet Module Tool Face - the module tool has seen a host of
    improvements including dependency resolution, environment handling,
    and searching the forge. There are more details available at
    http://docs.puppetlabs.com./modules_installing.html

### Bug Fixes

(\#13682) Rename Puppet::Module::Tool to Puppet::ModuleTool

    Without this patch, Puppet will monkey patch the existing implementation
    of the puppet-module Gem if it is used.  This is bad because the two
    implementations are all jumbled up inside of one another and behavior
    may become unpredictable.  Warnings are also displayed directly to the
    end user in the form of redefined constants.

    This patch fixes the problem by renaming Puppet::Module::Tool inside of
    Puppet to Puppet::ModuleTool  This fixes the problem because Puppet will
    no longer monkey-patch the Puppet::Module::Tool module inside of the
    puppet-module Gem.

    This patch also has the added benefit of making the Module's name match
    up with the CamelCase filepath (puppet/module_tool/ =>
    Puppet::ModuleTool)  As a result, no file moves are necessary.

(\#13682) Fix acceptance test failures

    On Lucid, /usr/share/puppet may not exist.  The module upgrade tests all
    make the assumption that this parent directory exists.  This causes
    false positive failures when running systest against a Lucid system.

    This patch modifies the setup code for all of the tests to ensure the
    parent directory exists.

(maint) Ensure every file has a trailing newline

    Without this patch some files exist in the tree that don't have trailing
    newlines.  This is annoying because perl -pli.bak -e will automatically
    add a newline to every file it modifies in place.  The files that
    actually have modifications by the global search and replace need to be
    separated from the files that only have newlines added.

    This patch simply adds newlines to everything if they don't exist on the
    last line.

    Yes, the PNG's are perfectly fine with a trailing newline as well.

(\#14036) Handle upstart better

    Change the upstart provider to better handle the mix of some services
    that are upstart controlled and some that are init script controlled.

(\#14060) Fix quoting of commands to interpolate inside the shell.

    The `shell` exec provider was supposed to emulate the behaviour of 0.25 exec,
    which was to pass the content through the default shell to get it executed.

    Unfortunately, it got quoting a bit wrong, and ended up interpolating
    variables at the wrong point - it used double quotes where single quotes were
    really what was desired.

    Thanks to Matthew Byng-Maddick for the report, and a fix to the quoting; in
    the end we should not be in this position - we shouldn't be using string
    execution where we can pass an array instead.  That avoids any chance that
    there is more than one round of shell interpolation entirely.

    As a bonus, this fixes the base exec type to support specifying the command to
    run that very way, and making it good.

(\#14101) Improve deprecation warning for dynamic lookup

    The new message will tell the user how to get more information about
    what is occuring. More information will be provided at debug level so
    that a user can see what the change to the lookup will be.

Better warnings about scoping

Make new scoping look through inherited scopes

    Previous to this commit, Puppet would look through a given scope
    hierarchy and give deprecation warnings when a value was found in either
    an inherited class scope or included class scope, when it should only
    give the warning in the case of the included class scope.
    This commit makes the new-scope behavior also examine inherited scopes,
    though continuing to ignore included scopes.

Implement newlookupvar() to replace dynamic scope

    lookupvar() is shifted to oldlookupvar() and newlookupvar() is added. An
    intermediary lookupvar() function will query both and if the answer
    varies then it will throw a deprecation warning for dynamic scoping. The
    intermediary and old lookup functions may be removed at a later date,
    thus completing the transition.
    A test case has been introduced to detect dynamic scoping and the
    deprecation warning. Slight modifications to the spec test scoping
    objects were made to bring them more in line with the real world.
    All scope tests pass. When oldlookupvar is replaced, the deprecated
    dynamic scoping test case will fail and all other scope test cases will
    pass.


Augeas Improvements

(\#11988) Work around Augeas reload bug when changing save modes

    After saving a file in one save mode and switching to another,
    Augeas realise
    to reload the file when Augeas#load is called again.  Work around this by
    explicitly reloading all files we saved while using the first save mode.

(\#11988) Don't overwrite symlinks in augeas provider

    Previously, if not running with `force` set, we would try to write the
    file in SAVE_NEWFILE mode to create a <filename>.augnew file with the
    changes. We determined whether there were changes to be made based on
    that file (and used it to show a diff). When it came time to actually
    make the changes, we would simply move the .augnew file over the file
    being managed. Unfortunately, if the file being managed were a symlink,
    this would clobber it.

    There was a fallback path in the case of force (or older versions of
    augeas not supporting SAVE_NEWFILE) in which we would make the
    changes in SAVE_OVERWRITE mode as normal. Now, the behavior is a
    combination of the two; we still use SAVE_NEWFILE to determine whether
    changes need to be made and to show a diff, but then remove the .augnew
    file and always run again in SAVE_OVERWRITE mode to save the changes.
    This effectively delegates the behavior of preserving the file, etc.
    to augeas, so we don't duplicate effort or bugs.

(\#13204) Don't ignore missing PATH.augnew files

    The original fix for #13204 may have masked other potential bugs if the
    PATH.augnew file was missing.  It simply tested for the file
    existance and not
    only when duplicate save events occurred.
    This change de-duplicates the list of save events instead, so if a
    bug appeared
    where PATH.augnew was genuinely missing, the error wouldn't be squashed.

(\#13204) Workaround duplicate Augeas save events

    Bug #264 in Augeas causes duplicate save events to be returned when editing
    under /boot in newfile mode.  Because we loop around these events,
    diffing and unlinking the files, this causes an ENOENT error when we process
    the same event twice.

    This commit checks that the file we intend to operate on exists.

(\#7592) Remove redundant call to String#to_s

    Previously, the augeas provider made calls like the following:
    @aug.get(key).to_s
    Since the Augeas#get method returns a String not an array, the to_s
    call is redundant. (Note the #match method does return an array.)
    The augeas tests were stubbing the #get method to return an array in
    some places (and a string in others). Prior to 1.9.2, ruby will
    automatically convert ["foo"].to_s to "foo", so everything worked as
    expected. However, under 1.9.2, ["foo"].to_s becomes "[\"foo\"]".
    These failures weren't noticed earlier, because our 1.9.2@allFeatures
    jenkins nodes do not have ruby-augeas installed. In other words, tests
    that require Puppet.features.augeas? were never running in
    Jenkins. The recent change to improve augeas testing, removed the
    dependency on this feature being installed, so these tests started
    failing.
    This commit just removes the redundant call to String#to_s, and
    updates the spec tests to match what the Augeas#get method really
    returns.

Zypper Provider Improvements

(\#8312) Fix zypper provider so ensure => 'latest' now works

    Previously the regular expression to match the correct column from
    'zypper list-updates' was wrong, it seems to have been based on the command
    'zypper packages' instead. This was caused ensure => 'latest' to fail as the
    provider couldn't adequately figure out what newer versions were actually
    availabe.
    So I've fixed the regular expression (based on Felix Frank's
    patch) and updated
    the spec test so that it uses the real output from zypper
    list-updates and now
    references an external spec file, as apposed to referencing the
    content inline.

Windows Bugfixes

(\#12392) Created Windows eventlog message resource dll

    This commit adds the ability to build a message resource dll used to
    display localized eventlog messages on Windows. Windows eventlog expects
    that each log event has a unique id, which can then be localized in a
    resource dll, one for each locale. However, puppet does not yet support
    this, see #11076. So this commit defines three puppet event ids
    corresponding to the three levels of Windows events that we support
    (info, warn, and error).
    In order to build the dll, you need the Windows SDK installed that
    contains the mc, rc, and link utilities.

(Maint) Don't assume eventlog gem is installed on Windows

    Previously, the test would fail when run on a Windows box that didn't
    have the eventlog gem installed. Since the Windows agent should be able
    to run without the gem installed, and fall back to writing to a log
    file, this commit changes the test to only run when the gem is
    installed. There is already a test that verifies that we fall back if
    the eventlog feature is not available.


## Puppet 2.7.13

This is a **security** release in the 2.7.x branch.

### Security Fixes

#### CVE-2012-1906 (High) - appdmg and pkgdmg providers write packages to insecure location

http://puppetlabs.com/security/cve/cve-2012-1906

(\#13260)

    If a remote source is given for a package, the package is downloaded
    to a predictable filename in /tmp. It is possible to create a symlink
    at this name and use it to clobber any file on the system, or by
    switching the symlink install arbitrary packages (and package installers
    can execute arbitrary code).

#### CVE-2012-1986 (High) - Filebucket arbitrary file read

http://puppetlabs.com/security/cve/cve-2012-1986

(\#13511)
    It is possible to construct a REST request to fetch a file from a
    filebucket that overrides the puppet master’s defined location
    for the files to be stored. If a user has access to construct directories
    and symlinks on the machine they can read any file that the user the
    puppet master is running as has access to.

#### CVE-2012-1987 (Moderate) - Filebucket denial of service

http://puppetlabs.com/security/cve/cve-2012-1987

(\#13552,\#13553)

    By constructing a marshaled form of a Puppet::FileBucket::File object a
    user can cause it it to be written to any place on the disk of the puppet
    master. This could be used for a denial of service attack against the
    puppet master if an attacker fills a filesystem that can cause systems to
    stop working. In order to do this the attacker needs no access to the
    puppet master system, but does need access to agent SSL keys.

    Using the symlink attack described in Bug #13511 the puppet master
    can be caused to read from a stream (e.g. /dev/random) when either
    trying to save a file or read a file. Because of the way in which the puppet
    master deals with sending files on the filesystem to a remote system via a
    REST request the thread handling the request will block forever reading from
    that stream and continually consuming more memory. This can lead to the
    puppet master system running out of memory and cause a denial of service.

#### CVE-2012-1988 (High) - Filebucket arbitrary code execution

http://puppetlabs.com/security/cve/cve-2012-1988

(\#13518)
    Filebucket arbitrary code execution
    This requires access to the cert on the agent and an unprivileged
    account on the master.  By creating a path on the master in a
    world-writable location that matches a command string, one can
    then make a file bucket request to execute that command.

#### CVE-2012-1989 (High) - Telnet utility (used for network devices) writes to insecure location

http://puppetlabs.com/security/cve/cve-2012-1989

(\#13606)
    The telnet.rb file opens a NET::Telnet connection with an output log
    of /tmp/out.log. That log could be replaced by a symlink anywhere
    on the system and the puppet user would happily write through the
    symlink, potentially clobbering data or worse.


## Puppet 2.7.12

### Features

* Zypper package provider supports zypper 0.6
* Raise default key lengths in Puppet

Plumbing For Puppet Module Tool improvements

* Module requirements should include versions
* Fix SemVer's range behavior to work with Ruby 1.9
* Face actions should be able to set exit codes
* Implement a rich console logging prototype
* Enhance the uninstall PMT action
* All forge interactions should be centralized
* Add module dependency errors to module list output
* Enhance PMT search action output

### Bug Fixes

Windows Bug Fixes

* Fix puppet agent --listen on Windows
* Don't add execute bit to newly created files on Windows
* Skip default file permissions for sync'ed files on Windows
* Allow POSIX paths for files served to Windows agents
* Refactor Windows administrator detection
* Disable puppet kick on windows

* Restored agent lockfile behavior to 2.7.9;  in 2.7.10 and 2.7.11, 'puppet agent --disable' begun to use a new lock file named 'puppetdlock.disabled'.  This was determined to cause compatibility issues with certain external tools, so the pre-2.7.10 behavior has been restored.
* Agent lockfile backwards compatibility to support users upgrading from 2.7.10 or 2.7.11.
* Improved status / notification message when attempting to run an agent after agents have been administratively disabled (via 'puppet agent --disable').
* Cron error messages on Windows less cryptic
* Don't overwrite symlinks in augeas provider
* Fix zypper provider so ensure => 'latest' works

### Details

(\#11988) Don't overwrite symlinks in augeas provider

    Previously, if not running with `force` set, we would try to write the
    file in SAVE_NEWFILE mode to create a <filename>.augnew file with the
    changes. We determined whether there were changes to be made based on
    that file (and used it to show a diff). When it came time to actually
    make the changes, we would simply move the .augnew file over the file
    being managed. Unfortunately, if the file being managed were a symlink,
    this would clobber it.

    There was a fallback path in the case of force (or older versions of
    augeas not supporting SAVE_NEWFILE) in which we would make the
    changes in SAVE_OVERWRITE mode as normal. Now, the behavior is a
    combination of the two; we still use SAVE_NEWFILE to determine whether
    changes need to be made and to show a diff, but then remove the .augnew
    file and always run again in SAVE_OVERWRITE mode to save the changes.
    This effectively delegates the behavior of preserving the file, etc.
    to augeas, so we don't duplicate effort or bugs.

(\#8312) Fix zypper provider so ensure => 'latest' now works

    Previously the regular expression to match the correct column from
    'zypper list-updates' was wrong, it seems to have been based on the command
    'zypper packages' instead. This was caused ensure => 'latest' to fail as the
    provider couldn't adequately figure out what newer versions were actually
    availabe.

    So I've fixed the regular expression (based on Felix Frank's patch) and updated
    the spec test so that it uses the real output from zypper list-updates and now
    references an external spec file, as apposed to referencing the content inline.

(\#12914) Allow puppet to be interrupted while waiting for child

    Previously, puppet on Windows could not be interrupted, e.g. Ctrl-C,
    while waiting for a child process it executed to exit. For example,
    when executing a pre/post run command.

    This commit changes puppet to poll the state of the child process'
    handle, sleeping for 1 second in between.

(\#12844) Agent lockfiles: backwards compatibility with 2.7.10/2.7.11

    In 2.7.10 there was a change in behavior introduced with regards
    to agent lockfiles.  Basically we split the concept of "an agent
    is currently running" apart from the concept of "the agent has
    been administratively disabled" by using 2 different lockfiles.

    That change was determined to have broken compatibility with
    mcollective, so it has been reverted as of 2.7.12.

    This commit provides backwards compatibility between 2.7.12+
    and 2.7.10/2.7.11 for cases where a user may have administratively
    disabled their agent and then upgraded to a newer version of puppet.

(\#12881) Fix cron type default name error on windows

    On windows I ran into this error with the cron type:

        err: Failed to apply catalog: undefined method 'name' for nil:NilClass

    Without this patch, the problem appears to be that the cron type name
    parameter defaults to the following block:

        defaultto { Etc.getpwuid(Process.uid).name || "root" }

    On windows `Etc.getpwuid(Process.uid)` returns `nil`.  This patch fixes
    the problem by binding the object returned by
    `Etc.getpwuid(Process.uid)` to a variable.  We then check if the
    variable responds to the `name` method, and only send a message to name
    if so.  Otherwise, we return "root"

(\#12933) Better error message when agent is administratively disabled

    Detect the difference between the cases where an agent run is
    aborted due to another agent run already in progress vs. being
    aborted due to the agent being administratively disabled via
    '--disable', and print a more useful message for the latter case.

(\#12080) Implement a rich console logging prototype.

    The new telly_prototype_console log destination aims to be a more human-friendly logging
    endpoint, and acts as a prototype of some of the work we plan to build into Telly.

(\#12106) Enhance the uninstall PMT action for UX

    Before this patch the uninstall action only uninstalled puppet modules by
    name. The uninstallation of a module consists of removing a directory in
    the module path that matches the name of the module. This does not take
    into account the version of the module installed.

    This patch changes the behaviour of the uninstall action with the
    following features:

    * Modules can be uninstalled by specific version
    * Modules can be uninstalled by enviornment
    * Output of the unistall command has been enhanced to provide a better UX

    This patch also includes updated specs for the change in behaviour.

(\#12244) All forge interactions should be centralized

    Before this patch each module application makes direct connection to the
    Puppet Forge. This is a maintenance nightmare, any changes to the
    Forge API requires changes to all the module applications.

    This patch re-factors how we communicate with the Forge. All module
    application now use the interface exposed by the `lib/puppet/forge.rb`
    module.

    This patch also includes tests for the new forge.rb module, and updates
    others to reflect the new behaviour.

(\#12256) Fix SemVer's range behavior to work with Ruby 1.9

    In Ruby 1.9 Range's implementation of include? changed so that if the
    objects being compared were non-numeric it would iterate over them
    instead of doing a comparison with the endpoints.  We're subclassing
    numeric to force non-discrete range behavior.

    Numeric doesn't allow singleton methods to be defined, so we had to
    change the way inspect worked when dealing with MIN and MAX values.

    Paired-with: Pieter van de Bruggen <pieter@puppetlabs.com>

(\#12256) module_requirements should include versions

    Before this patch module requirements do not include version numbers.
    Since modules with the same name, but different version numbers, can be
    installed at the same time -- in different parts of the modulepath,
    there is no way to tell which module has the dependency.

    This patch fixes this issue by changing the data structure that
    represents module requirements from a two item Array to a Hash with
    three keys: name, version, and version_requirement.

    This patch includes updated spec tests related to this change.

(\#10299) Use CheckTokenMembership to see if user has admin rights

    Previously, on Windows 2003 and earlier, Puppet.features.root? was
    implemented by checking if the current user is a member of the local
    Administrators group. However, many accounts, e.g. LocalSystem, are
    implicit members of this group, so Puppet.features.root? would
    incorrectly return false. This led to puppet not being able to find
    its default configuration directory, among other things.

    Conversely, a process can be executing using a restricted token, so
    while the user may be a member of the Administrators group, the
    process will be running with less privileges, and
    Puppet.features.root?  would incorrectly return true.

    This commit uses CheckTokenMembership to determine if the local
    Administrators group SID is both present and enabled in the calling
    thread's access token.

    The behavior on Vista/2008 is unchanged. The calling thread's token
    must be currently elevated.

(\#12725) Fix puppet agent --listen on Windows

    Previously, running `puppet agent --listen` failed on Windows, because
    we were trying to set the Fcntl::FD_CLOEXEC flag on webrick's http
    access log, but Windows does not support that flag.

    There are ways to prevent file handles from being inherited across
    calls to CreateProcess (either disabling inheritance on a given handle
    or preventing all handles from being inherited). But for now, this
    commit just skips setting the flag on Windows.

    This commit also re-enables spec tests that were disabled on
    Windows. The thinking previously is that webrick would never run on a
    Windows agent, but that's not true.

(\#11740) Wait on the handle from the PROCESS_INFORMATION structure

    Previously, the `Puppet::Util.execute` method was using `waitpid2` to
    wait for the child process to exit and retrieve its exit status. On
    Windows, this method (as implemented by the win32-process gem) opens a
    handle to the process with the given pid, and then calls
    `WaitForSingleObject` and `GetExitCodeProcess` on the process
    handle. However, the pid-to-handle lookup will raise an exception if
    the child process has exited. As a result there was a race condition
    whereby puppet could sometimes fail to retrieve the exit status of
    child processes.

    The normal way of getting the exit code for a child process on Windows
    is to use the child process handle contained in the
    `PROCESS_INFORMATION` structure returned by `CreateProcess`. This
    works regardless of whether the child process is currently executing
    or not.

    This commit reworks the `Puppet::Util.execute_windows` method to wait
    on the child process handle contained in the process information
    structure. This requires that we pass the `:close_handles => false`
    option to the win32-process gem so that it doesn't close the handles.

    This commit also re-enables tests that were previously being skipped
    due to this bug.

(\#11408): Don't add execute bit to newly created files on Windows

    Previously, if a directory was executable for owner or group, then any
    file created at a later time in the directory would have its execute
    bit set. For example, if a directory's mode is set to 0750, then any
    file created in the directory at a later time would have the same
    mode.

    This causes the file mode to change unnecessarily across puppet
    runs. For example, when puppet starts for the first time, it creates a
    $vardir/certs directory that is executable. During the same run, it
    writes out its signed cert, which is now executable. The second time
    puppet runs, it sees that the mode is out-of-sync, it should be 0644,
    and changes the mode.

    If the same scenario occurs to a service's configuration file, then
    puppet could bounce the service unnecessarily.

    This commit creates two sets of inherit-only access control entries on
    the parent directory. One set applies the same permissions from the
    parent directory to its subdirectories (containers) at creation time. The other set
    masks off the execute bit for its files (objects) at creation time.

    Note puppet always has FULL_CONTROL (which includes FILE_EXECUTE) for
    files it creates, so this commit does not prevent puppet from being
    able to execute content that it downloads. It only prevents group and
    other from having execute permission by default.

    In order to grant execute permission to group and other on a file that
    puppet manages, you must explicitly specify the appropriate mode in
    the file's resource.

(\#11408) Allow POSIX paths for files served to Windows agents

    Previously, Windows agents would fail during fact and plugin sync. The
    agent would retrieve the remote file metadata and attempt to set the
    metadata's path based on the path of the file as it exists on the
    remote system. Since the remote system is typically a POSIX puppet
    master, our `Puppet::Util.absolute_path?` path check would fail on
    Windows.

    To complicate matters, the path of the "remote" file can in fact be a
    Windows-style path, such as when using puppet apply and a modulepath
    that refers to the local filesystem.

    This commit changes the `Puppet::FileServing::Base#path=` method to
    allow both POSIX and Windows style paths on Windows hosts, but only
    allows POSIX style paths on POSIX hosts, since we don't support
    running puppet master on Windows.

(\#6663) Raise default key lengths in Puppet.

    The CA key length was lower than it should be - 1024 bits is no longer secure
    enough for real world use.  This raises both client and CA certs to use 4096
    bit keys.  Those are slow, but effective for long term security.

    People who know enough to decide that the trade-off of speed vs limited window
    of security can still totally reduce the size of the key without much trouble,
    but we default to being more cautious.

    This also pegs the key lengths low in testing, since building a 4K key is
    awful slow if you want to do it time and time again over the course of dozens
    of tests.


## Puppet 2.7.11

This is a **security, and bug fix** release in the 2.7.x branch.

### Security Fixes

#### CVE-2012-1053 (Group Privilege Escalation)

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

#### CVE-2012-1054 (User Privilege Escalation)

http://puppetlabs.com/security/cve/cve-2012-1054/

(\#12460)

If a user’s `.k5login` file is a symlink, Puppet will overwrite the
link’s target when managing that user’s login file with the k5login
resource type. This allows local privilege escalation by linking a
user’s `.k5login` file to root’s `.k5login` file.

2.7.11 also addresses the following regressions in the 2.7.10 release
\#12572, \#12188, \#12412, \#2927, \#12296, \#12310, \#12464

## Puppet 2.7.10

### Pulled due to regressions from 2.7.9

We are continuing to see several issues introduced Puppet 2.7.10.  We
are recommending that users discontinue its usage.  This could mean
using 2.7.9 or waiting patiently until we can get 2.7.11 out the door.

These are the most significant tickets around the  2.7.10 regressions.
\#12310, \#2927, \#12269, \#12588

#### Community MVP for this release: Brice Figureau (@masterzen) for the
Instrumentation Framework

#### Highlights
We have several section of release notes this month due to the high volume of commits.  Sections are Instrumentation, Core, Mac OS, Windows, and FreeBSD.


* Instrumentation Features available
* Symbolic File modes supports ( e.g. u=rw,go=r) for File type
* Write reports to a temporary file and move them into place
* Add password get/set behavior for Mac OS X 10.7
* Add support for user expiriy in pw user provider
* Improve pw group provider on FreeBSD
* Make sure managehome is respected on FreeBSD
* Add password management on FreeBSD

#### Bug Fixes
* Make the Debian service provider handle services that don't conform to the debian policy manual.
* Only load facts once per run
* Puppetd removes pid file upon exit
* Fix MySQL deadlock possibility within inventory service
* Test Augeas versions correctly with versioncmp
* Consider package epoch version when comparing yum package versions
* Link should autorequire target
* Use SMF's svcadm -s option to wait for errors
* Fix fact and plugin sync on Windows
* Set password before creating user on Windows
* Always serve files in binary mode on Windows
* Don't hard code ruby install paths in Windows batch files
* Don't copy owner and group when sourcing files from master on Windows
* Fix OS X supplementary group handling
* Use launchctl load -w in launchd provider (Mac OS)
* Improve error msg for missing pip command
* Better validation for IPv4 and IPv6 address in host type.

#### Instrumentation
Contributed by:  Brice Figureau <brice-puppet@daysofwonder.com>

The Puppet Instrumentation Framework is a tool to install into a puppet
executable:

* instrumentation listeners
* code probes

Code probes are static commands we add to the Puppet codebase to
instrument some specific parts of the code. Currently only the
Indirector is covered (but since it is the central piece of Puppet, it
should cover a lot of possible use).

Each time the program reaches a code probe (and instrumentation is
enabled), the Instrumentation Framework sends an event to the registered
instrumentation listeners. Those can be enabled/disabled/added/removed
live without restarting the executable.
Those listeners responsibility is to produce something useful to the
user. The patch shipped with 3 example listeners, one that logs
execution time of every probe, another that aggregate some performance
data about probes, and the final one decorates the executable process
name (as seen in top) with the latest probes it encounters.

The Framework also includes a set of REST API and REST Faces to allow it
to enable/disable listeners or probes or to get access to listener
performance data if they produce some.

How to use the Instrumentation Framework:

You need a live running Puppet executable (preferably a puppet master
which by default listens to REST requests). It might also be necessary
to modify the auth.conf to allow the instrumentation requests.

Display the list of known instrumentation listeners
    puppet instrumentation_listener search x --terminus rest

Enable the "performance" instrumentation listener
    puppet instrumentation_listener enable performance --terminus rest

Know more about the "performance" listener (is it enabled for
instance):
    puppet instrumentation_listener find performance --terminus rest

Of course this will only work if probes are enabled:

List all the current executable probes:
     puppet instrumentation_probe search x --terminus rest

Enable the instrumentation probes:
     puppet instrumentation_probe enable --terminus rest

How to get access to the data coming from a listener (here the
"performance" one):
    puppet instrumentation_data find performance --terminus rest

#### Core

#### Improve error msg for missing pip comand
Author: Kelsey Hightower <kelsey@puppetlabs.com>

(#11958) Improve error msg for missing pip command

Without this patch the pip package provider does not produce a user
friendly error message when the pip command is not available. The
current error message looks like this:

        err: /Stage[main]/Dummy/Package[virtualenv]/ensure: change from
        absent to present failed: Could not set 'present on ensure:
        undefined method `pip' for
        #<Puppet::Type::Package::ProviderPip:0xb6cf6cd0> at
        /etc/puppet/modules/dummy/manifests/init.pp:5

This patch improves the error message by passing a string argument, 'Could not locate
the pip command.', when raising the `NoMethodError`. The new error
message looks like this:

        err: /Stage[main]/Dummy/Package[virtualenv]/ensure: change from
        absent to present failed: Could not set 'present on ensure: Could
        not locate the pip command. at
        /etc/puppet/modules/dummy/manifests/init.pp:5

This patch also includes updated spec tests validating this change. No
other behavior changes are being introduced.

### Better validation for IPv4 and IPv6 address in host type.
Author: Daniel Pittman <daniel@puppetlabs.com>

(#11499) Better validation for IPv4 and IPv6 address in host type.

The previous code was fairly lax in validation, and would allow a bunch of
invalid addresses through - as well as rejecting some legal, but uncommon,
IPv6 address types.

This adds substantial testing, especially around IPv6 addressing, and replaces
the older validation with new, fancy stuff that works for all the cases.

###  Support symbolic file modes.
Author: Daniel Pittman <daniel@puppetlabs.com>

 (#2927) Support symbolic file modes.

This adds a new feature, support for symbolic file modes, to Puppet.  In
addition to being able to specify the octal mode, you can now use the same
symbolic mode style that chmod supports:

        file { "/example": mode => "u=rw,go=r" }

This also supports relative file modes:

        file { "/relative": mode = "u+w,go-wx" }

Support is based on the common GNU and BSD symbolic modes of operation; you
specify a comma separated list of actions to take in each you can sit:

The user (u), group (g), other (o), or all (a) of the permission map.

You can modify the ability to read (r), write (w), execute / search (x) on a
 file or directory.

You can also modify the sticky bit (t), or the setuid and setgid bits (s).

Finally, you can set conditional execute permissions (X), which will result in
the file having the execute bit if the target is a directory, or if the target
had *any* execute bit set.  (eg: g+X will set x if the original was u=x,g=.)


### Only load facts once per puppet run

Author: Patrick Carlisle <patrick@puppetlabs.com>

(#8341) Only load facts once per puppet run

Make the facter terminus the only place that loads facts (with the notable
exception of pluginsync which loads any ruby code it syncs).

This should satisfy several requirements:

 * daemonized puppet agent can get fresh facts on each run
 * puppet master can load facts
 * facts are not loaded more than once by the puppet agent fact handler

### Puppetd does not remove its pidfile when it exits
Author: R.I.Pienaar <rip@devco.net>

(#5246) Puppetd does not remove its pidfile when it exits

The Puppet::Daemon instance sets up the pid file when it starts
but it's up to the user of that object to arrange for stop to be
called

There are signal handlers setup to call stop but in a onetime run
those are never called

This change arrange for the stop method to be called after a onetime
run is done but do not hand the task of exiting the application over
to that so that the agent application can handle the report status
based exit codes


### Retry inventory ActiveRecord transaction failure
Author: Carl Caum <carl@carlcaum.com>

Retry inventory ActiveRecord transaction failure

Previous to this commit, if the ActiveRecord transaction for saving
facts failed do to MySQL deadlock, for example, the transaction would
fail printing a message to the user.  This primarily occurred during a
PE agent installation if multiple agent's were being creating
simultaneously.

This commit adds the ability to retry if a
ActiveRecord::StatementInvalid exception is thrown.  To accomplish this,
this commit ports Cloud Provisioner's
Puppet::CloudPack::Utils#retry_action method to Puppet core under
Puppet::Util::RetryAction#retry_action.


### Properly track blockers when generating additional resources
Author: Nick Lewis <nick@puppetlabs.com>

(#11641) Properly track blockers when generating additional resources

Previously, we would enqueue any unblocked resources as we added them to the
graph. These were our initial resources, with no dependencies, and served as a
starting place for traversal. However, we would
add_dynamically_generated_resources before traversing, which could add
additional resources and dependencies. We never accounted for these, causing
our measure of blockedness to become incorrect (a resource could have more
dependencies than we counted).

This is similar to the case of eval_generate adding additional resources. In
that case, we clear the blockers list and allow it to be recalculated on
demand. Unfortunately, that approach doesn't work for the case where we add
resources before traversing (as in add_dynamically_generated_resources),
because we wouldn't have a reliable list of resources to begin traversal with.
Now we no longer enqueue resources when adding them, and instead wait until
after we have called add_dynamically_generated_resources (which happens only
once). This allows us to add our root resources with the assurance they won't
change before we start evaluating them.

### Make the Debian service provider handle services that don't conform to the debain policy manual.
Author: Zach Leslie <zach@puppetlabs.com>

(#7296) Make the Debian service provider handle services that don't conform to the debain policy manual.

This change is to support initscripts that do not support the --query
method of invoke-rc.d used by the Debian provider to determine if
service is enabled.

The fix checks that the link count in /etc/rc?.d is equal to 4, which is
the number of links that should be present when using the Debian service
provider, which is done by `update-rc.d #{service} defaults`.

### Write reports to a temporary file and move them into place
Author: Ricky Zhou <ricky@fedoraproject.org>

(#8119) Write reports to a temporary file and move them into place

When writing reports, there is a window in between opening and writing to the
report file when the report file exists as an empty file. This makes writing
report processors a little annoying as they have to deal with this case. This
writes the report into a temporary file then renames it to the report file.

### Test Augueas versions correctly with versioncmp
Author: Dominic Cleal <dcleal@redhat.com>

(#11414) Test Augeas versions correctly with versioncmp

The release of Augeas 0.10.0 broke simplistic version comparisons with the >=
operator, so now use versioncmp.

### Save/execute changes on versions of Augeas < 0.3.6
Author: Dominic Cleal <dcleal@redhat.com>

(#11414) Save/execute changes on versions of Augeas < 0.3.6

Versions of Augeas prior to 0.3.6 didn't report their version number, so a
fallback of executing changes once in need_to_run? and again in execute_changes
is performed.  Otherwise a save is done in need_to_run? and this is re-used in
execute_changes.

The /augeas/events/saved node is used to tell whether the latter optimisation
happened, but the return value of #match wasn't tested correctly (it's an empty
array).

###   Make Puppet::Type.ensurable? false when exists? is undefined
Author: Ilya Sher <ilya.sher@coding-knight.com>

(#11333) Make Puppet::Type.ensurable? false when exists? is undefined

Puppet::Type.ensurable? incorrectly returned true even when
public_method_defined?(:exists?) was false because the check never
actually happened. This make sure all the necessary methods are checked
and adds tests.

### Consider package epoch version when comparing yum package versions
Author: Jude Nagurney <jude@pwan.org>

(#8062) Consider package epoch version when comparing yum package versions

By including the epoch version in the version returned as the "latest"
available, we can now properly consider package updates where only the
epoch version has changed.

### Log when we start evaluating resource at the info level
Author: Patrick Carlisle <patrick@puppetlabs.com>

(#4865) Log when we start evaluating resources at the info level

Since we log the final time at info it makes sense to log the start at info as
well.

### Fix array support in schedule's range parameters
Author: Sean Millichamp <sean@bruenor.org>

(#10321) Fix array support in schedule's range parameter

Change the schedule type's range parameter to properly evaluate
all elements of a supplied array for validity instead of only
checking the first member of the array. Add documentation to
clarify that range does accept an array.

Fix the associated tests to use must instead of should (Puppet::Type#should
shadows the rspec should).

###    Make resourcefile work with composite namevars
Author: Max Martin <max@puppetlabs.com>

(#10109) Make resourcefile work with composite namevars

The code for creating the resourcefile was directly calling
resource.name_var, which was causing problems with resources that have
composite namevars (since, for these, Type#name_var will return false).
This patch sanitizes the process by first checking whether there is a
single namevar, and simply calling resource.ref if there is not one.


### Add README_DEVELOPER describing UTF-8 in Puppet
Author: Jeff McCune <jeff@puppetlabs.com>

(#11246) Add README_DEVELOPER describing UTF-8 in Puppet

Without this patch, developers of Puppet don't have a clear place to get
a high level understanding of the way other Puppet developers are
working with UTF-8 and the differences in character encodings between
Ruby 1.8 and 1.9.

This patch addresses this problem by adding a new document,
README_DEVELOPER.md where developers and contributors can look to for
high level information.

### Better SSL error message certificate doesn't match key
Author: Joshua Harlan Lifton <lifton@puppetlabs.com>

(#7110) Better SSL error message certificate doesn't match key

Previously, any error with the certificate retrieved from the master
matching the agent's private key would give the same static error
message, which wasn't particularly helpful. This commit differentiates
three different error cases: missing certificate, missing private key,
and certificate doesn't match private key. In the last case, the error
message includes the fingerprint of the certificate in question and
explicit command line instructions on how to fix the problem.

###   Add a defaults argument to create_resources
Author: Matthias Pigulla <mp@webfactory.de>

(#9768) Add a defaults argument to create_resources

Make it possible to supply defaults when calling create_resources using an
optional hash argument.

### Link should autorequire target
Author: Stefan Schulte <stefan.schulte@taunusstein.net>

(#5421) Link should autorequire target

When we manage a local link to a directory and the target directory is
managed by puppet as well, establish an autorequire. So if we have
something like

      file { '/foo': ensure => directory }
      file { '/link_to_foo': ensure => '/foo' }
      file { '/link_to_foo/bar': ensure => file }

we can ensure that puppet does not create dead links and does not try to
create '/link_to_foo/bar' before /foo is created.

###     Use SMF's svcadm -s option to wait for errors
Author: Dominic Cleal <dcleal@redhat.com>

(#10807) Use SMF's svcadm -s option to wait for errors

By default running `svcadm enable example` will start the service in the
background and won't return errors if it fails.  Using the -s option will cause
svcadm to wait and return errors back to the provider if the service cannot
start for some reason.

### Added missing RequestHeader entries to ext/rack/files/apache2.conf
Author: Eli Klein <eklein@rallydev.com>

    Added missing RequestHeader entries to ext/rack/files/apache2.conf

###    Debug logging when we start evaluating resources.
Author: Daniel Pittman <daniel@puppetlabs.com>

(#4865) Debug logging when we start evaluating resources.

The `evaltrace` option allowed individual resource evaluation time to be
tracked, which made it easier to post-hoc identify which resources took long
periods of time to process.

It is also helpful, when doing live debugging, to know where the hang happens;
to support that we now log a debug message about starting the evaluation of
the resource before we go into the process.

###   Update storeconfigclean script to read puppet.conf
Author: Nan Liu <nan@puppetlabs.com>

(#8547) Update storeconfigclean script to read puppet.conf

The existing storeconfig script is parsing and reading puppet.conf
specifically from the master section. This change allows the script to
read from the settings from puppet.conf in the order of master, main,
and loads the rails default. This should match the puppet application
behaviour.

### Add mysql2 gem support
Author: Stefan Schulte <stefan.schulte@taunusstein.net>

(#9997) Add mysql2 gem support

Besides the mysql gem there is a mysql2 gem that is a "modern, simple
and very fast Mysql library for Ruby" [1]. It can either be installed as a
separate gem (v0.2.x) for ActiveRecord < 3.1 or can be used as part of
ActiveRecord 3.1

To use mysql2 the dbadapter setting must be set to "mysql2" and this patch
adds support for this setting.

    [1] https://github.com/brianmario/mysql2#readme


### Mac Highlights
####  Fix OS X Ruby supplementary group handling
Author: Gary Larizza <gary@puppetlabs.com>

(#3419) Fix OS X Ruby supplementary group handling

Catch Errno::EINVAL as some operating systems (OS X in particular) can
cause troubles when using Process#groups= to change the user/process
list of supplementary groups membership.

Test coverage has been added to check for regressions.

Add a test for the expected failure

#### Fix group resource in OS X
Author: Gary Larizza <gary@puppetlabs.com>

(#4855) Fix group resource in OS X

The group provider on OS X uses “dseditgroup” to manage group
membership. Due to Apple bug 8481241 (“dseditgroup can’t remove unknown
users from groups”), however, if the puppet group provider needs to
remove a non-existent user from a group it manages, it will fail.

To remedy this, in the meantime, the provider will call dscl to delete
the non-existent member from the group. If that fails then the error
is rescued and feedback is provided.

#### Build a Rake task for building Apple Packages
Author: Gary Larizza <gary@puppetlabs.com>

Build a Rake task for building Apple Packages

#### Use launchctl load -w in launchd provider
Author: Gary Larizza <gary@puppetlabs.com>

(#2773) Use launchctl load -w in launchd provider

There was an issue where a service on OS X would be enabled but also
stopped and the launchd service provider couldn't start it. In this
case, the launchd service provider needed to execute:

    launchctl load -w JOB_PATH

to successfully start the service, but it wasn't programmed
to do so.

To remedy this, the launchd service provider's start method now checks
if the job is disabled OR if the job is currently stopped.

A spec test was added to catch for this unique situation.

#### Add password get/set behavior for 10.7
Author: Gary Larizza <gary@puppetlabs.com>

(#11293) Add password get/set behavior for 10.7

Puppet did not have the ability to get/set passwords in OS X version
10.7.  This commit implements this behavior. Users in 10.7 have a
binary plist file in /var/db/dslocal/nodes/Default/users that contains
a 'ShadowHashData' key. The value for this key is actually a binary
encrypted plist which contains a 'SALTED-SHA512' key containing
a base64 encoded string. This string is actually the salted-SHA512
password hash with a 4 byte salt prepending the hash. Puppet expects
this 4 byte salt + salted-SHA512 password hash in order to set the
user's password. Since this value is drastically different from
previous versions of OS X, Puppet will fail if you try and pass
a SHA1 password hash that was used in previous versions of OS X.

Spec tests were added to ensure that Puppet fails with an incorrect
password, and that the get/set behavior works properly with OS X
version 10.7.

### Windows Highlights

#### Always serve files in binary mode
Author: Josh Cooper <josh@puppetlabs.com>

(#11929) Always serve files in binary mode

Previously, Windows agents were reading files in text mode when serving
them locally, such as when serving files from a local module, corrupting
binary files in the process.

This commit reads files in binary mode, which is a noop on Unix.

####  Use `%~dp0` to resolve bat file's install directory
Author: Josh Cooper <josh@puppetlabs.com>

(#11714) Use `%~dp0` to resolve bat file's install directory

This commit uses the `%~dp0` batch script modifier to resolve the
drive and path of the directory containing the envpuppet.bat
file. This eliminates the need for hard coded paths within the script
tselfIt also uses `%VAR:\=/%` to substitute each backslash for a
forward slash in the RUBYLIB environment

Also added a section about running the spec tests on Windows.


#### Add envpuppet batch file to run Puppet from source on Windows
Author: Jeff McCune <jeff@puppetlabs.com>

(#11714) Add envpuppet batch file to run Puppet from source on Windows

Running Puppet on windows from source is non-trivial since the
environment variables behave quite differently.  In addition, it's not
clear windows paths expect / rather than \ path separators.

This patch provides an envpuppet batch file to run Puppet from source on
Windows platforms.

####  Don't hard code ruby install paths in Windows batch files
Author: Josh Cooper <josh@puppetlabs.com>

(#11847) Don't hard code ruby install paths in Windows batch files

Previously, the {filebucket,pi,puppet,puppetdoc,ralsh}.bat files hard
coded the path to the ruby installation, making it impossible to move
the ruby install directory.

This commit changes the script to use the `%~dp0` batch file modifier,
which resolves to the drive letter and path of the directory of the
batch file being executed.

Windows XP and later all support the `%*` modifier, so this commit
removes the Win 9x code paths that are not supported.

#### Set password before creating user on Windows
Author: Paul Tinsley <paul.tinsley@gmail.com>

(#11717) Set password before creating user on Windows

Previously, puppet could not create a user with no password when a
local password complexity policy was set. This commit sets the
password on the user prior to creating it, and updates the spec tests
accordingly.

#### Fix fact and plugin sync on Windows
Author: Josh Cooper <josh@puppetlabs.com>

(#11408) Fix fact and plugin sync on Windows

Previously, fact and pluginsync were broken on Windows, because it was
defaulting the owner and group to Process.uid/gid, and then failing to
translate them into Windows SIDs.

This commit changes the default file owner to the current user name,
and the default file group to Nobody, which is the group that Windows
typically applies to newly created files.

####   Don't copy owner and group when sourcing files from master
Author: Josh Cooper <josh@puppetlabs.com>

(#10586) Don't copy owner and group when sourcing files from master

Previously, puppet on Windows was not able to source files from the
master, because it was attempting to translate the uid/gid from
the Unix master into a Windows account, and obviously failing.

This commit skips the owner and group properties when copying them
from non-local sources, i.e. sources whose URIs have a 'puppet'
scheme.

If the source comes from a local source, then puppet behaves the same
as it did previously, it copies the owner and group if the source
volume supports Windows ACLs, e.g. C:/, samba mapped drives, or uses
default values if the volume does not, e.g. VMware shared drives.


### FreeBSD Highlights

#### Add support for user expiriy in pw user provider
Author: Tim Bishop <tim@bishnet.net>

(#11046) Add support for user expiry in pw user provider

Add support for setting an expiry date for a user in the pw user
provider. FreeBSD uses the format DD-MM-YYYY rather than Puppet's
YYYY-MM-DD. Tests added to confirm the value is correctly swapped
around.

Also added custom accessor method to take the unix timestamp given
by the operating system to a Puppet-style YYYY-MM-DD. This stops
Puppet from repeatedly trying to set the expiry date if it's already
correct.

#### Improve pw group provider on FreeBSD
Author: Tim Bishop <tim@bishnet.net>

(#11046) Improve pw group provider on FreeBSD

Make the pw group provider on FreeBSD support managing group members.
Also readd the allowdupe feature since in testing on FreeBSD 7, 8
and 9 the -o flag to pw works as documented.

Add tests for the provider.

#### Make sure managehome is respected on FreeBSD
Author: Tim Bishop <tim@bishnet.net>

(#10962) Make sure managehome is respected on FreeBSD

When modifying the home directory of a user and managehome is set
the -m flag should be used with pw. This ensures that the new home
directory is created if it doesn't exist.

Also add test to verify this behaviour.

#### Add password management on FreeBSD
Author: Tim Bishop <tim@bishnet.net>

(#11318) Add password management on FreeBSD

This adds the manages_passwords feature to the pw user provider. It is based
on the patch by Andrew Hust that was integrated into FreeBSD puppet port. It
adds tests covering the create, delete and modify processes of the provider.

This integrates a fix for #7500 that was introduced by the original patch.
The existing code takes the first character of each property and uses it as a
flag. However, with pw, the -p flag is for setting the password expiration.
The result is that the password isn't set at create time and that the password
is set to expire. The next run of puppet correctly sets the password but the
expiry is still set. The new code avoids using -p for passwords, and also sets
the password correctly when an account is created.

## Puppet 2.7.9

This is a bug fix release for regression (#11306) in 2.7.8 on Ruby 1.8.5.

The 1.8.5-incompatible code wasn’t caught because of a long-standing bug in our tests that went unnoticed because of a bug in our CI setup. The former issue caused specs to fail before they even started running on 1.8.5, and the latter caused the run to still be reported as successful. We’ve fixed the former bug, but haven’t yet figured out a way to fix the latter (as it seems to be a bug in Ruby 1.8.5 + rspec). We will, however, be taking steps to ensure that such problems with our CI setup are more visible and caught sooner.

(#11306)
    Fix Ruby 1.8.5-incompatible code in Transaction#eval_generate

    This was previously creating a Hash from an array of pairs.
    Unfortunately, Ruby 1.8.5 only supports an argument list of pairs rather
    than an array, so this code didn't work with that version.

## Puppet 2.7.8

This is a **feature and bug fix** release in the 2.7.x branch.

### Known Issues

**This release introduced a regression that causes errors under Ruby 1.8.5,** which was not noticed until after release. See issue #11306 for more details as we investigate, and delay upgrading to this version if you depend on Ruby 1.8.5 in your node population.

### New Features

#### Display file diffs through the Puppet log system.

(#2744)

When Puppet generated a diff after changing a file on disk, it previously
printed it directly to stdout; although a user could view it, it
was lost to the rest of the system, and did not appear in monitoring, logs, or reports.

We now send file diffs through our regular logging system, so that they can be viewed in reports and logs. **Note that this may have security implications if reports are being sent to an untrusted destination, as Puppet now exposes partial file contents in reports.**

#### Allow optional trailing comma in argument lists.

(#6335)

You can now put an optional comma at the end of argument lists for parameterized
class definitions and defined types. This makes parameter lists more closely
resemble resource attributes.

### Bug Fixes


#### Provide default subjectAltNames when bootstrapping master

(#10739)

When bootstrapping a new puppet master without explicitly setting its valid alternate DNS names, we've always added some default Subject Alternative Names to its certificate so agents could reach it at `puppet` and `puppet.<domain>`. This got broken in the process of fixing #2848 (the CVE-2011-3872 AltNames vulnerability), which caused new puppet masters to get certificates with no valid Subject Alternative Names. (That is, the master could only be reached at its FQDN, not at `puppet`.)

This fix brings back the default AltNames behavior for initial puppet master certificates, while staying true to the policy changes we made for #2848 and making sure the default names never end up in agent certs. As ever, the default DNS names are only used if the `dns_alt_names` setting isn't explicitly set.

#### Don't automatically enable `show_diff` in noop mode

(#2744)

As of 845825a, file diffs are now logged, rather than printed to
console. Because log messages may be stored and are more broadly readable,
we no longer implicitly set `show_diff` in noop mode.


#### Allow providers to be used in the run they become suitable

(#6907)

At long last! You can now deliver a provider with pluginsync, use a Puppet resource to install executables or files the provider depends on, and use that provider in resources during the same run.

This works for both explicitly selected providers and providers that would be the default for their type.

#### Output four-digit file modes in logging and reporting

(#7274)

When reporting a change to a file's mode, Puppet now outputs the four-digit
file mode instead of omitting the leading 0, i.e. 0755 instead of 755. This
reduces the likelihood of setting the wrong mode on a file through a
copy/paste accident.

#### Fix "parenthesize method arguments" warnings under Ruby 1.8.6

(#10161)

In the process of Windows development, we introduced some warnings under Ruby 1.8.6:

    warning: parenthsize arguments(s) for future versions

These have been fixed, along with several testing/spec improvements around order dependent tests, and testing on Windows.

#### Restore Mongrel XMLRPC functionality

(#10244)

Some code was over-eagerly removed, which turned out to still be necessary for backward compatibility with XMLRPC clients. It has been re-instated in this release.

#### Fix missing facts under Mongrel

(#9109)

When using Puppet with Mongrel, facts were being lost from agent nodes running
2.7.0 or higher. This was caused by Mongrel puppet masters only retrieving
request parameters from the query parameters of the URL, which mixed badly
with clients that submit their facts in a POST request. This has been fixed,
and Mongrel puppet masters can merge the POST request body with the query
parameters.

#### Speed up recursive file management in 2.7

(#9671)

Recursively managing file ownership and permissions
is now at least ten times faster. This
speed improvement can also
be seen in some other scenarios.

#### Windows: Handle files on non-ACL volumes more gracefully

(#10614)

* We now check whether a Windows volume supports ACLs before just trying to get or set them. This eliminates a nasty error that would arise when managing owner, group, and/or mode on a file whose volume didn't support ACLs.
* We also insert default ACL values when sourcing file content from a volume that doesn't support Windows ACLs (e.g. a VMware shared drive) to a volume that does; this allows content to be sourced without requiring the owner, group, and mode to be specified in the manifest. A file's owner now defaults to Administrators, its group defaults to Nobody, and its mode defaults to 0644.
* Setting and clearing of the read-only attribute is improved.
* Potential segfaults when attempting to manage ACLs on non-ACL volumes have been fixed by improving our handling of return values from the Windows APIs.

These fixes do not affect the POSIX file provider.


#### Ruby 1.8.1: Don't rely on Kernel#Pathname

(#10727)

We've removed an unnecessary incompatibility with pre-1.8.5 Rubies in `Puppet::Type::File`, which was caused by using Kernel#Pathname.


#### Allow authenticated clients to access anything clients _without_ certificates can access

(#9508)

Previously, the default `auth.conf` allowed anonymous clients *more* access to the certificate endpoint than authenticated clients. We now allow authenticated clients to access any endpoint that we trust anonymous clients to use. This improves support for distributed certificate management workflows.

#### Serve file content in binary mode

(#9983)

Previously, Puppet::FileServing::Content opened files in text
mode. This has been changed to use binary mode.

## Puppet 2.7.7

2.7.7 was killed in the Thunderdome by 2.7.8. It was never released.

## Puppet 2.7.6

This is a **security, feature, and bug fix** release in the 2.7.x branch.

### Security Fixes

#### CVE-2011-3872 (AltNames vulnerability)

[(Full vulnerability and mitigation details)][cve20113872]

[cve20113872]: http://puppetlabs.com/security/cve/cve-2011-3872/

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

### Features and Enhancements

#### Enhancement: User/group management on Windows

(#9328) Retrieve user and group SIDs on windows.

Puppet can now manage user and group resources on Windows, and will use
Windows security identifiers (SIDs) for the uid and gid properties. (The uid
and gid properties are read-only for the time being.)

#### Enhancement: Better file support on Windows

The file type and providers have been significantly refactored to properly
manage the owners, groups, and permissions of files on Windows.

Some subtleties to be aware of:

* In general, this implementation only supports "typical" permissions,
  where group permissions are a subset of user, and other permissions
  are a subset of group, e.g. 754, but not 467.
* The owner can be either a user or group SID, and most system files
  are owned by the Administrators group.
* The group can be either a user or group SID.
* Unexpected results can occur if the owner and group are the
  same, but the user and group classes are different, e.g. 750. In
  this case, it is not possible to allow write access to the owner,
  but not the group. As a result, the actual permissions set on the
  file would be 770.
* In general, only privileged users can set the owner, group, or
  change the mode for files they do not own. In 2003, the user must
  be a member of the Administrators group. In Vista/2008, the user
  must be running with elevated privileges.
* A file/dir can be deleted by anyone with the DELETE access right
  OR by anyone that has the FILE_DELETE_CHILD access right for the
  parent. See http://support.microsoft.com/kb/238018. But on Unix,
  the user must have write access to the file/dir AND execute access
  to all of the parent path components.
* Many access control entries are inherited from parent directories,
  and it is common for file/dirs to have more than 3 entries,
  e.g. Users, Power Users, Administrators, SYSTEM, etc, which cannot
  be mapped into the 3 class POSIX model. The get_mode method will
  set the S_IEXTRA bit flag indicating that an access control entry
  was found whose SID is neither the owner, group, or other. This
  enables Puppet to detect when file/dirs are out-of-sync,
  especially those that Puppet did not create, but is attempting
  to manage.
* On Unix, the owner and group can be modified without changing the
  mode. But on Windows, an access control entry specifies which SID
  it applies to. As a result, the set_owner and set_group methods
  automatically rebuild the access control list based on the new
  (and different) owner or group.

#### Enhancement: Support plaintext password in Windows

(#9326) Support plaintext passwords in Windows 'user' provider.

The Windows 'user' provider now includes password support, although passwords
must be passed as plaintext instead of as hashes.

### Enhancement: Return reports on ral save

(#9838) Return the transaction report when doing a ral save

When using puppet resource from the command line, using `puppet resource`
to do a save will log error messages to the console when
saving using the ral indirection.  However, this doesn't help when using
that indirection in Ruby like you might from MCollective's puppetral
agent.

So we now return the transaction report you get from applying the
catalog.

The only place we could find this indirection being used was in the
`puppet resource` application, although it's possible that code external
to puppet uses this indirection and will need to change what it expects
for the return value of save.

### Bug Fixes

#### Fix: Recognize more duplicate resources

(#8596) Title and name must be unique within a given resource

Puppet 2.6 introduced a bug where titles were no longer being compared to
names when identifying duplicate resources. For example:

    file { '/tmp/foo':
      ensure => file,
    }

    file { 'same_file':
      path   => '/tmp/foo',
      ensure => absent,
    }

This would work, but wasn't supposed to. It will now register as a duplicate, as intended.

#### Fix: Allow multi-line exec resources

(#9996) Restore functionality for multi-line commands in exec resources


#### Fix: Eliminate warning on groupadd

(#9027) Get rid of spurious info messages in groupadd

Usage of the groupadd provider was leading to spurious log messages of
this form:

    info: /Group[developer]: Provider groupadd does not support features
    manages_aix_lam; not managing attribute ia_load_module

These messages have been eliminated. See also issue #7137, covering
similar issues with the useradd provider.

#### Fix: Remove unnecessary deprecation warning in puppet resource

(#9837) Call puppet apply to avoid deprecation warning

`puppet resource --edit` was causing unnecessary deprecation warnings similar to the following:

    warning: Implicit invocation of 'puppet apply' by passing files (or flags) directly
    to 'puppet' is deprecated, and will be removed in the 2.8 series.  Please
    invoke 'puppet apply' directly in the future.

These have been resolved.

#### Fix: Resolve issues with Windows URIs

Previously, specifying a Windows file URI of the form 'file:///C:/foo'
as a file source failed to strip the leading slash when attempting to
source the file. (Also, there was ambiguity after values were munged, since a
value of the form 'C:/foo' could either be a Windows file path or a
URI whose scheme is 'C'.)

This behavior has been fixed, and Windows file URIs can be used safely.

#### Fix: Expose all functions in templates

(#4549) Fix templates to be able to call all functions

Only a small subset of Puppet functions were available on the scope in
templates.  This had people doing workarounds like:

    inline_template("<%= Puppet::Parser::Functions.autoloader.loadall; scope.function_extlookup(['hello world']) %>")

These workarounds are no longer necessary, and templates can load any available
Puppet function.

#### Fix: Update pluginsync to only load ruby files.

(#4135) Update pluginsync to only load ruby files.

Previously, puppet agent would attempt to load any file distributed via
pluginsync as though it were Ruby code. This was causing errors by loading,
for example, README files.

Pluginsync will still distribute any type of file, but puppet agent will no
longer attempt to load non-Ruby files.

#### Fix: Fix logging on Windows

(#9435) Gracefully handle when syslog feature is unavailable

Previously, Puppet would try to create a syslog log destination when run
without a log destination, which would fail on Windows because the Syslog
module was not available. Behavior when syslog isn't available has been fixed.

#### Fix: Disable daemonizing on Windows

(#9329) Disable agent daemonizing on Windows

For this release, we will not be providing the
code to run puppet agent as a service, though we have verified that
puppet will run as a service using a third-party service wrapper,
nssm.

Until support for running the agent as a service is complete, we have changed
the default `daemonize` setting on Windows. Puppet will also report an error if
`daemonize` is set to true on Windows.


## Puppet 2.7.5

Puppet 2.7.5 is a **security and regression fix** release in the 2.7.x branch.

* See the 2.7.5 [announcement](http://groups.google.com/group/puppet-announce/t/5c363480686372e3) on puppet-announce
* You can also see the general [security notice email](http://groups.google.com/group/puppet-announce/t/91e3b46d2328a1cb)

### Security Fixes

#### Three security vulnerabilities

This release resolves the following security vulnerabilities:

* [CVE-2011-3869 -- k5login can overwrite arbitrary files as root][cve20113869]
* [CVE-2011-3870 -- SSH auth key local privilege escalation][cve20113870]
* [CVE-2011-3871 -- Predictable temporary filename in puppet resource/ralsh][cve20113871]

Follow the links above for details on each vulnerability.

[cve20113871]: http://puppetlabs.com/security/cve/cve-2011-3871/
[cve20113870]: http://puppetlabs.com/security/cve/cve-2011-3870/
[cve20113869]: http://puppetlabs.com/security/cve/cve-2011-3869/

### Bug Fixes

#### Fix: storeconfigs regression from 2.7.4

(#9832) General StoreConfigs regression.

Some StoreConfigs exported and imported resources were not being
found under PostgreSQL. This fix resolves the regression.


## Puppet 2.7.4

Puppet 2.7.4 is security and feature release in the 2.7.x branch.  Due to the security patches included, it is recommended anybody using the 2.7.x series update to 2.7.4.

In addition to the security patch, this release adds functional Windows providers for several types, and makes changes to the storeconfigs indirection.

### Security Fixes

#### CVE-2011-3848 (directory traversal attacks through indirections)

[cve20113848]: http://puppetlabs.com/security/cve/cve-2011-3848/

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

### Fixes and Enhancements

#### Allow cron vars to have leading whitespace

Fix #9440

Patch applied from Jeremy Thornhill. This allows whitespace to appear before
cron variables. Previously, whitespace before cron variables would trigger a
parse failure, and the crontab, except for the puppet managed portion, would
get removed. This addresses that issue. It also includes a test for this issue,
added into the tests directory, which seems to be where the crontab tests live.

#### Write out a list of resources that are managed by puppet agent

Feature #8667

Similar to how the Puppet classes are written out each catalog apply,
the list of resources is now being written out to a text file that can
be easily used by tools like MCollective.  This allows tools that do
ad-hoc management of resources to know if they're changing a resource
that puppet manages, and adjust behavior accordingly.

#### Fix value validation on options

Fix #7114

Support single options that legally include a comma like
"from=host1,host2". We now basically allow either "word" or "key=value"
as options. That's also what the parsedfile provider currently supports
when parsing options.

#### GigabitEthernet/TenGigabitEthernet are uncorrectly parsed

Fix #7984

The interface name abbreviation to canonical name doesn't return
the correct name for GigabitEthernet and doesn't support TenGigabitEthernet
interfaces.

#### Allow macauthorization provider to work on OS X Lion 10.7

Fix #9143

We've flipped around the confine check so we explicitly exclude the
versions of OS X where this provider won't work, rather than working
from a whitelist.


#### Move complex collect expression error into terminus.

Fix #9051

When the StoreConfig system was extracted from core to a set of termini, most
of the rules about permitted syntax were pushed down into the same place, to
allow them to also be replaced.

One set of restrictions were missed, the limitation that complex search
criteria (like and, or, or parenthetical expressions) were not permitted, and
remained in our parser.

Now, they live in the terminus, and we enforce them only there.  This ensures
that StoreConfigs can be replaced with a back-end that supports complex
collection criteria without other changes to the Puppet core.

#### Don't rely on error message to detect UAC capable platform

Fix #8662

The call to Win32::Security.elevated_privileges? can raise an
exception when running on a pre-Vista computer or if the process fails
to open its process token.

Previously, we were looking at the exception message to determine
which case it was. However, Windows 2003 and 2003 R2 return different
error codes (and therefore messages) for the pre-Vista case. In 2003,
it returns error code 1 (Incorrect function), but in 2003 R2 it
returns 87 (The parameter is incorrect). Since SUIDManager was only
looking for Incorrect function, SUIDManager.root? would always return
false on 2003 R2.

Ideally, we could just check if the GetTokenInformation Win32 API was
available, and only call it on platforms where it makes sense. But
this API is available on all recent version of Windows. What's new in
Vista and up is the TokenElevation value of the
`TOKEN_INFORMATION_CLASS` enumeration.

This commit changes the suidmanager to only call GetTokenInformation
when the major kernel version, as reported by facter, is 6.0 or
greater, which corresponds to Vista/2008. See:

<http://msdn.microsoft.com/en-us/library/ms724833(v=vs.85).aspx>

#### Add MSI package provider for use with Windows

Feature #8412

This provider takes some of its inspiration from the appdmg provider
used with OS X.  It will maintain a list of packages that have been
installed and removed from the system via the provider in a directory
under Puppet's vardir called db/package/msi.  These state files will
be named the same as the resource name with '.yml' appended.  The
state files will be a hash containing the resource name, the install
options used, and the source location of the MSI.

Any properties that a user wishes to provide to the MSI can be
specified as key/value pairs in the install_options parameter.  For
example:

    package { 'mysql':
      provider => msi,
      source => 'E:\mysql.msi',
      ensure => installed,
      install_options => { 'INSTALLDIR' => 'C:\mysql' },
    }

The MSI properties specified by install_options will be appropriately
quoted when invoking msiexec.exe to install the MSI.

Because the source parameter is integral to the functionality of being
able to install and uninstall MSI packages, we also override
validate_source to make sure that the source parameter is always set,
and is not an empty string when using this provider.

#### Add a Windows exec provider

Feature #8140

This provider inherits from the `Puppet::Provider::Exec` class, and is
very similar to the posix provider in its behavior. This provider
doesn't have the ability to run as a particular user or group and will
fail if that is attempted, but does support setting all other
parameters, as well as autorequires.

Rather than the shell provider inheriting from the posix provider, they
both now inherit from a common `Puppet::Provider::Exec` class. This new
base class and inheritance structure will allow the forthcoming windows
provider to also inherit from that class, rather than from the
unsuitable posix provider.

Also, now that Puppet::Util.execute supports commands as strings in
addition to arrays, the command to execute is passed to
`Puppet::Util::SUIDManager.run_and_capture` as a string, rather than a
string wrapped in an array. This ensures we will never improperly quote
a command with arguments provided as a single string.

#### Default config dir to %PROGRAMDATA% on Windows

Fix #8660

The puppet install.rb script now defaults the config directory to
%PROGRAMDATA%\PuppetLabs\puppet\etc on Windows. This is more inline
with Windows best-practices, as this directory is used to store
application data across all users. The PROGRAMDATA environment
variable also takes into account alternate system drives, by using the
SYSTEMDRIVE environment variable.

Note that the `Dir::COMMON_APPDATA` constant is so named because it
corresponds to the `CSIDL_COMMON_APPDATA` constant, which on 2000, XP,
and 2003 is `%ALLUSERSPROFILE%\Application Data`, and on Vista, Win7 and
2008 is `%SYSTEMDRIVE%\ProgramData`.

This commit also updates puppet's default run_mode var and conf
directories when running as "root" to match the install script, and
fixes the spec test, which was looking in the `Dir::WINDOWS` directory.




## Puppet 2.7.3

2.7.3 is a maintenance and enhancement release in the 2.7.x branch.

### Add Node Clean action

Fix #1886 - Add node cleanup capability

This adds a new "clean" action to the puppet node face, which removes all traces of a node on the puppetmaster
(including certs, cached facts and nodes, reports, and storedconfig
entries).

Furthermore, it is capable of unexporting exported resources of a
host so that consumers of these resources can remove the exported
resources and we will safely remove the node from our
infrastructure.

Usage:

    puppet node clean [--unexport] <host> [<host2> ...]

To achieve this we add different destroy methods to the different
parts of the indirector. So for example for yaml indirections we
already offer read access for the yaml, this changeset adds
the destroy handler which only removes the yaml file for
a request. This can be used to remove cached entries.

### Deprecate RestAuthConfig#allowed? in favor of #check_authorization

 \#allowed? was a poorly named method since it isn't actually a predicate
method. Instead of returning a boolean, this methods throws an
exception when the access is denied (in order to keep the full context
of what ACE triggered the deny).

Given that #allowed? was overriding the behavior from AuthConfig, we
leave a version of #allowed? in place that will issue a deprecation
warning before delegating to #check_authorization.  Once support for
XML-RPC agents is removed from the master, we will be able to remove
this delegation, since there should no longer be a reason for a
distinction between AuthConfig and RestAuthConfig.


### #6026 - security file should support inline comments

Auth.conf, namespaceauth.conf and fileserver.conf were not supporting
trailing inlined comments.
Also this commit fixes some indentation and error management.


### Suggest where to start troubleshooting SSL error message

Much like the infamous "hostname was not match" error message, there is
another SSL error that people run into that is not clear how to
troubleshoot.

    err: Could not send report: SSL_connect returned=1 errno=0
    state=SSLv3 read server certificate B: certificate verify failed.

As far as I can tell this only ever happens when the clock is off on the
master or client.  People seem to think it will happen other times, but
I have not been able to reproduce it other ways - missing private key,
revoked cert, offline CA all have their own errors.  I googled around
and the only thing I've seen for this error in relation to puppet is the
time sync problem.

So the error message text just has some additional info to suggest you
check your clocks.


### #8596 Detect resource alias conflicts when titles do not match

The introduction of composite namevars caused the resource title used in
resource aliases to be set as an array, even when the resource only had one
namevar. This would fail to conflict with non-alias entries in the resource
table, which used a string for the title, even though the single element array
contained the same string.

Now, we flatten the key used in the resource table, so that single element
arrays are represented as strings, and will properly conflict with resource
titles.


### maint: Adding logging to include environment when source fails

### maint: Add debug logging when the master receives a report

It's always bothered me that when running puppet inspect (or any
application that produces a report really) the master gives no
indication that anything happened when it processes the report.

### #6789 Port SSL::CertificateAuthority::Interface to a Face

The Puppet::SSL::CertificateAuthority::Interface class was an early prototype
heading toward building out a system like Faces.  Now that we have done that,
this changeset ports the early code to a new face.

### #8401 Document that --detailed-exitcodes is a bitmask

The agent/apply/device man pages mentioned the 2 and 4 exit codes, but didn't
mention that they can combine to make 6 if there are both changes and failures.
This commit adds the missing information to all three man pages.

### #4142 Fix module check not to fail when empty metadata.json

Even though the puppet module tool was fixed to generate the required
metadata attributes when it packages modules, it still creates an empty
metadata.json file that gets checked into everybody's module repos.
This causes the module to be unusable straight from a git clone since
puppet was requiring all the required metadata attributes just with the
presence of that file, and resulting in the error:

    No source module metadata provided for mcollective at

This change makes it so that if you have an empty metadata.json (like
the moduletool generates), puppet doesn't consider it to have metadata.
If you have ANY metadata attributes in that file, it will still check to
make sure all the required attributes are present.

The work around up to this point has just been to delete the
metadata.json file in git cloned modules.

This also fixed the tests around this to actually run, since previously
the tests depended on the a json feature, which we didn't have.  We do,
however, have a pson feature.

### #8147 Change default reporturl to match newer Dashboard versions

Puppet's default reporturl setting was http://localhost:3000/reports, which has
been deprecated in Puppet Dashboard in favor of
http://localhost:3000/reports/upload. As Dashboard is the first-class
destination for the http report processor, this commit changes Puppet's default
to match what current versions of Dashboard expect.

### #6857 Password disclosure when changing a user's password

Make the should_to_s and is_to_s functions to return a form of 'redacted'.

Rather than send the password hash to system logs in cases of failure or
running in --noop mode, just state whether it's the new or old hash. We're
already doing this with password changes that work, so this just brings it
inline with those, albeit via a slightly different pair of methods.

### Additional Notes

* Several odd behaviors seen in 2.7.2rc2 should now meet expectations.
* 8ec0804 #8301 Red Hat spec file for 2.7.2rc1 won't work
* 2263be6 #5108 Update service type docs for new hasstatus default

This merges up all changes in the 2.6.9 release that were unable to be merged into 2.7.{0,1} due to 2.7 being frozen in release candidate state.

Highlights include:

* 99330fa (#7224) Reword 'hostname was not match' error message
* 1d867b0 (#7224) Add a helper to Puppet::SSL::Certificate to retrieve alternate names
* db1a392 (#7506) Organize READMEs; specify supported Ruby versions in README.md
* 98ba407 (#7127) Stop puppet if a prerun command fails
* caca469 (#4416) Ensure types are providified after reloading
* 413b136 (#4416) Always remove old provider before recreating it
* 98f58ce (#2128) Add WARNING for node_name_{fact,value} descriptions
* 3f0dbb5 (#650) Allow symlinks for configuration directories
* 1c70f0c (#2128) Add support for setting node name based on a fact
* c629958 (#2128) Get facts before retrieving catalog
* 8eb0e16 (#2728) Add diff output for changes made by Augeas provider
* c02126d (#5966) Add support for hostname regular expressions in auth.conf
* 75e2764 (#5318) Always notice changes to manifests when compiling.
* 0bcbca5 maint: Dedup the loadpath so we don't have to walk it multiple times
* 89d447b (#6962) Add "arguments" method to help API
* 8eea3f5 Added the vcsrepo type and providers to the core
* 107b38a maint: Fix pacman provider to work with Ruby 1.9
* 0b8ebac (#7300) Fix instances method of mount provider

## Puppet 2.7.2

2.7.2 was slain in the Thunderdome by 2.7.3.

## Puppet 2.7.1

2.7.1 is a bug fix release in the 2.7.x branch.

Fixing bug #8048.  This made users of Puppet as a gem unable to install Puppet 2.7.0 release if gem was configured to use rdoc, as rdoc failed to parse on one file.

This issue only impacted users of Puppet as a gem.

## Puppet 2.7.0


2.7.0 is a new feature release of Puppet.

Notable Features and Bug Fixes
------------------------------

### Apache License

Puppet is now released under the Apache 2.0 license.

#### Why was this decision made?

The Apache license will make it easier for third-parties to add
capabilities to the Puppet platform and ecosystem. Over time, this
will mean a wider array of solutions that will more perfectly fit
the needs of any given team or infrastructure.

We put a lot of thought into this decision. We recognize that parts
of the Puppet community would prefer we stay on a GPLv2 license,
but we feel this migration is to the benefit of the community as a
whole.

#### What happens if I am on Puppet 2.6x or earlier?

Nothing changes for you.  Puppet 2.6.x remains licensed as GPLv2.
The license change is not retroactive.

#### Does this change affect all the components of Puppet?

As part of this change, we’re also changing the license of the
Facter system inventory tool to Apache.  This change will take
effect with Facter version 1.6.0, and earlier versions of Facter
will remain licensed under the GPLv2 license.  This change will
bring the licensing of Puppet’s two key components into alignment.

Our other major product, MCollective, is already licensed under
the Apache 2.0 license.

#### What does this mean if I or my company have or want to contribute code to Puppet?

As part of this license change, Puppet Labs has approached every
existing contributor to the project and asked them to sign a
[Contributor License Agreement or CLA](https://cla.puppetlabs.com/).

Signing this CLA for yourself or your company provides both you and
Puppet Labs with additional legal protections, and confirms:

1.  That you own and are entitled to the code you are contributing
    to Puppet
2.  That you are willing to have it used in distributions

This gives assurance that the origins and ownership of the code
cannot be disputed in the event of any legal challenge.

#### What if I haven’t signed a CLA?

If you haven’t signed a CLA, then we can’t yet accept your code
contribution into Puppet or Facter.  Signing a CLA is very easy:
simply log into your [GitHub](https://github.com) account
and [go to our CLA page to sign the agreement](https://cla.puppetlabs.com/).

We’ve worked hard to try find to everyone who has contributed code
to Puppet, but if you have questions or concerns about a previous
contribution you’ve made to Puppet and you don’t believed you’ve
signed a CLA, please sign a CLA or
[contact us](mailto:info@puppetlabs.com) for further information.

#### Does signing a CLA change who owns Puppet?

The change in license and the requirement for a CLA doesn’t change
who owns the code.  This is a pure license agreement and NOT a
Copyright assignment.  If you sign a CLA, you maintain full
copyright to your own code and are merely providing a license to
Puppet Labs to use your code.

All other code remains the copyright of Puppet Labs.

### Ruby 1.9 Support

There are some known issues with the 2.7.0 release, but we now support Ruby 1.9.2 and higher, and will be aggressively fixing bugs under Ruby 1.9.

### Deterministic Catalog Application

Previously, Puppet didn't guarantee that it would apply unrelated resources in any particular order. This meant that if you forgot to specify some important `before` or `require` relationship, a single catalog might work fine on eight nodes and then fail mysteriously on the ninth and tenth. This could be frustrating! Now it's gone: Puppet will make sure that the same catalog will always be applied in the same order on every machine, and it'll either succeed reliably or fail reliably. (This change will also be appearing in the final 2.6.x releases.)

(See issue #6911.)

### Manage Network Devices

Based on an open-space discussion that happened at PuppetCamp EU in May, 2010, Brice Figureau has implemented the start of a network management solution.

Currently this initial solution has a base network type/provider and providers for managing Cisco interfaces and vlans. The puppet provider connects to remote switches and routers through either ssh or telnet.

To manage an interface:

    interface { "FastEthernet 0/1":
      device_url          => "ssh://user:pass@cisco2960.domain.com/",
      mode                => trunk,
      encapsulation       => dot1q,
      trunk_allowed_vlans => "1-99,200,253",
      description         => "to back bone router"
    }

or

    interface { "Vlan 1":
      device_url  => "ssh://user:pass@router.domain.com/",
      description => "internal net",
      ipaddress   => [ "192.168.0.1/24", "fe08::/128 link-local"]
    }

And to manage vlans:

    vlan { "99":
	  description => "management",
      device_url  => "ssh://user:pass@cisco2960.domain.com/",
    }

A current limitation is that it isn't possible to have 2 switches with the same interface name.

### Dependency cycle reporting

We have significantly improved dependency cycle reporting so that the cycle is clearly identifiable, and will produce graphs of such cycles for easier debugging.  Error messages will now appear as follows:

    Found 2 dependency cycles: (Notify[a] => Notify[b] => Notify[a]) (Notify[mp2-2] => Notify[mp2] => Notify[mp2-2])

### Man Pages

We've spiffed up our man pages. Static man files are in the `man/` directory of the source, and should be installed for you if you installed Puppet with your OS's packaging system. We've also introduced a `puppet man` subcommand that can render man pages on the fly using [ronn](https://github.com/rtomayko/ronn/). (We recommend running `gem install ronn` before using it; if it isn't installed, puppet man will just print a human-readable version of the man page source text.)

### Deprecations

We're starting the hourglass on a few older features:

* **'puppet' as a synonym for 'puppet apply'** --- Starting today, running `puppet my-manifest.pp` will issue a warning; you should start using `puppet apply` directly instead. Support for implicit invocation of puppet apply will be dropped in Puppet 2.8.
* **Dynamic scope** --- We've started issuing warnings when variables or resource defaults are found via dynamic lookup. [There's more info and explanation here](./scope_and_puppet.html), but the short version is that you should start referencing variables with their qualified names instead of counting on dynamic scope. We hope to drop support for dynamic scope in Puppet 2.8. (Issue #5027)
* **No more `--parseonly` option** --- This one's already gone, because we used Faces to build a drop-in replacement: use `puppet parser validate [<manifest>] [<manifest> ...]` instead.

### Notice Changed Manifests on the First Try

During the 2.6.x series, puppet agent would sometimes require two runs to receive new configurations when puppet master was running under Passenger. This persistent bug has been dealt with. (This change will also be appearing in the final 2.6.x releases.)

### Static Compiler

We've introduced `static_compiler`, a new `catalog_terminus` which can be configured in puppet.conf on your puppet master. (See issue #6873.) The static compiler works by wrapping the default compiler terminus and replacing every `puppet:///` URL in the catalog it returns with an MD5 reference to a filebucket object; this saves a lot of describe calls while the agent is running, and it ensures that the agent won't grab inconsistent file versions if one of the source files changes while it's running.

There are some known issues that keep it from being used as-is, yet --- you have to manually sync the agent's filebucket to that of the master, the compiler's behavior around recursion hasn't been rigorously tested, we haven't specified how it should behave if your puppet master is serving files through a load balancer, and files are read into memory rather than being streamed. However, this new approach has the potential to drastically speed up file-heavy Puppet runs, and if your site serves a lot of files and you have some lab time to test it, it could be worth a look.

### Improved APIs

You can now [manage and sign certificates via Puppet's REST API](/guides/rest_api.html#certificate-status), which means that in the near future you'll be able to check off signing requests for new nodes right from Puppet Dashboard. (And someone can now easily write an iPhone or Android app to fetch and handle CSRs, hint hint. :) )

### Services Are Assumed to Have Status Commands

Per issue #5108, the service type's `hasstatus` attribute now defaults to true, which means init scripts are expected to have working status commands. **This is a potentially incompatible change.** If you use an OS where broken status commands are still the norm, you may need to add the following resource default to your `site.pp` manifest:

    Service {
      hasstatus => false,
    }

This will effectively restore the old behavior.

### Default ACL improvements

We have adjusted the default ACL in the puppet master to allow a node to query configuration information about itself from the internal or external node classifier.

### pkgutil Provider

`pkgutil` provider support has been significantly improved, resolving issue #4258.


### Puppet Faces

Faces is a new API for creating new Puppet subcommands. Faces dramatically simplifies the process of extending Puppet by building new capabilities, including additional nouns and verbs that can be called by issuing commands from your command line interface.

We're particularly excited about Faces and the opportunities it offers for our user base.
You can see how easy it is to create a subcommand and action with our [new manifest validator](https://github.com/puppetlabs/puppet/blob/master/lib/puppet/face/parser.rb)

This provides a new subcommand and a single action as follows:

`puppet parser validate <mymanifest.pp>`

It's also easy to create new actions for existing subcommands, which is a great way to extend the Puppet model, and it's also become significantly easier to access Puppet subsystems as shown by the [configurer subcommand](https://github.com/puppetlabs/puppet/blob/master/lib/puppet/face/configurer.rb):

This shows how easy it is to access these subcommands and actions in Ruby code:

      facts = Puppet::Face[:facts, '0.0.1'].find(certname)
      catalog = Puppet::Face[:catalog, '0.0.1'].download(certname, facts)
      report = Puppet::Face[:catalog, '0.0.1'].apply(catalog)

That small amount of code offers this on the command line:

    $ puppet configurer synchronize

which accomplishes basically the same functionality as 'puppet agent --test', but is much simpler to rearrange and modify for your own needs.

We look forward to seeing what the community comes up with now that it is so easy to interact with and extend the underlying model.


To get a look at the new subcommands, start by running `puppet help`. To see the API in action, look at the source for the [secret_agent](https://github.com/puppetlabs/puppet/blob/2.7.x/lib/puppet/face/secret_agent.rb) and [parser](https://github.com/puppetlabs/puppet/blob/2.7.x/lib/puppet/face/parser.rb) faces.

### Certificate API

Read or alter the status of a certificate or pending certificate request. This endpoint is roughly equivalent to the puppet cert command; rather than returning complete certificates, signing requests, or revocation lists, this endpoint returns information about the various certificates (and potential and former certificates) known to the CA.

    GET /{environment}/certificate_status/{certname}

Retrieve a PSON hash containing information about the specified host’s certificate. Similar to puppet cert --list {certname}.

    GET /{environment}/certificate_statuses/no_key

Retrieve a list of PSON hashes containing information about all known certificates. Similar to puppet cert --list --all.

    PUT /{environment}/certificate_status/{certname}

Change the status of the specified host’s certificate. The desired state is sent in the body of the PUT request as a one-item PSON hash; the two allowed complete hashes are {"desired_state":"signed"} (for signing a certificate signing request; similar to puppet cert --sign) and {"desired_state":"revoked"} (for revoking a certificate; similar to puppet cert --revoke); see examples below for details.

When revoking certificates, you may wish to use a DELETE request instead, which will also clean up other info about the host.

    DELETE /{environment}/certificate_status/{hostname}

Cause the certificate authority to discard all information regarding a host (including any certificates, certificate requests, and keys), and revoke the certificate if one is present. Similar to puppet cert --clean.

Examples include:

    curl -k -H "Accept: pson" https://puppetmaster:8140/production/certificate_status/testnode.localdomain
    curl -k -H "Accept: pson" https://puppetmaster:8140/production/certificate_statuses/all
    curl -k -X PUT -H "Content-Type: text/pson" --data '{"desired_state":"signed"}' https://puppetmaster:8140/production/certificate_status/client.network.address
    curl -k -X PUT -H "Content-Type: text/pson" --data '{"desired_state":"revoked"}' https://puppetmaster:8140/production/certificate_status/client.network.address
    curl -k -X DELETE -H "Accept: pson" https://puppetmaster:8140/production/certificate_status/client.network.address

[CVE-2013-2275]: http://puppetlabs.com/security/cve/cve-2013-2275
[CVE-2013-1655]: http://puppetlabs.com/security/cve/cve-2013-1655
[CVE-2013-1654]: http://puppetlabs.com/security/cve/cve-2013-1654
[CVE-2013-1653]: http://puppetlabs.com/security/cve/cve-2013-1653
[CVE-2013-1652]: http://puppetlabs.com/security/cve/cve-2013-1652
[CVE-2013-1640]: http://puppetlabs.com/security/cve/cve-2013-1640
