---
layout: default
title: "Puppet 3.0 Release Notes"
---

### Changes to Dependencies

#### `puppet doc` only supported on Ruby 1.8.7 and 1.8.5

Because of changes in Ruby 1.9 to the underlying RDoc library used with `puppet doc`, it is only supported on Ruby 1.8.7  and 1.8.5.  See [ticket # 11786](http://projects.puppetlabs.com/issues/11786) for more information.

#### Rubygem support

Puppet can now load extensions (faces) and plugins (types/providers/custom functions) from rubygems. See [ticket #7788](https://projects.puppetlabs.com/issues/7788) for more information.

#### Functions must be called from ruby with an array (#15756)

Previously, custom functions called from ruby (either from other functions or from templates) were supposed to be called using an array of arguments. However, this rule was not enforced and consequently many functions worked by chance. To ensure that functions work consistently, a check is now performed to enforce that arguments are passed via an array. See [ticket #15756](https://projects.puppetlabs.com/issues/15756) for more information.

### Deprecated and Removed Functions

#### `String#lines` and `IO#lines` revert to standard Ruby semantics.

The earliest versions of Ruby supported by puppet lacked these methods. As a consequence, they were supported via emulation. However, this emulation used non-standard Ruby semantics. They have now been reverted to Ruby's norm. Specifically, whereas earlier `String#lines` and `IO#lines` behaved the same way as `split`, they now behave normally: they include the separator character (default `$/` == `\n`) in the output and include content where they previously wouldn't.

#### Puppet::Application: parse_config methods deprecated

The following methods are now deprecated: #should_parse_config, #should_not_parse_config, and #should_parse_config? In previous versions of puppet, individual applications and faces built from the Puppet::Application class were responsible for determining whether or not the puppet config file should be parsed.  This logic is now part of the main puppet engine/framework and thus applications and faces need no longer specify this via the methods mentioned above.  The signatures still exist for now (but will print a deprecation warning) and will be removed in a future release.

#### Puppet::Util::CommandLine: no longer defaults to 'apply'

In recent versions of puppet, if you called puppet without specifying a subcommand, it would default to 'apply'.  This behavior has been deprecated for some time and is now officially removed from 3.0.0.  A subcommand is now required for `puppet` and you will get a warning message if you attempt to run without one.

#### Deprecated standalone commands

The following standalone executables have been removed and replaced as indicated:
Removed     Replacement
`filebucket` --> `puppet filebucket`
`pi` --> `puppet describe`
`puppetdoc` --> `puppet doc`
`ralsh` --> `puppet resource`
`puppetca`  --> `puppet cert`
`puppetd`  -->`puppet agent`
`puppetmasterd`  -->  `puppet master`
`puppetqd`  --> `puppet queue`
`puppetrun`  --> `puppet kick`

Note that all of the replacements have been available for at least one major version before 3.0.0.

#### factsync has been removed

The `factsync` option, deprecated since puppet 0.25, has been removed in 3.0.0. It's functionality has been entirely replaced with `pluginsync`. (See ticket #2277)

#### Puppet language no longer has dynamic scoping for variables

<!-- TODO I think this should be moved to lang_scope and linked to from here and maybe also from lang_variables-->

Dynamic scoping, which has been deprecated for the 2.7.x code, has been removed from this release of puppet. The most recent 2.7 release provides information about what variables were still being looked up in a dynamic manner. Before upgrading to this release, all manifests should be updated so that they no longer produce the dynamic lookup deprecation warnings.

WARNING: Because deprecation warnings are only produced once during a run of the puppet master, you will need to restart the puppet master in order to be certain that your current manifests no longer produce the warnings. If you simply watch your logs and notice no warnings during a puppet agent run, you will not see a warning for a condition that still exists if it had already been logged during a previous run.

#### `ca_days` is removed
 The previously deprecated `ca_days` setting has been removed. `ca_ttl` should be used instead.
 
 #### `cacrl` can no longer be false
  The ability to set the `cacrl` setting to false has been removed. Puppet will now just ignore the CRL if it is missing.
  
 #### Downcasing of facts no longer supported
  - `downcasefact` and `downcase_if_necessary` have been removed as downcasing of facts is no longer supported.
  
  #### `recurse` is removed
  The ability to set the recursion depth with `recurse` has been removed. Instead, `recurselimit` should be used.
  
  #### `path` is removed
`path` has been removed as a valid parameter for the mount point. Instead, `name` should be used.
  
  #### `$` now required for prototypes
  Puppet's grammar has been updated so that a dollar sign (`$`) is now required for prototypes.	When listing parameters in a defined type or class definition, each parameter must be formatted according to the rules for a normal variable and must include a `$` prefix. Note that this has no effect on declaring classes or instances of a defined type.

Right:

	`define vhost ($port = 80, $vhostdir) { ... }`

Wrong:

	`define vhost (port = 80, vhostdir) { ... }`

Unchanged:

	`vhost {'web01.example.com':
	port 	=> 8080,
	vhostdir => '/etc/apache2/conf.d',
	}`
	
  #### `--apply` option is removed
 The `--apply` option has been removed; `puppet apply --catalog` should be used instead of `puppet --apply catalog`.
  
  #### `path` is removed
 The `reportserver` setting has been removed and replaced with `report_server`.
  
  #### `reportserver` is removed
 The `set_default_format` method has been removed, `render_as` should be used instead.
  
  #### `path` is removed
 The `mkmodelmethods` method has been removed for provider objects, `mk_resource_methods` should be used instead.
  
  #### `mkmodelmethods` is removed
 There is now a hard dependency on Facter 1.5.5 or later.
  
  #### `type` is removed
 The `type` attribute for packages has been removed, `provider` should be used instead
  
  #### Numerous methods for `type` objects are removed
 The following methods for type objects have been removed: `states`, `newstate`, `[ ]`, `[ ]=`, `alias`, `clear`, `create`, `delete`, `each`, and `has_key?`.
  
  #### `check` is removed
 The `check` attribute for `type` objects has been removed, `aduit` should be used in it's place.
  
  #### MSI package provider is deprecated
  
  <!--TODO this also needs to be linked to from type.html-->

Starting with Puppet 3.0, the Windows `:msi` package provider has been deprecated. The default and preferred Windows package provider is now `:windows`. This should have little impact on users unless they have manifests that specify `provider => msi`. In such cases, the line needs to be removed or replaced with `provider => windows`

#### Built-in mongrel support and the servertype setting are removed

With the discontinuation of built-in Mongrel support, the `servertype` setting is no longer needed. It only existed to pick between Mongrel and webrick.