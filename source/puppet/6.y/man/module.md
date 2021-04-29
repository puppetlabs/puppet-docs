---
layout: default
built_from_commit: 40229a5d238c1fae86d2a4acfe88860091f3728a
title: 'Man Page: puppet module'
canonical: "/puppet/latest/man/module.html"
---

<div class='mp'>
<p>USAGE: puppet module <var>action</var> [--environment production ] [--modulepath  ]</p>

<p>This subcommand can find, install, and manage modules from the Puppet Forge,
a repository of user-contributed Puppet code. It can also generate empty
modules, and prepare locally developed modules for release on the Forge.</p>

<p>OPTIONS:
  --render-as FORMAT             - The rendering format to use.
  --verbose                      - Whether to log verbosely.
  --debug                        - Whether to log debug information.
  --environment production       - The environment in which Puppet is running.
                                   For clients, such as <code>puppet agent</code>, this
                                   determines the environment itself, which
                                   Puppet uses to find modules and much more.
                                   For servers, such as <code>puppet master</code>, this
                                   provides the default environment for nodes
                                   that Puppet knows nothing about. When
                                   defining an environment in the <code>[agent]</code>
                                   section, this refers to the environment that
                                   the agent requests from the master. The
                                   environment doesn't have to exist on the
                                   local filesystem because the agent fetches it
                                   from the master. This definition is used when
                                   running <code>puppet agent</code>. When defined in the
                                   <code>[user]</code> section, the environment refers to
                                   the path that Puppet uses to search for code
                                   and modules related to its execution. This
                                   requires the environment to exist locally on
                                   the filesystem where puppet is being
                                   executed. Puppet subcommands, including
                                   <code>puppet module</code> and <code>puppet apply</code>, use this
                                   definition. Given that the context and
                                   effects vary depending on the <a href="https://puppet.com/docs/puppet/latest/config_file_main.html#config-sections">config
                                   section</a>
                                   in which the <code>environment</code> setting is
                                   defined, do not set it globally.
  --modulepath                   - The search path for modules, as a list of
                                   directories separated by the system path
                                   separator character. (The POSIX path
                                   separator is ':', and the Windows path
                                   separator is ';'.) Setting a global value for
                                   <code>modulepath</code> in puppet.conf is not allowed
                                   (but it can be overridden from the
                                   commandline). Please use directory
                                   environments instead. If you need to use
                                   something other than the default modulepath
                                   of <code>&lt;ACTIVE ENVIRONMENT'S MODULES
                                   DIR>:$basemodulepath</code>, you can set
                                   <code>modulepath</code> in environment.conf. For more
                                   info, see
                                   <a href="https://puppet.com/docs/puppet/latest/environments_about.html" data-bare-link="true">https://puppet.com/docs/puppet/latest/environments_about.html</a></p>

<p>ACTIONS:
  build        Build a module release package.
  changes      Show modified files of an installed module.
  generate     Generate boilerplate for a new module.
  install      Install a module from the Puppet Forge or a release archive.
  list         List installed modules
  search       Search the Puppet Forge for a module.
  uninstall    Uninstall a puppet module.
  upgrade      Upgrade a puppet module.</p>

<p>See 'puppet help module' or 'man puppet-module' for full help.</p>

</div>
