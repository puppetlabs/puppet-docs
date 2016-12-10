---
layout: default
title: "Language: Comments"
---

Puppet supports two kinds of comments:

## Shell-style comments


Shell-style comments (also known as Ruby-style comments) begin with a hash symbol (`#`) and continue to the end of a line. They can start at the beginning of a line or partway through a line that began with code.

``` puppet
# This is a comment
file {'/etc/ntp.conf': # This is another comment
  ensure => file,
  owner  => root,
}
```


## C-style comments

C-style comments are delimited by slashes with inner asterisks. They can span multiple lines. This comment style is less frequently used than shell-style.

``` puppet
/*
  this is a comment
*/
```
