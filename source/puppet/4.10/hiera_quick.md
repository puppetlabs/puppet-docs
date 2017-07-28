---
title: "Hiera: Quick start guide"
---


[v5]: ./hiera_config_yaml_5.html
[environments]: ./environments.html
[yaml]: http://www.yaml.org/YAML_for_ruby.html
[hierarchy]: ./hiera_hierarchy.html
[interpolation]: ./hiera_interpolation.html
[r_n_p]: {{pe}}/r_n_p_intro.html
[class parameters]: ./lang_classes.html#class-parameters-and-variables
[automatic]: ./hiera_automatic.html
[cli]: ./man/lookup.html
[confdir]: ./dirs_confdir.html
[codedir]: ./dirs_codedir.html
[os]: {{facter}}/core_facts.html#os
[certname]: ./lang_facts_and_builtin_vars.html#trusted-facts
[layers]: ./hiera_layers.html
[merging]: ./hiera_merging.html

This introduction to the basic concepts of Hiera gives you a functioning configuration to get started.

## The config file

Hiera's config file is called [hiera.yaml][v5]. Each [environment][environments] gets its own hiera.yaml file.

In the main directory of one of your [environments][], create a new file called `hiera.yaml`. Paste the following contents into it:

``` yaml
# <ENVIRONMENT>/hiera.yaml
---
version: 5

defaults:  # Used for any hierarchy level that omits these keys.
  datadir: data  # This path is relative to the environment -- <ENVIRONMENT>/data
  data_hash: yaml_data  # Use the built-in YAML backend.

hierarchy:
  - name: "Per-node data"                   # Human-readable name.
    path: "nodes/%{trusted.certname}.yaml"  # File path, relative to datadir.
                                   # ^^^ IMPORTANT: include the file extension!

  - name: "Per-OS defaults"
    path: "os/%{facts.os.family}.yaml"

  - name: "Common data"
    path: "common.yaml"
```

This file is in a format called [YAML][], which is used extensively throughout Hiera. If you'd like, you can read [a summary of YAML's syntax][YAML], or you can just follow along.

More details:

* [The hiera.yaml (v5) reference][v5].

### The hierarchy

hiera.yaml's main job is to configure a [hierarchy][], which is an ordered list of data sources. Hiera searches these sources in the order they're written, so higher-priority sources can override lower-priority ones.

Most hierarchy levels [use variables][interpolation] to locate a data source, so that different nodes get different data.

Stop and read those two paragraphs again, because this is the core concept of Hiera: a defaults-with-overrides pattern for data lookup, using a node-specific list of data sources.

More details:

* [How hierarchies work][hierarchy].
* [Interpolating variables and other values][interpolation].

## Write some data

### A test class

Hiera is meant to be used with Puppet code, so before we go any further, create a Puppet class for testing. This class doesn't do anything interesting; it just writes the data it receives to a temporary file.

Create this class in your `profile` module. If you don't already use [the roles and profiles method][r_n_p], create a module named `profile` at this time.

``` puppet
# /etc/puppetlabs/code/environments/production/modules/profile/manifests/hiera_test.pp
class profile::hiera_test (
  Boolean             $ssl,
  Boolean             $backups_enabled,
  Optional[String[1]] $site_alias = undef,
) {
  file { '/tmp/hiera_test.txt':
    ensure  => file,
    content => @("END"),
               Data from profile::hiera_test
               -----
               profile::hiera_test::ssl: ${ssl}
               profile::hiera_test::backups_enabled: ${backups_enabled}
               profile::hiera_test::site_alias: ${site_alias}
               |END
    owner   => root,
    mode    => '0644',
  }
}
```


Our test class uses [class parameters][] to request configuration data. And Puppet [automatically looks up class parameters in Hiera][automatic], using `<CLASS NAME>::<PARAMETER NAME>` as the lookup key.

So to provide values for the following class parameters, we can set the following keys in our Hiera data:

Parameter          | Hiera key
-------------------|---------------------------------------
`$ssl`             | `profile::hiera_test::ssl`
`$backups_enabled` | `profile::hiera_test::backups_enabled`
`$site_alias`      | `profile::hiera_test::site_alias`

More details:

* [The roles and profiles method][r_n_p].
* [Automatic class parameter lookup][automatic].

### Common data

Let's set some basic, fallback values in our common data --- the level at the bottom of our hierarchy.

This hierarchy level (like the rest of our hierarchy) uses the YAML backend for data, which means the data goes into a YAML file. To know where to put that file, we must combine a few pieces of information:

* The current environment's directory.
* The **data directory,** which is a subdirectory of the environment. It defaults to `<ENVIRONMENT>/data`.
* The file path specified by the hierarchy level.

