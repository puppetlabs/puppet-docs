---
layout: default
title: "About Deprecations in This Version of Puppet"
---

[puppet.conf]: ./config_file_main.html

## About Deprecations in Puppet 3.7

We expect Puppet 3.7 to be one of the final releases (if not **the** final release) before Puppet 4.0.

Since 4.0 counts as a major version under our versioning scheme, it's a rare opportunity to perform major cleanups of Puppet's code and behavior, and we've spent months identifying things we want to fix.

Some of these fixes can cause breaking changes to Puppet's user-facing behavior, and we need to make sure users are prepared before they upgrade. Thus, these pages collect all of the deprecated features that will be vanishing or changing significantly in Puppet 4.0.

If you use Puppet, you should definitely read through these pages at least once. Please identify any deprecated features you think will affect you, and make sure you understand how to find uses of them in your code and how to update your code to eliminate them.


## Three Kinds of Deprecations

There are three main kinds of deprecations in this release:

### Deprecations With Warnings

Some features will cause deprecation warnings when you use them. These are the easiest to find.

First, ensure that [the `disable_warnings` setting](/references/3.7.latest/configuration.html#disablewarnings) is not set, on your Puppet master(s) or on any agent nodes.

Next, reset your Puppet master's web server. (In Puppet Enterprise, you can usually run `sudo service pe-httpd restart` to do this.) This will reset Puppet's automatic suppression of repeated deprecation warnings.

Finally, let your nodes go about their normal business while monitoring the syslog file on your Puppet master(s) and the syslog or event log on at least one agent node. (See the documentation on logging [for `puppet master`](./services_master_rack.html#logging) and for `puppet agent` [on \*nix](./services_agent_unix.html#logging) and [on Windows](./services_agent_windows.html#logging).)

Each deprecation that logs a warning will have an example of that warning in its "Detecting and Updating" section. Look for these warnings in your logs, and react as needed.

### Deprecations Revealed by the Future Parser

Some deprecated features do not log warnings, but will cause noisy and obvious failures in Puppet 4's implementation of the Puppet language. In these cases, you can root out failures by temporarily setting `parser = future` in [puppet.conf][] on your Puppet master(s). This lets you identify uses of deprecated features at your leisure, while still being able to revert to pre-4.0 behavior if you aren't ready to fix every failure yet.

### Deprecations Without Warnings

Some deprecated features (mostly the rarest or most obvious ones) have no warnings and cannot be smoked out by turning on the future parser; they will simply stop working once you upgrade to 4.0. For these features, the "Detecting and Updating" section of their deprecation notice will include brief instructions for finding out whether you're affected. Sometimes this involves a global text search; other times it may involve a survey of the custom tooling you've built around Puppet's APIs.

## Complete List of Deprecations

Use the navigation sidebar to the left to browse the lists of deprecated features in Puppet 3.7.
