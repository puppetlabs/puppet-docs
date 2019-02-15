---
title: "Hiera: Legacy config file syntax (hiera.yaml v4)"
---

[hierarchy]: ./hiera_hierarchy.html
[layers]: ./hiera_layers.html
[v3]: ./hiera_config_yaml_3.html
[v5]: ./hiera_config_yaml_5.html


Hiera's config file is called hiera.yaml. It configures the [hierarchy][] for a given [layer][layers] of data.

This version of Puppet supports three formats for hiera.yaml --- you can use any of them, although v4 and [v3][] are deprecated. This page is about version 4, a transitional format used in Hiera 5's experimental predecessor (Puppet lookup).


Format | Allowed in                    | Description
-------|-------------------------------|------------
[v5][] | All three data layers         | The main version of hiera.yaml, which supports all Hiera 5 features.
v4     | Environment and module layers | Deprecated. A transitional format, used in the rough draft of Hiera 5 (when we were calling it "Puppet lookup"). Doesn't support custom backends.
[v3][] | Global layer                  | Deprecated. The classic version of hiera.yaml, which has some problems.

## Important: version 4 is deprecated.

Version 4 of hiera.yaml is deprecated, and we plan to remove support for it in Puppet 6.

More importantly, version 4 can't use some of Hiera 5's best new features, like custom backends.

## `hiera.yaml` (Version 4) in a nutshell

``` yaml
# /etc/puppetlabs/code/environments/production/hiera.yaml
---
version: 4
datadir: data
hierarchy:
  - name: "Nodes"
    backend: yaml
    path: "nodes/%{trusted.certname}"

  # Putting a JSON level between YAML levels like this
  # was impossible in the old format.
  - name: "Exported JSON nodes"
    backend: json
    paths:
      # Puppet checks these in order. Even though this is a single
      # item in the hierarchy, it acts like multiple hierarchy levels.
      - "nodes/%{trusted.certname}"
      - "insecure_nodes/%{facts.fqdn}"

  - name: "virtual/%{facts.virtual}"
    backend: yaml

  - name: "common"
    backend: yaml
```

The `hiera.yaml` (version 4) file goes in the main directory of a module or environment. It is a YAML hash that contains three keys:

* `version` --- Required. Must always be `4`.
* `datadir` --- Optional. The default datadir, for any hierarchy levels that omit it. It is a relative path, from the root of the environment or module. The default is `data`.
* `hierarchy` --- Optional. A hierarchy of data sources to search, in the new format. If omitted, it defaults to a single source called `common` that uses the YAML backend.

The `hierarchy` is an array of hashes. Unlike in classic Hiera, each hierarchy level must specify its own backend, and can optionally use a separate datadir.

Each hierarchy level can contain the following keys:

* `name` --- Required. An arbitrary human-readable name, used for debugging and for `puppet lookup --explain`.

    This is also used as the default `path` if you don't specify any paths. (If the name interpolates variables, Hiera will interpolate when finding data files but leave it uninterpolated when reporting the level's name.)
* `backend` --- Required. Which backend to use. Currently only `yaml` and `json` are supported.
* `path` --- Optional; mutually exclusive with `paths`. The path to a data file. Can interpolate variables, to use different files depending on a node's facts.
* `paths` --- Optional; mutually exclusive with `path`. An array of paths to data files, which can interpolate variables. This acts like multiple hierarchy levels, and is shorthand for writing consecutive levels that use the same backend and datadir.
* `datadir` --- Optional. A one-off datadir to use instead of the default one specified at top level.

## Changes to version 4 for Hiera 5

In the experimental Puppet lookup, you had to use a setting to enable Hiera: for environments you had to set `environment_data_provider = hiera` in environment.conf or puppet.conf, and for modules you had to set `"data_provider":"hiera"` in metadata.json.

That's no longer necessary. As of Puppet 4.9, Puppet automatically enables Hiera for a module or environment if a hiera.yaml file is present. This works for both v4 and v5 hiera.yaml files.
