---
layout: default
title: Custom Types
---

Custom Types
============

Learn how to create your own custom types & providers in Puppet

* * *

Organizational Principles
-------------------------

When creating a new Puppet type, you will be create two things:
The resource type itself, which we normally just call a
'type', and the provider(s) for that type.  While Puppet does not require
Ruby experience to use, extending Puppet with new Puppet types and providers does require some knowledge of the Ruby programming language, as is the case with
new functions and facts.   If you're new to Ruby, what is going on should
still be somewhat evident from the examples below, and it is easy to learn.

The resource types provide the model for what you can do; they define
what parameters are present, handle input validation, and they
determine what features a provider can (or should) provide.

The providers implement support for that type by translating calls
in the resource type to operations on the system.  As mentioned
in our [Introduction](./introduction.html) and [language guide](./language_guide.html), an example would be
that "yum" and "apt" are both different providers that fulfill
the "package" type.

Deploying Code
--------------

Once you have your code, you will need to have it both on the
server and also distributed to clients.

The best place to put this content is within Puppet's configured `libdir`. The libdir is special because you can use the `pluginsync` system to copy all of your plugins from the fileserver to all of your clients (and seperate Puppetmasters, if they exist)). To enable pluginsync, set `pluginsync=true` in puppet.conf and, if necessary, set the `pluginsource` setting. The contents of pluginsource
will be copied directly into `libdir`, so make sure you make a
puppet/type directory in your `pluginsource`, too.

In Puppet 0.24 and later, the "old" `pluginsync` function has been
deprecated and you should see the [Plugins In Modules](./plugins_in_modules.html) page for details of distributing custom types and facts via modules.

The internals of how types are created have changed over Puppet's
lifetime, and this document will focus on best practices, skipping over all the things you can but probably shouldn't do.

Resource Types
--------------

When defining the resource type, focus on what the resource can do,
not how it does it (that is the job for providers!).

The first thing you have to figure out is what `properties` the resource has. Properties are the changeable bits, like a file's owner or a user's UID.

After adding properties, Then you need to add any other necessary `parameters`, which can affect how the resource behaves but do not directly manage the resource itself. Parameters handle things like whether to recurse when managing files or where to look for service init scripts.

Resource types also support special parameters, called `MetaParameters`, that are supported by all resource types, but you can safely ignore these since they are already defined and you won't normally add more.  You may remember that things like `require` are metaparameters.

Types are created by calling the `newtype` method on `Puppet::Type`,
with the name of the type as the only required argument.  You can
optionally specify a parent class; otherwise, `Puppet::Type` is used
as the parent class.  You must also provide a block of code
used to define the type:

You may wish to read up on "Ruby blocks" to understand more about
the syntax.  Blocks are a very powerful feature of Ruby and are
not surfaced in most programming languages.

    Puppet::Type.newtype(:database) do
        @doc = "Create a new database."
        ... the code ...
    end

The above code should be stored in puppet/type/database.rb (within the `libpath`), because of the name of the type we're creating ("database").

A normal type will define multiple properties and possibly
some parameters. Once these are defined, as long as the type is put into
lib/puppet/type anywhere in Ruby's search path, Puppet will
autoload the type when you reference it in the Puppet language.

We have already mentioned Puppet provides a `libdir` setting where you can copy the files outside the Ruby search path.  See also [Plugins In Modules](./plugins_in_modules.html)

All types should also provide inline documention in the @doc class
instance variable. The text format is in Restructured Text.

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

    Puppet::Type.newtype(:database) do
        ensurable
        ...
    end

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

    Puppet::Type.newtype(:database) do
        ensurable
        newproperty(:owner) do
            desc "The owner of the database."
            ...
        end
    end

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

    newproperty(:enable) do
        newvalue(:true)
        newvalue(:false)
    end

You can attach code to the value definitions (this code would be
called instead of the property= method), but it's normally
unnecessary.

For most properties, though, it is sufficient to set up
validation:

    newproperty(:owner) do
        validate do |value|
            unless value =~ /^\w+/
                raise ArgumentError, "%s is not a valid user name" % value
            end
        end
    end

