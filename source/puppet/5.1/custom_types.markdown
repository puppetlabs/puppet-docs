---
layout: default
title: Custom Types
---

[package_type]: /puppet/latest/type.html#package
[module]: /puppet/latest/modules_fundamentals.html
[custom_functions]: /puppet/latest/lang_write_functions_in_puppet.html
[custom_facts]: /facter/latest/custom_facts.html
[pluginsync]: /puppet/latest/configuration.html#pluginsync
[symbol]: http://www.ruby-doc.org/core/Symbol.html
[ruby_block]: http://www.robertsosinski.com/2008/12/21/understanding-ruby-blocks-procs-and-lambdas/
[markdown]: http://commonmark.org/
[metaparameters]: /puppet/latest/lang_resources.html#metaparameters
[inpage_whitespace]: #type-documentation
[namevar]: /puppet/latest//lang_resources.html#namenamevar

Custom Types
============

This page describes how to create your own custom resource types to add new resource types to Puppet. It covers the nature of the type/provider split, how to develop the type file, and how types and providers interact; for more complete details on developing providers, see [the Provider Development page](./provider_development.html).

Puppet types and providers must always be written in Ruby. If you're new to Ruby, what is going on should still be somewhat evident from the examples below, but some experience with Ruby is definitely recommended.

The internals of how types are created have changed over Puppet's lifetime, and this document will focus on best practices, skipping over all the things you can but probably shouldn't do.

> **Note:** Often the best way to learn types and providers is to read the existing type and providers in Puppet's core codebase. One warning: Don't start with the `file` type; start with `user` or `package` instead. New extension writers often expect that `file` would be a nice easy one to get started with, and it's actually an incredibly complicated morass of special cases that most types just don't have to deal with.
>
> User or package, not file.

Types and Providers
-------------------

When making a new Puppet type, you will create two things:

* The "type" itself, which is a model of the resource type. It defines what parameters are available, handles input validation, and determines what features a provider can (or should) provide.
* One or more providers for that type, which implements the type by translating its capabilities into specific operations on a system. (For example, the [package][package_type] has `yum` and `apt` providers which implement package resources on Red Hat-like and Debian-like systems, respectively.)

Deploying and Using Types and Providers
--------------

To use new types and providers, two conditions must be met:

1. The type and providers must be present in a [module][] on the puppet master server(s). Like other types of plugin (such as [custom functions][custom_functions] and [custom facts][custom_facts]), they should go in the module's `lib` directory:
    * Type files should be located at `lib/puppet/type/<TYPE NAME>.rb`.
    * Provider files should be located at `lib/puppet/provider/<TYPE NAME>/<PROVIDER NAME>.rb`.
2. If you are using an agent/master Puppet deployment, each agent node must have its [`pluginsync` setting][pluginsync] in puppet.conf set to `true`.
    * Starting in Puppet 3.0, this setting defaults to true.
    * In Puppet 2.x, it defaults to false and must be explicitly enabled.

In masterless Puppet using puppet apply, pluginsync is not required, but the module containing the type and providers must be present on each node.

See [the Plugins In Modules page](./plugins_in_modules.html) for more details on distributing custom types and facts via modules.


Types
-----

When defining the resource type, focus on what the resource can do,
not how it does it.

### Creating a Type

Types are created by calling the `newtype` method on the `Puppet::Type` class:

``` ruby
    # lib/puppet/type/database.rb
    Puppet::Type.newtype(:database) do
      @doc = "Create a new database."
      # ... the code ...
    end
```

* The name of the type is the only required argument to `newtype`. The name must be a [Ruby symbol][symbol], and the name of the file containing the type must match the type's name.
* The `newtype` method also requires a [block of code][ruby_block], specified with either curly braces (`{ ... }`) or the `do ... end` syntax. This code block will implement the type, and contains all of the properties and parameters. The block will not be passed any arguments.

> #### Options
>
> When creating a type, you can also specify options after the name. There is currently only one option available.
>
> Options must be specified as a hash, although Ruby method arguments allow you to leave the curly braces off of hashes.
>
> * `:self_refresh => true` --- Cause resources of this type to **refresh** (as if they had received an event via a notify/subscribe relationship) whenever a change is made to the resource. Most notably used in the core `mount` type.


### Type Documentation

