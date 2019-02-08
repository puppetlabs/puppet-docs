---
layout: default
title: "Language: Data types: Sensitive"
canonical: "/puppet/latest/lang_data_sensitive.html"
---

[arithmetic]: ./lang_expressions.html#arithmetic-operators
[data type]: ./lang_data_type.html
[variant]: ./lang_data_abstract.html#variant


Sensitive types in the Puppet language are strings marked as sensitive. The value is displayed in plain text in the catalog and manifest, but is redacted from logs and reports. Because the value is currently maintained as plain text, you should only use it as an aid to ensure that sensitive values are not inadvertently disclosed.

> PuppetDB versions earlier than 4.4.0 have a known issue storing the sensitive data type. Make sure you are using a PuppetDB versions 4.4.0 or later with sensitive types.

## Syntax

The Sensitive type can be written as `Sensitive.new(val)`, or the shortform `Sensitive(val)`

### Parameters

The full signature for `Sensitive` is:

    Sensitive.new([<STRING VALUE>])

The Sensitive type is parameterized, but the parameterized type (the type of the value it contains) only retains the basic type as sensitive information about the length or details about the contained data value can otherwise be leaked.

It is therefore not possible to have detailed data types and expect that the data type match. For example, `Sensitive[Enum[red, blue, green]]` will fail if a value of `Sensitive('red')` is given. When a sensitive type is used, the type parameter must be generic, in this example a `Sensitive[String]` instead would match `Sensitive('red')`.

## Example

If you assign a sensitive value, and call notice:

```puppet
$secret = Sensitive('myPassword')
notice($secret)
```

This outputs `Notice: Scope(Class[main]): Sensitive [value redacted]`.

However, you can still unwrap this with the `unwrap` function and gain access to the original data. 

```
$secret = Sensitive('myPassword')
$processed = $secret.unwrap
notice $processed
```

In future implementations, this info may be encrypted, removing access to the original data with this method, but it currently is not and therefore you should only use it as an aid for logs and reports.



