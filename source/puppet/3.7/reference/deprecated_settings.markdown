---
layout: default
title: "Deprecated Settings"
---




The following Puppet settings are deprecated, and will be removed in Puppet 4.0. Many of them are related to other deprecated features.


Config File Environment Settings
-----

* [`manifest`](/references/3.7.latest/configuration.html#manifest)
* [`modulepath`](/references/3.7.latest/configuration.html#modulepath)
* [`config_version`](/references/3.7.latest/configuration.html#configversion)

### Now

You can set global values for the [`manifest`][manifest_setting], [`modulepath`][modulepath_setting], and [`config_version`][config_version] settings in [puppet.conf][].

### In Puppet 4.0

The `manifest`, `modulepath`, and `config_version` settings are not allowed in [puppet.conf][]. They can be configured per-environment in [environment.conf][].

### Detecting and Updating

If you are using config file environments, your Puppet masters will log deprecation warnings about it.

Read the page on [config file environments][], and remove the relevant settings and sections from puppet.conf on your Puppet masters. Then, switch to using [directory environments][].

### Context

See the note about [the deprecation of config file environments.](./deprecated_misc.html#config-file-environments)


Activerecord Storeconfigs Settings
-----

* [`async_storeconfigs`](/references/3.7.latest/configuration.html#asyncstoreconfigs)
* [`dbadapter`](/references/3.7.latest/configuration.html#dbadapter)
* [`dbconnections`](/references/3.7.latest/configuration.html#dbconnections)
* [`dblocation`](/references/3.7.latest/configuration.html#dblocation)
* [`dbmigrate`](/references/3.7.latest/configuration.html#dbmigrate)
* [`dbname`](/references/3.7.latest/configuration.html#dbname)
* [`dbpassword`](/references/3.7.latest/configuration.html#dbpassword)
* [`dbport`](/references/3.7.latest/configuration.html#dbport)
* [`dbserver`](/references/3.7.latest/configuration.html#dbserver)
* [`dbsocket`](/references/3.7.latest/configuration.html#dbsocket)
* [`dbuser`](/references/3.7.latest/configuration.html#dbuser)
* [`queue_source`](/references/3.7.latest/configuration.html#queuesource)
* [`queue_type`](/references/3.7.latest/configuration.html#queuetype)
* [`rails_loglevel`](/references/3.7.latest/configuration.html#railsloglevel)
* [`railslog`](/references/3.7.latest/configuration.html#railslog)
* [`thin_storeconfigs`](/references/3.7.latest/configuration.html#thinstoreconfigs)

### Now

Activerecord-based storeconfigs still works, and these settings configure various parts of it.

### In Puppet 4.0

It's gone, and so are the settings. Use PuppetDB instead.

### Detecting and Updating

Look for the settings in your puppet master config files and delete them. Install PuppetDB.

### Context

Activerecord storeconfigs was an old and slow system that could do a fraction of what PuppetDB does, badly.


Inventory Service Settings
-----

* [`inventory_port`](/references/3.7.latest/configuration.html#inventoryport)
* [`inventory_server`](/references/3.7.latest/configuration.html#inventoryserver)
* [`inventory_terminus`](/references/3.7.latest/configuration.html#inventoryterminus)

### Now

These settings configure the deprecated inventory service.

### In Puppet 4.0

The settings are gone.

### Detecting and Updating

If you or your applications use the inventory service, you should switch to [PuppetDB][]. Delete these settings from puppet.conf on your Puppet master(s), install PuppetDB, and change any custom code to speak directly to PuppetDB's API.

### Context

The inventory service could do a fraction of what PuppetDB did, with a slower and less flexible API. It's been replaced.

Other Settings
-----

### `allow_variables_with_dashes`

* [`allow_variables_with_dashes`](/references/3.7.latest/configuration.html#allowvariableswithdashes)

#### Now

This setting appears to no longer work.

#### In Puppet 4.0

The setting is gone.

#### Detecting and Updating

If this is set in puppet.conf on your master(s), you'll need to delete it.

#### Context

This setting was designed to reduce the damage from a pair of bad decisions we made in the Puppet 2.7 era.

### `catalog_format`

* [`catalog_format`](/references/3.7.latest/configuration.html#catalogformat)

#### Now

It's present

#### In Puppet 4.0

It's gone

#### Detecting and Updating

Search your puppet.conf file on agent nodes for the name of the setting.

#### Context

This setting was replaced by the [`preferred_serialization_format`](/references/3.7.latest/configuration.html#preferredserializationformat) setting.

### `dynamicfacts`

* [`dynamicfacts`](/references/3.7.latest/configuration.html#dynamicfacts)

#### Now

It's dead code and does nothing, but you can still set it in puppet.conf. It'll cause a deprecation warning.

#### In Puppet 4.0

It's gone.

#### Detecting and Updating

Deprecation warning:

    The dynamicfacts setting is deprecated and will be ignored.

#### Context

I don't think we ever actually implemented the behavior it seems designed for?

### `listen`

* [`listen`](/references/3.7.latest/configuration.html#listen)

#### Now

Setting `listen = true` will cause `puppet agent` to listen for incoming connections on port 8140.

#### In Puppet 4.0

The setting is gone.

#### Detecting and Updating

See [the note on `puppet kick`.](./deprecated_command.html#puppet-kick)

#### Context

See [the note on `puppet kick`.](./deprecated_command.html#puppet-kick)


### `manifestdir`

* [`manifestdir`](/references/3.7.latest/configuration.html#manifestdir)

#### Now

This setting is used to construct the default value of the `manifest` setting. It has no other purpose. However, the directory it specifies has to exist, or else Puppet will raise an error.

#### In Puppet 4.0

The setting is gone and its directory doesn't have to exist.

#### Detecting and Updating

Nothing needed.

#### Context

I dunno why this ever existed.

### `masterlog`

* [`masterlog`](/references/3.7.latest/configuration.html#masterlog)

#### Now

This setting does literally nothing but can be set in puppet.conf.

#### In Puppet 4.0

The setting is gone.

#### Detecting and Updating

Nothing needed. If you have the setting set and you upgrade, Puppet will give an error and ask you to remove it.

#### Context

This might have done something once, but has probably been dead code since before Puppet 2.6.

### `stringify_facts = true`


* [`stringify_facts`](/references/latest/configuration.html#stringifyfacts)

#### Now

It defaults to true

#### In Puppet 4.0

it's still around but defaults to false

#### Detecting and Updating

No warning. Set it to false and see if anything blows up.

#### Context

This should only affect you if you have custom facts that naïvely return something other than a string (a bool, an array...) and you have regexes or something that rely on that implicit stringification behavior.

* [PUP-406: Deprecate stringify_fact = true](https://tickets.puppetlabs.com/browse/PUP-406)


### `templatedir`

* [`templatedir`](/references/3.7.latest/configuration.html#templatedir)

#### Now

When given a relative path, the [`template` function](/references/3.7.latest/function.html#template) will try to find templates in this directory before trying to find them in modules.

#### In Puppet 4.0

The `template` function will only search modules when given a relative path.

#### Detecting and Updating

No warning.

Look for it in puppet.conf on your master(s), see if the directory exists, see if there's anything in the directory. If so, you'll need to identify any Puppet code that references those templates, move the templates into modules, and change the code that refers to them so they can find them in their new homes.

#### Context

This setting and its behavior predate Puppet's module system. Now that all templates should go in modules, it adds unnecessary complexity.

