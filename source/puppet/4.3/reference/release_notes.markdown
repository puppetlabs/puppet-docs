---
layout: default
title: "Puppet 4.3 Release Notes"
---

This page lists the changes in Puppet 4.3 and its patch releases.

Puppet's version numbers use the format X.Y.Z, where:

* X must increase for major backwards-incompatible changes
* Y may increase for backwards-compatible new functionality
* Z may increase for bug fixes

## If You're Upgrading from Puppet 3.x

Make sure you also read the [Puppet 4.0 release notes](/puppet/4.0/reference/release_notes.html), since they cover any breaking changes since Puppet 3.8.

Also of interest: the [Puppet 4.2 release notes](/puppet/4.2/reference/release_notes.html) and [Puppet 4.1 release notes](/puppet/4.1/reference/release_notes.html).

## Puppet 4.3.0

Released November 17, 2015.

Puppet 4.3.0 is a feature and bug fix release in the Puppet 4 series. It introduces the experimental `lookup` feature.


### New Feature: Data in Modules

* [PUP-4474: Complete the "data in modules" functionality introduced in Puppet 4.0.0](https://tickets.puppetlabs.com/browse/PUP-4474): The 'data in modules' is a new feature (partially available in earlier 4.x releases) that makes it possible to specify data in environments and modules without requiring that they all share the same hierarchy. Data can be defined using functions or via new Hiera 4 data providers.

* [PUP-4490: Pick up bindings from module's Metadata.json](https://tickets.puppetlabs.com/browse/PUP-4490): A module's `metadata.json` can now define the name of a 'data in modules' data provider directly without the need of specifying the same using the lower level bindings system which required ruby coding.

* [PUP-5395: There's no way to set resolution_type when using data bindings](https://tickets.puppetlabs.com/browse/PUP-5395): This adds a new feature to automatic data binding and the lookup function that allows the lookup options to be defined in the data by binding keys in a hash bound to the key `lookup_options`. This makes it possible to get deep merge behavior for select class parameters.

* [PUP-4489: Add data_provider to module metadata](https://tickets.puppetlabs.com/browse/PUP-4489): Module metadata can now optionally contain binding information for a 'data in modules' data provider.

		"data_provider":  "symbolic_name"

Where the key `symbolic_name` must be a string that matches /^[a-zA-Z][a-zA-Z0-9_]*$/

### New Feature: `lookup` Command Line Application

* [PUP-4476: Add a 'puppet lookup' command line application as UI to lookup function](https://tickets.puppetlabs.com/browse/PUP-4476): As part of the new 'data in modules' feature, there is now a command line command `puppet lookup` that can lookup the value for a given key for a given node. This is an intended replacement of the earlier "hiera" command line tool since it is unaware of 'data in modules'.
### New Feature: New `hiera` Data Provider

* [PUP-4485: Add a 'hiera' data provider](https://tickets.puppetlabs.com/browse/PUP-4485): This introduces the capability to have hiera data per environment and per module. This also introduces new features in the hiera.yaml configuration file that is used for environments and modules. The new feature does not apply to the regular hiera, which remains unaffected.

In summary:

* It is now possible to have more precise control over the hierarchy where hiera earlier gave all paths to all backends.
* Backends written for the regular hiera cannot be used with the new 'data in modules' based implementation (JSON and yaml support is included in Puppet).
* Data files in JSON and Hiera as used with regular Hiera are compatible with the data in modules implementation.
* The hiera.yaml configuration file is not compatible with regular Hiera.
* Automatic data binding, and the `lookup` function operates on the data in the global regular Hiera, environments, and modules. The `hiera_*` functions only operate on the global regular Hiera data.

* [PUP-4475: Add explain-ability to the lookup and data provider APIs](https://tickets.puppetlabs.com/browse/PUP-4475): As part of the 'data in modules' feature - the `lookup` command line tool can now explain how a looked up value was resolved by using the option `--explain`.

### New Feature: Control the Execution of Augeas Resources

* [PUP-4629: Augeas onlyif does not work when using arrays to match against](https://tickets.puppetlabs.com/browse/PUP-4629): Makes it possible to control execution of an augeas resource based on whether a property in the file being managed has a particular value. For example, you can ensure augeas only applies changes to /etc/nagios/nagios.cfg, if the cfg_file property in the nagios.cfg file does not equal a list of values.

~~~
	augeas { 'configure-nagios-cfg_file':
	incl => '/etc/nagios/nagios.cfg',
	lens => 'NagiosCfg.lns',
	changes => [ "rm cfg_file",
	"ins cfg_file",
	"set cfg_file[1] /etc/nagios/commands.cfg",
	"ins cfg_file after /files/etc/nagios/nagios.cfg/cfg_file[last()]",
	"set cfg_file[2] /etc/nagios/anotherconfig.cfg" ],
	onlyif => "values cfg_file != ['/etc/nagios/commands.cfg', '/etc/nagios/anotherconfig.cfg']"
	}
~~~


### New Features: Miscellaneous

* [PUP-4622: Add a diff command in Puppet filebucket](https://tickets.puppetlabs.com/browse/PUP-4622): Adds a new diff command to the Puppet filebucket application allowing you to diff two files. The files to compare can either be specified using a local path or the checksum of the file in the filebucket, e.g. `puppet filebucket diff d43a6ecaa892a1962398ac9170ea9bf2 7ae322f5791217e031dc60188f4521ef` will diff two files from the filebucket. The diff command works with both local and remote filebuckets.

* [PUP-5097: Hostname and Domain as trusted facts](https://tickets.puppetlabs.com/browse/PUP-5097): This change adds two new trusted facts, `hostname` and `domainname`, which can be handy in a hiera hierarchy. See the ticket description for an example of how it might be used in hiera.

* [PUP-4602: 'bsd' service provider doesn't work with rcng](https://tickets.puppetlabs.com/browse/PUP-4602): Previously, Puppet could not manage services on NetBSD. This change adds an `rcng` service provider, which is the default provider for platforms where the operatingsystem fact returns `netbsd` or `cargos`.

* [PUP-2315: function call error message about mis-matched arguments is hard to understand](https://tickets.puppetlabs.com/browse/PUP-2315): When giving arguments to functions, defined types, or classes, and they were not acceptable Puppet would produce too much information and thereby making it hard to understand exactly were the unacceptable argument value was and why it was unacceptable.

This is now much improved and the presented error message points to what to fix.

* [PUP-4780: enhance versioncmp() error checking as it only accepts strings](https://tickets.puppetlabs.com/browse/PUP-4780): The `versioncmp()` function now type checks its arguments (they must be Strings). Before this, if something other than Strings were given the result could be a confusing error message. Now it is made clear it is a type mismatch problem.

* [PUP-5355: Add additional OIDs for cloud specific data](https://tickets.puppetlabs.com/browse/PUP-5355): Adds more Puppet OIDs under ppRegCertExt (1.3.6.1.4.1.34380.1.1) for certificate extension information, see the table of [Puppet Specific Registered IDs](https://docs.puppetlabs.com/puppet/latest/reference/ssl_attributes_extensions.html#puppet-specific-registered-ids).

* [PUP-4055: Support DNF package manager (yum successor)](https://tickets.puppetlabs.com/browse/PUP-4055): Fedora 22 has moved to DNF as a replacement for yum. With this ticket, we now have a new DNF package provider that supports DNF.

* [PUP-1388: Add 'list' subcommand to filebucket](https://tickets.puppetlabs.com/browse/PUP-1388): Makes it possible to list *local* filebuckets, returning the checksum, date and path of each file in the file bucket. Listing remote filebuckets is not supported. The list command takes optional --fromdate and/or --todate options to limit which files are returned.
* [PUP-4890: Add code_id to catalog](https://tickets.puppetlabs.com/browse/PUP-4890): Adds `code_id` to the catalog, which is serialized with the catalog, e.g. when the agent requests a catalog. Updates the catalog schema and api docs. For now the code_id will always be nil, so there is not much in the way of user-facing changes.

* [PUP-5221: (Ankeny) Direct Puppet: code_id support](https://tickets.puppetlabs.com/browse/PUP-5221): This epic covers add a `code_id` field to the catalog during compilation. The catalog sent to the agent and puppetdb will contain & persist the code_id. See the API docs for more information about how this changes the catalog schema.

For FOSS users, the `code_id` will have a nil value, and doesn't result in user-visible behavior changes. In PE Ankeny, the `code_id` will be the git sha from the file sync service.


### Bug Fixes: Language

* [PUP-4926: Relationship with a parameter does not work](https://tickets.puppetlabs.com/browse/PUP-4926): When giving a resource reference such as Notify['x'] as an attribute value in a resource or class it was not possible to form a relationship with this value.

* [PUP-4610: multi-resource references do not accept trailing commas](https://tickets.puppetlabs.com/browse/PUP-4610): A trailing comma was not accepted in expressions like `Type[title,]`.

* [PUP-5026: error message "illegal comma separated argument list" does not give a line number](https://tickets.puppetlabs.com/browse/PUP-5026): Some error messages like "illegal comma separated list" did not contain the source location (file and line).

### Bug Fixes: Resource Types and Providers

* [PUP-2573: Puppet::Agent::Locker#lock doesn't return whether it acquired the lock or not](https://tickets.puppetlabs.com/browse/PUP-2573): The Puppet agent uses a lock file to ensure that only one instance is running at a time. However, the agent was susceptible to a race condition that could cause two agents to try to acquire the lock at the same time, and have one of them fail with a generic "Could not run" error. Now the agent will atomically try to acquire the lock, and if that fails, log a meaningful error.

* [PUP-2509: puppet resource service on Solaris needs -H flag](https://tickets.puppetlabs.com/browse/PUP-2509): This change was necessary on Solaris 11 due to a new format for service listings when calling `svcs`. Puppet was fooled into thinking that the literal column headers of the command output were services, when they clearly were not.

* [PUP-5016: SysV init script managed by 'init' provider instead of 'debian' provider on Debian8](https://tickets.puppetlabs.com/browse/PUP-5016): In Debian 8 and Ubuntu 15.04, Systemd was introduced as the default service manager. However, many packages and services still utilize older SysVInit scripts to manage services, necessitating the systemd-sysv-init compatibility layer.

This layer confused Puppet into improperly managing SysVInit services on these platforms. The final outcome of this ticket is that Puppet now falls back to the Debian service provider when managing a service without a Systemd unit file. All services should be enable-able, which they were not before due to Puppet incorrectly falling back to the Init provider.

In another, closely related scenario (on versions of Ubuntu before 15.04), the init provider was erroneously being favored over the debian provider when managing the 'enable' attribute of upstart services. This meant that `puppet resource service <name>` would not show whether the service was enabled or not.

This change causes the debian provider to be used instead, which utilizes upstart rather than init to manage these services. Thus, the `enable` attribute is always displayed when a service is queried.

* [PUP-5271: Windows user resource should not manage password unless specified](https://tickets.puppetlabs.com/browse/PUP-5271): When you are attempting to create users without specifying the password and you have the Windows Password Policy for `Password must meet complexity requirements` set to Enabled, it caused Puppet to fail to create the user. Now it works appropriately.

>>NOTE: When the Windows Password Policy `Minimum password length` is greater than 0, the password must always be specified. This is due to Windows validation for new user creation requiring a password for all new accounts, so it is not possible to leave password unspecified once that password policy is set.

It is also important to note that when a user is specified with `managehome => true`, the password must always be specified if it is not an already existing user on the system.

* [PUP-4633: User resource fails with UTF-8 comment on 2nd run](https://tickets.puppetlabs.com/browse/PUP-4633): Failure to parse existing non-ASCII characters in user comment field - performed when comment is set by the user type - has been fixed.

* [PUP-4738: launchd enable/disable on OS X 10.11](https://tickets.puppetlabs.com/browse/PUP-4738): On OS X 10.10+, the launchd provider would fail to update the correct plist. On OS X 10.11 this would result in an error when trying to update a service registered in /System because permission is restricted on /System. Fixed so that the launchd provider now updates the correct override plist rather than falling back to attempting to modify the service plist.

* [PUP-5058: The sshkey Type's Default Target for Mac OS X 10.11 (El Capitan) is Incorrect](https://tickets.puppetlabs.com/browse/PUP-5058): In OSX 10.11, the ssh_known_hosts file is in /etc/ssh, whereas it's in /etc in older OSX versions. This fix allows Puppet to manage the file on 10.11, while continuing to manage the file at the previous location on 10.9 and 10.10.

* [PUP-4917: puppet resource package does not display installs that use QuietDisplayName](https://tickets.puppetlabs.com/browse/PUP-4917): Previously, `puppet resource package` didn't display all installed programs as there was a new field added to the registry keys named QuietDisplayName. We've now fixed that so those items can now be managed with the Puppet built-in Windows package resource.

### Bug Fixes: Miscellaneous

* [PUP-1963: Generated resources never receive dependency edges](https://tickets.puppetlabs.com/browse/PUP-1963): Resources created by another type (via the `generate` method) will now have any relationship metaparams respected, and will participate in `autorequire`.
* [PUP-4918: Logrotate and init scripts permission and signal issues](https://tickets.puppetlabs.com/browse/PUP-4918): Log rotation was incorrectly configured on Fedora/RHEL and Debian-based systems; it pointed to the wrong file location and so would not rotate logs. Fix log locations so log rotation works again.

Also the log rotation script tried to own permissions for Puppet's log file, which conflicted with service restarts on Fedora/RHEL where the Puppet service would also try to update permissions for the log file. Installation on those systems will now set the correct permissions for log files, and the log rotation script will not try to update them.

* [PUP-3953: Puppet resource doesn't properly escape single quotes.](https://tickets.puppetlabs.com/browse/PUP-3953): `puppet resource` did not escape single quotes in resource titles, causing it to generate invalid manifests. This commit escapes single quotes so the title is valid.

* [PUP-4653: filebucket fails when environment is specified](https://tickets.puppetlabs.com/browse/PUP-4653): This ticket was supposed to cleanup the client-side filebucket code so that in the future we could support HTTP(S) based file sources. After this change was made, we realized it fixed another bug where filebucket requests failed when an environment was specified (PUP-4954). So for release notes, Puppet will correctly filebucket files when an environment is specified, such as when using agent specified environments.

* [PUP-5014: Base class for JSON/msgpack indirection termini calls log_exception() wrong](https://tickets.puppetlabs.com/browse/PUP-5014): If an exception occurred while serializing objects to JSON or msgpack, Puppet generated a new exception while logging the original exception, causing the reason for the original exception to be lost.

* [PUP-4781: filemode retrieved by static_compiler should be stringified](https://tickets.puppetlabs.com/browse/PUP-4781): The static compiler was completely broken in Puppet 4, because it would generate file resources with numeric file modes, which is not allowed. This fix causes the static compiler to generate a quoted octal mode, e.g. "644".

* [PUP-5282: Allow local of install of a gem on windows](https://tickets.puppetlabs.com/browse/PUP-5282): Makes it possible to use the gem provider on windows where the source is a local gem.

* [PUP-5192: undefined method `[]' for Puppet::Transaction::Event with certain reports](https://tickets.puppetlabs.com/browse/PUP-5192): PUP-3272 introduced a regression where you could not load a report containing status events, e.g. YAML.load_file("last_run_report.yaml"). This ticket fixes fixes that and adds tests to ensure we don't regress.

* [PUP-5055: parent attributes are set from metadata too early in static_compiler](https://tickets.puppetlabs.com/browse/PUP-5055): When using the static compiler (catalog_terminus=static_compiler), and managing a directory with `recurse => true`, then the static compiler would copy the metadata, e.g. owner, from the parent to the child, even when the manifest already specified the child's metadata.

* [PUP-4697: Puppet service provider for SuSE should default to systemd except for version 11](https://tickets.puppetlabs.com/browse/PUP-4697): Changes the default service provider for suse to be `systemd`, and falls back to `redhat` for versions 10 and 11. This change aligns with future suse releases as they will be `systemd` based. It's a breaking change for suse 9 and earlier, but those are not supported.

* [PUP-2575: OS X group resource triggers spurious notice of a change](https://tickets.puppetlabs.com/browse/PUP-2575): Previously, if the manifest specified group members in a different order than the OSX group provider returned them in, then Puppet would generate a spurious notice that the resource was not insync. The same would also happen if you specified the same member more than once.

* [PUP-4776: `puppet agent arg` silently eats arguments and runs the agent](https://tickets.puppetlabs.com/browse/PUP-4776): Previously, Puppet agent would allow arguments to be passed to it that it didn't understand, and would ignore them. For example, `puppet agent disable`, and because the Puppet agent deamonizes by default, this would actually start the agent running in the background instead of disabling it. Now the Puppet agent will reject options it doesn't understand.

* [PUP-4771: Static compiler only looks for file content in production environment](https://tickets.puppetlabs.com/browse/PUP-4771): Fixes the static compiler to use the specified environment, rather than always using production.

* [PUP-5062: static compiler fails to remove existing resources from children.](https://tickets.puppetlabs.com/browse/PUP-5062): Previously the static compiler would fail to remove children from the graph that already exist thanks to recursive directory resources, causing an error for valid Puppet code. This has been fixed.

* [PUP-4919: static compiler always sets ensure parameter to 'file' if a source is declared](https://tickets.puppetlabs.com/browse/PUP-4919): When using the static compiler, it was not possible to ensure a file resource was absent. Instead it would always ensure it was a file.

* [PUP-5037: RedHat puppetmaster service status report is invalid when it's stopped and client is running](https://tickets.puppetlabs.com/browse/PUP-5037): If the Puppet service was running, but the passenger-based puppetmaster service was not, then you would receive an error when trying to get the status of the puppetmaster service. Now it reports that the puppetmaster service is stopped.

* [PUP-4740: Add missing query parameters to Puppet HTTPS API docs](https://tickets.puppetlabs.com/browse/PUP-4740): Updates the REST API docs to include source_permissions and configured_environment query parameters that the agent sends. No code/behavior changes were made.

* [PUP-1189: Custom reports not working (Class is already defined in Puppet::Reports)](https://tickets.puppetlabs.com/browse/PUP-1189): Previously, if a report handler failed during initialization, it wasn't cleaned up. So the second time a report was submitted, Puppet would try to instantiate a new class, and then fail because it had already been instantiated. This instructs the class loader to overwrite if needed.

* [PUP-3694: puppet cert fingerprint invalidhost returns zero instead of non-zero](https://tickets.puppetlabs.com/browse/PUP-3694): Previously, `puppet cert fingerprint invalid_host_name` would report an error but still exit 0. This fixes the command to return a non-zero exit code if the certificate can not be found.

* [PUP-4814: Path of scheduled tasks folder is not necessarily C:\Windows\Tasks](https://tickets.puppetlabs.com/browse/PUP-4814): Previously Puppet's scheduled_task provider on windows assumed the windows system directory was C:\windows\system32. However, it possible for the directory to be on an alternative drive and/or have a different root directory, e.g. D:\winnt\system32. As a result the provider could not manage scheduled tasks. This change uses the SystemRoot environment variable to resolve the correct directory.

* [PUP-5340: puppet apply doesn't honor --catalog_cache_terminus](https://tickets.puppetlabs.com/browse/PUP-5340): Changes `puppet apply` to observe the `catalog_cache_terminus` Puppet setting to be consistent with `puppet agent`. This way you can run `puppet apply <manifest.pp> --catalog_cache_terminus=json`, then Puppet will store a cached copy of the catalog in `$client_datadir/catalog/<hostname>.json`. The default behavior of `puppet apply` is unchanged.

* [PUP-5381: Evaluating instance match with Optional[T] and NotUndef[T] fails when T is a string value](https://tickets.puppetlabs.com/browse/PUP-5381): The type references Optional[T] and NotUndef[T] should have accepted a string S as a shorthand notation for Enum[S]. Instead this failed with an error which is not corrected.

* [PUP-5292: regsubst doesn't work on empty arrays in Puppet 4.x](https://tickets.puppetlabs.com/browse/PUP-5292): Type system did not recognize an empty array as an acceptable value where a array with a specified subtype was declared. This caused certain calls to be reported as being given the wrong type(s) of arguments - e.g. a regsubst function call operating on an empty array.

* [PUP-5427: incorrect path being defined in puppet-agent's init script is causing gems to be installed into Puppet's gem env.](https://tickets.puppetlabs.com/browse/PUP-5427): When running Puppet as a daemon, our private bin directory, /opt/puppetlabs/puppet/bin was prepended to the PATH for the Puppet process, causing Puppet to install gems (such as when using the `gem` package provider) into Puppet's vendored ruby instead of system ruby. Now Puppet correctly installs gems into system ruby when running daemonized, which is consistent with running Puppet in the foreground, e.g. `puppet agent -t`.

* [PUP-5262: Solaris (10) service provider returns before service refresh is complete](https://tickets.puppetlabs.com/browse/PUP-5262): In versions of Solaris older than 11.2, service state transitions are not atomic. On slower systems, this could cause race conditions when starting, stopping or restarting services, as Puppet did not wait for services to conclude their operations before continuing to apply different resources. The SMF service provider has been updated to wait up for up to 60 seconds when changing the state of a service.

* [PUP-5309: Yum package provider: ensure => latest fails when kernel is updated but not current](https://tickets.puppetlabs.com/browse/PUP-5309): The yum provider will no longer throw "undefined method `[]' for nil:NilClass" if the yum-security plugin is enabled when trying to manage a yum package.

* [PUP-5441: $trusted is not available in master compile and fails when coming from PDB](https://tickets.puppetlabs.com/browse/PUP-5441): Sanitizes the trusted info in the node object when it is restored from cache. This prevents "Attempt to assign to a reserved variable name: 'trusted' " errors when running standalone compiles on a master node, among other scenarios.

* [PUP-5025: Package resource showing notice when ensure attribute contains Epoch tag](https://tickets.puppetlabs.com/browse/PUP-5025): Previously, if the ensure property for a yum/dnf package contained an epoch tag, then Puppet would consider the resource to always be out-of-sync and would try to reinstall the package. Puppet now takes into account the epoch tag when comparing the current and desired versions.

* [PUP-4458: Refactor validation of 4.x parameter signatures](https://tickets.puppetlabs.com/browse/PUP-4458): This makes the typechecking and reporting of parameter types consistent. Earlier there were several different implementatations and they differed in how they checked and reported type mismatches.

* [PUP-5035: undefined method `keys' for nil:NilClass in static_compiler](https://tickets.puppetlabs.com/browse/PUP-5035): The static compiler would raise a NoMethodError exception if it tried to inline metadata for a file resource where recurse was true, but the source parameter, e.g. `source => 'puppet:///modules/puppet/puppet.conf'`, referred to a file on the master.

* [PUP-4702: Replace rgen model for the Puppet Type system with immutable classes](https://tickets.puppetlabs.com/browse/PUP-4702): A refactoring was done of the Puppet type system to make it use less memory and faster performing.

* [PUP-5342: Empty arrays does not match type of typed arrays](https://tickets.puppetlabs.com/browse/PUP-5342): The type system did not accept an empty array as valid when the array type matched against did not accept Undef entries.

* [PUP-4932: Deprecate cfacter setting](https://tickets.puppetlabs.com/browse/PUP-4932): The cfacter setting existed so that users could opt-into native facter. But in AIO, it is the one and only facter implementation, and trying to set it will fail, since native facter does not provide cfacter.rb. This ticket deprecates the setting and it will be removed in the next major version.

* [PUP-5032: Update node terminus configured_environment to mirror agent_specified_environment](https://tickets.puppetlabs.com/browse/PUP-5032): When the `configured_environment` property was added to node and catalog communication, it was always set even when accepting the default. This was less useful than intended, as a node classifier may expect to know whether the agent explicitly requested that environment or is using the default. Change to only set the `configured_environment` property if an environment was explicitly requested on the agent, i.e. via puppet.conf or the command-line.

* [PUP-4516: Agent does not stop with Ctrl-C](https://tickets.puppetlabs.com/browse/PUP-4516): Puppet agents and webrick masters now immediately exit in response to SIGINT and SIGTERM signals, such as when pressing Ctrl-C. Previously, if the agent process was idle, it would take upwards of 5 seconds for the process to stop. If the agent was performing a run, it could not be interrupted until after the run completed.

* [PUP-5387: AIX service provider returns before service operations are complete](https://tickets.puppetlabs.com/browse/PUP-5387): In AIX, service state transitions are not atomic. On slower systems, this could cause race conditions when starting, stopping or restarting services, as Puppet did not wait for services to conclude their operations before continuing to apply different resources. The SRC service provider has been updated to wait up for up to 60 seconds when changing the state of a service.

* [PUP-5422: Daemonized agent's pidfile never removed if stopped while waiting for a certificate](https://tickets.puppetlabs.com/browse/PUP-5422): If the daemonized agent was waiting for a cert to be issued, and the process was killed, e.g. SIGTERM or SIGINT, then the agent would exit ungracefully and leave its pid file behind. Now the agent gracefully exits and deletes its pid file.
