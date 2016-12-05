---
layout: default
title: "About Deprecations in This Version of Puppet"
---

[puppet.conf]: ./config_file_main.html

## About Deprecations in Puppet 3.7

We expect Puppet 3.7 to be one of the final releases (if not **the** final release) before Puppet 4.0.

Since 4.0 counts as a major version under our versioning scheme, it's a rare opportunity to perform major cleanups of Puppet's code and behavior, and we've spent months identifying things we want to fix.

Some of these fixes can cause breaking changes to Puppet's user-facing behavior, and we need to make sure users are prepared before they upgrade. Thus, these pages collect all of the deprecated features that will be vanishing or changing significantly in Puppet 4.0.

If you use Puppet, you should definitely read through these pages at least once. Please identify any deprecated features you think will affect you, and make sure you understand how to find uses of them in your code and how to update your code to eliminate them.


## Three Kinds of Deprecations

There are three main kinds of deprecations in this release:

### Deprecations With Warnings

Some features will cause deprecation warnings when you use them. These are the easiest to find.

First, ensure that [the `disable_warnings` setting](./configuration.html#disablewarnings) is not set, on your Puppet master(s) or on any agent nodes.

Next, reset your Puppet master's web server. (In Puppet Enterprise, you can usually run `sudo service pe-httpd restart` to do this.) This will reset Puppet's automatic suppression of repeated deprecation warnings.

Finally, let your nodes go about their normal business while monitoring the syslog file on your Puppet master(s) and the syslog or event log on at least one agent node. (See the documentation on logging [for `puppet master`](./services_master_rack.html#logging) and for `puppet agent` [on \*nix](./services_agent_unix.html#logging) and [on Windows](./services_agent_windows.html#logging).)

Each deprecation that logs a warning will have an example of that warning in its "Detecting and Updating" section. Look for these warnings in your logs, and react as needed.

### Deprecations Revealed by the Future Parser

Some deprecated features do not log warnings, but will cause noisy and obvious failures in Puppet 4's implementation of the Puppet language. In these cases, you can root out failures by temporarily setting `parser = future` in [puppet.conf][] on your Puppet master(s). This lets you identify uses of deprecated features at your leisure, while still being able to revert to pre-4.0 behavior if you aren't ready to fix every failure yet.

### Deprecations Without Warnings

Some deprecated features (mostly the rarest or most obvious ones) have no warnings and cannot be smoked out by turning on the future parser; they will simply stop working once you upgrade to 4.0. For these features, the "Detecting and Updating" section of their deprecation notice will include brief instructions for finding out whether you're affected. Sometimes this involves a global text search; other times it may involve a survey of the custom tooling you've built around Puppet's APIs.

## Complete List of Deprecations

Use the navigation sidebar to the left to browse the lists of deprecated features in Puppet 3.7.

You may want to print out the following checklist, to use while investigating deprecated feature usage at your site.


* [Language Features](./deprecated_language.html)
    * [Relative Resolution of Class Names](./deprecated_language.html#relative-resolution-of-class-names)
    * [Node Inheritance](./deprecated_language.html#node-inheritance)
    * [Importing Manifests](./deprecated_language.html#importing-manifests)
    * [Matching Numbers With Regular Expressions](./deprecated_language.html#matching-numbers-with-regular-expressions)
    * [The search Function](./deprecated_language.html#the-search-function)
    * [Variable Names Beginning With Capital Letters](./deprecated_language.html#variable-names-beginning-with-capital-letters)
    * [Class Names Containing Hyphens](./deprecated_language.html#class-names-containing-hyphens)
    * [Mutating Arrays and Hashes](./deprecated_language.html#mutating-arrays-and-hashes)
    * [The Ruby DSL](./deprecated_language.html#the-ruby-dsl)
* [Resource Type Features](./deprecated_resource.html)
    * [file](./deprecated_resource.html#file)
        * [Non-String mode Values](./deprecated_resource.html#non-string-mode-values)
        * [Default Copying of Source Permissions](./deprecated_resource.html#default-copying-of-source-permissions)
        * [`recurse => inf`](./deprecated_resource.html#recurse--inf)
    * [cron](./deprecated_resource.html#cron)
        * [Conservative Purging of Cron Resources](./deprecated_resource.html#conservative-purging-of-cron-resources)
    * [package](./deprecated_resource.html#package)
        * [Old msi Package Provider](./deprecated_resource.html#old-msi-package-provider)
* [Extension Points and APIs](./deprecated_api.html)
    * [Resource Type and Provider APIs](./deprecated_api.html#resource-type-and-provider-apis)
        * [Automatic Unwrapping of Single Element Array Values for Parameters and Properties](./deprecated_api.html#automatic-unwrapping-of-single-element-array-values-for-parameters-and-properties)
        * [`:parent` Argument For Creating Resource Types](./deprecated_api.html#parent-argument-for-creating-resource-types)
    * [The Inventory Service](./deprecated_api.html#the-inventory-service)
    * [ActiveRecord Storeconfigs](./deprecated_api.html#activerecord-storeconfigs)
    * [YAML in HTTP API Calls](./deprecated_api.html#yaml-in-http-api-calls)
    * [Miscellaneous APIs](./deprecated_api.html#miscellaneous-apis)
        * [`Puppet::Plugins`](./deprecated_api.html#puppetplugins)
        * [CouchDB Facts Terminus](./deprecated_api.html#couchdb-facts-terminus)
        * [`Puppet::Node::Environment.current`](./deprecated_api.html#puppetnodeenvironmentcurrent)
* [Command Line Features](./deprecated_command.html)
    * [puppet kick](./deprecated_command.html#puppet-kick)
    * [puppet queue](./deprecated_command.html#puppet-queue)
    * [puppet facts find --terminus rest](./deprecated_command.html#puppet-facts-find---terminus-rest)
    * [puppet facts upload](./deprecated_command.html#puppet-facts-upload)
* [Settings](./deprecated_settings.html)
    * [Config File Environment Settings](./deprecated_settings.html#config-file-environment-settings)
    * [Activerecord Storeconfigs Settings](./deprecated_settings.html#activerecord-storeconfigs-settings)
    * [Inventory Service Settings](./deprecated_settings.html#inventory-service-settings)
    * [Other Settings](./deprecated_settings.html#other-settings)
        * [`allow_variables_with_dashes`](./deprecated_settings.html#allowvariableswithdashes)
        * [`catalog_format`](./deprecated_settings.html#catalogformat)
        * [`dynamicfacts`](./deprecated_settings.html#dynamicfacts)
        * [`listen`](./deprecated_settings.html#listen)
        * [`manifestdir`](./deprecated_settings.html#manifestdir)
        * [`masterlog`](./deprecated_settings.html#masterlog)
        * [`stringify_facts = true`](./deprecated_settings.html#stringifyfacts--true)
        * [`templatedir`](./deprecated_settings.html#templatedir)
        * [`couchdb_url`](./deprecated_settings.html#couchdburl)
* [Other Features](./deprecated_misc.html)
    * [Config File Environments](./deprecated_misc.html#config-file-environments)
    * [Non-Recursive Main Manifest Directory Loading](./deprecated_misc.html#non-recursive-main-manifest-directory-loading)
    * [The Modulefile](./deprecated_misc.html#the-modulefile)
    * [The Hidden _timestamp Fact](./deprecated_misc.html#the-hidden-timestamp-fact)
    * [The Instrumentation System](./deprecated_misc.html#the-instrumentation-system)
