---
layout: default
title: "Overview of Facter Facts"
nav: facter2.html
---

Overview of Facts in Facter
===========================

## What is a fact?

Facter examines the system it's running on and returns what it finds as a set of **facts**. You can get the set of facts for a system by running `facter` at the command line, but it's most useful as an integrated part of Puppet. Within Puppet, facts are [top-scope](/puppet/3/reference/lang_scope.html#top-scope) variables that hold information about the puppet agent. For example, if the puppet agent node is a virtual machine running CentOS 6.4, the following facts (among many others) will be available:

  * $::operatingsystem = "CentOS"
  * $::operatingsystemrelease = "6.4"
  * $::osfamily = "redhat"
  * $::is_virtual = "true"

Facts are always strings. That includes facts like `$operatingsystemrelease` and `$is_virtual`, which look like other data types (float and boolean, respectively). If you want to do, say, numerical comparison or boolean logic using facts, you'll have to take additional steps to convert them first. Facter comes with a number of built-in **core facts**, but you can also write your own [custom facts](custom_facts.html).


## Flat and Structured Facts

There are two major categories of facts: flat and structured. **Flat facts** are those that return a single string corresponding to one piece of data, like all of the examples above. All facts were flat prior to Facter 2, and most core facts still are. You can refer to them in puppet manifests just like any other string variable:

{% highlight ruby %}
	
	# Interpolating flat facts
	notify { "This agent node is running $::operatingsystem version $::operatingsystemrelease": }

{% endhighlight %}

Flat facts are great when you have a neat one-to-one mapping between facts and strings, but they're not ideal for examining parts of the system that may have multiple parts. The classic example for this is IP addresses, since a node could have several of them. Earlier versions of Facter generated individual facts with unique suffixes for cases like this, but Facter 2 introduced **structured facts**. Now, all IP addresses are stored in a single fact that's structured like a whatnow?:


## Fact Locations



