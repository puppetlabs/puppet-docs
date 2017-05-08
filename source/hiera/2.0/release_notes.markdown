---
layout: default
title: "Hiera 2: Release Notes"
---

{% partial /hiera/_hiera_update.md %}

## Hiera 2.0.1

Released April 13, 2015

This release is identical to 2.0.0. We only changed some tests and packaging data.

## Hiera 2.0.0

Released March 25, 2015.

Hiera 2.0.0 is a new major version of Hiera, which includes several new features and one breaking change. Please read the section below labeled "BREAK," because you may need to edit your configuration and/or move some files around.

Hiera 2.0.0 is available as a gem (run `gem install hiera`) or a tarball (download from [http://downloads.puppetlabs.com/hiera/](http://downloads.puppetlabs.com/hiera/)). Official delivery of Hiera 2.0.0 is via the puppet-agent package with Puppet 4, which was released on 13 April 2015.

### BREAK: New Default Locations for Config File and Data Directory

This release changes the default locations for the config file and the data directory used by the YAML and JSON backends. If you were relying on the old default behavior, you'll need to either move your files or configure Hiera to use non-default locations.

On *nix systems:
* `hiera.yaml` is now at `/etc/puppetlabs/code/hiera.yaml`
    * (was: `/etc/hiera.yaml` or `/etc/puppetlabs/puppet/hiera.yaml` or `/etc/puppet/hiera.yaml`)
* `:datadir` is now at `/etc/puppetlabs/code/hieradata/`
    * (was: `/var/lib/hiera`)

On Windows systems:

* `hiera.yaml` is now at `<COMMON_APPDATA>\PuppetLabs\code\hiera.yaml`
  * (was: `<COMMON_APPDATA>\PuppetLabs\puppet\etc\hiera.yaml`)
* `:datadir` is now at `<COMMON_APPDATA>\PuppetLabs\code\hieradata`
  * (was: `<COMMON_APPDATA>\PuppetLabs\Hiera\var`)

Also, Hiera will now always use the _same_ default location, whether you're using it from the CLI, as a Ruby library, or via Puppet.

* [HI-298: Update FS layout for hiera](https://tickets.puppetlabs.com/browse/HI-298)
* [HI-50: pe-hiera unit tests check incorrect etc path](https://tickets.puppetlabs.com/browse/HI-50)

### API Change for Custom Backends (Backwards Compatible)

This release makes several changes to the custom backends API, in order to fix infinite interpolation recursion, forgotten order overrides, and other problems.

These changes are optional for custom backends: they'll continue to work without an update, but you can get improved behavior by updating.

To update to the new API, you'll need to:

* Change your backend's `lookup` method to accept an additional argument at the end, named `context`.
    * When the `lookup` method is called, this context hash will contain a key named `:recurse_guard`. You never need to call methods on this object, but you'll need to pass it along later.
* Change your `lookup` method to call `throw(:no_such_key)` when it doesn't find a match, instead of returning `nil`. (`nil` is now a normal value that backends can return.)
* If your `lookup` method uses the value of its `resolution_type` argument to switch between behaviors, be aware that in addition to its symbol values, it may also now be a Hash containing, at minimum, a `:behavior` key. Your backend should treat this the same as if it received a `resolution_type` value of `:hash`.
* Change any calls to the `Backend.parse_answer` or `Backend.parse_string` helper methods. Whenever your backend calls these methods:
    * It should always provide an explicit value for the `extra_data` argument. Use an empty hash `{}` if you're not providing any extra data.
    * It should provide an additional argument at the end. This argument should be a hash with two keys:
        * `:recurse_guard` --- the value should be `context[:recurse_guard]`.
        * `:order_override` --- the value should be the `order_override` value that was passed to your `lookup` method (as its third argument).
* Change any calls to the `Backend.merge_answer` helper method. Your backend should pass the value of its `resolution_type` argument as a third argument to `merge_answer`.

* [HI-328: Hiera does not detect interpolation recursion](https://tickets.puppetlabs.com/browse/HI-328)
* [HI-304: Override does not propagate to hiera() function in interpolation tokens](https://tickets.puppetlabs.com/browse/HI-304)
* [HI-337: Hiera Backends should distinguish key with null value from key not found](https://tickets.puppetlabs.com/browse/HI-337)
* [HI-348: Enable deep-merge options to be passed in lookup](https://tickets.puppetlabs.com/browse/HI-348)

### New Feature: Lookups Can Index Into Data Structures

Previously, you could only look up top-level keys in Hiera, and it would return the entire value of that key. Sometimes, especially when the value was a large hash or array, that would be more data than you wanted, and you would have to manipulate the data structure after receiving the entire thing.

Now, you can use sub-keys to request only part of a data structure. For example, `hiera('user.uid')` or `hiera('user.groups.0')`.

For details, see the docs about [performing lookups.](./lookup_types.html)

* [HI-14: Allow access to structured data](https://tickets.puppetlabs.com/browse/HI-14)

### New Feature: `literal()` Function --- Escape `%` Signs in Data

Some pieces of data need to include literal text that looks like a Hiera interpolation token, without triggering interpolation. This was previously impossible, but you can now escape percent signs to put things like Apache variables in Hiera data. You'll need to escape each literal `%` with `%{literal('%')}`.

So to get a final string that looks like this:

    http://%{SERVER_NAME}/

Write the Hiera value like this:

    "http://%{literal('%')}{SERVER_NAME}/"

For more info, see the docs about [lookup functions in interpolation tokens.](./variables.html#using-lookup-functions)

* [HI-127: PR (185) Allow escaping %{...} in hiera data so that hiera does not try to perform a replacement](https://tickets.puppetlabs.com/browse/HI-127)

### New Feature: `alias()` Function --- Make Key an Alias For Other Key

Previously, you could re-use strings from other pieces of Hiera data by using the `hiera()` lookup function in an interpolation token, but you couldn't re-use hashes or arrays. Now, Hiera will treat a string containing an `%{alias('key_name')}` token as the value of `key_name`, no matter what kind of data it is. For more details, see the docs about [lookup functions in interpolation tokens.](./variables.html#using-lookup-functions)

* [HI-183: Really need the ability to lookup hashes and arrays from other parts of Hiera.](https://tickets.puppetlabs.com/browse/HI-183)


### New Feature: Pass Options to Deep Merge Gem

The `deep_merge` gem has several options that can modify its behavior, but Hiera was unable to take advantage of them. Now, there's a new setting in `hiera.yaml` that can pass options to the gem. For details, see [the configuration page](./configuring.html) and the docs about [hash merge lookups.](./lookup_types.html#hash-merge)

* [HI-230: Allow options to be passed to deep merge](https://tickets.puppetlabs.com/browse/HI-230)

### New Feature: Output YAML on Command Line

You can now run `hiera -f yaml` to get YAML-formatted data.

* [HI-129: PR (172): Add output format to CLI - mrbanzai](https://tickets.puppetlabs.com/browse/HI-129)
* [HI-281: Add YAML output format to CLI](https://tickets.puppetlabs.com/browse/HI-281)


### Bug Fixes

* With the `hiera()` lookup function in interpolation tokens, Hiera data can look up other Hiera data, and it could end up in an infinite loop and crash with a `SystemStackError: stack level too deep` error. Now looping lookups will fail early. [HI-328: Hiera does not detect interpolation recursion](https://tickets.puppetlabs.com/browse/HI-328)
* If you looked up a piece of data that had an interpolated `hiera()` call (e.g. `value: "${hiera('other_lookup_key')}"`), and you [provided a hierarchy override](./puppet.html#hiera-lookup-functions) to the original lookup, Hiera would ignore the override when resolving the secondary lookup. This is now fixed, and overrides will propagate to secondary lookups. Note that custom backends may need an update to accommodate this; see the note above about backend API changes. [HI-304: Override does not propagate to hiera() function in interpolation tokens](https://tickets.puppetlabs.com/browse/HI-304)
* Empty YAML files will now be ignored instead of causing errors. [HI-65: PR (162): ignore empty yaml files - leinaddm](https://tickets.puppetlabs.com/browse/HI-65)
* Using the `-m` option on the command line was causing Hiera to throw away any subsequent options. This is fixed now. [HI-306: Hiera CLI optparse problems with -m](https://tickets.puppetlabs.com/browse/HI-306)
*  If a deep merge is requested, but the deep merge gem is not present, an error is given. Previously, only a warning was given and unexpected data was returned. [HI-274: :merge_behavior with deep_merge gem missing should error instead of falling back](https://tickets.puppetlabs.com/browse/HI-274)

### Not Quite Bug Fixes

Puppet 4 will pass Hiera a new pseudo-variable named `calling_class_path`, which is the name of the current class with any occurrences of `::` replaced with `/`.

We introduced this because `:` is an illegal character in Windows and OS X file names, and people trying to use `calling_class` in their hierarchies to create class-specific data sources were running into trouble. Now, you can use `calling_class_path` in the hierarchy to convert namespaced class names into a directory structure. (But only in Puppet 4 and higher.)

This isn't a change to Hiera itself, but putting it in the Hiera release notes seems like the best way to point it out to the people who want it.

* [HI-152: %{calling_class} yaml paths do not function on windows](https://tickets.puppetlabs.com/browse/HI-152)

### Operating System Support and Packaging

This release included some routine work to improve support on new platforms and drop old ones.

* [HI-273: Support Bundler workflow on x64](https://tickets.puppetlabs.com/browse/HI-273)
* [HI-126: Build windows specific gem](https://tickets.puppetlabs.com/browse/HI-126)
* [HI-185: Add Trusty (Ubuntu 14.04) support](https://tickets.puppetlabs.com/browse/HI-185)
* [HI-285: Remove saucy from build_defaults.yaml](https://tickets.puppetlabs.com/browse/HI-285)
* [HI-277: Remove sid and unstable from build_defaults](https://tickets.puppetlabs.com/browse/HI-277)
* [HI-303: Add optional dependency deep_merge to Gemfile](https://tickets.puppetlabs.com/browse/HI-303)


