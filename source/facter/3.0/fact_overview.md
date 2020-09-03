---
layout: default
title: "Facter 3.0: Overview of Custom Facts With Examples"
---


A typical Facter fact is a fairly simple assemblage of just a few different elements.
This page is an example-driven tour of those elements, and is intended as a quick primer or reference
for authors of custom facts. You'll need some familiarity with Ruby to understand most of these examples.
For a gentler introduction, check out the [Custom Facts Walkthrough](./custom_facts.html).

First off, it's important to distinguish between **facts** and **resolutions**. A fact is a piece of information about a given node,
while a resolution is a way of obtaining that information from the system. That means that every fact needs to have **at least one**
resolution, and facts that can run on different operating systems may need to have different resolutions for each one.

Even though facts and resolutions are conceptually very different, the line can get a bit blurry at times. That's because declaring a second
(or third, etc.) resolution for a fact looks just like declaring a completely new fact, only with the same name as an existing fact. You can see
what this looks like in this example: [different resolutions for different operating systems](#example-different-resolutions-for-different-operating-systems).

## Writing Facts with Simple Resolutions

Most facts are resolved all at once, without any need to merge data from different sources. In that case, the resolution is **simple**.
Both flat and structured facts can have simple resolutions.

### Example: Minimal Fact That Relies on a Single Shell Command

~~~ ruby
Facter.add(:rubypath) do
  setcode 'which ruby'
end
~~~

### Example: Different Resolutions for Different Operating Systems

~~~ ruby
Facter.add(:rubypath) do
  setcode 'which ruby'
end

Facter.add(:rubypath) do
  confine :osfamily => "Windows"
  # Windows uses 'where' instead of 'which'
  setcode 'where ruby'
end
~~~

### Example: Slightly More Complex Fact, Confined to Linux With a Block

~~~ ruby
Facter.add(:jruby_installed) do
  confine :kernel do |value|
    value == "Linux"
  end

  setcode do
    # If jruby is present, return true. Otherwise, return false.
    Facter::Core::Execution.which('jruby') != nil
  end
end
~~~

### Main Components of Simple Resolutions

Simple facts are typically made up of the following parts:

1. A call to `Facter.add(:fact_name)`:
    * This introduces a new fact *or* a new resolution for an existing fact with the same name.
    * The name can be either a symbol or a string.
    * You can optionally pass `:type => :simple` as a parameter, but it will have no effect since that's already the default.
    * The rest of the fact is wrapped in the `add` call's `do ... end` block.
2. Zero or more `confine` statements:
    * These determine whether the resolution is suitable (and therefore will be evaluated).
    * They can either match against the value of another fact or evaluate a Ruby block.
    * If given a symbol or string representing a fact name, a block is required and the block will receive the fact's value as an argument.
    * If given a hash, the keys are expected to be fact names. The values of the hash are either the expected fact values or an array of values to compare against.
    * If given a block, the confine is suitable if the block returns a value other than `nil` or `false`.
3. An optional `has_weight` statement:
    * When multiple resolutions are available for a fact, resolutions will be evaluated from highest weight value to lowest.
    * It must be an integer greater than 0.
    * The weight defaults to the number of `confine` statements for the resolution.
4. A `setcode` statement that determines the value of the fact:
    * It can take either a string or a block.
    * If given a string, Facter will execute it as a shell command. If the command succeeds, the output of the command will be the value of the fact. If the command fails, the next suitable resolution will be evaluated.
    * If given a block, the block's return value will be the value of the fact unless the block returns `nil`. If `nil` is returned, the next suitable resolution will be evalutated.
    * To execute shell commands within a `setcode` block, use the `Facter::Core::Execution.exec` function.
    * If multiple `setcode` statements are evaluated for a single resolution, only the last `setcode` block will be used.

## Writing Structured Facts

Facter 2.0 introduced **structured facts**, which can take the form of hashes or arrays. You don't have to do anything special to mark the fact as structured --- if your fact returns a hash or array, Facter will recognize it as a structured fact. Structured facts can have [simple](#main-components-of-simple-resolutions) or [aggregate resolutions](#main-components-of-aggregate-resolutions).

> **Note:** Structured facts are supported in Puppet 3.3 and greater, but they aren't enabled by default. To enable structured facts, set the [stringify_facts](/puppet/latest/reference/configuration.html#stringifyfacts) option to `false` in the `[main]` section of puppet.conf on all machines, whether they are agents, masters, or standalone nodes running `puppet apply`.
>
> Puppet Enterprise 3.7 and later has structured facts enabled by default, as will Puppet 4.0.

### Example: Returning an Array of Network Interfaces

~~~ ruby
Facter.add(:interfaces_array) do
  setcode do
   interfaces = Facter.value(:interfaces)
   # the 'interfaces' fact returns a single comma-delimited string, e.g., "lo0,eth0,eth1"
   # this splits the value into an array of interface names
   interfaces.split(',')
  end
end
~~~

### Example: Returning a Hash of Network Interfaces to IP Addresses

~~~ ruby
Facter.add(:interfaces_hash) do
  setcode do
    interfaces_hash = {}

    Facter.value(:interfaces_array).each do |interface|
      ipaddress = Facter.value("ipaddress_#{interface}")
      if ipaddress
        interfaces_hash[interface] = ipaddress
      end
    end

    interfaces_hash
  end
end
~~~

## Writing Facts with Aggregate Resolutions

Aggregate resolutions allow you to split up the resolution of a fact into separate chunks.
By default, Facter will merge hashes with hashes or arrays with arrays, resulting in a
[structured fact](#writing-structured-facts), but you can also aggregate the chunks into a flat fact
using concatenation, addition, or any other function that you can express in Ruby code.

### Example: building a structured fact progressively

~~~ ruby
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
  # automatically, so there's no aggregate statement.
end
~~~

### Example: Building a Flat Fact Progressively With Addition

~~~ ruby
Facter.add(:total_free_memory_mb, :type => :aggregate) do
  chunk(:physical_memory) do
    Facter.value(:memoryfree_mb)
  end

  chunk(:virtual_memory) do
    Facter.value(:swapfree_mb)
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
~~~

### Main Components of Aggregate Resolutions

Aggregate resolutions have two key differences compared to simple resolutions: the presence of `chunk` statements and the lack of a `setcode` statement. The `aggregate` block is optional, and without it Facter will merge hashes with hashes or arrays with arrays.

1. A call to `Facter.add(:fact_name, :type => :aggregate)`:
    * This introduces a new fact *or* a new resolution for an existing fact with the same name.
    * The name can be either a symbol or a string.
    * The `:type => :aggregate` parameter is required for aggregate resolutions.
    * The rest of the fact is wrapped in the `add` call's `do ... end` block.
2. Zero or more `confine` statements:
    * These determine whether the resolution is suitable and (therefore will be evaluated).
    * They can either match against the value of another fact or evaluate a Ruby block.
    * If given a symbol or string representing a fact name, a block is required and the block will receive the fact's value as an argument.
    * If given a hash, the keys are expected to be fact names. The values of the hash are either the expected fact values or an array of values to compare against.
    * If given a block, the confine is suitable if the block returns a value other than `nil` or `false`.
3. An optional `has_weight` statement:
    * When multiple resolutions are available for a fact, resolutions will be evaluated from highest weight value to lowest.
    * It must be an integer greater than 0.
    * The weight defaults to the number of `confine` statements for the resolution.
4. One or more calls to `chunk`, each containing:
    * A name (as the argument to `chunk`).
    * A block of code, which is responsible for resolving the chunk to a value. The block's return value will be the value of the chunk; it can be any type, but is typically a hash or array.
5. An optional `aggregate` block:
    * If this is absent, Facter will automatically merge hashes with hashes or arrays with arrays.
    * If you want to merge the chunks in any other way, you'll need to make a call to `aggregate`, which takes a block of code.
    * The block is passed one argument (`chunks`, in the example), which is a hash of chunk name to chunk value for all the chunks in the resolution.
