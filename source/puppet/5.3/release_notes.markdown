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

## Puppet 5.3.0

Released September 26, 2017.

This is a feature and improvement release in the Puppet 5 series that also includes several bug fixes.

-   [All issues resolved in Puppet 5.3.0](https://tickets.puppetlabs.com/issues/?jql=fixVersion%20%3D%20%27PUP%205.3.0%27)

### New feature: Puppet agents retry requests on a configurable delay if Puppet Server is busy

When a group of Puppet agents start their Puppet runs together, they can form a "thundering herd" capable of exceeding Puppet Server's available resources. This results in a growing backlog of requests from Puppet agents waiting for a JRuby instance to become free before their request can be processed. If this backlog exceeds the size of the Server's Jetty thread pool, other requests (such as status checks) start timing out. (For more information about JRubies and Server performance, see [Applying metrics to improve performance]({{puppetserver}}/puppet_server_metrics_performance.html#measuring-capacity-with-jrubies).)

In previous versions of Puppet Server, administrators had to manually remediate this situation by separating groups of agent requests, for instance through rolling restarts. In Server 5.1.0, administrators can optionally have Server return a 503 response containing a `Retry-After` header to requests when the JRuby backlog exceeds a certain limit, causing agents to pause before retrying the request.

Both the backlog limit and `Retry-After` period are configurable, as the `max-queued-requests` and `max-retry-delay` settings respectively under the `jruby-puppet` configuration in [puppetserver.conf]({{puppetserver}}/config_file_puppetserver.html). Both settings' default values do not change Puppet Server's behavior compared to Server 5.0.0, so to take advantage of this feature in Puppet Server 5.1.0, you must specify your own values for `max-queued-requests` and `max-retry-delay`. For details, see the [puppetserver.conf]({{puppetserver}}/config_file_puppetserver.html) documentation. Also, Puppet agents must run Puppet 5.3.0 or newer to respect such headers.

-   [PUP-7451](https://tickets.puppetlabs.com/browse/PUP-7902)
-   [SERVER-1767](https://tickets.puppetlabs.com/browse/SERVER-1767)

### Regression fix: Allow trailing commas when specifying a type alias

Puppet 5.2.0 would falsely report a syntax error when including an optional trailing comma in a type alias specification, such as `type X = Variant\[Integer,]`. Puppet 5.3.0 resolves this regression by allowing trailing commas as expected.

-   [PUP-7952](https://tickets.puppetlabs.com/browse/PUP-7952)

### Bug fix: Heredocs closed by `-END` removes only the last trailing newline in a heredoc as expected

When a heredoc ended with a dash-prefixed tag (such as `-END`) to indicate that the final newline should be removed from the result, not only did Puppet remove the last newline, but it also reduced all multiple empty lines into single empty lines across the entire heredoc. Puppet 5.3.0 resolves this issue by removing only the single last trailing newline as expected.

-   [PUP-7902](https://tickets.puppetlabs.com/browse/PUP-7902)