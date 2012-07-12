---
layout: default
title: "Language: Resource Defaults"
---

<!-- TODO -->

[dynamic_scope]: 
[resource]: 
[definedtypes]: 
[sitemanifest]: 
[node]: 

Resource defaults let you set default attribute values for a given resource type. Any resource declaration within the area of effect that omits those attributes will inherit the default values.

Syntax
-----

{% highlight ruby %}
    Exec { 
      path        => '/usr/bin:/bin:/usr/sbin:/sbin',
      environment => 'RUBYLIB=/opt/puppet/lib/ruby/site_ruby/1.8/',
      logoutput   => true,
      timeout     => 180,
    }
{% endhighlight %}

The general form of resource defaults is:

* The resource type, capitalized. (If the type has a namespace separator (`::`) in its name, every segment must be capitalized. E.g., `Concat::Fragment`.)
* An opening curly brace.
* Any number of attribute and value pairs.
* A closing curly brace. 

You can specify defaults for any resource type in Puppet, including [defined types][definedtypes].

Area of Effect
-----

Resource defaults obey dynamic scope; [see here for a full description of scope rules][dynamic_scope]. 

You can declare global resource defaults in the [site manifest][sitemanifest] outside any [node definition][node].

Unlike dynamic variable lookup, dynamic scope for resource defaults is not deprecated in Puppet 2.7.

Overriding Defaults
-----

Attributes that are set explicitly in a resource declaration will always override any default value. 

Resource defaults declared in the local scope will override defaults from parent scopes. 

Overriding of resource defaults is **per attribute,** not per block of attributes. Thus, local and inherited resource defaults that don't conflict with each other will be merged together. 
