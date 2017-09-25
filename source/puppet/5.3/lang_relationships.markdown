---
layout: default
title: "Language: Relationships and ordering"
---

[virtual]: ./lang_virtual.html
[collector]: ./lang_collectors.html
[resources]: ./lang_resources.html
[reference]: ./lang_data_resource_reference.html
[array]: ./lang_data_array.html
[class]: ./lang_classes.html
[service]: ./type.html#service
[exec]: ./type.html#exec
[type]: ./type.html
[mount]: ./type.html#mount
[package]: ./type.html#package
[metaparameters]: ./lang_resources.html#metaparameters
[require_function]: ./lang_classes.html#using-require
[moar]: ./configuration.html#ordering
[lambdas]: ./lang_lambdas.html
[containment]: ./lang_containment.html


By default, Puppet applies resources in the order they're declared in their manifest. However, if a group of resources must _always_ be managed in a specific order, you should explicitly declare such relationships with relationship metaparameters, chaining arrows, and the `require` function.

> **Aside: Default ordering**
>
> To make Puppet apply unrelated resources in a more-or-less random order, set [the `ordering` setting][moar] to `title-hash` or `random`.


## Syntax: Relationship metaparameters


``` puppet
package { 'openssh-server':
  ensure => present,
  before => File['/etc/ssh/sshd_config'],
}
```

Puppet uses four [metaparameters][] to establish relationships, and you can set each of them as an attribute in any resource. The value of any relationship metaparameter should be a [resource reference][reference] (or [array][] of references) pointing to one or more **target resources**.

* `before` --- Applies a resource **before** the target resource.
* `require` --- Applies a resource **after** the target resource.
* `notify` --- Applies a resource **before** the target resource. The target resource [refreshes][refresh] if the notifying resource changes.
* `subscribe` --- Applies a resource **after** the target resource. The subscribing resource [refreshes][refresh] if the target resource changes.

If two resources need to happen in order, you can either put a `before` attribute in the prior one or a `require` attribute in the subsequent one; either approach creates the same relationship. The same is true of `notify` and `subscribe`.

The two examples below create the same ordering relationship:

``` puppet
package { 'openssh-server':
  ensure => present,
  before => File['/etc/ssh/sshd_config'],
}
```

``` puppet
file { '/etc/ssh/sshd_config':
  ensure  => file,
  mode    => '0600',
  source  => 'puppet:///modules/sshd/sshd_config',
  require => Package['openssh-server'],
}
```

The two examples below create the same notifying relationship:

``` puppet
file { '/etc/ssh/sshd_config':
  ensure => file,
  mode   => '0600',
  source => 'puppet:///modules/sshd/sshd_config',
  notify => Service['sshd'],
}
```

``` puppet
service { 'sshd':
  ensure    => running,
  enable    => true,
  subscribe => File['/etc/ssh/sshd_config'],
}
```

Since an array of resource references can contain resources of differing types, these two examples also create the same ordering relationship:

``` puppet
service { 'sshd':
  ensure  => running,
  require => [
    Package['openssh-server'],
    File['/etc/ssh/sshd_config'],
  ],
}
```

``` puppet
package { 'openssh-server':
  ensure => present,
  before => Service['sshd'],
}

file { '/etc/ssh/sshd_config':
  ensure => file,
  mode   => '0600',
  source => 'puppet:///modules/sshd/sshd_config',
  before => Service['sshd'],
}
```


## Syntax: Chaining arrows


``` puppet
# ntp.conf is applied first, and notifies the ntpd service if it changes:
File['/etc/ntp.conf'] ~> Service['ntpd']
```

You can create relationships between two resources or groups of resources using the `->` and `~>` operators.

* `->` (ordering arrow; a hyphen and a greater-than sign) --- Applies the resource on the left before the resource on the right.
* `~>` (notifying arrow; a tilde and a greater-than sign) --- Applies the resource on the left first. If the left-hand resource changes, the right-hand resource will [refresh][].

### Operands

The chaining arrows accept the following kinds of operands on either side of the arrow:

