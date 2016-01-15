---
layout: default
title: "Configuration: Short List of Important Settings"
canonical: "/puppet/latest/reference/config_important_settings.html"
---

[cli_settings]: ./config_about_settings.html#settings-can-be-set-on-the-command-line
[trusted_and_facts]: ./lang_facts_and_builtin_vars.html
[config_environments]: ./environments_classic.html
[config_reference]: ./configuration.html
[environments]: ./environments.html
[future]: ./experiments_future.html
[multi_master]: /guides/scaling_multiple_masters.html
[enc]: /guides/external_nodes.html
[meta_noop]: ./metaparameter.html#noop
[meta_schedule]: ./metaparameter.html#schedule
[lang_tags]: ./lang_tags.html
[modulepath_dir]: ./dirs_modulepath.html
[manifest_dir]: ./dirs_manifest.html
[report_reference]: ./report.html
[write_reports]: /guides/reporting.html#writing-custom-reports
[passenger_headers]: /guides/passenger.html#notes-on-ssl-verification
[puppetdb_install]: /puppetdb/latest/connect_puppet_master.html
[static_compiler]: ./indirection.html#staticcompiler-terminus
[ssl_autosign]: ./ssl_autosign.html
[structured_facts]: ./lang_facts_and_builtin_vars.html#data-types

[trusted_node_data]: ./configuration.html#trustednodedata
[immutable_node_data]: ./configuration.html#immutablenodedata
[strict_variables]: ./configuration.html#strictvariables
[stringify_facts]: ./configuration.html#stringifyfacts
[ordering]: ./configuration.html#ordering
[reports]: ./configuration.html#reports
[parser]: ./configuration.html#parser
[server]: ./configuration.html#server
[ca_server]: ./configuration.html#caserver
[report_server]: ./configuration.html#reportserver
[certname]: ./configuration.html#certname
[node_name_fact]: ./configuration.html#nodenamefact
[node_name_value]: ./configuration.html#nodenamevalue
[environment]: ./configuration.html#environment
[noop]: ./configuration.html#noop
[priority]: ./configuration.html#priority
[report]: ./configuration.html#report
[tags]: ./configuration.html#tags
[trace]: ./configuration.html#trace
[profile]: ./configuration.html#profile
[graph]: ./configuration.html#graph
[show_diff]: ./configuration.html#showdiff
[usecacheonfailure]: ./configuration.html#usecacheonfailure
[ignoreschedules]: ./configuration.html#ignoreschedules
[prerun_command]: ./configuration.html#preruncommand
[postrun_command]: ./configuration.html#postruncommand
[pluginsync]: ./configuration.html#pluginsync
[runinterval]: ./configuration.html#runinterval
[waitforcert]: ./configuration.html#waitforcert
[splay]: ./configuration.html#splay
[splaylimit]: ./configuration.html#splaylimit
[daemonize]: ./configuration.html#daemonize
[onetime]: ./configuration.html#onetime
[dns_alt_names]: ./configuration.html#dnsaltnames
[basemodulepath]: ./configuration.html#basemodulepath
[modulepath]: ./configuration.html#modulepath
[manifest]: ./configuration.html#manifest
[ssl_client_header]: ./configuration.html#sslclientheader
[ssl_client_verify_header]: ./configuration.html#sslclientverifyheader
[node_terminus]: ./configuration.html#nodeterminus
[external_nodes]: ./configuration.html#externalnodes
[storeconfigs]: ./configuration.html#storeconfigs
[storeconfigs_backend]: ./configuration.html#storeconfigsbackend
[catalog_terminus]: ./configuration.html#catalogterminus
[config_version]: ./configuration.html#configversion
[ca]: ./configuration.html#ca
[ca_ttl]: ./configuration.html#cattl
[autosign]: ./configuration.html#autosign
[environmentpath]: ./configuration.html#environmentpath
[environment.conf]: ./config_file_environment.html
[alwayscachefeatures]: ./configuration.html#alwayscachefeatures
[environment_timeout]: ./configuration.html#environmenttimeout
[configuring_timeout]: ./environments_configuring.html#environmenttimeout

Puppet has about 230 settings, all of which are listed in the [configuration reference][config_reference]. Most users can ignore about 200 of those.

