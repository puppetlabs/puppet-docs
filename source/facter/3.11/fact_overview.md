---
layout: default
title: "Writing custom facts"
---

A typical fact in Facter is an assemblage of a few different elements and composed either
as a simple value ("flat" fact) or structured data ("structured" fact). 

This page shows you how to write and format facts correctly.

>Note: It's important to distinguish between **facts** and **resolutions**. A fact is a piece of information about a given node, while a resolution is a way of obtaining that information from the system. That means every fact needs to have **at least one** resolution, and facts that can run on different operating systems may need to have different resolutions for each one. Facts and resolutions are conceptually different, but have similarities. Declaring a second (or more) resolution for a fact looks just like declaring a completely new fact, only with the same name as an existing fact.

You need some familiarity with Ruby to understand most of these examples. For an introduction to custom facts, see the [Custom facts overview](./custom_facts.html).

## Writing facts with simple resolutions

Most facts are resolved all at once, without any need to merge data from different sources. In that case, the resolution is simple. Both flat and structured facts can have simple resolutions.

### Main components of facts with simple resolutions

Facts are typically made up of the following parts:

1. A call to `Facter.add(:fact_name)`:
    * This introduces a new fact *or* a new resolution for an existing fact with the same name.
    * The name can be either a symbol or a string.
    * The rest of the fact is wrapped in the `add` call's `do ... end` block.
2. Zero or more `confine` statements:
    * Determine whether the resolution is suitable (and therefore is evaluated).
    * Can either match against the value of another fact or evaluate a Ruby block.
    * If given a symbol or string representing a fact name, a block is required and the block receives the fact's value as an argument.
    * If given a hash, the keys are expected to be fact names. The values of the hash are either the expected fact values or an array of values to compare against.
    * If given a block, the confine is suitable if the block returns a value other than `nil` or `false`.
3. An optional `has_weight` statement:
    * When multiple resolutions are available for a fact, resolutions are evaluated from highest weight value to lowest.
    * Must be an integer greater than 0.
    * Defaults to the number of `confine` statements for the resolution.
4. A `setcode` statement that determines the value of the fact:
    * Can take either a string or a block.
    * If given a string, Facter executes it as a shell command. If the command succeeds, the output of the command is the value of the fact. If the command fails, the next suitable resolution is evaluated.
    * If given a block, the block's return value is the value of the fact unless the block returns `nil`. If `nil` is returned, the next suitable resolution is evalutated.
    * Can execute shell commands within a `setcode` block, using the `Facter::Core::Execution.exec` function.
    * If multiple `setcode` statements are evaluated for a single resolution, only the last `setcode` block is used. 

Set all code inside the sections outlined above ⁠— there should not be any code outside `setcode` and `confine` blocks other than an optional `has_weight` statement in a custom fact. 


### How to format facts

The format of a fact is important because of the way that Factor evaluates them — by reading *all* the fact definitions. If formatted incorrectly, Facter can execute code too early. You need to use the `setcode` correctly. Below is a *good* example and a *bad* example of a fact, showing you where to place the `setcode`. 

Good: 

```
Facter.add('phi') do
  confine :owner => "BTO"
  confine :kernel do |value|
    value == "Linux"
  end
 
  setcode do
    bar=Facter.value('theta')
    bar + 1
  end
end
```

In this example, the `bar=Facter.value('theta')` call is guarded by `setcode`, which means it won't be executed unless or until it is appropriate to do so. Facter will load all `Facter.add` blocks first, use any OS or confine/weight information to decide which facts to evaluate, and once it chooses, it will selectively execute `setcode` blocks for each fact that it needs.

Bad: 

```
Facter.add('phi') do
  confine :owner => "BTO"
  confine :kernel do |value|
    value == "Linux"
  end
  
  bar = Facter.value('theta')
 
  setcode do
    bar + 1
  end
end
```

In this example, the `Facter.value('theta')` call is outside of the guarded `setcode` block and in the unguarded part of the `Facter.add` block. This means that the statement will always execute, on every system, regardless of confine, weight, or which resolution of `phi` is appropriate. Any code with possible side-effects, or code pertaining to figuring out the value of a fact, should be kept inside the setcode block. The only code left outside `setcode` is code that helps Facter choose which resolution of a fact to use.

### Examples

The following example shows a minimal fact that relies on a single shell command:

``` ruby
Facter.add(:rubypath) do
  setcode 'which ruby'
end
```

The following example shows different resolutions for different operating systems:

``` ruby
Facter.add(:rubypath) do
  setcode 'which ruby'
end

Facter.add(:rubypath) do
  confine :osfamily => "Windows"
  # Windows uses 'where' instead of 'which'
  setcode 'where ruby'
end
```

The following example shows a more complex fact, confined to Linux with a block:

``` ruby
Facter.add(:jruby_installed) do
  confine :kernel do |value|
    value == "Linux"
  end

  setcode do
    # If jruby is present, return true. Otherwise, return false.
    Facter::Core::Execution.which('jruby') != nil
  end
end
```

