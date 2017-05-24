---
layout: default
title: Using With Chef
disqus: true
canonical: "/mcollective/reference/integration/chef.html"
---
[FactsOpsCodeOhai]: http://code.google.com/p/mcollective-plugins/wiki/FactsOpsCodeOhai

# {{page.title}}

If you're a Chef user you are supported in both facts and classes filters.

## Facts
There is a [community plugin to enable Ohai][FactsOpsCodeOhai] as a fact source.

Using this plugin Ohai facts will be converted from:

{% highlight javascript %}
  "languages": {
    "java": {
      "runtime": {
        "name": "OpenJDK  Runtime Environment",
        "build": "1.6.0-b09"
      },
      "version": "1.6.0"
    },
{% endhighlight %}

to:

{% highlight ruby %}
 "languages.java.version"=>"1.6.0",
 "languages.java.runtime.name"=>"OpenJDK  Runtime Environment",
 "languages.java.runtime.build"=>"1.6.0-b09",
{% endhighlight %}

So you can use the flattened versions of the information provided by Ohai in filters, reports etc.

{% highlight console %}
% mco find --with-fact languages.java.version=1.6.0
{% endhighlight %}

## Class Filters
Chef does not provide a list of roles and recipes that has been applied to a node, to use with MCollective you need to create such a list.

It's very easy with Chef to do this in a simple cookbook.  Put the following code in a cookbook and arrange for it to run *last* on your node.

This will create a list of all roles and recipes in _/var/tmp/chefnode.txt_ on each node for us to use:

{% highlight ruby %}
ruby_block "store node data locally" do
  block do
    state = File.open("/var/tmp/chefnode.txt", "w")

    node.run_state[:seen_recipes].keys.each do |recipe|
        state.puts("recipe.#{recipe}")
    end

    node.run_list.roles.each do |role|
        state.puts("role.#{role}")
    end

    state.close
  end
end
{% endhighlight %}

You should configure MCollective to use this file by putting the following in your _server.cfg_

{% highlight ini %}
classesfile = /var/tmp/chefnode.txt
{% endhighlight %}

You can now use your roles and recipe lists in filters:

{% highlight console %}
% mco find --with-class role.webserver --with-class /apache/
{% endhighlight %}
