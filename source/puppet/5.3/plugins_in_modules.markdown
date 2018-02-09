---
title: Plug-ins in Modules
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

Puppet supports several kinds of **plug-ins,** which can be distributed in modules. These plug-ins enable new features for managing your nodes. Plug-ins are often included in modules downloaded from the Puppet Forge, and you can also develop your own.

{:.concept}
## Installing plug-ins

Plug-ins are automatically enabled when you install the module that contains them. You don't have to do anything else: once a module is installed in an environment's modulepath, its plug-ins are available when managing nodes in that environment.

{:.concept}
### Auto-download of agent-side plug-ins (pluginsync)

Some plug-ins are used by Puppet Server, which can load them directly from modules. But other plug-ins (facts, custom resource types and providers) are used by Puppet agent, which doesn't have direct access to the server's modules.

To enable this, Puppet agent automatically downloads plug-ins from the server at the start of each agent run. Those plug-ins are then available during the run.

Puppet agent syncs plug-in files from _every_ module in its environment's modulepath, regardless of whether that node uses any classes from a given module, as well as any translations available for each module regardless of the agent's or master's locale.

In other words, even if you don't declare any classes from the `stdlib` module, nodes will still use `stdlib`'s custom facts. Also, even if your agent's locale is set to en-US, if the module has translations for other locales, the agent will download all of those translations.

> **Note:** Puppet 5.3.4 added pluginsync of module translations. Agents running Puppet 5.3.4 that connect to masters running older versions of Puppet do not automatically download translations.

{:.concept}
### Technical details of pluginsync

Pluginsync takes advantage of the same file serving features used by the `file` resource type.

Puppet Server creates special file server mount points for pluginsync, and populates them with the aggregate contents of certain subdirectories of modules. Before doing an agent run, Puppet agent recursively manages the contents of those mount points into cache directories on disk. The agent performs the following functions:

1. Sends GET requests to `/puppet/v3/file_metadatas/<MOUNT POINT>`,
2. Compares the resulting checksums and ownership info to local files,
3. Deletes any unmanaged files,
4. Retrieves content data for any missing or out-of-date files, and
5. Sets permissions as needed.

The following table shows the corresponding module subdirectories, mount points, and agent-side directories for each kind of plug-in, as well as module translations:

Plug-in type       | Module subdirectory | Mount point   | Agent directory
-------------------|---------------------|---------------|----------------------------------------
[External facts][] | `<MODULE>/facts.d`  | `pluginfacts` | `<VARDIR>/facts.d`
Ruby plug-ins      | `<MODULE>/lib`      | `plugins`     | `<VARDIR>/lib`
Translations       | `<MODULE>/locales`  | `locales`     | `<VARDIR>/locales`

(`<VARDIR>` is Puppet agent's [cache directory][vardir], which is located at `/var/opt/puppetlabs/puppet/cache`, `%PROGRAMDATA%\PuppetLabs\puppet\cache`, or `~/.puppetlabs/opt/puppet/cache`.)

{:.concept}
## Types of plug-ins

Puppet supports several kinds of plug-ins:

* [Custom facts][] (written in Ruby).
* [External facts][] (executable scripts or static data).
* [Custom resource types and providers][] (written in Ruby).
* [Custom functions written in Ruby][ruby_functions].
* [Custom functions written in the Puppet language][puppet_functions].
* [Custom Augeas lenses][].
* Miscellaneous utility Ruby code used by other plug-ins.

Facts and Augeas lenses are used solely by Puppet agent. Functions are used solely by Puppet Server. Resource types and providers are used by both. (Note that Puppet apply acts as both agent and server.)

{:.concept}
## Adding plug-ins to a module

To add plug-ins to a module, put them in the following directories:

Type of plug-in                                           | Module subdirectory
---------------------------------------------------------|------------------------------
Facts                                                    | `lib/facter`
Functions (Ruby, modern `Puppet::Functions` API)         | `lib/puppet/functions`
Functions (Ruby, legacy `Puppet::Parser::Functions` API) | `lib/puppet/parser/functions`
Functions (Puppet language)                              | `functions`
Resource types                                           | `lib/puppet/type`
Resource providers                                       | `lib/puppet/provider`
External facts                                           | `facts.d`
Augeas lenses                                            | `lib/augeas/lenses`

In all cases, you must name files and additional subdirectories according to the plug-in type's loading requirements.

To illustrate, a module that included every type of plug-in would have a directory structure like this:

-   `mymodule` (the module's top-level directory; this module is named `mymodule`.)
    -   `lib`
        -   `facter`
            -   `my_custom_fact.rb`
        -   `puppet`
            -   `functions`
                -   `modern_function.rb`
            -   `parser`
                -   `functions`
                    -   `classic_function.rb`
            -   `type`
                -   `mymodule_instance.rb`
            -   `provider`
                -   `exec`
                    -   `powershell.rb`
        -   `augeas`
            -   `lenses`
                -   `custom.lns`
    -   `functions`
        -   `convertdata.pp` (contains a function named `mymodule::convertdata`.)
    -   `facts.d`
        -   `datacenter.py` (an executable script that returns fact data.)
    -   `locales`

{:.concept}
## Issues with server-side plug-ins

If you encounter problems with conflicting versions of the same plug-in in different environments, you can fix these issues as described below.

Environments aren't completely isolated for certain kinds of plug-ins. If a plug-in of the same name exists in different versions in multiple environments, Puppet loads the plug-in from the first environment to use that plug-in, then continues to use that version of the plug-in for all subsequent environments.

This issue can occur with the following plug-in types:

* Custom resource types. To avoid resource type conflicts, use the `puppet generate types` command as described in [environment isolation](./environment_isolation.html) documentation.
* Custom functions, only with the legacy `Puppet::Parser::Functions` API. To fix the issue, rewrite functions with the modern API, which is not affected by this issue.

