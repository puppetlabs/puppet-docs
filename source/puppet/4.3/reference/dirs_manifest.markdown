---
layout: default
title: "Directories: The Main Manifest(s)"
canonical: "/puppet/latest/reference/dirs_manifest.html"
---

[environment]: ./environments.html
[catalog_compilation]: ./subsystem_catalog_compilation.html
[confdir]: ./dirs_confdir.html
[manifest_setting]: /references/4.2.latest/configuration.html#manifest
[print_settings]: ./config_print.html
[enc]: /guides/external_nodes.html
[default_manifest]: /references/4.2.latest/configuration.html#defaultmanifest
[disable_per_environment_manifest]: /references/4.2.latest/configuration.html#disableperenvironmentmanifest
[environment.conf]: ./config_file_environment.html
[puppet.conf]: ./config_file_main.html
[configuring environments]: ./environments_configuring.html
[creating environments]: ./environments_creating.html


Puppet always starts compiling with either a single manifest file or a directory of manifests that get treated like a single file. This main starting point is called the **main manifest** or **site manifest.**

For more information on how the site manifest is used in catalog compilation, see [the reference page on catalog compilation.][catalog_compilation]

Location
-----

### With Puppet Apply

The `puppet apply` command requires a manifest as an argument on the command line. (For example: `puppet apply /etc/puppetlabs/puppet/manifests/site.pp`.) It may be a single file or a directory of files.

Puppet apply does not use the manifest from an environment; it always uses the manifest given on the CLI.

### With Puppet Master

Puppet master always uses the main manifest set by the current node's [environment][]. The main manifest may be a single file or a directory of `.pp` files.

By default, the main manifest for a given environment is `<ENVIRONMENTS DIRECTORY>/<ENVIRONMENT>/manifests`. (For example: `/etc/puppetlabs/code/environments/production/manifests`.) You can configure the manifest per-environment, and you can also configure the default for all environments.

* An environment can use the `manifest` setting in [environment.conf][] to choose its main manifest. This can be an absolute path or a path relative to the environment's main directory. If absent, it defaults to the value of [the `default_manifest` setting][default_manifest] from [puppet.conf][].
* [The `default_manifest` setting][default_manifest] defaults to `./manifests`. Like the `manifest` setting, the value of `default_manifest` can be an absolute path or a path relative to the environment's main directory.
* You can also force all environments to use the `default_manifest` (ignoring their own `manifest` settings) by setting [`disable_per_environment_manifest = true`][disable_per_environment_manifest] in puppet.conf.

For more details, see:

* [Configuring Environments][]
* [Creating Environments][]

To check the actual manifest your Puppet master will use for a given environment, [run `puppet config print manifest --section master --environment <ENVIRONMENT>`][print_settings].



Directory Behavior (vs. Single File)
-----

If the main manifest is a directory, Puppet will parse every `.pp` file in the directory in alphabetical order and then evaluate the combined manifest. It will descend into all subdirectories of the manifest dir, and load files in depth-first order. (For example, if the manifest directory contains a directory named `01` and a file named `02.pp`, it will parse all the files in `01` before `02`.)

Puppet will act as though the whole directory were just one big manifest; for example, a variable assigned in the file `01_all_nodes.pp` would be accessible in `node_web01.pp`.