Note that the order in which you define your properties can be
important: Puppet keeps track of the definition order, and it
always checks and fixes properties in the order they are defined.

#### Customizing Behaviour

By default, if a property is assigned multiple values in an array,
it is considered in sync if any of those values matches the current
value. If, instead, the property should only be in sync if all
values match the current value (e.g., a list of times in a cron
job), you can declare this:

    newproperty(:minute, :array_matching => :all) do # defaults to :first
        ...
    end

You can also customize how information about your property gets
logged. You can create an is\_to\_s method to change how the
current values are described, should\_to\_s to change how the
desired values are logged, and change\_to\_s to change the overall
log message for changes. See current types for examples.

#### Handling Property Values

Handling values set on properties is currently somewhat confusing,
and will hopefully be fixed in the future. When a resource is
created with a list of desired values, those values are stored in
each property in its @should instance variable. You can retrieve
those values directly by calling should on your resource (although
note that when array\_matching is set to first you get the first
value in the array, otherwise you get the whole array):

    myval = should(:color)

When you're not sure (or don't care) whether you're dealing with a
property or parameter, it's best to use value:

    myvalue = value(:color)

### Parameters

Parameters are defined essentially exactly the same as properties;
the only difference between them is that parameters never result in
methods being called on providers.

Like ensure, one parameter you will always want to define is the
one used for naming the resource. This is nearly always called
name:

    newparam(:name) do
        desc "The name of the database."
    end

You can name your naming parameter something else, but you must
declare it as the namevar:

    newparam(:path, :namevar => true) do
        ...
    end

In this case, path and name are both accepted by Puppet, and it
treats them equivalently.

If your parameter has a fixed list of valid values, you can declare
them all at once:

    newparam(:color) do
        newvalues(:red, :green, :blue, :purple)
    end

You can specify regexes in addition to literal values; matches
against regexes always happen after equality comparisons against
literal values, and those matches are not converted to symbols. For
instance, given the following definition:

    newparam(:color) do
        desc "Your color, and stuff."

        newvalues(:blue, :red, /.+/)
    end

If you provide blue as the value, then your parameter will get set
to :blue, but if you provide green, then it will get set to
"green".

#### Validation and Munging

If your parameter does not have a defined list of values, or you
need to convert the values in some way, you can use the validate
and munge hooks:

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

### Automatic Relationships

Your type can specify automatic relationships it can have with
resources. You use the autorequire hook, which requires a resource
type as an argument, and your code should return a list of resource
names that your resource could be related to:

    autorequire(:file) do
      ["/tmp", "/dev"]
    end

Note that this won't throw an error if resources with those names
do not exist; the purpose of this hook is to make sure that if any
required resources are being managed, they get applied before the
requiring resource.

Providers
---------

Look at the [Provider Development](./provider_development.html)
page for intimate detail; this document will only
cover how the resource types and providers need to interact.Because
the properties call getter and setter methods on the providers,
except in the case of ensure, the providers must define getters and
setters for each property.

### Provider Features

A recent development in Puppet (around 0.22.3) is the ability to
declare what features providers can have. The type declares the
features and what's required to make them work, and then the
providers can either be tested for whether they suffice or they can
declare that they have the features. Additionally, individual
properties and parameters in the type can declare that they require
one or more specific features, and Puppet will throw an error if
those prameters are used with providers missing those features:

    newtype(:coloring) do
        feature :paint, "The ability to paint.", :methods => [:paint]
        feature :draw, "The ability to draw."

        newparam(:color, :required_features => %w{paint}) do
            ...
        end
    end

The first argument to the feature method is the name of the
feature, the second argument is its description, and after that is
a hash of options that help Puppet determine whether the feature is
available. The only option currently supported is specifying one or
more methods that must be defined on the provider. If no methods
are specified, then the provider needs to specifically declare that
it has that feature:

    Puppet::Type.type(:coloring).provide(:drawer) do
        has_feature :draw
    end

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

