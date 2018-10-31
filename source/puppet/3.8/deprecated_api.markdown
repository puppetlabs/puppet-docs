---
layout: default
title: "Deprecated Extension Points and APIs"
---

[inventory service]: https://github.com/puppetlabs/puppet-docs/blob/0db89cbafa112be256aab67c42b913501200cdca/source/guides/inventory_service.markdown
[puppet.conf]: ./config_file_main.html
[puppetdb]: {{puppetdb}}
[auth.conf]: ./config_file_auth.html
[exported resources]: ./lang_exported.html


The following APIs and extension points are deprecated, and will be removed in Puppet 4.0.


Resource Type and Provider APIs
-----

### Automatic Unwrapping of Single Element Array Values for Parameters and Properties

#### Now

If a user specifies a single element array as the value of a resource attribute:

~~~ ruby
    my_type { 'name':
      my_property => ['value'],
    }
~~~

...then Puppet will automagically unwrap the array, and the resource type will receive the first element of the array as the value. (In the example above, the type would see the value of `my_property` as `'value'` rather than as `['value']`.)

Note that this only happens when parsing manifests, not when writing tests that create resources.

#### In Puppet 4.0

Puppet will not automagically unwrap single-element arrays. The resource type will always receive the actual specified value.

#### Detecting and Updating

Puppet **will not** log a deprecation warning when this behavior occurs. You can turn on the Puppet 4 behavior by setting `parser = future` in [puppet.conf][] on your Puppet master(s).

For most existing resource types, the author has already written defensive code to get around this behavior, and the user-facing behavior shouldn't change. If you identify any types that were relying on automatic de-arrayification, you may need to revise the parameter and property munging.

#### Context

This was generally unexpected, and plugin authors experienced it as hostile magic. The fact that it didn't do the same thing during tests made the situation even worse. Removing it improves consistency and makes it easier to write plugins.

