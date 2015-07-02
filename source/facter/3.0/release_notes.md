---
layout: default
title: "Facter 3.0: Release Notes"
---

This page documents the history of the Facter 3.0 series. (Previous version: [Facter 2.4 release notes](../2.4/release_notes.html).)

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

### BREAK: Facter Doesn't Display Legacy Unstructured Facts with Structured Equivalents

Facter 2 introduced structured facts, and Facter 3.0.0 reprovisions many unstructured Puppet facts with new structured equivalents. Facter still tracks the legacy unstructured facts, and `puppet facts` still outputs these facts, but in Facter 3.0.0 these legacy facts no longer appear in the default command-line output. This might break workflows that rely on legacy facts appearing in Facter output.

For example, the new map-structured `os` fact describes several legacy operating system-related facts, such as `architecture` and `operatingsystem`.

Facts that no longer appear in command-line output are documented as such in [the list of core facts](./core_facts.html).

To display legacy facts on the command line with Facter 3, we recommend either using `puppet facts` or modifying Facter workflows to instead use the equivalent structured facts. Facter 3.0.2 will provide the `--show-legacy` flag that forces Facter to output deprecated legacy facts, which should be used only as an interim solution.

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

### REGRESSION (fixed in 3.0.2): Facter Redirects stderr to stdout

Facter 3.0.0 incorrectly redirects stderr output from the commands its runs to gather information to stdout, resulting in error messages that should not appear on the command line. This can also result in unexpectedly nullified output if any first command that Facter executes cannot be found.

- [FACT-1085](https://tickets.puppetlabs.com/browse/FACT-1085)

### BREAK: Facter Does Not Pass Commands' stderr Output to Puppet's stderr

In Facter 2.x, stderr output from commands that Facter executed would be redirected to Facter's stderr. This no longer occurs in Facter 3.x. 

Instead, use the `--debug` flag to display more details about Facter's operation, including error messages from commands that Facter executes.

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

### REGRESSION (Fixed in 3.0.2): `xendomains` Fact Removed

We unintentionally removed the `xendomains` fact in 3.0.0. This fact's functionality will return in 3.0.2.

- [FACT-867](https://tickets.puppetlabs.com/browse/FACT-867)

### BREAK: `:timeout` for Execution Replaces `:timeout` in Resolutions

You can no longer set the `:timeout` option when creating a new fact resolution. If a fact specifies a resolution timeout, Facter will raise a warning and ignore it.

Instead, specify `:timeout` when you call the `Facter::Core::Execution#execute` function. An execution timeout is the number of seconds to wait for the command's execution to complete. If the time elapses, a `Facter::Core::Execution::ExecutionFailure` exception will be raised.

For details and examples, see [the custom fact docs.](./custom_facts.html#execution-timeouts)

(This was necessary because there was no longer any safe way to implement timeouts of arbitrary Ruby code in a fact. Since timeouts were almost always used to protect against long-running external commands, the new interface should be just as useful, but you might need to update some facts.)

* [FACT-886: Expose a timeout option on the Ruby Facter API](https://tickets.puppetlabs.com/browse/FACT-886)
* [FACT-907: cfacter doesn't implement :timeout](https://tickets.puppetlabs.com/browse/FACT-907)

### BREAK: `facter -p` is Gone

Facter's command line interface no longer supports the `-p` option, because it introduced a circular dependency.

To inspect facts from modules and pluginsync, please use the `puppet facts` command instead.

### BREAK: On 64-bit Windows, `$os['hardware'] = x86_64`

On Windows, the value of the hardware fact (`os.hardware`) has changed from "x64" to "x86_64" for 64-bit Windows editions. We did this to make Windows consistent with other operating systems. The `architecture` fact is still "x64" as it represents the platform-specific name for the system architecture.

- [FACT-610](https://tickets.puppetlabs.com/browse/FACT-610)

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

### SPEED

The whole point of rewriting Facter in C++ was to make everything faster, and Facter 3.0 delivers in spades. It's noticeable everywhere, but especially impressive on Windows.
