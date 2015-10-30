---
layout: default
title: "Configuration: Short List of Important Settings"
canonical: "/puppet/latest/reference/config_important_settings.html"
---

[cli_settings]: ./config_about_settings.html#settings-can-be-set-on-the-command-line
[trusted_and_facts]: ./lang_facts_and_builtin_vars.html
[config_reference]: /references/4.3.latest/configuration.html
[environments]: ./environments.html
[future]: ./experiments_future.html
[multi_master]: /guides/scaling_multiple_masters.html
[enc]: /guides/external_nodes.html
[meta_noop]: /references/4.3.latest/metaparameter.html#noop
[meta_schedule]: /references/4.3.latest/metaparameter.html#schedule
[lang_tags]: ./lang_tags.html
[modulepath_dir]: ./dirs_modulepath.html
[manifest_dir]: ./dirs_manifest.html
[report_reference]: /references/4.3.latest/report.html
[write_reports]: /guides/reporting.html#writing-custom-reports
[passenger_headers]: /guides/passenger.html#notes-on-ssl-verification
[puppetdb_install]: /puppetdb/latest/connect_puppet_master.html
[static_compiler]: /references/4.3.latest/indirection.html#staticcompiler-terminus
[ssl_autosign]: ./ssl_autosign.html
[structured_facts]: ./lang_facts_and_builtin_vars.html#data-types

[trusted_node_data]: /references/4.3.latest/configuration.html#trustednodedata
[immutable_node_data]: /references/4.3.latest/configuration.html#immutablenodedata
[strict_variables]: /references/4.3.latest/configuration.html#strictvariables
[stringify_facts]: /references/4.3.latest/configuration.html#stringifyfacts
[ordering]: /references/4.3.latest/configuration.html#ordering
[reports]: /references/4.3.latest/configuration.html#reports
[parser]: /references/4.3.latest/configuration.html#parser
[server]: /references/4.3.latest/configuration.html#server
[ca_server]: /references/4.3.latest/configuration.html#caserver
[report_server]: /references/4.3.latest/configuration.html#reportserver
[certname]: /references/4.3.latest/configuration.html#certname
[node_name_fact]: /references/4.3.latest/configuration.html#nodenamefact
[node_name_value]: /references/4.3.latest/configuration.html#nodenamevalue
[environment]: /references/4.3.latest/configuration.html#environment
[noop]: /references/4.3.latest/configuration.html#noop
[priority]: /references/4.3.latest/configuration.html#priority
[report]: /references/4.3.latest/configuration.html#report
[tags]: /references/4.3.latest/configuration.html#tags
[trace]: /references/4.3.latest/configuration.html#trace
[profile]: /references/4.3.latest/configuration.html#profile
[graph]: /references/4.3.latest/configuration.html#graph
[show_diff]: /references/4.3.latest/configuration.html#showdiff
[usecacheonfailure]: /references/4.3.latest/configuration.html#usecacheonfailure
[ignoreschedules]: /references/4.3.latest/configuration.html#ignoreschedules
[prerun_command]: /references/4.3.latest/configuration.html#preruncommand
[postrun_command]: /references/4.3.latest/configuration.html#postruncommand
[pluginsync]: /references/4.3.latest/configuration.html#pluginsync
[runinterval]: /references/4.3.latest/configuration.html#runinterval
[waitforcert]: /references/4.3.latest/configuration.html#waitforcert
[splay]: /references/4.3.latest/configuration.html#splay
[splaylimit]: /references/4.3.latest/configuration.html#splaylimit
[daemonize]: /references/4.3.latest/configuration.html#daemonize
[onetime]: /references/4.3.latest/configuration.html#onetime
[dns_alt_names]: /references/4.3.latest/configuration.html#dnsaltnames
[basemodulepath]: /references/4.3.latest/configuration.html#basemodulepath
[modulepath]: /references/4.3.latest/configuration.html#modulepath
[manifest]: /references/4.3.latest/configuration.html#manifest
[ssl_client_header]: /references/4.3.latest/configuration.html#sslclientheader
[ssl_client_verify_header]: /references/4.3.latest/configuration.html#sslclientverifyheader
[node_terminus]: /references/4.3.latest/configuration.html#nodeterminus
[external_nodes]: /references/4.3.latest/configuration.html#externalnodes
[storeconfigs]: /references/4.3.latest/configuration.html#storeconfigs
[storeconfigs_backend]: /references/4.3.latest/configuration.html#storeconfigsbackend
[catalog_terminus]: /references/4.3.latest/configuration.html#catalogterminus
[config_version]: /references/4.3.latest/configuration.html#configversion
[ca]: /references/4.3.latest/configuration.html#ca
[ca_ttl]: /references/4.3.latest/configuration.html#cattl
[autosign]: /references/4.3.latest/configuration.html#autosign
[environmentpath]: /references/4.3.latest/configuration.html#environmentpath
[environment.conf]: ./config_file_environment.html
[alwayscachefeatures]: /references/4.3.latest/configuration.html#alwayscachefeatures
[environment_timeout]: /references/4.3.latest/configuration.html#environmenttimeout
[configuring_timeout]: ./environments_configuring.html#environmenttimeout
[puppetserver_config_files]: /puppetserver/2.2/configuration.html
[settings_diffs]: /puppetserver/2.2/puppet_conf_setting_diffs.html
[puppet_admin]: /puppetserver/2.2/configuration.html#puppetserverconf
[jruby_puppet]: /puppetserver/2.2/tuning_guide.html#puppet-server-and-jruby
[jvm_heap_config]: /puppetserver/2.2/install_from_packages.html#memory-allocation
[puppetserver_ca]: /puppetserver/2.2/puppet_conf_setting_diffs.html#cahttpsdocspuppetlabscomreferenceslatestconfigurationhtmlca
[service_bootstrap]: /puppetserver/2.2/configuration.html#service-bootstrapping
[trusted_server_facts]: ./lang_facts_and_builtin_vars.html#serverfacts-variable


