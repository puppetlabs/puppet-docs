---
layout: default
title: "Language: Relationships and Ordering"
canonical: "/puppet/latest/reference/lang_relationships.html"
---

[virtual]: ./lang_virtual.html
[collector]: ./lang_collectors.html
[resources]: ./lang_resources.html
[reference]: ./lang_datatypes.html#resource-references
[array]: ./lang_datatypes.html#arrays
[class]: ./lang_classes.html
[event]: ./lang_resources.html#behavior
[service]: /references/latest/type.html#service
[exec]: /references/latest/type.html#exec
[type]: /references/latest/type.html
[mount]: /references/latest/type.html#mount
[metaparameters]: ./lang_resources.html#metaparameters
[require_function]: ./lang_classes.html#using-require




The order of [resources][] in a Puppet manifest does not matter. Puppet assumes that most resources are not related to each other and will manage the resources in whatever order is most efficient.

If a group of resources should be managed in a specific order, you must explicitly declare the relationships.

Syntax
-----

Relationships can be declared with relationship metaparameters, chaining arrows, and the `require` function.

### Relationship Metaparameters

{% highlight ruby %}
    package { 'openssh-server':
      ensure => present,
      before => File['/etc/ssh/sshd_config'],
    }
{% endhighlight %}

Puppet uses four [metaparameters][] to establish relationships. Each can be set as an attribute in any resource. The value of any relationship metaparameter should be a [resource reference][reference] (or an [array][] of references) pointing to one or more target resources.

`before`
: Causes a resource to be applied **before** the target resource.

`require`
: Causes a resource to be applied **after** the target resource.

`notify`
: Causes a resource to be applied **before** the target resource. The target resource will refresh if the notifying resource changes.

`subscribe`
: Causes a resource to be applied **after** the target resource. The subscribing resource will refresh if the target resource changes.

If two resources need to happen in order, you can either put a `before` attribute in the first resource or a `require` attribute in the subsequent one; either approach will create the same relationship. The same is true of `notify` and `subscribe`.

The two examples below create the same ordering relationship:

{% highlight ruby %}
    package { 'openssh-server':
      ensure => present,
      before => File['/etc/ssh/sshd_config'],
    }
{% endhighlight %}

{% highlight ruby %}
    file { '/etc/ssh/sshd_config':
      ensure  => file,
      mode    => 600,
      source  => 'puppet:///modules/sshd/sshd_config',
      require => Package['openssh-server'],
    }
{% endhighlight %}

The two examples below create the same notification relationship:

{% highlight ruby %}
    file { '/etc/ssh/sshd_config':
      ensure => file,
      mode   => 600,
      source => 'puppet:///modules/sshd/sshd_config',
      notify => Service['sshd'],
    }
{% endhighlight %}

{% highlight ruby %}
    service { 'sshd':
      ensure    => running,
      enable    => true,
      subscribe => File['/etc/ssh/sshd_config'],
    }
{% endhighlight %}

### Chaining Arrows

You can create relationships between two resources or groups of resources using the `->` and `~>` operators.

`->` (ordering arrow)
: Causes the resource on the left to be applied before the resource on the right. Written with a hyphen and a greater-than sign.

`~>` (notification arrow)
: Causes the resource on the left to be applied first and sends a refresh event to the resource on the right if the left resource changes. Written with a tilde and a greater-than sign.

{% highlight ruby %}
    # ntp.conf is applied first and will notify the ntpd service if it changes:
    File['/etc/ntp.conf'] ~> Service['ntpd']
{% endhighlight %}

#### Operands

The chaining arrows accept the following types of operands on either side of the arrow:

* [Resource references][reference], including multi-resource references.
* [Resource declarations][resources].
* [Resource collectors][collector].

> Note: Arrays of references cannot be chained. To chain multiple resources at once, you must use a multi-resource reference or a collector.

An operand can be shared between two chaining statements, which allows you to link them together into a "timeline":

{% highlight ruby %}
    Package['ntp'] -> File['/etc/ntp.conf'] ~> Service['ntpd']
{% endhighlight %}

Since resource declarations can be chained, you can use chaining arrows to make Puppet apply a section of code in the order that it is written:

{% highlight ruby %}
    # first:
    package { 'openssh-server':
      ensure => present,
    } -> # and then:
    file { '/etc/ssh/sshd_config':
      ensure => file,
      mode   => 600,
      source => 'puppet:///modules/sshd/sshd_config',
    } ~> # and then:
    service { 'sshd':
      ensure => running,
      enable => true,
    }
{% endhighlight %}

