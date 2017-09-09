---
title: "Hiera: Enable the environment layer for existing Hiera data"
---


[layers]: ./hiera_layers.html
[legacy_functions]: ./hiera_use_hiera_functions.html
[migrate]: ./hiera_migrate.html
[environment]: ./environments.html
[v5]: ./hiera_config_yaml_5.html
[global layer]: ./hiera_layers.html#the-global-layer
[environment layer]: ./hiera_layers.html#the-environment-layer
[control repo]: {{pe}}/cmgmt_control_repo.html
[migrate_v3]: ./hiera_migrate_v3_yaml.html
[custom backends]: ./hiera_custom_backends.html
[eyaml_v5]: ./hiera_config_yaml_5.html#configuring-a-hierarchy-level-hiera-eyaml

Hiera 5's headline feature is [per-environment hierarchy configuration][layers]. Since most people already store data in environments, local hiera.yaml files are much more logical and convenient than a single global hierarchy.

You can enable the environment layer gradually. In migrated environments, the [legacy `hiera` functions][legacy_functions] seamlessly switch to Hiera 5 mode, so they can access environment and module data without requiring any code changes.

> **Note:** Before migrating environment data to Hiera 5, read the [introduction to migrating Hiera configurations][migrate]. In particular, be aware that if you rely on custom Hiera 3 backends, you should upgrade them for Hiera 5 or prepare for some extra work during migration.
>
> If your only custom backend is hiera-eyaml, you're good to go --- Puppet 4.9.3 and higher include a Hiera 5 eyaml backend. See the [usage instructions in the hiera.yaml (v5) syntax reference][eyaml_v5].

## Summary

In each [environment][], do the following:

* Add a local [hiera.yaml (v5)][v5] file, to enable the environment layer.
* Rename the data directory, to exclude that environment from the global configuration.

This process has no particular time limit and shouldn't involve any downtime. Once all of your environments are migrated, you can phase out the global hierarchy (or greatly reduce it).

> ### Why rename the data directory?
>
> Since un-migrated environments rely on the global hierarchy, it can't change until they're all migrated.
>
> That's a problem for _migrated_ environments, because Hiera always checks the [global layer][]  before the [environment layer][]. So if both layers use the same datadir, the global layer gets there first; the environment layer might be enabled, but it won't get a chance to do anything. That's fine if the global and environment hierarchies are identical, but it causes problems the first time you edit an environment's hierarchy. Effectively, you wouldn't get the benefits of per-environment configuration until you'd migrated _every_ environment.
>
> Moving the datadir avoids that problem --- since the global datadir no longer exists in a migrated environment, Hiera skips those data sources and proceeds to the environment hierarchy.


## Step 1: Check for illegal hierarchy overrides

Before adding a hiera.yaml to an environment, check your Puppet code and make sure none of your calls to the classic `hiera` functions have a third argument.

The classic Hiera functions (`hiera`, `hiera_array`, `hiera_hash`, and `hiera_include`) used to accept three arguments:

1. A lookup key.
2. An optional default value.
3. An optional hierarchy override, which almost nobody used.

In Hiera 5, that third argument is an error; you must remove it when migrating an environment. You're probably unaffected, but check to make sure.

> **Note:** If most of your environments are similar to each other, you might only need to check the `hiera` calls once. This isn't something that's likely to vary widely across code versions.

There are two ways to handle this step: search the code, or just move on to the next step and catch errors as they come up.

### Search the code

We don't have a perfect way to find three-argument `hiera` calls, but we can find most of the `hiera` calls with _two or more commas._ This includes some false positives (for example, when the default value is an array, hash, or function call), but it should be a small enough list to check manually.

Search your codebase with the following regular expression:

    hiera(_array|_hash|_include)?\(([^,\)]*,){2,}[^\)]*\)

If any of the results include a third argument, remove it.

### Catch errors as they arise

