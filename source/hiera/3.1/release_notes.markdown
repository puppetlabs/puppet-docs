---
layout: default
title: "Hiera 3.1: Release Notes"
---

[`puppet-agent`]: /puppet/4.4/reference/about_agent.html

[1.4.2]: /puppet/4.4/reference/release_notes_agent.html#puppet-agent-142
[1.4.1]: /puppet/4.4/reference/release_notes_agent.html#puppet-agent-141

{% partial /hiera/_hiera_update.md %}

## Hiera 3.1.2

Released April 26, 2016.

This is a bug fix release in the Hiera 3.1 series, shipped with [`puppet-agent`][] [1.4.2][]

* [Fixed in Hiera 3.1.2](https://tickets.puppetlabs.com/issues/?jql=fixVersion+%3D+%27HI+3.1.2%27)
* [Introduced in Hiera 3.1.2](https://tickets.puppetlabs.com/issues/?jql=affectedVersion+%3D+%27HI+3.1.2%27)

### Bug Fix

#### Subkeys were matching by string values containing the subkey

When looking up a key with a dot, such as 'foo.bar', if foo was bound to a string containing the next segment ('bar') the value 'bar' was be returned instead of the expected undef.

[HI-508](https://tickets.puppetlabs.com/browse/HI-)


## Hiera 3.1.1

Released March 24, 2016.

This is a small one-feature release shipped in [`puppet-agent`][] version [1.4.1][].

* [Fixed in Hiera 3.1.1](https://tickets.puppetlabs.com/issues/?jql=fixVersion+%3D+%27HI+3.1.1%27)
* [Introduced in Hiera 3.1.1](https://tickets.puppetlabs.com/issues/?jql=affectedVersion+%3D+%27HI+3.1.1%27)

### New features

#### Interpolated keys can contain period character

It is now possible to lookup keys in Hiera data containing the `.` character (period), by quoting the entire name segment with either single or double quotes.

> **Note:** It is important to correctly quote with the corresponding YAML or JSON syntax rules for single and double quotes when using quoted keys in interpolation inside of the Hiera data.


## Hiera 3.1.0

Released March 16, 2016.

Shipped in [`puppet-agent`][] version [1.4.0](/puppet/4.4/reference/release_notes_agent.html#puppet-agent-140).

* [Fixed in Hiera 3.1.0](https://tickets.puppetlabs.com/issues/?jql=fixVersion+%3D+%27HI+3.1.0%27)
* [Introduced in Hiera 3.1.0](https://tickets.puppetlabs.com/issues/?jql=affectedVersion+%3D+%27HI+3.1.0%27)

### New features

#### deep_merge compatibility

Support deep_merge compatibility mode.

[HI-483](https://tickets.puppetlabs.com/browse/HI-483)

#### Hiera backend opt-in for producing subkeys

This new feature is for implementers of Hiera backends.

Hiera backends can now opt-in to a new feature in the backend API that allows the backend to be responsible for producing values from subkeys. This is beneficial for backends that would otherwise have to produce a very large hash (for example, from a database or LDAP) only to be reduced to a single value and the returned data. Now the backend can instead opt-in to do the required slicing.

* [HI-471](https://tickets.puppetlabs.com/browse/HI-471)

### Bug fixes

#### Exit compilation when no backend found

If Hiera could not load a backend, it would skip it with a warning. This could have serious implications on the configuration, as the compilation will potentially act on data where a large portion of it is missing. Hiera will now produce an error and exit catalog compliation.

* [HI-499](https://tickets.puppetlabs.com/browse/HI-499)

#### Empty interpolations

A regression where empty interpolations in Hiera strings caused garbage text to be inserted has been fixed. This regression was introduced in the 3.x Hiera release. Empty interpolations such as %{}, or %{::} now work, and the trick to get one verbatim interpolation into the string (for example, "%%{}{environment}" producing the string "%{environment}") is now also again functional.

* [HI-494](https://tickets.puppetlabs.com/browse/HI-494)

#### Infinite recursion when calling `hiera()` in hiera.yaml

Calling the `hiera()` interpolation method from within a hiera.yaml caused infinite recursion. This was fixed by making it an error to set `hiera()` method in interpolation in hiera.yaml. Also, the use of other interpolation methods in hiera.yaml will now yield a deprecation warning as they will not be allowed in Hiera 4.0.
