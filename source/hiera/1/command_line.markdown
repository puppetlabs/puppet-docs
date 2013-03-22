---
layout: default
title: "Hiera 1: Command Line Usage"
---

[priority_lookup]: ./lookup_types.html#priority-default
[hash_lookup]: ./lookup_types.html#hash-merge
[array_lookup]: ./lookup_types.html#array-merge

Hiera provides a command line tool that's useful for verifying that your hierarchy is constructed correctly and that your data 
sources are returning the values you expect. You'll typically run the Hiera command line tool on a puppet master, mocking up the facts agents would would normally provide the puppet master using a variety of [fact sources](#fact-sources).

## Invocation

The simplest Hiera command takes a single argument --- the key to look up --- and will look up the key's value using the static [data sources](data_sources.html) in the [hierarchy](./hierarchy.html).

`$ hiera ntp_server`

A more standard invocation will provide a set of variables for Hiera to use, so that it can also use its dynamic [data sources](./data_sources.html):

`$ hiera ntp_server --yaml web01.example.com.yaml`

### Order of Arguments

Hiera is sensitive to the position of its command-line arguments: 

- The first value is always the key to look up. 
- The first argument after the key that does not include an equals sign (`=`) becomes the default value, which Hiera will return if no key is found. Without a default value and in the absence of a matching key from the hierarchy, Hiera returns `nil`. 
- Remaining arguments should be `variable=value` pairs.
- **Options** may be placed anywhere. 

### Options

Hiera accepts the following command line options:

Argument                              | Use
--------------------------------------|------------------------------------------------------------------
`-V`, `--version`                     | Version information
`-c`, `--config FILE`                 | Specify an alternate configuration file location
`-d`, `--debug`                       | Show debugging information
`-a`, `--array`                       | Return all values as a flattened array of unique values
`-h`, `--hash`                        | Return all hash values as a merged hash 
`-j`, `--json FILE`                   | JSON file to load scope from
`-y`, `--yaml FILE`                   | YAML file to load scope from
`-m`, `--mcollective IDENTITY`        | Use facts from a node (via mcollective) as scope
`-i`, `--inventory_service IDENTITY`  | Use facts from a node (via Puppet's inventory service) as scope



## Configuration File Location

The Hiera command line tool looks for its configuration in `/etc/hiera.yaml`. You can use the `--config` argument to specify a different configuration file. See the documentation on Hiera's [configuration file](configuring.html#location) for notes on where to find this file depending on your Puppet version and operating system, and consider either reconfiguring Puppet to use `/etc/hiera.yaml` (Puppet 3) or set a symlink to `/etc/hiera.yaml` (Puppet 2.7).

## Fact Sources

When used from Puppet, Hiera automatically receives all of the facts it needs. On the command line, you'll need to manually pass it those facts. 

You'll typically run the Hiera command line tool on your puppet master node, where it will expect the facts to be either:

* Included on the command line as variables (e.g. `operatingsystem=Debian`)
* Given as a [YAML or JSON scope file](#json-and-yaml-scopes)
* Retrieved on the fly from [MCollective](#mcollective) data
* Looked up from [Puppet's inventory service](#inventory-service)

Descriptions of these choices are below.

### Command Line Variables

Hiera accepts facts from the command line in the form of `variable=value` pairs, e.g. `hiera ntp_server osfamily=Debian clientcert="web01.example.com"`. Variable values must be strings and must be quoted if they contain spaces. 

This is useful if the values you're testing only rely on a few facts. It can become unweildy if your hierarchy is large or you need to test values for many nodes at once. In these cases, you should use one of the other options below.

### JSON and YAML Scopes

Rather than passing a list of variables to Hiera as command line arguments, you can use JSON and YAML files. You can construct these files yourself, or use a YAML file retrieved from Puppet's cache or generated with `facter --yaml`.

Given this command using command line variable assignments:

`$ hiera ntp_server osfamily=Debian timezone=CST`

The following YAML and JSON examples provide equivalent results:

#### Example YAML Scope

`$ hiera ntp_server -y facts.yaml`

{% highlight yaml %}
# facts.yaml
---
osfamily: Debian
timezone: CST
{% endhighlight %}



#### Example JSON Scope

`$ hiera ntp_server -j facts.json`

{% highlight json %}
# facts.json
{
  "osfamily" : "Debian",
  "timezone" : "CST"
}
{% endhighlight %}



### MCollective 

If you're using hiera on a machine that is allowed to issue MCollective commands, you can ask any node running MCollective to send you its facts. Hiera will then use those facts to drive the lookup.

Example coming soon.


### Inventory Service

If you are using Puppet's [inventory service](/guides/inventory_service.html), you can query the puppet master for any node's facts. Hiera will then use those facts to drive the lookup.

Example coming soon.


## Lookup Types

By default, the Hiera command line tool will use a [priority lookup][priority_lookup], which returns a single value --- the first value found in the hierarchy. There are two other lookup types available: array merge and hash merge. 

### Array Merge

An array merge lookup assembles a value by merging every value it finds in the hierarchy into a flattened array of unique values. [See "Array Merge Lookup"][array_lookup] for more details. 

Use the `--array` option to do an array merge lookup.

If any of the values found in the data sources are hashes, the `--array` option will cause Hiera to return an error. 

### Hash

A hash merge lookup assembles a value by merging the top-level keys of each hash it finds in the hierarchy into a single hash. [See "Hash Merge Lookup"][hash_lookup] for more details. 

Use the `--hash` option to do a hash merge lookup.

If any of the values found in the data sources are strings or arrays, the `--hash` option will cause Hiera to return an error. 

