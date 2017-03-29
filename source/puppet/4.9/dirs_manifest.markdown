---
layout: default
title: "Directories: The main manifest(s)"
---

[environment]: ./environments.html
[catalog_compilation]: ./subsystem_catalog_compilation.html
[confdir]: ./dirs_confdir.html
[manifest_setting]: ./configuration.html#manifest
[print_settings]: ./config_print.html
[enc]: ./nodes_external.html
[default_manifest]: ./configuration.html#defaultmanifest
[disable_per_environment_manifest]: ./configuration.html#disableperenvironmentmanifest
[environment.conf]: ./config_file_environment.html
[puppet.conf]: ./config_file_main.html
[configuring environments]: ./environments_configuring.html
[creating environments]: ./environments_creating.html

Puppet always starts compiling with either a single manifest file or a directory of manifests that get treated like a single file. This main starting point is called the **main manifest** or **site manifest.**

For more information on how the site manifest is used in catalog compilation, see [the reference page on catalog compilation][catalog_compilation].

## Location

### With Puppet apply

The `puppet apply` command requires a manifest as an argument on the command line. (For example: `puppet apply /etc/puppetlabs/code/environments/production/manifests/site.pp`.) It can be a single file or a directory of files.

The `puppet apply` command does not automatically use an environment's manifest. Instead, it always uses the manifest you pass to it.

### With Puppet master

Puppet master always uses the main manifest set by the current node's [environment][]. The main manifest can be a single file or a directory of `.pp` files.

By default, the main manifest for a given environment is `<ENVIRONMENTS DIRECTORY>/<ENVIRONMENT>/manifests`. (For example: `/etc/puppetlabs/code/environments/production/manifests`.) You can configure the manifest per-environment, and you can also configure the default for all environments.

* An environment can use the `manifest` setting in [environment.conf][] to choose its main manifest. This can be an absolute path or a path relative to the environment's main directory. If absent, it defaults to the value of [the `default_manifest` setting][default_manifest] from [puppet.conf][].
* [The `default_manifest` setting][default_manifest] defaults to `./manifests`. Like the `manifest` setting, the value of `default_manifest` can be an absolute path or a path relative to the environment's main directory.
* You can also force all environments to use the `default_manifest` (ignoring their own `manifest` settings) by setting [`disable_per_environment_manifest = true`][disable_per_environment_manifest] in puppet.conf.

For more details, see:

* [Configuring Environments][]
* [Creating Environments][]

To check the manifest your Puppet master will use for a given environment, [run `puppet config print manifest --section master --environment <ENVIRONMENT>`][print_settings].

## Directory behavior (vs. single file)

If the main manifest is a directory, Puppet parses every `.pp` file in the directory in alphabetical order and evaluate the combined manifest. It descends into all subdirectories of the manifest directory and loads files in depth-first order. (For example, if the manifest directory contains a directory named `01` and a file named `02.pp`, it will parse all the files in `01` before `02`.)

Puppet acts as though the whole directory were just one big manifest; for example, a variable assigned in the file `01_all_nodes.pp` would be accessible in `node_web01.pp`.
