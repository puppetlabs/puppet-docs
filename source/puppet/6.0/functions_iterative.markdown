---
title: "Writing functions: Iterative functions"
---

The Iterable and Iterator types represent all things over which an iterative function can iterate. Types that can be iterated over, such as Arrays and Hashes, are also Iterables; for example, an `Array[Integer]` is also an `Iterable[Integer]`. You can use iterative types to chain iterative functions built into Puppet, or to write efficient iterative functions that work well with them.

> **Note:** Iterable and Iterator types are used internally by Puppet to efficiently chain the results of its built-in iterative functions. Most Puppet users won't interact directly with these types, and you can't write iterative functions solely in the Puppet language, so this document is primarily targeted at users writing Iterative functions in Ruby. For details, see [Writing functions in Ruby](./functions_ruby_overview.html). For help writing less complex functions in Puppet code, see [Writing functions in Puppet](./lang_write_functions_in_puppet.html).

## Iterable and Iterator type design

The Iterable type represents all things an iterative function can iterate over. Before this type existed, users who wanted to design working iterative functions also needed to write code that accommodated all relevant types, such as `Array`, `Hash`, `Integer`, and `Type[Integer]`.

When Puppet 4.4 introduced these new types for iteration, Puppet also changed the signatures of iterative functions to accept an Iterable-type argument, instead of designing the functions to check against every type. This change doesn't affect how the Puppet code that invokes these functions worked, but did change the errors users see if they try to iterate over a value that does not have the Iterable type.

The Iterator type, which is a subtype of Iterable, is a special algorithm-based Iterable not backed by a concrete data type. When asked to produce a value, an Iterator produces the next value from its input, then either:

-   yields some kind of transformation of this value
-   take its input and yield each value from some formula based on that value

For example, the [`step` function](./function.html#step) produces consecutive values but does not need to first produce an array contain all of the values, it can compute them lazily.

## Writing iterative functions

> **Note:** You can't write iterative functions solely in the Puppet language.

When writing iterative functions, use the Iterable type instead of the more specific, individual types.

The Iterable type has a type parameter that describes the type that is yielded in each iteration; the type of the value in each turn of the loop if you so like. As an example, an `Array[Integer]` is also an `Iterable[Integer]`.

For best practices on implementing such functions, examine existing iterative functions in Puppet and read the Ruby documentation for the helper classes these functions use. See the [implementations](https://github.com/puppetlabs/puppet/tree/master/lib/puppet/functions) of `each` and `map` for functions that always produce a new result, and `reverse_each` and `step` for new iterative functions that return an Iterable when called without a block.

For example, this is the Ruby code for the `step` function:

```ruby
Puppet::Functions.create_function(:step) do
  dispatch :step do
    param 'Iterable', :iterable
    param 'Integer[1]', :step
  end

  dispatch :step_block do
    param 'Iterable', :iterable
    param 'Integer[1]', :step
    block_param 'Callable[1,1]', :block
  end

  def step(iterable, step)
    # produces an Iterable
    Puppet::Pops::Types::Iterable.asserted_iterable(self, iterable).step(step)
  end

  def step_block(iterable, step, &block)
    Puppet::Pops::Types::Iterable.asserted_iterable(self, iterable).step(step, &block)
    nil
  end
end
```

For help generating up-to-date Ruby reference docs, see [Generating Ruby API docs for developing extensions](./yard/index.html).

When writing a function that returns an Iterator, declare the return type as Iterable, because this is the most flexible.

## Efficiently chaining iterative functions

Iterative functions are often used in chains, where the result of one function is used as the next function's parameter. A typical example is a map/reduce function where values are first modified, and then an aggregate value is computed.

For example, this use of `reverse_each` and `reduce` works the same before and after iterative types were introduced:

```ruby
[1,2,3].reverse_each.reduce |$result, $x| { $result - $x }
```

The [`reverse_each` function](./function.html#reverseeach) iterates over the Array to reverse its values' order from `[1,2,3]` to `[3,2,1]`. The [`reduce` function](function.html#reduce) iterates over the Array subtracting each value from the previous value. The `$result` is `0`, because 3 - 2 - 1 = 0.

Iterable types allow functions like these to execute more efficiently in a chain of calls, because they eliminate each function's need to create an intermediate copy of the mapped values in the appropriate type.

In the above example, that would be the array `[3,2,1]` produced by the `reverse_each` function. The first time the `reduce` function is called, it receives the values `3` and `2` --- the value `1` has not yet been computed. In the next iteration, `reduce` receives the value `1` is produced, and the chain ends because there are no more values in the array.

Iterative functions work the same way in versions of Puppet prior to and after the introduction of iterative types in version 4.4.0, but Puppet 4.4.0 also added the new iterative function `step`, and the `reverse_each` function returns the more efficient Iterable- and Iterator-typed results when chained.

## Limitations and workarounds

When used last in a chain, you can assign a value of `Iterator[T]` (where T is a data type) to a variable and pass it on. However, you cannot to assign an Iterator to a parameter value, nor is it possible to call legacy 3.x functions with such a value.

Because the Iterator type is a special algorithm-based Iterable that is not backed by a concrete data type, and parameters in resources are serialized and Puppet cannot serialize a temporary algorithmic result, assigning an Iterator to a resource attribute raises an error:

```
Error while evaluating a '=>' expression, Use of an Iterator is not supported here
```

For example, this Puppet code results in the above error:

```puppet
notify { 'example1':
  message => [1,2,3].reverse_each,
}
```

Puppet needs a concrete data type for serialization, but the result of `[1,2,3].reverse_each` is only a temporary Iterator vallue.

To convert the Iterator-typed value to an Array, map the value. This example results in an Array by chaining the `map` function:

```puppet
notify { 'mapped_iterator':
  message => [1,2,3].reverse_each.map |$x| { $x },
}
```

The splat operator `*` can also convert the value into an Array:s

```puppet
notify { 'mapped_iterator':
  message => *[1,2,3].reverse_each,
}
```

Both of these examples result in a notice containing `[3,2,1]`.

If the splat operator is used in a context where it also unfolds, the result is the same as unfolding an array: each value of the array becomes a separate value, which results in separate arguments in a function call).