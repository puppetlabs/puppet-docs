---
layout: default
title: "Language: Resource default statements"
---

[sitemanifest]: ./dirs_manifest.html
[dynamic_scope]: ./lang_scope.html#scope-lookup-rules
[resource]: ./lang_resources.html
[definedtypes]: ./lang_defined_types.html
[node]: ./lang_node_definitions.html

Resource default statements let you set default attribute values for a given resource type. Any resource declaration within the area of effect that omits those attributes will inherit the default values.

## Syntax


``` puppet
Exec {
  path        => '/usr/bin:/bin:/usr/sbin:/sbin',
  environment => 'RUBYLIB=/opt/puppetlabs/puppet/lib/ruby/site_ruby/2.1.0/',
  logoutput   => true,
  timeout     => 180,
}
```

The general form of resource defaults is:

* The resource type, capitalized. (If the resource type has a namespace separator (`::`) in its name, every segment must be capitalized. E.g., `Concat::Fragment`.)
* An opening curly brace.
* Any number of attribute and value pairs.
* A closing curly brace.

You can specify defaults for any resource type in Puppet, including [defined types][definedtypes].

## Behavior


Within the [area of effect](#area-of-effect), every resource of the specified type that omits a given attribute will use that attribute's default value.

Attributes that are set explicitly in a resource declaration will always override any default value.

Resource defaults are **evaluation-order independent** --- that is, a default will affect resource declarations written both above and below it.

### Area of effect

Puppet uses dynamic scoping for resource defaults, even though it no longer uses dynamic _variable_ lookup. This means that if you use a resource default statement in a class, it has the potential to affect any classes or defined types that class declares.

Because of this, they should not be set outside of `site.pp`. You should [use per-resource default attributes](./lang_resources_advanced.html#per-expression-default-attributes) when possible.

### Overriding defaults from parent scopes

Resource defaults declared in the local scope will override any defaults received from parent scopes.

Overriding of resource defaults is **per attribute,** not per block of attributes. Thus, local and parent resource defaults that don't conflict with each other will be merged together.