So in this case, we want `/etc/puppetlabs/code/environments/production/` + `data/` + `common.yaml`. We'll edit that YAML file, and set values for two of the class's parameters.

``` yaml
# /etc/puppetlabs/code/environments/production/data/common.yaml
---
profile::hiera_test::ssl: false
profile::hiera_test::backups_enabled: true
```

The third parameter (`$site_alias`) has a default value defined in code, so we can omit it from the data.

### Per-OS data

The second level of our hierarchy uses [the `os` fact][os] to locate its data file. This means it can use different data files depending on the OS of the current node.

For this example, we'll assume that our developers use MacBook laptops, which have an OS family of `Darwin`. If an engineer is running an app instance on their laptop, it shouldn't send data to our production backup server, so we'll set `$backups_enabled` to `false`.

If you don't run Puppet on any Mac laptops, choose an OS family that's meaningful for your infrastructure. Remember, this is just an illustration.

To locate the data file, we need to replace `%{facts.os.family}` with the value we're targeting. So:

`/etc/puppetlabs/code/environments/production/data/` + `os/` + `Darwin` + `.yaml`.

``` yaml
# /etc/puppetlabs/code/environments/production/data/os/Darwin.yaml
---
profile::hiera_test::backups_enabled: false
```

### Per-node data

The highest level of our hierarchy uses the value of [`$trusted['certname']`][certname] to locate its data file, so you can set data by name for each individual node.

For this example, we'll assume there's a real server named `jenkins-prod-03.example.com`, and we'll configure it to use SSL and serve this application at the hostname `ci.example.com`. In your own data, choose the name of a real server you can run Puppet on.

To locate the data file, we need to replace `%{trusted.certname}` with the node name we're targeting. So:

`/etc/puppetlabs/code/environments/production/data/` + `nodes/` + `jenkins-prod-03.example.com` + `.yaml`

``` yaml
# /etc/puppetlabs/code/environments/production/data/nodes/jenkins-prod-03.example.com.yaml
---
profile::hiera_test::ssl: true
profile::hiera_test::site_alias: ci.example.com
```

## Different nodes get different data

Now you can go ahead and test your Hiera data on a variety of nodes in your Puppet infrastructure. Assign the `profile::hiera_test` class to several machines, and run Puppet on them (making sure to specify the environment you've been making these edits in). Then, check the contents of the `/tmp/hiera_test.txt` file.

On the `jenkins-prod-03.example.com` server, you would see something like:

```
Data from profile::hiera_test
-----
profile::hiera_test::ssl: true
profile::hiera_test::backups_enabled: true
profile::hiera_test::site_alias: ci.example.com
```

* Per-node values for `$ssl` and `$site_alias`.
* No per-OS data.
* The `$backups_enabled` value from common.yaml.

On the other hand, a developer laptop would have something like this:

```
Data from profile::hiera_test
-----
profile::hiera_test::ssl: false
profile::hiera_test::backups_enabled: false
```

* No per-node data.
* A per-OS value for `$backups_enabled`.
* The `$ssl` value from common.yaml.

Try writing more data and testing it with different kinds of nodes. Then, try adding more levels to the hierarchy in hiera.yaml --- copy the existing format and use the facts that are most important to your infrastructure.

## Test data on the command line

As you set Hiera data or rearrange your hierarchy, it's often important to double-check the data a given node will receive. [The `puppet lookup` command][cli] can help you test data interactively. For example:

```
$ puppet lookup profile::hiera_test::backups_enabled --environment production --node jenkins-prod-03.example.com

--- true
```

To use the command effectively, keep these tips in mind:

* Run the command on a Puppet Server node, or on another node that has access to a full checkout of your Puppet code and configuration.
* Make sure the command uses the global [confdir][] and [codedir][], so it has access to your live data. If you're not running `puppet lookup` as root, specify `--codedir` and `--confdir` on the command line.
* If you use PuppetDB, you can use any node's facts in a lookup by specifying `--node <NAME>`. Hiera can automatically get that node's real facts and use them to resolve data.
    * If you don't use PuppetDB, or if you want to test for a set of facts that doesn't exist yet, you can provide facts as a YAML or JSON file with `--facts <FILE>`. The best way to get a file full of facts is to run `facter -p --json > facts.json` on a node that's similar to the node you want to examine, copy the file to your Puppet Server node, and edit it as needed.
* If you aren't getting the values you expect, try re-running the command with `--explain`. This makes Hiera give a full explanation for which data sources it searched and what it found in them.

## Carry on!

There's a lot we haven't told you about in this quick-start, like the [global layer and module layer][layers], [hash and array merging][merging], alternate data backends, and more. But even with just the environment layer and some YAML files, you can accomplish a lot.

You now know enough to start using Hiera for real.
