### The `Puppet::LookupKey` and `Puppet::LookupValue` types

To simplify backend function signatures, you can use two extra data type aliases: `Puppet::LookupKey`, and `Puppet::LookupValue`. These are only available to backend functions called by Hiera; normal functions and Puppet code can't use them.

`Puppet::LookupKey` matches any legal Hiera lookup key. It's equivalent to:

``` puppet
Variant[String, Numeric]
```

`Puppet::LookupValue` matches any value Hiera could return for a lookup. It's equivalent to:

``` puppet
Variant[
  Scalar,
  Undef,
  Sensitive,
  Type,
  Hash[Puppet::LookupKey, Puppet::LookupValue],
  Array[Puppet::LookupValue]
]
```