If you use environments for code testing and promotion, you're probably migrating a temporary branch of your [control repo][] first, then pointing some canary nodes at it to make sure everything works as expected.

If you think you've never used the hierarchy override feature, you'll be verifying that assumption anyway when you run your canary nodes. If you do find any errors, you can fix them before merging your branch to production, the same way you would with any work-in-progress code.


## Step 2: Choose a new datadir name

You need a new name for your datadir in the next two steps, so you should decide on it now.

The default datadir in Hiera 3 was `<ENVIRONMENT>/hieradata`, and the default in Hiera 5 is `<ENVIRONMENT>/data`. So if you used the old default, use the new default; if you were already using `data`, you'll need to pick something different.


## Step 3: Add a hiera.yaml (v5) file to the environment

Each environment needs a Hiera config file that works with its existing data.

* If this is the first environment you're migrating, follow our instructions for [converting a version 3 hiera.yaml to version 5][migrate_v3]. Make sure to reference the new datadir. Save the resulting file as `<ENVIRONMENT>/hiera.yaml`. (For example, `/etc/puppetlabs/code/environments/production/hiera.yaml`.)
* If you've already migrated at least one environment, copy the hiera.yaml file from a previous environment and make changes if necessary.

> **Important:** The environment layer does not support Hiera 3 backends. If any of your data uses a custom backend that has not been ported to Hiera 5, you must omit those hierarchy levels from the environment config and continue to use the global layer for that data.
>
> Since the global layer goes before the environment layer, it's possible to run into situations where you cannot migrate data to the environment layer yet. For example: if your old `:backends` setting was `['custom_backend', 'yaml']`, you can do a partial migration, because the custom data was all going before the YAML data anyway. But if `:backends` was `['yaml', 'custom_backend']`, AND you frequently use YAML data to override the custom data, you can't migrate until you have a Hiera 5 version of that custom backend.
>
> If you run into a situation like that, you'll need to get an upgraded backend before enabling the environment layer.

## Step 4: Install any custom Hiera 5 backends

If any of your data relies on [custom backends][] that have been ported to Hiera 5, install them in the environment now.

Hiera 5 backends are distributed as Puppet modules, so each environment can use its own version of them.


## Step 5: Move the environment's datadir

Rename the datadir from its old name (probably `hieradata`) to its new name (probably `data`).

* If you only use file-based Hiera 5 backends, that's all you have to do.
* If you use any custom file-based Hiera 3 backends, the global layer still needs access to their data.

    You'll need to sort the files: Hiera 5 data moves to the new datadir, and Hiera 3 data stays in the old datadir. Then, when you have Hiera 5 versions of your custom backends, you can move the remaining files to the new datadir.
* If you use any non-file backends (for example, MongoDB): these don't necessarily have a "datadir" per se, and you'll have to decide how to handle that. Since these are relatively uncommon compared to plain YAML files, we don't have a one-size-fits-all migration plan for them. Roughly speaking, your options are:
    * Decide that the global hierarchy is the right place for configuring this data, and leave it there permanently.
    * Do something equivalent to moving the datadir; for example, make a new database table for migrated data and move values into place as you migrate environments.
    * Allow the global and environment layers to use duplicated configuration for this data until the migration is done. This isn't ideal, but it's easy, and it's probably harmless if you'll finish migrating environments fairly quickly.


## Repeat, then prune the global hierarchy

Continue to migrate environments until they're all using their own Hiera configurations.

Many people's environments are mapped to branches in a [control repo][]. If you manage your code like this, you can probably migrate most of your environments using your version control system's merging tools. You can merge your `production` branch into any branches that will eventually re-join it; with branches that will never re-join `production`, you can cherry-pick commits. If you have a bunch of dead or mysterious environments, this might be a good time to remove some of them.

Once you've migrated the environments that have active node populations, you can delete all the parts of your global hierarchy that you transferred into environment hierarchies.


