---
title: "Looking up data with Hiera"
---

[r_n_p]: {{pe}}/r_n_p_intro.html
[data_type]: ./lang_data_type.html
[editing_data]: ./hiera_merging.html

{:.concept}
## Class parameters

Puppet looks up the values for class parameters in Hiera, using the fully-qualified name of the parameter (`myclass::parameter_one`) as a lookup key.

Most classes need configuration, and you can specify them as parameters to a class as this will lookup the needed data if not directly given when the class is included in a catalog. There are several ways Puppet sets values for class parameters, in this order:

1.  If you're doing a resource-like declaration, Puppet uses parameters that are explicitly set (if explicitly setting undef, a looked up value or default will be used).

2.  Puppet uses Hiera, using `<CLASS NAME>::<PARAMETER NAME>` as the lookup key. For example, it looks up `ntp::servers` for the `ntp` class's `$servers parameter`.

3.  If a  parameter still has no value, Puppet uses the default value from the parameter's default value expression in the class's definition.

4.  If any parameters have no value and no default, Puppet fails compilation with an error.

For example, you can set servers for the `NTP` class like this:

```
# /etc/puppetlabs/code/production/data/nodes/web01.example.com.yaml
---
ntp::servers:
  - time.example.com
  - 0.pool.ntp.org
```

> Note: The best way to manage this is to use the roles and profiles method, which allows you to store a smaller amount of more meaningful data in Hiera.

Related topics: [roles and profiles][r_n_p].

{:.concept}
## Puppet lookup

The `lookup` function uses Hiera to retrieve a value for a given key.

By default, the lookup function returns the first value found and fails compilation if no values are available. You can also configure the lookup function to merge multiple values into one.

When looking up a key, Hiera searches up to four hierarchy layers of data, in the following order:

1.  Global hierarchy.
2.  The current environment's hierarchy.
3.  The indicated module's hierarchy, if the key is of the form `<MODULE NAME>::<SOMETHING>`.
4.  If not found and the module's hierarchy has a default_hierarchy entry in its hiera.yaml - the lookup is repeated if steps 1-3 did not produce a value.

> Note: Hiera checks the global layer before the environment layer. If no global `hiera.yaml` file has been configured, Hiera defaults are used. If you do not want it to use the defaults, you can create an empty `hiera.yaml` file in `/etc/puppetlabs/puppet/hiera.yaml`.

Default global hiera.yaml is installed at /etc/puppetlabs/puppet/hiera.yaml.

### Arguments

You must provide the name of a key to look up, and can optionally provide other arguments. You can combine these arguments in the following ways:
-   `lookup( <NAME>, [<VALUE TYPE>], [<MERGE BEHAVIOR>], [<DEFAULT VALUE>] )`
-   `lookup( [<NAME>], <OPTIONS HASH> )`
-   `lookup( as above ) |$key| { <VALUE> } # lambda returns a default value`

Arguments in `[square brackets]` are optional.

> Note: Giving a hash of options containing `default_value` at the same time as giving a lambda means that the lambda will win. The rationale for allowing this is that you may be using the same hash of options multiple times, and you may want to override the production of the default value. A `default_values_hash` wins over the lambda if it has a value for the looked up key.

### Merge behaviours

Hiera uses a hierarchy of data sources, and a given key can have values in multiple sources. Hiera can either return the first value it finds, or continue to search and merge all the values together. When Hiera searches, it first searches the global layer, then the environment layer, and finally the module layer — where it only searches in modules that have a matching namespace. By default (unless you use one of the merge strategies) it is priority/"first found wins", in which case the search ends as soon as a value is found.

> Note: Data sources can use the `lookup_options` metadata key to request a specific merge behavior for a key. The lookup function will use that requested behavior unless you specify one.

### Examples

Look up a key and returning the first value found:

```
lookup('ntp::service_name')
```

A unique merge lookup of class names, then adding all of those classes to the catalog:

```
lookup('classes', Array[String], 'unique').include
```


A deep hash merge lookup of user data, but letting higher priority sources remove values by prefixing them with:

```
lookup( { 'name'  => 'users',
          'merge' => {
            'strategy'        => 'deep',
            'knockout_prefix' => '--',
          },
})
```

{:.reference}
## Arguments accepted by lookup

You must provide the key's name. The other arguments are optional.

