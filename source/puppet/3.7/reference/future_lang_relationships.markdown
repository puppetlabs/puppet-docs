---
layout: default
title: "Future Parser: Relationships and Ordering"
canonical: "/puppet/latest/reference/future_lang_relationships.html"
---

[virtual]: ./future_lang_virtual.html
[collector]: ./future_lang_collectors.html
[resources]: ./future_lang_resources.html
[reference]: ./future_lang_datatypes.html#resource-references
[array]: ./future_lang_datatypes.html#arrays
[class]: ./future_lang_classes.html
[event]: ./future_lang_resources.html#behavior
[service]: /references/latest/type.html#service
[exec]: /references/latest/type.html#exec
[type]: /references/latest/type.html
[mount]: /references/latest/type.html#mount
[metaparameters]: ./future_lang_resources.html#metaparameters
[require_function]: ./future_lang_classes.html#using-require
[moar]: /references/latest/configuration.html#ordering




With default settings, the order of [resources][] in a Puppet manifest does not matter. Puppet assumes that most resources are not related to each other and will manage the resources in whatever order is most efficient.

If a group of resources should be managed in a specific order, you must explicitly declare the relationships.

>****Aside: Manifest Ordering**** Puppet 3.3 added a the ability to turn on [manifest ordering][moar] in the agent's puppet.conf, which causes resources to be applied in the order they are declared in manifests. Beginning in Puppet 4, manifest ordering will be the default setting. Manifest ordering is an intuitive and useful shortcut, but you'll still want to explicitly declare dependencies whenever you can--especially in modules or other places where resources are spread out across multiple manifests.


Syntax
-----

Relationships can be declared with the relationship metaparameters, chaining arrows, and the `require` function.

### Relationship Metaparameters

{% highlight ruby %}
    package { 'openssh-server':
      ensure => present,
      before => File['/etc/ssh/sshd_config'],
    }
{% endhighlight %}

Puppet uses four [metaparameters][] to establish relationships. Each of them can be set as an attribute in any resource. The value of any relationship metaparameter should be a [resource reference][reference] (or [array][] of references) pointing to one or more **target resources.**

`before`
: Causes a resource to be applied **before** the target resource.

`require`
: Causes a resource to be applied **after** the target resource.

`notify`
: Causes a resource to be applied **before** the target resource. The target resource will refresh if the notifying resource changes.

`subscribe`
: Causes a resource to be applied **after** the target resource. The subscribing resource will refresh if the target resource changes.

If two resources need to happen in order, you can either put a `before` attribute in the prior one or a `require` attribute in the subsequent one; either approach will create the same relationship. The same is true of `notify` and `subscribe`.

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

{% highlight ruby %}
    # ntp.conf is applied first, and will notify the ntpd service if it changes:
    File['/etc/ntp.conf'] ~> Service['ntpd']
{% endhighlight %}

You can create relationships between two resources or groups of resources using the `->` and `~>` operators.

`->` (ordering arrow)
: Causes the resource on the left to be applied before the resource on the right. Written with a hyphen and a greater-than sign.

`~>` (notification arrow)
: Causes the resource on the left to be applied first, and sends a refresh event to the resource on the right if the left resource changes. Written with a tilde and a greater-than sign.

#### Operands

The chaining arrows accept the following types of operands on either side of the arrow:

* [Resource references][reference], including multi-resource references
* [Resource declarations][resources]
* [Resource collectors][collector]
* Array of [Resource references][reference]


An operand can be shared between two chaining statements, which allows you to link them together into a "timeline:"

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

> Note: Collectors can only search on attributes which are present in the manifests and cannot see properties that must be read from the target system. For example, if the example above had been written as `Yumrepo <| |> -> Package <| provider == yum |>`, it would only create relationships with packages whose `provider` attribute had been _explicitly_ set to `yum` in the manifests. It would not affect any packages that didn't specify a provider but would end up using Yum.

#### Reversed Forms

Both chaining arrows have a reversed form (`<-` and `<~`). As implied by their shape, these forms operate in reverse, causing the resource on their right to be applied before the resource on their left.

> Note: As the majority of Puppet's syntax is written left-to-right, these reversed forms can be confusing and are not recommended.

#### Data Driven Constructs and Iteration (advanced)

In configurations that are primarily data driven it is common to lookup arrays of resources
and class names and then operate on them to achieve the same result as if a puppet manifest
had been written with these resource and classes spelled out using regular Puppet statements.
In earlier versions of Puppet this could lead to difficulties in defining the relationships.