And since collectors can be chained, you can create many-to-many relationships:

{% highlight ruby %}
    Yumrepo <| |> -> Package <| |>
{% endhighlight %}

This example would apply all yum repository resources before applying any package resources, which protects any packages that rely on custom repos.

> Note: Chained collectors can potentially cause huge [dependency cycles](#dependency-cycles) and should be used carefully. They can also be dangerous when used with [virtual resources][virtual], which are implicitly realized by collectors.

> Note: Although you can usually chain many resources and/or collectors together (`File['one'] -> File['two'] -> File['three']`), the chain can be broken if it includes a collector whose search expression doesn't match any resources. This is [Puppet bug #18399](http://projects.puppetlabs.com/issues/18399).

> Note: Collectors can only search on attributes which are present in the manifests and cannot see properties that must be read from the target system. For example, if the example above had been written as `Yumrepo <| |> -> Package <| provider == yum |>`, it would only create relationships with packages whose `provider` attribute had been _explicitly_ set to `yum` in the manifests. It would not affect any packages that use yum without specifying the provider.

#### Reversed Forms

Both chaining arrows have a reversed form (`<-` and `<~`). As implied by their shape, these forms operate in reverse, causing the resource on their right to be applied before the resource on their left.

> Note: As the majority of Puppet's syntax is written left-to-right, we do not recommend these reversed forms, as they can be confusing .

### The `require` Function

[The `require` function][require_function] declares a [class][] and makes it a dependency of the surrounding container:

{% highlight ruby %}
    class wordpress {
      require apache
      require mysql
      ...
    }
{% endhighlight %}

The above example would cause every resource in the `apache` and `mysql` classes to be applied before any of the resources in the `wordpress` class.

Unlike the relationship metaparameters and chaining arrows, the `require` function does not have a reciprocal form or a notifying form. However, you can combine `include` and chaining arrows inside a class definition to achieve more complex behavior:

{% highlight ruby %}
    class apache::ssl {
      include site::certificates
      # Restart every service in this class if any of our SSL certificates change on disk:
      Class['site::certificates'] ~> Class['apache::ssl']
    }
{% endhighlight %}

Behavior
-----

### Ordering and Notification

Puppet has two types of resource relationships:

* Ordering.
* Ordering with notification.

An ordering relationship ensures that one resource will be managed before another.

A notification relationship does the same, but it **also** sends the latter resource a _refresh event_ if Puppet [changes the first resource's state][event]. A refresh event causes the recipient to refresh itself.

If a resource receives multiple refresh events, they will be combined and the resource will only refresh once.

### Refreshing

Only certain resource types can refresh themselves. Of the built-in types, [service][], [mount][], and [exec][] can refresh themselves.

Service resources refresh by restarting their service. Mount resources refresh by unmounting and then mounting their volume. Exec resources usually do not refresh, but you can make them do so: setting `refreshonly => true` causes the exec to never fire unless it receives a refresh event. You can also set an additional `refresh` command, which causes the exec to run both commands when it receives a refresh event.

### Autorequire

Certain resource types can autorequire other resources. This creates an ordering relationship even if you have not explicitly stated one. Autorequiring is done when applying a catalog. (That is, the autorequire relationship is not already present in the catalog.)

When Puppet is preparing to sync a resource whose type supports autorequire, it will search the catalog for any resources that match certain rules. If it finds any, it will process them before that resource. If Puppet doesn't find any resources that could be autorequired, that's fine; they won't be considered a failed dependency.

The [type reference][type] contains information on which types can autorequire other resources. Each type's description should state its autorequire behavior, if any. For an example, see the "Autorequires" section near the end of [the exec type][exec]'s description.

### Parse-Order Independence

Relationships are not limited by parse order. You can declare a relationship with a resource before that resource has been declared.

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

If two or more resources require each other in a loop, Puppet will compile the catalog but will be unable to apply it. Puppet will log an error and attempt to help you identify the cycle. The error will look like the following:

    err: Could not apply complete catalog: Found 1 dependency cycle:
    (<RESOURCE> => <OTHER RESOURCE> => <RESOURCE>)
    Try the '--graph' option and opening the resulting '.dot' file in OmniGraffle or GraphViz

To locate the directory containing the graph files, run `puppet agent --configprint graphdir`.