This page lists the most important ones. (We assume here that you're okay with default values for things like the port Puppet uses for network traffic.) The link for each setting will go to the long description in the configuration reference.

> **Why so many settings?** There are a lot of settings that are rarely useful but still make sense, but there are also at least a hundred that shouldn't be configurable at all.
>
> This is basically a historical accident. Due to the way Puppet's code is arranged, the settings system was always the easiest way to publish global constants that are dynamically initialized on startup. This means a lot of things have crept in there regardless of whether they needed to be configurable.

Getting New Features Early
-----

We've added improved behavior to Puppet over the course of the 3.x series, but some of it can't be enabled by default until a major version boundary, since it changes things that some users might be relying on. But if you know your site won't be affected, you can enable some of it today.

### Recommended and Safe

> **Note:** All three of these features are **enabled by default in Puppet Enterprise 3.7.**

* [`trusted_node_data = true`][trusted_node_data] (Puppet master/apply only) --- This enables [the `$trusted` and `$facts` hashes][trusted_and_facts], so you can start using them in your own code.
* [`stringify_facts = false`][stringify_facts] (all nodes) --- This enables [full data type support for facts][structured_facts], allowing facts to contain arrays, hashes, and booleans instead of just strings. This requires Facter ≥ 2.0.
* [`ordering = manifest`][ordering] (all nodes) --- This causes unrelated resources to be applied in the order they are written, instead of in effectively random order. You should still specify dependencies, but this reduces frustration if you forget one.

### Possibly Disruptive

Both of these only affect the Puppet master (and Puppet apply nodes).

* [`parser = future`][parser] (Puppet master/apply only) --- This enables the future parser, which is explained in more detail on [the future parser page][future]. Since it swaps out the entire Puppet language, there's a good chance you'll find something in your code it doesn't like, but it now runs at a decent speed and lets you explore what's eventually coming in Puppet 4.
* [`strict_variables = true`][strict_variables] (Puppet master/apply only) --- This makes uninitialized variables cause parse errors, which can help squash difficult bugs by failing early instead of carrying undef values into places that don't expect them. This one has a strong chance of causing problems when you turn it on, so be wary, but it will eventually improve the general quality of Puppet code.



Settings for Agents (All Nodes)
-----

Roughly in order of importance. Most of these can go in either `[main]` or `[agent]`, or be [specified on the command line][cli_settings].

### Basics

* [`server`][server] --- The Puppet master server to request configurations from. Defaults to `puppet`; change it if that's not your server's name.
    * [`ca_server`][ca_server] and [`report_server`][report_server] --- If you're using multiple masters, you'll need to centralize the CA; one of the ways to do this is by configuring `ca_server` on all agents. [See the multiple masters guide][multi_master] for more details. The `report_server` setting works about the same way, although whether you need to use it depends on how you're processing reports.
* [`certname`][certname] --- The node's certificate name, and the name it uses when requesting catalogs; defaults to the fully qualified domain name.
    * For best compatibility, you should limit the value of `certname` to only use letters, numbers, periods, underscores, and dashes. (That is, it should match `/\A[a-z0-9._-]+\Z/`.)
    * The special value `ca` is reserved, and can't be used as the certname for a normal node.
    * (Yes, it's also possible to re-use certificates/certnames and then set the name used in requests via the [`node_name_fact`][node_name_fact] / [`node_name_value`][node_name_value] settings. Don't do this unless you know exactly what you're doing, because it changes Puppet's whole security model. For most users, certname = only name.)
* [`environment`][environment] --- The [environment][environments] to request when contacting the Puppet master. It's only a request, though; the master's [ENC][] can override this if it chooses. Defaults to `production`.

### Run Behavior

These settings affect the way Puppet applies catalogs.

* [`noop`][noop] --- If enabled, the agent won't do any work; instead, it will look for changes that _should_ be made, then report to the master about what it would have done. This can be overridden per-resource with the [`noop` metaparameter][meta_noop].
* [`priority`][priority] --- Allows you to "nice" Puppet agent so it won't starve other applications of CPU resources while it's applying a catalog.
* [`report`][report] --- Whether to send reports. Defaults to true; usually shouldn't be disabled, but you might have a reason.
* [`tags`][tags] --- Lets you limit the Puppet run to only include resources with certain [tags][lang_tags].
* [`trace`][trace], [`profile`][profile],  [`graph`][graph], and [`show_diff`][show_diff] --- Tools for debugging or learning more about an agent run. Extra-useful when combined with the `--test` and `--debug` CLI options.
* [`usecacheonfailure`][usecacheonfailure] --- Whether to fall back to the last known good catalog if the master fails to return a good catalog. The default behavior is good, but you might have a reason to disable it.
* [`ignoreschedules`][ignoreschedules] --- If you use [schedules][meta_schedule], this can be useful when doing an initial Puppet run to set up new nodes.
* [`prerun_command`][prerun_command] and [`postrun_command`][postrun_command] --- Commands to run on either side of a Puppet run.
* [`pluginsync`][pluginsync] --- This defaults to true these days, so you don't need it in your config file. But you might see it in default config files still, because in versions ≤2.7 you had to turn it on yourself.

### Service Behavior

These settings affect the way Puppet agent acts when running as a long-lived service.

* [`runinterval`][runinterval] --- How often to do a Puppet run, when running as a service.
* [`waitforcert`][waitforcert] --- Whether to keep trying back if the agent can't initially get a certificate. The default behavior is good, but you might have a reason to disable it.

### Useful When Running Agent from Cron

* [`splay`][splay] and [`splaylimit`][splaylimit] --- Together, these allow you to spread out agent runs. When running the agent as a daemon, the services will usually have been started far enough out of sync to make this a non-issue, but it's useful with cron agents. For example, if your agent cron job happens on the hour, you could set `splay = true` and `splaylimit = 60m` to keep the master from getting briefly hammered and then left idle for the next 50 minutes.
* [`daemonize`][daemonize] --- Whether to daemonize. Set this to false when running the agent from cron.
* [`onetime`][onetime] --- Whether to exit after finishing the current Puppet run. Set this to true when running the agent from cron.

Settings for Puppet Master Servers
-----

Many of these settings are also important for standalone Puppet apply nodes, since they act as their own Puppet master.

These settings should usually go in `[master]`. However, if you're using Puppet apply in production, put them in `[main]` instead.

### Basics

* [`always_cache_features`][alwayscachefeatures] --- You should always set this to `true` in `[master]` for better performance. (Don't change the default value in `[main]`, because Puppet apply and Puppet agent both need this set to `false`.)
* [`dns_alt_names`][dns_alt_names] --- A list of hostnames the server is allowed to use when acting as a Puppet master. The hostname your agents use in their `server` setting **must** be included in either this setting or the master's `certname` setting. Note that this setting is only used when initially generating the Puppet master's certificate --- if you need to change the DNS names, you must:
    * Turn off the Puppet master service (or Rack server).
    * Run `sudo puppet cert clean <MASTER'S CERTNAME>`.
    * Run `sudo puppet cert generate <MASTER'S CERTNAME> --dns_alt_names <ALT NAME 1>,<ALT NAME 2>,...`.
    * Re-start the Puppet master service.
* [`environment_timeout`][environment_timeout] --- For better performance, you can set this to `unlimited` and make refreshing the Puppet master a part of your standard code deployment process. See [the timeout section of the Configuring Environments page][configuring_timeout] for more details.
* [`environmentpath`][environmentpath] --- Set this to `$confdir/environments` to enable directory environments. See [the page on directory environments][environments] for details.
* [`basemodulepath`][basemodulepath] --- A list of directories containing Puppet modules that can be used in all environments. [See the modulepath page][modulepath_dir] for details.
    * If [directory environments][environments] are disabled, the [`modulepath`][modulepath] setting controls the final modulepath. You can also set `modulepath` in [environment.conf][].
* [`manifest`][manifest] --- The main entry point for compiling catalogs. This is only used if directory environments aren't enabled. Defaults to a single site.pp file, but can also point to a directory of manifests. [See the manifest page][manifest_dir] for details.
* [`reports`][reports] --- Which report handlers to use. For a list of available report handlers, see [the report reference][report_reference]. You can also [write your own report handlers][write_reports]. Note that the report handlers might require settings of their own, like `tagmail`'s various email settings.

### Rack-Related Settings

* [`ssl_client_header`][ssl_client_header] and [`ssl_client_verify_header`][ssl_client_verify_header] --- These are used when running Puppet master as a Rack application (e.g. under Passenger), which you should definitely be doing. See [the Passenger setup guide][passenger_headers] for more context about how these settings work; depending on how you configure your Rack server, you can usually leave these settings with their default values.

### Extensions

These features configure add-ons and optional features.

* [`node_terminus`][node_terminus] and [`external_nodes`][external_nodes] --- The ENC settings. If you're using an [ENC][], set these to `exec` and the path to your ENC script, respectively.
* [`storeconfigs`][storeconfigs] and [`storeconfigs_backend`][storeconfigs_backend] --- Used for setting up PuppetDB. See [the PuppetDB docs for details.][puppetdb_install]
* [`catalog_terminus`][catalog_terminus] --- This can enable the optional static compiler. If you have lots of `file` resources in your manifests, the static compiler lets you sacrifice some extra CPU work on your Puppet master to gain faster configuration and reduced HTTPS traffic on your agents. [See the "static compiler" section of the indirection reference][static_compiler] for details.
* [`config_version`][config_version] --- The "config version" is an ID string included in catalogs and reports. Usually it's just the time at which the catalog was compiled, but this setting can specify a command to run to generate that ID. Some people use this to get, e.g., the current git HEAD in their modules directory.

### CA Settings

* [`ca`][ca] --- Whether to act as a CA. **There should only be one CA at a Puppet deployment.** If you're using [multiple Puppet masters][multi_master], you'll need to set `ca = false` on all but one of them.
* [`ca_ttl`][ca_ttl] --- How long newly signed certificates should be valid for.
* [`autosign`][autosign] --- Whether (and how) to autosign certificates. See [the autosigning page][ssl_autosign] for details.

