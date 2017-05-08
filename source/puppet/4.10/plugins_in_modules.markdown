---
title: Plugins in Modules
---

[modules]: ./modules_fundamentals.html
[environment]: ./environments.html
[modulepath]: ./dirs_modulepath.html
[external facts]: {{facter}}/custom_facts.html#external-facts
[vardir]: ./dirs_vardir.html
[custom facts]: {{facter}}/custom_facts.html
[custom resource types and providers]: /guides/custom_types.html
[ruby_functions]: /guides/custom_functions.html
[puppet_functions]: ./lang_write_functions_in_puppet.html
[custom augeas lenses]: https://github.com/hercules-team/augeas/wiki/Create-a-lens-from-bottom-to-top


Puppet supports several kinds of **plugins,** which can be distributed in [modules][].

These plugins enable new features for managing your nodes. Plugins are often included in modules downloaded from the Puppet Forge, and you can also develop your own.

## Installing plugins

Plugins are automatically enabled when you install the module that contains them. You don't have to do anything else: once a module is installed in an [environment][]'s [modulepath][], its plugins are available when managing nodes in that environment.

### Auto-download of agent-side plugins (pluginsync)

Some plugins are used by Puppet Server, which can load them directly from modules. But other plugins (facts, custom resource types and providers) are used by Puppet agent, which doesn't have direct access to the server's modules.

To enable this, Puppet agent automatically downloads plugins from the server at the start of each agent run. Those plugins are then available during the run.

Puppet agent syncs plugin files from _every_ module in its environment's [modulepath][], regardless of whether that node uses any classes from a given module. (In other words: even if you don't declare any classes from the `stdlib` module, nodes will still use `stdlib`'s custom facts.)

#### Technical details of pluginsync

Pluginsync takes advantage of the same file serving features used by the `file` resource type.

Puppet Server creates two special file server mount points for pluginsync, and populates them with the aggregate contents of certain subdirectories of modules. Before doing an agent run, Puppet agent recursively manages the contents of those mount points into two cache directories on disk. This uses the same machinery as the `source` attribute in classic (non-static-catalog) recursive `file` resources: the agent does a GET request to `/puppet/v3/file_metadatas/<MOUNT POINT>`, compares the resulting checksums and ownership info to local files, deletes any unmanaged files, retrieves content data for any missing or out-of-date files, and sets permissions as needed.

The following table shows the corresponding module subdirectories, mount points, and agent-side directories for each kind of plugin:

Plugin type        | Module subdirectory | Mount point   | Agent directory
-------------------|---------------------|---------------|----------------------------------------
[External facts][] | `<MODULE>/facts.d`  | `pluginfacts` | `<VARDIR>/facts.d`
Ruby plugins       | `<MODULE>/lib`      | `plugins`     | `<VARDIR>/lib`

(`<VARDIR>` is Puppet agent's [cache directory][vardir], which is located at `/var/opt/puppetlabs/puppet/cache`, `%PROGRAMDATA%\PuppetLabs\puppet\cache`, or `~/.puppetlabs/opt/puppet/cache`.)


## Types of plugins

Puppet supports several kinds of plugins:

* [Custom facts][] (written in Ruby).
* [External facts][] (executable scripts or static data).
* [Custom resource types and providers][] (written in Ruby).
* [Custom functions written in Ruby][ruby_functions].
* [Custom functions written in the Puppet language][puppet_functions].
* [Custom Augeas lenses][].
* Miscellaneous utility Ruby code used by other plugins.

Facts and Augeas lenses are used solely by Puppet agent. Functions are used solely by Puppet Server. Resource types and providers are used by both. (Note that Puppet apply acts as both agent and server.)

## Adding plugins to a module

To add plugins to a module, put them in the following directories:

Type of plugin                                           | Module subdirectory
---------------------------------------------------------|------------------------------
Facts                                                    | `lib/facter`
Functions (Ruby, modern `Puppet::Functions` API)         | `lib/puppet/functions`
Functions (Ruby, legacy `Puppet::Parser::Functions` API) | `lib/puppet/parser/functions`
Functions (Puppet language)                              | `functions`
Resource types                                           | `lib/puppet/type`
Resource providers                                       | `lib/puppet/provider`
External facts                                           | `facts.d`
Augeas lenses                                            | `lib/augeas/lenses`

In all cases, you must name files and additional subdirectories according to the plugin type's loading requirements.

To illustrate, a module that included every type of plugin would have a directory structure like this:

* `mymodule` (the module's top-level directory; this module is named `mymodule`.)
    * `lib`
        * `facter`
            * `my_custom_fact.rb`
        * `puppet`
            * `functions`
                * `modern_function.rb`
            * `parser`
                * `functions`
                    * `classic_function.rb`
            * `type`
                * `mymodule_instance.rb`
            * `provider`
                * `exec`
                    * `powershell.rb`
        * `augeas`
            * `lenses`
                * `custom.lns`
    * `functions`
        * `convertdata.pp` (contains a function named `mymodule::convertdata`.)
    * `facts.d`
        * `datacenter.py` (an executable script that returns fact data.)


## Issues with server-side plugins

If you encounter problems with conflicting versions of the same plugin in different environments, you can fix these issues as described below.

Environments aren't completely isolated for certain kinds of plugins. If a plugin of the same name exists in different versions in multiple environments, Puppet loads the plugin from the first environment to use that plugin, then continues to use that version of the plugin for all subsequent environments.

This issue can occur with the following plugin types:

* Custom resource types. To avoid resource type conflicts, use the `puppet generate types` command as described in [environment isolation](./environment_isolation.html) documentation.
* Custom functions, only with the legacy `Puppet::Parser::Functions` API. To fix the issue, rewrite functions with the modern API, which is not affected by this issue.

