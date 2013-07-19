---
layout: default
title: "Hiera 1: Creating Hierarchies"
---

[config]: ./configuring.html
[variables]: ./variables.html
[data]: ./data_sources.html

<!-- TODO: better links for the lookup types -->
[priority]: ./lookup_types.html#priority-default
[array]: ./lookup_types.html#array-merge
[hash]: ./lookup_types.html#hash-merge


Hiera uses an ordered hierarchy to look up data. This allows you to have a large amount of common data and override smaller amounts of it wherever necessary.

Location and Syntax
-----

Hiera loads the hierarchy from the [hiera.yaml config file][config]. The hierarchy must be the value of the top-level `:hierarchy` key.

The hierarchy should be an **array.** (Alternately, it may be a string; this will be treated like a one-element array.)

Each element in the hierarchy must be a **string,** which may or may not include [variable interpolation tokens][variables]. Hiera will treat each element in the hierarchy as **the name of a [data source][data].** 

    # /etc/hiera.yaml
    ---
    :hierarchy:
      - "%{::clientcert}"
      - "%{::environment}"
      - "virtual_%{::is_virtual}"
      - common

> **Terminology:** 
> 
> We use these two terms within the Hiera docs and in various other places:
> 
> * **Static data source** --- A hierarchy element **without** any interpolation tokens. A static data source will be the same for every node. In the example above, `common` is a static data source --- a virtual machine named `web01` and a physical machine named `db01` would both use `common`. 
> * **Dynamic data source** --- A hierarchy element with at least one interpolation token. If two nodes have different values for the variables it references, a dynamic data source will use two different data sources for those nodes. In the example above: the special `$::clientcert` Puppet variable has a unique value for every node. A machine named `web01` would have a data source named `web01` at the top of its hierarchy, while a machine named `db01` would have `db01` at the top.

Behavior
-----

### Ordering

Each element in the hierarchy resolves to the name of a [data source][data]. Hiera will check these data sources **in order,** starting with the first.

* If a data source in the hierarchy doesn't exist, Hiera will move on to the next data source. 
* If a data source exists but does not have the piece of data Hiera is searching for, it will move on to the next data source. (Since the goal is to help you not repeat yourself, Hiera expects that most data sources will either not exist or not have the data.)
* If a value is found:
    * In a normal ([priority][]) lookup, Hiera will stop at the first data source with the requested data and return that value.
    * In an [array][] lookup, Hiera will continue, then return all of the discovered values as a flattened array. Values from higher in the hierarchy will be the first elements in the array, and values from lower will be later. 
    * In a [hash][] lookup, Hiera will continue, **expecting every value to be a hash** and throwing an error if any non-hash values are discovered. It will then merge all of the discovered hashes and return the result, allowing values from higher in the hierarchy to replace values from lower.
* If Hiera goes through the entire hierarchy without finding a value, it will use the default value if one was provided, or fail with an error if one wasn't. 

### Multiple Backends

You can [specify multiple backends as an array in `hiera.yaml`][config]. If you do, they function as a **second hierarchy.**

Hiera will give priority to the first backend, and will **check every level of the hierarchy** in it before moving on to the second backend. This means that, with the following `hiera.yaml`:

    ---
    :backends:
      - yaml
      - json
    :hierarchy:
      - one
      - two
      - three

...hiera would check the following data sources, in order:

* `one.yaml`
* `two.yaml`
* `three.yaml`
* `one.json`
* `two.json`
* `three.json`

Example
-----

Assume the following hierarchy:

    # /etc/hiera.yaml
    ---
    :hierarchy:
      - "%{::clientcert}"
      - "%{::environment}"
      - "virtual_%{::is_virtual}"
      - common

...and the following set of data sources:

* `web01.example.com`
* `web02.example.com`
* `db01.example.com`
* `production.yaml`
* `development.yaml`
* `virtual_true.yaml`
* `common.yaml`

...and only the `yaml` backend.

Given two different nodes with different Puppet variables, here are two ways the hierarchy could be interpreted:

### web01.example.com

#### Variables

- `::clientcert` = `web01.example.com`
- `::environment` = `production`
- `::is_virtual` = `true`

#### Data Source Resolution

![A hierarchy interpreted for a node](./images/hierarchy1.png)

#### Final Hierarchy

- web01.example.com.yaml
- production.yaml
- virtual_true.yaml
- common.yaml

### db01.example.com

#### Variables

- `::clientcert` = `db01.example.com`
- `::environment` = `development`
- `::is_virtual` = `false`

#### Data Source Resolution

![The same hierarchy, interpreted for another node](./images/hierarchy2.png)

#### Final Hierarchy

- db01.example.com.yaml
- development.yaml
- common.yaml

Note that, since `virtual_false.yaml` doesn't exist, it gets skipped entirely. 
