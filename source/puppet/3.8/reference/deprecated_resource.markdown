---
layout: default
title: "Deprecated Resource Type Features"
---

[main manifest]: ./dirs_manifest.html

The following features of Puppet's built-in resource types are deprecated, and will be removed in Puppet 4.0.

## `file`

### Non-String `mode` Values

#### Now

The [`file` type's `mode` attribute](./type.html#file-attribute-mode) will accept both numbers and strings to represent numeric permissions (like `0644`).

#### In Puppet 4.0

Numeric modes **must** be represented as quoted strings. Un-quoted numbers in the `mode` attribute will raise a compilation error.

~~~ ruby
    file { '/etc/sudoers':
      ensure => file,
      # BAD:
      mode   => 0400,
      # GOOD:
      mode   => '0400',
    }
~~~

#### Detecting and Updating

If you are using unquoted numbers in the `mode` attribute, Puppet will log the following deprecation warning on the Puppet master:

    Warning: Non-string values for the file mode property are deprecated. It must be a string, either a symbolic mode like 'o+w,a+r' or an octal representation like '0644' or '755'.

#### Context

In the Puppet 4 language, numbers starting with 0 are interpreted as octal, but they get converted to decimal once they reach resource types and providers. This could cause bizarre file modes, so we now prevent it.

* [PUP-2349: Deprecate non-string modes on file type](https://tickets.puppetlabs.com/browse/PUP-2349)

### Default Copying of Source Permissions

#### Now

If a `file` resource uses the `source` attribute and doesn't specify any of the `owner`, `group`, or `mode` attributes, Puppet will default to using the ownership and permissions from the source file, which is usually a file from a Puppet module. You can use [the `source_permissions` attribute](./type.html#file-attribute-source_permissions) to override this behavior.

#### In Puppet 4.0

Puppet **will not** default to using ownership and permissions from the source file. If you wish to copy the source permissions, you can opt in using the `source_permissions` attribute.

In other words, the default value of `source_permissions` will change from `use` to `ignore`.

#### Detecting and Updating

Puppet **will not** log deprecation warnings if you use this feature.

If you were implicitly relying on copied source permissions, you may need to re-examine all of your `file` resources. But for most users' files, the new default permissions (`puppet agent`'s user and that user's default umask or DACL) will be just as appropriate as the source permissions.

If you identify any files that DID rely on source permissions, you can:

* Set `source_permissions => use` on the affected files
* Explicitly set ownership and permissions on the affected files
* Set a resource default in the [main manifest][] to restore Puppet's 3.x behavior in 4.x (e.g. `File { source_permissions => use }`)

#### Context

Nonsensical \*nix permissions being copied to Windows nodes revealed the problems with this default behavior. After we considered it further, we decided that most module files probably don't have meaningful permissions in the first place, and use of the source permissions should be the exception rather than the rule.

* [PUP-2614: Deprecate default source_permissions :use on all platforms](https://tickets.puppetlabs.com/browse/PUP-2614)

### `recurse => inf`

#### Now

The [`file` type's `recurse` attribute](./type.html#file-attribute-recurse) allows a value of `inf`. (It's a synonym for `true`.)

#### In Puppet 4.0

Setting `recurse => inf` will cause a compilation error.

#### Detecting and Updating

Puppet **will not** log deprecation warnings if you use this feature.

Instead, do a global search of your Puppet code, making sure to handle varying whitespace and quoting. Use a regex-supporting search tool and search for something like:

    recurse\s*=>\s*['"]?inf

Replace any occurrences with `recurse => true`.

#### Context

The behavior of `recurse` and [`recurselimit`](./type.html#file-attribute-recurselimit) used to both be crammed into the `recurse` attribute, which could be set to numbers and `inf` in addition to its current values. Now that they're handled separately, `inf` is nonsensical as a value for `recurse`.

* [PUP-2379: Deprecate `recurse => inf` for file type](https://tickets.puppetlabs.com/browse/PUP-2379)


## `cron`

### Conservative Purging of Cron Resources

#### Now

If you purge unmanaged `cron` resources, like so:

~~~ ruby
    resources { 'cron':
      purge => true,
    }
~~~

...then Puppet will **only** delete cron jobs from its own user's crontab file. (Usually, `puppet agent`'s user is `root`.)

#### In Puppet 4.0

If you purge unmanaged `cron` resources, Puppet will purge cron jobs from **every user's crontab file.**

#### Detecting and Updating

If you are purging cron jobs, Puppet will log the following change warning:

    Warning: Change notice: purging cron entries will be more aggressive in future versions, take care when updating your agents. See http://links.puppetlabs.com/puppet-aggressive-cron-purge

#### Context

We've found that users expect "purge" to mean "PURGE," especially since Puppet can manage cron jobs for any user.

* [PUP-1381: cron type and provider only return resources for ENV["USER"] or "root", not all users](https://tickets.puppetlabs.com/browse/PUP-1381)

## `package`

### Old `msi` Package Provider

#### Now

Puppet includes a less useful `msi` package provider, in addition to the more flexible `windows` provider (which duplicates all of the `msi` provider's features).

#### In Puppet 4.0

Goodbye, `msi` provider! Use the `windows` provider instead.

#### Detecting and Updating

Puppet **will not** log deprecation warnings if you use this feature.

If you never specified a provider for your Windows packages, they're already using the `windows` provider, since `msi` is no longer the default. To find any packages that _do_ specify `msi`, do a global search of your Puppet code, making sure to handle varying whitespace and quoting. Use a regex-supporting search tool and search for something like:

    provider\s*=>\s*['"]?msi

Replace or delete any occurrences.

#### Context

Having a single Windows package provider that handles both MSIs and executable installers turned out to be much nicer.
