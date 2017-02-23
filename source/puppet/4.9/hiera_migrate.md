---
title: "Hiera: Migrating existing Hiera data to Hiera 5"
---

[layers]: todo
[automatic]: todo
[backends]: todo
[legacy_backend]: todo
[environment layer]: todo
[global layer]: todo
[merge]: todo
[v5]: todo
[v3]: todo
[custom_backends]: todo
[v4]: todo
[lookup_options]: todo


If you're already a Hiera user, **you don't have to migrate anything yet.** Hiera 5 is fully backwards-compatible with Hiera 3, and we won't remove any legacy features until Puppet 6. You can even start using some Hiera 5 features (like module data) without migrating anything.

However, Hiera 5 has enough advantages and new features that you probably want to migrate your existing data sooner rather than later. In particular:

* A real [environment data layer][layers] means it's easy to make hierarchy changes within your normal change process.
* Hierarchies that use multiple backends make much more sense in Hiera 5.


## What do we mean by "migrate?"

When we discuss "migrating data to Hiera 5," we mean the following set of tasks:

* **Mandatory:** Make sure you're not using anything that can prevent migration. The list is pretty short.
* If you already have data in environments, start controlling it with per-environment hiera.yaml files (instead of the global one).
* Convert your global hiera.yaml file to the version 5 format.
* Convert any experimental (version 4) hiera.yaml files to version 5.
* Find calls to the deprecated `hiera`/`hiera_*` functions and change them to use `lookup` or automatic class parameter lookup.

Except for the hard roadblocks, you can do these at your own pace, a little bit at a time. In particular, you have plenty of time to migrate away from the `hiera_*` functions --- in a partially-migrated environment, they work with all three Hiera 5 data layers.


## Fix any roadblocks to migration

There are two things that will prevent further migration:

* Use of hierarchy overrides in the classic `hiera` functions.
* Custom `data_binding_terminus` plugins.

There's also one thing that might make it more efficient to delay migration:

* Extensive use of Hiera Eyaml or other Hiera 3 backends.

### Hierarchy overrides in the classic `hiera` functions

The classic Hiera functions (`hiera`, `hiera_array`, `hiera_hash`, and `hiera_include`) take three arguments:

1. A lookup key.
2. An optional default value.
3. An optional "hierarchy override" argument.

Hiera 5 does not support that third argument. You **must** remove that argument from any Hiera function calls before doing any other Hiera 5 migration tasks.

Almost nobody used this feature, so you're probably unaffected. But you should check to make sure.

We don't currently have a failsafe way to find hierarchy overrides, but you can detect Hiera calls that include two or more commas by searching your codebase for the following regular expression, with the multi-file searching tool of your choice:

    hiera(_array|_hash|_include)?\(([^,\)]*,){2,}[^\)]*\)

_This will include false positives,_ but there should be few enough results that you can manually verify them.

### Custom `data_binding_terminus` plugins

Puppet has a deprecated `data_binding_terminus` setting, which changes the behavior of [automatic class parameter lookup][automatic]. It can have the following values:

* `hiera` (the default value) is best. It now uses Hiera 5.
* `none` disables automatic class parameter lookup. Hiera 5 still supports this, but its days are numbered. You should switch it to `hiera` very soon; automatic class parameter lookup is part of how Puppet works, and more and more modules are going to start relying on it for default data.
* Any other value sets a custom plugin for automatic class parameter lookup. **This will partially block migration to Hiera 5.**

If you use a custom `data_binding_terminus` plugin, you must:

* Obtain an equivalent Hiera 5 backend.
    * If it's an off-the-shelf extension, check its website or contact its developer. (The most widely used terminus we're aware of is Jerakia, and its author has said he'll build a Hiera 5 compatible version.)
    * If you developed it in-house, [read the documentation about writing Hiera 5 backends][backends]. They're much easier to write than backends for previous versions of Hiera, and the terminus's author can probably convert it in an afternoon or two.
* Integrate the backend into your global hierarchy, after you've converted the global hiera.yaml to version 5.
* Set `data_binding_terminus` back to `hiera`.

If you don't do this, automatic class parameter lookup will give results that are radically different from function-based lookups for the same keys.

### Extensive use of Hiera Eyaml or other Hiera 3 backends

This won't block migration, but it might encourage you to delay it.

Hiera 5 works fine with the existing `hiera_eyaml` backend --- you can [use it as a legacy backend][legacy_backend] in the global hierarchy. However, Puppet 5.0 will ship with a built-in **native** backend for encrypted YAML files, fully compatible with data from the Hiera 3 backend. (We've completed work on it, but it didn't make it in time for Puppet 4.9.)

