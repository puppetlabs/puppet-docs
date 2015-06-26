---
layout: default
title: "Facter 3.0: Release Notes"
---

This page documents the history of the Facter 3.0 series. (Previous version: [Facter 2.4 release notes](../2.4/release_notes.html).)


Facter 3.0.0
-----

Released June 24, 2015.

Shipped in puppet-agent version: 1.2.0.

Facter 3.0.0 is a complete rewrite of Facter in C++. Prior to this release, it was available separately as `cfacter`, and could be enabled in Puppet by setting `cfacter = true` in puppet.conf.

This rewrite is essentially a drop-in replacement for the Ruby-based Facter 2.x. It still supports custom facts written in Ruby with the existing Facter API, as well as external facts written in any number of languages.

It does include a few breaking changes relative to Facter 2.4, but these are very minor.

* [All tickets fixed in 3.0.0](https://tickets.puppetlabs.com/issues/?filter=14556)
* [Issues introduced in 3.0.0](https://tickets.puppetlabs.com/issues/?filter=14557)

### BREAK: Removed Seven Obscure Facts

The following facts are not supported in Facter 3.0.0:

* `ps`
* `uniqueid`
* `dir`
* `cfkey`
* `puppetversion` (still available in Puppet)
* `vlans`
* `xendomains`

`ps` was only used by Puppet, and we updated Puppet to no longer need it. `uniqueid` was a lie in the first place, and wasn't widely used. `dir` had been added accidentally in Windows, because the `FACTER_DIR` environment variable was set. `cfkey` was from a different tiiiiiime, man. `vlans` and `xendomains` weren't used widely enough to justify bringing them forward.

`puppetversion` introduced a circular dependency, and shouldn't have been in Facter's core in the first place. We moved it into Puppet (implemented as an always-available custom fact), and other custom facts can take advantage of it if they're also running via Puppet.

- [CFACT-151](https://tickets.puppetlabs.com/browse/CFACT-151)

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

### SPEED

The whole point of rewriting Facter in C++ was to make everything faster, and Facter 3.0 delivers in spades. It's noticeable everywhere, but especially impressive on Windows.
