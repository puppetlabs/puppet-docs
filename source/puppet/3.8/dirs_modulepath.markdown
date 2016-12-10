---
layout: default
title: "Directories: The Modulepath (Default Config)"
---

[module_fundamentals]: ./modules_fundamentals.html
[config file environments]: ./environments_classic.html
[directory environments]: ./environments.html
[env_modules]: ./environments.html#setting-up-environments-on-a-puppet-master
[confdir]: ./dirs_confdir.html
[basemodulepath_setting]: ./configuration.html#basemodulepath
[modulepath_setting]: ./configuration.html#modulepath
[environment config sections]: ./environments_classic.html#environment-config-sections
[dynamic environments]: ./environments_classic.html#dynamic-environments
[config_print]: ./config_print.html
[enable_dir_envs]: ./environments.html#enabling-directory-environments
[puppet.conf]: ./config_file_main.html
[environment.conf]: ./config_file_environment.html

The Puppet master service and the Puppet apply command both load most of their content from modules. (See the page on [module structure and behavior][module_fundamentals] for more details.)

Puppet automatically loads modules from one or more directories. The list of directories Puppet will find modules in is called the **modulepath.**

## Format

`/etc/puppet/modules:/usr/share/puppet/modules`

The modulepath is a list of directories separated by the system _path-separator character._ On \*nix systems this is the colon (`:`, as seen above), and on Windows it is the semi-colon (`;`).

It is an ordered list, with earlier directories having priority over later ones. See ["Loading Content from Modules"][inpage_loading] below.

## Contents

Every directory in the modulepath should only contain valid Puppet modules.

For details about module contents and structure, see [the documentation on modules][module_fundamentals].

## Location

By default, the modulepath will usually be something like:

`<ACTIVE ENVIRONMENT'S MODULES DIRECTORY>:$confdir/modules:<SYSTEM MODULES DIRECTORY>`

The location of the modulepath is configured differently, depending on whether [directory environments][] are enabled:

Configuration                                   | Location of modulepath
------------------------------------------------|-----------------------
[Config file environments][] or no environments | Value of `modulepath` setting from [puppet.conf][] (defaults to the **base modulepath**)
[Directory environments][]                      | Value of `modulepath` setting from [environment.conf][] (defaults to the active environment's [`modules` directory][env_modules] plus the **base modulepath**)

You can view the effective modulepath for any environment by specifying the environment when [requesting the setting value][config_print]:

    $ sudo puppet config print modulepath --section master --environment test
    /etc/puppet/environments/test/modules:/etc/puppet/modules:/usr/share/puppet/modules

### The Base Modulepath

The **base modulepath** is a list of global module directories for use with all [directory environments][]. It also serves as the default value for the `modulepath` setting, which is used when directory environments are disabled. It can be configured with [the `basemodulepath` setting][basemodulepath_setting], but its default value is probably suitable for you unless you're doing something unusual.

The default value of the `basemodulepath` setting depends on your OS and the distribution of Puppet in use. This table lists the default `basemodulepath` values.

Note that all default values include `$confdir/modules`; [see here for info about the confdir][confdir].

OS and Distro             | Default Base Modulepath
--------------------------|----------------------------------------------------
\*nix (Puppet Enterprise) | `$confdir/modules:/opt/puppet/share/puppet/modules`
\*nix (open source)       | `$confdir/modules:/usr/share/puppet/modules`
Windows (PE and FOSS)     | `$confdir\modules`

### Examples of Default Modulepaths

Default settings for a new installation of Puppet Enterprise 3.8 and higher:

`/etc/puppetlabs/puppet/environments/production/modules:/opt/puppet/share/puppet/modules`

Default settings for Puppet Enterprise 3.3 and lower or upgrades to Puppet Enterprise 3.8:

`/etc/puppetlabs/puppet/modules:/opt/puppet/share/puppet/modules`

Open source Puppet, directory environments [enabled][enable_dir_envs] with `environmentpath = $confdir/environments`, active environment is `dev`:

`/etc/puppet/environments/dev/modules:/etc/puppet/modules:/usr/share/puppet/modules`


### Configuring the Modulepath

* If you are not using environments, you can directly configure the modulepath with [the `modulepath` setting][modulepath_setting]. This should generally be set in the `[main]` section of puppet.conf, so it can be used by all commands and services.
* If you are using [directory environments][], the first element of the modulepath will always be the active environment's `modules` directory. However, you can configure global module directories with the `basemodulepath` setting (see above). This should generally be set in the `[main]` section of puppet.conf.
* If you are using [environment config sections][], you can set `modulepath` in each environment's section of puppet.conf. If that setting is absent in a given environment, Puppet will fall back to the global value of the `modulepath` setting.
* If you are using [dynamic environments][], you can set the `modulepath` setting in `[main]` and use the `$environment` variable in some of the directory names.


## Loading Content from Modules

[inpage_loading]: #loading-content-from-modules

Puppet will use modules from every directory in the modulepath.

### Empty and Absent Directories

Directories in the modulepath may be empty, and may even be absent. In both cases, this is not an error; it just means no modules will be loaded from that directory.

If no modules are present across the entire modulepath, or if modules are present but none of them contains a `lib` directory, then Puppet agent will log an error when attempting to sync plugins from the Puppet master. This error is benign and will not prevent the rest of the Puppet run.

### Duplicate or Conflicting Modules and Content

If the modulepath contains multiple modules with the same name, Puppet will use the version from the directory that comes _earliest_ in the modulepath. This allows directories earlier in the modulepath to override the later directories.

For most content, this earliest-module-wins behavior is on an all-or-nothing, **per-module** basis --- **all** of the manifests, files, and templates in the winning version will be available for use, and **none* of that content from any subsequent versions will be available. This behavior covers:

- Puppet code (from `manifests`)
- Files (from `files`)
- Templates (from `templates`)
- External facts (from `facts.d`)
- Ruby plugins synced to agent nodes (from `lib`)

> **However,** Puppet occasionally shows problematic behavior with **Ruby plugins loaded directly from modules.** This includes:
>
> - Plugins used by the Puppet master (custom resource types, custom functions)
> - Plugins used by Puppet apply
> - Plugins that happen to be present in Puppet agent's modulepath (which should generally be empty, but may not be when running Puppet agent on a node that is also a Puppet master server)
>
> With these plugins, the earlier module still wins, but the plugins are handled on a **per-file** basis instead of per-module. This means that if a duplicate module in a later directory has **additional** plugin files that don't exist in the winning module, those extra files will be loaded, and Puppet will use a mixture of files from the winning and duplicate modules.
>
> The upshot is, if you do a major refactor of the Ruby plugins in some module and then maintain two versions of that module in your modulepath, it can sometimes result in weirdness.
>
> This is essentially the same Ruby loading problem that environments have, [as described elsewhere in this manual.](./environments_limitations.html#plugins-running-on-the-puppet-master-are-weird) It's not intentional, but it's not likely to get fixed soon, since it's a byproduct of the way Ruby works and Puppet only has a limited amount of control over it.

