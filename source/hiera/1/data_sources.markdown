---
layout: default
title: "Hiera 1: Writing Data Sources"
---


[json]: http://www.json.org/
[yaml_ruby]: http://www.yaml.org/YAML_for_ruby.html
[yaml]: http://www.yaml.org
[datadir]: ./configuring.html#datadir
[variables]: ./variables.html

Hiera can use several different data backends, including two built-in backends and various optional backends. Each backend uses a different document format for its data sources.

This page describes the built-in `yaml` and `json` backends, as well as the `puppet` backend included with Hiera's Puppet integration. For optional backends, see the backend's documentation. 

YAML
-----

### Summary

The `yaml` backend looks for data sources on disk, in the directory specified in its [`:datadir` setting][datadir]. It expects each data source to be a text file containing valid YAML data, with a file extension of `.yaml`. No other file extension (e.g. `.yml`) is allowed.

### Data Format

See [yaml.org][yaml] and [the "YAML for Ruby" cookbook][yaml_ruby] for a complete description of valid YAML.

The root object of each YAML data source must be a YAML **mapping** (hash). Hiera will treat its top level keys as the pieces of data available in the data source. The value for each key can be any of the data types below. 

Hiera's data types map to the native YAML data types as follows: 

Hiera   | YAML
--------|-----
Hash    | Mapping
Array   | Sequence
String  | Quoted scalar or non-boolean unquoted scalar 
Number  | Integer or float
Boolean | Boolean (note: includes `on` and `off` in addition to `true` and `false`)

Any string may include any number of [variable interpolation tokens][variables].

### Example

<!-- TODO -->

Coming soon. 


JSON
-----

### Summary

The `json` backend looks for data sources on disk, in the directory specified in its [`:datadir` setting][datadir]. It expects each data source to be a text file containing valid JSON data, with a file extension of `.json`. No other file extension is allowed.

### Data Format

[See the JSON spec for a complete description of valid JSON.][json]

The root object of each JSON data source must be a JSON **object** (hash). Hiera will treat its top level keys as the pieces of data available in the data source. The value for each key can be any of the data types below. 

Hiera's data types map to the native JSON data types as follows: 

Hiera   | JSON
--------|------
Hash    | Object
Array   | Array
String  | String
Number  | Number
Boolean | `true` / `false`

Any string may include any number of [variable interpolation tokens][variables].

### Example

<!-- TODO -->

Coming soon. 


Puppet
-----

Coming soon. <!-- TODO -->