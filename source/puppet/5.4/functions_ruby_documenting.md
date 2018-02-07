---
title: "Writing functions in Ruby: Documenting Ruby functions"
---

[puppet strings]: https://github.com/puppetlabs/puppet-strings
[overview]: ./functions_ruby_overview.html
[signatures]: ./functions_ruby_signatures.html

[Puppet Strings][], a free documentation tool for Puppet, can extract code details and specially-formatted comments to build documentation pages for functions. This page describes the proper formatting to make your comments work well with Strings.

> **Note:** This is one of several pages describing the Ruby functions API. Before reading it, make sure you understand the [overview of this API][overview] and how to [define function signatures][signatures].

## Examples

Full content for this page is coming soon. In the meantime, the following examples show how to format comments in two situations: a function with two explicit signatures, and a function with an automatic signature.

``` ruby
# Subtracts two things.
Puppet::Functions.create_function(:subtract) do
  # Subtracts two integers.
  # @param x The first integer.
  # @param y The second integer.
  # @return [Integer] Returns x - y.
  # @example Subtracting two integers.
  #   subtract(5, 1) => 4
  dispatch :subtract_ints do
    param 'Integer', :x
    param 'Integer', :y
  end

  # Subtracts two arrays.
  # @param x The first array.
  # @param y The second array.
  # @return [Array] Returns x - y.
  # @example Subtracting two arrays.
  #   subtract([3, 2, 1], [1]) => [3, 2]
  dispatch :subtract_arrays do
    param 'Array', :x
    param 'Array', :y
  end

  def subtract_ints(x, y)
    x - y
  end

  def subtract_arrays(x, y)
    x - y
  end
end
```

``` ruby
# Says goodbye (in the master's output).
Puppet::Functions.create_function(:goodbye) do
  # @param [String] name The name of the person to say goodbye to.
  # @return [Undef]
  # @example Saying goodbye is hard to do.
  #   goodbye('world') => 'goodbye world'
  def goodbye(name)
    puts "goodbye #{name}!"
    nil
  end
end
```
