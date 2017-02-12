---
title: "Hiera: How hierarchies work"
---

[hiera.yaml]: todo
[interpolate]: todo
[subkey]: todo
[facts]: todo
[trusted data]: todo
[merge]: todo
[layers]: todo
[codedir]: todo
[confdir]: todo
[builtins]: todo
[backends]: todo



Hiera looks up data with a **hierarchy,** which is an ordered list of data sources.

Hierarchies are configured in a [hiera.yaml][] config file. A hierarchy usually looks something like this:

``` yaml
version: 5
defaults:               # Used in any hierarchy level that omits these keys.
  datadir: data         # This path is relative to the config file's directory.
  data_hash: yaml_data  # Use the YAML data backend.

hierarchy:
  - name: "Per-node data"                   # Human-readable name.
    path: "nodes/%{trusted.certname}.yaml"  # Path to data file,
                                            # relative to datadir.

  - name: "Per-datacenter business group data" # Uses custom facts.
    path: "location/%{facts.whereami}/%{facts.group}.yaml"

  - name: "Global business group data"
    path: "groups/%{facts.group}.yaml"

  - name: "Per-OS defaults"
    path: "os/%{facts.os.family}.yaml"

  - name: "Common data"
    path: "common.yaml"
```

Each **level** of the hierarchy tells Hiera how to access some kind of data source. In this example, every level configures the path to a YAML file on disk. (For more about different kinds of data sources, see [Configuring the built-in data backends][builtins] and [Overview of the backend functions system][backends].)

## Most hierarchies interpolate variables

Notice that most levels of this hierarchy [interpolate variables][interpolate] into their configuration:

``` yaml
    path: "os/%{facts.os.family}.yaml"
```

* The percent-and-braces `%{variable}` syntax is a Hiera [interpolation token][interpolate]. It's similar to the Puppet language's `${expression}` interpolation tokens.
* `facts.os.family` uses Hiera's special [key.subkey notation][subkey] for accessing elements of hashes and arrays. It's equivalent to `$facts['os']['family']` in the Puppet language.
* This example, like most real-life hierarchies, uses [facts][] and [trusted data][].
* You can only interpolate values into certain parts of the config file. For more info, see [the hiera.yaml format reference][hiera.yaml].

This is the core of Hiera's power: with node-specific variables, each node gets its own customized version of the hierarchy.

Consider two example machines that both belong to the operations team: an Ubuntu server named Thrush (in the Belfast datacenter), and a Red Hat server named Crane (in Portland). These machines use the same hierarchy, but it resolves to a different list of data sources for each.

<table>
<tr> <th>Thrush’s hierarchy</th> <th>Crane’s hierarchy</th> </tr>
<tr>
<td>
{% md %}
* `data/nodes/thrush.example.com.yaml`
* `data/location/belfast/ops.yaml`
* `data/groups/ops.yaml`
* `data/os/Debian.yaml`
* `data/common.yaml`
{% endmd %}
</td>
<td>
{% md %}
* `data/nodes/crane.example.com.yaml`
* `data/location/portland/ops.yaml`
* `data/groups/ops.yaml`
* `data/os/RedHat.yaml`
* `data/common.yaml`
{% endmd %}
</td>
</tr>
</table>

Note that they both use `data/groups/ops.yaml` (since they belong to the same group) and they both use `data/common.yaml` (since that level of the hierarchy doesn't use any variables). But other than that, they use completely different data sources.

It's normal for some of these files to not exist, and Hiera handles that just fine. Most Hiera users have several optional levels in their hierarchy, which are important for some machines and irrelevant for others. (For example, maybe the ops team uses a lot of location-specific data, but the release engineering team is datacenter-agnostic.)

## Hiera searches the hierarchy in order

Once Hiera replaces the variables to make a list of concrete data sources, it checks those data sources in the order they're written. If a data source doesn't exist, or doesn't specify a value for the current key, Hiera skips it and moves on to the next source.

This means earlier data sources have priority over later ones. In the example above, the node-specific data has the highest priority, and can override data from any other level. Business group data is separated into local and global sources, with the local one overriding the global one. And the common data used by all nodes always goes last.

That's how Hiera's "defaults, with overrides" approach to data works: you specify shared data at lower levels of the hierarchy, and override it at higher levels for groups of nodes with special needs.

## Optionally, Hiera can merge data

Hiera has two main modes of operation:

* Return the first value found.
* Find multiple values and merge them together. (There are a few merge behaviors to choose from; for more details, see [Merging data from multiple sources][merge].)

In a first-found lookup, higher-priority data sources completely override values from the data sources below them. In a merging lookup, every level of the hierarchy can contribute to the final value, although higher-priority sources win in the case of a conflict.

## Three layer hierarchies → one combined hierarchy

Hiera uses three layers of data. (For more info, see [The three config layers][layers].)

Each layer can configure its own independent hierarchy. When it's time to do a lookup, Hiera combines them into a single super-hierarchy. (The order for this is global, then environment, then module.)

Assume the example above is an environment hierarchy (in the `production` environment). If we also had the following global hierarchy:

``` yaml
version: 5
hierarchy:
  - name: "Data exported from our old self-service config tool"
    path: "selfserve/%{trusted.certname}.json"
    data_hash: json_data
    datadir: data
```

...and the NTP module had the following hierarchy for default data:

``` yaml
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

...then in a lookup for the the `ntp::servers` key, thrush.example.com would use the following combined hierarchy:

* `<CONFDIR>/data/selfserve/thrush.example.com.json`
* `<CODEDIR>/environments/production/data/nodes/thrush.example.com.yaml`
* `<CODEDIR>/environments/production/data/location/belfast/ops.yaml`
* `<CODEDIR>/environments/production/data/groups/ops.yaml`
* `<CODEDIR>/environments/production/data/os/Debian.yaml`
* `<CODEDIR>/environments/production/data/common.yaml`
* `<CODEDIR>/environments/production/modules/ntp/data/os/Ubuntu.yaml`
* `<CODEDIR>/environments/production/modules/ntp/data/common.yaml`

(See the [codedir][] and [confdir][] documentation for the locations of these directories on different platforms.)

The combined hierarchy works the same way as a layer hierarchy: Hiera skips empty data sources, and either returns the first found value or merges all found values.