-   `<NAME>` (String or Array) - The name of the key to look up.
This can also be an array of keys. If Hiera doesn't find anything for the first key, it tries with the subsequent ones, only resorting to a default value if none of them succeed.
-   `<VALUE TYPE>` (data Type) - A data type that must match the retrieved value; if not, the lookup (and catalog compilation) will fail. Defaults to `Data`  which accepts any normal value.
-   `<MERGE BEHAVIOR>` (String or Hash; see [Merge behaviors](https://puppet.com/docs/puppet/5.5/hiera_merging.html#ariaid-title3)) -  Whether and how to combine multiple values. If present, this overrides any merge behavior specified in the data sources. Defaults to no value; Hiera will use merge behavior from the data sources if present, and will otherwise do a first-found lookup.
-   `<DEFAULT VALUE>` (any normal value) - If present, lookup returns this when it can't find a normal value. Default values are never merged with found values. Like a normal value, the default must match the value type. Defaults to no value; if Hiera can't find a normal value, the lookup (and compilation) will fail.
-   `<OPTIONS HASH>` (Hash) - Alternate way to set the arguments above, plus some less common additional options. If you pass an options hash, you can't combine it with any regular arguments (except `<NAME>`). An options hash can have the following keys:
    -   `'name'` - Same as `<NAME>` (argument 1). You can pass this as an argument or in the hash, but not both.
    -   `'value_type'` - Same as `<VALUE TYPE>`.
    -   `'merge'` - Same as `<MERGE BEHAVIOR>`.
    -   `'default_value'` - Same as `<DEFAULT VALUE>` .
    -   `'default_values_hash'` (Hash) - A hash of lookup keys and default values. If Hiera can't find a normal value, it will check this hash for the requested key before giving up. You can combine this with `default_value` or a lambda, which will be used if the key isn't present in this hash. Defaults to an empty hash.
    -   `'override'` (Hash) - A hash of lookup keys and override values. Puppet will check for the requested key in the overrides hash first. If found, it returns that value as the final value, ignoring merge behavior. Defaults to an empty hash.
    -   `lookup` - can take a lambda, which must accept a single parameter. This is yet another way to set a default value for the lookup; if no results are found, Puppet will pass the requested key to the lambda and use its result as the default value.

Related topics: [Data type][data_type].

{:.concept}
## Using puppet lookup

The `puppet lookup` command is the command line interface (CLI) for Puppet's lookup function.

The `puppet lookup` command lets you do Hiera lookups from the command line. It needs to be run on a node that has a copy of your Hiera data. You can log into a Puppet Server node and run 'puppet lookup' with sudo.

The most common version of this command is:

```
puppet lookup <KEY> --node <NAME> --environment <ENV> --explain
```

The `puppet lookup` command searches your Hiera data and returns a value for the requested lookup key, so you can test and explore your data. It replaces the 'hiera' command. Hiera relies on a node's facts to locate the relevant data sources. By default, 'puppet lookup' uses facts from the node you run the command on, but you can get data for any other node with the '--node NAME' option. If possible, the lookup command will use the requested node's real stored facts from PuppetDB. If PuppetDB is not configured or you want to provide other fact values, pass facts from a JSON or YAML file with the '--facts FILE' option.

> Note: The `puppet lookup` replaces the 'hiera' command.

### usage

puppet lookup [--help] [--type <TYPESTRING>] [--merge first|unique|hash|deep] [--knock-out-prefix <PREFIX-STRING>] [--sort-merged-arrays] [--merge-hash-arrays] [--explain] [--environment <ENV>] [--default <VALUE>] [--node <NODE-NAME>] [--facts <FILE>] [--compile] [--render-as s|json|yaml|binary|msgpack] keys

### Examples

To look up 'key_name' using the Puppet Server node's facts:

```
$ puppet lookup key_name
```

To look up 'key_name' with agent.local's facts:

```
$ puppet lookup --node agent.local key_name
```

To get the first value found for `key_name_one` and `key_name_two` with agent.local's facts while merging values and knocking out the prefix 'foo' while merging:

```
puppet lookup --node agent.local --merge deep --knock-out-prefix foo key_name_one key_name_two
```

To lookup `key_name` with agent.local's facts, and return a default value of `bar` if nothing was found:

```
puppet lookup --node agent.local --default bar key_name
```

To see an explanation of how the value for 'key_name' would be found, using agent.local's facts:

```
puppet lookup --node agent.local --explain key_name
```

{:.reference}
## Puppet lookup command options

The `puppet lookup` command has the following command options.

-   `--help`: Print a usage message.
-   `--explain`: Explain the details of how the lookup was performed and where the final value came from, or the reason no value was found. Useful when debugging Hiera data. If `--explain` isn't specified, lookup exits with 0 if a value was found and 1 if not. With `--explain`, lookup always exits with 0 unless there is a major error. You can provide multiple lookup keys to this command, but it only returns a value for the first found key, omitting the rest.
-   `--node <NODE-NAME>`: Specify which node to look up data for; defaults to the node where the command is run. The purpose of Hiera is to provide different values for different nodes; use specific node facts to explore your data. If the node where you're running this command is configured to talk to PuppetDB, the command will use the requested node's most recent facts. Otherwise, override facts with the '--facts' option.
-   `--facts <FILE>`: Specify a JSON or YAML file that contains key-value mappings to override the facts for this lookup. Any facts not specified in this file maintain their original value.
-   `--environment <ENV>`: Specify an environment. Different environments can have different Hiera data.
-   `--merge first/unique/hash/deep`: Specify the merge behavior, overriding any merge behavior from the data's `lookup_options`.
-   `--knock-out-prefix <PREFIX-STRING>`: Used with 'deep' merge. Specifies a prefix to indicate a value should be removed from the final result.
-   `--sort-merged-arrays`: Used with 'deep' merge. When this flag is used, all merged arrays are sorted.
-   `--merge-hash-arrays`: Used with the 'deep' merge strategy. When this flag is used, hashes within arrays are deep-merged with their counterparts by position.
-   `--explain-options`: Explain whether a `lookup_options` hash affects this lookup, and how that hash was assembled. (`lookup_options` is how Hiera configures merge behavior in data.)
-   `--default <VALUE>`: A value to return if Hiera can't find a value in data. Useful for emulating a call to the `lookup function that includes a default.
-   `--type <TYPESTRING>`: Assert that the value has the specified type. Useful for emulating a call to the `lookup` function that includes a data type.
-   `--compile`: Perform a full catalog compilation prior to the lookup. If your hierarchy and data only use the `$facts`, `$trusted`, and `$server_facts` variables, you don't need this option. If your Hiera configuration uses arbitrary variables set by a Puppet manifest, you need this to get accurate data. The lookup command doesn't cause catalog compilation unless this flag is given.
-   `--render-as s/json/yaml/binary/msgpack`: Specify the output format of the results; `s` means plain text. The default when producing a value is `yaml` and the default when producing an explanation is `s`.

Related topics: [Creating and editing data with Hiera][editing_data].

{:.task}
## Access hash and array elements using a key.subkey notation

Access hash and array members in Hiera using a `key.subkey` notation.

You can access hash and array elements when doing the following things:

-   Interpolating variables into `hiera.yaml` or a data file. Many of the most commonly used variables, for example `facts` and `trusted`, are deeply nested data structures.
-   Using the `lookup` function or the `puppet lookup` command. If the value of `lookup('some_key')` is a hash or array, look up a single member of it by using `lookup('some_key.subkey')`.
-   Using interpolation functions that do Hiera lookups, for example `lookup` and `alias`.

To access a single member of an array or hash:

1.  Use the name of the value followed by a period (.) and a subkey.
    -   If the value is an array, the subkey must be an integer, for example: `users.0` returns the first entry in the `users` array.
    -   If the value is a hash, the subkey must be the name of a key in that hash, for example, `facts.os`.
    -   To access values in nested data structures, you can chain subkeys together. For example, since the value of `facts.system_uptime` is a hash, you can access its hours key with `facts.system_uptime.hours`.

{:.reference}
## Hiera dotted notation

The Hiera dotted notation does not support arbitrary expressions for subkeys; only literal keys are valid.

A hash can include literal dots in the text of a key. For example, the value of `$trusted['extensions']` is a hash containing any certificate extensions for a node, but some of its keys can be raw OID strings like '1.3.6.1.4.1.34380.1.2.1'. You can access those values in Hiera with the `key.subkey` notation, but you must put quotation marks - single or double - around the affected subkey. If the entire compound key is quoted (for example, as required by the lookup interpolation function), use the other kind of quote for the subkey, and escape quotes (as needed by your data file format) to ensure that you don't prematurely terminate the whole string.

For example:

```
aliased_key: "%{lookup('other_key.\"dotted.subkey\"')}"
# Or:
aliased_key: "%{lookup(\"other_key.'dotted.subkey'\")}"
```

> Note: Using extra quotes prevents digging into dotted keys. For example, if the lookup key contains a dot (`.`) then the entire key must be enclosed within single quotes within double quotes, for example, `lookup("'has.dot'")`.
