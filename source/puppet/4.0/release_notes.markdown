---
layout: default
title: "Puppet 4.0 Release Notes"
canonical: "./release_notes.html"
toc: false
---
[refguide]: ./function.html#epp

<a id="puppet-400"></a>

These are the release notes for Puppet 4.0, released April 15 2015. There's a lot of information here so it's organized top to bottom by size of impact -- things everyone is going to notice will be at the top and minor bugfixes/improvements are down at the bottom.

## BREAK: Changes to Platform Support, Repos, and Installation

### All-in-One Packaging

The first thing you'll notice is that the packaging has changed pretty dramatically. Puppet had gotten complicated enough, and the systems it runs on diverse enough, that it became really difficult to provide the proverbial "one-click install" through our Linux-distribution style packaging. For Puppet 4, we've gone to an All-In-One package (which we refer to as "AIO", like a bad hand in Words With Friends), which includes Puppet 4, both Facter 2.4 and CFacter 0.4, the latest Hiera and Mcollective, as well Ruby 2.1.5, OpenSSL 1.0.0r, and our gem dependencies. The package installs into its own area in `/opt/puppetlabs` and is named `puppet-agent` so it will not auto-upgrade existing systems with the `puppet` package installed (it will, however, _replace_ them if you opt-in to the upgrade). 

