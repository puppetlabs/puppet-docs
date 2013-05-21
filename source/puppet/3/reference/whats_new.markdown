---
layout: default
title: "Puppet 3: What's New"
description: "New features, improvements, changes, and incompatibilities in the Puppet 3.x releases."
---

[classes]: ./lang_classes.html
<!-- TODO better hiera url -->
[hiera]: https://github.com/puppetlabs/hiera
[lang_scope]: ./lang_scope.html
[qualified_vars]: ./lang_variables.html#accessing-out-of-scope-variables
[auth_conf]: /guides/rest_auth_conf.html
[upgrade]: /guides/upgrading.html
[upgrade_issues]: http://projects.puppetlabs.com/projects/puppet/wiki/Telly_Upgrade_Issues
[target_300]: http://projects.puppetlabs.com/projects/puppet/issues?set_filter=1&f[]=fixed_version_id&op[fixed_version_id]=%3D&v[fixed_version_id][]=271&f[]=&c[]=project&c[]=tracker&c[]=status&c[]=priority&c[]=subject&c[]=assigned_to&c[]=fixed_version&group_by=
[unless]: ./lang_conditional.html#unless-statements
[target_310]: http://projects.puppetlabs.com/projects/puppet/issues?set_filter=1&f%5B%5D=fixed_version_id&op%5Bfixed_version_id%5D=%3D&v%5Bfixed_version_id%5D%5B%5D=288&f%5B%5D=&c%5B%5D=project&c%5B%5D=tracker&c%5B%5D=status&c%5B%5D=priority&c%5B%5D=subject&c%5B%5D=assigned_to&c%5B%5D=fixed_version&group_by=
[puppet3_release_notes]: ./release_notes.html

Puppet 3 introduces several new features and some backwards-incompatible changes. **Before upgrading from Puppet 2.x, you should:**

* Read our [general recommendations for upgrading between two major versions of Puppet][upgrade], which include suggested roll-out plans and package management practices.
* Read the [Backwards-Incompatible Changes][backwards] section below and watch for "upgrade notes" --- you may need to make changes to your configuration and manifests.
* Check the [Telly upgrade issues][upgrade_issues] wiki page, and make sure none of the bugs found immediately after the current release are dealbreakers for your site.

This document provides a more narrative guide to the Puppet 3 release. For information on changes to subsequent point and patch releases (e.g. 3.1.0 and 3.1.1), please see the [Puppet 3 release notes page][puppet3_release_notes]


Flagship Features in Puppet 3.x
-----

### Improved Version Numbering

Puppet 3 marks the beginning of a new version scheme for Puppet releases. Beginning with 3.0.0, Puppet uses a strict three-field version number:

* The leftmost segment of the version number must increase for major backwards-incompatible changes.
* The middle segment may increase for backwards-compatible new functionality.
* The rightmost segment may increase for bug fixes.

### Major Speed Increase

Puppet 3 is faster than Puppet 2.6 and _significantly_ faster than Puppet 2.7. The exact change will depend on your site's configuration and Puppet code, but many 2.7 users have seen up to a 50% improvement.

### Automatic Data Bindings for Class Parameters

When you declare or assign classes, Puppet now automatically looks up parameter values in Hiera. See [Classes][] for more details.

### Hiera Functions in Core

The `hiera`, `hiera_array`, `hiera_hash`, and `hiera_include` functions are now included in Puppet core. If you previously installed these functions with the `hiera-puppet` package, you may need to uninstall it before upgrading.

### Solaris Improvements

* Puppet now supports the ipkg format, and is able to "hold" packages (install without activating) on Solaris.
* Zones support is fixed.
* Zpool support is significantly improved.


New Features in Puppet 3.1.0
-----

### YAML Node Cache Restored on Master

In 3.0.0, we inadvertently removed functionality that people relied upon to get a list of all the nodes checking into a particular puppet master. This is now enabled for good, added to the test harness, and available for use as:

    # shell snippet
    export CLIENTYAML=`puppet master --configprint yamldir`
    puppet node search "*" --node_terminus yaml --clientyamldir $CLIENTYAML

### Improvements When Loading Ruby Code

