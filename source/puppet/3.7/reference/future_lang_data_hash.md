---
layout: default
title: "Future Parser: Data Types: Hashes"
canonical: "/puppet/latest/reference/future_lang_data_hash.html"
---

[undef]: ./future_lang_data_undef.html
[stdlib]: http://forge.puppetlabs.com/puppetlabs/stdlib


Hashes are written as key/value pairs surrounded by curly braces; a key is separated from its value by a `=>` (arrow, fat comma, or hash rocket), and adjacent pairs are separated by commas. An optional trailing comma is allowed between the final value and the closing curly brace.

{% highlight ruby %}
    { key1 => 'val1', key2 => 'val2' }
    # Equivalent:
    { key1 => 'val1', key2 => 'val2', }
{% endhighlight %}

Hash keys are strings, but hash values can be any data type, including arrays or more hashes.

## Indexing

You can access hash members with their key; square brackets are used for indexing.

{% highlight ruby %}
    $myhash = { key       => "some value",
                other_key => "some other value" }
    notice( $myhash[key] )
{% endhighlight %}

This manifest would log `some value` as a notice.

If you try to access a nonexistent key from a hash, its value will be [`undef`.][undef]

{% highlight ruby %}
    $cool_value = $myhash[absent_key] # Value is undef
{% endhighlight %}

Nested arrays and hashes can be accessed by chaining indexes:

{% highlight ruby %}
    $main_site = { port        => { http  => 80,
                                    https => 443 },
                   vhost_name  => 'docs.puppetlabs.com',
                   server_name => { mirror0 => 'warbler.example.com',
                                    mirror1 => 'egret.example.com' }
                 }
    notice ( $main_site[port][https] )
{% endhighlight %}

This example manifest would log `443` as a notice.

## Additional Functions

The [puppetlabs-stdlib][stdlib] module contains several additional functions for dealing with hashes, including:

* `has_key`
* `is_hash`
* `keys`
* `merge`
* `validate_hash`
* `values`