## Writing structured facts

Structured facts can take the form of hashes or arrays. You don't have to do anything special to mark the fact as structured --- if your fact returns a hash or array, Facter recognizes it as a structured fact. Structured facts can have [simple](#main-components-of-simple-resolutions) or [aggregate resolutions](#main-components-of-aggregate-resolutions).

#### Examples

An example of a fact returning an array of network interfaces:

``` ruby
Facter.add(:interfaces_array) do
  setcode do
   interfaces = Facter.value(:interfaces)
   # the 'interfaces' fact returns a single comma-delimited string, such as "lo0,eth0,eth1"
   # this splits the value into an array of interface names
   interfaces.split(',')
  end
end
```

An example of a fact returning a hash of network interfaces to IP addresses:

``` ruby
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
```

## Writing facts with aggregate resolutions

Aggregate resolutions allow you to split up the resolution of a fact into separate chunks. By default, Facter merges hashes with hashes or arrays with arrays, resulting in a [structured fact](#writing-structured-facts), but you can also aggregate the chunks into a flat fact using concatenation, addition, or any other function that you can express in Ruby code.

### Main components of aggregate resolutions

Aggregate resolutions have two key differences compared to simple resolutions: the presence of `chunk` statements and the lack of a `setcode` statement. The `aggregate` block is optional, and without it Facter merges hashes with hashes or arrays with arrays.

1. A call to `Facter.add(:fact_name, :type => :aggregate)`:
    * Introduces a new fact *or* a new resolution for an existing fact with the same name.
    * The name can be either a symbol or a string.
    * The `:type => :aggregate` parameter is required for aggregate resolutions.
    * The rest of the fact is wrapped in the `add` call's `do ... end` block.
2. Zero or more `confine` statements:
    * Determine whether the resolution is suitable and (therefore is evaluated).
    * They can either match against the value of another fact or evaluate a Ruby block.
    * If given a symbol or string representing a fact name, a block is required and the block receives the fact's value as an argument.
    * If given a hash, the keys are expected to be fact names. The values of the hash are either the expected fact values or an array of values to compare against.
    * If given a block, the confine is suitable if the block returns a value other than `nil` or `false`.
3. An optional `has_weight` statement:
    * Evaluates multiple resolutions for a fact from highest weight value to lowest.
    * Must be an integer greater than 0.
    * Defaults to the number of `confine` statements for the resolution.
4. One or more calls to `chunk`, each containing:
    * A name (as the argument to `chunk`).
    * A block of code, which is responsible for resolving the chunk to a value. The block's return value is the value of the chunk; it can be any type, but is typically a hash or array.
5. An optional `aggregate` block:
    * If absent, Facter automatically merges hashes with hashes or arrays with arrays.
    * To merge the chunks in any other way, you need to make a call to `aggregate`, which takes a block of code.
    * The block is passed one argument (`chunks`, in the example), which is a hash of chunk name to chunk value for all the chunks in the resolution.

#### Examples

The following example builds a new fact, `networking_primary_sha`, by progressively merging two chunks. One chunk encodes each networking interface's MAC address as an encoded base64 value, and the other determines if each interface is the system's primary interface.

``` ruby
require 'digest'
require 'base64'

Facter.add(:networking_primary_sha, :type => :aggregate) do

  chunk(:sha256) do
    interfaces = {}

    Facter.value(:networking)['interfaces'].each do |interface, values|
      if values['mac']
        hash = Digest::SHA256.digest(values['mac'])
        encoded = Base64.encode64(hash)
        interfaces[interface] = {:mac_sha256 => encoded.strip}
      end
    end

    interfaces
  end

  chunk(:primary?) do
    interfaces = {}

    Facter.value(:networking)['interfaces'].each do |interface, values|
      interfaces[interface] = {:primary? => (interface == Facter.value(:networking)['primary'])}
    end

    interfaces
  end
  # Facter merges the return values for the two chunks
  # automatically, so there's no aggregate statement.
end
```

The fact's output is organized by network interface into hashes, each containing the two chunks:

``` ruby
{
  bridge0 => {
    mac_sha256 => "bfgEFV7m1V04HYU6UqzoNoVmnPIEKWRSUOU650j0Wkk=",
    primary?   => false
  },
  en0 => {
    mac_sha256 => "6Fd3Ws2z+aIl8vNmClCbzxiO2TddyFBChMlIU+QB28c=",
    primary?   => true
  },
  ...
}
```

An example of building a flat fact progressively with addition:

``` ruby
Facter.add(:total_free_memory_mb, :type => :aggregate) do
  chunk(:physical_memory) do
    Facter.value(:memoryfree_mb)
  end

  chunk(:virtual_memory) do
    Facter.value(:swapfree_mb)
  end

  aggregate do |chunks|
    # The return value for this block determines the value of the fact.
    sum = 0
    chunks.each_value do |i|
      sum += i
    end

    sum
  end
end
```