A major area of focus for this release was loading extension code. As people wrote and distributed Faces (new puppet subcommands that extend Puppet's capabilities), bugs like [#7316](https://projects.puppetlabs.com/issues/7316) started biting them. Additionally, seemingly simple things like retrieving configuration file settings quickly got complicated, causing problems both for Puppet Labs' code like Cloud Provisioner as well as third-party integrations like Foreman. The upshot is that it's now possible to fully initialize puppet when using it as a library, loading Ruby code from Forge modules works correctly, and tools like puppetlabs_spec_helper now work correctly.

### YARD API Documentation

To go along with the improved usability of Puppet as a library, we've added [YARD documentation](http://yardoc.org) throughout the codebase. YARD generates browsable code documentation based on in-line comments. This is a first pass through the codebase but about half of it's covered now. To use the YARD docs, simply run `gem install yard` then `yard server --nocache` from inside a puppet source code checkout (the directory containing `lib/puppet`). YARD documentation is also available in the [generated references section](/references/3.1.latest/index.html) under [Developer Documentation](/references/3.1.latest/developer/).


All Bugs Fixed in 3.1
-----

Use the Puppet issue tracker to find every bug fixed in a given version of Puppet.

* [All bugs fixed in 3.1.0][target_310] (approx. 53)



Backwards-Incompatible Changes in 3.x
-----

[backwards]: #backwards-incompatible-changes-in-30

In addition to this section, you may also wish to check the [Telly upgrade issues][upgrade_issues] wiki page, which tracks any major bugs found immediately after the current release.


### Dependencies and Supported Systems

* Puppet 3 adds support for Ruby 1.9.3, and drops support for Ruby 1.8.5. (Puppet Labs is publishing Ruby 1.8.7 packages in its repositories to help users who are still on RHEL and CentOS 5.)
    * Note that `puppet doc` is only supported on Ruby 1.8.7, due to 1.9's changes to the underlying RDoc library. See [ticket # 11786](http://projects.puppetlabs.com/issues/11786) for more information.
* [Hiera][] is now a dependency of Puppet.
* Puppet now requires Facter 1.6.2 or later.
* Support for Mac OS X 10.4 has been dropped.

### Puppet Language Changes

#### Dynamic Scope for Variables is Removed

Dynamic scoping of variables, which was deprecated in Puppet 2.7, has been removed. See [Language: Scope][lang_scope] for more details. The most recent 2.7 release logs warnings about any variables in your code that are still being looked up dynamically.

> **Upgrade note:** Before upgrading from Puppet 2.x, you should do the following:
>
> * Restart your puppet master --- this is necessary because deprecation warnings are only produced once per run, and warnings that were already logged may not appear again in your logs until a restart.
> * Allow all of your nodes to check in and retrieve a catalog.
> * Examine your puppet master's logs for dynamic scope warnings.
> * Edit any manifests referenced in the warnings to remove the dynamic lookup behavior. Use [fully qualified variable names][qualified_vars] where necessary, and move makeshift data hierarchies out of your manifests and into [Hiera][].


#### Parameters In Definitions Must Be Variables

Parameter lists in class and defined type **definitions** must include a dollar sign (`$`) prefix for each parameter. In other words, parameters must be styled like variables. Non-variable-like parameter lists have been deprecated since at least Puppet 0.23.0.

The syntax for class and defined resource **declarations** is unchanged.

Right:

    define vhost ($port = 80, $vhostdir) { ... }

Wrong:

    define vhost (port = 80, vhostdir) { ... }

Unchanged:

    vhost {'web01.example.com':
      port     => 8080,
      vhostdir => '/etc/apache2/conf.d',
    }

### Ruby DSL is Deprecated

The [Ruby DSL that was added in Puppet 2.6](http://projects.puppetlabs.com/projects/puppet/wiki/Ruby_Dsl) (and then largely ignored) is deprecated. Deprecation warnings have been added to Puppet 3.1.

### Deprecated Commands Are Removed

The legacy standalone executables, which were replaced by subcommands in Puppet 2.6, have been removed. Additionally, running `puppet` without a subcommand no longer defaults to `puppet apply`.


Pre-2.6       | Post-2.6
--------------|--------------
puppetmasterd | puppet master
puppetd       | puppet agent
puppet        | puppet apply
puppetca      | puppet cert
ralsh         | puppet resource
puppetrun     | puppet kick
puppetqd      | puppet queue
filebucket    | puppet filebucket
puppetdoc     | puppet doc
pi            | puppet describe

> **Upgrade note:** Examine your Puppet init scripts, the configuration of the puppet master's web server, and any wrapper scripts you may be using, and ensure that they are using the new subcommands instead of the legacy standalone commands.

### Changed Application Behavior

#### Puppet Apply's `--apply` Option Is Removed

The `--apply` option has been removed. It was replaced by `--catalog`.

#### Console Output Formatting Changes

The format of messages displayed to the console has changed slightly, potentially leading to scripts that watch these messages breaking. Additionally, we now use STDERR appropriately on \*nix platforms.

> **Upgrade Note:** If you scrape Puppet's console output, revise the relevant scripts.

This does not change the formatting of messages logged through other channels (eg: syslog, files), which remain as they were before. [See bug #13559 for details](https://projects.puppetlabs.com/issues/13559)


### Removed and Modified Settings

The following settings have been removed:

* `factsync` (Deprecated since Puppet 0.25 and replaced with `pluginsync`; see [ticket #2277](http://projects.puppetlabs.com/issues/2277))
* `ca_days` (Replaced with `ca_ttl`)
* `servertype` (No longer needed, due to [removal of built-in Mongrel support](#special-case-mongrel-support-is-removed))
* `downcasefact` (Long-since deprecated)
* `reportserver` (Long-since deprecated; replaced with `report_server`)


The following settings now behave differently:

* `pluginsync` is now enabled by default
* `cacrl` can no longer be set to `false`. Instead, Puppet will now ignore the CRL if the file in this setting is not present on disk.

### Puppet Master Web Server Changes

#### Rack Configuration Is Changed

Puppet master's `config.ru` file has changed slightly; see `ext/rack/files/config.ru` in the Puppet source code for an updated example. The new configuration:

* Should now require `'puppet/util/command_line'` instead of `'puppet/application/master'`.
* Should now run `Puppet::Util::CommandLine.new.execute` instead of `Puppet::Application[:master].run`.
* Should explicitly set the `--confdir` option (to avoid reading from `~/.puppet/puppet.conf`).

{% highlight diff %}
    diff --git a/ext/rack/files/config.ru b/ext/rack/files/config.ru
    index f9c492d..c825d22 100644
    --- a/ext/rack/files/config.ru
    +++ b/ext/rack/files/config.ru
    @@ -10,7 +10,25 @@ $0 = "master"
     # ARGV << "--debug"

     ARGV << "--rack"
    +ARGV << "--confdir" << "/etc/puppet"
    +
    -require 'puppet/application/master'
    +require 'puppet/util/command_line'

    -run Puppet::Application[:master].run
    +run Puppet::Util::CommandLine.new.execute
    +
{% endhighlight %}

> **Upgrade note:** If you run puppet master via a Rack server like Passenger, you **must** change the `config.ru` file as described above.

#### Special-Case Mongrel Support Is Removed

Previously, the puppet master had special-case support for running under Mongrel. Since Puppet's standard Rack support can also be used with Mongrel, this redundant code has been removed.

> **Upgrade note:** If you are using Mongrel to run your puppet master, re-configure it to run Puppet as a standard Rack application.

### Changes to Core Resource Types

#### File

* The `recurse` parameter can no longer set recursion depth, and must be set to `true`, `false`, or `remote`. Use the `recurselimit` parameter to set recursion depth. (Setting depth with the `recurse` parameter has been deprecated since at least Puppet 2.6.8.)

#### Mount

* The `path` parameter has been removed. It was deprecated and replaced by `name` sometime before Puppet 0.25.0.

#### Package

* The `type` parameter has been removed. It was deprecated and replaced by `provider` some time before Puppet 0.25.0.
* The `msi` provider has been deprecated in favor of the more versatile `windows` provider.
* The `install_options` parameter for Windows packages now accepts an array of mixed strings and hashes; however, it remains backwards-compatible with the 2.7 single hash format.
* A new `uninstall_options` parameter was added for Windows packages. It uses the same semantics as `install_options`.

#### Exec

* The `logoutput` parameter now defaults to `on_failure`.
* Due to misleading values, the `HOME` and `USER` environment variables are now unset when running commands.

#### Metaparameters

* The `check` metaparameter has been removed. It was deprecated and replaced by `audit` in Puppet 2.6.0.

### Changes to Auth.conf

#### Puppet Agent Now Requires Node Access

Puppet agent nodes now requires access to their own `node` object on the puppet master; this is used for making ENC-set environments authoritative over agent-set environments. Your puppet master's auth.conf file must contain the following stanza, or else agent nodes will not be able to retrieve catalogs:

    # allow nodes to retrieve their own node object
    path ~ ^/node/([^/]+)$
    method find
    allow $1

Auth.conf has allowed this by default since 2.7.0, but puppet masters which have been upgraded from previous versions may still be disallowing it.

> **Upgrade note:** Check your auth.conf file and make sure it includes the above stanza **before** the final stanza. Add it if necessary.

#### `auth no` in `auth.conf` Is Now the Same as `auth any'

Previously, `auth no` in [auth.conf][auth_conf] would reject connections with valid certificates. This was confusing, and the behavior has been removed; `auth no` now allows any kind of connection, same as `auth any`.

#### New `allow_ip` Directive in `auth.conf`; IP Addresses Disallowed in `allow` Directive

To allow hosts based on IP address, use `allow_ip`. It functions exactly like `allow` in all respects except that it does not support backreferences. The `allow` directive now assumes that the string is not an IP address.

> **Upgrade Note:** If your `auth.conf` or `fileserver.conf` files allowed any specific nodes by IP address, you must replace those `allow` directives with `allow_ip`.

### Changes to HTTP API

#### "Resource Type" API Has Changed

The API for querying resource types has changed to more closely match standard Puppet terminology.  This is most likely to be visible to any external tools that were using the HTTP API to query for information about resource types.

* You can now add a `kind` option to your request, which will allow you to filter results by one of the following kinds of resource types: `class`, `node`, `defined_type`.
* The API would previously return a field called `type` for each result; this has been changed to `kind`.
* The API would previously return the value `hostclass` for the `type` field for classes; this has been changed to `class`.
* The API would previously return the value `definition` for the `type` field for classes; this has been changed to `defined_type`.
* The API would previously return a field called `arguments` for any result that contained a parameter list; this has been changed to `parameters`.

An example of the new output:

    [
      {
        "line": 1,
        "file": "/home/cprice/work/puppet/test/master/conf/modules/resource_type_foo/manifests/init.pp",
        "name": "resource_type_foo",
        "kind": "class"
      },
      {
        "line": 1,
        "file": "/home/cprice/work/puppet/test/master/conf/modules/resource_type_foo/manifests/my_parameterized_class.pp",
        "parameters": {
          "param1": null,
          "param2": "\"default2\""
        },
        "name": "resource_type_foo::my_parameterized_class",
        "kind": "class"
      },
      {
        "line": 1,
        "file": "/home/cprice/work/puppet/test/master/conf/modules/resource_type_foo/manifests/my_defined_type.pp",
        "parameters": {
          "param1": null,
          "param2": "\"default2\""
        },
        "name": "resource_type_foo::my_defined_type",
        "kind": "defined_type"
      },
      {
        "line": 1,
        "file": "/home/cprice/work/puppet/test/master/conf/modules/resource_type_foo/manifests/my_node.pp",
        "name": "my_node",
        "kind": "node"
      }
    ]

#### XML-RPC support is entirely removed

XML-RPC support has been removed entirely, in favor of the HTTP API introduced in 2.6. XML-RPC support has been deprecated since 2.6.0.



### Changes to Ruby API, Including Type and Provider Interface

The following hard changes have been made to Puppet's internal Ruby API:

* **Helper code:** `String#lines` and `IO#lines` revert to standard Ruby semantics. Puppet used to emulate these methods to accomodate ancient Ruby versions, and its emulation was slightly inaccurate. We've stopped emulating them, so they now include the separator character (`$/`, default value `\n`) in the output and include content where they previously wouldn't.
* **Functions:** Puppet functions called from Ruby code (templates, other functions, etc.) must be called with an **array of arguments.** Puppet has always expected this, but was not enforcing it. See [ticket #15756](https://projects.puppetlabs.com/issues/15756) for more information.
* **Faces:** The `set_default_format` method has been removed. It had been deprecated and replaced by `render_as`.
* **Resource types:** The following methods for type objects have been removed: `states`, `newstate`, `[ ]`, `[ ]=`, `alias`, `clear`, `create`, `delete`, `each`, and `has_key?`.
* **Providers:** The `mkmodelmethods` method for provider objects has been removed. It was replaced with `mk_resource_methods`.
* **Providers:** The `LANG`, `LC_*`, and `HOME` environment variables are now unset when providers and other code execute external commands.

The following Ruby methods are now deprecated:

* **Applications:** The `Puppet::Application` class's `#should_parse_config`, `#should_not_parse_config`, and `#should_parse_config?` methods are now deprecated, and will be removed in a future release. They are no longer necessary for individual applications and faces, since Puppet now automatically determines when the config file should be re-parsed.


### Changes to Agent Lockfile Behavior

Puppet agent now uses two lockfiles instead of one:

* The run-in-progress lockfile (configured with the `agent_catalog_run_lockfile` setting) is present if an agent catalog run is in progress. It contains the PID of the currently running process.
* The disabled lockfile (configured with the `agent_disabled_lockfile` setting) is present if the agent was disabled by an administrator. The file is a JSON hash which **may** contain a `disabled_message` key, whose value should be a string with an explanatory message from the administrator.

### Non-Administrator Windows Data Directory Is Changed

When running as a non-privileged user (i.e. not an Administrator), the location of Puppet's data directory has changed. Previously, it was in `~/.puppet`, but it is now located in the Local Application Data directory following Microsoft best-practices for per-user, non-roaming data. The location of the directory is contained in the `%LOCALAPPDATA%` environment variable, which on Windows 2003 and earlier is: `%USERPROFILE%\Local Settings\Application Data` On Windows Vista and later: `%USERPROFILE%\AppData\Local`


New Backwards-Compatible Features in 3.0
-----

### Automatic Data Bindings for Class Parameters

When you declare or assign classes, Puppet now automatically looks up parameter values in Hiera. See [Classes][] for more details.

### Solaris Improvements

* Puppet now supports the ipkg format, and is able to "hold" packages (install without activating) on Solaris.
* Zones support is fixed.
* Zpool support is significantly improved.


### Rubygem Extension Support

Puppet can now load extensions (including subcommands) and plugins (custom types/providers/functions) from gems. See [ticket #7788](https://projects.puppetlabs.com/issues/7788) for more information.

### Puppet Agent Is More Efficient in Daemon Mode

Puppet agent now forks a child process to run each catalog. This allows it to return memory to system more efficiently when running in daemon mode, and should reduce resource consumption for users who don't run puppet agent from cron.

### `puppet parser validate` Will Read From STDIN

Piped content to `puppet parser validate` will now be read and validated, rather than ignoring it and requiring a file on disk.

### The HTTP Report Processor Now Supports HTTPS

Use an `https://` URL in the `report_server` setting to submit reports to an HTTPS server.

### The `include` Function Now Accepts Arrays

### New `unless` Statement

Puppet now has [an `unless` statement][unless].

### Puppet Agent Can Use DNS SRV Records to Find Puppet Master

> **Note:** This feature is meant for certain unusual use cases; if you are wondering whether it will be useful to you, the answer is probably "No, use [round-robin DNS or a load balancer](/guides/scaling_multiple_masters.html) instead."

Usually, agent nodes use the `server` setting from puppet.conf to locate their puppet master, with optional `ca_server` and `report_server` settings for centralizing some kinds of puppet master traffic.

If you set [`use_srv_records`](/references/latest/configuration.html#usesrvrecords) to `true`, agent nodes will instead use DNS SRV records to attempt to locate the puppet master. These records must be configured as follows:

Server                       | SRV record
-----------------------------|-----------------------------
Puppet master                | `_x-puppet._tcp.$srv_domain`
CA server (if different)     | `_x-puppet-ca._tcp.$srv_domain`
Report server (if different) | `_x-puppet-report._tcp.$srv_domain`
File server\* (if different) | `_x-puppet-fileserver._tcp.$srv_domain`

The [`srv_domain`](/references/latest/configuration.html#srvdomain) setting can be used to set the domain the agent will query; it defaults to the value of the [domain fact](/facter/latest/core_facts.html#domain). If the agent doesn't find an SRV record or can't contact the servers named in the SRV record, it will fall back to the `server`/`ca_server`/`report_server` settings from puppet.conf.

\* (Note that the file server record is somewhat dangerous, as it overrides the server specified in **any** `puppet://` URL, not just URLs that use the default server.)


All Bugs Fixed in 3.0
-----

Use the Puppet issue tracker to find every bug fixed in a given version of Puppet.

* [All bugs fixed in 3.0.0][target_300] (approx. 220)

