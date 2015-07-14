---
layout: default
title: "Facter 3.0: Release Notes"
---

This page documents the history of the Facter 3.0 series. (Previous version: [Facter 2.4 release notes](../2.4/release_notes.html).)

Facter 3.0.2
-----

Released July 15, 2015.

Shipped in puppet-agent version: 1.2.2.

Facter 3.0.2 fixes several regressions in Facter 3.0.0 and implements new features to support legacy workflows.

### Feature: `--show-legacy` Flag Outputs Unstructured Facts

Facter 3 outputs new, structured versions of many facts, such as `os`, and hides the equivalent unstructured legacy facts. In Facter 3.0.2, you can force Facter's output to include legacy facts by running it with the `--show-legacy` flag.

- [FACT-1075](https://tickets.puppetlabs.com/browse/FACT-1075)

### FIX: Improved Memory Usage on Launch

Facter 3.0.0 consumed more memory than was necessary when starting `puppetserver`. Facter 3.0.2 significantly improves memory usage on launch, making `puppetserver` easier to start on low-spec systems.

- [FACT-1083](https://tickets.puppetlabs.com/browse/FACT-1083)

### FIX: Improved Parsing of Kernel-derived Major and Minor Operating System Version Facts

In Facter 3.0.2, the `os` fact reports major and minor kernel release versions on operating systems that do not formally report OS release versions, such as OS X and Arch Linux.

- [FACT-1056: Operatingsystem major release not resolved in OSX](https://tickets.puppetlabs.com/browse/FACT-1056)
- [FACT-1073: Operatingsystem release facts not properly resolved in Arch Linux](https://tickets.puppetlabs.com/browse/FACT-1073)

### REGRESSION FIX: Restored `xendomains` Fact

Facter 3.0.2 reports the `xendomains` fact, which was unintentionally omitted from Facter 3.0.0.

- [FACT-867](https://tickets.puppetlabs.com/browse/FACT-867)

### REGRESSION FIX: Restored Hostname to the `fqdn` Fact

When reporting the `fqdn` fact, Facter 3.0.0 did not report the hostname. Facter 3.0.2 restores the hostname to the fact.

- [FACT-1077](https://tickets.puppetlabs.com/browse/FACT-1077)
- [FACT-1078](https://tickets.puppetlabs.com/browse/FACT-1078)

### REGRESSION FIX: Fixed Crash on Windows Systems with Network Interfaces Lacking DHCP Assignments

Facter 3.0.0 could crash with an "unhandled exception" error when reporting facts on a Windows system where DHCP-configured network interfaces weren't assigned IP addresses. Facter 3.0.2 resolves this issue.

- [FACT-1084](https://tickets.puppetlabs.com/browse/FACT-1084)

### REGRESSION FIX: Resolved an OLE COM Initialization Issue When Reporting Windows Facts 

Facter 3.0.0 could fail when reporting Windows facts that require `win32ole`, resulting in a "fail: OLE initialize" error. Facter 3.0.2 resolves this issue.

- [FACT-1082](https://tickets.puppetlabs.com/browse/FACT-1082)

### REGRESSION FIX: Restored Reporting On Command Execution And Failures

Facter 3.0.0 did not report output if a command it executed returned a non-zero exit code or couldn't be found. Facter 3.0.2 restores this functionality to Facter 2.x's behavior, producing error output to help diagnose fact-reporting failures.

- [FACT-1115](https://tickets.puppetlabs.com/browse/FACT-1115)

### REGRESSION FIX: Fixed `stderr` Redirection

When Facter 3.0.0 invoked commands to report facts that resulted in `stderr` output, Facter would report the `stderr` output as the fact. Also, if the required command didn't exist, Facter would report a null value. 

Facter 3.0.2 correctly handles fact values in these situations. To view additional diagnostic information, including the invoked commands' `stderr` output, run Facter with the `--debug` flag.

- [FACT-1085](https://tickets.puppetlabs.com/browse/FACT-1085)

### `facter -p` Restored

In Facter 2.4, we deprecated `facter -p` as a means of accessing Puppet facts in favor of the `puppet facts` command. However, we've reversed that decision in the short term due to the differences in functionality between `facter` and `puppet facts`.

`puppet facts` is still the best and most direct source for Puppet facts, and we recommend using it whenever possible and moving to it to future-proof your Puppet workflow.

- [FACT-1111](https://tickets.puppetlabs.com/browse/FACT-1111)

Facter 3.0.1
-----

Released June 25, 2015.

Shipped in puppet-agent version: 1.2.1.

Facter 3.0.1 fixes an external facts regression that shipped in 3.0.0.

### REGRESSION FIX: External Facts Work Again

Facter 3.0.0 accidentally broke manually installed external facts when running under Puppet. This is now fixed.

* [FACT-1055: External facts not working with cfacter](https://tickets.puppetlabs.com/browse/FACT-1055)

Facter 3.0.0
-----

Released June 24, 2015.

Shipped in puppet-agent version: 1.2.0.

Facter 3.0.0 is a complete rewrite of Facter in C++. Prior to this release, it was available separately as `cfacter` and could be enabled in Puppet by setting `cfacter = true` in puppet.conf.

For many workflows, this rewrite is a drop-in replacement for the Ruby-based Facter 2.x. It still supports custom facts written in Ruby with the existing Facter API, as well as external facts written in any number of languages.

It does include a few breaking changes relative to Facter 2.4.

* [All tickets fixed in 3.0.0](https://tickets.puppetlabs.com/issues/?filter=14556)
* [Issues introduced in 3.0.0](https://tickets.puppetlabs.com/issues/?filter=14557)

### BREAK (workaround in 3.0.2): Facter Doesn't Display Legacy Unstructured Facts with Structured Equivalents

Facter 2 introduced structured facts, and Facter 3.0.0 reprovisions many unstructured Puppet facts with new structured equivalents. Facter still tracks the legacy unstructured facts, and `puppet facts` still outputs these facts, but in Facter 3.0.0 these legacy facts no longer appear in the default command-line output. This might break workflows that rely on legacy facts appearing in Facter output.

For example, the new map-structured `os` fact describes several legacy operating system-related facts, such as `architecture` and `operatingsystem`.

Facts that no longer appear in command-line output are documented as such in [the list of core facts](./core_facts.html).

To display legacy facts on the command line with Facter 3, we recommend either using `puppet facts` or modifying Facter workflows to instead use the equivalent structured facts. Facter 3.0.2 provides a flag that forces Facter to output deprecated legacy facts as an interim solution for affected workflows.

- [FACT-1075](https://tickets.puppetlabs.com/browse/FACT-1075)

### REGRESSION / BREAK (Fixed in 3.0.1): Can't Find Manually Installed External Facts

[inpage_external_regression]: #regression--break-fixed-in-301-cant-find-manually-installed-external-facts

[external facts]: ./custom_facts.html#external-facts

When running under Puppet, Facter 3.0.0 can't load _manually-installed_ [external facts][] from any of the following directories:

* `/etc/puppetlabs/facter/facts.d/`
* `/etc/facter/facts.d/`
* `C:\ProgramData\PuppetLabs\facter\facts.d\`
* `~/.facter/facts.d/`

This was an unintended regression from Facter 2.x, and we fixed it immediately in Facter 3.0.1.

Pluginsynced external facts (that is, facts synced from your Puppet modules) still work, but it's common to make your provisioning system set some external facts when creating a new machine as a way to assign persistent metadata to that node. If your site does this, Facter 3.0.0 will cause breakages. Make sure you install puppet-agent 1.2.1 instead of 1.2.0.

### REGRESSION (fixed in 3.0.2): Facter Redirects `stderr` to `stdout`

When Facter 3.0.0 executes commands, it incorrectly redirects the stderr output from those commands to stdout, causing any affected facts to appear to contain the stderr output instead of the fact's value. This can also result in a fact appearing to have an unexpectedly null value if the first command that Facter executes when reporting that fact cannot be found. This is resolved in Facter 3.0.2, and you can view the commands' `stderr` output by running Facter with the `--debug` flag.

- [FACT-1085](https://tickets.puppetlabs.com/browse/FACT-1085)

### BREAK: Facter Does Not Pass Commands' `stderr` to Puppet's `stderr`

In Facter 2.x, Facter would redirect `stderr` output from executed commands to Facter's stderr. This no longer occurs in Facter 3.x.

To display more details about Facter's operation, including error messages from commands that Facter executes, use the `--debug` flag.

### BREAK: Removed Six Facts

The following facts are not supported in Facter 3.0.0:

* `ps`: Only Puppet uses this fact, and we updated Puppet to no longer require it.
* `uniqueid`: This fact was neither widely used nor necessarily unique in non-Solaris OSs. Puppet prefers `hostid`.
* `dir`: This fact was unintentionally added in Windows because the `FACTER_DIR` environment variable was set.
* `cfkey`: This fact was specific to CFengine and removed.
* `puppetversion`: This fact introduced a circular dependency and didn't belong in Facter's core. We moved it into Puppet, implemented as an always-available custom fact, and other custom facts can take advantage of it if they're also running via Puppet.
* `vlans`: This fact was not widely used and removed.

- [FACT-1013](https://tickets.puppetlabs.com/browse/FACT-1013)
- [CFACT-151](https://tickets.puppetlabs.com/browse/CFACT-151)

### REGRESSION (fixed in 3.0.2): `xendomains` Fact Removed

We unintentionally removed the `xendomains` fact in Facter 3.0.0. It was restored in Facter 3.0.2.

- [FACT-867](https://tickets.puppetlabs.com/browse/FACT-867)

### REGRESSION / BREAK (fixed in 3.0.2): `fqdn` Fact Omits Hostname

When reporting the `fqdn` fact, Facter 3.0.0 does not report the hostname. Facter 3.0.2 restores the hostname to the fact.

### BREAK: `:timeout` for Execution Replaces `:timeout` in Resolutions

You can no longer set the `:timeout` option when creating a new fact resolution. If a fact specifies a resolution timeout, Facter will raise a warning and ignore it.

Instead, specify `:timeout` when you call the `Facter::Core::Execution#execute` function. An execution timeout is the number of seconds to wait for the command's execution to complete. If the time elapses, a `Facter::Core::Execution::ExecutionFailure` exception will be raised.

For details and examples, see [the custom fact docs.](./custom_facts.html#execution-timeouts)

(This was necessary because there was no longer any safe way to implement timeouts of arbitrary Ruby code in a fact. Since timeouts were almost always used to protect against long-running external commands, the new interface should be just as useful, but you might need to update some facts.)

* [FACT-886: Expose a timeout option on the Ruby Facter API](https://tickets.puppetlabs.com/browse/FACT-886)
* [FACT-907: cfacter doesn't implement :timeout](https://tickets.puppetlabs.com/browse/FACT-907)

### BREAK (reversed in 3.0.2): `facter -p` is Gone

Facter's command line interface no longer supports the `-p` option, because it introduced a circular dependency.

To inspect facts from modules and pluginsync, please use the `puppet facts` command instead.

This decision was reversed in Facter 3.0.2.

### BREAK: On 64-bit Windows, `$os['hardware'] = x86_64`

On Windows, the value of the hardware fact (`os.hardware`) has changed from "x64" to "x86_64" for 64-bit Windows editions. We did this to make Windows consistent with other operating systems. The `architecture` fact is still "x64" as it represents the platform-specific name for the system architecture.

- [FACT-610](https://tickets.puppetlabs.com/browse/FACT-610)

### REGRESSION / BREAK (fixed in 3.0.2): Hostname missing from the `fqdn` fact

When reporting the `fqdn` fact, Facter 3.0.0 does not report the hostname. This is resolved in Facter 3.0.2.

- [FACT-1077](https://tickets.puppetlabs.com/browse/FACT-1077)
- [FACT-1078](https://tickets.puppetlabs.com/browse/FACT-1078)

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

Some of these facts contain new information about the node, and some are structured improvements on facts that were already present in Facter 2.x. Please see the [core facts reference](./core_facts.html) for details.

- [CFACT-154](https://tickets.puppetlabs.com/browse/CFACT-154)

### Better Docs for Core Facts

We've improved the [core facts reference](./core_facts.html) to include:

* The data type for every fact.
* Info about the name and data type for every member of map/hash facts.
* Whether the fact is included in Facter's command-line output.

### REGRESSION (fixed in 3.0.2): Facter Uses Too Much Memory

Facter 3.0.0 consumes more memory than is necessary when starting `puppetserver`, causing stability or performance issues on systems with little RAM. This is resolved in Facter 3.0.2.

- [FACT-1083](https://tickets.puppetlabs.com/browse/FACT-1083)

### SPEED

The whole point of rewriting Facter in C++ was to make everything faster, and Facter 3.0 delivers in spades. It's noticeable everywhere, but especially impressive on Windows.
