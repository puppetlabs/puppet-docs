---
title: "Hiera: Migrating existing Hiera configurations to Hiera 5"
---

[layers]: ./hiera_layers.html
[migrate_environment]: ./hiera_migrate_environments.html
[migrate_v3]: ./hiera_migrate_v3_yaml.html
[migrate_v4]: ./hiera_migrate_v4_yaml.html
[migrate_functions]: ./hiera_migrate_functions.html
[migrate_modules]: ./hiera_migrate_modules.html
[legacy_backend]: ./hiera_config_yaml_5.html#configuring-a-hierarchy-level-legacy-hiera-3-backends
[backends]: ./hiera_custom_backends.html
[puppet.conf]: ./config_file_main.html
[automatic]: ./hiera_automatic.html

If you're already a Hiera user, **you don't have to migrate anything yet.** Hiera 5 is fully backwards-compatible with Hiera 3, and we won't remove any legacy features until Puppet 6. You can even start using some Hiera 5 features (like module data) without migrating anything.

But there are major advantages to fully adopting Hiera 5:

* A real [environment data layer][layers] means changes to your hierarchy are now routine and testable, instead of stop-the-world events.
* Using multiple backends in your hierarchy is a lot easier now.
* Ever wanted to make a custom backend? It's not black magic anymore.

## What do we mean by "migrate?"

Since Hiera 5 uses the same built-in data formats as Hiera 3, you don't need to do mass edits of any data files. When we say "migrate to Hiera 5," we're talking about **updating configuration.** Specifically, we're talking about these four tasks:

Task | Benefit
-----|--------
[Enable the environment layer, by giving each environment its own hiera.yaml file.][migrate_environment] | Future hierarchy changes are cheap and testable. The legacy `hiera()`, `hiera_array()`, etc. functions gain full Hiera 5 powers in any migrated environment.
[Convert your global hiera.yaml file to the version 5 format.][migrate_v3] | You can use new Hiera 5 backends at the global layer.
[Convert any experimental (version 4) hiera.yaml files to version 5.][migrate_v4] | Future-proof any environments or modules where you used the experimental version of Puppet lookup.
[In Puppet code, replace `hiera()`/`hiera_array()`/etc. with `lookup()`.][migrate_functions] | Future-proof your Puppet code.
[Use Hiera for default data in modules.][migrate_modules] | Simplify your modules with an elegant alternative to the "params.pp" pattern.

Enabling the environment layer takes the most work, and yields the biggest benefits. Focus on that first, then do the rest at your own pace.


## Should you migrate yet?

Probably! But there are a few situations where you might want to delay upgrading.

### `hiera-eyaml` users: maybe wait for Puppet 5

Hiera 5 works with the existing `hiera-eyaml` backend --- you can [use it as a legacy backend][legacy_backend] in the global hierarchy. However, Puppet 5.0 will ship with a **built-in** backend for encrypted YAML files, fully compatible with data from the Hiera 3 backend. (We completed work on it, but not in time for Puppet 4.9.)

You can migrate the non-encrypted parts of your hierarchy now, and migrate the encrypted parts once Puppet 5 comes out. Or you can wait, and migrate everything at once. Your call.

### Custom backend users: maybe wait for updated backends

You can keep using custom Hiera 3 backends with Hiera 5, but they'll make migration more complex, because you can't move legacy data to the environment layer until there's a Hiera 5 backend for it. If an updated version of the backend is coming out soon, it might be more efficient to wait (or even help contribute to its development).

If you're using an off-the-shelf custom backend, check its website or contact its developer. If you developed your backend in-house, [read the documentation about writing Hiera 5 backends][backends] --- updating it might be easier than you think.

### Custom `data_binding_terminus` users: go ahead, but replace it with a Hiera 5 backend ASAP

There's a deprecated `data_binding_terminus` setting in [puppet.conf][], which changes the behavior of [automatic class parameter lookup][automatic]. It can be set to `hiera` (normal), `none` (deprecated; disables auto-lookup), or the name of a custom plugin.

With a custom `data_binding_terminus`, automatic lookup results are radically different from function-based lookups for the same keys. If you're one of the rare few who use this feature, you've already had to design your Puppet code to avoid that problem, so it's probably safe to migrate your configuration to Hiera 5. But since we've deprecated that extension point, you'll have to replace your custom terminus with a Hiera 5 backend before Puppet 6 rolls around.

* If you're using an off-the-shelf plugin, check its website or contact its developer. (The most widely used terminus we're aware of is Jerakia, and we've been told a Hiera 5 compatible version is on the way.)
* If you developed your plugin in-house, [read the documentation about writing Hiera 5 backends][backends]. You're already an advanced Puppet hacker if you managed to build one of these in the first place, so you can probably write an equivalent Hiera 5 backend in an afternoon or two. We hope you enjoy this improved interface!

Once you have a Hiera 5 backend, integrate it into your global and/or environment hierarchies and delete the `data_binding_terminus` setting.

