---
layout: default
title: Discovery Filters
disqus: true
canonical: "/mcollective/reference/ui/filters.html"
---

[FactPlugin]: /mcollective1.2/reference/plugins/facts.html

# {{page.title}}

 * TOC Placeholder
 {:toc}

Using filters to control discovery and addressing is a key concept in mcollective.
You can use facts, classes, agents and server identities in filters and combine
to narrow down what hosts you will affect.

To determine if your client support filters use the _--help_ option:


{% highlight console %}
$ mco rpc --help
.
.
.
Host Filters
    -W, --with FILTER                Combined classes and facts filter
    -F, --wf, --with-fact fact=val   Match hosts with a certain fact
    -C, --wc, --with-class CLASS     Match hosts with a certain config management class
    -A, --wa, --with-agent AGENT     Match hosts with a certain agent
    -I, --wi, --with-identity IDENT  Match hosts with a certain configured identity
{% endhighlight %}

If you see a section as above then the client supports filters, this is the default
for all clients using SimpleRPC.

All filters support Regular Expressions and some support comparisons like greater than
or less than.

Filters are applied in a combined manner, if you supply 5 filters they must all match
your nodes.

## Fact Filters

Filtering on facts require that you've correctly set up a [FactPlugin].  The examples below
show common fact filters.

Prior to version 1.2.0 the only fact filters that were supported were equality and regular
expressions.

Install the ZSH package on machines with the fact _country=de_:

{% highlight console %}
% mco rpc package install zsh -F country=de
{% endhighlight %}

Install the ZSH package on machines where the _country_ fact starts with the letter _d_:

{% highlight console %}
% mco rpc package install zsh -F country=/^d/
{% endhighlight %}

{% highlight console %}
% mco rpc package install zsh -F country=~^d
{% endhighlight %}

Install the ZSH package on machines with more than 2 CPUs, other available operators
include _==, &lt;=, &gt;=, &lt;, &gt;, !=_.  For facts where the comparison and the
actual fact is numeric it will do a numerical comparison else it wil do alphabetical:

{% highlight console %}
% mco rpc package install zsh -F "physicalprocessorcount>=2"
{% endhighlight %}

## Agent, Identity and Class filters

These filters all work on the same basic pattern, they just support equality or regular
expressions:

Install ZSH on machines with hostnames starting with _web_:

{% highlight console %}
% mco rpc package install zsh -I /^web/
{% endhighlight %}

Install ZSH on machines with hostnames _web1.example.com_:

{% highlight console %}
% mco rpc package install zsh -I web1.example.com
{% endhighlight %}

## Combining Fact and Class filters

As a short-hand you can combine Fact and Class filters into a single filter:

Install ZSH on machines in Germany that has classes matching _/apache/_:

{% highlight console %}
% mco rpc package install zsh -W "/apache/ country=de"
{% endhighlight %}

