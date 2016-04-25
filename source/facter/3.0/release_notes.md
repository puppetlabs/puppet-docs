---
layout: default
title: "Facter 3.0: Release Notes"
---

[puppet-agent 1.2.x]: /puppet/4.2/reference/about_agent.html

This page documents the history of the Facter 3.0 series. (Previous version: [Facter 2.4 release notes](../2.4/release_notes.html).)

## Facter 3.0.2

Released July 22, 2015.

Shipped in [`puppet-agent` 1.2.2][puppet-agent 1.2.x].

Facter 3.0.2 fixes several regressions in Facter 3.0.0 and implements new features to support legacy workflows.

For JIRA issues related to Facter 3.0.2, see:

* [Fixes for Facter 3.0.2](https://tickets.puppetlabs.com/issues/?filter=15119)
* [Introduced in Facter 3.0.2](https://tickets.puppetlabs.com/issues/?filter=15118)

### Feature: `--show-legacy` Flag Outputs Unstructured Facts

Facter 3 reports new, structured versions of many facts, such as `os`, and hides the equivalent unstructured legacy facts when run from the command line. Facter still tracks these legacy facts---they're only hidden from command-line output. In Facter 3.0.2, you can force Facter to output legacy facts by running it with the `--show-legacy` flag, providing a way to maintain legacy workflows while you convert them to use structured facts.

* [FACT-1075](https://tickets.puppetlabs.com/browse/FACT-1075)

### FIX: Improved Memory Usage on Launch

Facter 3.0.0 consumes more memory than is necessary when starting `puppetserver`. Facter 3.0.2 significantly improves memory usage on launch, making `puppetserver` easier to start on low-spec systems.

* [FACT-1083](https://tickets.puppetlabs.com/browse/FACT-1083)

### FIX: Improved Parsing of Kernel-derived Major and Minor Operating System Version Facts

Facter 3.0.0 couldn't parse major and minor kernel release versions (`os.release.major` and `os.release.minor`) on OS X, or on operating systems that do not formally report OS release versions, such as Arch Linux. We've fixed this in Facter 3.0.2.

* [FACT-1056: Operatingsystem major release not resolved in OSX](https://tickets.puppetlabs.com/browse/FACT-1056)
* [FACT-1073: Operatingsystem release facts not properly resolved in Arch Linux](https://tickets.puppetlabs.com/browse/FACT-1073)

### REGRESSION FIX: Corrected `operatingsystem` Fact Reporting on Oracle Linux

Facter 3.0.0 incorrectly reports Oracle Linux's `operatingsystem` fact as `RedHat`. Facter 3.0.2 correctly reports `OracleLinux`.

* [FACT-1134](https://tickets.puppetlabs.com/browse/FACT-1134)

### REGRESSION FIX: Restored `xendomains` Fact

Facter 3.0.2 reports the `xendomains` fact, which was unintentionally omitted from Facter 3.0.0.

* [FACT-867](https://tickets.puppetlabs.com/browse/FACT-867)

### REGRESSION FIX: `fqdn` Fact Always Reports the Host's Domain Name

On some systems, Facter 3.0.0 doesn't report the domain name as part of the `fqdn` fact. We've fixed this in Facter 3.0.2.

* [FACT-1077](https://tickets.puppetlabs.com/browse/FACT-1077)
* [FACT-1078](https://tickets.puppetlabs.com/browse/FACT-1078)

### REGRESSION FIX: Fixed Crash on Windows Systems with Network Interfaces Lacking DHCP Assignments

Facter 3.0.0 can crash with an "unhandled exception" error when reporting facts on a Windows system where DHCP-configured network interfaces aren't assigned IP addresses. Facter 3.0.2 resolves this issue.

* [FACT-1084](https://tickets.puppetlabs.com/browse/FACT-1084)

### REGRESSION FIX: Localized Time Zones on Windows No Longer Report Invalid UTF-8 Sequences

When Windows is configured to use a timezone that has a localized name, like "Mitteleuropäische Sommerzeit", Facter 3.0.0 reports the timezone as "Mitteleurop‰ische Sommerzeit" in its output. Facter 3.0.2 resolves this issue.

* [FACT-1126](https://tickets.puppetlabs.com/browse/FACT-1126)

### REGRESSION FIX: Facter Works on Windows under MCollective

When running the MCollective agent plugin on Windows, Facter could report a missing `libfacter.so` shared object due to an unset environment variable. Facter 3.0.2 loads this object differently to avoid this error.

* [FACT-1125](https://tickets.puppetlabs.com/browse/FACT-1125)

### REGRESSION FIX: Resolved an OLE COM Initialization Issue When Reporting Windows Facts

Facter 3.0.0 can fail when reporting Windows facts that require `win32ole`, resulting in a "fail: OLE initialize" error. Facter 3.0.2 resolves this issue.

* [FACT-1082](https://tickets.puppetlabs.com/browse/FACT-1082)

### REGRESSION FIX: Restored Output on Non-zero Exit Codes

If a command returns a non-zero exit code or can't be found, Facter 3.0.0 returns `nil`, instead of a String as in Facter 2. This causes problems with facts that rely on exit codes or error messages. Facter 3.0.2 restores this functionality.

* [FACT-1115](https://tickets.puppetlabs.com/browse/FACT-1115)

### REGRESSION FIX: Fixed `stderr` Redirection

When Facter 3.0.0 invokes commands to report facts that result in `stderr` output, Facter reports the `stderr` output as the fact. Also, if the required command doesn't exist, Facter 3.0.0 reports a null value.

Facter 3.0.2 correctly reports facts in these situations. To view additional diagnostic information, including the invoked commands' `stderr` output, run Facter with the `--debug` flag.

* [FACT-1085](https://tickets.puppetlabs.com/browse/FACT-1085)

### `facter -p` Restored

In Facter 2.4, we deprecated `facter -p` as a means of accessing Puppet facts in favor of the `puppet facts` command because it introduced a circular dependency. However, we've reversed that decision in Facter 3.0.2 because `puppet facts` isn't yet a drop-in replacement for `facter`.

`puppet facts` is still the most direct source for Puppet facts, and we recommend moving to it to future-proof your Puppet workflow.

* [FACT-1111](https://tickets.puppetlabs.com/browse/FACT-1111)

## Facter 3.0.1

Released June 25, 2015.

Shipped in [`puppet-agent` 1.2.1][puppet-agent 1.2.x].

Facter 3.0.1 fixes an external facts regression that shipped in 3.0.0.

### REGRESSION FIX: External Facts Work Again

Facter 3.0.0 accidentally breaks manually installed external facts when running under Puppet. This is now fixed.

* [FACT-1055: External facts not working with cfacter](https://tickets.puppetlabs.com/browse/FACT-1055)

## Facter 3.0.0

Released June 24, 2015.

Shipped in [`puppet-agent` 1.2.0][puppet-agent 1.2.x].

Facter 3.0.0 is a complete rewrite of Facter in C++. Prior to this release, it was available separately as `cfacter` and could be enabled in Puppet by setting `cfacter = true` in puppet.conf.

For many workflows, this rewrite is a drop-in replacement for the Ruby-based Facter 2. It still supports custom facts written in Ruby with the existing Facter API, as well as external facts written in any number of languages.

It includes a few breaking changes relative to Facter 2.4.

* [All tickets fixed in 3.0.0](https://tickets.puppetlabs.com/issues/?filter=14556)
* [Issues introduced in 3.0.0](https://tickets.puppetlabs.com/issues/?filter=14557)

### BREAK (workaround in 3.0.2): Facter Doesn't Display Legacy Unstructured Facts with Structured Equivalents

Facter 2 introduced structured facts, and Facter 3 reprovisions many unstructured Puppet facts with new structured equivalents. For example, the new map-structured `os` fact describes several legacy operating system-related facts, such as `architecture` and `operatingsystem`.

Facter still tracks the legacy unstructured facts, and `puppet facts` still outputs these facts, but in Facter 3 these legacy facts no longer appear in the default command-line output. This change can break workflows that rely on legacy facts appearing in Facter output.

Facts that no longer appear in command-line output are documented as such in [the list of core facts](./core_facts.html).

To display legacy facts on the command line with Facter 3, we recommend either using `puppet facts` or modifying Facter workflows to instead use the equivalent structured facts. Facter 3.0.2 provides a flag that forces Facter to output legacy facts as an interim solution for affected workflows.

* [FACT-1075](https://tickets.puppetlabs.com/browse/FACT-1075)

### REGRESSION / BREAK (Fixed in 3.0.1): Can't Find Manually Installed External Facts

[inpage_external_regression]: #regression--break-fixed-in-301-cant-find-manually-installed-external-facts

[external facts]: ./custom_facts.html#external-facts

When running under Puppet, Facter 3.0.0 can't load _manually-installed_ [external facts][] from any of the following directories:

* `/etc/puppetlabs/facter/facts.d/`
* `/etc/facter/facts.d/`
* `C:\ProgramData\PuppetLabs\facter\facts.d\`
* `~/.facter/facts.d/`

This is an unintended regression from Facter 2, and we fixed it immediately in Facter 3.0.1.

Pluginsynced external facts (that is, facts synced from your Puppet modules) still work, but it's common to make your provisioning system set some external facts when creating a new machine as a way to assign persistent metadata to that node. If your site does this, Facter 3.0.0 will cause breakages. Make sure you install puppet-agent 1.2.1 instead of 1.2.0.

### REGRESSION (fixed in 3.0.2): Facter Reports Incorrect Values for `operatingsystem` Fact on Oracle Linux

Facter 3.0.0 incorrectly reports Oracle Linux's `operatingsystem` fact as `RedHat`. Facter 3.0.2 correctly reports `OracleLinux`.

* [FACT-1134](https://tickets.puppetlabs.com/browse/FACT-1134)

### REGRESSION (fixed in 3.0.2): Facter Outputs `nil` When It Can't Find a Command, or When a Command Returns a Non-zero Exit Code

Facter 2 returns a String if a command returns a non-zero exit code or can't be found, but Facter 3.0.0 returns `nil`, which causes problems with facts that rely on exit codes or error messages. This behavior is reverted in Facter 3.0.2.

* [FACT-1115](https://tickets.puppetlabs.com/browse/FACT-1115)

### REGRESSION (fixed in 3.0.2): Facter Redirects `stderr` to `stdout`

When Facter 3.0.0 executes commands, it incorrectly redirects the stderr output from those commands to stdout, causing any affected facts to appear to contain the stderr output instead of the fact's value. This can also result in a fact appearing to have an unexpectedly null value if the first command that Facter executes when reporting that fact cannot be found. We resolved this in Facter 3.0.2, and you can view the commands' `stderr` output by running Facter with the `--debug` flag.

* [FACT-1085](https://tickets.puppetlabs.com/browse/FACT-1085)

### BREAK: Facter Doesn't Pass Commands' `stderr` to Puppet's `stderr`

In Facter 2, Facter redirects `stderr` output from executed commands to Facter's `stderr`. This no longer occurs in Facter 3.

To display more details about Facter's operation, including error messages from commands that Facter executes, use the `--debug` flag.

### BREAK: Removed Six Facts

The following facts are not supported in Facter 3:

* `cfkey`: This fact was specific to CFengine and removed.
* `dir`: This fact was unintentionally added in Windows because the `FACTER_DIR` environment variable was set.
* `ps`: Only Puppet uses this fact, and we updated Puppet to no longer require it.
* `puppetversion`: This fact introduced a circular dependency and didn't belong in Facter's core. We moved it into Puppet, implemented as an always-available custom fact, and other custom facts can take advantage of it if they're also running via Puppet.
* `uniqueid`: This fact was neither widely used nor necessarily unique in non-Solaris OSs. Puppet prefers `hostid`.
* `vlans`: This fact was not widely used and removed.

* [FACT-1013](https://tickets.puppetlabs.com/browse/FACT-1013)
* [CFACT-151](https://tickets.puppetlabs.com/browse/CFACT-151)

### REGRESSION (fixed in 3.0.2): `xendomains` Fact Removed

We unintentionally removed the `xendomains` fact in Facter 3.0.0. It's restored in Facter 3.0.2.

* [FACT-867](https://tickets.puppetlabs.com/browse/FACT-867)

### REGRESSION / BREAK (fixed in 3.0.2): `fqdn` Fact Might Omit Domain Name

On some systems, Facter 3.0.0 doesn't report the domain name as part of the `fqdn` fact. We've fixed this in Facter 3.0.2.

### BREAK: `:timeout` for Execution Replaces `:timeout` in Resolutions

You can no longer set the `:timeout` option when creating a new fact resolution. If a fact specifies a resolution timeout, Facter 3 will raise a warning and ignore it.

Instead, specify `:timeout` when you call the `Facter::Core::Execution#execute` function. An execution timeout is the number of seconds to wait for the command's execution to complete. If the time elapses, a `Facter::Core::Execution::ExecutionFailure` exception will be raised.

For details and examples, see [the custom fact docs.](./custom_facts.html#execution-timeouts)

This was necessary because there was no longer a safe way to implement timeouts of arbitrary Ruby code in a fact. The new interface should be just as useful since timeouts are almost always used to protect against long-running external commands, but you might need to update some facts.

* [FACT-886: Expose a timeout option on the Ruby Facter API](https://tickets.puppetlabs.com/browse/FACT-886)
* [FACT-907: cfacter doesn't implement :timeout](https://tickets.puppetlabs.com/browse/FACT-907)

### BREAK (reversed in 3.0.2): `facter -p` is Gone

Facter 3.0.0's command-line interface doesn't support the `-p` option because it introduced a circular dependency. To inspect facts from modules and pluginsync with Facter 3.0.0, please use the `puppet facts` command instead.

We reversed this decision in Facter 3.0.2.

### BREAK: On 64-bit Windows, `$os['hardware'] = x86_64`

We changed the value of the hardware fact (`os.hardware`) from "x64" to "x86_64" for 64-bit Windows editions to make Windows consistent with other operating systems. The `architecture` fact is still "x64" as it represents the platform-specific name for the system architecture.

* [FACT-610](https://tickets.puppetlabs.com/browse/FACT-610)

### BREAK: Removed Ruby Facter implementations

Facter 3.0 removes the Ruby implementations of some features and replaced it with a [custom facts API](https://github.com/puppetlabs/facter/blob/master/Extensibility.md#custom-facts-compatibility). Any custom fact that requires one of the Ruby files previously stored in `lib/facter/util` will fail with an error. For example, requiring the [`file_read.rb`](https://github.com/puppetlabs/facter/blob/2.x/lib/facter/util/file_read.rb) (`Facter::Util::FileRead`) Ruby module will produce an error message like this:

```
Error: Facter: error while resolving custom facts in /opt/configmgmt/environments/production/modules/custom_facts/lib/facter/customfact.rb: cannot load such file -- facter/util/file_read
```

As a workaround, you can rewrite your custom facts to avoid requiring these Ruby implementations, and instead use the [new API](https://github.com/puppetlabs/facter/blob/master/Extensibility.md#custom-facts-compatibility). You can also [copy the necessary Facter 2 Ruby libraries](https://github.com/puppetlabs/facter/tree/2.x/lib/facter/util) to the `lib/facter/util/` subdirectory of the affected `custom_facts` path, such as `/opt/configmgmt/environments/production/modules/custom_facts/lib/facter/util/` in the above example. For more information about writing custom facts for Facter 3, see [the Facter documentation](./custom_facts.html).

* [FACT-1400](https://tickets.puppetlabs.com/browse/FACT-1400)

### REGRESSION / BREAK (fixed in 3.0.2): Hostname missing from the `fqdn` fact

When reporting the `fqdn` fact, Facter 3.0.0 doesn't report the hostname. We resolved this in Facter 3.0.2.

* [FACT-1077](https://tickets.puppetlabs.com/browse/FACT-1077)
* [FACT-1078](https://tickets.puppetlabs.com/browse/FACT-1078)

### REGRESSION (fixed in 3.0.2): Facter Uses Too Much Memory

Facter 3.0.0 consumes more memory than necessary when starting `puppetserver`, causing stability or performance issues on systems with little RAM. We resolved this in Facter 3.0.2.

* [FACT-1083](https://tickets.puppetlabs.com/browse/FACT-1083)

### Enhanced Fact: `os` Fact Includes New and Renamed Keys

The new structured `os` fact adds several new keys and renames others.

* The new `architecture`, `hardware`, and `selinux` keys respectively report on the operating system's reported architecture, the supported instruction set, and selinux status.
* The `lsb` key is now named `distro`, and its keys are no longer prefixed by `dist`.
* The `release` key encompasses two keys, `full` and `major`. These keys replace `distrelease` and `majdistrelease`.

### New Facts: `disks`, `memory`, and Nine More

The following facts are new to the 3.0.0 release:

* `disks`
* `dmi`
* `identity`
* `load_averages`
* `memory`
* `mountpoints`
* `networking`
* `ruby`
* `solaris_zones`
* `ssh`
* `system_profiler`

Some of these facts contain new information about the node, and some are structured improvements on facts that were already present in Facter 2. Please see the [core facts reference](./core_facts.html) for details.

* [CFACT-154](https://tickets.puppetlabs.com/browse/CFACT-154)

### Better Docs for Core Facts

We've improved the [core facts reference](./core_facts.html) to include:

* The data type for every fact.
* Info about the name and data type for every member of map/hash facts.
* Whether the fact is included in Facter's command-line output.

### SPEED

We rewrote Facter in C++ to make it faster, and Facter 3 delivers in spades. It's noticeable everywhere, but especially impressive on Windows.