* [PUP-1299: Deprecate and eliminate magic parameter array handling](https://tickets.puppetlabs.com/browse/PUP-1299)

### `:parent` Argument For Creating Resource Types

#### Now

You can pass a `:parent` parameter to the method that creates a new resource type, but it won't do anything.

#### In Puppet 4.0

The method that creates a new resource type will not accept a `:parent` parameter.

#### Detecting and Updating

If any of your custom resource types use this argument, Puppet will log the following deprecation warning:

    Warning: option :parent is deprecated. It has no effect

#### Context

This parameter appears to have been dead code for a very long time, so we're cleaning it up.

* [PUP-899: Deprecate parent parameter for type](https://tickets.puppetlabs.com/browse/PUP-899)


The Inventory Service
-----

### Now

It's possible to query fact information from the Puppet master using the [inventory service][] API. This requires you to connect the Puppet master to a database using [several related settings](./deprecated_settings.html#inventory-service-settings), and open some routes in [auth.conf][]. Once you've done that, you can:

- Use the `/facts` and `/facts_search` HTTP API endpoints
- Use the [`puppet facts upload`](./deprecated_command.html#puppet-facts-upload) and [`puppet facts find --terminus rest`](./deprecated_command.html#puppet-facts-find---terminus-rest) commands

### In Puppet 4.0

The `/facts` and `/facts_search` HTTPS endpoints are removed, and the `puppet facts` commands that interface with the inventory service no longer work.

### Detecting and Updating

Puppet **will not** log deprecation warnings if you are using the inventory service. To determine if you're affected, look over any custom integrations you've built and see whether they're using the affected commands or endpoints.

For a similar but superior interface, you should use [PuppetDB][] and its extensive API for fact data.

### Context

The inventory service was kind of an awkward API, and PuppetDB's API is much better.

* [PUP-1874: Deprecate the inventory service on master](https://tickets.puppetlabs.com/browse/PUP-1874)


ActiveRecord Storeconfigs
-----

### Now

Using [several related settings,](./deprecated_settings.html#activerecord-storeconfigs-settings) a Puppet master can be connected directly to a database using ActiveRecord. Once enabled, Puppet will send catalogs and facts to the database to enable [exported resources][].

Although there is no public API to the storeconfigs database, it's possible to manipulate the database directly and write custom integrations with Puppet's data.

Since ActiveRecord storeconfigs is heinously slow and rickety when given normal catalogs, you can limit the data Puppet sends to it using the `thin_storeconfigs` setting.

You can also prevent storeconfigs' slowness from causing catalog runs to timeout by enabling the `async_storeconfigs` setting, setting up a message queue, configuring the `queue_source` and `queue_type` settings, and running the `puppet queue` command as a daemon.

Alternately, you can skip all this and use the vastly superior [PuppetDB][], which enables the same features (and more) at a perfectly acceptable speed and presents a flexible public API for use with arbitrary integrations.

### In Puppet 4.0

ActiveRecord storeconfigs is gone, and so are all of the tools designed to work around its limitations. You should use [PuppetDB][] instead.

### Detecting and Updating

Look for the [ActiveRecord storeconfigs settings](./deprecated_settings.html#activerecord-storeconfigs-settings) in [puppet.conf][] on your Puppet master(s), and delete them if present. Install [PuppetDB][] and rewrite any custom integrations to use its API instead of the raw storeconfigs database.

### Context

PuppetDB is much better, and everyone has already had a long time to switch.


YAML in HTTP API Calls
-----

### Now

Although Puppet agent only uses JSON (or PSON) when communicating with the Puppet master server, the master's HTTPS API will accept requests from other clients that expect YAML (including older Puppet agent versions).

* The master will gracefully handle requests that set a `Content-Type: yaml` header and include a YAML data payload.
* If a request sets the `Accept: yaml` header, the master will respond with YAML data.

### In Puppet 4.0

Any requests that contain or request YAML will be rejected.

### Detecting and Updating

You will need to examine any custom clients you've built that access the Puppet master's HTTPS API, and ensure that they are sending and requesting JSON or PSON instead of YAML.

### Context

It turns out that YAML, especially YAML in Ruby, is an enormous attack surface. In 2013 we had to handle a huge number of security issues related to deserializing YAML from the network, and we ultimately decided it would be in our users' best interests to stop accepting YAML over the wire at all.

[We discuss this at length in the Puppet 3.3.0 release notes.](/puppet/3/reference/release_notes.html#security-yaml-over-the-network-is-now-deprecated)

Miscellaneous APIs
-----

### `Puppet::Plugins`

#### Now

Puppet will search for files named `plugin_init.rb` in the `$LOAD_PATH`. If it finds any, it will load them and evaluate their code according to an essentially secret API.

#### In Puppet 4.0

Puppet will not automagically load files named `plugin_init.rb`.

#### Detecting and Updating

If you ever used this secret API, we assume you remember doing so.

#### Context

This was added to enable a hack that we didn't end up needing. It then sat unused for years.

* [PUP-2424: Deprecate Puppet::Plugins](https://tickets.puppetlabs.com/browse/PUP-2424)

### CouchDB Facts Terminus

#### Now

It's possible to set the `facts_terminus` setting to `couchdb` and specify a server in the `couchdb_url` setting. If you do so, the Puppet master will upload agent facts to a CouchDB database, for use with exotic integrations.

#### In Puppet 4.0

The `couchdb_url` setting is no longer valid, and `facts_terminus` cannot be set to `couchdb`.

#### Detecting and Updating

Look for the `facts_terminus` and `couchdb_url` settings in [puppet.conf][] on your Puppet master(s). If they enable this terminus, disable it and remove the `couchdb_url` setting. If you need to write integrations with fact data, we suggest using [PuppetDB][]'s API instead.

#### Context

The CouchDB facts terminus predates [PuppetDB][], and was rarely used. Nearly all users are better off using PuppetDB instead.

* [PUP-796: Deprecate couchdb facts terminus and associated settings](https://tickets.puppetlabs.com/browse/PUP-796)


### `Puppet::Node::Environment.current`

#### Now

Plugins can get the name of the current environment by calling the `Puppet::Node::Environment.current` method.

#### In Puppet 4.0

This method is removed, but has a drop-in replacement named `Puppet.lookup(:current_environment)`. The replacement method returns the exact same information.

#### Detecting and Updating

If you are using this method, Puppet will log the following deprecation warning:

    Warning: Puppet::Node::Environment.current has been replaced by Puppet.lookup(:current_environment), see http://links.puppetlabs.com/current-env-deprecation

You should find any calls to this method and replace them with `Puppet.lookup(:current_environment)`.

#### Context

This was part of a general cleanup of how environments are loaded and assigned.

* [PUP-1735: Puppet::Node::Environment.current should reroute with deprecation warning](https://tickets.puppetlabs.com/browse/PUP-1735)

