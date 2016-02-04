---
layout: default
title: "Future Parser: Relationships and Ordering"
canonical: "/puppet/latest/reference/lang_relationships.html"
---

[virtual]: ./future_lang_virtual.html
[collector]: ./future_lang_collectors.html
[resources]: ./future_lang_resources.html
[reference]: ./future_lang_data_resource_reference.html
[array]: ./future_lang_data_array.html
[class]: ./future_lang_classes.html
[event]: ./future_lang_resources.html#behavior
[service]: ./type.html#service
[exec]: ./type.html#exec
[type]: ./type.html
[mount]: ./type.html#mount
[metaparameters]: ./future_lang_resources.html#metaparameters
[require_function]: ./future_lang_classes.html#using-require
[moar]: ./configuration.html#ordering
[lambdas]: ./future_lang_lambdas.html



With default settings, the order of [resources][] in a Puppet manifest does not matter. Puppet assumes that most resources are not related to each other and will manage the resources in whatever order is most efficient.

If a group of resources should be managed in a specific order, you must explicitly declare the relationships.

> **Aside: Manifest Ordering** Puppet 3.3 added a the ability to turn on [manifest ordering][moar] in the agent's puppet.conf, which causes resources to be applied in the order they are declared in manifests. Beginning in Puppet 4, manifest ordering will be the default setting.
>
> While manifest ordering is an intuitive and useful shortcut, you should still explicitly declare dependencies much of the time, especially in modules where resources are spread out across multiple manifests.


Relationships can be declared with the relationship metaparameters, chaining arrows, and the `require` function.

Syntax: Relationship Metaparameters
-----

~~~ ruby
    package { 'openssh-server':
      ensure => present,
      before => File['/etc/ssh/sshd_config'],
    }
~~~

Puppet uses four [metaparameters][] to establish relationships. Each of them can be set as an attribute in any resource. The value of any relationship metaparameter should be a [resource reference][reference] (or [array][] of references) pointing to one or more **target resources.**

* `before` --- Causes a resource to be applied **before** the target resource.
* `require` --- Causes a resource to be applied **after** the target resource.
* `notify` --- Causes a resource to be applied **before** the target resource. The target resource will refresh if the notifying resource changes.
* `subscribe` --- Causes a resource to be applied **after** the target resource. The subscribing resource will refresh if the target resource changes.

If two resources need to happen in order, you can either put a `before` attribute in the prior one or a `require` attribute in the subsequent one; either approach will create the same relationship. The same is true of `notify` and `subscribe`.

The two examples below create the same ordering relationship:

~~~ ruby
    package { 'openssh-server':
      ensure => present,
      before => File['/etc/ssh/sshd_config'],
    }
~~~

~~~ ruby
    file { '/etc/ssh/sshd_config':
      ensure  => file,
      mode    => '0600',
      source  => 'puppet:///modules/sshd/sshd_config',
      require => Package['openssh-server'],
    }
~~~

The two examples below create the same notification relationship:

~~~ ruby
    file { '/etc/ssh/sshd_config':
      ensure => file,
      mode   => '0600',
      source => 'puppet:///modules/sshd/sshd_config',
      notify => Service['sshd'],
    }
~~~

~~~ ruby
    service { 'sshd':
      ensure    => running,
      enable    => true,
      subscribe => File['/etc/ssh/sshd_config'],
    }
~~~


Syntax: Chaining Arrows
-----

~~~ ruby
    # ntp.conf is applied first, and will notify the ntpd service if it changes:
    File['/etc/ntp.conf'] ~> Service['ntpd']
~~~

You can create relationships between two resources or groups of resources using the `->` and `~>` operators.

* `->` (ordering arrow) --- Causes the resource on the left to be applied before the resource on the right. Written with a hyphen and a greater-than sign.
* `~>` (notification arrow) --- Causes the resource on the left to be applied first, and sends a refresh event to the resource on the right if the left resource changes. Written with a tilde and a greater-than sign.

### Operands

The chaining arrows accept the following kinds of operands on either side of the arrow:

* [Resource references][reference], including multi-resource references
* Arrays of resource references
* [Resource declarations][resources]
* [Resource collectors][collector]

An operand can be shared between two chaining statements, which allows you to link them together into a "timeline:"

~~~ ruby
    Package['ntp'] -> File['/etc/ntp.conf'] ~> Service['ntpd']
~~~

Since resource declarations can be chained, you can use chaining arrows to make Puppet apply a section of code in the order that it is written:

~~~ ruby
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
~~~

And since collectors can be chained, you can create many-to-many relationships:

~~~ ruby
    Yumrepo <| |> -> Package <| |>
~~~

This example would apply all yum repository resources before applying any package resources, which protects any packages that rely on custom repos.

### Capturing Resource References for Generated Resources

In this version of the Puppet language, the _value_ of a resource declaration is a _reference_ to the resource it creates.

You can take advantage of this if you're automatically creating resources whose titles you can't predict, by using the [iteration functions][lambdas] to declare several resources at once or using an array of strings as a resource title. If you assign the resulting resource references to a variable, you can then use them in chaining statements without ever knowing the final title of the affected resources.

For example:

* The `map` function iterates over its arguments and returns an array of values, wich each value produced by the last expression in the block. If that last expression is a resource declaration, `map` would produce an array of resource references, which could then be used as an operand for a chaining arrow.
* The value of a resource declaration whose title is an array is an array of resource references. This can be assigned to a variable and used in a chaining statement.

