---
layout: default
title: "The Puppet Ruby DSL"
---

[import]: ./lang_import.html
[manifest_setting]: /references/3.1.latest/configuration.html#manifest
[environments]: /guides/environment.html

The Puppet Ruby DSL provides you with access to the Puppet API, making it possible to express Puppet logic in Ruby. The newest version of Puppet's Ruby DSL, available in Puppet 3.1, is the result of a Google Summer of Code project that revamped existing Ruby DSL support. 

> The Puppet Ruby DSL and the proposed APIs are all experimental. Do not assume that the API or features in this document will be supported long term. 

## Using Puppet Ruby DSL Manifests

A Ruby file (.rb) may be used in place of any Puppet (.pp) manifest. Ruby code can function as:

- The site/entry point manifest (when [specifically configured](#site_or_entry_point_manifests))
- The init file for a module (`init.rb` instead of `init.pp`)
- Any manifest that would be autoloaded from a module (`baz.rb` instead of `baz.pp`)
- An [imported manifest][import].

## Site or Entry-Point Manifests

In order to use Puppet Ruby DSL files as the site (entry-point) manifest, you must change the [`manifest` setting][manifest_setting] in puppet.conf. By default, its value is `site.pp`, and you will need to change it to `site.rb` in the `[main]` block (as well as any [environments][] that specify their own manifest file). For instance, for the `main` block and a `development` environment:

{% highlight ini %}
[main]
  manifest=/etc/puppet/manifests/site.rb

[development]
  manifest=/etc/puppet/development/manifests/site.rb
{% endhighlight %}

## Conditional Logic

Conditional logic is handled using Ruby conditionals. There is no need to write conditional logic any other way.

## String Interpolation

The Puppet Ruby DSL uses Ruby string interpolation. Puppet variables are not automatically translated to Ruby variables; they must first be looked up, as described in ["Access to Puppet Variables"](./ruby_dsl_statements_expressions.html#access-to-puppet-variables). 

{% highlight ruby %}
scope["a_value"] = "something I want to say"
notify "this is #{scope["a_value"]}", :message=> "1 + 1 = #{1 + 1}"
{% endhighlight %}

## The "R"s : Rules, Responsibilities and Restrictions

Your Ruby logic will be running inside the Puppet engine, and there are things you should not do in your Ruby code; or at least where you need to be aware of the consequences:

- While it is certainly possible to get to any part of the Puppet runtime, and there are no restrictions in Ruby, none of the internal workings of the Puppet runtime are considered to be part of the public API. Only use interfaces that are clearly documented to be part of the public API.  If you're unsure of whether an interface is part of the public API, consult the YARD documentation in Puppet's source. 

- Puppet Ruby DSL code may not work as expected if conflicting copies of it exist in different [environments][], because unlike Puppet code, loaded Ruby code is the same for all environments. You need to view Puppet Ruby DSL code as part of the runtime.

- If you have written a Puppet Ruby DSL manifest that in itself is not changed between environments and have included or required other Ruby logic, such external logic could create a problem with your code. Things written in Ruby must be the same across all environments in use by one master. 

- Order of evaluation: Puppet performs lazy evaluation, so your instructions may not always be executed in the order you think.
You must also make sure you declare dependencies between resources: Puppet will not process resources in your Ruby manifests in the order they appear in the manifest. 

- There is no protection whatsoever in the Puppet Ruby DSL against modifying values that are considered immutable in the Puppet DSL. It is the user's responsibility to ensure that variables, arrays, and hashes obtained via the scope are not altered. As a consequence, use `+` to append to arrays since `<<` mutates. 

- The Puppet Ruby DSL and the proposed APIs are all experimental. Make no assumption that the API or features in this document will be supported long term. What and how things will change depends on feedback received from the user community. **Unlike other parts of Puppet, the Puppet Ruby DSL isn't limited by semantic versioning and may change in minor versions.**

<!-- Return to this: Eventually point to the published YARD pages -mph --> 

### Access to Parameters

Access to parameters in class definitions and defined resource types doesn't work exactly as it does in the Puppet language. In Puppet manifests, parameters act like normal local variables. In Ruby manifests, they must be accessed as `params[parameter_name]` and **do not** appear as normal variables (e.g. `scope[parameter_name]`). This may change in the future.

### Access to Variables

You can access variables using `scope[variable]`, but the Puppet Ruby DSL doesn't differentiate between variables that have not been defined or whose value is `nil`. 

<!-- Return to this:  How does this interact with variables set to `undef` in the Puppet DSL? Does undef translate to nil?  -->

In the future, the Puppet Ruby DSL may return a variable entry or `nil` to indicate whether a variable has not been defined, or if its actual value is nil or undefined.

### Access to All Variables

Examples show use of `scope.to_hash` to get all variables in scope. This may change in the future.

### Appending to a Variable

To append to a variable, use:

{% highlight ruby %}
scope.setvar("p", scope["p"] + value)
{% endhighlight %}

## New in the Puppet Ruby DSL

### Resource References

Given that Rtype is the name of a resource type, these are equivalent references to the same thing:

{% highlight ruby %}
rtype "name"
Rtype["name"]
type("rtype")["name"]
{% endhighlight %}

Here's how to avoid Ruby reserved names (like `File`):

{% highlight ruby %}
type("file")["name"] # works in Ruby 1.8 and Ruby 1.9
File["name"] # works in Ruby 1.9
{% endhighlight %}

### ruby_eval

The Puppet Ruby DSL strongly depends on `method_missing`. For Ruby 1.9 it uses `BasicObject`, and for Ruby 1.8 `Object`, with almost all methods undefined. If there is a need to call methods defined in `Object`, use the `#ruby_eval` method, which provides access to methods from `Object`.

Example:

{% highlight ruby %}
ruby_eval { puts "Hello" } # => nil, and printout
puts "Hello" # => NoMethodError
{% endhighlight %}

### Top Scope Statements

Users of the Puppet Ruby DSL prior to Puppet 3 should note that limitations regarding certain types of statements only being available in some nested scopes is now gone.

## Syntax and Examples

- [Puppet Ruby DSL statements and expressions](ruby_dsl_statements_expressions.html)
