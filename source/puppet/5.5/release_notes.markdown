---
layout: default
toc_levels: 1234
title: "Puppet 5.5 Release Notes"
---

This page lists the changes in Puppet 5.5 and its patch releases. You can also view [known issues](known_issues.html) in this release.

Puppet's version numbers use the format X.Y.Z, where:

-   X must increase for major backward-incompatible changes
-   Y can increase for backward-compatible new functionality or significant bug fixes
-   Z can increase for bug fixes

## If you're upgrading from Puppet 4.x

Read the [Puppet 5.0.0 release notes](https://github.com/puppetlabs/docs-archive/blob/master/puppet/5.0/release_notes.markdown), because they cover breaking changes since Puppet 4.10.

Read the [Puppet 5.1](https://github.com/puppetlabs/docs-archive/blob/master/puppet/5.1/release_notes.markdown), [Puppet 5.2](https://github.com/puppetlabs/docs-archive/blob/master/puppet/5.2/release_notes.markdown), [Puppet 5.3](https://github.com/puppetlabs/docs-archive/blob/master/puppet/5.3/release_notes.markdown), and [Puppet 5.4](https://github.com/puppetlabs/docs-archive/blob/master/puppet/5.4/release_notes.markdown) release notes, because they cover important new features and changes since Puppet 5.0.

Also of interest: the [Puppet 4.10 release notes](../4.10/release_notes.html) and [Puppet 4.9 release notes](https://github.com/puppetlabs/docs-archive/blob/master/puppet/4.9/release_notes.markdown).

## Puppet 5.5.19

Released 10 March 2020

### New features

- When managing a user or group resource with a forcelocal set, Puppet reads `/etc/passwd` or `/etc/group` for each parameter of the resource. Files are read once per managed resource. [PUP-10117](https://tickets.puppetlabs.com/browse/PUP-10117)

- Previously, when `puppetserver` returned a 429 or 503 to an agent after the agent tried to make an HTTP request, the agent would keep the HTTP connection open during the sleep. Now the connection closes before the sleep, and retries the connection after, to reduce the resource load on the `puppetserver`. [PUP-10227](https://tickets.puppetlabs.com/browse/PUP-10227)

- The `flavor` package parameter has been changed into a property and can now be changed after it's initially set. Supported providers are `dnfmodule` and `openbsd`. [PUP-10171](https://tickets.puppetlabs.com/browse/PUP-10171)

- If a `/opt/puppetlabs/server/pe_version` file exists on an agent, the file will be read and added to the server facts under the name `pe_serverversion`. [PUP-9750](https://tickets.puppetlabs.com/browse/PUP-9750)

- Puppet Agent now ships FFI on AIX packages. [PA-3061](https://tickets.puppetlabs.com/browse/PA-3061)

- The RedHat 7 FIPS package now ships OpenSSL 1.1.1, instead of relying on the version provided by the operating system. [PA-3027](https://tickets.puppetlabs.com/browse/PA-3027)

- FIPS mode is now enforced on OpenSSL, vendored in Windows FIPS platform. [PA-3025](https://tickets.puppetlabs.com/browse/PA-3025)

- The installer package for the Windows Puppet agent has a new installation option. [PA-2253](https://tickets.puppetlabs.com/browse/PA-2253)

- This release of the `puppet-agent` package removes support for macOS 10.12, macOS 10.13 and Fedora 28. [PUP-10244](https://tickets.puppetlabs.com/browse/PUP-10244), [PUP-10245](https://tickets.puppetlabs.com/browse/PUP-10245), [PUP-10242](https://tickets.puppetlabs.com/browse/PUP-10242). 

### Resolved issues

- This release fixes [CVE-2020-7942](https://puppet.com/security/cve/CVE-2020-7942/) by defaulting to `strict_hostname_checking=true`. To return to the previous behavior, set the Puppet setting to false. [PUP-10238](https://tickets.puppetlabs.com/browse/PUP-10238).

- This release updates OpenSSL to 1.0.2u, as a result of [CVE-2019-1551](https://www.openssl.org/news/vulnerabilities.html#2019-1551). [PA-306](https://tickets.puppetlabs.com/browse/PA-3062)

- Due to Apple changing user management in macOS 10.15, Puppet could no longer manage user passwords on that version. Puppet now uses the `dsimport` utility to manage passwords on macOS 10.15 or higher. [PUP-10246](https://tickets.puppetlabs.com/browse/PUP-10246)

- This release fixes an issue where Puppet would try to parse an XML property list file as ASCII instead of UTF-8. [PUP-10241](https://tickets.puppetlabs.com/browse/PUP-10241)

- This commit adds the missing `ppAuthCertExt` oid and updates docs to reference it. [PUP-10234](https://tickets.puppetlabs.com/browse/PUP-10234)

- The Yum package provider now accepts an array of strings to be specified for the `install_options` parameter, in addition to the previous implementation which only accepted an array of hashes. This fix was provided by community contributor Corey Osman. [PUP-10177](https://tickets.puppetlabs.com/browse/PUP-10177)

- The Puppet language supports calling functions using prefix or chained syntax, for example, `each($var)` and `$var.each`. Using the latter syntax is now much faster, especially when `$var` is a large hash, such as `$facts` from the node. [PUP-10113](https://tickets.puppetlabs.com/browse/PUP-10113)

- This release fixes an issue with large environment blocks on Windows, which caused a Ruby error.. [PA-3113](https://tickets.puppetlabs.com/browse/PA-3113).

- This release adds the `mark` property with Debian and Solaris instead of setting the ensure attribute to held. The `held` value for `ensure` is deprecated. Allowed values for `mark` are `hold` or `none`, and it defaults to `none`. You can specify `mark` along with ensure. If ensure is missing, `mark` defaults to `present`. You cannot use the `mark` property together with `purged`, `absent`, or `held` values for `ensure`. [PUP-1537](https://tickets.puppetlabs.com/browse/PUP-1537).

- To avoid the Puppet changing the `mailalias` resource, do not use comma in the `mailalias` record field separator when surrounded by double quotes. [PUP-10287](https://tickets.puppetlabs.com/browse/PUP-10287)

## Puppet 5.5.18

Released 14 January 2020

### New features

- Puppet now supports managing DNF modules, which are groups of packages that represent
    an application, a language runtime, or any logical group. 
    
    Modules can be available in multiple streams, usually representing a major version of
    the software they include. Profiles are package subsets representing a specific use
    case of the module (these are handled by the flavor parameter of the package
    type).
    
    Due to the significant difference between a package and a module,
    `dnfmodule` is an opt-in provider and should be explicitly
    specified in the manifest. [PUP-9978](https://tickets.puppetlabs.com/browse/PUP-9978)

- This release removes a dependency on .bat files when running Puppet as a service on
    Windows. [PUP-9940](https://tickets.puppetlabs.com/browse/PUP-9940)

- This release introduces a new setting, `puppet_trace`, which prints the Puppet stack without the Ruby frames interleaved. If the `trace` setting is enabled, it overrides the value of `puppet_trace`. [PUP-10150](https://tickets.puppetlabs.com/browse/PUP-10150)

- Resubmit facts after an agent's run.
    
    Puppet submits facts when requesting a catalog, but if
    the agent modifies the system while applying the catalog, then the facts in PuppetDB won't be refreshed until the agent runs
    again, which may be 30 minutes (or however `runinterval` is
    configured). This feature makes it possible to submit facts again at the end of the
    agent's run, after the catalog has been applied. To enable this feature, set
    `resubmit_facts=true` in the agent's
    `puppet.conf`. Resubmitting facts doubles the fact submission load on
    PuppetDB, since each agent submits facts
    twice per run. This feature is disabled by default. [PUP-5934](https://tickets.puppetlabs.com/browse/PUP-5934)

### Resolved issues

- This version of the `puppet-agent` package upgrades OpenSSL to version 1.1.1d. [PA-3029](https://tickets.puppetlabs.com/browse/PA-3029)

- This release includes improvements to the evaluator, meaning some compilation warnings now take less time to compute. [PUP-10213](https://tickets.puppetlabs.com/browse/PUP-10213)

- The HP-UX provider forced command line arguments to `usermod` to be in a specific order. This is now fixed. [PUP-9391](https://tickets.puppetlabs.com/browse/PUP-9391)

- This release fixes a bug where stacktraces from errors no longer had the Ruby stack frames interleaved with the Puppet stack frames when using `trace`. [PUP-10150](https://tickets.puppetlabs.com/browse/PUP-10150)

- Performance of manifests that use the `PuppetStack.top_of_stack` function have been greatly improved. This includes manifests that use the puppetlabs-stdlib `deprecation` function or the pseudo keywords `break`, `return`, and `next`. [PUP-10170](https://tickets.puppetlabs.com/browse/PUP-10170)

- Previously, Puppet agents might fail to apply a catalog if the agent switched environments based on node classification and those environments contained different versions of a module. With this fix, an agent converges to its server-assigned environment more quickly, loads types and providers only once, and updates its cached catalog only after the environment converges. [PUP-10160](https://tickets.puppetlabs.com/browse/PUP-10160)

- Puppet agent packages for Debian and Ubuntu now include Ruby SELinux libraries. [PA-2985](https://tickets.puppetlabs.com/browse/PA-2985)

- Puppet no longer checks for domain users or groups when managing local resources on Windows. This fixes a local user management issue where an Active Directory account existed with the same name as the local user. [PUP-10057](https://tickets.puppetlabs.com/browse/PUP-10057)

- Previously, when Puppet encountered a connection error, it created a new 
    exception with additional contextual information around what was causing the error.
    However, this new exception could cause an additional "Wrong number of arguments"
    error. Puppet now raises the original error and logs it with any additional
    contextual information. [PUP-10121](https://tickets.puppetlabs.com/browse/PUP-1012)

- This release fixes a bug where Puppet would attempt to
    use a proxy specified in the `http_proxy` environment variable, even
    though `Puppet[:no_proxy]` was set to bypass the proxy. [PUP-10112](https://tickets.puppetlabs.com/browse/PUP-10112)

- Previously, Puppet would only bypass a proxy if
    `no_proxy` had a leading wildcard or period. For example,
    `*.example.com` or `.example.com`. Puppet now bypasses the HTTP proxy if the
    `no_proxy` environment variable or Puppet setting is a suffix of
    the destination server FQDN. [PUP-10106](https://tickets.puppetlabs.com/browse/PUP-10106)

- If an `exec` resource's command is not executable or cannot be
    resolved into a fully qualified path, Puppet now only
    prints the command, and not the potentially sensitive arguments passed to the
    command. Puppet also redacts the output of sensitive
    commands when the `logoutput` parameter is set to
    `true`, or the parameter is `on_failure` (the
    default) and the command fails. [PUP-10100](https://tickets.puppetlabs.com/browse/PUP-10100)

- Puppet now correctly installs dpkg sub-packages and sets them to `held` if `ensure` is set to
    `held`. [PUP-10059](https://tickets.puppetlabs.com/browse/PUP-10059)"

- Puppet can now manage pip resources in directories
    containing spaces, such as `C:\Program Files\Python27`on Windows.
    [PUP-9647](https://tickets.puppetlabs.com/browse/PUP-9647) 

- Prior to this release, the `notify` resource leaked
    data if the message was a `sensitive` datatype with a
    raw value, not encapsulated in quotes. Now sensitive values are redacted when they
    are interpolated in a `notify` resource's message. [PUP-9295](https://tickets.puppetlabs.com/browse/PUP-9295)

- Previously, the pip provider failed if `pip --version` did not emit
    the version on the first line of output. [PUP-8986](https://tickets.puppetlabs.com/browse/PUP-8986)

- The `systemd` service provider can now manage services whose names
    start with a dash. Contributed by [j-collier](https://github.com/j-collier) [PUP-7218](https://tickets.puppetlabs.com/browse/PUP-7218)

- Previously, if the `cwd` parameter was not specified, puppet would
    change its working directory to the current working directory, which was redundant
    and could fail if the current working directory was not accessible. Now,
    `wxec` resources only change the current working directory if the
    `cwd` parameter is specified in a manifest. [PUP-5915](https://tickets.puppetlabs.com/browse/PUP-5915)

## Puppet 5.5.17

Released 15 October 2019

This is a bug-fix and new feature release.

### New features

- The `exec` type's `onlyif` and `unless` checks now return redacted output if it is marked sensitive. [PUP-9956]((https://tickets.puppetlabs.com/browse/PUP-9956))

- You can now specify `no_proxy` as a Puppet setting, consistent with other `http_proxy_*` Puppet settings. The `NO_PROXY` environment variable takes precedence over the `no_proxy` Puppet setting. [PUP-9316]((https://tickets.puppetlabs.com/browse/PUP-9316))

- Installation time on larger modules has been improved. Previously, on platforms that had the minitar gem installed, mintar would fsync every directory and file, causing long extraction times during module installation. Puppet now uses minitar 0.9, with this fsync option turned off by default. [PUP-10013]((https://tickets.puppetlabs.com/browse/PUP-1001)3)

- Puppet can now set Windows service startup type to Auto-Start (Delayed). To set a service to use this setting, set the `enable` parameter of the `service` resource to "delayed". [PUP-6382]((https://tickets.puppetlabs.com/browse/PUP-6382))

- When running in daemon mode, Puppet logs the configuration used on agent startup at the debug level. The log is sent to the output specified by the `--logdest` option. Configuration is reloaded and also logged on SIGHUP. [PUP-9754]((https://tickets.puppetlabs.com/browse/PUP-9754))

### Resolved issues

- This version upgrades the Ruby version to 2.4.9 to address the following security issues:
   * [CVE-2019-16255](https://www.ruby-lang.org/en/news/2019/10/01/code-injection-shell-test-cve-2019-16255/): A code injection vulnerability of Shell#[] and Shell#test
   * [CVE-2019-16201](https://www.ruby-lang.org/en/news/2019/10/01/webrick-regexp-digestauth-dos-cve-2019-16201/): Regular Expression Denial of Service vulnerability of WEBrick's Digest access authentication
   * [CVE-2019-16254](https://www.ruby-lang.org/en/news/2019/10/01/http-response-splitting-in-webrick-cve-2019-16254/): HTTP response splitting in WEBrick (Additional fix)
   * [CVE-2019-15845](https://www.ruby-lang.org/en/news/2019/10/01/nul-injection-file-fnmatch-cve-2019-15845/): A NUL injection vulnerability of File.fnmatch and File.fnmatch?
   * [RDoc vulnerabilities](https://www.ruby-lang.org/en/news/2019/08/28/multiple-jquery-vulnerabilities-in-rdoc/).

- This version upgrades OpenSSL to 1.0.2t to address CVE-2019-1547, CVE-2019-1549 and CVE-2019-1563. For more details, see the [OpenSSL Security Advisory](https://www.openssl.org/news/secadv/20190910.txt).

- This version includes a security update to curl 7.66.0 to address [CVE-2019-5481](https://curl.haxx.se/docs/CVE-2019-5481.html) and [CVE-2019-5482](https://curl.haxx.se/docs/CVE-2019-5482.html).

- Previously, the `puppet resource --to_yaml` and `puppet device --to_yaml` commands did not generate valid YAML if the output contained special characters such as a single quote. [PUP-7808]((https://tickets.puppetlabs.com/browse/PUP-7808))

- Prior to this release, Puppet silently ignored truncated file downloads, such as when using a file resource whose source parameter contained a `puppet://`, `http://`, or `https://` URL. This issue was caused by a Ruby issue and is fixed in this release. [PA-2849]((https://tickets.puppetlabs.com/browse/PA-2849))

- The `puppet plugin download` command now reuses HTTPS connections. This significantly speeds up the download process. [PUP-8662]((https://tickets.puppetlabs.com/browse/PUP-8662))

- If the agent is configured to use an HTTP proxy, and it attempts to connect to a host that matches an entry in the `NO_PROXY` environment variable, then Puppet connects directly to the host instead of using the proxy. This feature was originally introduced in Puppet 4.2, but it did not work. [PUP-9942]((https://tickets.puppetlabs.com/browse/PUP-9942))

- Agents could not connect through an authenticating HTTP proxy when making REST requests to Puppet infrastructure, such as when requesting a catalog. Now agents will observe the `http_proxy_user` and `http_proxy_password` settings or `HTTP_PROXY_USER/PASSWORD` environment variables when making those requests. [PUP-4470]((https://tickets.puppetlabs.com/browse/PUP-4470))

- If an HTTP proxy is configured either in Puppet settings or the `HTTP_PROXY_*` environment variables, then Puppet does not use the proxy when connecting to localhost or 127.0.0.1. This behavior can be modified by changing the `no_proxy` setting in puppet.conf or the `NO_PROXY` environment variable. [PUP-2172]((https://tickets.puppetlabs.com/browse/PUP-2172))




## Puppet 5.5.16

Released 16 July 2019

This is a bug-fix and new feature release.

### New features

Previously, using `config print` to view your server list output a nested array that was difficult to read. Using `config print` now outputs the text in the same human-readable format as its entry in the `puppet.conf` file. Puppet uses the same human-readable output for errors you receive from being unable to connect to a server in `server_list``. [PUP-9495]((https://tickets.puppetlabs.com/browse/PUP-9495))

- When the agent is configured with a list of servers, with the `server_list` setting, it now requests server status from the "status" endpoint instead of the "node" endpoint. [PUP-9698]((https://tickets.puppetlabs.com/browse/PUP-9698))

### Resolved issues

- Some Puppet commands, such as `puppet-infra`, might not be found in the system PATH. This fix ensures that the relevant directory, `opt/puppetlabs/bin`, is available in the PATH. [PA-2750]((https://tickets.puppetlabs.com/browse/PA-2750))

- Custom MSI actions did not correctly log `STDERR` to the MSI log. [PA-2691]((https://tickets.puppetlabs.com/browse/PA-2691))

- If `LD_LIBRARY_PATH` is set on an AIX 7.y node, running Puppet might fail with the following error: `libfacter was not found. Please make sure it was installed to the expected location.` This is now fixed. [PA-2668]((https://tickets.puppetlabs.com/browse/PA-2668))

- Previously, Puppet agent failed to run if the Regional language was changed to Arabic (United Arab Emirates). Now if the code page is not available in Ruby, the handler reverts to UTF-8 and the agent does not fail. [PA-2191]((https://tickets.puppetlabs.com/browse/PA-2191))

- This release fixes an issue where incorrectly named spec files caused gem dependency lookup failures. [PA-2670]((https://tickets.puppetlabs.com/browse/PA-2670))

For facterdb this means facter 2.5.1 would be installed which then tries to overwrite the bin/facter binary upon installation because facter is a dependency of facterdb (regardless of version).- Prior to this release, Puppet agent required find, but didn't correctly declare it as a dependency. The agent now requires `findutils` as a dependency. [PA-2629]((https://tickets.puppetlabs.com/browse/PA-2629))

- Fixed reading of crontabs using Puppet for Solaris 11. Now crontabs for all users are listed when running 'puppet resource cron'. [PUP-9697]((https://tickets.puppetlabs.com/browse/PUP-9697))

- Update Augeas to 1.12.0, which includes the `always_query_group_plugin` keyword. [PA-2562]((https://tickets.puppetlabs.com/browse/PA-2562))

- This release fixes an issue where if a Puppet run is killed, the lockfile containing the PID that was being used for the process remains. If another process subsequently starts and uses this PID, the agent fails. Puppet now checks that the PID belongs to Puppet so it can lock the PID correctly. This fix works for Puppet even if you run it as a gem. [PUP-9691]((https://tickets.puppetlabs.com/browse/PUP-9691))

- This release fixes an issue where trying to remove a user resource on a Solaris 11 installation using a home directory configuration resulted in an error. [PUP-9706]((https://tickets.puppetlabs.com/browse/PUP-9706))

- If you used a Hiera 3 lookup or Hiera handled an alias and the key was configured with `convert_to`,  you'd get an error: "`undefined method 'call_function' for Hiera::Scope`" [PUP-9693]((https://tickets.puppetlabs.com/browse/PUP-9693)).

- Conversions from a string to an integer would result in an error when asking for conversion of a decimal string with leading zeros. For example, converting `Integer("08", 10)` would result in an error. [PUP-9689]((https://tickets.puppetlabs.com/browse/PUP-9689))

- This release includes an update to curl to address security issues. See [CVE-2019-5435](https://curl.haxx.se/docs/CVE-2019-5435.html) and [CVE-2019-5436](https://curl.haxx.se/docs/CVE-2019-5436.html) for information about the CVEs. [PA-2689](((https://tickets.puppetlabs.com/browse/PA-2689))

- When initialising new device certificates, `puppet device` would sometimes set permissions in a way that prevented the `pe-puppet` user from reading some directories. [PUP-9642]((https://tickets.puppetlabs.com/browse/PUP-9642))

- This release updates the Windows registry `read` method to replace null byte sequences with a space. This issue was causing PuppetDB to discard updated facts from affected nodes. [PUP-9639]((https://tickets.puppetlabs.com/browse/PUP-9639))

- Prior to this release, if you set a Debian package on hold with `ensure => held` and the package had a pending upgrade, Puppet would install the upgrade before locking the package [PUP-9564]((https://tickets.puppetlabs.com/browse/PUP-9564)).

- This release fixes an issue where the `gem update --system` command used in the Puppet agent caused conflicts with software that depends on gems in Puppet's vendored Ruby directory, such as r10k. Now gem paths always contain the path for this directory, even after updating. [PA-2628]((https://tickets.puppetlabs.com/browse/PA-2628))

## Puppet 5.5.15

This version of Puppet was never released.

## Puppet 5.5.14

Released 30 April 2019

This is a security and bug-fix release.

### Resolved issues

- This release updates the `libxslt` version packaged in `puppet-runtime` to version 1.11.33 . This update patches a critical security issue in `libxslt`. See [CVE-2019-11068](https://nvd.nist.gov/vuln/detail/CVE-2019-11068) for details about this vulnerability. [PA-2667]((https://tickets.puppetlabs.com/browse/PA-2667))

- To address security fixes, Open SSL has been updated to 1.0.2r.

- This release fixes an issue where you could no longer specify multiple logging destinations on the command line with the `--logdest` option. This feature was temporarily broken when we added the ability to specify a logging destination in `puppet.conf`. [PUP-9565]((https://tickets.puppetlabs.com/browse/PUP-9565))

- Because parameters for task execution may be sensitive, the `pxp-agent` no longer logs or writes parameter values to disk. [PCP-814]((https://tickets.puppetlabs.com/browse/PCP-814))

- Puppet now uses the `--no-document` option to exclude documentation when installing gems, instead of the deprecated `--no-rdoc` and `--no-ri` options. This change allows compatibility with `rubygems` 3.0 and greater. [PUP-9395]((https://tickets.puppetlabs.com/browse/PUP-9395))

## Puppet 5.5.13

Released 16 April 2019

This is a bug-fix and new feature release.

### New features

This release of the `puppet-agent` package removes support for Cumulus-2.2-amd64 and Debian 7 (Wheezy). [PA-2574]((https://tickets.puppetlabs.com/browse/PA-2574)), [PA-2567]((https://tickets.puppetlabs.com/browse/PA-2567))

### Resolved issues

- Prior to this release, use of the `server_list` setting could cause misleading agent errors. Now, when running in debug mode, Puppet prints the exception that caused it to skip an entry in the server_list setting. [PUP-8036]((https://tickets.puppetlabs.com/browse/PUP-8036))

- This release adds information to debug output that specifies whether the server
setting originates from the `server` or `server_list` setting in the configuration. [PUP-9470]((https://tickets.puppetlabs.com/browse/PUP-9470))

## Puppet 5.5.12

Released 26 March 2019

This is a bug-fix and new feature release.

### New features

- Running the `exec` resource with `--debug` and `--noop` now prints a debug message with the command if checks prevent it from being executed. If `command`, `onlyif`, or `unless` are marked as sensitive, all commands are redacted from the log output. [PUP-9357]((https://tickets.puppetlabs.com/browse/PUP-9357))

- This release of the `puppet-agent` package removes support for SUSE Linux Enterprise Server 11/12 s390x. [PA-2489]((https://tickets.puppetlabs.com/browse/PA-2489))

- This release adds a `puppet-agent` package for macOS 10.14 Mojave. On macOS 10.14 Mojave, you must grant Puppet Full Disk Access to be able to manage users and groups. To give Puppet access on a machine running  10.14, go to `System Preferences > Security & Privacy > Privacy > Full Disk Access`, and add the path to the Puppet executable. Alternatively, set up automatic access using Privacy Preferences Control Profiles and a Mobile Device Management Server. [PA-2226]((https://tickets.puppetlabs.com/browse/PA-2226)), [PA-2227]((https://tickets.puppetlabs.com/browse/PA-2227))

### Bug fixes

- Augeas 1.11.0 has been released with a number of fixes and improvements. Update the puppet-agent package to get the new version. [PA-2364]((https://tickets.puppetlabs.com/browse/PUP-2364))

- This `puppet-agent` package release includes a security patch for Ruby 2.4.5. To learn more about the CVEs that this patch address, see the Ruby [security advisories](https://blog.rubygems.org/2019/03/05/security-advisories-2019-03.html). [PA-2510]((https://tickets.puppetlabs.com/browse/PA-2510))

- For the `filebucket` type, `server` and `port` no longer have explicit default values in the type definition. If `server` is not set, it defaults to the first entry in `server_list` if set; otherwise, it defaults to `server`. If `port` is not set, it defaults to the port in the first entry of `server_list` if set; otherwise, it defaults to `masterport`. [PUP-9025]((https://tickets.puppetlabs.com/browse/PUP-9025))

- This release modifies the `pxp-agent` service to kill all `pxp-agent` processes when the service is restarted, rather than only the current process. [PCP-833]((https://tickets.puppetlabs.com/browse/PCP-833))

- This release fixes an issue where `call()` function could call only functions that existed in Puppet core; custom functions could not be called. Now any function in the environment is visible and can be called. [PUP-9477]((https://tickets.puppetlabs.com/browse/PUP-9477))

- This release fixes a regression that prevented installing MSI packages from an HTTP URL on Windows. [PUP-9496]((https://tickets.puppetlabs.com/browse/PUP-9496))

- For the `filebucket` type, `server` and `port` no longer have explicit default values in the type definition. If `server` is not set, it defaults to the first entry in `server_list` if set; otherwise, it defaults to `server`. If `port` is not set, it defaults to the port in the first entry of `server_list` if set; otherwise, it defaults to `masterport`. [PUP-9025]((https://tickets.puppetlabs.com/browse/PUP-9025))

- Previously, if you used the type `Optional` without any arguments, it could result in an internal error. This is now fixed. On its own, `Optional`, means the same as `Any`. You should always supply a type argument with the desired type if the value is not `undef`. [PUP-9467]((https://tickets.puppetlabs.com/browse/PUP-9467))

- Prior to this release, agent runs provided the same output for both intentional and corrective changes. Now corrective changes are now explicitly called out in the logs as corrective. [PUP-9324]((https://tickets.puppetlabs.com/browse/PUP-9324))

- The upstart provider was being evaluated when loaded, causing issues with testing and availability during transactions. This  has been fixed so that the provider is evaluated only when provider suitability is being checked. [PUP-9336]((https://tickets.puppetlabs.com/browse/PUP-9336))

- If you passed an invalid path to `--logdest` option, Puppet silently ignored it. Now, if you give a `--logdest` location that Puppet cannot find or write to, the run fails with an error. [PUP-6571]((https://tickets.puppetlabs.com/browse/PUP-6571))

- The Windows group resource was incorrectly printing an array of SIDs for members. The resource now correctly prints members as <DOMAIN>/<user>. [PUP-9435]((https://tickets.puppetlabs.com/browse/PUP-9435))

- Heredoc expressions with interpolation using an access expression such as `$facts['somefact']` sometimes failed with a syntax error. This error was related to the relative location of the heredoc and surrounding whitespace and is now resolved. [PUP-9303]((https://tickets.puppetlabs.com/browse/PUP-9303))

- The `SublocatedExpression` class is no longer generated by the parser. The `SublocatedExpression` class itself will not be removed until 7.0.0, but it no longer appears in AST produced by the parser. [PUP-9303]((https://tickets.puppetlabs.com/browse/PUP-9303))

- Puppet commands now fail if Puppet Server is  unable to read the `puppet.conf` file. Only the `help` and `--version` commands work if the `puppet.conf` file is unreadable. [PUP-5575]((https://tickets.puppetlabs.com/browse/PUP-5575))

- If the agent encounters exceptions when pre-fetching resources for catalog application, it now logs the exceptions and returns a more useful error message. [PUP-8962]((https://tickets.puppetlabs.com/browse/PUP-8962))

- Improved error handling for PNTransformer     When parsing  into structured AST, the  parser produced an error on some empty constructs because the PNTransformer could not resolve them. Now it generates a Nop expression instead. [PUP-9400]((https://tickets.puppetlabs.com/browse/PUP-9400))

- Puppet now treats `owner` and `group` on the file resource as in-sync in the following scenario:
  - The `owner` and `group` are not set in the resource.
  - Either the `owner` or the `group` is set to the `System` user on the running mode.
  - The `System` user `ACE` is set to `FullControl`.

  Puppet now allows users to specifically configure the `System` user to less than `FullControl` by setting the `owner` and/or `group` parameters to `System` in the file resource. In this case, Puppet emits a warning since setting `System` to less than `FullControl` may have unintended consequences. [PUP-9337]((https://tickets.puppetlabs.com/browse/PUP-9337))

- If a functional server was not found, Puppet agent fell back to the `server` setting. Puppet agent now returns an error if `server_list` is set and a functional server is not found. [PUP-9076]((https://tickets.puppetlabs.com/browse/PUP-9076))

- The `pxp-agent init` script started more than one process if the `pidfile` was missing. This release modifies the `pxp-agent` service to kill all `pxp-agent` processes when the service is restarted, rather than only the current process. [PCP-833]((https://tickets.puppetlabs.com/browse/PCP-833))

## Puppet 5.5.11

This version of Puppet was never released.

## Puppet 5.5.10

Released 15 January 2019

This is a bug-fix release.

### Bug fixes

- The agent package on Solaris 11 failed because it tried to write files to `/system`. Now the package writes to the correct user-facing location in `/var`. [PA-2776]((https://tickets.puppetlabs.com/browse/PA-2276))

- `puppet-agent` packages for Fedora have been updated. As of this release, a `puppet-agent` package for Fedora 29 is available. Updated packages for Fedora 27, which reached end of life in November 2018, are no longer available.

- The `puppet module install` command now downloads only the release metadata it needs to perform dependency resolution, drastically reducing data download and improving installation time. For the `puppetlabs-stdlib` module, this change reduces the data download from 25MB to 68KB, and any module that depends on `stdlib` will benefit when installed. [PUP-9364]((https://tickets.puppetlabs.com/browse/PUP-9364))

- When compiling a catalog, Puppet sometimes raised the error "Attempt to redefine entity." This issue has been fixed with an update to the internal logic. [PUP-8002]((https://tickets.puppetlabs.com/browse/PUP-8002))

- Puppet now treats incomplete services the same way as nonexistent services, returning `enabled => false` and `ensure => :stopped` in either case. If you try to set `ensure => running` or `enabled => true` on an incomplete or nonexistent service, Puppet raises an error. [PUP-9240]((https://tickets.puppetlabs.com/browse/PUP-9240))

- Prior to this release, the `puppet device` command failed if the environment specified in `puppet.conf` or with the `--environment` option was not 'production'. This issue is fixed. Now `puppet device` uses its own device-specific cache for pluginsynced code (facts, types, and providers). Additionally, `puppet device` now supports a `--libdir` option for overriding any pluginsynced code with a local directory for testing. [PUP-8766]((https://tickets.puppetlabs.com/browse/PUP-8766))

- Failed dependency resources are now reported only once. After that resource has been reported, other resources that depend on the failed resource will not be reported again. However, you still get the skip message for each skipped resource. [PUP-6562]((https://tickets.puppetlabs.com/browse/PUP-6562))

- Error messages and logging are improved for some sync errors. Previously, Puppet provided no log message and an uninformative error. [PUP-1542]((https://tickets.puppetlabs.com/browse/PUP-1542))

- When compiling a catalog, Puppet sometimes raised the error "Attempt to redefine entity." This issue has been fixed with an update to the internal logic. [PUP-8002]((https://tickets.puppetlabs.com/browse/PUP-8002))

- SELinux utilities within the Puppet codebase now recognize that the `tmpfs` supports extended attributes and SELinux labels. The query `selinux_label_support?` returns `true` for a file mounted on `tmpfs`. [PUP-9330]((https://tickets.puppetlabs.com/browse/PUP-9330))

- This release fixes a regression in the string formatting rules that caused a short form for an Array or Hash to not be recognized. For example, `String([1,[2,3],4], '%#a")` would not format with indentation, but would format the long form `String([1,[2,3],4], {Array =&gt; { format =&gt; '%#a"}})`. Now the short form works for Array and Hash as intended.​[PUP-9329]((https://tickets.puppetlabs.com/browse/PUP-9329))

- Prior to this release, the data types `Timestamp` and `Timespan` raised errors if time range was specified with `Integer` or `Float` values. These data types now support time ranges specified with these values. [PUP-9310]((https://tickets.puppetlabs.com/browse/PUP-9310))

- This release fixes an issue where refreshed resources, such as reboot or some execs, did not create a status event in the event report. If the refresh fails, an event is also created for the failure. [PUP-9339]((https://tickets.puppetlabs.com/browse/PUP-9339))

## Puppet 5.5.9

This version of Puppet was never released.

## Puppet 5.5.8

Released 1 November 2018.

This is a bug-fix, new feature, and deprecation release.

### Bug fixes

- When `forcelocal` is true and `expiry` is set, use `usermod` to manage a user instead of  `lusermod`. `lusermod` does not support `-e` and causes the Puppet run to fail. [PUP-9195]((https://tickets.puppetlabs.com/browse/PUP-9195))
- Puppet 5.5.7 failed with a faulty error message when a legacy function did not comply with the standard rules. This is now fixed in Puppet 5.5.8 and accepts the illegal implementation of the function. [PUP-9270]((https://tickets.puppetlabs.com/browse/PUP-9270))
- Puppet will now only set the user, group, and mode of log files if Puppet creates them. [PUP-7331]((https://tickets.puppetlabs.com/browse/PUP-7331))
- The members property has been fixed to have the same API for `retrieve` and `should` as it did prior to the breaking changes in 5.5.7, while also reporting the right change notification. Providers can now return an array for `getter` and accept an array for `setter`. [PUP-9267]((https://tickets.puppetlabs.com/browse/PUP-9267)).

### New feature

- RHEL 8 now has DNF as the default package provider. [PUP-9198]((https://tickets.puppetlabs.com/browse/PUP-9198))

### Deprecation

- A regression was triggered by illegal constructs in functions that used the legacy 3.x function API. This has been fixed but will raise errors for the illegal constructs in Puppet 6. If you have 3.x functions that define methods inside the function body, or outside of the call to `newfunction`, they *must* be updated to work with Puppet 6 - and preferably use the modern 4x function API. [PUP-9268]((https://tickets.puppetlabs.com/browse/PUP-9268))

## Puppet 5.5.7

Released 23 October 2018.

This release contains new features, bug fixes, and deprecations.

### Bug fixes

- Fixed issue where overlapping module paths caused an incorrect illegal location deprecation warning or error. [PUP-9211]((https://tickets.puppetlabs.com/browse/PUP-9211))
- Empty or comments only files will no longer emit a deprecation warning or error about illegal top level construct. [PUP-9190]((https://tickets.puppetlabs.com/browse/PUP-9190))
- When using interpolation inside a heredoc, the position and location information for the interpolated expressions was wrong. This is now fixed. [PUP-9163]((https://tickets.puppetlabs.com/browse/PUP-9163))
- We have removed the deprecation warnings for most of the CA settings that were shipped prematurely in 5.5.6. All the CA settings, besides `capass` and `caprivatedir`, will still continue to function in Puppet 6. [PUP-9158]((https://tickets.puppetlabs.com/browse/PUP-9158))
- When called from the Puppet Language, the 3x functions were loaded when calling `function_<name>` (in Ruby) or when using `call_function` (in Ruby) from another function. In some circumstances this caused warnings for overwrite of already loaded functions. [PUP-9137]((https://tickets.puppetlabs.com/browse/PUP-9137))
- Fixed a race condition between Puppet and launchd when restarting services on OSX. [PUP-9111]((https://tickets.puppetlabs.com/browse/PUP-9111))
- Previously Puppet took at least one second to execute external processes, even if the process completed more quickly than that. This is now fixed and significantly decreases the time it takes the Puppet agent to apply a catalog if the catalog contains a large number of exec resources, and each child process completes in less than one second. [PUP-9092]((https://tickets.puppetlabs.com/browse/PUP-9092))
- Updated Puppet portage package provider for changes to Gentoo package management. [PUP-9044]((https://tickets.puppetlabs.com/browse/PUP-9044))
- The AIX user provider now handles the groups property in a manner that is consistent with other Linux user providers. Specifically, it reads the user's groups from the `/etc/group` file and implements inclusive/minimum membership correctly, even when the user's primary group changes. [PUP-7393]((https://tickets.puppetlabs.com/browse/PUP-7393))
- The members property in the group resource has been fixed to report the right change notifications to Puppet. [PUP-6542]((https://tickets.puppetlabs.com/browse/PUP-6542))
- Previously, the `state.yaml` file could grow unbounded. The new `statettl` setting controls how long entries are cached (default: 32 days). If you use resource schedules, see the `statettl` documentation to see how this setting interacts with the schedule type. [PUP-3647]((https://tickets.puppetlabs.com/browse/PUP-3647))
- `Puppet::Util.safe_posix_fork` now ensures that the stdin, stdout, and stderr streams are redirected to the passed-in files by referencing the corresponding STDIN, STDOUT and STDERR Ruby constants, instead of the mutable global variables $stdin, $stdout and $stderr. [PUP-9250]((https://tickets.puppetlabs.com/browse/PUP-9250))
- Puppet will no longer leak sensitive data into the resource file. [PUP-7580]((https://tickets.puppetlabs.com/browse/PUP-7580))

### New features and improvements

- The `Puppet::Util::Windows::ADSI::User` class now supports setting/unsetting ADSI userflags. [PUP-9177]((https://tickets.puppetlabs.com/browse/PUP-9177))
- It is no longer required to have a dependency listed in a module's metadata.json on another module, in order to use functions or data types from that module. [PUP-6964]((https://tickets.puppetlabs.com/browse/PUP-6964))
- `Puppet::Util::Execution.execute` now supports a `cwd` option to specify the current working directory that the command will run in. This option is only available on the agent. It cannot be used on the master, including regular functions, Hiera backends, or report processors. [PUP-6919]((https://tickets.puppetlabs.com/browse/PUP-6919))
- The `--logdest` argument can now be set in the puppet.conf file as the `logdest` setting. [PUP-2997]((https://tickets.puppetlabs.com/browse/PUP-2997))

### Deprecations

- A deprecation warning will be given during Puppet code validation when top level constructs that are not defined are found in auto loaded module files. [PUP-9020]((https://tickets.puppetlabs.com/browse/PUP-9020))

## Puppet 5.5.6

Released 22 August 2018

This is a bug-fix release of Puppet. It contains several deprecations.

**Note**: Puppet 5.5.4 and 5.5.5 releases do not exist. To keep Puppet and Puppet agent versions synchronized, we have skipped to version 5.5.6.

### Bug fixes

- The `tagged` function is no longer case sensitive. The `tagged` function will now return `true` if the string case-insensitively matches a resource or catalog tag. Previously, the function was case sensitive. ([PUP-9024]((https://tickets.puppetlabs.com/browse/PUP-9024)))

- Puppet Server catalog failed to compile when `disable_i18n = true` in the main section in `puppet.conf`. This is now fixed. ([PUP-9010]((https://tickets.puppetlabs.com/browse/PUP-9010)))

- puppet-agent-5.5.4-1.el6.x86_64 on Scientfic Linux 6 failed to use `upstart`. This is fixed. Note that the `upstart` provider only works on platforms that have the `upstart daemon` running. Puppet checks this with `initctl version --quiet`. ([PUP-9008]((https://tickets.puppetlabs.com/browse/PUP-9008)))

- This fix eliminates the use of `Kernel.eval` to convert stringified arrays to Ruby arrays when specified in Augeas resources in the manifest. ([PUP-8974]((https://tickets.puppetlabs.com/browse/PUP-8974)))

### New features and improvements

- We added deprecation warnings for manifests declaring things in the wrong namespace so that strict naming can be enforced. ([PUP-8894]((https://tickets.puppetlabs.com/browse/PUP-8894)))

### Deprecations

-   All Puppet subcommands that perform actions on the CA are deprecated. This includes `cert`, `ca`, `certificate`, `certificate_revocation_list`, and `certificate_request`. Their functionality will be replaced in Puppet 6 by a new CA command-line interface under Puppet Server, and a new client-side subcommand for SSL client tasks. This change deprecates `puppet.conf` settings:

    -   `ca_name`
    -   `cadir`
    -   `cacert`
    -   `cakey`
    -   `capub`
    -   `cacrl`
    -   `caprivatedir`
    -   `csrdir`
    -   `signeddir`
    -   `capass`
    -   `serial`
    -   `autosign`
    -   `allow_duplicate_certs`
    -   `ca_ttl`
    -   `cert_inventory`

    ([PUP-9027]((https://tickets.puppetlabs.com/browse/PUP-9027)) and [PUP-8997]((https://tickets.puppetlabs.com/browse/PUP-8997)))

- The LDAP Node Terminus is deprecated. ([PUP-7600]((https://tickets.puppetlabs.com/browse/PUP-7600)))

- Setting `source_permissions` to `use` or `use_when_creating` is deprecated. If you need to manage permissions, set them explicitly using `owner`, `group`, and `mode`. ([PUP-5921]((https://tickets.puppetlabs.com/browse/PUP-5921)))

## Puppet 5.5.3

Released 17 July 2018

This is a bug-fix release of Puppet.

-   [All issues resolved in Puppet 5.5.3](https://tickets.puppetlabs.com/issues/?jql=fixVersion%20%3D%20%27PUP%205.5.3%27)

### Bug fixes

-   The `selmodule` type in Puppet 5.5.3 checks module names more strictly when determining whether a module has already been loaded. Specifically, its search wasn't anchored to the start of the module name in previous versions of Puppet, resulting in modules whose only difference in name is a prefix (such as "motd" and "mymotd") falsely reporting which module is loaded. Puppet 5.5.3 resolves this issue. ([PUP-8943]((https://tickets.puppetlabs.com/browse/PUP-8943)))

-   When resources fail to restart when notified from another resource, Puppet 5.5.3 now flags them as failed and reports them as such. Reports also now include the [`failed_to_restart` status](./format_report.html) for individual resources. This change also increments the report format version to 10. ([PUP-8908]((https://tickets.puppetlabs.com/browse/PUP-8908)))

-   When `config_version` refers to an external program, the last run summary in Puppet 5.5.3 no longer includes the Puppet-specific class name in YAML output. This is designed to make the YAML output easier to work with when using other YAML-processing tools. ([PUP-8767]((https://tickets.puppetlabs.com/browse/PUP-8767)))

-   When previous versions of Puppet cleared the environment cache, associated translation domains lingered until they were replaced the next time the environment was used. Environments that were never used again would still consume memory required for the translations, resulting in a memory leak. Puppet 5.5.3 resolves this issue by releasing translation domains when the related cached environment is purged. ([PUP-8672]((https://tickets.puppetlabs.com/browse/PUP-8672)))

-   Since Puppet 4.10.9, non-existent Solaris SMF services reported a state of `:absent` instead of `:stopped`. This change could break some workflows, so the behavior has been reverted in this release to report non-existent Solaris SMF services as `:stopped`. ([PUP-8262]((https://tickets.puppetlabs.com/browse/PUP-8262)))

### Regression fixes

-   The introduction of `multi_json` in Puppet 5.5.0 broke the JSON log destination. Puppet 5.5.3 fixes this regression. ([PUP-8773]((https://tickets.puppetlabs.com/browse/PUP-8773)))

### New features

-   The new [`puppet device --facts`](puppet_device.html) command allows you to display facts on a device, much in the same way that the `puppet facts` command behaves on other agents. ([PUP-8699]((https://tickets.puppetlabs.com/browse/PUP-8699)))

### Deprecations

-   The `puppet module build` command is deprecated in Puppet 5.5.3 and will be removed in a future release. To build modules and submit them to the Puppet Forge, use the [Puppet Development Kit](https://puppet.com/download-puppet-development-kit). ([PUP-8762]((https://tickets.puppetlabs.com/browse/PUP-8762)))

-   The `--configprint` flag is deprecated in Puppet 5.5.3. When running `puppet <SUBCOMMAND> --configprint` with the `debug` or `verbose` flags, Puppet outputs a deprecation warning. Use `puppet config <SUBCOMMAND>` to output setting values. ([PUP-8712]((https://tickets.puppetlabs.com/browse/PUP-8712)))

-   Puppet has long verified absolute paths across platforms with `Puppet::Util.absolute_path?(path)`. However, it now uses Ruby's built-in methods to accomplish this. Puppet 5.5.3 therefore deprecates `Puppet::Util.absolute_path?(path)` in favor of `Pathname.new(path.to_s).absolute?`. ([PUP-7407]((https://tickets.puppetlabs.com/browse/PUP-7407)))

## Puppet 5.5.2

Released June 7, 2018.

This is a bug-fix and security release of Puppet.

-   [All issues resolved in Puppet 5.5.2](https://tickets.puppetlabs.com/issues/?jql=fixVersion%20%3D%20%27PUP%205.5.2%27)

### Bug fixes

-   In previous versions of Puppet, attempting to create a Numeric type from the String "0" would result in an error. Puppet 5.5.2 resolves this issue. ([PUP-8703]((https://tickets.puppetlabs.com/browse/PUP-8703)))

-   When running Puppet on Ruby 2.0 or newer, Puppet would close and reopen HTTP connections that were idle for more than 2 seconds, causing increased load on Puppet masters. Puppet 5.5.2 ensures that the agent always uses the `http_keepalive_timeout` setting when determining when to close idle connections. ([PUP-8663]((https://tickets.puppetlabs.com/browse/PUP-8663)))

-   When using the [`--freeze_main` option](./configuration.html#freezemain) in previous versions of Puppet, certain circumstances could result in an error even if no code being loaded modified the main loaded logic. Puppet 5.5.2 resolves this issue. ([PUP-8637]((https://tickets.puppetlabs.com/browse/PUP-8637)))

-   Previous versions of Puppet did not allow aliased (custom) data types or Variant types to be used with the `match()` function. Puppet 5.5.2 removes this limitation. ([PUP-8745]((https://tickets.puppetlabs.com/browse/PUP-8745)))

### Security fixes

-   On Windows, Puppet no longer includes `/opt/puppetlabs/puppet/modules` in its default basemodulepath, because unprivileged users could create a `C:\opt` directory and escalate privileges. ([PUP-8707]((https://tickets.puppetlabs.com/browse/PUP-8707)))

### New features

-   Puppet 5.5.2 can accept globs in the path name for the `modulepath` as defined in `environment.conf`. ([PUP-8556]((https://tickets.puppetlabs.com/browse/PUP-8556)))

-   Puppet 5.5.2 simplifies the logic for resolving resources' types in reports. ([PUP-8746]((https://tickets.puppetlabs.com/browse/PUP-8746)))

### Deprecations

-   Puppet 5.5.2 issues a deprecation warning when explicitly using a checksum value in the content property of a file resource. ([PUP-7534]((https://tickets.puppetlabs.com/browse/PUP-7534)))

## Puppet 5.5.1

Released April 17, 2018.

This is a feature and bug-fix release of Puppet.

-   [All issues resolved in Puppet 5.5.1](https://tickets.puppetlabs.com/issues/?jql=fixVersion%20%3D%20%27PUP%205.5.1%27)

### Deprecations

-   Ruby versions older than 2.3 are deprecated in Puppet 5.5.1 and will be removed in Puppet 6. Puppet issues warnings when using older versions of Ruby.	([PUP-8504]((https://tickets.puppetlabs.com/browse/PUP-8504)))

-   Puppet 5.5.1 removes the deprecation of `empty(undef)` introduced in Puppet 5.5.0. ([PUP-8623]((https://tickets.puppetlabs.com/browse/PUP-8623)))

### Bug fixes

-   When reporting metrics on the time of a Puppet run, previous versions of Puppet instead reported the sum of other run times. Puppet 5.5.1 reports the measured time of the run. ([PUP-6344]((https://tickets.puppetlabs.com/browse/PUP-6344)))

-   If the production environment did not exist when running Puppet, previous versions would create the directory as the user `root` and group `root` instead of the service account if one is available. Puppet 5.5.1 sets the owner and group to the service account if it exists on the node. ([PUP-6996]((https://tickets.puppetlabs.com/browse/PUP-6996)))

-   The `yumrepo` provider in previous versions of Puppet attempted to run `stat` on non-existent repository files when a repository file not being managed by a `yumrepo` resource was deleted. This led to an error on the first attempt at running Puppet. In Puppet 5.5.1, `yumrepo` ensures the file exists before attempting to run `stat`. ([PUP-8421]((https://tickets.puppetlabs.com/browse/PUP-8421)))

-   On AIX, Puppet 5.5.1 correctly manages users on the latest AIX service packs. ([PUP-8538]((https://tickets.puppetlabs.com/browse/PUP-8538)))

-   The `augeas` provider in previous versions of Puppet did not properly unescape quotes in quoted arguments for `set` and similar commands, resulting in escaping backslashes appearing in output. Puppet 5.5.1 correctly removes those escaping backslashes. ([PUP-8561]((https://tickets.puppetlabs.com/browse/PUP-8561)))

-   Previous versions of Puppet overpopulated the context stack with the server version, which drastically increased the time it took to parse the context stack for every request due to a massive amount of redundant data. Puppet 5.5.1 doesn't overpopulate the stack with duplicate information. ([PUP-8562]((https://tickets.puppetlabs.com/browse/PUP-8562)))

-   Extra information for `puppet config print` is shown only when passing the `verbose` or `debug` options in Puppet 5.5.1. ([PUP-8566]((https://tickets.puppetlabs.com/browse/PUP-8566)))

-   When parsing EPP templates containing CRLF line breaks, previous versions of Puppet did not generate files containing CRLF line breaks, which could cause issues when using EPP templates on platforms such as Windows that expect them. (ERB templates were not affected.) Puppet 5.5.1 correctly passes CRLF line breaks in EPP templates to the generated output. ([PUP-8240]((https://tickets.puppetlabs.com/browse/PUP-8240)))

### New features

-   When forming relationships between resources by using an invalid resource reference, the error message in Puppet 5.5.1 includes the source location. ([PUP-8498]((https://tickets.puppetlabs.com/browse/PUP-8498)))

-   In previous versions of Puppet, the `yumrepo` type limited priority values to a range fom 1 to 99. Puppet 5.5.1 now accepts any positive or negative integer, which matches the behavior of `yum` when determining valid priority values. ([PUP-4678]((https://tickets.puppetlabs.com/browse/PUP-4678)))

-   Previous versions of Puppet applied the `tidy` resource to all files that it found, even when Puppet managed the files. The `tidy` resource in Puppet 5.5.1 skips any files that are managed by Puppet when deciding if it should remove files. ([PUP-7307]((https://tickets.puppetlabs.com/browse/PUP-7307)))

-   SystemD is the new default provider for Ubuntu 17.04 and 17.10. ([PUP-8495]((https://tickets.puppetlabs.com/browse/PUP-8495)))

## Puppet 5.5.0

Released March 20, 2018.

This is a feature and bug-fix release of Puppet.

-   [All issues resolved in Puppet 5.5.0](https://tickets.puppetlabs.com/issues/?jql=fixVersion%20%3D%20%27PUP%205.5.0%27)

### Bug fixes

-   When processing malformed plist files, previous versions of Puppet used `/dev/stdout`, which can cause Ruby to report warnings. Puppet 5.5 instead uses `-`, which uses stdout when processing the plist file with `plutil`. ([PUP-8545]((https://tickets.puppetlabs.com/browse/PUP-8545)))

-   Previous versions of Puppet might incorrectly report an error that a match expression had no effect, if for instance numeric match variables could be set as a side-effect of evaluating the match. For example, this valid code would produce an error:

    ```puppet
    'cdf' =~ /^([a-z])(.*)/
    notice($2)
    ```

    Puppet 5.5.0 resolves the issue. ([PUP-8519]((https://tickets.puppetlabs.com/browse/PUP-8519)))

-   The `puppet lookup` command-line tool called the external node classifier (node terminus) even if the `--compile` flag was not enabled. This could cause errors, because Puppet would load classes indicated by the ENC without a complete and proper setup, or if loaded code was had parse errors. In Puppet 5.5.0, the configured ENC is used only if the `--compile` flag is enabled. ([PUP-8502]((https://tickets.puppetlabs.com/browse/PUP-8502)))

-   If selinux bindings were not available in previous versions of Puppet, it would try and fail to manage a setting because it could not read its current state. In Puppet 5.5.0, if no selinux bindings are available, Puppet doesn't try to read the setting's current inaccessible state. ([PUP-8477]((https://tickets.puppetlabs.com/browse/PUP-8477)))

-   The `puppet parser dump` output format in previous versions of Puppet produced output with an initial lowercase letter for names of types, when it should have used an initial uppercase letter. Puppet 5.5.0 resolves the issue. ([PUP-8474]((https://tickets.puppetlabs.com/browse/PUP-8474)))

-   Since Puppet 5.4.0, Puppet uses the `lusermod` command instead of `usermod` when setting `forcelocal => true` on a user resource in *nix. Puppet also typically manages group membership via the user resource. However, unlike `usermod`, the `lusermmod` command cannot manage group membership. Therefore, Puppet 5.4.0 couldn't manage group membership in a user resource.

    Puppet 5.5.0 calls `usermod` only when trying to manage group membership for a user resource. In some situations, such as attempting to add a user to a NIS or LDAP group, the command might still fail. However, this behavior is consistent with versions of Puppet prior to 5.4.0. ([PUP-8470]((https://tickets.puppetlabs.com/browse/PUP-8470)))

-   Puppet 5.5.0 should no longer log warnings resulting from inadvisable coding practices, such as using ambiguous arguments, to the process's `stderr`. This resolves an issue in previous versions of Puppet where log managers could cause a broken pipe. ([PUP-8467]((https://tickets.puppetlabs.com/browse/PUP-8467)))

-   In a custom Node terminus, previous versions of Puppet allowed you to construct the Node object where `$::environment` would be empty during catalog compilation, even though the Node object had a properly set environment. In Puppet 5.5.0, catalog compilation now consults the node's environment directly when setting `$::environment`. ([PUP-8443]((https://tickets.puppetlabs.com/browse/PUP-8443)))

-   The data types Timespan and Timestamp incorrectly set the upper bounds to the same as lower bounds when created with a single parameter. For example, `T[x]` was interpreted as `T[x,x]` instead of `T[x, <no-limit>]`. Puppet 5.5.0 resolves this by assuming no upper bound when passed a single parameter. ([PUP-8439]((https://tickets.puppetlabs.com/browse/PUP-8439)))

-   While previous versions of Puppet could create new Windows groups containing virtual accounts, it couldn't manage groups that contained at least one virtual account. Puppet might also have been unable to correctly manage groups with account names that appeared in both the local computer and a domain, due to a failure to properly disambiguate the accounts. Puppet 5.5.0 resolves both problems. ([PUP-8231]((https://tickets.puppetlabs.com/browse/PUP-8231)))

-   The `puppet config` command in Puppet 5.5.0 behaves better when a section is not specified, and resolves bugs that could cause settings to be set in the wrong section or resulted in duplicate sections. ([PUP-7542]((https://tickets.puppetlabs.com/browse/PUP-7542)))

-   The `--render-as` flag for `puppet config print` can now produce appropriately structured formatted output with the `json` and `yaml` options. The default format is unchanged. ([PUP-8188]((https://tickets.puppetlabs.com/browse/PUP-8188)))

-   When running `puppet config print` in Puppet 5.5.0, the `environment_timeout` setting prints `unlimited` when set to 'unlimited', and prints the configured `environment_timeout` when no environment exists to set this value. ([PUP-8409]((https://tickets.puppetlabs.com/browse/PUP-8409)))

-   The `puppet config print`, `set`, and `delete` commands now print the environment and section on stderr to reduce user confusion. The `puppet config print` command also warns the user if they do not specify a section. ([PUP-2868]((https://tickets.puppetlabs.com/browse/PUP-2868)))

-   Previous versions of Puppet produced warnings or errors when managing Windows local groups that contained unresolvable SIDs from previously valid domain members that had since been deleted. Puppet 5.5.0 safely handles these unresolvable SIDs inside of groups. ([PUP-7326]((https://tickets.puppetlabs.com/browse/PUP-7326)))

-   The `yumrepro` provider in Puppet 5.5.0 trims the leading and trailing spaces from the values it finds when reading a YUM Repository Configuration File, instead of returning an error. ([PUP-6639]((https://tickets.puppetlabs.com/browse/PUP-6639)))

-   Updated `yumrepo` provider descriptions for the `exclude` and `includepkg` field now explain that the properties should be set to a string containing a space-separated list of package names or shell globs. ([PUP-2884]((https://tickets.puppetlabs.com/browse/PUP-2884)))

-   The `yumrepo` provider in previous versions of Puppet overwrote repository configurations that weren't being managed by a `yumrepo` resource. Puppet 5.5.0 resolves this issue by checking for any unmanaged repository configurations before writing to the yumrepo config file. ([PUP-723]((https://tickets.puppetlabs.com/browse/PUP-723)))

### Known issues

-   The `yumrepo` provider contains the new property `target`. The property will be enabled in a future release and should not be used. ([PUP-8542]((https://tickets.puppetlabs.com/browse/PUP-8542)))

-   In previous versions of Puppet, if Hiera read a YAML data file and the result was neither a hash nor completely empty, Hiera issued a warning. In Puppet 5.5, if the `--strict=error` flag is enabled, Hiera will instead produce an error if the file was read by the built-in YAML or eYAML backend functions. If the `--strict` flag is set to `warning` or `off`, Hiera issues a warning as before.

    Note that Ruby's YAML parser does not fully comply with the YAML spec, and some faulty YAML files can still be loaded with unexpected results instead of errors. See [PUP-8547]((https://tickets.puppetlabs.com/browse/PUP-8547)) for details. ([PUP-8541]((https://tickets.puppetlabs.com/browse/PUP-8541)))
    
-   The `hiera-eyaml` gem was included with Puppet agent 5.5.0, but is not installed to a location in the working environment's PATH until Puppet agent 5.5.7, which can lead to unexpected Puppet agent failures [PA-2129](https://tickets.puppetlabs.com/browse/PA-2129):

    ```
    Error: Could not find command 'eyaml'
    Error: /Stage[main]/Hiera::Eyaml/Exec[createkeys]/returns: change from 'notrun' to ['0'] failed: Could not find command       'eyaml'
    ```

    The preferred solution is to update Puppet to 5.5.7 or newer. To work around this issue on Puppet agent 5.5.0 to 5.5.6, link the installed hiera-eyaml gem executable to that path:

    ```
    ln -s /opt/puppetlabs/puppet/lib/ruby/vendor_gems/bin/eyaml /opt/puppetlabs/puppet/bin/eyaml
    ```

### Improvements

-   If a heredoc used an empty end tag (`@("")`), Puppet reported a Ruby NameError. Puppet 5.5.0 instead reports an error stating that the tag is empty. ([PUP-8519]((https://tickets.puppetlabs.com/browse/PUP-8519)))

-   The `puppet help` and `puppet man` commands now print helpful error messages. ([PUP-8444]((https://tickets.puppetlabs.com/browse/PUP-8444)), [PUP-8464]((https://tickets.puppetlabs.com/browse/PUP-8464)))

-   In Puppet 5.5.0, the `puppet cert clean` command can clean certificates even if none of the certificates in the provided list have already been signed. ([PUP-8448]((https://tickets.puppetlabs.com/browse/PUP-8448)))

-   Puppet 5.5.0 restores the ability to upload facts to Puppet Server and other Puppet masters, as well as the `puppet facts upload` command, which is important for Direct Puppet workflows when agents always run from cached catalogs and need an alternate mechanism to upload facts. It also updates the default legacy `auth.conf` to allow agents to only upload their own facts. ([PUP-8232]((https://tickets.puppetlabs.com/browse/PUP-8232))

-   Time metrics recorded in the run report now include the time it takes to apply the catalog, convert the catalog, plugin sync, generate facts, retrieve nodes, and evaluate transactions. ([PUP-920]((https://tickets.puppetlabs.com/browse/PUP-920)), [PUP-6343]((https://tickets.puppetlabs.com/browse/PUP-6343)))

### New features

-   The `flatten()`, `empty()`, `join()`, `keys()`, `values()`, and `length()` functions have been promoted from the `stdlib` module to Puppet.

    Additionally, the Puppet `length()` function adds support for returning the length of a Binary value, and the `empty()` function supports answering if a Binary value is empty (has zero bytes).

    Puppet's implementations take precedence over `stdlib` if you use a version of the module containing them, and maintain compatibility with their `stdlib` implementations. As a result, you should not need to change any Puppet code relying on these functions. However, note that the Puppet implementation of `empty()` deprecates being called with an undef or numeric value and will issue a warning. ([PUP-8492]((https://tickets.puppetlabs.com/browse/PUP-8492)), [PUP-8497]((https://tickets.puppetlabs.com/browse/PUP-8497)), [PUP-8507]((https://tickets.puppetlabs.com/browse/PUP-8507)))

-   Puppet 5.5.0 uses the `MultiJson` gem to choose the fastest available JSON backend at runtime. By default, it loads the JSON gem built into Ruby. This allows Puppet Server to choose a faster backend if implemented. ([PUP-8501]((https://tickets.puppetlabs.com/browse/PUP-8501)))

-   In addition to Ubuntu 16.10, Puppet 5.5.0 uses `systemd` as the default provider for Ubuntu 17.04 and 17.10. ([PUP-8482]((https://tickets.puppetlabs.com/browse/PUP-8482)))

-   The S-Expression (Clojure-style) data format generated by `puppet parser dump` is formalized and updated in Puppet 5.5.0, and is now considered a supported API for tool integration. The new format is available in text and JSON formats, by using the `--format` flag with either `pn` for the new format or `json` for the new format in JSON. The `--pretty` flag adds line breaks and indentation for readability.

    The previous format remains the default for `puppet parser dump`, but is deprecated and will be removed in the next major version of puppet. ([PUP-8482]((https://tickets.puppetlabs.com/browse/PUP-8482)))

-   In Puppet 5.5.0, the `fqdn_rand()` function uses SHA256 to compute seed/rand when running on FIPS-enabled hosts, instead of MD5 as used on other hosts. As such, hosts generate different `fqdn_rand()` values depending on whether FIPS is enabled. ([PUP-8469]((https://tickets.puppetlabs.com/browse/PUP-8469)))

-   Puppet 5.5.0 adds the new `provider_used` field to the report schema for serialization and deserialization. This field is populated with the provider used to provide the resource. ([PUP-8412]((https://tickets.puppetlabs.com/browse/PUP-8412)))

-   Puppet 5.5.0 can retrieve the current system state as Puppet code from devices using `puppet device`. ([PUP-8041]((https://tickets.puppetlabs.com/browse/PUP-8041)))

-   You can specify a type conversion in `lookup_options` for Hiera 5. This allows you to convert values to a rich data type, for example to make a value Sensitive or construct a Timestamp, as well as other values that cannot be directly represented in JSON or YAML. ([PUP-7675]((https://tickets.puppetlabs.com/browse/PUP-7675)))

-   The `puppet config` command in Puppet 5.5.0 can remove settings. ([PUP-3020]((https://tickets.puppetlabs.com/browse/PUP-3020)))

-   The `yumrepo` provider in Puppet 5.5.0 supports username and password fields. ([PUP-7400]((https://tickets.puppetlabs.com/browse/PUP-7400)))

### Regressions

-   The introduction of `multi_json` in Puppet 5.5.0 broke the JSON log destination. For example, running Puppet agent with the `--logdest` option pointed at a JSON target would result in a Ruby failure. This regression is fixed in Puppet 5.5.3. ([PUP-8773]((https://tickets.puppetlabs.com/browse/PUP-8773)))

### Deprecations

-   The S-Expression (Clojure-style) data format generated by `puppet parser dump` is formalized and updated in Puppet 5.5.0, and is now considered a supported API for tool integration. The new format is available in text and JSON formats, by using the `--format` flag with either `pn` for the new format or `json` for the new format in JSON. The `--pretty` flag adds line breaks and indentation for readability.

    The previous format remains the default for `puppet parser dump`, but is deprecated and will be removed in the next major version of puppet. ([PUP-8482]((https://tickets.puppetlabs.com/browse/PUP-8482)))

-   The `puppet man` command is deprecated and will be removed in a future release. To view Puppet command documentation from the command line, use `puppet help <subcommand>` or the installed manpages as `man puppet-<subcommand>`. ([PUP-8445]((https://tickets.puppetlabs.com/browse/PUP-8445)))
