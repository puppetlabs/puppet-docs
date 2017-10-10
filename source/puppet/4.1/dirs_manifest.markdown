---
layout: default
title: "Directories: The Main Manifest(s)"
canonical: "/puppet/latest/dirs_manifest.html"
---

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
[configuring environments]: ./environments_configuring.html
[creating environments]: ./environments_creating.html

Puppet always starts compiling with either a single manifest file or a directory of manifests that get treated like a single file. This main starting point is called the **main manifest** or **site manifest.**

For more information on how the site manifest is used in catalog compilation, see [the reference page on catalog compilation][catalog_compilation].

## Location

### With Puppet Apply

The `puppet apply` command requires a manifest as an argument on the command line. (For example: `puppet apply /etc/puppetlabs/code/environments/production/manifests/site.pp`.) It can be a single file or a directory of files.

The `puppet apply` command does not automatically use an environment's manifest. Instead, it always uses the manifest you pass to it.

### With Puppet Master

Puppet master always uses the main manifest set by the current node's [environment][]. The main manifest can be a single file or a directory of `.pp` files.

Each environment can configure its own main manifest with the `manifest` setting in [environment.conf][]. (You can disable this ability with [the `disable_per_environment_manifest` setting][disable_per_environment_manifest].)

Any environment that doesn't set a manifest in its config file will use [the `default_manifest` setting][default_manifest] from [puppet.conf][]. Like the `manifest` setting in [environment.conf][], the value of `default_manifest` can be an absolute or relative path. If it's a relative path, Puppet will resolve it relative to each environment's main directory.

Since the default value of `default_manifest` is `./manifests`, the default main manifest for an environment is `<ENVIRONMENTS DIRECTORY>/<ENVIRONMENT NAME>/manifests`. (For example: `/etc/puppetlabs/code/environments/production/manifests`.)

For more details, see:

* [Configuring Environments][]
* [Creating Environments][]

To check the manifest your Puppet master will use for a given environment, [run `puppet config print manifest --section master --environment <ENVIRONMENT>`][print_settings].

## Directory Behavior (vs. Single File)

If the main manifest is a directory, Puppet parses every `.pp` file in the directory in alphabetical order and evaluate the combined manifest. It descends into all subdirectories of the manifest directory and loads files in depth-first order. (For example, if the manifest directory contains a directory named `01` and a file named `02.pp`, it will parse all the files in `01` before `02`.)

Puppet acts as though the whole directory were just one big manifest; for example, a variable assigned in the file `01_all_nodes.pp` would be accessible in `node_web01.pp`.