### Caveats when Chaining Resource Collectors

#### Potential for Dependency Cycles

Chained collectors can potentially cause huge [dependency cycles](#dependency-cycles) and should be used carefully. They can also be dangerous when used with [virtual resources][virtual], which are implicitly realized by collectors.

#### Potential for Breaking Chains

Although you can usually chain many resources and/or collectors together (`File['one'] -> File['two'] -> File['three']`), the chain can be broken if it includes a collector whose search expression doesn't match any resources. This is [Puppet bug PUP-1410](https://tickets.puppetlabs.com/browse/PUP-1410).

#### Implicit Properties Aren't Searchable

Collectors can only search on attributes which are present in the manifests; they cannot see properties that are automatically set or are read from the target system. For example, if the example above had been written as `Yumrepo <| |> -> Package <| provider == yum |>`, it would only create relationships with packages whose `provider` attribute had been _explicitly_ set to `yum` in the manifests. It would not affect any packages that didn't specify a provider but would end up using Yum because it's the default provider for the node's OS.

### Reversed Forms

Both chaining arrows have a reversed form (`<-` and `<~`). As implied by their shape, these forms operate in reverse, causing the resource on their right to be applied before the resource on their left.

> Note: As the majority of Puppet's syntax is written left-to-right, these reversed forms can be confusing and are not recommended.

Syntax: The `require` Function
-----

[The `require` function][require_function] declares a [class][] and causes it to become a dependency of the surrounding container:

~~~ ruby
    class wordpress {
      require apache
      require mysql
      ...
    }
~~~

The above example would cause every resource in the `apache` and `mysql` classes to be applied before any of the resources in the `wordpress` class.

Unlike the relationship metaparameters and chaining arrows, the `require` function does not have a reciprocal form or a notifying form. However, more complex behavior can be obtained by combining `include` and chaining arrows inside a class definition:

~~~ ruby
    class apache::ssl {
      include site::certificates
      # Restart every service in this class if any of our SSL certificates change on disk:
      Class['site::certificates'] ~> Class['apache::ssl']
    }
~~~

Behavior
-----

### Ordering and Notification

Puppet has two kinds of resource relationships:

* Ordering
* Ordering with notification

An ordering relationship ensures that one resource will be managed before another.

A notification relationship does the same, but **also** sends the latter resource a **refresh event** if Puppet [changes the first resource's state][event]. A refresh event causes the recipient to refresh itself.

If a resource receives multiple refresh events, they will be combined and the resource will only refresh once.

### Refreshing

Only certain resource types can refresh themselves. Of the built-in resource types, these are [service][], [mount][], and [exec][].

Service resources refresh by restarting their service. Mount resources refresh by unmounting and then mounting their volume. Exec resources usually do not refresh, but can be made to: setting `refreshonly => true` causes the exec to never fire _unless_ it receives a refresh event. You can also set an additional `refresh` command, which causes the exec to run both commands when it receives a refresh event.

### Autorequire

Certain resource types can **autorequire** other resources. This creates an ordering relationship without the user explicitly stating one. Autorequiring is done when applying a catalog. (That is, the autorequire relationship is not already present in the catalog.)

When Puppet is preparing to sync a resource whose type supports autorequire, it will search the catalog for any resources that match certain rules. If it finds any, it will process them _before_ that resource. If Puppet _doesn't_ find any resources that could be autorequired, that's fine; they won't be considered a failed dependency.

The [resource type reference][type] contains information on which resource types can autorequire other resources. Each resource type's description should state its autorequire behavior, if any. For an example, see the "Autorequires" section near the end of [the `exec` type's description.][exec]

### Evaluation-Order Independence

Relationships are not limited by evaluation-order. You can declare a relationship with a resource before that resource has been declared.

### Missing Dependencies

If one of the resources in a relationship is never declared, **compilation will fail** with one of the following errors:

* `Could not find dependency <OTHER RESOURCE> for <RESOURCE>`
* `Could not find resource '<OTHER RESOURCE>' for relationship on '<RESOURCE>'`.

### Failed Dependencies

If Puppet fails to apply the prior resource in a relationship, it will skip the subsequent resource and log the following messages:

    notice: <RESOURCE>: Dependency <OTHER RESOURCE> has failures: true
    warning: <RESOURCE>: Skipping because of failed dependencies

It will then continue to apply any unrelated resources. Any resources that depend on the skipped resource will also be skipped.

This helps prevent inconsistent system state by causing a "clean" failure instead of attempting to apply a resource whose prerequisites may be broken.

> Note: Although a resource won't be applied if a dependency fails, it can still receive and respond to refresh events from other, successful, dependencies. This is because refreshes are handled semi-independently of the normal resource sync process. It is an outstanding design issue, and may be tracked at [issue #7486](http://projects.puppetlabs.com/issues/7486).

### Dependency Cycles

If two or more resources require each other in a loop, Puppet will compile the catalog but will be unable to apply it. Puppet will log an error like the following, and will attempt to help you identify the cycle:

    err: Could not apply complete catalog: Found 1 dependency cycle:
    (<RESOURCE> => <OTHER RESOURCE> => <RESOURCE>)
    Try the '--graph' option and opening the resulting '.dot' file in OmniGraffle or GraphViz

To locate the directory containing the graph files, run `puppet agent --configprint graphdir`.