You can migrate your non-encrypted data now, and migrate the encrypted data once Puppet 5 comes out. Or you can wait, and migrate all your data at once. There's good reasons for either choice; it's just a question of what's most important to you.

The same goes for other legacy backends: You can use them with Hiera 5, but they'll make migration more complex. If an updated version of the backend is coming out soon, it might be more efficient to wait (or help contribute to its development!).

## Migrate to per-environment hiera.yaml files

One of the biggest benefits of Hiera 5 is that you can manage the hierarchy for an environment _alongside that environment's data._ (See [How the three config layers work][layers] for more complete information.)

To transfer control to your environments, you must edit each environment to:

* Add a hiera.yaml file.
* Move the data directory.

This process will ensure that un-migrated environments can co-exist with migrated ones, to give you plenty of time to finish migrating.

### Summary and explanation

Most Hiera 3 users interpolate Puppet's `$environment` or `$server_facts['environment']` variable into their `:datadir` setting, which lets each environment contain its own data directory. (For example, the default datadir in Hiera 3 is `"/etc/puppetlabs/code/environments/%{environment}/hieradata"`.)

This means the data is already in a convenient spot for the [environment layer][] --- theoretically, if you were migrating all of your environments at once, you could add a hiera.yaml file to each of them, delete the global hiera.yaml, and be done. But most serious Puppet users have too many environments to migrate simultaneously, which raises the problem of competition between the global and environment layers.

The [global layer][] is always consulted first, and if the global and environment layers are looking in the same place for their data, Hiera will stop at global and never reach the environment layer. (Or, in a [merging lookup][merge], it will get double copies of every value.) This gives identical results at first, but behaves erratically when you change the hierarchy in an environment.

You can avoid that problem by moving an environment's datadir at the same time you add a hiera.yaml file to it. That way, the global layer won't find any data for a migrated environment, and control will pass cleanly to the environment layer.

![Illustration: In a migrated environment, global data sources are missing, so Hiera continues on to the environment data.](./images/hiera_migrate.jpg)

### Step 1: Identify the current datadir(s) for your environments

In your global hiera.yaml file, find the `:datadir` setting for each backend. This will look something like:

``` yaml
:yaml:
  :datadir: "/etc/puppetlabs/code/environments/%{::environment}/hieradata"
```

If it's absent from the config file, you're using the default, which is `<ENVIRONMENT>/hieradata`.

If you use multiple backends, note the datadir for all of them. Hopefully they're the same; if they're different, decide whether you want them to stay different post-migration.

### Step 2: Choose a new datadir name

The best choice is `data`, which is Hiera 5's default datadir.

If you've already used that name for your Hiera 3 data, you'll have to pick something different.

### Step 3: Move the environment's datadir

If your environments are managed as Git branches in a control repo, you'll need to check out the environment you want to work with and use `git mv` to rename the datadir. If your environments aren't in version control, you can do a normal directory rename.

#### Extra considerations

* If some of your data relies on a non-Hiera-5 backend, you can't just rename the whole datadir. Since only the global configuration can use Hiera 3 backends, the legacy data still has to live in the global datadir.

    So you'll have to make a new datadir and only move Hiera 5 data sources into it. Later, when you have a Hiera 5 version of that backend, you can finish migrating the data.

    This is more complex than migrating all of the data at once, which is why you might want to delay migrating until Hiera 5 versions of your backends are available.
* Non-file-based backends (like MongoDB) don't have a "datadir," per se, and you'll have to make your own call about how to handle them. Since they're relatively uncommon compared to YAML files, we don't have a one-size-fits-most migration plan for them. Roughly speaking, your options are:
    * Do something equivalent to moving the datadir; for example, make a new database table for migrated data and move values into place as you migrate environments.
    * Decide that the global hierarchy is the right place for configuring this data, and leave it there.
    * Decide that you don't change the configuration of this data very often, and you can afford to leave it duplicated in global and environment hierarchies until you're finished migrating.

### Step 4: Make a hiera.yaml for the environment

Look at your global hierarchy, and make a new [version 5 hiera.yaml file][v5] with an equivalent hierarchy. Save (or commit) that file in the root of your environment.

For example, a version 3 hiera.yaml like this:

``` yaml
:backends: yaml
:yaml:
  :datadir: "/etc/puppetlabs/code/environments/%{environment}/hieradata"
:hierarchy:
  - "nodes/%{trusted.certname}"
  - "location/%{facts.whereami}/%{facts.group}"
  - "groups/%{facts.group}"
  - "os/%{facts.os.family}"
  - "common"
```

