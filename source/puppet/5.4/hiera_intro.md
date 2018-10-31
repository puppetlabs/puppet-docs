---
title: "Hiera"
---

[auto_lookup]: ./hiera_automatic.html#class-parameters
[codedir]: ./dirs_codedir.html
[confdir]: ./dirs_confdir.html
[v3]: ./hiera_config_yaml_3.html
[v4]: ./hiera_config_yaml_4.html
[v5]: ./hiera_config_yaml_5.html

Hiera is a key/value lookup used for separating data from Puppet code.

{:.concept}
## About Hiera

Hiera is Puppet’s built-in key-value configuration data lookup system.

Puppet’s strength is in reusable code. Code that serves many needs must be configurable: put site-specific information in external configuration data files, rather than in the code itself.

Puppet uses Hiera to do two things:

* Store the configuration data in key-value pairs
* Look up what data a particular module needs for a given node during catalog compilation.

This is done via:

* Automatic Parameter Lookup for classes included in the catalog
* Explicit lookup calls

Hiera’s hierarchical lookups follow a “defaults, with overrides” pattern, meaning you specify common data once, and override it in situations where the default won’t work. Hiera uses Puppet’s facts to specify data sources, so you can structure your overrides to suit your infrastructure. While using facts for this purpose is common, data-sources may well be defined without the use of facts.

Hiera 5 comes with support for JSON, YAML, and EYAML files.

Related topics: [Automatic Parameter Lookup][auto_lookup]

{:.concept}
## Hiera hierarchies

Hiera looks up data by following a hierarchy - an ordered list of data sources.

Hierarchies are configured in a `hiera.yaml` configuration file. Each level of the hierarchy tells Hiera how to access some kind of data source.

### Hierarchies interpolate variables

Most levels of a hierarchy interpolate variables into their configuration:

`path: "os/%{facts.os.family}.yaml"`

* The percent-and-braces `%{variable}` syntax is a Hiera interpolation token. It is similar to the Puppet language’s `${expression}` interpolation tokens. Wherever you use an interpolation token, Hiera determines the variable’s value and inserts it into the hierarchy.
* `facts.os.family` uses the Hiera special `key.subkey` notation for accessing elements of hashes and arrays. It is equivalent to `$facts['os']['family']` in the Puppet language but the 'dot' notation will produce an empty string instead of raising an error if parts of the data is missing. Make sure that an empty interpolation does not end up matching an unintended path.
* You can only interpolate values into certain parts of the config file. For more info, see the hiera.yaml format reference.
* With node-specific variables, each node gets a customized set of paths to data. The hierarchy is always the same.

### Hiera searches the hierarchy in order

Once Hiera replaces the variables to make a list of concrete data sources, it checks those data sources in the order they were written. Generally, if a data source doesn’t exist, or doesn’t specify a value for the current key, Hiera skips it and moves on to the next source, until it finds one that exists - then it uses it. Note that this is the default merge strategy, but does not always apply, for example, Hiera can use data from all data sources and merge the result.

Earlier data sources have priority over later ones. In the example above, the node-specific data has the highest priority, and can override data from any other level. Business group data is separated into local and global sources, with the local one overriding the global one. Common data used by all nodes always goes last.

That’s how Hiera’s “defaults, with overrides” approach to data works - you specify common data at lower levels of the hierarchy, and override it at higher levels for groups of nodes with special needs.

### Layered hierarchies

Hiera uses layers of data with a `hiera.yaml` for each layer.

Each layer can configure its own independent hierarchy. Before a lookup, Hiera combines them into a single super-hierarchy: global → environment → module.

> Note: There is a fourth layer - `default_hierarchy` - that can be used in a module's `hiera.yaml`. It only comes into effect when there is no data for a key in any of the other regular hierarchies

Assume the example above is an environment hierarchy (in the production environment). If we also had the following global hierarchy:

---
```
version: 5
hierarchy:
  - name: "Data exported from our old self-service config tool"
    path: "selfserve/%{trusted.certname}.json"
    data_hash: json_data
    datadir: data
```
And the NTP module had the following hierarchy for default data:

---
```
version: 5
hierarchy:
  - name: "OS values"
    path: "os/%{facts.os.name}.yaml"
  - name: "Common values"
    path: "common.yaml"
defaults:
  data_hash: yaml_data
  datadir: data
```