* [Resource references][reference], including multi-resource references
* Arrays of resource references
* [Resource declarations][resources]
* [Resource collectors][collector]

An operand can be shared between two chaining statements, which allows you to link them together into a "timeline":

``` puppet
Package['ntp'] -> File['/etc/ntp.conf'] ~> Service['ntpd']
```

Since resource declarations can be chained, you can use chaining arrows to make Puppet apply a section of code in the order that it is written:

``` puppet
# first:
package { 'openssh-server':
  ensure => present,
} -> # and then:
file { '/etc/ssh/sshd_config':
  ensure => file,
  mode   => '0600',
  source => 'puppet:///modules/sshd/sshd_config',
} ~> # and then:
service { 'sshd':
  ensure => running,
  enable => true,
}
```

And since collectors can be chained, you can create many-to-many relationships:

``` puppet
Yumrepo <| |> -> Package <| |>
```

This example applies all yum repository resources before applying any package resources, which protects any packages that rely on custom repositories.

### Capturing resource references for generated resources

In this version of the Puppet language, the _value_ of a resource declaration is a _reference_ to the resource it creates.

You can take advantage of this if you're automatically creating resources whose titles you can't predict, by using the [iteration functions][lambdas] to declare several resources at once or using an array of strings as a resource title. If you assign the resulting resource references to a variable, you can then use them in chaining statements without ever knowing the final title of the affected resources.

For example:

* The `map` function iterates over its arguments and returns an array of values, with each value produced by the last expression in the block. If that last expression is a resource declaration, `map` produces an array of resource references, which could then be used as an operand for a chaining arrow.
* The value of a resource declaration whose title is an array, is itself an array of resource references that you can assign to a variable and use in a chaining statement.

### Caveats when chaining resource collectors

#### Potential for dependency cycles

