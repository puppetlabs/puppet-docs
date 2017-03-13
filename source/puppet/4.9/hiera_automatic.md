---
title: "Hiera: Looking up data: Automatic class parameter lookup"
toc: false
---

[class parameters]: ./lang_classes.html#class-parameters-and-variables
[classes]: ./lang_classes.html
[class_declare]: ./lang_classes.html#declaring-classes
[resource_like]: ./lang_classes.html#resource-like-behavior
[class_definition]: ./lang_classes.html#defining-classes
[r_n_p]: {{pe}}/r_n_p_intro.html



When values for [class parameters][] aren't explicitly provided, Puppet automatically looks them up in Hiera, using the fully-qualified name of the parameter (like `myclass::parameter_one`) as a lookup key.


## How class parameters work

Most [classes][] need some amount of configuration, and they can specify parameters to request the data they need.

There are three ways to set values for class parameters, and Puppet tries each of them in order when the class is [declared][class_declare] or assigned by an ENC:

1. If it was a [resource-like declaration/assignment][resource_like], Puppet uses any parameters that were explicitly set. These always win if they exist.
2. **Puppet automatically looks up the remaining parameters with Hiera, using `<CLASS NAME>::<PARAMETER NAME>` as the lookup key (for example, `ntp::servers` for the `ntp` class's `$servers` parameter).**
3. For any parameters that still have no value, Puppet uses the default value from the class's [definition][class_definition].
4. If any parameters have no value AND no default, Puppet fails compilation with an error.

Thus, you can set servers for the NTP class like this:

``` yaml
# /etc/puppetlabs/code/production/data/nodes/web01.example.com.yaml
---
ntp::servers:
  - time.example.com
  - 0.pool.ntp.org
```

That's automatic class parameter lookup.

## Pro-tip: Use the roles and profiles method

Automatic class parameter lookup is powerful, but you probably use thousands of class parameters to describe your infrastructure, and putting them all in Hiera is an invitation to chaos. The best way to manage that is to use [the roles and profiles method][r_n_p], which allows you to store a _smaller amount_ of _more meaningful_ data in Hiera. For more details, see [our documentation on the roles and profiles method][r_n_p].
