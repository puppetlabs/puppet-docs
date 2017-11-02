---
layout: default
toc_levels: 1234
title: "Puppet 5.3 Release Notes"
---

This page lists the changes in Puppet 5.3 and its patch releases. You can also view [current known issues](known_issues.html) in this release.

Puppet's version numbers use the format X.Y.Z, where:

-   X must increase for major backward-incompatible changes
-   Y can increase for backward-compatible new functionality or significant bug fixes
-   Z can increase for bug fixes

## If you're upgrading from Puppet 4.x

Read the [Puppet 5.0 release notes](/puppet/5.0/release_notes.html), because they cover breaking changes since Puppet 4.10.

Read the [Puppet 5.1](/puppet/5.1/release_notes.html) and [Puppet 5.2 release notes](/puppet/5.2/release_notes.html), because they cover important new features and changes since Puppet 5.0.

Also of interest: the [Puppet 4.10 release notes](/puppet/4.10/release_notes.html) and [Puppet 4.9 release notes](/puppet/4.9/release_notes.html).

## Puppet 5.3.3

Released November 6, 2017.

This is a bug-fix release of Puppet.

-   [All issues resolved in Puppet 5.3.3](https://tickets.puppetlabs.com/issues/?jql=fixVersion%20%3D%20%27PUP%205.3.3%27)

### Bug fix: Puppet can install Forge modules with many available versions

Previous versions of Puppet could fail to install modules from the Puppet Forge that had many available versions. Puppet 5.3.3 resolves this issue by improving URL encoding in paginated Forge results.

-   [PUP-8008](https://tickets.puppetlabs.com/browse/PUP-8008)

### Bug fix: Puppet consistently uses the system's locale

Previous versions of Puppet failed to consistently initialize its internationalization functionality using the system's locale. Puppet 5.3.3 resolves this issue, resulting in consistent presentation of localized messages when available.

-   [PUP-8040](https://tickets.puppetlabs.com/browse/PUP-8040)

### Bug fix: Puppet logs warnings about internationalization initialization failures only once

Previous versions of Puppet that failed to initialize its internationalization functionality, typically due to a missing `gettext` gem, would log a warning each time each module on the system was loaded. This overwhelmed logs with redundant error messages. Puppet 5.3.3 resolves this issue by logging that warning only once.

-   [PUP-8039](https://tickets.puppetlabs.com/browse/PUP-8039)

### Bug fix: Identical files can co-exist in a single filebucket

In previous versions of Puppet, backing up the same file content to a filebucket more than once could result in a mistaken error warning suggesting that the files had the same checksum value but different contents, which indicated a potential (but false) hash collision. Puppet 5.3.3 correctly handles duplicate files in a filebucket.

-   [PUP-7951](https://tickets.puppetlabs.com/browse/PUP-7951)

### Bug fix: Refresh events propagate to all tagged resources correctly

Previous versions of Puppet failed to propagate tags with included classes, which could break class notifications when running Puppet with tags enabled. Puppet 5.3.3 resolves this issue; refresh events are now correctly propagated to all tagged resources when running with tags, and some confusing debug and warning messages have been eliminated.

-   [PUP-7308](https://tickets.puppetlabs.com/browse/PUP-7308)

### Additional bug fixes

-   [PUP-8083](https://tickets.puppetlabs.com/browse/PUP-8083): Previous versions of Puppet did not correctly resolve the path to Windows reparse points that are mount points, rather than symbolic links. This could impact accessing paths on DFS shares. Puppet 5.3.3 resolves this issue.
-   [PUP-6986](https://tickets.puppetlabs.com/browse/PUP-6986): The `service` provider could fail with a stacktrace in previous versions of Puppet if the process line for any given service contained UTF-8 characters and Puppet was not running in UTF-8. Puppet 5.3.3 avoids this error by more gracefully handling these characters in order to match running services to the managed service name.
-   [PUP-3713](https://tickets.puppetlabs.com/browse/PUP-3713): To set the `volsize` property when creating a ZFS volume, Puppet 5.3.3 correctly uses the `-V` flag for the `zfs create` command, instead of the `-o` flag used in previous versions.
-   [PUP-3368](https://tickets.puppetlabs.com/browse/PUP-3368): Puppet 5.3.3 can parse Nagios files containing Unicode content more consistently.

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
