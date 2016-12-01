---
layout: default
title: "Directories: The Main Manifest(s)"
canonical: "/puppet/latest/reference/dirs_manifest.html"
---

[import_deprecation]: ./lang_import.html#deprecation-notice
[environment]: ./environments.html
[catalog_compilation]: ./subsystem_catalog_compilation.html
[confdir]: ./dirs_confdir.html
[manifest_setting]: ./configuration.html#manifest
[print_settings]: ./config_print.html
[enc]: /guides/external_nodes.html
[default_manifest]: ./configuration.html#defaultmanifest
[disable_per_environment_manifest]: ./configuration.html#disableperenvironmentmanifest
[environment.conf]: ./config_file_environment.html
[puppet.conf]: ./config_file_main.html
[configuring directory environments]: ./environments_configuring.html
[creating directory environments]: ./environments_creating.html


Puppet always starts compiling with either a single manifest file or a directory of manifests that get treated like a single file. This main starting point is called the **main manifest** or **site manifest.**

For more information on how the site manifest is used in catalog compilation, see [the reference page on catalog compilation.][catalog_compilation]

Location
-----

### With Puppet Apply

The `puppet apply` command requires a manifest as an argument on the command line. (For example: `puppet apply /etc/puppetlabs/puppet/manifests/site.pp`.) It may be a single file or a directory of files.

Puppet apply does not use the `manifest` setting or environment-specific manifests; it always uses the manifest given on the CLI.

### With Puppet Master

The location of the main manifest depends on how Puppet is configured. See the sections below for details.

To check the actual manifest your Puppet master will use for a given environment, [run `puppet config print manifest --section master --environment <ENVIRONMENT>`][print_settings].

The main manifest may be a single file or a directory of `.pp` files.

#### Directory Environments

Each [environment][] can configure its own main manifest with the `manifest` setting in [environment.conf][]. (You can disable this ability with [the `disable_per_environment_manifest` setting][disable_per_environment_manifest].)

Any environment that doesn't set a manifest in its config file will use [the `default_manifest` setting][default_manifest] from [puppet.conf][].

Like the `manifest` setting in [environment.conf][], the value of `default_manifest` can be an absolute or relative path. If it's a relative path, Puppet will resolve it relative to each environment's main directory.

Since the default value of `default_manifest` is `./manifests`, the default main manifest for a directory environment is `<ENVIRONMENTS DIRECTORY>/<ENVIRONMENT NAME>/manifests`. (For example: `/etc/puppetlabs/puppet/environments/production/manifests`.)

For more details, see:

* [Configuring Directory Environments][]
* [Creating Directory Environments][]

#### No Environments, or Config File Environments

If you haven't enabled directory environments, Puppet will use the value of [the `manifest` setting][manifest_setting] in `puppet.conf` as its main manifest. **Note that setting `manifest` in puppet.conf is deprecated,** and will not be possible in Puppet 4.0.

The `manifest` setting defaults to `$confdir/manifests/site.pp`, which is a single file. ([See the confdir documentation for more about the confdir.][confdir])


Directory Behavior (vs. Single File)
-----

If the main manifest is a directory, Puppet will parse every `.pp` file in the directory in alphabetical order and then evaluate the combined manifest.

Puppet will act as though the whole directory were just one big manifest; for example, a variable assigned in the file `01_all_nodes.pp` would be accessible in `node_web01.pp`.

* If [the `parser` setting][parser] is set to `current`, Puppet will only read **the first level of files** in a manifest directory; it **won't** descend into subdirectories.
* If you've set [`parser = future`][parser], Puppet **will** descend into all subdirectories of the manifest dir.

    Puppet will load files in depth-first order. (For example, if the manifest directory contains a directory named `01` and a file named `02.pp`, it will parse all the files in `01` before `02`.)

[parser]: ./configuration.html#parser

> **Recommended:** If you're using the main manifest heavily instead of relying on an [ENC][], consider changing the `manifest` setting to `$confdir/manifests`. This lets you split up your top-level code into multiple files while [avoiding the `import` keyword][import_deprecation]. It will also match the behavior of [directory environments][environment].

