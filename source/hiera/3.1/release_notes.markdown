---
layout: default
title: "Hiera 3.1: Release Notes"
---

[puppet-agent]: /puppet/4.3/reference/about_agent.html

## Hiera 3.1.0

Released March 16, 2016.

Shipped in [`puppet-agent`](/puppet/4.2/reference/about_agent.html) version [1.4.0]().

* [Fixed in Hiera 3.1.0](https://tickets.puppetlabs.com/issues/?jql=fixVersion+%3D+%27HI+3.1.0%27)
* [Introduced in Hiera 3.1.0](https://tickets.puppetlabs.com/issues/?jql=affectedVersion+%3D+%27HI+3.1.0%27)

### New feature: deep_merge compatibility

Support deep_merge compatibility mode.

[HI-483](https://tickets.puppetlabs.com/browse/HI-483)

### New feature: Hiera backend opt-in for producing subkeys

This new feature is for implementers of Hiera backends. 

Hiera backends can now opt-in to a new feature in the backend API that allows the backend to be responsible for producing values from subkeys. This is beneficial for backends that would otherwise have to produce a very large hash (for example, from a database or LDAP) only to be reduced to a single value and the returned data. Now the backend can instead opt-in to do the required slicing. 

* [HI-471](https://tickets.puppetlabs.com/browse/HI-471)

### FIX: exit compilation when no backend found

If Hiera could not load a backend, it would skip it with a warning. This could have serious implications on the configuration, as the compilation will potentially act on data where a large portion of it is missing. Hiera will now produce an error and exit catalog compliation.

* [HI-499](https://tickets.puppetlabs.com/browse/HI-499)

### REGRESSION FIX: empty interpolations

A regression where empty interpolations in Hiera strings caused garbage text to be inserted has been fixed. This regression was introduced in the 3.x Hiera release. Empty interpolations such as %{}, or %{::} now work, and the trick to get one verbatim interpolation into the string (for example, "%%{}{environment}" producing the string "%{environment}") is now also again functional.

* [HI-494](https://tickets.puppetlabs.com/browse/HI-494)

### FIX: infinite recursion when calling `hiera()` in hiera.yaml

Calling the `hiera()` interpolation method from within a hiera.yaml caused infinite recursion. This was fixed by making it an error to set `hiera()` method in interpolation in hiera.yaml. Also, the use of other interpolation methods in hiera.yaml will now yield a deprecation warning as they will not be allowed in Hiera 4.0.