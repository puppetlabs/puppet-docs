---
layout: default
title: "Future Parser: Data Types: Undef"
canonical: "/puppet/latest/reference/future_lang_data_undef.html"
---


[resourcedefault]: ./future_lang_defaults.html

Puppet's special `undef` value is roughly equivalent to `nil` in Ruby; it represents the absence of a value. If the `strict_variables` setting isn't enabled, variables which have never been declared have a value of `undef`. Literal undef values must be the bare word `undef`.

The `undef` value is usually useful for testing whether a variable has been set. It can also be used as the value of a resource attribute, which can let you un-set any value inherited from a [resource default][resourcedefault] and cause the attribute to be unmanaged.

When used as a boolean, `undef` is false. When interpolated into a string, `undef` will be converted to the empty string.

