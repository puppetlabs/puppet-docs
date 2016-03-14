---
layout: default
title: "Other Deprecated Features"
---


[main manifest]: ./dirs_manifest.html
[puppet.conf]: ./config_file_main.html
[config file environments]: ./environments_classic.html
[environment config sections]: ./environments_classic.html#environment-config-sections
[manifest_setting]: ./configuration.html#manifest
[modulepath_setting]: ./configuration.html#modulepath
[config_version]: ./configuration.html#configversion
[directory environments]: ./environments.html
[puppet-dev]: https://groups.google.com/forum/#!forum/puppet-dev

The following miscellaneous features of Puppet are deprecated, and will be removed in Puppet 4.0.


## Config File Environments

### Now

You can use [config file environments][] by using [environment config sections][] or using special values for the [`manifest`][manifest_setting], [`modulepath`][modulepath_setting], and [`config_version`][config_version] settings.

### In Puppet 4.0

The `manifest`, `modulepath`, and `config_version` settings are not allowed in [puppet.conf][]. Environment config sections are not allowed either.

### Detecting and Updating

If you are using config file environments, your Puppet masters will log deprecation warnings about it.

Read the page on [config file environments][], and remove the relevant settings and sections from puppet.conf on your Puppet masters. Then, switch to using [directory environments][].

### Context

The best way to manage environments was unnecessarily complicated and indirect when using config file environments, so we designed directory environments to make that use case simpler.


## Non-Recursive Main Manifest Directory Loading

### Now

If the [main manifest][] is set to a directory, Puppet will only load the first level of manifest files in it, ignoring any subdirectories.

### In Puppet 4.0

Puppet will load manifests from all subdirectories of the main manifest.

### Detecting and Updating

Check your [main manifest][] directory and see if there are any subdirectories.

You can see the effects of this change early by setting `parser = future` in [puppet.conf][] on your Puppet master(s).

### Context

This didn't make the initial implementation of main manifest directories. Once we decided to add it, we determined that it was a big enough change to wait for 4.0.

* [PUP-2711: The manifests directory should be recursively loaded when using directory environments](https://tickets.puppetlabs.com/browse/PUP-2711)


## The Modulefile

### Now

If you are using Modulefile for metadata in your modules, its contents will be merged with the metadata.json file during the build process. Only the metadata.json file is used by the Puppet Forge, and we encourage you to remove the Modulefile after building your module.

### In the Future

The metadata.json file will eventually be the only valid source of module metadata. We haven't yet decided when we'll remove Modulefile support.

### Detecting and Updating

Look for a file named Modulefile in the modules you publish. If any of them contain one, you can convert it to a metadata.json file by doing the following:

* Run `puppet module build <MODULE DIRECTORY>` once.
* Delete the Modulefile.
* Check the updated metadata.json file into version control.

### Context

A lot of different tools interact with Puppet modules, and some of them aren't Ruby-based. This makes the Modulefile a poor data format, since it contains raw Ruby code that must be evaluated in order to read it. Plain JSON is much safer and friendlier.


## The Hidden `_timestamp` Fact

### Now

Puppet agent adds a hidden fact named `_timestamp` to its request to the Puppet master, and manifests and extensions can access its value. (Puppet apply does not add this fact.)

### In Puppet 4.0

The `_timestamp` fact is gone.

### Detecting and Updating

Puppet **will not** log deprecation warnings if you are using this fact, but you are almost definitely not using this fact. If you want to check, you can search every text file in your modules for the string `_timestamp`. If you are using it, you'll have to write a custom fact that has a similar value.

### Context

Almost nobody knew this existed, its behavior wasn't specified, and it was implemented in a weird way.

* [PUP-3129: Deprecate hidden _timestamp fact](https://tickets.puppetlabs.com/browse/PUP-3129)


## The Instrumentation System

### Now

Puppet includes an instrumentation system, which as far as we can tell is not used anywhere.

### In Puppet 4.0

The instrumentation system will be removed. This includes the `instrumentation_data`, `instrumentation_listener`, and `instrumentation_probe` subcommands.

### Detecting and Updating

If you're using the instrumentation system for something, you'll have to stop. Also, please send a note to [puppet-dev][] so we can find out more about what you're doing and how to support it better.

### Context

* [PUP-586: Deprecate Instrumentation system](https://tickets.puppetlabs.com/browse/PUP-586)