* [PUP-4003: Puppet 4.0.0 should update to MCO 2.8.0 and Hiera 2.0.0](https://tickets.puppetlabs.com/browse/PUP-4003)
* [PUP-3848: Puppet 4.0.0 should update Ruby to 2.1.5 and Facter to 2.4.0](https://tickets.puppetlabs.com/browse/PUP-3848)
* [PUP-4005: AIO agent CSR extension not compatible with current puppetserver packages](https://tickets.puppetlabs.com/browse/PUP-4005)
* [PUP-3843: Remove PE / FOSS branching (and branding) logic from puppet_for_the_win](https://tickets.puppetlabs.com/browse/PUP-3843)
* [PUP-4018: Execute puppet AIO acceptance against puppetserver](https://tickets.puppetlabs.com/browse/PUP-4018)
* [PUP-4019: Add agent role back to the master](https://tickets.puppetlabs.com/browse/PUP-4019)
* [PUP-4034: Update MSI for AIO](https://tickets.puppetlabs.com/browse/PUP-4034)
* [PUP-4037: Windows AIO path changes](https://tickets.puppetlabs.com/browse/PUP-4037)
* [PUP-3986: Expand predefined OID's for Puppet's extension attributes](https://tickets.puppetlabs.com/browse/PUP-3986)
* [PUP-4009: Add Cfacter 0.4.0 to Windows MSI](https://tickets.puppetlabs.com/browse/PUP-4009)
* [PUP-3920: Update Puppet to use HI 2.0.0](https://tickets.puppetlabs.com/browse/PUP-3920)
* [PUP-4199: config.ru is missing codedir argument](https://tickets.puppetlabs.com/browse/PUP-4199)
* [PUP-4355: Update per-user directories to ~/.puppetlabs](https://tickets.puppetlabs.com/browse/PUP-4355)
* [PUP-4189: Add all per-user directories to file_paths specification](https://tickets.puppetlabs.com/browse/PUP-4189)

### BREAK: New Locations for Important Files and Directories

Related to the AIO packaging changes, there are new locations on the filesystem for the binaries, configuration, and code. The goals were to make a unified filesystem layout for all Puppet/PE installations and to enable continuous-deployment workflows with r10k. There's a [separate top-level guide](./whered_it_go.html) which summarizes the changes.

* [PUP-3809: Separate code (content?) and configuration directories for AIO packaging](https://tickets.puppetlabs.com/browse/PUP-3809)
* [PUP-3846: Puppet 4.0 MSI Changes - Windows Unified Installer](https://tickets.puppetlabs.com/browse/PUP-3846)
* [PUP-3632: Update paths and defaults for the unified FS layout](https://tickets.puppetlabs.com/browse/PUP-3632)
* [PUP-3944: Make sure puppetdb.conf is under $confdir](https://tickets.puppetlabs.com/browse/PUP-3944)
* [PUP-4001: Packaging should create default module directories for puppet](https://tickets.puppetlabs.com/browse/PUP-4001)

### The End of Ruby 1.8.7

One of the benefits of the All-in-One packaging is no longer being dependent on the version of Ruby provided by the different operating system. This let us consolidate on a fast, stable, modern version -- Ruby 2.1.5 -- across all operating systems (including Windows) and remove a ton of hacky work-arounds left over from the Ruby 1.8.7 days.

If you're using the AIO packaging, the whole Puppet toolset (facter, mcollective, etc) will all work out of the box; if you're running from gem or source, however, make sure you're running a recent Ruby interpreter.

* [PUP-3776: Upgrade Windows Ruby to 2.1.5](https://tickets.puppetlabs.com/browse/PUP-3776)
* [PUP-1805: Drop Ruby 1.8.7 support](https://tickets.puppetlabs.com/browse/PUP-1805)
* [PUP-2411: Remove 1.8.7 multibyte string support in Lexer2](https://tickets.puppetlabs.com/browse/PUP-2411)
* [PUP-2563: Remove 1.8.7 support in the ruby code base](https://tickets.puppetlabs.com/browse/PUP-2563)
* [PUP-2412: Remove 1.8.7 function API support](https://tickets.puppetlabs.com/browse/PUP-2412)


### OS Support

* [PUP-3553: Remove support for OSX versions <= 10.6](https://tickets.puppetlabs.com/browse/PUP-3553)
    this mostly relates to setting user passwords and managing services.

## BREAK: Next Version of Puppet Language

By far the most significant user-facing change in Puppet 4 is the completely rewritten parser and evaluator, which are the parts of Puppet that take your modules and transform them into a catalog for each node that checks in. This was originally introduced as an opt-in "Future Parser", and over the last year, community feedback, user research, and engineering time have honed the Future Parser to the point where it's no longer in the realm of the future – it's here.

The rewritten parser includes new capabilities like iteration and type-checking for variables as well as deprecations and changed behaviour. Most notably, the stricter, more predictable parsing of numbers, empty strings, and "undef"/"nil" comparisons may cause changes to a node's catalog without necessarily producing an error.

* [PUP-410: Complete Implementation of Language based on the EGrammar](https://tickets.puppetlabs.com/browse/PUP-410)
* [PUP-3274: Remove old parser/evaluator](https://tickets.puppetlabs.com/browse/PUP-3274)
* [PUP-3133: Decide on the specification of Integer/Float runtime types](https://tickets.puppetlabs.com/browse/PUP-3133)
* [PUP-3002: Better report invalid resource attribute errors](https://tickets.puppetlabs.com/browse/PUP-3002)
* [PUP-3680: The parameter order on the hash type is inconsistent](https://tickets.puppetlabs.com/browse/PUP-3680)
* [PUP-3240: Remove ignoreimport setting](https://tickets.puppetlabs.com/browse/PUP-3240)
    (import was removed in future parser in 3.5.0, see PUP-490)
* [PUP-494: Make future parser/evaluator have acceptable performance](https://tickets.puppetlabs.com/browse/PUP-494)
* [PUP-3701: Issue with empty export resources expression in the Puppet future parser](https://tickets.puppetlabs.com/browse/PUP-3701)
* [PUP-3718: defined function does not handle qualified variable names correctly](https://tickets.puppetlabs.com/browse/PUP-3718)

## BREAK: Directory Environments Replace Config File Environments

Starting with Puppet 3.6, Directory Environments started taking over from Dynamic Environments as Puppet's mechanism for serving different versions of modules and code. In Puppet 4, they're the default and other environment support is gone. Read more about directory environments in the [environments section of the docs](/puppet/latest/environments.html).

* [PUP-3268: Remove non-directory environment support](https://tickets.puppetlabs.com/browse/PUP-3268)
* [PUP-3567: Remove current_environment check in Puppet::Indirector::Request#environment=](https://tickets.puppetlabs.com/browse/PUP-3567)
* [PUP-4094: Default environment_timeout should be 0, not infinity.](https://tickets.puppetlabs.com/browse/PUP-4094)
* [PUP-4067: Create production environment directories in packaging](https://tickets.puppetlabs.com/browse/PUP-4067)
* [PUP-4083: Add sample environment.conf to puppet](https://tickets.puppetlabs.com/browse/PUP-4083)


## BREAK: Removed Puppet Kick, ActiveRecord, and Inventory Service

There's been a lot of accumulated technical debt in Puppet's code base: old features which were deprecated but never removed, half-implemented experiments, and interested things that turned out to be really bad ideas. Almost 60,000 lines of code have been removed from the repository, comprising things like the pre-PuppetDB stored configs, `puppet kick`, and an unsupported CouchDB facts terminus. 

* [PUP-862: Remove deprecated items for the Puppet 4 release](https://tickets.puppetlabs.com/browse/PUP-862) the epic for a bunch of the above.
* [PUP-2560: Remove inventory service on the master](https://tickets.puppetlabs.com/browse/PUP-2560)
* [PUP-2559: Remove couchdb facts terminus and associated settings](https://tickets.puppetlabs.com/browse/PUP-2559)
* [PUP-3249: Remove async_storeconfigs and queue service on the master](https://tickets.puppetlabs.com/browse/PUP-3249)
    see summary in the old deprecations pages. actually that holds true for most of the above.
* Puppet kick:
    * [PUP-84: Disable unnecessary termini, Puppet::Resource::Ral should never be enabled in the puppet master application](https://tickets.puppetlabs.com/browse/PUP-84)
* [PUP-3267: Remove puppet kick and related agent functionality](https://tickets.puppetlabs.com/browse/PUP-3267)
* [PUP-3269: Remove network access to the Resource indirection](https://tickets.puppetlabs.com/browse/PUP-3269)
* [PUP-405: Remove ActiveRecord stored configs](https://tickets.puppetlabs.com/browse/PUP-405)
* [PUP-2560: Remove inventory service on the master](https://tickets.puppetlabs.com/browse/PUP-2560)
* [PUP-4074: Remove master settings from puppet.conf](https://tickets.puppetlabs.com/browse/PUP-4074)


## BREAK: HTTP API Changes

An important set of changes in Puppet 4 involve the URLs the agents and master use to communicate with one another over the network. We've standardized the endpoints onto the same namespaced, versioned standard as other Puppet projects like PuppetDB, which should make for much better compatibility guarantees. A side effect of this, however, is that currently Puppet 3 agents cannot talk to Puppet 4 masters; this compatbility layer will be introduced in Puppet-Server 2.1. See the upgrade docs for [servers](./upgrade_server.html) and [agents](./upgrade_agent.html) for step-by-step instructions to safely update your existing infrastructure.

* [PUP-3641: Changes to Puppet URL structure](https://tickets.puppetlabs.com/browse/PUP-3641)
* [PUP-3519: Scope URL rework](https://tickets.puppetlabs.com/browse/PUP-3519)
* [PUP-3826: Update API docs for Puppet 4 URL changes](https://tickets.puppetlabs.com/browse/PUP-3826)
* [PUP-3851: Remove v2.0 endpoints](https://tickets.puppetlabs.com/browse/PUP-3851)
* [PUP-3921: Craft 404 error message that includes verbiage about Puppet 4 URL changes](https://tickets.puppetlabs.com/browse/PUP-3921)
* [PUP-3642: Remove environment name from URL path](https://tickets.puppetlabs.com/browse/PUP-3642)
* [PUP-3644: move all legacy and v2.0 endpoints to v3](https://tickets.puppetlabs.com/browse/PUP-3644)
* [PUP-3645: allow configurable URL prefix for all routes](https://tickets.puppetlabs.com/browse/PUP-3645)
* [PUP-3526: re-structure CA REST API](https://tickets.puppetlabs.com/browse/PUP-3526)
* [PUP-3812: Modify file_bucket_file API to use "application/octet-stream" instead of "text/plain" for Content-Type](https://tickets.puppetlabs.com/browse/PUP-3812)
* [PUP-3855: auth.conf no longer restricting based on environment](https://tickets.puppetlabs.com/browse/PUP-3855)
* [PUP-3958: Puppet agent requests do not include the X-Puppet-Version header](https://tickets.puppetlabs.com/browse/PUP-3958)
* [PUP-3355: Remove PSON document_type](https://tickets.puppetlabs.com/browse/PUP-3355)



## New Language Features

In addition to the core language changes, there are some new functions available along with a new function API that's written on top of the 4.x parser. No longer will you have to restart a long-running puppetmaster to get it to pick up new versions of your function code! One of the coolest built-in functions is "EPP", or Embedded Puppet, which enables inline and file-based templates similar to ERB (Embedded Ruby) but written in the Puppet Language directly. This helps reduce the cognitive dissonance of switching back and forth between the Puppet Language and Ruby ("Are my variables prefixed with dollar signs or not?!") and lets you use the Puppet's tooling for templates as well as your manifests. Read more about EPP in the [function reference guide][refguide].

* [PUP-2904: Make string/symbol use consistent in new function API](https://tickets.puppetlabs.com/browse/PUP-2904)
* [PUP-2531: Provide validation tool for EPP](https://tickets.puppetlabs.com/browse/PUP-2531)



## Changes to support Puppet Server and CA

* [PUP-3676: Avoid OpenSSL::X509::Name calls in ssl.rb for Puppet Server](https://tickets.puppetlabs.com/browse/PUP-3676)
* [PUP-3522: Ruby OpenSSL executed implicitly in JVM-Puppet by loading Puppet/Util module](https://tickets.puppetlabs.com/browse/PUP-3522)
* [PUP-4194: Puppet's logdir permissions prevent puppetserver service start](https://tickets.puppetlabs.com/browse/PUP-4194)
* [PUP-3520: Move the Puppet extension OIDs definitions](https://tickets.puppetlabs.com/browse/PUP-3520)
* [PUP-3986: Expand predefined OID's for Puppet's extension attributes](https://tickets.puppetlabs.com/browse/PUP-3986)
* [PUP-2995: Proposal for custom trusted oid mapping file](https://tickets.puppetlabs.com/browse/PUP-2995)
* [PUP-3560: Add support for properly signed trusted facts](https://tickets.puppetlabs.com/browse/PUP-3560)
* [PUP-3352: Always attempt to use HTTP compression](https://tickets.puppetlabs.com/browse/PUP-3352)

## BREAK: Changed Defaults for Settings

* [PUP-2253: Enable manifest ordering by default](https://tickets.puppetlabs.com/browse/PUP-2253)
* [PUP-1035: Default setting for pluginsource problematic for deployments using SRV records](https://tickets.puppetlabs.com/browse/PUP-1035)

## BREAK: Puppet Doc and Tagmail Removed from Core, Released as Modules

For users of `puppet doc`, check out the new [puppetlabs-strings](https://forge.puppetlabs.com/puppetlabs/strings/) module on the Forge. `puppet doc` relied on RDoc behaviours which broke in newer Ruby versions. Similarly, the tagmail report processor didn't work under Puppet Server and it seemed like a good candidate to move into a modules, so it's available at [puppetlabs-tagmail](https://forge.puppetlabs.com/puppetlabs/tagmail) on the Forge.

* [PUP-3463: Remove tagmail](https://tickets.puppetlabs.com/browse/PUP-3463)
    https://forge.puppetlabs.com/puppetlabs/tagmail
* [PUP-3638: Remove the manifest handling code from the util/rdoc parsers.](https://tickets.puppetlabs.com/browse/PUP-3638)

## Internal Cleanups and Dead Code Removal

Nearly all users can ignore these removals, but we're including them for completeness's sake.

* [PUP-880: Remove "localconfig" Setting](https://tickets.puppetlabs.com/browse/PUP-880)
* [PUP-3627: Remove ignored certdnsnames setting](https://tickets.puppetlabs.com/browse/PUP-3627)
* [PUP-3295: Remove "metaparam_compatibility_mode"](https://tickets.puppetlabs.com/browse/PUP-3295)
* [PUP-2953: "masterlog" setting is dead code](https://tickets.puppetlabs.com/browse/PUP-2953)
* [PUP-3433: Remove defunct code from Puppet::Util::Autoload](https://tickets.puppetlabs.com/browse/PUP-3433)
* [PUP-3370: Remove serialization of indirector requests](https://tickets.puppetlabs.com/browse/PUP-3370)
* [PUP-1019: Remove ZAML](https://tickets.puppetlabs.com/browse/PUP-1019)


## BREAK: Resource Types/Providers With Changed Behavior

* [PUP-3719: Group resource non-authoritative by default](https://tickets.puppetlabs.com/browse/PUP-3719)
* On the SUSE family of Linuxes, the default package provider is now zypper instead of rug. [PUP-2728: zypper should always be the default package provider for Suse osfamily](https://tickets.puppetlabs.com/browse/PUP-2728)
* [PUP-2613: Change source_permissions default to :ignore](https://tickets.puppetlabs.com/browse/PUP-2613)
* [PUP-2609: Don't allow source_permissions to be set to anything other than ignore on Windows](https://tickets.puppetlabs.com/browse/PUP-2609)
* [PUP-3280: Remove msi provider](https://tickets.puppetlabs.com/browse/PUP-3280)
* [PUP-3305: Change allow_virtual default to true](https://tickets.puppetlabs.com/browse/PUP-3305)
* [PUP-1244: Yum provider using "version-release" to validate installation.](https://tickets.puppetlabs.com/browse/PUP-1244)
    this is a long-running bug where ensure => "version of package, but without the -release suffix" would cause errors.
    the break is that some version comparisons might go differently, now.
* [PUP-2576: Implement behavioral change in the crontab provider to allow more drastic purging](https://tickets.puppetlabs.com/browse/PUP-2576)
* [PUP-2350: Remove support for non-string mode of file type](https://tickets.puppetlabs.com/browse/PUP-2350)
* [PUP-2967: Remove recurse => inf](https://tickets.puppetlabs.com/browse/PUP-2967)
* [PUP-3308: Remove deprecation warning about cron purge change](https://tickets.puppetlabs.com/browse/PUP-3308)
* [PUP-1106: Resource refreshes don't check for failed dependencies.](https://tickets.puppetlabs.com/browse/PUP-1106)
    Prior to Puppet 4.0, refresh events generated by subscribe or notify would be applied without regard to tag filters, failed dependencies or schedules.


## BREAK: Internal API and Implementation Changes

These changes affect Puppet's internal Ruby methods and libraries. Their removal should affect either no one, or a small number of extension authors.

Most of these changes remove code that was previously deprecated.

* [PUP-2965: Remove Puppet::Plugins](https://tickets.puppetlabs.com/browse/PUP-2965)
* [PUP-3229: Remove deprecated methods in Puppet::Settings::BaseSetting](https://tickets.puppetlabs.com/browse/PUP-3229)
* [PUP-3281: Remove latest_info methods from yum provider](https://tickets.puppetlabs.com/browse/PUP-3281)
* [PUP-3684: Remove deprecated methods from Puppet::Settings and Puppet::Module](https://tickets.puppetlabs.com/browse/PUP-3684)
* [PUP-3311: Remove deprecated methods from Puppet::Provider](https://tickets.puppetlabs.com/browse/PUP-3311)
* [PUP-3293: Removed unused pson and rubygems features](https://tickets.puppetlabs.com/browse/PUP-3293)
* [PUP-3298: Remove Puppet::Util::SUIDManager.run_and_capture](https://tickets.puppetlabs.com/browse/PUP-3298)
* [PUP-3299: Remove deprecated Puppet::Util::CommandLine methods](https://tickets.puppetlabs.com/browse/PUP-3299)
* [PUP-3303: Remove deprecated binread implementations](https://tickets.puppetlabs.com/browse/PUP-3303)
* [PUP-3306: Remove deprecated Puppet::SSL::Inventory#serial method](https://tickets.puppetlabs.com/browse/PUP-3306)
* [PUP-3307: Remove parameter from Puppet::Type#remove](https://tickets.puppetlabs.com/browse/PUP-3307)
* [PUP-3312: Remove deprecated code from the Puppet module](https://tickets.puppetlabs.com/browse/PUP-3312)
* [PUP-3313: Remove deprecated puppet_lambda method](https://tickets.puppetlabs.com/browse/PUP-3313)
* [PUP-3270: Remove deprecated Puppet::Application methods](https://tickets.puppetlabs.com/browse/PUP-3270)
* [PUP-3271: Remove filebucket support for pson](https://tickets.puppetlabs.com/browse/PUP-3271)
* [PUP-3273: Remove Puppet::FileCollection](https://tickets.puppetlabs.com/browse/PUP-3273)
* [PUP-3275: Remove from_pson](https://tickets.puppetlabs.com/browse/PUP-3275)
* [PUP-3276: Remove deprecated methods from Puppet::Util::Windows::*](https://tickets.puppetlabs.com/browse/PUP-3276)
* [PUP-3289: Remove deprecated serialization and dynamic facts settings](https://tickets.puppetlabs.com/browse/PUP-3289)
* [PUP-3290: Remove script support from Puppet::Interface::ActionManager](https://tickets.puppetlabs.com/browse/PUP-3290)
* [PUP-3291: Remove autoloader from Puppet::Interface](https://tickets.puppetlabs.com/browse/PUP-3291)
* [PUP-2558: Remove instrumentation system](https://tickets.puppetlabs.com/browse/PUP-2558)
* [PUP-3294: Remove support for :parent](https://tickets.puppetlabs.com/browse/PUP-3294) in the custom type and provider API.
* [PUP-3296: Remove handling and mention of :before and :after for parameters](https://tickets.puppetlabs.com/browse/PUP-3296)


## Stuff a lot of people will notice

A lot of these changes codify defaults changes that were deprecated or on-the-way in Puppet 3.x but couldn't flip over to be the default except on a semver major number boundary. For example, the `stringify_facts` setting (which causes the agent to submit all Facter facts as strings) is gone, because non-stringified-facts are now the default. Similarly, the Modulefile which described puppet module metadata was deprecated in 3.5 in favour of the `metadata.json` file, and now the transitional support for it is gone completely.

Module authors who use the `prefetch` method in custom providers may want to be aware of the changes in PUP-3656. Two things to consider:
  1. Previously, the prefetch method could throw any exception and puppet would carry on. As discussed above this is the wrong behavior in general, however some module authors may have stumbled across this, allowed/encouraged prefetch to throw exceptions, and let puppet runs succeed. So modules should be examined for this assumption.
  2. The only two legitimate causes for prefetch to throw an exception now are `LoadError` and (added in this puppet 4.0) `Puppet::MissingCommand`

* [PUP-3096: trusted_node_data option should go away (should be always-on)](https://tickets.puppetlabs.com/browse/PUP-3096)
* [PUP-3678: Invalid module name .DS_Store error running puppet apply](https://tickets.puppetlabs.com/browse/PUP-3678)
    "Specifically, modules installed in the modulepath will not be recognized as module directories if they have a - in the directory name. I believe this is in line with our docs, but because we have permitted otherwise in the past, some people may have abused the leniency."
* [PUP-2966: Remove stringify_facts option (should never stringify)](https://tickets.puppetlabs.com/browse/PUP-2966)
* [PUP-3372: Remove extlookup function](https://tickets.puppetlabs.com/browse/PUP-3372)
* [PUP-3924: Remove the hiera "puppet_backend"](https://tickets.puppetlabs.com/browse/PUP-3924)
* [PUP-3282: Remove support for method access of variables in ERB templates](https://tickets.puppetlabs.com/browse/PUP-3282)
* [PUP-3656: Prefetch eats most exceptions (those derived from StandardError), there is no way to fail out.](https://tickets.puppetlabs.com/browse/PUP-3656)
* [PUP-3063: Remove certification expiration check from puppet-4](https://tickets.puppetlabs.com/browse/PUP-3063)
    * [PUP-3508: simplify/move warn_if_near_expiration](https://tickets.puppetlabs.com/browse/PUP-3508)
    * [PUP-3510: delete for 4.0](https://tickets.puppetlabs.com/browse/PUP-3510)
    afaict, we just decided this isn't necessary. there's no signal so far on whether we want other tools for checking expiry times.
* [PUP-3254: Remove all Modulefile functionality in PMT except warnings about ignoring](https://tickets.puppetlabs.com/browse/PUP-3254)
* [PUP-777: Remove 'versionRequirement' per code comment](https://tickets.puppetlabs.com/browse/PUP-777)

## Stuff nearly nobody will notice

* [PUP-1467: DIE :undef, DIE!](https://tickets.puppetlabs.com/browse/PUP-1467)
* [PUP-2741: remove the 'search' function](https://tickets.puppetlabs.com/browse/PUP-2741)
* [PUP-3250: Remove secret_agent](https://tickets.puppetlabs.com/browse/PUP-3250)
* [PUP-987: Remove Ruby DSL support](https://tickets.puppetlabs.com/browse/PUP-987)
* [PUP-3272: Remove support for yaml on the network](https://tickets.puppetlabs.com/browse/PUP-3272)
    notably, `report_serialization_format` setting is gone.
* [PUP-3260: Remove RRD functionality from Puppet](https://tickets.puppetlabs.com/browse/PUP-3260)
    rrd metrics graphing, and the rrdgraph report processor
* [PUP-3130: Remove "hidden" $_timestamp fact](https://tickets.puppetlabs.com/browse/PUP-3130)
* [PUP-779: Remove deprecated process execution methods in util](https://tickets.puppetlabs.com/browse/PUP-779)
* The `libdir` setting can only be set to a single directory. Previously, you could set it to a list of directories, but only when using Puppet as a library. This was usually used for testing modules with multiple dependencies. If you need to do this in Puppet 4 or later, you should manipulate Ruby's `$LOAD_PATH` instead. [PUP-3336: Puppet is inconsistent about :libdir setting when multiple paths provided](https://tickets.puppetlabs.com/browse/PUP-3336)


## CLI, Faces, and Logging Improvements


* [PUP-3140: Illegal number error should include the faulty number](https://tickets.puppetlabs.com/browse/PUP-3140)
* [PUP-1103: puppet commands should respond correctly to --help](https://tickets.puppetlabs.com/browse/PUP-1103)
* [PUP-1426: Destructive puppet cert operations should have a safety check](https://tickets.puppetlabs.com/browse/PUP-1426)
* [PUP-3119: Puppet resource should be able to output yaml format for create_resources. (pull request provided)](https://tickets.puppetlabs.com/browse/PUP-3119)
* [PUP-3700: Faces should remove invalid actions instead of just documenting them as invalid](https://tickets.puppetlabs.com/browse/PUP-3700)
* [PUP-3838: puppet console output for warning is red, which is unnecessarily alarming](https://tickets.puppetlabs.com/browse/PUP-3838)
* [PUP-2927: Facter logs should be surfaced during Puppet runs](https://tickets.puppetlabs.com/browse/PUP-2927)
* [PUP-3376: Make the windows puppet service daemon use the configured log_level setting](https://tickets.puppetlabs.com/browse/PUP-3376)
* [PUP-2998: Allow log_level option to be specified in configuration file in addition to command line](https://tickets.puppetlabs.com/browse/PUP-2998)
* [PUP-3624: Running with --test should run with at least info level](https://tickets.puppetlabs.com/browse/PUP-3624)
* [PUP-3756: Don't try to chown log file destination when non-root](https://tickets.puppetlabs.com/browse/PUP-3756)
* [PUP-3521: puppet incorrectly swallows some errors](https://tickets.puppetlabs.com/browse/PUP-3521)
* [PUP-3754: Better logging when fail to set ownership](https://tickets.puppetlabs.com/browse/PUP-3754)
* [PUP-3081: reported catalog run time is wildly inaccurate](https://tickets.puppetlabs.com/browse/PUP-3081)
* [PUP-3706: console format should pretty print nested structures](https://tickets.puppetlabs.com/browse/PUP-3706)
* [PUP-3698: Make find into the default action for the facts face](https://tickets.puppetlabs.com/browse/PUP-3698)


## Bug Fixes

* [PUP-3245: Function calls no longer showing up in profile data](https://tickets.puppetlabs.com/browse/PUP-3245)
* [PUP-3167: node namespaces override class namespaces if they happen to match](https://tickets.puppetlabs.com/browse/PUP-3167)
* [PUP-3228: "{}" in systemd service files cause services to fail to start](https://tickets.puppetlabs.com/browse/PUP-3228)

### New Deprecations

* [PUP-3654: Deprecate Puppet.newtype](https://tickets.puppetlabs.com/browse/PUP-3654)
* [PUP-3512: Add deprecation warning for old profiler API in Puppet](https://tickets.puppetlabs.com/browse/PUP-3512)
* [PUP-3666: Replace 'configtimeout' with separate HTTP connect and read timeout settings](https://tickets.puppetlabs.com/browse/PUP-3666)

### Regression: `--profile` flag produces less information

In Puppet 4, functions converted to the Puppet 4 function API were not included in the profiling information produced by the `--profile` flag. This caused the profiling output to produce less information than in Puppet 3. Puppet 4.3.2 restores this missing information.

* [PUP-5063](https://tickets.puppetlabs.com/browse/PUP-5063)

### Regression: Resource collectors can't use resource references

Puppet 4.0 introduced a regression where resource collectors using resource references would produce an error. Puppet 4.3.2 fixes that regression.

* [PUP-5465](https://tickets.puppetlabs.com/browse/PUP-5465)  

### Resource Type and Provider Improvements

The biggest change in this category is [PUP-1073](https://tickets.puppetlabs.com/browse/PUP-1073), which implements a long-standing feature request. The Type docs have the details, but now you can, for example, have the same package name like "mysql" managed by two separate resources, one for the gem version and one for the RPM version. 

* The [`yumrepo` type][type_yumrepo] now includes `assumeyes`, `deltarpm_percentage`, and `deltarpm_metadata_percentage` attributes. [PUP-3024: yumrepo: add setting deltarpm_percentage](https://tickets.puppetlabs.com/browse/PUP-3024), [PUP-2923: Add assumeyes attribute to yumrepo](https://tickets.puppetlabs.com/browse/PUP-2923)
* [PUP-1413: Support touch command for augeas type](https://tickets.puppetlabs.com/browse/PUP-1413)
* [PUP-1362: Rubyize yumhelper.py to remove dependency on python](https://tickets.puppetlabs.com/browse/PUP-1362)
* [PUP-3492: Puppet should allow Upstart service provider for Linux Mint](https://tickets.puppetlabs.com/browse/PUP-3492)
* [PUP-3322: Add additional debugging to appdmg provider](https://tickets.puppetlabs.com/browse/PUP-3322)
* [PUP-3338: Systemd should be the default service provider for OpenSuSE >= 12 and SLES 12](https://tickets.puppetlabs.com/browse/PUP-3338)
* [PUP-3695: yum provider handling for --disableexcludes in :install_options](https://tickets.puppetlabs.com/browse/PUP-3695)
* [PUP-3750: The mailalias type should allow the specification of included files](https://tickets.puppetlabs.com/browse/PUP-3750)
* [PUP-1073: Support common package name in two different providers](https://tickets.puppetlabs.com/browse/PUP-1073)
* [PUP-4237: Add puppet_gem provider for managing puppet-agent gems](https://tickets.puppetlabs.com/browse/PUP-4237)
* [PUP-2452: Add reinstallable feature on package type](https://tickets.puppetlabs.com/browse/PUP-2452)
* [PUP-3753: Improve performance of zfs checks.](https://tickets.puppetlabs.com/browse/PUP-3753)

### Resource Type and Provider Bugs

Some of these are subtle, some more in-your-face, but for the most part these bugfixes caused Puppet to behave slightly differently -- better, but differently -- and therefore had to wait for Puppet 4.0 to see the light of day.

* [PUP-3787: puppet resource file 'mode' parameter is 3-digit notation instead of 4-digit](https://tickets.puppetlabs.com/browse/PUP-3787)
* [PUP-1208: md5lite, mtime not honoured for file type/provider](https://tickets.puppetlabs.com/browse/PUP-1208)
    * [PUP-3887: Server should use agent specified checksum](https://tickets.puppetlabs.com/browse/PUP-3887)
    * [PUP-3888: Fix puppet apply writing source to file when using non-md5 checksum type](https://tickets.puppetlabs.com/browse/PUP-3888)
    * [PUP-3889: Fix puppet agent writing source to file when using non-md5 checksum type](https://tickets.puppetlabs.com/browse/PUP-3889)
    * [PUP-3898: Fix writing content to file with non-md5 checksum type](https://tickets.puppetlabs.com/browse/PUP-3898)
    * [PUP-3945: Fix puppet apply/agent when recursively copying a directory](https://tickets.puppetlabs.com/browse/PUP-3945)
    * [PUP-3890: Fix mtime/ctime checksum type](https://tickets.puppetlabs.com/browse/PUP-3890)
    * [PUP-3899: Write acceptance tests](https://tickets.puppetlabs.com/browse/PUP-3899)
* [PUP-4012: parsed provider destroys file if a line starts with uppercase Q](https://tickets.puppetlabs.com/browse/PUP-4012)
* [PUP-900: noop => true is ignored when resource is triggered by other resource](https://tickets.puppetlabs.com/browse/PUP-900)
* [PUP-3346: curl allows --insecure SSL connections](https://tickets.puppetlabs.com/browse/PUP-3346)
    for mac package providers.
* [PUP-3373: 'mount' resource with list of mount options only applies the first option](https://tickets.puppetlabs.com/browse/PUP-3373)
* [PUP-1244: Yum provider using "version-release" to validate installation.](https://tickets.puppetlabs.com/browse/PUP-1244)
    this is a long-running bug where ensure => "version of package, but without the -release suffix" would cause errors.
* [PUP-1270: 'pkg' package provider does not understand IPS package versions properly](https://tickets.puppetlabs.com/browse/PUP-1270)
* [PUP-1293: service status is ignored ( puppet 3.2 + upstart provider )](https://tickets.puppetlabs.com/browse/PUP-1293)
* [PUP-3128: (PR 3003) Pacman provider does not work on manjaro linux](https://tickets.puppetlabs.com/browse/PUP-3128)
* [PUP-3564: pkg provider latest gives empty warnings](https://tickets.puppetlabs.com/browse/PUP-3564)
* [PUP-1085: Pacman provider constantly reinstalls package groups on arch linux](https://tickets.puppetlabs.com/browse/PUP-1085)
* [PUP-3861: Yum provider cannot parse long package names](https://tickets.puppetlabs.com/browse/PUP-3861)
* [PUP-2289: Puppet will purge the /etc/hosts if it have some invalid lines](https://tickets.puppetlabs.com/browse/PUP-2289)
* [PUP-4191: Custom gem provider does not issue the right command to uninstall gem](https://tickets.puppetlabs.com/browse/PUP-4191)
* [PUP-3388: Issue Creating Multiple Mirrors in Zpool Resource](https://tickets.puppetlabs.com/browse/PUP-3388)

### On OpenBSD

Thanks to Jasper Lievisse Adriaanse and Zach Leslie for these changes to help Puppet work better on BSDs.

* [PUP-3243: There's no way the 'bsd' service provider will work on OpenBSD](https://tickets.puppetlabs.com/browse/PUP-3243)
* [PUP-3605: Puppet doesn't remove users from groups on OpenBSD](https://tickets.puppetlabs.com/browse/PUP-3605)
* [PUP-3939: Update OpenBSD service provider to support new syntax of rcctl](https://tickets.puppetlabs.com/browse/PUP-3939)
* [PUP-3144: Rewrite OpenBSD service provider with rcctl(8)](https://tickets.puppetlabs.com/browse/PUP-3144)
* [PUP-3736: OpenBSD service provider should restart a service when flags are changed](https://tickets.puppetlabs.com/browse/PUP-3736)
* [PUP-3723: Add support for setting a user's login class](https://tickets.puppetlabs.com/browse/PUP-3723) -- only affects openbsd for now. new `loginclass` attribute.

### On Windows

On Windows, `group` resources now respect the `auth_membership` attribute, which lets you control whether `members` is the complete list of members or a minimum list of members. (Previously, Puppet ignored this attribute on Windows.) Note that the default value of this attribute has also changed; see the breaking changes section on resource types. 

Weekly `scheduled_task` resources would attempt to set the trigger on every run, due to part of the trigger being compared to the wrong thing. This is fixed. 

* [PUP-2628: Ability to add a member to a group, instead of specifying the complete list](https://tickets.puppetlabs.com/browse/PUP-2628)
* [PUP-3429: Weekly tasks always notify 'trigger changed'](https://tickets.puppetlabs.com/browse/PUP-3429)
* [PUP-2647: Windows user provider reports that the password is created instead of changed](https://tickets.puppetlabs.com/browse/PUP-2647)
* [PUP-2609: Don't allow source_permissions to be set to anything other than ignore on Windows](https://tickets.puppetlabs.com/browse/PUP-2609)
* [PUP-1276: Tidy causes 'Cannot alias' ArgumentError exception on Windows](https://tickets.puppetlabs.com/browse/PUP-1276)
* [PUP-1802: Puppet should execute ruby.exe not cmd.exe when running as a windows service](https://tickets.puppetlabs.com/browse/PUP-1802)
* [PUP-3247: Win32::TaskScheduler#trigger_string doesn't work](https://tickets.puppetlabs.com/browse/PUP-3247)
* [PUP-3724: Use ffi 1.9.6 for Ruby 2.1 in puppet-win32-ruby](https://tickets.puppetlabs.com/browse/PUP-3724)
* [PUP-3837: Work around Ruby string encoding behavior exercised during registry calls in win32/registry](https://tickets.puppetlabs.com/browse/PUP-3837)
* [PUP-3842: Ensure that Puppet 4 FOSS MSI includes MCO](https://tickets.puppetlabs.com/browse/PUP-3842)
* [PUP-3844: Puppet MSI filename should be puppet-agent.msi by default](https://tickets.puppetlabs.com/browse/PUP-3844)
* [PUP-3845: Windows Unified Installer should track internal component versions](https://tickets.puppetlabs.com/browse/PUP-3845)
* [PUP-3951: Prefer api_types.read_wide_str(length, encoding) in Windows calls](https://tickets.puppetlabs.com/browse/PUP-3951)


## Puppet Language, Hiera, and Function Features

* [PUP-1515: When compiling a catalog, providers should be loaded from specified environment](https://tickets.puppetlabs.com/browse/PUP-1515)
* [PUP-1601: functions accepting regexp string should also accept Regexp](https://tickets.puppetlabs.com/browse/PUP-1601)
* [PUP-3462: Hiera scope: add the key 'calling_class_path'](https://tickets.puppetlabs.com/browse/PUP-3462)
* [PUP-4046: hiera_include broken](https://tickets.puppetlabs.com/browse/PUP-4046)
* [PUP-4070: Deep merge options cannot be passed as options map.](https://tickets.puppetlabs.com/browse/PUP-4070)
* [PUP-4081: lookup should lookup in module when looking up qualified names](https://tickets.puppetlabs.com/browse/PUP-4081)
* [PUP-4132: Pass merge strategy to Hiera using Indirector::Request options](https://tickets.puppetlabs.com/browse/PUP-4132)
* [PUP-4133: Future parser error when interpolating name segment starting with underscore](https://tickets.puppetlabs.com/browse/PUP-4133)
* [PUP-4205: Puppet 4 lexer fails to parse multiple heredocs on the same line](https://tickets.puppetlabs.com/browse/PUP-4205)
* [PUP-3949: Update docs for application/octet-stream and binary Accept value](https://tickets.puppetlabs.com/browse/PUP-3949)

## New Features in Resource Type and Provider API

* [PUP-3331: Custom Types should be able to call all levels of auto* relationships.](https://tickets.puppetlabs.com/browse/PUP-3331)


## Miscellaneous Improvements and Bug Fixes


* [PUP-3379: Bring back retry action and fix up](https://tickets.puppetlabs.com/browse/PUP-3379)
* [PUP-1635: "current thread not owner" after Puppet Agent receives USR1 signal](https://tickets.puppetlabs.com/browse/PUP-1635)
* [PUP-3935: Pluginsync errors when no source is available and modulepath directory is a symlink](https://tickets.puppetlabs.com/browse/PUP-3935)

## Miscellaneous New Features

* [PUP-3666: Replace 'configtimeout' with separate HTTP connect and read timeout settings](https://tickets.puppetlabs.com/browse/PUP-3666)


## Performance Improvements

* [PUP-3436: Optimize CPU intensitive compiler methods](https://tickets.puppetlabs.com/browse/PUP-3436)
* [PUP-659: Qualified variable lookups are very slow under Puppet 2.7+ unless prefixed with ::](https://tickets.puppetlabs.com/browse/PUP-659)
* [PUP-3389: Significant delay in puppet runs with growing numbers of directory environments](https://tickets.puppetlabs.com/browse/PUP-3389)


## New Feature: Data Binder

* [PUP-1640: Provide agnostic mechanism for Hiera Based Data in Modules](https://tickets.puppetlabs.com/browse/PUP-1640)
* [PUP-3948: Let lookup be the impl for agnostic lookup of data](https://tickets.puppetlabs.com/browse/PUP-3948)
* [PUP-3900: Data providers cannot be added in modules](https://tickets.puppetlabs.com/browse/PUP-3900)
* [PUP-4016: Consider short circuiting data binding if lookup is called as the default value](https://tickets.puppetlabs.com/browse/PUP-4016)

## Preparations for Facter 3.0

* [PUP-3821: Use of cfacter on Windows causes error](https://tickets.puppetlabs.com/browse/PUP-3821)
* [PUP-3679: Drop service dependency on the 'ps' fact](https://tickets.puppetlabs.com/browse/PUP-3679)

## Module Tool Improvements

* [PUP-3569: module skeleton should not require rubygems](https://tickets.puppetlabs.com/browse/PUP-3569)
* [PUP-3962: Test for module directories starting with '.'](https://tickets.puppetlabs.com/browse/PUP-3962)
* [PUP-3894: Default license for module metadata does not match an identifier provided by SPDX](https://tickets.puppetlabs.com/browse/PUP-3894)
* [PUP-3981: Missing PMT Acceptance Test for Building Module with a Modulefile](https://tickets.puppetlabs.com/browse/PUP-3981)
* [PUP-3121: Puppet module generate - dependency problem](https://tickets.puppetlabs.com/browse/PUP-3121)
* [PUP-3168: Fix all file permissions on puppet module install](https://tickets.puppetlabs.com/browse/PUP-3168)
* [PUP-3124: tool should generate code using the actual module name as the directory instead of username-modulename](https://tickets.puppetlabs.com/browse/PUP-3124)
* [PUP-3082: Error in puppet module skeleton](https://tickets.puppetlabs.com/browse/PUP-3082)
* [PUP-3568: module skeleton should use puppet-lint v1](https://tickets.puppetlabs.com/browse/PUP-3568)


## Administrivia, Testing, Docs and Specs, Packaging, Internal Clean-ups


* [PUP-2733: Puppet squats on the PuppetX::Puppetlabs and PuppetX::Puppet namespaces](https://tickets.puppetlabs.com/browse/PUP-2733)
* [PUP-3393: relationship_spec.rb has minor bugs](https://tickets.puppetlabs.com/browse/PUP-3393)
* [PUP-3457: Puppet::Util::Execution.execute should not switch uid if it already matches the euid](https://tickets.puppetlabs.com/browse/PUP-3457)
* [PUP-3488: Stop overwriting the agent's facts timestamp](https://tickets.puppetlabs.com/browse/PUP-3488)
* [PUP-2909: Incorporate linting and static verification with rubocop](https://tickets.puppetlabs.com/browse/PUP-2909)
* [PUP-3239: Add a validate method to Puppet::Node::Environment so the Compiler can easily halt for environments with bad configuration.](https://tickets.puppetlabs.com/browse/PUP-3239)
* [PUP-3997: Audit and update puppet acceptance tests that assume the puppet user and group are present](https://tickets.puppetlabs.com/browse/PUP-3997)
* [PUP-3912: Update specs to rspec 3](https://tickets.puppetlabs.com/browse/PUP-3912)
* [PUP-3300: Rework Puppet::Util::Checksums to not extend itself](https://tickets.puppetlabs.com/browse/PUP-3300)
* [PUP-3475: Plan transition to JSON](https://tickets.puppetlabs.com/browse/PUP-3475)
* [PUP-3511: Refactor Application.run() for external reuse](https://tickets.puppetlabs.com/browse/PUP-3511)
* [PUP-3609: Partial revert of PUP-2732](https://tickets.puppetlabs.com/browse/PUP-3609)
* [PUP-3982: Ensure puppet service supports conditional restart](https://tickets.puppetlabs.com/browse/PUP-3982)
* [PUP-2716: ssl_server_ca_chain and ssl_client_ca_chain are dead settings](https://tickets.puppetlabs.com/browse/PUP-2716)
    the settings were never enabled, the commented-out rough versions were deleted, and other code was referring to values that would never be set. No user-facing impact.
* [PUP-4004: Remove acceptance workaround that creates the puppetserver cache related directories](https://tickets.puppetlabs.com/browse/PUP-4004)
* [PUP-2948: Enable rubocop for PRs in Github](https://tickets.puppetlabs.com/browse/PUP-2948)
* [PUP-2950: Enable rubocop:Style/AndOr for pops](https://tickets.puppetlabs.com/browse/PUP-2950)
* [PUP-3013: Add acceptance test for PMT build command changes for 3.7](https://tickets.puppetlabs.com/browse/PUP-3013)
* [PUP-3061: Upgrade win32-eventlog to 0.6.2+](https://tickets.puppetlabs.com/browse/PUP-3061)
* [PUP-3835: Specify that variables are case sensitive](https://tickets.puppetlabs.com/browse/PUP-3835)
* [PUP-2366: Replace hosts using Ruby 1.8.7 for Puppet 4.0 Acceptance](https://tickets.puppetlabs.com/browse/PUP-2366)
* [PUP-3779: Verify spec tests in dev env for Ruby 2.1.5](https://tickets.puppetlabs.com/browse/PUP-3779)
* [PUP-3780: Verify Ruby 2.1.5 compatibility on Windows 2003](https://tickets.puppetlabs.com/browse/PUP-3780)
* [PUP-3816: Verify correct gems are in puppet-win32-ruby 2.1.5-x86 and 2.1.5-x64 branches](https://tickets.puppetlabs.com/browse/PUP-3816)
* [PUP-2343: IPS acceptance tests should be confined to solaris-11 only](https://tickets.puppetlabs.com/browse/PUP-2343)
* [PUP-2346: Acceptance tests cannot depend on 'readlink' or 'stat' on Solaris 10](https://tickets.puppetlabs.com/browse/PUP-2346)
* [PUP-3076: Solaris (10) acceptance tests assume that /opt/csw/bin (opencsw) is in the path (necessary for solaris 10)](https://tickets.puppetlabs.com/browse/PUP-3076)
* [PUP-3818: Execute Windows acceptance pre-suite against Ruby 2.1.5](https://tickets.puppetlabs.com/browse/PUP-3818)
* [PUP-3915: Remove win32console for Windows Ruby 2.1.5](https://tickets.puppetlabs.com/browse/PUP-3915)
    this was only needed if you were running under 1.9.x, which we don't anymore.
* [PUP-3479: Windows ffi dependency fails for Ruby 2.1.3](https://tickets.puppetlabs.com/browse/PUP-3479)
* [PUP-3850: Two User provider spec tests fail on RedHat systems](https://tickets.puppetlabs.com/browse/PUP-3850)
* [PUP-3954: Determine failure for already_installed_elsewhere.rb acceptance test](https://tickets.puppetlabs.com/browse/PUP-3954)
* [PUP-3137: expiry parameter definition in user resource documentation needs update](https://tickets.puppetlabs.com/browse/PUP-3137)
* [PUP-3070: Include indent file in vim-puppet](https://tickets.puppetlabs.com/browse/PUP-3070)
* [PUP-3003: Windows MSI contains unneeded files](https://tickets.puppetlabs.com/browse/PUP-3003)
* [PUP-3016: tests/modules/install/with_version.rb assumes `puppet` is on the path](https://tickets.puppetlabs.com/browse/PUP-3016)
* [PUP-3603: Update language spec with new String to Float behavior in PUP-3602 and PUP-3615](https://tickets.puppetlabs.com/browse/PUP-3603)
* [PUP-4033: add puppet-agent path acceptance tests](https://tickets.puppetlabs.com/browse/PUP-4033)
* [PUP-4152: Try Debian 8 32-bit](https://tickets.puppetlabs.com/browse/PUP-4152)
* [PUP-4153: Try Debian 8 64-bit](https://tickets.puppetlabs.com/browse/PUP-4153)
* [PUP-4171: Try Fedora 20 32 bit](https://tickets.puppetlabs.com/browse/PUP-4171)
* [PUP-4172: Try Fedora 20 64 bit](https://tickets.puppetlabs.com/browse/PUP-4172)
* [PUP-4173: Try Fedora 21 32 bit](https://tickets.puppetlabs.com/browse/PUP-4173)
* [PUP-4174: Try Fedora 21 64 bit](https://tickets.puppetlabs.com/browse/PUP-4174)
* [PUP-4232: add acceptance tests for lookup()](https://tickets.puppetlabs.com/browse/PUP-4232)
* [PUP-2699: Puppet specs on windows triggers "Excluding C from search path. Fact file paths must be an absolute directory"](https://tickets.puppetlabs.com/browse/PUP-2699)
* [PUP-4011: Spec test failure on ruby 1.8.7: ProviderSystemd should not be the default provider on rhel4](https://tickets.puppetlabs.com/browse/PUP-4011)
* [PUP-3969: Puppet acceptance tests need auditing to derive 'host' and 'group' using the Beaker 'puppet' helper](https://tickets.puppetlabs.com/browse/PUP-3969)
* [PUP-4056: Audit acceptance tests for assumed ruby location](https://tickets.puppetlabs.com/browse/PUP-4056)
* [PUP-4093: Try out puppet acceptance against aio packages for non-el7 linux platforms](https://tickets.puppetlabs.com/browse/PUP-4093)
* [PUP-3960: Presence of createrepo not checked by acceptance/rpm_util.rb](https://tickets.puppetlabs.com/browse/PUP-3960)
* [PUP-3549: Debian init script status and stop actions are unsafe](https://tickets.puppetlabs.com/browse/PUP-3549)
* [PUP-3010: Allow Upstart jobs on Amazon Linux](https://tickets.puppetlabs.com/browse/PUP-3010)
* [PUP-3166: Debian service provider on docker with insserv (dep boot sequencing)](https://tickets.puppetlabs.com/browse/PUP-3166)
* [PUP-3090: Packaging for puppet masters should include always_cache_features set to true.](https://tickets.puppetlabs.com/browse/PUP-3090)
* [PUP-4340: source_attribute acceptance test failing intermittently](https://tickets.puppetlabs.com/browse/PUP-4340)
* [PUP-4057: Acceptance tests should not rely on the puppetpath beaker option](https://tickets.puppetlabs.com/browse/PUP-4057)
* [PUP-4150: Puppet-Agent Acceptance on RHEL5/6 failed](https://tickets.puppetlabs.com/browse/PUP-4150)
* [PUP-4330: Remove Puppet dependency on facter/util/plist.](https://tickets.puppetlabs.com/browse/PUP-4330)
* [PUP-4088: update puppet-agent path acceptance for Windows 2003 and 32-bit app on 64-bit OS](https://tickets.puppetlabs.com/browse/PUP-4088)


### Wontfix

* [PUP-2701: Add acceptance tests for PMT build metadata.json support](https://tickets.puppetlabs.com/browse/PUP-2701)
* [PUP-3015: Add acceptance test for PMT search command changes for 3.7](https://tickets.puppetlabs.com/browse/PUP-3015)
* [PUP-528: Line number information missing from 3x AST transformer errors](https://tickets.puppetlabs.com/browse/PUP-528)
* [PUP-3371: Ensure PSON parser only creates safe Hash and Array object types](https://tickets.puppetlabs.com/browse/PUP-3371)
* [PUP-3470: Syntax error in test suite on Ruby <= 1.8.7-p352](https://tickets.puppetlabs.com/browse/PUP-3470)
* [PUP-524: Complete Testing of Relationships](https://tickets.puppetlabs.com/browse/PUP-524)
* [PUP-739: Profile agent with complex catalog](https://tickets.puppetlabs.com/browse/PUP-739)
* [PUP-742: Identify components involved in puppet runs](https://tickets.puppetlabs.com/browse/PUP-742)
* [PUP-743: Retrieving a resource from a catalog](https://tickets.puppetlabs.com/browse/PUP-743)
* [PUP-2304: Implement "requirements" support for the PMT](https://tickets.puppetlabs.com/browse/PUP-2304)
* [PUP-2694: Scope replacing webrick with a rack-based lightweight server, e.g. thin](https://tickets.puppetlabs.com/browse/PUP-2694)
* [PUP-1119: List known environments on CLI](https://tickets.puppetlabs.com/browse/PUP-1119)
* [PUP-1149: Show environment information on CLI](https://tickets.puppetlabs.com/browse/PUP-1149)
* [PUP-3554: Validate all of the forge modules using future parser](https://tickets.puppetlabs.com/browse/PUP-3554)
* [PUP-3188: Puppet module tool no longer processes files starting with a period as erb](https://tickets.puppetlabs.com/browse/PUP-3188)
* [PUP-1263: Synonyms (title, namevar, name) make it confusing.](https://tickets.puppetlabs.com/browse/PUP-1263)
* [PUP-2105: Puppet config face and the --configprint option operate directly on environment.conf.](https://tickets.puppetlabs.com/browse/PUP-2105)

### Duplicates

* [PUP-3297: Remove deprecated Puppet::Settings::BaseSetting methods](https://tickets.puppetlabs.com/browse/PUP-3297)
* [PUP-3824: Ruby 2.1.5 - Puppet-Win32-Ruby - Clean Docs and Fix bin files](https://tickets.puppetlabs.com/browse/PUP-3824)
* [PUP-280: Variables outside of class definition in module does not produce error when running puppet apply](https://tickets.puppetlabs.com/browse/PUP-280)
* [PUP-3225: Remove legacy and dynamic environment support.](https://tickets.puppetlabs.com/browse/PUP-3225)
* [PUP-3499: Remove deprecated 'templatedir' setting](https://tickets.puppetlabs.com/browse/PUP-3499)
* [PUP-3499: Remove deprecated 'templatedir' setting](https://tickets.puppetlabs.com/browse/PUP-3499)
* [PUP-3942: Make sure classifier.yaml is under $confdir](https://tickets.puppetlabs.com/browse/PUP-3942)
* [PUP-3943: Make sure console.conf is under $confdir](https://tickets.puppetlabs.com/browse/PUP-3943)
* [PUP-3310: Remove warning for copying owner/group to windows](https://tickets.puppetlabs.com/browse/PUP-3310)
* [PUP-3292: Remove Modulefile support](https://tickets.puppetlabs.com/browse/PUP-3292)
* [PUP-2804: Remove deprecation warnings introduced into Windows code during FFI](https://tickets.puppetlabs.com/browse/PUP-2804)