Chained collectors can cause huge [dependency cycles](#dependency-cycles); be careful when using them. They can also be dangerous when used with [virtual resources][virtual], which are implicitly realized by collectors.

#### Potential for breaking chains

Although you can usually chain many resources or collectors together (`File['one'] -> File['two'] -> File['three']`), the chain can be broken if it includes a collector whose search expression doesn't match any resources. This is [Puppet bug PUP-1410](https://tickets.puppetlabs.com/browse/PUP-1410).

#### Implicit properties aren't searchable

Collectors can search only on attributes present in the manifests; they cannot see properties that are automatically set or are read from the target system. For example, if the example above had been written as `Yumrepo <| |> -> Package <| provider == yum |>`, it would only create relationships with packages whose `provider` attribute had been _explicitly_ set to `yum` in the manifests. It would not affect any packages that didn't specify a provider but would end up using Yum because it's the default provider for the node's operating system.

### Reversed forms

Both chaining arrows have a reversed form (`<-` and `<~`). As implied by their shape, these forms operate in reverse, causing the resource on their right to be applied before the resource on their left.

> **Note**: Most of Puppet's syntax is written left-to-right. Avoid these reversed forms as they can be confusing.


## Syntax: The `require` function


[The `require` function][require_function] declares a [class][] and causes it to become a dependency of the surrounding container:

``` puppet
class wordpress {
  require apache
  require mysql
  ...
}
```

The above example causes every resource in the `apache` and `mysql` classes to be applied before any of the resources in the `wordpress` class.

Unlike the relationship metaparameters and chaining arrows, the `require` function does not have a reciprocal form or a notifying form. However, more complex behavior can be obtained by combining `include` and chaining arrows inside a class definition:

``` puppet
class apache::ssl {
  include site::certificates
  # Restart every service in this class if any of our SSL certificates change on disk:
  Class['site::certificates'] ~> Class['apache::ssl']
}
```


## Behavior


### Ordering

All relationships cause Puppet to manage one or more resources before one or more other resources.

By default, _unrelated_ resources are managed in the order in which they're written in their manifest file. If you declare an explicit relationship between resources, it will override this default ordering.

### Refreshing and notification

[refresh]: #refreshing-and-notification

Some resource types can do a special "refresh" action when a dependency changes. For example, some services must restart when their config files change, so `service` resources can refresh by restarting the service.

(The built-in resource types that can refresh are [service][], [mount][], [exec][], and sometimes [package][]. See each type's docs for info about their refresh behavior.)

Puppet uses notifying relationships (`subscribe`, `notify`, and `~>`) to tell resources when they should refresh. A resource will perform its refresh action if Puppet changes any of the resources it subscribes to.

Notifying relationships also interact with [containment][]. The complete rules for notification and refreshing are:

#### Receiving refresh events

* If a resource gets a refresh event during a run and its resource type has a refresh action, it will perform that action.
* If a resource gets a refresh event but its resource type _cannot_ refresh, nothing happens.
* If a class or defined resource gets a refresh event, every resource it contains will also get a refresh event.
* A resource can perform its refresh action up to once per run. If it receives multiple refresh events, they're combined and the resource only refreshes once.

#### Sending refresh events

* If a resource is not in its desired state and Puppet makes changes to it during a run, it will send a refresh event to any subscribed resources.
* If a resource performs its refresh action during a run, it will send a refresh event to any subscribed resources.
* If Puppet changes (or refreshes) any resource in a class or defined resource, that class or defined resource will send a refresh event to any subscribed resources.

#### No-op

* If a resource is in no-op mode (due to the global `noop` setting or the per-resource `noop` metaparameter), it _will not refresh_ when it receives a refresh event. However, Puppet will log a message stating what would have happened.
* If a resource is in no-op mode but Puppet would otherwise have changed or refreshed it, it _will not send refresh events_ to subscribed resources. However, Puppet will log messages stating what would have happened to any resources further down the subscription chain.

### Auto\* relationships

Certain resource types can have automatic relationships with other resources, using  _autorequire_, _autonotify_, _autobefore_, or _autosubscribe_. This creates an ordering relationship without the user explicitly stating one. The [resource type reference][type] notes which resource types can have these types of relationships with other resources. Auto relationships between types and resources are established when applying a catalog.

When Puppet prepares to sync a resource whose type supports an auto relationship, it searches the catalog for any resources that match certain rules. If it finds any, it processes them in the correct order, sending refresh events if necessary. If Puppet _doesn't_ find any resources that could use an auto relationship, that's fine; they aren't considered a failed dependency.

### Evaluation-order independence

Relationships are not limited by evaluation-order. You can declare a relationship with a resource before that resource has been declared.

### Missing dependencies

If one of the resources in a relationship is never declared, **compilation fails** with one of the following errors:

* `Could not find dependency <OTHER RESOURCE> for <RESOURCE>`
* `Could not find resource '<OTHER RESOURCE>' for relationship on '<RESOURCE>'`.

### Failed dependencies

If Puppet fails to apply the prior resource in a relationship, it skips the subsequent resource and log the following messages:

```
notice: <RESOURCE>: Dependency <OTHER RESOURCE> has failures: true
warning: <RESOURCE>: Skipping because of failed dependencies
```

It then continues to apply any unrelated resources. Any resources that depend on the skipped resource are also skipped.

This helps prevent inconsistent system state by causing a "clean" failure instead of attempting to apply a resource whose prerequisites might be broken.

> **Note**: Although a resource won't be applied if a dependency fails, it can still receive and respond to refresh events from other, successful, dependencies. This is because refreshes are handled semi-independently of the normal resource sync process. It is an outstanding design issue, and can be tracked at [issue #7486](http://projects.puppetlabs.com/issues/7486).

### Dependency cycles

If two or more resources require each other in a loop, Puppet compiles the catalog but won't be able to apply it. Puppet logs an error like the following, and attempts to help  identify the cycle:

```
err: Could not apply complete catalog: Found 1 dependency cycle:
(<RESOURCE> => <OTHER RESOURCE> => <RESOURCE>)
Try the '--graph' option and opening the resulting '.dot' file in OmniGraffle or GraphViz
```

To locate the directory containing the graph files, run `puppet agent --configprint graphdir`.