Puppet has about 200 settings, all of which are listed in the [configuration reference][config_reference]. Most users can ignore about 170 of those.

This page lists the most important ones. (We assume here that you're okay with default values for things like the port Puppet uses for network traffic.) The link for each setting will go to the long description in the configuration reference.

> **Why so many settings?** There are a lot of settings that are rarely useful but still make sense, but there are also at least a hundred that shouldn't be configurable at all.
>
> This is basically a historical accident. Due to the way Puppet's code is arranged, the settings system was always the easiest way to publish global constants that are dynamically initialized on startup. This means a lot of things have crept in there regardless of whether they needed to be configurable.

Getting New Features Early
-----

We've added improved behavior to Puppet, but some of it can't be enabled by default until a major version boundary, since it changes things that some users might be relying on. But if you know your site won't be affected, you can enable some of it today.

* [`trusted_server_facts`][trusted_server_facts] (Puppet master/apply only) --- Set this setting to `true` to take advantage of the `$server_facts` variable, which contains a hash of server-side facts that cannot be overwritten by client-side facts.
* [`strict_variables = true`][strict_variables] (Puppet master/apply only) --- This makes uninitialized variables cause parse errors, which can help squash difficult bugs by failing early instead of carrying undef values into places that don't expect them. This one has a strong chance of causing problems when you turn it on, so be wary, but it will eventually improve the general quality of Puppet code. This will be enabled by default in Puppet 5.0.

Settings for Agents (All Nodes)
-----

Roughly in order of importance. Most of these can go in either `[main]` or `[agent]`, or be [specified on the command line][cli_settings].

### Basics

* [`server`][server] --- The Puppet master server to request configurations from. Defaults to `puppet`; change it if that's not your server's name.
    * [`ca_server`][ca_server] and [`report_server`][report_server] --- If you're using multiple masters, you'll need to centralize the CA; one of the ways to do this is by configuring `ca_server` on all agents. [See the multiple masters guide][multi_master] for more details. The `report_server` setting works about the same way, although whether you need to use it depends on how you're processing reports.
* [`certname`][certname] --- The node's certificate name, and the unique identifier it uses when requesting catalogs; defaults to the fully qualified domain name.
    * For best compatibility, you should limit the value of `certname` to only use letters, numbers, periods, underscores, and dashes. (That is, it should match `/\A[a-z0-9._-]+\Z/`.)
    * The special value `ca` is reserved, and can't be used as the certname for a normal node.
* [`environment`][environment] --- The [environment][environments] to request when contacting the Puppet master. It's only a request, though; the master's [ENC][] can override this if it chooses. Defaults to `production`.

{% partial ./_nodename_certname.md %}

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

* [`dns_alt_names`][dns_alt_names] --- A list of hostnames the server is allowed to use when acting as a Puppet master. The hostname your agents use in their `server` setting **must** be included in either this setting or the master's `certname` setting. Note that this setting is only used when initially generating the Puppet master's certificate --- if you need to change the DNS names, you must:
    1. Turn off the Puppet server service (or your Rack server).
    2. Run `sudo puppet cert clean <MASTER'S CERTNAME>`.
    3. Run `sudo puppet cert generate <MASTER'S CERTNAME> --dns_alt_names <ALT NAME 1>,<ALT NAME 2>,...`.
    4. Re-start the Puppet server service.
* [`environment_timeout`][environment_timeout] --- For better performance, you can set this to `unlimited` and make refreshing the Puppet master a part of your standard code deployment process. See [the timeout section of the Configuring Environments page][configuring_timeout] for more details.
* [`environmentpath`][environmentpath] --- Controls where Puppet finds directory environments. See [the page on directory environments][environments] for details.
* [`basemodulepath`][basemodulepath] --- A list of directories containing Puppet modules that can be used in all environments. [See the modulepath page][modulepath_dir] for details.
* [`reports`][reports] --- Which report handlers to use. For a list of available report handlers, see [the report reference][report_reference]. You can also [write your own report handlers][write_reports]. Note that the report handlers might require settings of their own.

### Puppet Server-Related Settings

Puppet Server has [its own configuration files][puppetserver_config_files]; consequently, there are [several settings in `puppet.conf` that Puppet Server ignores][settings_diffs].

* [`puppet-admin`][puppet_admin] --- Settings to control which authorized clients can use the admin interface.
* [`jruby-puppet`][jruby_puppet] --- Provides details on tuning JRuby for better performance.
* [`JAVA_ARGS`][jvm_heap_config] --- Instructions on tuning the Puppet Server memory allocation.

### Rack-Related Settings

* [`ssl_client_header`][ssl_client_header] and [`ssl_client_verify_header`][ssl_client_verify_header] --- These are used when running Puppet master as a Rack application (e.g. under Passenger), which you should definitely be doing. See [the Passenger setup guide][passenger_headers] for more context about how these settings work; depending on how you configure your Rack server, you can usually leave these settings with their default values.
* [`always_cache_features`][alwayscachefeatures] --- You should always set this to `true` in `[master]` for better performance. (Don't change the default value in `[main]`, because Puppet apply and Puppet agent both need this set to `false`.) Your `config.ru` file should forcibly set this, as done in the default `config.ru` file.

### Extensions

These features configure add-ons and optional features.

* [`node_terminus`][node_terminus] and [`external_nodes`][external_nodes] --- The ENC settings. If you're using an [ENC][], set these to `exec` and the path to your ENC script, respectively.
* [`storeconfigs`][storeconfigs] and [`storeconfigs_backend`][storeconfigs_backend] --- Used for setting up PuppetDB. See [the PuppetDB docs for details.][puppetdb_install]
* [`catalog_terminus`][catalog_terminus] --- This can enable the optional static compiler. If you have lots of `file` resources in your manifests, the static compiler lets you sacrifice some extra CPU work on your Puppet master to gain faster configuration and reduced HTTPS traffic on your agents. [See the "static compiler" section of the indirection reference][static_compiler] for details.

### CA Settings

* [`ca`][ca] --- Whether to act as a CA. **There should only be one CA at a Puppet deployment.** If you're using [multiple Puppet masters][multi_master], you'll need to set `ca = false` on all but one of them.

   Note that the `ca` setting is not valid for Puppet Server. Refer to these sections about the [Puppet Server `ca`][puppetserver_ca] and [service bootstrapping][service_bootstrap].

* [`ca_ttl`][ca_ttl] --- How long newly signed certificates should be valid for.
* [`autosign`][autosign] --- Whether (and how) to autosign certificates. See [the autosigning page][ssl_autosign] for details.

