---
layout: default
title: "Facter 2.0: Overview of Custom Facts With Examples"
---

Anatomy of a Facter Fact
========================

A typical Facter fact is a fairly simple assemblage of just a few different elements.
This page is an example-driven tour of those elements, and is intended as a quick primer or reference
for authors of custom facts. You'll need some familiarity with Ruby to understand most of these examples.
For a gentler introduction, check out the [Custom Facts Walkthrough](custom_facts.html).

>**Note:** If you're using any part of the Facter API, you'll need to add `require 'facter'` to the top of your source file. We'll omit it for the examples on this page to focus on more important details.

First off, it's important to distinguish between **facts** and **resolutions**. A fact is a piece of information about a given node,
while a resolution is a way of obtaining that information from the system. That means that every fact needs to have **at least one**
resolution, and facts that can run on different operating systems may need to have different resolutions for each one.

Even though facts and resolutions are conceptually very different, the line can get a bit blurry at times. That's because declaring a second
(or third, etc.) resolution for a fact looks just like declaring a completely new fact, only with the same name as an existing fact, as
you can see in this example: [different resolutions for different operating systems](#example-different-resolutions-for-different-operating-systems).

## Writing Facts with Simple Resolutions

Most facts are resolved all at once, without any need to merge data from different sources. In that case, the resolution is **simple**.
Both flat and structured facts can have simple resolutions.

### Example: minimal fact that relies on a single shell command

{% highlight ruby %}
Facter.add(:rubypath) do
  setcode 'which ruby'
end
{% endhighlight %}

### Example: slightly more complex fact, confined to Linux

{% highlight ruby %}
Facter.add(:jruby_installed) do

  confine :kernel => "Linux"

  setcode do
    jruby_path = Facter::Core::Execution.exec('which jruby')
    # if 'which jruby' exits with an error, jruby_path will be an empty string
    if jruby_path == ""
      false
    else
      true
    end
  end
end
{% endhighlight %}

### Example: different resolutions for different operating systems

{% highlight ruby %}
Facter.add(:rubypath) do
  setcode 'which ruby'
end

Facter.add(:rubypath) do
  confine :osfamily => "Windows"
  # Windows uses 'where' instead of 'which'
  setcode 'where ruby'
end
{% endhighlight %}

### Main Components of Simple Resolutions

Simple facts are typically made up of the following parts:

  1. A call to `Facter.add(:fact_name)`
     * introduces a new fact *or* a new resolution for an existing fact
     * the name can be either a symbol or a string
     * you can optionally pass `:type => :simple` as a parameter, but it will have no effect since that's already the default
     * the rest of the fact is wrapped in the constructor's `do ... end` block
  2. Zero or more `confine` statements
     * determines whether the fact/resolution will be executed
     * can either match against the value of another fact or evaluate an arbitrary Ruby expression/block
  3. An optional `has_weight` statement
     * when multiple resolutions are available, the one with the highest weight will be executed and the rest will be ignored
     * must be an integer greater than 0
     * defaults to the number of `confine` statements for the resolution
  4. A `setcode` statement that determines the value of the fact
     * can take either a string or a block
     * if given a string, Facter will execute it as a shell command and the output will be the value of the fact
     * if given a block, the block's return value will be the value of the fact
     * to execute shell commands within a `setcode` block, use the `Facter::Core::Execution.exec` function
     * if multiple `setcode` statements are evaluated for a single fact, Facter will only retain the newest value

## Writing Structured Facts

Facter 2.0 introduced **structured facts**, which can take the form of hashes or arrays. You don't have to do anything special to mark the fact as structured --- if your fact returns a hash or array, Facter will recognize it as a structured fact. Structured facts can have [simple](#main_components_of_simple_resolutions) or [aggregate resolutions](#main_components_of_aggregate_resolutions).

### Example: returning an array of network interfaces
{% highlight ruby %}
Facter.add(:interfaces_array) do
  setcode do
   interfaces = Facter.value(:interfaces)
   # the 'interfaces' fact returns a single comma-delimited string, e.g., "lo0,eth0,eth1"
   interfaces_array = interfaces.split(',')
   interfaces_array
  end
end
{% endhighlight %}

### Example: returning a hash of IP addresses
{% highlight ruby %}
Facter.add(:interfaces_hash) do
  setcode do
    interfaces_array = Facter.value(:interfaces_array)
    interfaces_hash = {}

    interfaces_array.each do |interface|
      ipaddress = Facter.value("ipaddress_#{interface}")
      if ipaddress
        interfaces_hash[interface] = ipaddress
      end
    end

    interfaces_hash
  end
end
{% endhighlight %}

## Writing Facts with Aggregate Resolutions

Aggregate resolutions allow you to split up the resolution of a fact into separate chunks. 
By default, Facter will merge hashes with hashes or arrays with arrays, resulting in a 
[structured fact](#structured_facts), but you can also aggregate the chunks into a flat fact 
using concatenation, summation, or any other method that you can express in Ruby code.

### Example: building a structured fact progressively

{% highlight ruby %}
Facter.add(:networking, :type => :aggregate) do

  confine :kernel => "Linux"

  chunk(:macaddrs) do
    interfaces = {}

    Sysfs.net_devs.each do |dev|
      interfaces[dev.name] = {
        'macaddr' => dev.macaddr,
        'macbrd'  => dev.macbrd,
      }
    end

    interfaces
  end

  chunk(:ipv4) do
    interfaces = {}
    Facter::Util::IP.get_interfaces.each do |interface|
      interfaces[interface] = {
        'ipaddress' => Facter::Util::IP.get_ipaddress_value(interface),
        'netmask'   => Facter::Util::IP.get_netmask_value(interface),
      }
    end

    interfaces
  end
  # Facter will merge the return values for the two chunks 
  # automatically, so there's no setcode statement.
end
{% endhighlight %}

### Example: building a flat fact progressively with addition

{% highlight ruby %}
Facter.add(:total_free_memory_mb, :type => :aggregate) do
  chunk(:physical_memory) do
    Facter.value(:memoryfree_mb).to_i
    # The 'memoryfree_mb' fact returns the number of megabytes of free memory as a string.
  end

  chunk(:virtual_memory) do
    Facter.value(:swapfree_mb).to_i
    # The 'swapfree_mb' fact returns the number of megabytes of free swap as a string.
  end
  
  aggregate do |chunks|
    # The return value for this block will determine the value of the fact.
    sum = 0
    chunks.each_value do |i|
      sum += i
    end
    
    sum
  end
end
{% endhighlight %}

### Main Components of Aggregate Resolutions

Aggregate resolutions have two key differences compared to simple resolutions: the presence of `chunk` statements and the lack of a `setcode` statement. The `aggregate` block is optional, and without it Facter will merge hashes with hashes or arrays with arrays.

  1. A call to `Facter.add(:fact_name, :type => :aggregate)`
     * introduces a new fact *or* a new resolution for an existing fact
     * the name can be either a symbol or a string
     * the `:type => :aggregate` parameter is required for aggregate resolutions
     * the rest of the fact is wrapped in the constructor's `do ... end` block
  2. Zero or more `confine` statements
     * determines whether the fact/resolution will be executed
     * can either match against the value of another fact or evaluate an arbitrary Ruby expression/block
  3. An optional `has_weight` statement
     * when multiple resolutions are available, the one with the highest weight will be executed and the rest will be ignored
     * defaults to the number of `confine` statements for the resolution
  4. One or more `chunk` blocks, each containing:
     * a name parameter (used only for internal organization)
     * some amount of code for (partially) resolving the fact
     * a return value (any type, but typically a hash or array)
  5. An optional `aggregate` block
     * if absent, Facter will merge hashes with hashes or arrays with arrays
     * if you want to merge the chunks in any other way, you'll need to specify it here
     * the `chunks` object contains the return values for all of the chunks in the resolution