You can and should write a string describing the resource type and assign it to the `@doc` instance variable. This string can be extracted by the `puppet doc --reference type` command (which outputs a complete type reference which will include your new type) and the `puppet describe` command (which outputs information about specific types).

The string should be in [Markdown][] format (avoiding dialect-specific features that aren't universally supported). When the Puppet tools extract the string, they will strip the greatest common amount of leading whitespace from the front of each line, excluding the first line. For example:

``` ruby
    Puppet::Type.newtype(:database) do
      @doc = %q{Creates a new database. Depending
        on the provider, this might create relational
        databases or NoSQL document stores.

        Example:

            database {'mydatabase':
              ensure => present,
              owner  => root,
            }
      }
    end
```

In this example, any whitespace would be trimmed from the first line (in this case, it's zero spaces), then the greatest common amount would be trimmed from remaining lines. Three lines have four leading spaces, two lines have six, and two lines have eight, so four leading spaces would be trimmed from each line. This leaves the example code block indented by four spaces, and thus doesn't break the Markdown formatting.

### Properties and Parameters

The bulk of a type consists of **properties** and **parameters.**

Both properties and parameters will become the resource attributes available when declaring a resource of the new type. The difference between the two is subtle but important:

* Properties should map more or less directly to something measurable on the target system. For example, the UID and GID of a user account would be properties, since their current state can be queried or changed. In practical terms, setting a value for a property causes a method to be called on the provider.
* Parameters change how Puppet manages a resource, but do not necessarily map directly to something measurable. For example, the `user` type's `managehome` attribute is a parameter --- its value affects what Puppet does, but the question of whether Puppet is managing a home directory isn't an innate property of the user account.

Additionally, there are a few special attributes called [metaparameters][], which are supported by all resource types. These don't need to be handled when creating new types; they're implemented elsewhere.

A normal type will define **multiple properties** and must define **at least one parameter.**


### Properties

Here's where we define how the resource really works. In most
cases, it's the properties that interact with your resource's
providers. If you define a property named owner, then when you are
retrieving the state of your resource, then the owner property will
call the owner method on the provider. In turn, when you are
setting the state (because the resource is out of sync), then the
owner property will call the owner= method to set the state on
disk.

There's one common exception to this: The ensure property is
special because it's used to create and destroy resources. You can
set this property up on your resource type just by calling the
ensurable method in your type definition:

``` ruby
    Puppet::Type.newtype(:database) do
      ensurable
      ...
    end
```

This property uses three methods on the provider: create, destroy,
and exists?. The last method, somewhat obviously, is a boolean to
determine if the resource current exists. If a resource's ensure
property is out of sync, then no other properties will be checked
or modified.

You can modify how ensure behaves, such as by adding other valid
values and determining what methods get called as a result; see
existing types like package for examples.

The rest of the properties are defined a lot like you define the
types, with the newproperty method, which should be called on the
type:

``` ruby
    Puppet::Type.newtype(:database) do
      ensurable
      newproperty(:owner) do
        desc "The owner of the database."
        ...
      end
    end
```

Note the call to desc; this sets the documentation string for this
property, and for Puppet types that get distributed with Puppet, it
is extracted as part of the Type reference.

When Puppet was first developed, there would normally be a lot of
code in this property definition. Now, however, you normally only
define valid values or set up validation and munging. If you
specify valid values, then Puppet will only accept those values,
and it will automatically handle accepting either strings or
symbols. In most cases, you only define allowed values for ensure,
but it works for other properties, too:

``` ruby
    newproperty(:enable) do
      newvalue(:true)
      newvalue(:false)
    end
```

You can attach code to the value definitions (this code would be
called instead of the property= method), but it's normally
unnecessary.

For most properties, though, it is sufficient to set up
validation:

``` ruby
    newproperty(:owner) do
      validate do |value|
        unless value =~ /^\w+/
          raise ArgumentError, "%s is not a valid user name" % value
        end
      end
    end
```

Note that the order in which you define your properties can be
important: Puppet keeps track of the definition order, and it
always checks and fixes properties in the order they are defined.

#### Customizing Behaviour

By default, if a property is assigned multiple values in an array:

* It is considered in sync if _any_ of those values matches the current
value.
* If none of those values match, the _first one_ will be used when syncing the property.

If, instead, the property should only be in sync if _all_
values match the current value (e.g., a list of times in a cron
job), you can declare this:

``` ruby
    newproperty(:minute, :array_matching => :all) do # :array_matching defaults to :first
      ...
    end
```

You can also customize how information about your property gets
logged. You can create an `is_to_s` method to change how the
current values are described, `should_to_s` to change how the
desired values are logged, and `change_to_s` to change the overall
log message for changes. See current types for examples.

#### Handling Property Values

Handling values set on properties is currently somewhat confusing,
and will hopefully be fixed in the future. When a resource is
created with a list of desired values, those values are stored in
each property in its @should instance variable. You can retrieve
those values directly by calling should on your resource (although
note that when `:array_matching` is set to `:first` you get the first
value in the array, otherwise you get the whole array):

``` ruby
    myval = should(:color)
```

When you're not sure (or don't care) whether you're dealing with a
property or parameter, it's best to use value:

``` ruby
    myvalue = value(:color)
```

### Parameters

Parameters are defined essentially exactly the same as properties;
the only difference between them is that parameters never result in
methods being called on providers.

To define a new parameter, call the `newparam` method. This method takes the name of the parameter (as a symbol) as its argument, as well as a block of code. You can and should provide documentation for each parameter by calling the `desc` method inside its block. Leading whitespace is trimmed from multiline strings [as described above][inpage_whitespace].

``` ruby
    newparam(:name) do
      desc "The name of the database."
    end
```

#### Namevar

Every type must have at least **one mandatory parameter:** the [**namevar.**][namevar] This parameter will uniquely identify each resource of the type on the target system --- for example, the path of a file on disk, the name of a user account, or the name of a package.

If the user doesn't specify a value for the namevar when declaring a resource, its value will default to the **title** of the resource.

There are three ways to designate a namevar. Every type must have **exactly one** parameter that meets **exactly one** of these criteria:

**Option 1:** Create a parameter whose name is `:name`. Since most types just use `:name` as the namevar, it gets special treatment and will automatically become the namevar.

``` ruby
    newparam(:name) do
      desc "The name of the database."
    end
```

**Option 2:** Provide the `:namevar => true` option as an additional argument to the `newparam` call. This allows you to use a namevar with a different, more descriptive name (such as the `file` type's `path` parameter).

``` ruby
    newparam(:path, :namevar => true) do
      ...
    end
```

**Option 3:** Call the `isnamevar` method (which takes no arguments) inside the parameter's code block. This allows you to use a namevar with a different, more descriptive name. There is no practical difference between this and option 2.

``` ruby
    newparam(:path) do
      isnamevar
      ...
    end
```

> ##### Errors When Namevar is Absent
>
> If you try to create a type that lacks a namevar, you'll see one of two errors when declaring resources of that type, depending on the Puppet version.
>
> **Puppet 2.7:**
>
>     $ puppet apply -e "testing { h: }"
>     Error: undefined method `merge' for []:Array
>
> **Puppet 3:**
>
>     $ puppet apply -e "testing { h: }"
>     Error: No set of title patterns matched the title "h".
>
> The fact that these are not particularly helpful is tracked as [issue 5220](http://projects.puppetlabs.com/issues/5220).

#### Specifying Allowed Values

If your parameter has a fixed list of valid values, you can declare
them all at once:

``` ruby
    newparam(:color) do
      newvalues(:red, :green, :blue, :purple)
    end
```

You can specify regexes in addition to literal values; matches
against regexes always happen after equality comparisons against
literal values, and those matches are not converted to symbols. For
instance, given the following definition:

``` ruby
    newparam(:color) do
      desc "Your color, and stuff."

      newvalues(:blue, :red, /.+/)
    end
```

If you provide blue as the value, then your parameter will get set
to :blue, but if you provide green, then it will get set to
"green".

#### Validation and Munging

If your parameter does not have a defined list of values, or you
need to convert the values in some way, you can use the validate
and munge hooks:

``` ruby
    newparam(:color) do
      desc "Your color, and stuff."

      newvalues(:blue, :red, /.+/)

      validate do |value|
        if value == "green"
          raise ArgumentError,
            "Everyone knows green databases don't have enough RAM"
        else
          super
        end
      end

      munge do |value|
        case value
        when :mauve, :violet # are these colors really any different?
          :purple
        else
          super
        end
      end
    end
```

The default validate method looks for values defined using
newvalues and if there are any values defined it accepts only those
values (this is exactly how allowed values are validated). The
default munge method converts any values that are specifically
allowed into symbols. If you override either of these methods, note
that you lose this value handling and symbol conversion, which
you'll have to call super for.

Values are always validated before they're munged.

Lastly, validation and munging *only\** happen when a value is
assigned. They have no role to play at all during use of a given
value, only during assignment.

#### Boolean Parameters

Boolean parameters are common.  To avoid repetition, some utilities are available:

``` ruby
    require 'puppet/parameter/boolean'
    # ...
    newparam(:force, :boolean => true, :parent => Puppet::Parameter::Boolean)
```

There are two parts here.  The `:parent => Puppet::Parameter::Boolean` part
configures the parameter to accept lots of names for true and false, to make
things easy for your users.  The `:boolean => true` creates a boolean method
on the type class to return the value of the parameter.  In this example, the
method would be named `force?`.

### Automatic Relationships

Your type can specify automatic relationships it can have with
resources. You can use autorequire, autobefore, autonotify, and
autosubscribe, which all require a resource type as an argument,
and your code should return a list of resource names that your
resource could be related to.

``` ruby
  autorequire(:user) do
      self[:user]
  end
```

Note that this won't throw an error if resources with those names
do not exist; the purpose of this hook is to make sure that if any
required resources are being managed, they get applied before the
requiring resource.


### Agent-Side Pre-Run Resource Validation (Puppet 3.7 and Later)

A resource can have prerequisites on the target, without which it cannot be synced. In some cases, if the absence of these prerequisites would be catastrophic, you might want to abort the whole catalog run if you detect a missing prerequisite.

In this situation, you can define a method in your type named `pre_run_check`. This method can do any check you want. It should take no arguments, and should raise a `Puppet::Error` if the catalog run should be aborted.

This method is **only available in Puppet 3.7 and later.** (In earlier versions of Puppet, adding a `pre_run_check` method will have no effect.)

If a `pre_run_check` method is present in the type, Puppet agent and Puppet apply will run the check for every resource of the type before attempting to apply the catalog. It will collect any errors raised, and present all of them before aborting the catalog run.

As a trivial example, here's a pre-run check that will fail randomly, about one time out of six:

``` ruby
    Puppet::Type.newtype(:thing) do
      newparam :name, :namevar => true

      def pre_run_check
        if(rand(6) == 0)
          raise Puppet::Error, "Puppet roulette failed, no catalog for you!"
        end
      end
    end
```


Providers
---------

Look at the [Provider Development](./provider_development.html)
page for intimate detail; this document will only
cover how the resource types and providers need to interact. Because
the properties call getter and setter methods on the providers,
except in the case of ensure, the providers must define getters and
setters for each property.

### Provider Features

Puppet allows you to
declare what features providers can have. The type declares the
features and what's required to make them work, and then the
providers can either be tested for whether they suffice or they can
declare that they have the features. Additionally, individual
properties and parameters in the type can declare that they require
one or more specific features, and Puppet will throw an error if
those parameters are used with providers missing those features:

``` ruby
    newtype(:coloring) do
      feature :paint, "The ability to paint.", :methods => [:paint]
      feature :draw, "The ability to draw."

      newparam(:color, :required_features => %w{paint}) do
        ...
      end
    end
```

The first argument to the feature method is the name of the
feature, the second argument is its description, and after that is
a hash of options that help Puppet determine whether the feature is
available. The only option currently supported is specifying one or
more methods that must be defined on the provider. If no methods
are specified, then the provider needs to specifically declare that
it has that feature:

``` ruby
    Puppet::Type.type(:coloring).provide(:drawer) do
      has_feature :draw
    end
```

The provider can specify multiple available features at once with
has\_features.

When you define features on your type, Puppet automatically defines
a bunch of class methods on the provider:

-   feature?: Passed a feature name, will return true if the
    feature is available or false otherwise.
-   features: Returns a list of all supported features on the
    provider.
-   satisfies?: Passed a list of feature, will return true if they
    are all available, false otherwise.

Additionally, each feature gets a separate boolean method, so the
above example would result in a paint? method on the provider.

