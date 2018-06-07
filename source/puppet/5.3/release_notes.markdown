---
layout: default
toc_levels: 1234
title: "Puppet 5.3 Release Notes"
---

This page lists the changes in Puppet 5.3 and its patch releases. You can also view [known issues](known_issues.html) in this release.

Puppet's version numbers use the format X.Y.Z, where:

-   X must increase for major backward-incompatible changes
-   Y can increase for backward-compatible new functionality or significant bug fixes
-   Z can increase for bug fixes

## If you're upgrading from Puppet 4.x

Read the [Puppet 5.0.0 release notes](/puppet/5.0/release_notes.html#puppet-500), because they cover breaking changes since Puppet 4.10.

Read the [Puppet 5.1](/puppet/5.1/release_notes.html) and [Puppet 5.2 release notes](/puppet/5.2/release_notes.html), because they cover important new features and changes since Puppet 5.0.

Also of interest: the [Puppet 4.10 release notes](/puppet/4.10/release_notes.html) and [Puppet 4.9 release notes](/puppet/4.9/release_notes.html).

## Puppet 5.3.7

Released June 7, 2018.

This is a bug-fix and security release of Puppet.

-   [All issues resolved in Puppet 5.3.7](https://tickets.puppetlabs.com/issues/?jql=fixVersion%20%3D%20%27PUP%205.3.7%27)

### Bug fixes

-   When running Puppet on Ruby 2.0 or newer, Puppet would close and reopen HTTP connections that were idle for more than 2 seconds, causing increased load on Puppet masters. Puppet 5.3.7 ensures that the agent always uses the `http_keepalive_timeout` setting when determining when to close idle connections. ([PUP-8663](https://tickets.puppetlabs.com/browse/PUP-8663))

### Security fixes

-   On Windows, Puppet no longer includes `/opt/puppetlabs/puppet/modules` in its default basemodulepath, because unprivileged users could create a `C:\opt` directory and escalate privileges. ([PUP-8707](https://tickets.puppetlabs.com/browse/PUP-8707))

## Puppet 5.3.6

Released April 17, 2018.

This is a bug-fix and feature release of Puppet.

-   [All issues resolved in Puppet 5.3.6](https://tickets.puppetlabs.com/issues/?jql=fixVersion%20%3D%20%27PUP%205.3.6%27)

### Bug fixes

-   Previous versions of Puppet produced warnings or errors when managing Windows local groups that contained unresolvable SIDs from previously valid domain members that had since been deleted. Puppet 5.3.6 safely handles these unresolvable SIDs inside of groups. ([PUP-7326](https://tickets.puppetlabs.com/browse/PUP-7326))

-   While previous versions of Puppet could create new Windows groups containing virtual accounts, it couldn't manage groups that contained at least one virtual account. Puppet might also have been unable to correctly manage groups with account names that appeared in both the local computer and a domain, due to a failure to properly disambiguate the accounts. Puppet 5.3.6 resolves both problems. ([PUP-8231](https://tickets.puppetlabs.com/browse/PUP-8231))

-   In a custom Node terminus, previous versions of Puppet allowed you to construct the Node object where `$::environment` would be empty during catalog compilation, even though the Node object had a properly set environment. In Puppet 5.3.6, catalog compilation now consults the node's environment directly when setting `$::environment`. ([PUP-8443](https://tickets.puppetlabs.com/browse/PUP-8443))

-   In Puppet 5.3.6, the `puppet cert clean` command can clean certificates even if none of the certificates in the provided list have already been signed. ([PUP-8448](https://tickets.puppetlabs.com/browse/PUP-8448))

-   Puppet 5.3.6 should no longer log warnings resulting from inadvisable coding practices, such as using ambiguous arguments, to the process's `stderr`. This resolves an issue in previous versions of Puppet where log managers could cause a broken pipe. ([PUP-8467](https://tickets.puppetlabs.com/browse/PUP-8467))

-   The lookup CLI tool called the ENC (node terminus) even if the `--compile` option was not enabled. This could cause errors, because classes indicated by the ENC would be loaded without a full and proper setup, and could also result in an error if loaded code was had parse errors. Puppet 5.3.6 uses the configured ENC only if the `--compile` option is enabled. ([PUP-8502](https://tickets.puppetlabs.com/browse/PUP-8502))

-   On AIX, Puppet 5.3.6 correctly manages users on the latest AIX service packs. ([PUP-8538](https://tickets.puppetlabs.com/browse/PUP-8538))

-   When processing malformed plist files, previous versions of Puppet used `/dev/stdout`, which can cause Ruby to report warnings. Puppet 5.3.6 instead uses `-`, which uses stdout when processing the plist file with `plutil`. ([PUP-8545](https://tickets.puppetlabs.com/browse/PUP-8545))

-   Previous versions of Puppet overpopulated the context stack with the server version, which drastically increased the time it took to parse the context stack for every request due to a massive amount of redundant data. Puppet 5.3.6 doesn't overpopulate the stack with duplicate information. ([PUP-8562](https://tickets.puppetlabs.com/browse/PUP-8562))

### New features

-   Puppet 5.3.6 can retrieve the current system state as Puppet code from devices using `puppet device`. ([PUP-8041](https://tickets.puppetlabs.com/browse/PUP-8041))

-   SystemD is the new default provider for Ubuntu 17.04 and 17.10. ([PUP-8495](https://tickets.puppetlabs.com/browse/PUP-8495))

## Puppet 5.3.5

Released February 13, 2018.

This is a bug-fix and feature release of Puppet.

-   [All issues resolved in Puppet 5.3.5](https://tickets.puppetlabs.com/issues/?jql=fixVersion%20%3D%20%27PUP%205.3.5%27)

### Bug fixes

-   Pupet 5.3.3 introduced a regression that prevented `puppet apply` from downloading files from HTTP sources when the response was compressed. (The `puppet agent` command was unaffected.) Puppet 5.3.5 resolves the issue.

-   If the `noop` metaparameter is set to true on a `tidy` resource, Puppet 5.3.5 won't purge its children.

-   Previous versions of Puppet would fail to clean a certificate signing request when running `puppet cert clean` because it would try to revoke the certificate. In Puppet 5.3.5, `puppet cert clean` correctly cleans certificate signing requests.

-   When using `puppet types generate` for environment isolation, and a resource type had customized title patterns, previous versions of Puppet would not use those. Puppet 5.3.5 resolves this issue.

-   The `puppet apply` command in Puppet 5.3.5 no longer attempts to enforce the server-side requirements around environment directories when retrieving its node information from the server. In previous versions of Puppet, this check could cause multiple catalog retrievals during a single run.

-   In previous versions of Puppet, calling `tree_each` without a lambda returned an `Iterable` that could not be converted to an `Array` using the new or splat operators. Puppet 5.3.5 resolves this issue.

-   Puppet 5.3.5 only excludes `*.pot` files when downloading translations from the `locales` mount point, instead of for all pluginsync-related mount points.

-   Puppet 5.3.5 lets you use cached catalogs in `puppet apply` and `puppet agent` runs with the `--noop` flag. The cached catalog isn't updated if one already exists, and isn't created if there's no previously cached catalog.

-   A gem installation of previous versions of Puppet had unnecessary gem dependencies. The Puppet 5.3.5 gem requires `fast_gettext ~> 1.1.2`, since that is what Puppet uses.

-   Previous versions of Puppet attempted to include the default text from `gem list` as a part of the package name, resulting in failed gem installations. Puppet 5.3.5 strips the `default: ` text to allow searches for the version number only.

### New features

-   Puppet 5.3.5 uses DNF as the default package provider on Fedora 26 and newer.

## Puppet 5.3.4

Released February 5, 2018.

This is a bug-fix and feature release of Puppet.

-   [All issues resolved in Puppet 5.3.4](https://tickets.puppetlabs.com/issues/?jql=fixVersion%20%3D%20%27PUP%205.3.4%27)

### Bug fixes

-   Exceptions in prefetch were not marked as failed in the report under previous versions of Puppet, leading to reports incorrectly suggesting that an agent run with errors was fully successful. Puppet 5.3.4 marks only transactions that finish processing as successful.

-   Puppet 5.3.4 no longer returns "invalid byte sequence" errors when parsing module translation files in non-UTF-8 environments.

-   Running `puppet apply` or `puppet resource` to modify state in previous versions of Puppet would update the transaction.yaml file used to determine corrective vs. intentional change. This could lead to Puppet reporting an unexpected correctional change status. Puppet 5.3.4 resolves this by updating transaction.yaml only during an agent run.

-   The validation of `uris` in a Hiera 5 `hiera.yaml` file by previous versions of Puppet did not allow reference or partial URIs, such as those containing only a path, despite the documentation stating that Hiera doesn't ensure that URIs are resolvable. Puppet 5.3.4 relaxes the implemented URI checking to remove these constraints.

-   The `break()` function did not break the iteration over a hash, and instead would break the container in which a lambda called `break()`. This resulted in an error about a break from an illegal context if the container was something other than a function, and would lead to early exit when invoked from a function. Puppet 5.3.4 resolves this by having the function behave like a break in an array iteration.

-   Puppet 5.3.4 updates the command used to start services on Solaris, preventing Puppet from abandoning certain services before they are properly started.

-   A regression in Puppet 5.0.0 made it impossible to reference fully qualified variables in the default value expression for a parameter. Puppet 5.3.4 resolves this issue.

-   Previous versions of Puppet required that `--user=root` be passed to `puppet device` when creating certificates, even if the command was being executed by root. Puppet 5.3.4 no longer requires the flag.

-   When providing facts with the `--facts` command line option of the `puppet lookup` command in previous versions of Puppet, those facts would not appear in the `$facts` variable. Puppet 5.3.4 resolves this issue.

### New features

-   Puppet 5.3.4 adds the `sourceaddress` setting, which specifies the interface that the agent should use for outbound HTTP requests. This setting might be necessary for agents on systems with multiple network interfaces.

-   Puppet 5.3.4 adds the `runtimeout` setting, which can cancel agent runs after the specified period. The setting defaults to 0, which preserves the behavior in previous version of Puppet of allowing an unlimited amount of time for agent runs to complete.

-   Puppet 5.3.4 allows agents to download each module's translations from the master during pluginsync, along with the rest of the module's files. This downloads all available translations for all languages, not only those for the agent's locale, and does so for the version of the module in the requested environment only. If a master runs an older version of Puppet (Puppet 5.3.3, Puppet Server 5.1.3, or PE 2017.3.2), the 5.3.4 agent detects this and will not request locale files.

-   A type alias to an iterable type did not allow the alias to be iterated in previous versions of Puppet. Puppet 5.3.4 resolves this issue.

-   Previous versions of Puppet did not support using named format arguments for `sprintf`. Puppet 5.3.4 lets you use a hash with string values as the `sprintf` format argument.

    For example, `notice sprintf("%<x>s : %<y>d", { 'x' => 'value is', 'y' => 42 })` would produce a notice of `value is : 42`.

### Improvements

-   Puppet 5.3.4 can retrieve file sources from web servers when the associated MIME type is not "binary". This particularly affects IIS webservers.

-   When setting the day of the week with the `schedule` type, previous versions of Puppet required a quoted string value even if you wanted to represent the day as a numeric value. In Puppet 5.3.4, `schedule` accepts an integer representation of the day in addition to a string or array value.

-   Certain Puppet subcommands, such as `puppet help` and `puppet config`, no longer require a local environment to exist in Puppet 5.3.4. They now can fall back to assuming the defined environment exists on the master filesystem after checking for the local environment.

-   If `environment.conf` contains unknown settings, Puppet 5.3.4 warns only once per unknown setting.

-   Puppet 5.3.4 sorts the output of `puppet config` lexicographically.

-   More warning and error messages are translated for Japanese locales.

-   Error messages from `Puppet::Face` objects now include the face's name and version number.

-   Error messages now provide simpler text when identifying error locations, such as line and character numbers, which makes them easier and clearer to translate.

-   To specify an environment when running Puppet from the command line, Puppet 5.3.4 lets you use the short flag `-E` in addition to the long flag `--environment`.

## Puppet 5.3.3

Released November 6, 2017.

This is a bug-fix release of Puppet.

-   [All issues resolved in Puppet 5.3.3](https://tickets.puppetlabs.com/issues/?jql=fixVersion%20%3D%20%27PUP%205.3.3%27)

### Bug fixes

This release resolves issues with tag propagation, internationalization features and Unicode support, filebuckets, Windows reparse point path resolution, and ZFS volume creation.

-   Previous versions of Puppet could fail to install modules from the Puppet Forge that had many available versions. Puppet 5.3.3 resolves this issue by improving URL encoding in paginated Forge results.

-   Previous versions of Puppet failed to consistently initialize its internationalization functionality using the system's locale. Puppet 5.3.3 resolves this issue, resulting in consistent presentation of localized messages when available.

-   Previous versions of Puppet that failed to initialize its internationalization functionality, typically due to a missing `gettext` gem, would log a warning each time each module on the system was loaded. This overwhelmed logs with redundant error messages. Puppet 5.3.3 resolves this issue by logging that warning only once.

-   In previous versions of Puppet, backing up the same file content to a filebucket more than once could result in a mistaken error warning suggesting that the files had the same checksum value but different contents, which indicated a potential (but false) hash collision. Puppet 5.3.3 correctly handles duplicate files in a filebucket.

-   Previous versions of Puppet failed to propagate tags with included classes, which could break class notifications when running Puppet with tags enabled. Puppet 5.3.3 resolves this issue; refresh events are now correctly propagated to all tagged resources when running with tags, and some confusing debug and warning messages have been eliminated.

-   Previous versions of Puppet did not correctly resolve the path to Windows reparse points that are mount points, rather than symbolic links. This could prevent access to paths on DFS shares.

-   The `service` provider could fail with a stacktrace in previous versions of Puppet if the process line for any given service contained UTF-8 characters and Puppet was not running in UTF-8. Puppet 5.3.3 avoids this error by more gracefully handling these characters in order to match running services to the managed service name.

-   To set the `volsize` property when creating a ZFS volume, Puppet 5.3.3 correctly uses the `-V` flag for the `zfs create` command, instead of the `-o` flag used in previous versions.

-   This version of Puppet can parse Nagios files containing Unicode content more consistently than previous versions.

## Puppet 5.3.2

Released October 5, 2017.

This is a bug-fix release of Puppet Platform that adds a [new `puppet.conf` setting](./configuration_about_settings.html) to disable some internationalized strings for improved performance.

-   [All issues resolved in Puppet 5.3.2](https://tickets.puppetlabs.com/issues/?jql=fixVersion%20%3D%20%27PUP%205.3.2%27)

### New feature: Disabling internationalized strings

Puppet 5.3.2 adds the optional Boolean `disable_i18n` setting, which you can configure in `puppet.conf`. If set to `true`, Puppet disables translated strings in log messages, reports, and parts of the command-line interface. This can improve performance, especially if you don't need all strings translated from English. This setting is `false` by default in open source Puppet.

-   [PUP-8009](https://tickets.puppetlabs.com/browse/PUP-8009)

## Puppet 5.3.1

Released October 2, 2017.

This is a feature, bug-fix, and improvement release in the Puppet 5 series. Puppet 5.3.0 was not packaged for release.

-   [All issues resolved in Puppet 5.3.1](https://tickets.puppetlabs.com/issues/?jql=fixVersion%20%3D%20%27PUP%205.3.1%27)

### New feature: Puppet agents can retry requests on a configurable delay if Puppet Server is busy

When a group of Puppet agents start their Puppet runs together, they can form a "thundering herd" capable of exceeding Puppet Server's available resources. This results in a growing backlog of requests from Puppet agents waiting for a JRuby instance to become free before their request can be processed. If this backlog exceeds the size of the Server's Jetty thread pool, other requests (such as status checks) start timing out. (For more information about JRubies and Server performance, see [Applying metrics to improve performance]({{puppetserver}}/puppet_server_metrics_performance.html#measuring-capacity-with-jrubies).)

In previous versions of Puppet Server, administrators had to manually remediate this situation by separating groups of agent requests, for instance through rolling restarts. In Server 5.1.0, administrators can optionally have Server return a 503 response containing a `Retry-After` header to requests when the JRuby backlog exceeds a certain limit, causing agents to pause before retrying the request.

Both the backlog limit and `Retry-After` period are configurable, as the `max-queued-requests` and `max-retry-delay` settings respectively under the `jruby-puppet` configuration in [puppetserver.conf]({{puppetserver}}/config_file_puppetserver.html). Both settings' default values do not change Puppet Server's behavior compared to Server 5.0.0, so to take advantage of this feature in Puppet Server 5.1.0, you must specify your own values for `max-queued-requests` and `max-retry-delay`. For details, see the [puppetserver.conf]({{puppetserver}}/config_file_puppetserver.html) documentation. Also, Puppet agents must run Puppet 5.3.1 or newer to respect such headers.

-   [PUP-7451](https://tickets.puppetlabs.com/browse/PUP-7902)
-   [SERVER-1767](https://tickets.puppetlabs.com/browse/SERVER-1767)

### New feature: End-entity certificate revocation checking

Puppet 5.3.1 can be configured to perform end-entity certificate revocation checking.

The [`certificate_revocation`](https://docs.puppet.com/puppet/latest/configuration.html#certificaterevocation) setting in the `[main]` section of `puppet.conf` (or specified on the command line) now supports being set to `chain` or `leaf`. When set to `chain` (equivalent to `true`, and the default setting in 5.3.1), Puppet checks every certificate in the chain against the certificate revocation list (CRL). When set to `leaf`, CRL checks are limited to the end-entity certificate. This allows for basic revocation checking when using an intermediate CA certificate with Puppet.

-   [PUP-7845](https://tickets.puppetlabs.com/browse/PUP-7845)

### Regression fix: Allow trailing commas when specifying a type alias

Puppet 5.2.0 would falsely report a syntax error when including an optional trailing comma in a type alias specification, such as `type X = Variant\[Integer,]`. Puppet 5.3.1 resolves this regression by allowing trailing commas as expected.

-   [PUP-7952](https://tickets.puppetlabs.com/browse/PUP-7952)

### Bug fix: Heredocs closed by `-END` removes only the last trailing newline in a heredoc as expected

When a heredoc ended with a dash-prefixed tag (such as `-END`) to indicate that the final newline should be removed from the result, not only did Puppet remove the last newline, but it also reduced all multiple empty lines into single empty lines across the entire heredoc. Puppet 5.3.1 resolves this issue by removing only the single last trailing newline as expected.

-   [PUP-7902](https://tickets.puppetlabs.com/browse/PUP-7902)