...would translate to a version 5 hiera.yaml like this:

{% partial ./_hiera.yaml_v5.md %}

See [the version 5 hiera.yaml reference][v5] for more details. In particular, note that you must include the file extension in a version 5 hierarchy.

### Step 5: Repeat steps 3 and 4 for all environments

Since migrated and un-migrated environments can co-exist, you should have plenty time to finish this.

If you manage your environments with a control repo, you'll be able to use your normal branch merging process to do a lot of this work, at least in your long-lived environments. For temporary environments, you might decide it's not worth migrating them since they'll be deleted soon.


## Convert your global hiera.yaml to version 5

For existing users, the global hiera.yaml file uses [the version 3 format][v3]. Converting it to [version 5][v5] has some advantages:

* You'll get to use the same format for [all three data layers][layers]; no more translating.
* Version 5 specifies backends per-hierarchy-level, so you can mix and match backends without having to deal with Hiera 3's weird looped hierarchy thing.
* You can use Hiera 5 backends. The only new one at launch is the HOCON backend, but there will be more. (And it's [easy to write your own][custom_backends].)
* You can still use Hiera 3 backends at the global layer.

But first, it's worth asking: do you need a global hierarchy? If you aren't using data sources that inherently make sense at the global level, you might be able to delete your global config after you've migrated all of your environments.

If you do still need a global layer for overrides, see [the hiera.yaml version 5 reference][v5] to learn how to write a v5 config. The most important things to watch out for:

* Make sure you add file extensions to each path. This is the easiest thing to miss when migrating.
* You can save some space and typing with a default backend and datadir.
* You don't have to use symbols as keys anymore. (So you can use `hierarchy` instead of `:hierarchy`.)

## Convert experimental (version 4) hiera.yaml files to version 5

If you used the experimental version of Puppet lookup (the direct predecessor of Hiera 5), you might have some [version 4 hiera.yaml files][v4] in your environments and modules. Hiera 5 can use these as-is, and they'll keep working until Puppet 6. But you'll need to convert them eventually, especially if you want to use any backends other than YAML or JSON.

A version 4 hiera.yaml usually looks something like this:

``` yaml
# /etc/puppetlabs/code/environments/production/hiera.yaml
---
version: 4
datadir: data
hierarchy:
  - name: "Nodes"
    backend: yaml
    path: "nodes/%{trusted.certname}"

  - name: "Exported JSON nodes"
    backend: json
    paths:
      - "nodes/%{trusted.certname}"
      - "insecure_nodes/%{facts.fqdn}"

  - name: "virtual/%{facts.virtual}"
    backend: yaml

  - name: "common"
    backend: yaml
```

This is pretty close to the version 5 format, but you'll need to make a few changes:

* Add a file extension to every file path --- it should be `"common.yaml"`, not `"common"`. This is the easiest thing to miss.
* If there's a top-level `datadir` key, you'll have to change it to a `defaults` key. For example:

  ``` yaml
  defaults:
    datadir: data
    data_hash: yaml_data
  ```
* In each hierarchy level, delete the `backend` key and replace it with a `data_hash` key. (If you set a default backend in the `defaults` key, you can omit it here.)

  v4 backend      | v5 equivalent
  ----------------|--------------
  `backend: yaml` | `data_hash: yaml_data`
  `backend: json` | `data_hash: json_data`

For full syntax details, see [the hiera.yaml version 5 reference][v5].

## Change `hiera` function calls to `lookup`

The `hiera`, `hiera_array`, `hiera_hash`, and `hiera_include` functions are all deprecated, and will be removed at some point in the future.

The `lookup` function is a complete replacement for all of these:

Hiera function                | Equivalent `lookup` call
------------------------------|-------------------------
`hiera('secure_server')`      | `lookup('secure_server')`
`hiera_array('ntp::servers')` | `lookup('ntp::servers', {merge => unique})`
`hiera_hash('users')`         | `lookup('users', {merge => hash})` or `lookup('users', {merge => deep})`
`hiera_include('classes')`    | `lookup('classes', {merge => unique}).include`

To make sure you're ready for Puppet 6 and beyond, you should revise your Puppet modules to replace the `hiera_*` functions with `lookup`.

While you're revising, consider refactoring some code to use [automatic class parameter lookup][automatic] instead of functions --- since automatic lookups [can now do unique and hash merges][lookup_options], the `hiera_array` and `hiera_hash` functions aren't as important as they used to be.
