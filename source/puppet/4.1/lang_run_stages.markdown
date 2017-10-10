---
layout: default
title: "Language: Run Stages"
canonical: "/puppet/latest/lang_run_stages.html"
---

[metaparameter]: ./lang_resources.html#metaparameters
[ordering]: ./lang_relationships.html
[class]: ./lang_classes.html
[resourcelike]: ./lang_classes.html#using-resource-like-declarations
[containment]: ./lang_containment.html

Run stages are an additional way to order resources. They allow groups of classes to run before or after nearly everything else, without having to explicitly create relationships with every other class.

Run stages have [several major limitations](#limitations-and-known-issues); you should understand these before attempting to use them.

The run stage feature has two parts:

* A `stage` resource type.
* A `stage` [metaparameter][], which assigns a class to a named run stage.

The Default `main` Stage
-----

By default there is only one stage (named "`main`"). All resources are automatically associated with this stage unless explicitly assigned to a different one. If you do not use run stages, every resource is in the main stage.

Custom Stages
-----

Additional stages are declared as normal resources. Each additional stage must have an [order relationship][ordering] with another stage, such as `Stage['main']`. As with normal resources, these relationships can be specified with metaparameters or with chaining arrows.

~~~ ruby
    stage { 'first':
      before => Stage['main'],
    }
    stage { 'last': }
    Stage['main'] -> Stage['last']
~~~

In the above example, all classes assigned to the `first` stage will be applied before the classes associated with the `main` stage and both stages will be applied before the `last` stage.

Assigning Classes to Stages
-----

Once stages have been declared, a [class][] may be assigned to a custom stage with the `stage` metaparameter.

~~~ ruby
    class { 'apt-keys':
      stage => first,
    }
~~~

The above example will ensure that the `apt-keys` class happens before all other classes, which can be useful if most of your package resources rely on those keys.

In order to assign a class to a stage, you **must** use the [resource-like][resourcelike] class declaration syntax. You **cannot** assign classes to stages with the `include` function.

Limitations and Known Issues
-----

* You cannot assign a class to a run stage when declaring it with `include`.
* You cannot subscribe to or notify resources across a stage boundary.
* Classes that [contain][containment] other classes (with either the `contain` function or the anchor pattern) can sometimes behave badly if declared with a run stage --- if the contained class is **only** declared by its container, it will work fine, but if it is also declared anywhere outside its container, it will often create a dependency cycle that will prevent the involved classes from being applied.

Due to these limitations, **stages should only be used with the simplest of classes,** and only when absolutely necessary. Mass dependencies like package repositories are effectively the only valid use case.
