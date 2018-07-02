---
layout: default
title: "Hiera 1: Command Line Usage"
---

[priority_lookup]: ./lookup_types.html#priority-default
[hash_lookup]: ./lookup_types.html#hash-merge
[array_lookup]: ./lookup_types.html#array-merge

{% partial /hiera/_hiera_update.md %}

Hiera provides a command line tool that's useful for verifying that your hierarchy is constructed correctly and that your data sources are returning the values you expect. You'll typically run the Hiera command line tool on a puppet master, making up the facts agents would normally provide the puppet master using a variety of [fact sources](#fact-sources).

## Invocation

The simplest Hiera command takes a single argument --- the key to look up --- and will look up the key's value using the static [data sources](data_sources.html) in the [hierarchy](./hierarchy.html).

`$ hiera ntp_server`

A more standard invocation will provide a set of variables for Hiera to use, so that it can also use its dynamic [data sources](./data_sources.html):

`$ hiera ntp_server --yaml web01.example.com.yaml`

## Configuration File Location

The Hiera command line tool looks for its configuration in `/etc/hiera.yaml`, which is different from both Puppet Enterprise and open source Puppet. You can use the `--config` argument to specify a different configuration file. See the documentation on Hiera's [configuration file](configuring.html#location) for notes on where to find this file depending on your Puppet version and operating system, and consider either reconfiguring Puppet to use `/etc/hiera.yaml` (Puppet 3) or set a symlink to `/etc/hiera.yaml` (Puppet 2.7).

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



## Fact Sources

When used from Puppet, Hiera automatically receives all of the facts it needs. On the command line, you'll need to manually pass it those facts.

You'll typically run the Hiera command line tool on your puppet master node, where it will expect the facts to be either:

* Included on the command line as variables (e.g. `::operatingsystem=Debian`)
* Given as a [YAML or JSON scope file](#json-and-yaml-scopes)
* Retrieved on the fly from [MCollective](#mcollective) data
* Looked up from [Puppet's inventory service](#inventory-service)

Descriptions of these choices are below.

### Command Line Variables

Hiera accepts facts from the command line in the form of `variable=value` pairs, e.g. `hiera ntp_server ::osfamily=Debian clientcert="web01.example.com"`. Variables on the command line must be specified in a way that matches how they appear in `hiera.yaml`, including the leading `::` for facts and other top-scope variables. Variable values must be strings and must be quoted if they contain spaces.

This is useful if the values you're testing only rely on a few facts. It can become unwieldy if your hierarchy is large or you need to test values for many nodes at once. In these cases, you should use one of the other options below.

### JSON and YAML Scopes

Rather than passing a list of variables to Hiera as command line arguments, you can use JSON and YAML files. You can construct these files yourself, or use a YAML file retrieved from Puppet's cache or generated with `facter --yaml`.

Given this command using command line variable assignments:

`$ hiera ntp_server osfamily=Debian timezone=CST`

>**Note:** For Puppet, [facts are top-scope variables](/puppet/latest/reference/lang_variables.html#facts-and-built-in-variables), so their [fully-qualified](/puppet/latest/reference/lang_scope.html#accessing-out-of-scope-variables) form is `$::fact_name`. When called from within Puppet, Hiera will correctly interpolate `%{::fact_name}`. However, Facter's command-line output doesn't follow this convention --- top-level facts are simply called `fact_name`. That means you'll run into trouble in this section if you have `%{::fact_name}` in your hierarchy.

The following YAML and JSON examples provide equivalent results:

#### Example YAML Scope

`$ hiera ntp_server -y facts.yaml`

~~~ yaml
# facts.yaml
---
"::osfamily": Debian
"::timezone": CST
~~~



#### Example JSON Scope

`$ hiera ntp_server -j facts.json`

~~~ javascript
// facts.json
{
  "::osfamily" : "Debian",
  "::timezone" : "CST"
}
~~~



### MCollective

If you're using Hiera from a user account that is allowed to issue MCollective commands, you can ask any node running MCollective to send you its facts. Hiera will then use those facts to drive the lookup.

To do this, use the `-m` or `--mcollective` flag and give it the name of an MCollective node as an argument:

    $ hiera ntp_server -m balancer01.example.com

Note that you must be running the Hiera command from a user account that is authorized and configured to send MCollective commands, and is also able to read the Hiera configuration and data files.

#### Puppet Enterprise Example

In Puppet Enterprise 2.x or 3.x, you can do Hiera lookups with MCollective by switching to the `peadmin` account on the puppet master server, which is authorized to issue orchestration commands.

    # sudo -iu peadmin
    $ hiera ntp_server -m balancer01.example.com

Make sure that the `peadmin` user is allowed to read the Hiera config and data files.

### Inventory Service

If your puppet master is connected to a PuppetDB server (or has the older ActiveRecord inventory service enabled), you can get Hiera lookups using the actual facts reported by an actual puppet agent node. This goes through Puppet's [inventory service](/guides/inventory_service.html) API.

To do this, use the `-i` or `--inventory_service` flag and give it the name of a Puppet node as an argument:

    $ hiera ntp_server -i balancer01.example.com

> #### Note: Known Bug With Puppet 3.x
>
> In Hiera 1.3 and earlier, inventory lookups will fail when Puppet 3.x is present. This is a bug in Hiera, which will be fixed in a future release.



#### Allowing Lookups on the Puppet Master

[authconf]: /guides/rest_auth_conf.html

Before you can do Hiera lookups via the inventory, you'll need to enable access in [the puppet master's `auth.conf` file.][authconf] You must ensure that the node you will be doing lookups from can call the `find` method on the `/facts` path. This will probably look something like this:

    path  /facts
    method find, search
    auth yes
    allow pe-internal-dashboard, puppet.example.com

When choosing the name and certificate to use when contacting the puppet master, Hiera uses the existing puppet.conf and agent certificate on the node. If you are running as root, it will impersonate the agent node you are running on; if you are running as another user, it will use configuration and credentials in `~/.puppet/` instead.

To run as a different user, you may need to request a separate certificate, since the master won't sign two certificates with the same certname. To do this:

1. Create a `~/.puppet/puppet.conf` file and set the `certname` setting to something unique.
2. Run `puppet agent --test` to request a certificate.
3. On the puppet master, sign the certificate.
4. Run `puppet agent --test` again.

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

