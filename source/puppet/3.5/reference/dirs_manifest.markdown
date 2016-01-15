---
layout: default
title: "Directories: The Main Manifest(s)"
canonical: "/puppet/latest/reference/dirs_manifest.html"
---


[import_deprecation]: ./lang_import.html

[environment]: ./environments.html
[catalog_compilation]: ./subsystem_catalog_compilation.html
[confdir]: ./dirs_confdir.html
[manifest_setting]: ./configuration.html#manifest
[print_settings]: ./config_print.html
[enc]: /guides/external_nodes.html
[environmentpath]: ./configuration.html#environmentpath
[classic_environments]: ./environments_classic.html

Puppet always starts compiling with either a single manifest file or a directory of manifests that get treated like a single file. This main starting point is called the **main manifest** or **site manifest.**

For more information on how the site manifest is used in catalog compilation, see [the reference page on catalog compilation.][catalog_compilation]

Location
-----

### With Puppet Master

* When using no environments, the main manifest will default to `$confdir/manifests/site.pp`, which is a single file. ([See here for info about the confdir][confdir].) This location can be configured with the [`manifest` setting][manifest_setting].
* If you are using [directory environments][environment], the main manifest will always be `$confdir/environments/<ENVIRONMENT NAME>/manifests`, which is a directory. The location of the environments directory can be configured with the [`environmentpath` setting][environmentpath]; see [the page about directory environments][environment] for more details.
* If you are using [config file environments][classic_environments], Puppet will look for a `manifest` setting in that environment's config section; if it isn't set there, Puppet will fall back to the `manifest` setting in the `[master]` or `[main]` section. See [the page about config file environments][classic_environments] for more details.

The main manifest may be a single file or a directory of `.pp` files. To check the actual manifest your puppet master will use, [run `puppet config print manifest --section master --environment <ENVIRONMENT>`][print_settings].

> **Recommended:** If you're using the main manifest heavily instead of relying on an [ENC][], consider changing the `manifest` setting to `$confdir/manifests`. This lets you split up your top-level code into multiple files while [avoiding the `import` keyword][import_deprecation]. It will also match the behavior of [simple environments][environment].

> **Bug warning:**  [PUP-1944](https://tickets.puppetlabs.com/browse/PUP-1944) --- In Puppet 3.5.0-rc1, the puppet master will malfunction if the value of the `manifest` setting is a directory but doesn't exactly match the (otherwise unused) `manifestdir` setting.


### With Puppet Apply

The puppet apply command requires a manifest as an argument on the command line. (For example: `puppet apply /etc/puppetlabs/puppet/manifests/site.pp`.) It may be a single file or a directory of files.

Puppet apply does not use the `manifest` setting or environment-specific manifests; it always uses the manifest given on the CLI.

Directory Behavior (vs. Single File)
-----

If the main manifest is a directory, Puppet will parse every `.pp` file in the directory in alphabetical order and then evaluate the combined manifest.

Puppet will act as though the whole directory were just one big manifest; for example, a variable assigned in the file `01_all_nodes.pp` would be accessible in `node_web01.pp`.

Puppet will only read **the first level of files** in a manifest directory; it won't descend into subdirectories.

