---
layout: default
title: "Hiera 2: Writing Data Sources"
---


[json]: http://www.json.org/
[yaml_ruby]: http://www.yaml.org/YAML_for_ruby.html
[yaml]: http://www.yaml.org
[datadir]: ./configuring.html#datadir
[variables]: ./variables.html

{% partial /hiera/_hiera_update.md %}

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
Boolean | Boolean (note: includes `on` and `off`, `yes` and `no` in addition to `true` and `false`)

Any string may include any number of [interpolation tokens][variables].

> **Important note:** The "psych" YAML parser, which is used by many Ruby versions, **requires** that any strings containing a `%` be quoted.

### Example

~~~ yaml
---
# array
apache-packages:
    - apache2
    - apache2-common
    - apache2-utils

# string
apache-service: apache2

# interpolated facter variable
hosts_entry: "sandbox.%{::fqdn}"

# hash
sshd_settings:
    root_allowed: "no"
    password_allowed: "yes"

# alternate hash notation
sshd_settings: {root_allowed: "no", password_allowed: "yes"}

# to return "true" or "false"
sshd_settings: {root_allowed: no, password_allowed: yes}

~~~

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

Any string may include any number of [interpolation tokens][variables].

### Example

~~~ javascript
{
    "apache-packages" : [
    "apache2",
    "apache2-common",
    "apache2-utils"
    ],

    "hosts_entry" :  "sandbox.%{fqdn}",

    "sshd_settings" : {
                        "root_allowed" : "no",
                        "password_allowed" : "no"
                      }
}
~~~