Since Puppet 4.0 (or Puppet 3x with future parser) there are additional features in the language that helps in these situations. These features are:

* A resource declaration of a single titled resource produces a [Resource reference][reference] as its value
* A resource declaration with multiple titles produces an Array of [Resource references][reference] as its value
* The last expression evaluated in a block of code becomes the value of that block (why this is of value is demonstrated below).

As an example, this means that you can **create the resources in an Array or Hash** which produces a structure of resource references in addition to adding the resources to the catalog:

{% highlight ruby %}
    $resources = {
      package =>
        package { 'openssh-server':
          ensure => present,
        },
      
      file => 
        file { '/etc/ssh/sshd_config':
          ensure => file,
          mode   => 600,
          source => 'puppet:///modules/sshd/sshd_config',
        },
        
      service =>
        service { 'sshd':
          ensure => running,
          enable => true,
        }
    }
    # These can now be linked without knowing the titles of the resources
    $resources[package] -> $resources[file] ~> $resources[service]
    
{% endhighlight %}

If you are creating a sequence of resources, you can **use iteration** that creates and
adds the resource to the catalog and produces an array of the resource references
as a value:

{% highlight ruby %}

    $messages = [ 'good morning', 'good day', 'good evening']
    $notifies = $messages.map |$message| {
      notify { $message: }
    }    
{% endhighlight %}

This would assign an array of notify references to `$notifies` with the content
`[Notify['good morning'], Notify['good day'], Notify['good evening']]`. Note that the
`map` function produces an array of equal length to the input but with the result of each iteration
at each position instead of the original value.

The array (`$notifies`) can then be used - say if we want to link them to be applied in the order they were given:

{% highlight ruby %}

    $notifies.reduce |$result, $notify| { $result -> $notify }
{% endhighlight %}

The variable $notifies is not really needed - the example can be written as:

{% highlight ruby %}

    $messages = [ 'good morning', 'good day', 'good evening']
    $messages.map |$message| {
      notify { $message: }
    }.reduce | $result, $notify | {
      $result -> $notify
    }
{% endhighlight %}

And as a final example: if you do not care in which order those messages are applied but
that they must all be applied before a final message, then they can be directly linked like this:

{% highlight ruby %}

    $messages = [ 'good morning', 'good day', 'good evening']
    $messages.map |$message| {
      notify { $message: }
    } ->
    notify { 'the final message':
    }
{% endhighlight %}

This works because `map` produces an Array of references, and the `->` operator produces one relationship between each of the references on the left hand side with each reference on
the right hand side.

### The `require` Function

[The `require` function][require_function] declares a [class][] and causes it to become a dependency of the surrounding container:

{% highlight ruby %}
    class wordpress {
      require apache
      require mysql
      ...
    }
{% endhighlight %}

The above example would cause every resource in the `apache` and `mysql` classes to be applied before any of the resources in the `wordpress` class.

Unlike the relationship metaparameters and chaining arrows, the `require` function does not have a reciprocal form or a notifying form. However, more complex behavior can be obtained by combining `include` and chaining arrows inside a class definition:

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

* Ordering
* Ordering with notification

An ordering relationship ensures that one resource will be managed before another.

A notification relationship does the same, but **also** sends the latter resource a **refresh event** if Puppet [changes the first resource's state][event]. A refresh event causes the recipient to refresh itself.

If a resource receives multiple refresh events, they will be combined and the resource will only refresh once.

### Refreshing

Only certain resource types can refresh themselves. Of the built-in types, these are [service][], [mount][], and [exec][].

Service resources refresh by restarting their service. Mount resources refresh by unmounting and then mounting their volume. Exec resources usually do not refresh, but can be made to: setting `refreshonly => true` causes the exec to never fire _unless_ it receives a refresh event. You can also set an additional `refresh` command, which causes the exec to run both commands when it receives a refresh event.

### Autorequire

Certain resource types can **autorequire** other resources. This creates an ordering relationship without the user explicitly stating one. Autorequiring is done when applying a catalog. (That is, the autorequire relationship is not already present in the catalog.)

When Puppet is preparing to sync a resource whose type supports autorequire, it will search the catalog for any resources that match certain rules. If it finds any, it will process them _before_ that resource. If Puppet _doesn't_ find any resources that could be autorequired, that's fine; they won't be considered a failed dependency.

The [type reference][type] contains information on which types can autorequire other resources. Each type's description should state its autorequire behavior, if any. For an example, see the "Autorequires" section near the end of [the exec type][exec]'s description.

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

