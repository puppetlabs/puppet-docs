---
layout: default
title: "Directories: The Modulepath (Default Config)"
canonical: "/puppet/latest/dirs_modulepath.html"
---

[module_fundamentals]: ./modules_fundamentals.html
[environments]: ./environments.html
[env_modules]: ./environments.html#setting-up-environments-on-a-puppet-master
[confdir]: ./dirs_confdir.html
[basemodulepath_setting]: ./configuration.html#basemodulepath
[modulepath_setting]: ./configuration.html#modulepath
[config_print]: ./config_print.html
[enable_dir_envs]: ./environments.html#enabling-directory-environments
[puppet.conf]: ./config_file_main.html
[environment.conf]: ./config_file_environment.html

The Puppet master service and the `puppet apply` command both load most of their content from modules. (See the page on [module structure and behavior][module_fundamentals] for more details.)

Puppet automatically loads modules from one or more directories. The list of directories Puppet will find modules in is called the **modulepath.**

The modulepath is set by the current node's [environment][environments].

## Format

`/etc/puppetlabs/code/environments/production/modules:/etc/puppetlabs/code/modules:/opt/puppetlabs/puppet/modules`

The modulepath is a list of directories separated by the system _path-separator character._ On \*nix systems, this is the colon (`:`, as seen above), and on Windows it is the semi-colon (`;`).

It is an ordered list, with earlier directories having priority over later ones. See ["Loading Content from Modules"][inpage_loading] below.

## Contents

Every directory in the modulepath should only contain valid Puppet modules.

The names of those modules must only contain letters, numbers, and underscores. Dashes and periods are **no longer valid** and cause errors when attempting to use the module.

For details about module contents and structure, see [the documentation on modules][module_fundamentals].

## Location

The modulepath is set by the current node's [environment][environments]. By default, it is usually something like:

`<ACTIVE ENVIRONMENT'S MODULES DIRECTORY>:$codedir/modules:/opt/puppetlabs/puppet/modules`

You can view the effective modulepath for any environment by specifying the environment when [requesting the setting value][config_print]:

~~~ bash
sudo puppet config print modulepath --section master --environment test
/etc/puppetlabs/code/environments/test/modules:/etc/puppetlabs/code/modules:/usr/share/puppet/modules
~~~

## Configuration

Each environment can set its full modulepath in [environment.conf][] with the `modulepath` setting. The default value is that environment's `modules` directory followed by the **base modulepath.**

When running `puppet apply` on the command line, you also have the option of directly setting the modulepath with the `--modulepath` flag.

### The `modulepath` Setting

The `modulepath` setting can only be set in [environment.conf][]. It configures the entire modulepath for that environment.

The default value of `modulepath` is `./modules:$basemodulepath`.

Note that the modulepath can include relative paths, such as `./modules` or `./site`. Puppet looks for these paths inside the environment's directory.

If you want an environment to have access to the global module directories, it should include `$basemodulepath`.

### The Base Modulepath

The **base modulepath** is a list of _global_ module directories for use with all [environments][]. It can be configured with [the `basemodulepath` setting][basemodulepath_setting], but its default value is probably suitable for you unless you're doing something unusual.

The default value of the `basemodulepath` setting is `$codedir/modules:/opt/puppetlabs/puppet/modules`. (On Windows, it will just use `$codedir\modules`.)

### Using `--modulepath`

When running `puppet apply`, you can supply a full modulepath as a command line option. This overrides the modulepath from the current environment.

## Loading Content from Modules

[inpage_loading]: #loading-content-from-modules

Puppet uses modules from every directory in the modulepath.

### Empty and Absent Directories

Directories in the modulepath can be empty, and might even be absent. In both cases, this is not an error; it just means Puppet does not load modules from those directories.

If no modules are present across the entire modulepath, or if modules are present but none of them contains a `lib` directory, then Puppet agent will log an error when attempting to sync plugins from the Puppet master. This error is benign and will not prevent the rest of the Puppet run.

### Duplicate or Conflicting Modules and Content

If the modulepath contains multiple modules with the same name, Puppet uses the version from the directory that comes _earliest_ in the modulepath. This allows directories earlier in the modulepath to override later directories.

For most content, this earliest-module-wins behavior is on an all-or-nothing, **per-module** basis --- **all** of the manifests, files, and templates in the winning version will be available for use, and **none* of that content from any subsequent versions will be available. This behavior covers:

- Puppet code (from `manifests`)
- Files (from `files`)
- Templates (from `templates`)
- External facts (from `facts.d`)
- Ruby plugins synced to agent nodes (from `lib`)

> **However,** Puppet occasionally shows problematic behavior with **Ruby plugins loaded directly from modules.** This includes:
>
> - Plugins used by the Puppet master (custom resource types, custom functions)
> - Plugins used by `puppet apply`
> - Plugins that happen to be present in Puppet agent's modulepath (which should generally be empty, but may not be when running Puppet agent on a node that is also a Puppet master server)
>
> With these plugins, the earlier module still wins, but the plugins are handled on a **per-file** basis instead of per-module. This means that if a duplicate module in a later directory has **additional** plugin files that don't exist in the winning module, those extra files will be loaded, and Puppet will use a mixture of files from the winning and duplicate modules.
>
> The upshot is, if you refactor a module's Ruby plugins and then maintain two versions of that module in your modulepath, it can sometimes result in weirdness.
>
> This is essentially the same Ruby loading problem that environments have, [as described elsewhere in this manual](./environments_limitations.html#plugins-running-on-the-puppet-master-are-weird). It's not intentional, but it's not likely to get fixed soon, since it's a byproduct of the way Ruby works and Puppet only has a limited amount of control over it.