Then in a lookup for the `ntp::servers` key, `thrush.example.com` would use the following combined hierarchy:

* `<CODEDIR>/data/selfserve/thrush.example.com.json`
* `<CODEDIR>/environments/production/data/nodes/thrush.example.com.yaml`
* `<CODEDIR>/environments/production/data/location/belfast/ops.yaml`
* `<CODEDIR>/environments/production/data/groups/ops.yaml`
* `<CODEDIR>/environments/production/data/os/Debian.yaml`
* `<CODEDIR>/environments/production/data/common.yaml`
* `<CODEDIR>/environments/production/modules/ntp/data/os/Ubuntu.yaml`
* `<CODEDIR>/environments/production/modules/ntp/data/common.yaml`

The combined hierarchy works the same way as a layer hierarchy.  Hiera skips empty data sources, and either returns the first found value or merges all found values.

> Note: By default, datadir refers to the directory named 'data' next to the `hiera.yaml`.

### Tips for making a good hierarchy

* Make a short hierarchy. Data files will be easier to work with.
* Use the roles and profiles method to manage less data in Hiera. Sorting hundreds of class parameters is easier than sorting thousands.
* If the built-in facts don’t provide an easy way to represent differences in your infrastructure, make custom facts. For example, create a custom datacenter fact that is based on information particular to your network layout so that each datacenter is uniquely identifiable.
* Give each environment -- production, test, development -- its own hierarchy.

Related topics: [codedir][codedir], [confdir][confdir], [hiera.yaml][v5.]

{:.concept}
## Hiera’s three config layers

Hiera uses three independent layers of configuration. Each layer has its own hierarchy, and they’re linked into one super-hierarchy before doing a lookup.

The three layers are searched in the following order: global → environment → module. Hiera searches every data source in the global layer’s hierarchy before checking any source in the environment layer.

### The global layer

* The configuration file for the global layer is located, by default, in `$confdir/hiera.yaml`. You can change the location by changing the `hiera_config` setting in `puppet.conf`.
* Hiera has one global hierarchy. Since it goes before the environment layer, it’s useful for temporary overrides, for example, when your ops team needs to bypass its normal change processes.
* The global layer is the only place where legacy Hiera 3 backends can be used - it’s an important piece of the transition period when you migrate you backends to support Hiera 5.
* The global layer supports the following config formats: hiera.yaml v5, hiera.yaml v3 (deprecated).
* Other than the above use cases, try to avoid the global layer. All normal data should be specified in the environment layer.

### The environment layer

* The configuration file for the global layer is located, by default, `<ENVIRONMENT DIR>/hiera.yaml`.
* The environment layer is where most of your Hiera data hierarchy definition happens.
* Every Puppet environment has its own hierarchy configuration, which applies to nodes in that environment.
Supported config formats: hiera.yaml v5,  hiera.yaml v5, hiera.yaml v3  (deprecated).

### The module layer

* The configuration file for a module layer is located, by default, in a module's `<MODULE>/hiera.yaml`.
* The module layer sets default values and merge behavior for a module’s class parameters. It is a convenient alternative to the `params.pp` pattern.
	* Note that to get the exact same behaviour as params.pp, the default_hierarchy should be used, as those bindings are excluded from merges. When placed in the regular hierarchy in the module's hierarchy the bindings will be merged when a merge lookup is performed.
* The module layer comes last in Hiera’s lookup order, so environment data set by a user overrides the default data set by the module’s author.
* Every module can have its own hierarchy configuration. You can only bind data for keys in the module's namespace.For example:

| Lookup key        | Relevant module hierarchy | 
| ----------------- |:-------------------------:|
| `ntp::servers`    | `ntp`                     | 
| `jenkins::port`   | `jenkins`                 |   
| `secure_server`   | `(none)`                  |   

* Hiera uses the `ntp` module’s hierarchy when looking up `ntp::servers`, but uses the `jenkins` module’s hierarchy when looking up `jenkins::port`. Hiera never checks the `ntp` module for a key beginning with `jenkins::`.
* When you use the lookup function for keys that don’t have a namespace (for example, `secure_server`), the module layer is not consulted.

The three-layer system means that each environment has its own hierarchy, and so do modules. You can make hierarchy changes on an environment-by-environment basis. Module data is also customizable.

Related topics: [version 3][v3], [version 4][v4], [version 5][v5].
