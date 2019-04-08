---
layout: default
built_from_commit: edd3c04ba4892bd59ab1cac02f44d74c9d432ca8
title: List of built-in functions
canonical: "/puppet/latest/function.html"
toc_levels: 2
toc: columns
---

> **NOTE:** This page was generated from the Puppet source code on 2018-08-14 10:19:44 -0700

This page is a list of Puppet's built-in functions, with descriptions of what they do and how to use them.

Functions are plugins you can call during catalog compilation. A call to any function is an expression that resolves to a value. For more information on how to call functions, see [the language reference page about function calls.](./lang_functions.html) 

Many of these function descriptions include auto-detected _signatures,_ which are short reminders of the function's allowed arguments. These signatures aren't identical to the syntax you use to call the function; instead, they resemble a parameter list from a Puppet [class](./lang_classes.html), [defined resource type](./lang_defined_types.html), [function](./lang_write_functions_in_puppet.html), or [lambda](./lang_lambdas.html). The syntax of a signature is:

```
<FUNCTION NAME>(<DATA TYPE> <ARGUMENT NAME>, ...)
```

The `<DATA TYPE>` is a [Puppet data type value](./lang_data_type.html), like `String` or `Optional[Array[String]]`. The `<ARGUMENT NAME>` is a descriptive name chosen by the function's author to indicate what the argument is used for.

* Any arguments with an `Optional` data type can be omitted from the function call.
* Arguments that start with an asterisk (like `*$values`) can be repeated any number of times.
* Arguments that start with an ampersand (like `&$block`) aren't normal arguments; they represent a code block, provided with [Puppet's lambda syntax.](./lang_lambdas.html)


## `alert`

* `alert(Any *$values)`
    * `*values` --- The values to log.
    * Return type(s): `Undef`. 

Log a message on the server at level alert.

## `all`

* `all(Hash[Any, Any] $hash, Callable[2,2] &$block)`
    * Return type(s): `Any`. 
* `all(Hash[Any, Any] $hash, Callable[1,1] &$block)`
    * Return type(s): `Any`. 
* `all(Iterable $enumerable, Callable[2,2] &$block)`
    * Return type(s): `Any`. 
* `all(Iterable $enumerable, Callable[1,1] &$block)`
    * Return type(s): `Any`. 

Runs a [lambda](http://docs.puppetlabs.com/puppet/latest/reference/lang_lambdas.html)
repeatedly using each value in a data structure until the lambda returns a non "truthy" value which
makes the function return `false`, or if the end of the iteration is reached, `true` is returned.

This function takes two mandatory arguments, in this order:

1. An array, hash, or other iterable object that the function will iterate over.
2. A lambda, which the function calls for each element in the first argument. It can
request one or two parameters.

`$data.all |$parameter| { <PUPPET CODE BLOCK> }`

or

`all($data) |$parameter| { <PUPPET CODE BLOCK> }`

~~~ puppet
# For the array $data, run a lambda that checks that all values are multiples of 10
$data = [10, 20, 30]
notice $data.all |$item| { $item % 10 == 0 }
~~~

Would notice `true`.

When the first argument is a `Hash`, Puppet passes each key and value pair to the lambda
as an array in the form `[key, value]`.

~~~ puppet
# For the hash $data, run a lambda using each item as a key-value array
$data = { 'a_0'=> 10, 'b_1' => 20 }
notice $data.all |$item| { $item[1] % 10 == 0  }
~~~

Would notice `true` if all values in the hash are multiples of 10.

When the lambda accepts two arguments, the first argument gets the index in an array
or the key from a hash, and the second argument the value.


~~~ puppet
# Check that all values are a multiple of 10 and keys start with 'abc'
$data = {abc_123 => 10, abc_42 => 20, abc_blue => 30}
notice $data.all |$key, $value| { $value % 10 == 0  and $key =~ /^abc/ }
~~~

Would notice true.

For an general examples that demonstrates iteration, see the Puppet
[iteration](https://docs.puppetlabs.com/puppet/latest/reference/lang_iteration.html)
documentation.

## `annotate`

* `annotate(Type[Annotation] $type, Any $value, Optional[Callable[0, 0]] &$block)`
    * Return type(s): `Any`. 
* `annotate(Type[Annotation] $type, Any $value, Variant[Enum[clear],Hash[Pcore::MemberName,Any]] $annotation_hash)`
    * Return type(s): `Any`. 
* `annotate(Type[Pcore] $type, Any $value, Hash[Type[Annotation], Hash[Pcore::MemberName,Any]] $annotations)`
    * Return type(s): `Any`. 

Handles annotations on objects. The function can be used in four different ways.

With two arguments, an `Annotation` type and an object, the function returns the annotation
for the object of the given type, or `undef` if no such annotation exists.

~~~ puppet
$annotation = Mod::NickNameAdapter.annotate(o)

$annotation = annotate(Mod::NickNameAdapter.annotate, o)
~~~

With three arguments, an `Annotation` type, an object, and a block, the function returns the
annotation for the object of the given type, or annotates it with a new annotation initialized
from the hash returned by the given block when no such annotation exists. The block will not
be called when an annotation of the given type is already present.

~~~ puppet
$annotation = Mod::NickNameAdapter.annotate(o) || { { 'nick_name' => 'Buddy' } }

$annotation = annotate(Mod::NickNameAdapter.annotate, o) || { { 'nick_name' => 'Buddy' } }
~~~

With three arguments, an `Annotation` type, an object, and an `Hash`, the function will annotate
the given object with a new annotation of the given type that is initialized from the given hash.
An existing annotation of the given type is discarded.

~~~ puppet
$annotation = Mod::NickNameAdapter.annotate(o, { 'nick_name' => 'Buddy' })

$annotation = annotate(Mod::NickNameAdapter.annotate, o, { 'nick_name' => 'Buddy' })
~~~

With three arguments, an `Annotation` type, an object, and an the string `clear`, the function will
clear the annotation of the given type in the given object. The old annotation is returned if
it existed.

~~~ puppet
$annotation = Mod::NickNameAdapter.annotate(o, clear)

$annotation = annotate(Mod::NickNameAdapter.annotate, o, clear)
~~~

With three arguments, the type `Pcore`, an object, and a Hash of hashes keyed by `Annotation` types,
the function will annotate the given object with all types used as keys in the given hash. Each annotation
is initialized with the nested hash for the respective type. The annotated object is returned.

~~~ puppet
  $person = Pcore.annotate(Mod::Person({'name' => 'William'}), {
    Mod::NickNameAdapter >= { 'nick_name' => 'Bill' },
    Mod::HobbiesAdapter => { 'hobbies' => ['Ham Radio', 'Philatelist'] }
  })
~~~

## `any`

* `any(Hash[Any, Any] $hash, Callable[2,2] &$block)`
    * Return type(s): `Any`. 
* `any(Hash[Any, Any] $hash, Callable[1,1] &$block)`
    * Return type(s): `Any`. 
* `any(Iterable $enumerable, Callable[2,2] &$block)`
    * Return type(s): `Any`. 
* `any(Iterable $enumerable, Callable[1,1] &$block)`
    * Return type(s): `Any`. 

Runs a [lambda](http://docs.puppetlabs.com/puppet/latest/reference/lang_lambdas.html)
repeatedly using each value in a data structure until the lambda returns a "truthy" value which
makes the function return `true`, or if the end of the iteration is reached, false is returned.

This function takes two mandatory arguments, in this order:

1. An array, hash, or other iterable object that the function will iterate over.
2. A lambda, which the function calls for each element in the first argument. It can
request one or two parameters.

`$data.any |$parameter| { <PUPPET CODE BLOCK> }`

or

`any($data) |$parameter| { <PUPPET CODE BLOCK> }`

~~~ puppet
# For the array $data, run a lambda that checks if an unknown hash contains those keys
$data = ["routers", "servers", "workstations"]
$looked_up = lookup('somekey', Hash)
notice $data.any |$item| { $looked_up[$item] }
~~~

Would notice `true` if the looked up hash had a value that is neither `false` nor `undef` for at least
one of the keys. That is, it is equivalent to the expression
`$looked_up[routers] || $looked_up[servers] || $looked_up[workstations]`.

When the first argument is a `Hash`, Puppet passes each key and value pair to the lambda
as an array in the form `[key, value]`.

~~~ puppet
# For the hash $data, run a lambda using each item as a key-value array.
$data = {"rtr" => "Router", "svr" => "Server", "wks" => "Workstation"}
$looked_up = lookup('somekey', Hash)
notice $data.any |$item| { $looked_up[$item[0]] }
~~~

Would notice `true` if the looked up hash had a value for one of the wanted key that is
neither `false` nor `undef`.

When the lambda accepts two arguments, the first argument gets the index in an array
or the key from a hash, and the second argument the value.


~~~ puppet
# Check if there is an even numbered index that has a non String value
$data = [key1, 1, 2, 2]
notice $data.any |$index, $value| { $index % 2 == 0 and $value !~ String }
~~~

Would notice true as the index `2` is even and not a `String`

For an general examples that demonstrates iteration, see the Puppet
[iteration](https://docs.puppetlabs.com/puppet/latest/reference/lang_iteration.html)
documentation.

## `assert_type`

* `assert_type(Type $type, Any $value, Optional[Callable[Type, Type]] &$block)`
    * Return type(s): `Any`. 
* `assert_type(String $type_string, Any $value, Optional[Callable[Type, Type]] &$block)`
    * Return type(s): `Any`. 

Returns the given value if it is of the given
[data type](https://docs.puppetlabs.com/puppet/latest/reference/lang_data.html), or
otherwise either raises an error or executes an optional two-parameter
[lambda](https://docs.puppetlabs.com/puppet/latest/reference/lang_lambdas.html).

The function takes two mandatory arguments, in this order:

1. The expected data type.
2. A value to compare against the expected data type.

~~~ puppet
$raw_username = 'Amy Berry'

# Assert that $raw_username is a non-empty string and assign it to $valid_username.
$valid_username = assert_type(String[1], $raw_username)

# $valid_username contains "Amy Berry".
# If $raw_username was an empty string or a different data type, the Puppet run would
# fail with an "Expected type does not match actual" error.
~~~

You can use an optional lambda to provide enhanced feedback. The lambda takes two
mandatory parameters, in this order:

1. The expected data type as described in the function's first argument.
2. The actual data type of the value.

~~~ puppet
$raw_username = 'Amy Berry'

# Assert that $raw_username is a non-empty string and assign it to $valid_username.
# If it isn't, output a warning describing the problem and use a default value.
$valid_username = assert_type(String[1], $raw_username) |$expected, $actual| {
  warning( "The username should be \'${expected}\', not \'${actual}\'. Using 'anonymous'." )
  'anonymous'
}

# $valid_username contains "Amy Berry".
# If $raw_username was an empty string, the Puppet run would set $valid_username to
# "anonymous" and output a warning: "The username should be 'String[1, default]', not
# 'String[0, 0]'. Using 'anonymous'."
~~~

For more information about data types, see the
[documentation](https://docs.puppetlabs.com/puppet/latest/reference/lang_data.html).

## `binary_file`

* `binary_file(String $path)`
    * Return type(s): `Any`. 

Loads a binary file from a module or file system and returns its contents as a Binary.
(Documented in 3.x stub)

## `break`

* `break()`
    * Return type(s): `Any`. 

Make iteration break as if there were no more values to process

## `call`

* `call(String $function_name, Any *$arguments, Optional[Callable] &$block)`
    * Return type(s): `Any`. 

Calls an arbitrary Puppet function by name.

This function takes one mandatory argument and one or more optional arguments:

1. A string corresponding to a function name.
2. Any number of arguments to be passed to the called function.
3. An optional lambda, if the function being called supports it.

~~~ puppet
$a = 'notice'
call($a, 'message')
~~~

~~~ puppet
$a = 'each'
$b = [1,2,3]
call($a, $b) |$item| {
 notify { $item: }
}
~~~

The `call` function can be used to call either Ruby functions or Puppet language
functions.

## `contain`

* `contain(Any *$names)`
    * Return type(s): `Any`. 

Called within a class definition, establishes a containment
relationship with another class
For documentation, see the 3.x stub

## `convert_to`

* `convert_to(Any $value, Type $type, Optional[Callable[1,1]] &$block)`
    * Return type(s): `Any`. 

The `convert_to(value, type)` is a convenience function does the same as `new(type, value)`.
The difference in the argument ordering allows it to be used in chained style for
improved readability "left to right".

When the function is given a lambda, it is called with the converted value, and the function
returns what the lambda returns, otherwise the converted value.

~~~ puppet
  # using new operator - that is "calling the type" with operator ()
  Hash(Array("abc").map |$i,$v| { [$i, $v] })

  # using 'convert_to'
  "abc".convert_to(Array).map |$i,$v| { [$i, $v] }.convert_to(Hash)

~~~

## `create_resources`

* `create_resources()`
    * Return type(s): `Any`. 

Converts a hash into a set of resources and adds them to the catalog.

This function takes two mandatory arguments: a resource type, and a hash describing
a set of resources. The hash should be in the form `{title => {parameters} }`:

    # A hash of user resources:
    $myusers = {
      'nick' => { uid    => '1330',
                  gid    => allstaff,
                  groups => ['developers', 'operations', 'release'], },
      'dan'  => { uid    => '1308',
                  gid    => allstaff,
                  groups => ['developers', 'prosvc', 'release'], },
    }

    create_resources(user, $myusers)

A third, optional parameter may be given, also as a hash:

    $defaults = {
      'ensure'   => present,
      'provider' => 'ldap',
    }

    create_resources(user, $myusers, $defaults)

The values given on the third argument are added to the parameters of each resource
present in the set given on the second argument. If a parameter is present on both
the second and third arguments, the one on the second argument takes precedence.

This function can be used to create defined resources and classes, as well
as native resources.

Virtual and Exported resources may be created by prefixing the type name
with @ or @@ respectively.  For example, the $myusers hash may be exported
in the following manner:

    create_resources("@@user", $myusers)

The $myusers may be declared as virtual resources using:

    create_resources("@user", $myusers)

Note that `create_resources` will filter out parameter values that are `undef` so that normal
data binding and puppet default value expressions are considered (in that order) for the
final value of a parameter (just as when setting a parameter to `undef` in a puppet language
resource declaration).

## `crit`

* `crit(Any *$values)`
    * `*values` --- The values to log.
    * Return type(s): `Undef`. 

Log a message on the server at level crit.

## `debug`

* `debug(Any *$values)`
    * `*values` --- The values to log.
    * Return type(s): `Undef`. 

Log a message on the server at level debug.

## `defined`

* `defined(Variant[String, Type[CatalogEntry], Type[Type[CatalogEntry]]] *$vals)`
    * Return type(s): `Any`. 

Determines whether a given class or resource type is defined and returns a Boolean
value. You can also use `defined` to determine whether a specific resource is defined,
or whether a variable has a value (including `undef`, as opposed to the variable never
being declared or assigned).

This function takes at least one string argument, which can be a class name, type name,
resource reference, or variable reference of the form `'$name'`.

The `defined` function checks both native and defined types, including types
provided by modules. Types and classes are matched by their names. The function matches
resource declarations by using resource references.

**Examples**: Different types of `defined` function matches

~~~ puppet
# Matching resource types
defined("file")
defined("customtype")

# Matching defines and classes
defined("foo")
defined("foo::bar")

# Matching variables
defined('$name')

# Matching declared resources
defined(File['/tmp/file'])
~~~

Puppet depends on the configuration's evaluation order when checking whether a resource
is declared.

~~~ puppet
# Assign values to $is_defined_before and $is_defined_after using identical `defined`
# functions.

$is_defined_before = defined(File['/tmp/file'])

file { "/tmp/file":
  ensure => present,
}

$is_defined_after = defined(File['/tmp/file'])

# $is_defined_before returns false, but $is_defined_after returns true.
~~~

This order requirement only refers to evaluation order. The order of resources in the
configuration graph (e.g. with `before` or `require`) does not affect the `defined`
function's behavior.

> **Warning:** Avoid relying on the result of the `defined` function in modules, as you
> might not be able to guarantee the evaluation order well enough to produce consistent
> results. This can cause other code that relies on the function's result to behave
> inconsistently or fail.

If you pass more than one argument to `defined`, the function returns `true` if _any_
of the arguments are defined. You can also match resources by type, allowing you to
match conditions of different levels of specificity, such as whether a specific resource
is of a specific data type.

~~~ puppet
file { "/tmp/file1":
  ensure => file,
}

$tmp_file = file { "/tmp/file2":
  ensure => file,
}

# Each of these statements return `true` ...
defined(File['/tmp/file1'])
defined(File['/tmp/file1'],File['/tmp/file2'])
defined(File['/tmp/file1'],File['/tmp/file2'],File['/tmp/file3'])
# ... but this returns `false`.
defined(File['/tmp/file3'])

# Each of these statements returns `true` ...
defined(Type[Resource['file','/tmp/file2']])
defined(Resource['file','/tmp/file2'])
defined(File['/tmp/file2'])
defined('$tmp_file')
# ... but each of these returns `false`.
defined(Type[Resource['exec','/tmp/file2']])
defined(Resource['exec','/tmp/file2'])
defined(File['/tmp/file3'])
defined('$tmp_file2')
~~~

## `dig`

* `dig(Optional[Collection] $data, Any *$arg)`
    * Return type(s): `Any`. 

Digs into a data structure.
(Documented in 3.x stub)

## `digest`

* `digest()`
    * Return type(s): `Any`. 

Returns a hash value from a provided string using the digest_algorithm setting from the Puppet config file.

## `each`

* `each(Hash[Any, Any] $hash, Callable[2,2] &$block)`
    * Return type(s): `Any`. 
* `each(Hash[Any, Any] $hash, Callable[1,1] &$block)`
    * Return type(s): `Any`. 
* `each(Iterable $enumerable, Callable[2,2] &$block)`
    * Return type(s): `Any`. 
* `each(Iterable $enumerable, Callable[1,1] &$block)`
    * Return type(s): `Any`. 

Runs a [lambda](https://docs.puppetlabs.com/puppet/latest/reference/lang_lambdas.html)
repeatedly using each value in a data structure, then returns the values unchanged.

This function takes two mandatory arguments, in this order:

1. An array, hash, or other iterable object that the function will iterate over.
2. A lambda, which the function calls for each element in the first argument. It can
request one or two parameters.

`$data.each |$parameter| { <PUPPET CODE BLOCK> }`

or

`each($data) |$parameter| { <PUPPET CODE BLOCK> }`

When the first argument (`$data` in the above example) is an array, Puppet passes each
value in turn to the lambda, then returns the original values.

~~~ puppet
# For the array $data, run a lambda that creates a resource for each item.
$data = ["routers", "servers", "workstations"]
$data.each |$item| {
 notify { $item:
   message => $item
 }
}
# Puppet creates one resource for each of the three items in $data. Each resource is
# named after the item's value and uses the item's value in a parameter.
~~~

When the first argument is a hash, Puppet passes each key and value pair to the lambda
as an array in the form `[key, value]` and returns the original hash.

~~~ puppet
# For the hash $data, run a lambda using each item as a key-value array that creates a
# resource for each item.
$data = {"rtr" => "Router", "svr" => "Server", "wks" => "Workstation"}
$data.each |$items| {
 notify { $items[0]:
   message => $items[1]
 }
}
# Puppet creates one resource for each of the three items in $data, each named after the
# item's key and containing a parameter using the item's value.
~~~

When the first argument is an array and the lambda has two parameters, Puppet passes the
array's indexes (enumerated from 0) in the first parameter and its values in the second
parameter.

~~~ puppet
# For the array $data, run a lambda using each item's index and value that creates a
# resource for each item.
$data = ["routers", "servers", "workstations"]
$data.each |$index, $value| {
 notify { $value:
   message => $index
 }
}
# Puppet creates one resource for each of the three items in $data, each named after the
# item's value and containing a parameter using the item's index.
~~~

When the first argument is a hash, Puppet passes its keys to the first parameter and its
values to the second parameter.

~~~ puppet
# For the hash $data, run a lambda using each item's key and value to create a resource
# for each item.
$data = {"rtr" => "Router", "svr" => "Server", "wks" => "Workstation"}
$data.each |$key, $value| {
 notify { $key:
   message => $value
 }
}
# Puppet creates one resource for each of the three items in $data, each named after the
# item's key and containing a parameter using the item's value.
~~~

For an example that demonstrates how to create multiple `file` resources using `each`,
see the Puppet
[iteration](https://docs.puppetlabs.com/puppet/latest/reference/lang_iteration.html)
documentation.

## `emerg`

* `emerg(Any *$values)`
    * `*values` --- The values to log.
    * Return type(s): `Undef`. 

Log a message on the server at level emerg.

## `epp`

* `epp(String $path, Optional[Hash[Pattern[/^\w+$/], Any]] $parameters)`
    * Return type(s): `Any`. 

Evaluates an Embedded Puppet (EPP) template file and returns the rendered text
result as a String.

`epp('<MODULE NAME>/<TEMPLATE FILE>', <PARAMETER HASH>)`

The first argument to this function should be a `<MODULE NAME>/<TEMPLATE FILE>`
reference, which loads `<TEMPLATE FILE>` from `<MODULE NAME>`'s `templates`
directory. In most cases, the last argument is optional; if used, it should be a
[hash](/puppet/latest/reference/lang_data_hash.html) that contains parameters to
pass to the template.

- See the [template](/puppet/latest/reference/lang_template.html) documentation
for general template usage information.
- See the [EPP syntax](/puppet/latest/reference/lang_template_epp.html)
documentation for examples of EPP.

For example, to call the apache module's `templates/vhost/_docroot.epp`
template and pass the `docroot` and `virtual_docroot` parameters, call the `epp`
function like this:

`epp('apache/vhost/_docroot.epp', { 'docroot' => '/var/www/html',
'virtual_docroot' => '/var/www/example' })`

This function can also accept an absolute path, which can load a template file
from anywhere on disk.

Puppet produces a syntax error if you pass more parameters than are declared in
the template's parameter tag. When passing parameters to a template that
contains a parameter tag, use the same names as the tag's declared parameters.

Parameters are required only if they are declared in the called template's
parameter tag without default values. Puppet produces an error if the `epp`
function fails to pass any required parameter.

## `err`

* `err(Any *$values)`
    * `*values` --- The values to log.
    * Return type(s): `Undef`. 

Log a message on the server at level err.

## `eyaml_lookup_key`

* `eyaml_lookup_key(String[1] $key, Hash[String[1],Any] $options, Puppet::LookupContext $context)`
    * Return type(s): `Any`. 

The `eyaml_lookup_key` is a hiera 5 `lookup_key` data provider function.
See [the configuration guide documentation](https://docs.puppet.com/puppet/latest/hiera_config_yaml_5.html#configuring-a-hierarchy-level-hiera-eyaml) for
how to use this function.

## `fail`

* `fail()`
    * Return type(s): `Any`. 

Fail with a parse error.

## `file`

* `file()`
    * Return type(s): `Any`. 

Loads a file from a module and returns its contents as a string.

The argument to this function should be a `<MODULE NAME>/<FILE>`
reference, which will load `<FILE>` from a module's `files`
directory. (For example, the reference `mysql/mysqltuner.pl` will load the
file `<MODULES DIRECTORY>/mysql/files/mysqltuner.pl`.)

This function can also accept:

* An absolute path, which can load a file from anywhere on disk.
* Multiple arguments, which will return the contents of the **first** file
found, skipping any files that don't exist.

## `filter`

* `filter(Hash[Any, Any] $hash, Callable[2,2] &$block)`
    * Return type(s): `Any`. 
* `filter(Hash[Any, Any] $hash, Callable[1,1] &$block)`
    * Return type(s): `Any`. 
* `filter(Iterable $enumerable, Callable[2,2] &$block)`
    * Return type(s): `Any`. 
* `filter(Iterable $enumerable, Callable[1,1] &$block)`
    * Return type(s): `Any`. 

Applies a [lambda](https://docs.puppetlabs.com/puppet/latest/reference/lang_lambdas.html)
to every value in a data structure and returns an array or hash containing any elements
for which the lambda evaluates to `true`.

This function takes two mandatory arguments, in this order:

1. An array, hash, or other iterable object that the function will iterate over.
2. A lambda, which the function calls for each element in the first argument. It can
request one or two parameters.

`$filtered_data = $data.filter |$parameter| { <PUPPET CODE BLOCK> }`

or

`$filtered_data = filter($data) |$parameter| { <PUPPET CODE BLOCK> }`

When the first argument (`$data` in the above example) is an array, Puppet passes each
value in turn to the lambda and returns an array containing the results.

~~~ puppet
# For the array $data, return an array containing the values that end with "berry"
$data = ["orange", "blueberry", "raspberry"]
$filtered_data = $data.filter |$items| { $items =~ /berry$/ }
# $filtered_data = [blueberry, raspberry]
~~~

When the first argument is a hash, Puppet passes each key and value pair to the lambda
as an array in the form `[key, value]` and returns a hash containing the results.

~~~ puppet
# For the hash $data, return a hash containing all values of keys that end with "berry"
$data = { "orange" => 0, "blueberry" => 1, "raspberry" => 2 }
$filtered_data = $data.filter |$items| { $items[0] =~ /berry$/ }
# $filtered_data = {blueberry => 1, raspberry => 2}

When the first argument is an array and the lambda has two parameters, Puppet passes the
array's indexes (enumerated from 0) in the first parameter and its values in the second
parameter.

~~~ puppet
# For the array $data, return an array of all keys that both end with "berry" and have
# an even-numbered index
$data = ["orange", "blueberry", "raspberry"]
$filtered_data = $data.filter |$indexes, $values| { $indexes % 2 == 0 and $values =~ /berry$/ }
# $filtered_data = [raspberry]
~~~

When the first argument is a hash, Puppet passes its keys to the first parameter and its
values to the second parameter.

~~~ puppet
# For the hash $data, return a hash of all keys that both end with "berry" and have 
# values less than or equal to 1
$data = { "orange" => 0, "blueberry" => 1, "raspberry" => 2 }
$filtered_data = $data.filter |$keys, $values| { $keys =~ /berry$/ and $values <= 1 }
# $filtered_data = {blueberry => 1}
~~~

## `find_file`

* `find_file(String *$paths)`
    * Return type(s): `Any`. 
* `find_file(Array[String] *$paths_array)`
    * Return type(s): `Any`. 

Finds an existing file from a module and returns its path.
(Documented in 3.x stub)

## `fqdn_rand`

* `fqdn_rand()`
    * Return type(s): `Any`. 

Usage: `fqdn_rand(MAX, [SEED])`. MAX is required and must be a positive
integer; SEED is optional and may be any number or string.

Generates a random Integer number greater than or equal to 0 and less than MAX,
combining the `$fqdn` fact and the value of SEED for repeatable randomness.
(That is, each node will get a different random number from this function, but
a given node's result will be the same every time unless its hostname changes.)

This function is usually used for spacing out runs of resource-intensive cron
tasks that run on many nodes, which could cause a thundering herd or degrade
other services if they all fire at once. Adding a SEED can be useful when you
have more than one such task and need several unrelated random numbers per
node. (For example, `fqdn_rand(30)`, `fqdn_rand(30, 'expensive job 1')`, and
`fqdn_rand(30, 'expensive job 2')` will produce totally different numbers.)

## `generate`

* `generate()`
    * Return type(s): `Any`. 

Calls an external command on the Puppet master and returns
the results of the command.  Any arguments are passed to the external command as
arguments.  If the generator does not exit with return code of 0,
the generator is considered to have failed and a parse error is
thrown.  Generators can only have file separators, alphanumerics, dashes,
and periods in them.  This function will attempt to protect you from
malicious generator calls (e.g., those with '..' in them), but it can
never be entirely safe.  No subshell is used to execute
generators, so all shell metacharacters are passed directly to
the generator.

## `hiera`

* `hiera()`

Performs a standard priority lookup of the hierarchy and returns the most specific value
for a given key. The returned value can be any type of data.

This function is deprecated in favor of the `lookup` function. While this function
continues to work, it does **not** support:
* `lookup_options` stored in the data
* lookup across global, environment, and module layers

The function takes up to three arguments, in this order:

1. A string key that Hiera searches for in the hierarchy. **Required**.
2. An optional default value to return if Hiera doesn't find anything matching the key.
    * If this argument isn't provided and this function results in a lookup failure, Puppet
    fails with a compilation error.
3. The optional name of an arbitrary
[hierarchy level](https://docs.puppetlabs.com/hiera/latest/hierarchy.html) to insert at the
top of the hierarchy. This lets you temporarily modify the hierarchy for a single lookup.
    * If Hiera doesn't find a matching key in the overriding hierarchy level, it continues
    searching the rest of the hierarchy.

The `hiera` function does **not** find all matches throughout a hierarchy, instead
returning the first specific value starting at the top of the hierarchy. To search
throughout a hierarchy, use the `hiera_array` or `hiera_hash` functions.

~~~ yaml
# Assuming hiera.yaml
# :hierarchy:
#   - web01.example.com
#   - common

# Assuming web01.example.com.yaml:
# users:
#   - "Amy Barry"
#   - "Carrie Douglas"

# Assuming common.yaml:
users:
  admins:
    - "Edith Franklin"
    - "Ginny Hamilton"
  regular:
    - "Iris Jackson"
    - "Kelly Lambert"
~~~

~~~ puppet
# Assuming we are not web01.example.com:

$users = hiera('users', undef)

# $users contains {admins  => ["Edith Franklin", "Ginny Hamilton"],
#                  regular => ["Iris Jackson", "Kelly Lambert"]}
~~~

You can optionally generate the default value with a
[lambda](https://docs.puppetlabs.com/puppet/latest/reference/lang_lambdas.html) that
takes one parameter.

~~~ puppet
# Assuming the same Hiera data as the previous example:

$users = hiera('users') | $key | { "Key \'${key}\' not found" }

# $users contains {admins  => ["Edith Franklin", "Ginny Hamilton"],
#                  regular => ["Iris Jackson", "Kelly Lambert"]}
# If hiera couldn't match its key, it would return the lambda result,
# "Key 'users' not found".
~~~

The returned value's data type depends on the types of the results. In the example 
above, Hiera matches the 'users' key and returns it as a hash.

See
[the 'Using the lookup function' documentation](https://docs.puppet.com/puppet/latest/hiera_use_function.html) for how to perform lookup of data.
Also see
[the 'Using the deprecated hiera functions' documentation](https://docs.puppet.com/puppet/latest/hiera_use_hiera_functions.html)
for more information about the Hiera 3 functions.

## `hiera_array`

* `hiera_array()`

Finds all matches of a key throughout the hierarchy and returns them as a single flattened
array of unique values. If any of the matched values are arrays, they're flattened and
included in the results. This is called an
[array merge lookup](https://docs.puppetlabs.com/hiera/latest/lookup_types.html#array-merge).

This function is deprecated in favor of the `lookup` function. While this function
continues to work, it does **not** support:
* `lookup_options` stored in the data
* lookup across global, environment, and module layers

The `hiera_array` function takes up to three arguments, in this order:

1. A string key that Hiera searches for in the hierarchy. **Required**.
2. An optional default value to return if Hiera doesn't find anything matching the key.
    * If this argument isn't provided and this function results in a lookup failure, Puppet
    fails with a compilation error.
3. The optional name of an arbitrary
[hierarchy level](https://docs.puppetlabs.com/hiera/latest/hierarchy.html) to insert at the
top of the hierarchy. This lets you temporarily modify the hierarchy for a single lookup.
    * If Hiera doesn't find a matching key in the overriding hierarchy level, it continues
    searching the rest of the hierarchy.

~~~ yaml
# Assuming hiera.yaml
# :hierarchy:
#   - web01.example.com
#   - common

# Assuming common.yaml:
# users:
#   - 'cdouglas = regular'
#   - 'efranklin = regular'

# Assuming web01.example.com.yaml:
# users: 'abarry = admin'
~~~

~~~ puppet
$allusers = hiera_array('users', undef)

# $allusers contains ["cdouglas = regular", "efranklin = regular", "abarry = admin"].
~~~

You can optionally generate the default value with a
[lambda](https://docs.puppetlabs.com/puppet/latest/reference/lang_lambdas.html) that
takes one parameter.

~~~ puppet
# Assuming the same Hiera data as the previous example:

$allusers = hiera_array('users') | $key | { "Key \'${key}\' not found" }

# $allusers contains ["cdouglas = regular", "efranklin = regular", "abarry = admin"].
# If hiera_array couldn't match its key, it would return the lambda result,
# "Key 'users' not found".
~~~

`hiera_array` expects that all values returned will be strings or arrays. If any matched
value is a hash, Puppet raises a type mismatch error.

See
[the 'Using the lookup function' documentation](https://docs.puppet.com/puppet/latest/hiera_use_function.html) for how to perform lookup of data.
Also see
[the 'Using the deprecated hiera functions' documentation](https://docs.puppet.com/puppet/latest/hiera_use_hiera_functions.html)
for more information about the Hiera 3 functions.

## `hiera_hash`

* `hiera_hash()`

Finds all matches of a key throughout the hierarchy and returns them in a merged hash.

This function is deprecated in favor of the `lookup` function. While this function
continues to work, it does **not** support:
* `lookup_options` stored in the data
* lookup across global, environment, and module layers

If any of the matched hashes share keys, the final hash uses the value from the
highest priority match. This is called a
[hash merge lookup](https://docs.puppetlabs.com/hiera/latest/lookup_types.html#hash-merge).

The merge strategy is determined by Hiera's
[`:merge_behavior`](https://docs.puppetlabs.com/hiera/latest/configuring.html#mergebehavior)
setting.

The `hiera_hash` function takes up to three arguments, in this order:

1. A string key that Hiera searches for in the hierarchy. **Required**.
2. An optional default value to return if Hiera doesn't find anything matching the key.
    * If this argument isn't provided and this function results in a lookup failure, Puppet
    fails with a compilation error.
3. The optional name of an arbitrary
[hierarchy level](https://docs.puppetlabs.com/hiera/latest/hierarchy.html) to insert at the
top of the hierarchy. This lets you temporarily modify the hierarchy for a single lookup.
    * If Hiera doesn't find a matching key in the overriding hierarchy level, it continues
    searching the rest of the hierarchy.

~~~ yaml
# Assuming hiera.yaml
# :hierarchy:
#   - web01.example.com
#   - common

# Assuming common.yaml:
# users:
#   regular:
#     'cdouglas': 'Carrie Douglas'

# Assuming web01.example.com.yaml:
# users:
#   administrators:
#     'aberry': 'Amy Berry'
~~~

~~~ puppet
# Assuming we are not web01.example.com:

$allusers = hiera_hash('users', undef)

# $allusers contains {regular => {"cdouglas" => "Carrie Douglas"},
#                     administrators => {"aberry" => "Amy Berry"}}
~~~

You can optionally generate the default value with a
[lambda](https://docs.puppetlabs.com/puppet/latest/reference/lang_lambdas.html) that
takes one parameter.

~~~ puppet
# Assuming the same Hiera data as the previous example:

$allusers = hiera_hash('users') | $key | { "Key \'${key}\' not found" }

# $allusers contains {regular => {"cdouglas" => "Carrie Douglas"},
#                     administrators => {"aberry" => "Amy Berry"}}
# If hiera_hash couldn't match its key, it would return the lambda result,
# "Key 'users' not found".
~~~

`hiera_hash` expects that all values returned will be hashes. If any of the values
found in the data sources are strings or arrays, Puppet raises a type mismatch error.

See
[the 'Using the lookup function' documentation](https://docs.puppet.com/puppet/latest/hiera_use_function.html) for how to perform lookup of data.
Also see
[the 'Using the deprecated hiera functions' documentation](https://docs.puppet.com/puppet/latest/hiera_use_hiera_functions.html)
for more information about the Hiera 3 functions.

## `hiera_include`

* `hiera_include()`

Assigns classes to a node using an
[array merge lookup](https://docs.puppetlabs.com/hiera/latest/lookup_types.html#array-merge)
that retrieves the value for a user-specified key from Hiera's data.

This function is deprecated in favor of the `lookup` function in combination with `include`.
While this function continues to work, it does **not** support:
* `lookup_options` stored in the data
* lookup across global, environment, and module layers

~~~puppet
# In site.pp, outside of any node definitions and below any top-scope variables:
lookup('classes', Array[String], 'unique').include
~~~

The `hiera_include` function requires:

- A string key name to use for classes.
- A call to this function (i.e. `hiera_include('classes')`) in your environment's
`sites.pp` manifest, outside of any node definitions and below any top-scope variables
that Hiera uses in lookups.
- `classes` keys in the appropriate Hiera data sources, with an array for each
`classes` key and each value of the array containing the name of a class.

The function takes up to three arguments, in this order:

1. A string key that Hiera searches for in the hierarchy. **Required**.
2. An optional default value to return if Hiera doesn't find anything matching the key.
    * If this argument isn't provided and this function results in a lookup failure, Puppet
    fails with a compilation error.
3. The optional name of an arbitrary
[hierarchy level](https://docs.puppetlabs.com/hiera/latest/hierarchy.html) to insert at the
top of the hierarchy. This lets you temporarily modify the hierarchy for a single lookup.
    * If Hiera doesn't find a matching key in the overriding hierarchy level, it continues
    searching the rest of the hierarchy.

The function uses an
[array merge lookup](https://docs.puppetlabs.com/hiera/latest/lookup_types.html#array-merge)
to retrieve the `classes` array, so every node gets every class from the hierarchy.

~~~ yaml
# Assuming hiera.yaml
# :hierarchy:
#   - web01.example.com
#   - common

# Assuming web01.example.com.yaml:
# classes:
#   - apache::mod::php

# Assuming common.yaml:
# classes:
#   - apache
~~~

~~~ puppet
# In site.pp, outside of any node definitions and below any top-scope variables:
hiera_include('classes', undef)

# Puppet assigns the apache and apache::mod::php classes to the web01.example.com node.
~~~

You can optionally generate the default value with a
[lambda](https://docs.puppetlabs.com/puppet/latest/reference/lang_lambdas.html) that
takes one parameter.

~~~ puppet
# Assuming the same Hiera data as the previous example:

# In site.pp, outside of any node definitions and below any top-scope variables:
hiera_include('classes') | $key | {"Key \'${key}\' not found" }

# Puppet assigns the apache and apache::mod::php classes to the web01.example.com node.
# If hiera_include couldn't match its key, it would return the lambda result,
# "Key 'classes' not found".
~~~

See
[the 'Using the lookup function' documentation](https://docs.puppet.com/puppet/latest/hiera_use_function.html) for how to perform lookup of data.
Also see
[the 'Using the deprecated hiera functions' documentation](https://docs.puppet.com/puppet/latest/hiera_use_hiera_functions.html)
for more information about the Hiera 3 functions.

## `hocon_data`

* `hocon_data(Struct[{path=>String[1]}] $options, Puppet::LookupContext $context)`
    * Return type(s): `Any`. 

The `hocon_data` is a hiera 5 `data_hash` data provider function.
See [the configuration guide documentation](https://docs.puppet.com/puppet/latest/hiera_config_yaml_5.html#configuring-a-hierarchy-level-built-in-backends) for
how to use this function.

Note that this function is not supported without a hocon library being present.

## `import`

* `import(Any *$args)`
    * Return type(s): `Any`. 

The import function raises an error when called to inform the user that import is no longer supported.

## `include`

* `include(Any *$names)`
    * Return type(s): `Any`. 

Include the specified classes
For documentation see the 3.x stub

## `info`

* `info(Any *$values)`
    * `*values` --- The values to log.
    * Return type(s): `Undef`. 

Log a message on the server at level info.

## `inline_epp`

* `inline_epp(String $template, Optional[Hash[Pattern[/^\w+$/], Any]] $parameters)`
    * Return type(s): `Any`. 

Evaluates an Embedded Puppet (EPP) template string and returns the rendered
text result as a String.

`inline_epp('<EPP TEMPLATE STRING>', <PARAMETER HASH>)`

The first argument to this function should be a string containing an EPP
template. In most cases, the last argument is optional; if used, it should be a
[hash](/puppet/latest/reference/lang_data_hash.html) that contains parameters to
pass to the template.

- See the [template](/puppet/latest/reference/lang_template.html) documentation
for general template usage information.
- See the [EPP syntax](/puppet/latest/reference/lang_template_epp.html)
documentation for examples of EPP.

For example, to evaluate an inline EPP template and pass it the `docroot` and
`virtual_docroot` parameters, call the `inline_epp` function like this:

`inline_epp('docroot: <%= $docroot %> Virtual docroot: <%= $virtual_docroot %>',
{ 'docroot' => '/var/www/html', 'virtual_docroot' => '/var/www/example' })`

Puppet produces a syntax error if you pass more parameters than are declared in
the template's parameter tag. When passing parameters to a template that
contains a parameter tag, use the same names as the tag's declared parameters.

Parameters are required only if they are declared in the called template's
parameter tag without default values. Puppet produces an error if the
`inline_epp` function fails to pass any required parameter.

An inline EPP template should be written as a single-quoted string or
[heredoc](/puppet/latest/reference/lang_data_string.html#heredocs).
A double-quoted string is subject to expression interpolation before the string
is parsed as an EPP template.

For example, to evaluate an inline EPP template using a heredoc, call the
`inline_epp` function like this:

~~~ puppet
# Outputs 'Hello given argument planet!'
inline_epp(@(END), { x => 'given argument' })
<%- | $x, $y = planet | -%>
Hello <%= $x %> <%= $y %>!
END
~~~

## `inline_template`

* `inline_template()`
    * Return type(s): `Any`. 

Evaluate a template string and return its value.  See
[the templating docs](https://docs.puppetlabs.com/puppet/latest/reference/lang_template.html) for
more information. Note that if multiple template strings are specified, their
output is all concatenated and returned as the output of the function.

## `json_data`

* `json_data(Struct[{path=>String[1]}] $options, Puppet::LookupContext $context)`
    * Return type(s): `Any`. 

The `json_data` is a hiera 5 `data_hash` data provider function.
See [the configuration guide documentation](https://docs.puppet.com/puppet/latest/hiera_config_yaml_5.html#configuring-a-hierarchy-level-built-in-backends) for
how to use this function.

## `lest`

* `lest(Any $arg, Callable[0,0] &$block)`
    * Return type(s): `Any`. 

(Documented in 3.x stub)

## `lookup`

* `lookup(NameType $name, Optional[ValueType] $value_type, Optional[MergeType] $merge)`
    * Return type(s): `Any`. 
* `lookup(NameType $name, Optional[ValueType] $value_type, Optional[MergeType] $merge, DefaultValueType $default_value)`
    * Return type(s): `Any`. 
* `lookup(NameType $name, Optional[ValueType] $value_type, Optional[MergeType] $merge, BlockType &$block)`
    * Return type(s): `Any`. 
* `lookup(OptionsWithName $options_hash, Optional[BlockType] &$block)`
    * Return type(s): `Any`. 
* `lookup(Variant[String,Array[String]] $name, OptionsWithoutName $options_hash, Optional[BlockType] &$block)`
    * Return type(s): `Any`. 

Uses the Puppet lookup system to retrieve a value for a given key. By default,
this returns the first value found (and fails compilation if no values are
available), but you can configure it to merge multiple values into one, fail
gracefully, and more.

When looking up a key, Puppet will search up to three tiers of data, in the
following order:

1. Hiera.
2. The current environment's data provider.
3. The indicated module's data provider, if the key is of the form
   `<MODULE NAME>::<SOMETHING>`.

#### Arguments

You must provide the name of a key to look up, and can optionally provide other
arguments. You can combine these arguments in the following ways:

* `lookup( <NAME>, [<VALUE TYPE>], [<MERGE BEHAVIOR>], [<DEFAULT VALUE>] )`
* `lookup( [<NAME>], <OPTIONS HASH> )`
* `lookup( as above ) |$key| { # lambda returns a default value }`

Arguments in `[square brackets]` are optional.

The arguments accepted by `lookup` are as follows:

1. `<NAME>` (string or array) --- The name of the key to look up.
    * This can also be an array of keys. If Puppet doesn't find anything for the
    first key, it will try again with the subsequent ones, only resorting to a
    default value if none of them succeed.
2. `<VALUE TYPE>` (data type) --- A
[data type](https://docs.puppetlabs.com/puppet/latest/reference/lang_data_type.html)
that must match the retrieved value; if not, the lookup (and catalog
compilation) will fail. Defaults to `Data` (accepts any normal value).
3. `<MERGE BEHAVIOR>` (string or hash; see **"Merge Behaviors"** below) ---
Whether (and how) to combine multiple values. If present, this overrides any
merge behavior specified in the data sources. Defaults to no value; Puppet will
use merge behavior from the data sources if present, and will otherwise do a
first-found lookup.
4. `<DEFAULT VALUE>` (any normal value) --- If present, `lookup` returns this
when it can't find a normal value. Default values are never merged with found
values. Like a normal value, the default must match the value type. Defaults to
no value; if Puppet can't find a normal value, the lookup (and compilation) will
fail.
5. `<OPTIONS HASH>` (hash) --- Alternate way to set the arguments above, plus
some less-common extra options. If you pass an options hash, you can't combine
it with any regular arguments (except `<NAME>`). An options hash can have the
following keys:
    * `'name'` --- Same as `<NAME>` (argument 1). You can pass this as an
    argument or in the hash, but not both.
    * `'value_type'` --- Same as `<VALUE TYPE>` (argument 2).
    * `'merge'` --- Same as `<MERGE BEHAVIOR>` (argument 3).
    * `'default_value'` --- Same as `<DEFAULT VALUE>` (argument 4).
    * `'default_values_hash'` (hash) --- A hash of lookup keys and default
    values. If Puppet can't find a normal value, it will check this hash for the
    requested key before giving up. You can combine this with `default_value` or
    a lambda, which will be used if the key isn't present in this hash. Defaults
    to an empty hash.
    * `'override'` (hash) --- A hash of lookup keys and override values. Puppet
    will check for the requested key in the overrides hash _first;_ if found, it
    returns that value as the _final_ value, ignoring merge behavior. Defaults
    to an empty hash.

Finally, `lookup` can take a lambda, which must accept a single parameter.
This is yet another way to set a default value for the lookup; if no results are
found, Puppet will pass the requested key to the lambda and use its result as
the default value.

#### Merge Behaviors

Puppet lookup uses a hierarchy of data sources, and a given key might have
values in multiple sources. By default, Puppet returns the first value it finds,
but it can also continue searching and merge all the values together.

> **Note:** Data sources can use the special `lookup_options` metadata key to
request a specific merge behavior for a key. The `lookup` function will use that
requested behavior unless you explicitly specify one.

The valid merge behaviors are:

* `'first'` --- Returns the first value found, with no merging. Puppet lookup's
default behavior.
* `'unique'` (called "array merge" in classic Hiera) --- Combines any number of
arrays and scalar values to return a merged, flattened array with all duplicate
values removed. The lookup will fail if any hash values are found.
* `'hash'` --- Combines the keys and values of any number of hashes to return a
merged hash. If the same key exists in multiple source hashes, Puppet will use
the value from the highest-priority data source; it won't recursively merge the
values.
* `'deep'` --- Combines the keys and values of any number of hashes to return a
merged hash. If the same key exists in multiple source hashes, Puppet will
recursively merge hash or array values (with duplicate values removed from
arrays). For conflicting scalar values, the highest-priority value will win.
* `{'strategy' => 'first'}`, `{'strategy' => 'unique'}`,
or `{'strategy' => 'hash'}` --- Same as the string versions of these merge behaviors.
* `{'strategy' => 'deep', <DEEP OPTION> => <VALUE>, ...}` --- Same as `'deep'`,
but can adjust the merge with additional options. The available options are:
    * `'knockout_prefix'` (string or undef) --- A string prefix to indicate a
    value should be _removed_ from the final result. If a value is exactly equal
    to the prefix, it will knockout the entire element. Defaults to `undef`, which
    disables this feature.
    * `'sort_merged_arrays'` (boolean) --- Whether to sort all arrays that are
    merged together. Defaults to `false`.
    * `'merge_hash_arrays'` (boolean) --- Whether to merge hashes within arrays.
    Defaults to `false`.

## `map`

* `map(Hash[Any, Any] $hash, Callable[2,2] &$block)`
    * Return type(s): `Any`. 
* `map(Hash[Any, Any] $hash, Callable[1,1] &$block)`
    * Return type(s): `Any`. 
* `map(Iterable $enumerable, Callable[2,2] &$block)`
    * Return type(s): `Any`. 
* `map(Iterable $enumerable, Callable[1,1] &$block)`
    * Return type(s): `Any`. 

Applies a [lambda](https://docs.puppetlabs.com/puppet/latest/reference/lang_lambdas.html)
to every value in a data structure and returns an array containing the results.

This function takes two mandatory arguments, in this order:

1. An array, hash, or other iterable object that the function will iterate over.
2. A lambda, which the function calls for each element in the first argument. It can
request one or two parameters.

`$transformed_data = $data.map |$parameter| { <PUPPET CODE BLOCK> }`

or

`$transformed_data = map($data) |$parameter| { <PUPPET CODE BLOCK> }`

When the first argument (`$data` in the above example) is an array, Puppet passes each
value in turn to the lambda.

~~~ puppet
# For the array $data, return an array containing each value multiplied by 10
$data = [1,2,3]
$transformed_data = $data.map |$items| { $items * 10 }
# $transformed_data contains [10,20,30]
~~~

When the first argument is a hash, Puppet passes each key and value pair to the lambda
as an array in the form `[key, value]`.

~~~ puppet
# For the hash $data, return an array containing the keys
$data = {'a'=>1,'b'=>2,'c'=>3}
$transformed_data = $data.map |$items| { $items[0] }
# $transformed_data contains ['a','b','c']
~~~

When the first argument is an array and the lambda has two parameters, Puppet passes the
array's indexes (enumerated from 0) in the first parameter and its values in the second
parameter.

~~~ puppet
# For the array $data, return an array containing the indexes
$data = [1,2,3]
$transformed_data = $data.map |$index,$value| { $index }
# $transformed_data contains [0,1,2]
~~~

When the first argument is a hash, Puppet passes its keys to the first parameter and its
values to the second parameter.

~~~ puppet
# For the hash $data, return an array containing each value
$data = {'a'=>1,'b'=>2,'c'=>3}
$transformed_data = $data.map |$key,$value| { $value }
# $transformed_data contains [1,2,3]
~~~

## `match`

* `match(String $string, Variant[Any, Type] $pattern)`
    * Return type(s): `Any`. 
* `match(Array[String] $string, Variant[Any, Type] $pattern)`
    * Return type(s): `Any`. 

Matches a regular expression against a string and returns an array containing the match
and any matched capturing groups.

The first argument is a string or array of strings. The second argument is either a
regular expression, regular expression represented as a string, or Regex or Pattern
data type that the function matches against the first argument.

The returned array contains the entire match at index 0, and each captured group at
subsequent index values. If the value or expression being matched is an array, the
function returns an array with mapped match results.

If the function doesn't find a match, it returns 'undef'.

~~~ ruby
$matches = "abc123".match(/[a-z]+[1-9]+/)
# $matches contains [abc123]
~~~

~~~ ruby
$matches = "abc123".match(/([a-z]+)([1-9]+)/)
# $matches contains [abc123, abc, 123]
~~~

~~~ ruby
$matches = ["abc123","def456"].match(/([a-z]+)([1-9]+)/)
# $matches contains [[abc123, abc, 123], [def456, def, 456]]
~~~

## `md5`

* `md5()`
    * Return type(s): `Any`. 

Returns a MD5 hash value from a provided string.

## `module_directory`

* `module_directory(String *$names)`
    * Return type(s): `Any`. 
* `module_directory(Array[String] *$names)`
    * Return type(s): `Any`. 

Finds an existing module and returns the path to its root directory.

The argument to this function should be a module name String
For example, the reference `mysql` will search for the
directory `<MODULES DIRECTORY>/mysql` and return the first
found on the modulepath.

This function can also accept:

* Multiple String arguments, which will return the path of the **first** module
 found, skipping non existing modules.
* An array of module names, which will return the path of the **first** module
 found from the given names in the array, skipping non existing modules.

The function returns `undef` if none of the given modules were found

## `new`

* `new(Type $type, Any *$args, Optional[Callable] &$block)`
    * Return type(s): `Any`. 

Returns a new instance of a data type.
(The documentation is maintained in the corresponding 3.x stub)

## `next`

* `next(Optional[Any] $value)`
    * Return type(s): `Any`. 

Make iteration continue with the next value optionally given a value for this iteration.
If a value is not given it defaults to `undef`

## `notice`

* `notice(Any *$values)`
    * `*values` --- The values to log.
    * Return type(s): `Undef`. 

Log a message on the server at level notice.

## `realize`

* `realize()`
    * Return type(s): `Any`. 

Make a virtual object real.  This is useful
when you want to know the name of the virtual object and don't want to
bother with a full collection.  It is slightly faster than a collection,
and, of course, is a bit shorter.  You must pass the object using a
reference; e.g.: `realize User[luke]`.

## `reduce`

* `reduce(Iterable $enumerable, Callable[2,2] &$block)`
    * Return type(s): `Any`. 
* `reduce(Iterable $enumerable, Any $memo, Callable[2,2] &$block)`
    * Return type(s): `Any`. 

Applies a [lambda](https://docs.puppetlabs.com/puppet/latest/reference/lang_lambdas.html)
to every value in a data structure from the first argument, carrying over the returned
value of each iteration, and returns the result of the lambda's final iteration. This
lets you create a new value or data structure by combining values from the first
argument's data structure.

This function takes two mandatory arguments, in this order:

1. An array, hash, or other iterable object that the function will iterate over.
2. A lambda, which the function calls for each element in the first argument. It takes
two mandatory parameters:
    1. A memo value that is overwritten after each iteration with the iteration's result.
    2. A second value that is overwritten after each iteration with the next value in the
    function's first argument.

`$data.reduce |$memo, $value| { ... }`

or

`reduce($data) |$memo, $value| { ... }`

You can also pass an optional "start memo" value as an argument, such as `start` below:

`$data.reduce(start) |$memo, $value| { ... }`

or

`reduce($data, start) |$memo, $value| { ... }`

When the first argument (`$data` in the above example) is an array, Puppet passes each
of the data structure's values in turn to the lambda's parameters. When the first
argument is a hash, Puppet converts each of the hash's values to an array in the form
`[key, value]`.

If you pass a start memo value, Puppet executes the lambda with the provided memo value
and the data structure's first value. Otherwise, Puppet passes the structure's first two
values to the lambda.

Puppet calls the lambda for each of the data structure's remaining values. For each
call, it passes the result of the previous call as the first parameter ($memo in the
above examples) and the next value from the data structure as the second parameter
($value).

If the structure has one value, Puppet returns the value and does not call the lambda.

~~~ puppet
# Reduce the array $data, returning the sum of all values in the array.
$data = [1, 2, 3]
$sum = $data.reduce |$memo, $value| { $memo + $value }
# $sum contains 6

# Reduce the array $data, returning the sum of a start memo value and all values in the
# array.
$data = [1, 2, 3]
$sum = $data.reduce(4) |$memo, $value| { $memo + $value }
# $sum contains 10

# Reduce the hash $data, returning the sum of all values and concatenated string of all
# keys.
$data = {a => 1, b => 2, c => 3}
$combine = $data.reduce |$memo, $value| {
  $string = "${memo[0]}${value[0]}"
  $number = $memo[1] + $value[1]
  [$string, $number]
}
# $combine contains [abc, 6]
~~~

~~~ puppet
# Reduce the array $data, returning the sum of all values in the array and starting
# with $memo set to an arbitrary value instead of $data's first value.
$data = [1, 2, 3]
$sum = $data.reduce(4) |$memo, $value| { $memo + $value }
# At the start of the lambda's first iteration, $memo contains 4 and $value contains 1.
# After all iterations, $sum contains 10.

# Reduce the hash $data, returning the sum of all values and concatenated string of
# all keys, and starting with $memo set to an arbitrary array instead of $data's first
# key-value pair.
$data = {a => 1, b => 2, c => 3}
$combine = $data.reduce( [d, 4] ) |$memo, $value| {
  $string = "${memo[0]}${value[0]}"
  $number = $memo[1] + $value[1]
  [$string, $number]
}
# At the start of the lambda's first iteration, $memo contains [d, 4] and $value
# contains [a, 1].
# $combine contains [dabc, 10]
~~~

~~~ puppet
# Reduce a hash of hashes $data, merging defaults into the inner hashes.
$data = {
  'connection1' => {
    'username' => 'user1',
    'password' => 'pass1',
  },
  'connection_name2' => {
    'username' => 'user2',
    'password' => 'pass2',
  },
}

$defaults = {
  'maxActive' => '20',
  'maxWait'   => '10000',
  'username'  => 'defaultuser',
  'password'  => 'defaultpass',
}

$merged = $data.reduce( {} ) |$memo, $x| {
  $memo + { $x[0] => $defaults + $data[$x[0]] }
}
# At the start of the lambda's first iteration, $memo is set to {}, and $x is set to
# the first [key, value] tuple. The key in $data is, therefore, given by $x[0]. In
# subsequent rounds, $memo retains the value returned by the expression, i.e.
# $memo + { $x[0] => $defaults + $data[$x[0]] }.
~~~

## `regsubst`

* `regsubst(Variant[Array[String],String] $target, String $pattern, Variant[String,Hash[String,String]] $replacement, Optional[Optional[Pattern[/^[GEIM]*$/]]] $flags, Optional[Enum['N','E','S','U']] $encoding)`
    * Return type(s): `Any`. 
* `regsubst(Variant[Array[String],String] $target, Variant[Regexp,Type[Regexp]] $pattern, Variant[String,Hash[String,String]] $replacement, Optional[Pattern[/^G?$/]] $flags)`
    * Return type(s): `Any`. 

Perform regexp replacement on a string or array of strings.

## `require`

* `require(Any *$names)`
    * Return type(s): `Any`. 

Requires the specified classes
For documentation see the 3.x function stub

## `return`

* `return(Optional[Any] $value)`
    * Return type(s): `Any`. 

Make iteration continue with the next value optionally given a value for this iteration.
If a value is not given it defaults to `undef`

## `reverse_each`

* `reverse_each(Iterable $iterable)`
    * Return type(s): `Any`. 
* `reverse_each(Iterable $iterable, Callable[1,1] &$block)`
    * Return type(s): `Any`. 

Reverses the order of the elements of something that is iterable.
(Documentation in 3.x stub)

## `scanf`

* `scanf(String $data, String $format, Optional[Callable] &$block)`
    * Return type(s): `Any`. 

Scans a string and returns an array of one or more converted values based on the given format string.
See the documentation of Ruby's String#scanf method for details about the supported formats (which
are similar but not identical to the formats used in Puppet's `sprintf` function.)

This function takes two mandatory arguments: the first is the string to convert, and the second is
the format string. The result of the scan is an array, with each successfully scanned and transformed value.
The scanning stops if a scan is unsuccessful, and the scanned result up to that point is returned. If there
was no successful scan, the result is an empty array.

   "42".scanf("%i")

You can also optionally pass a lambda to scanf, to do additional validation or processing.


    "42".scanf("%i") |$x| {
      unless $x[0] =~ Integer {
        fail "Expected a well formed integer value, got '$x[0]'"
      }
      $x[0]
    }

## `sha1`

* `sha1()`
    * Return type(s): `Any`. 

Returns a SHA1 hash value from a provided string.

## `sha256`

* `sha256()`
    * Return type(s): `Any`. 

Returns a SHA256 hash value from a provided string.

## `shellquote`

* `shellquote()`
    * Return type(s): `Any`. 

\
Quote and concatenate arguments for use in Bourne shell.

Each argument is quoted separately, and then all are concatenated
with spaces.  If an argument is an array, the elements of that
array is interpolated within the rest of the arguments; this makes
it possible to have an array of arguments and pass that array to
shellquote instead of having to specify each argument
individually in the call.

## `slice`

* `slice(Hash[Any, Any] $hash, Integer[1, default] $slice_size, Optional[Callable] &$block)`
    * Return type(s): `Any`. 
* `slice(Iterable $enumerable, Integer[1, default] $slice_size, Optional[Callable] &$block)`
    * Return type(s): `Any`. 

This function takes two mandatory arguments: the first should be an array or hash, and the second specifies
the number of elements to include in each slice.

When the first argument is a hash, each key value pair is counted as one. For example, a slice size of 2 will produce
an array of two arrays with key, and value.

    $a.slice(2) |$entry|          { notice "first ${$entry[0]}, second ${$entry[1]}" }
    $a.slice(2) |$first, $second| { notice "first ${first}, second ${second}" }

The function produces a concatenated result of the slices.

    slice([1,2,3,4,5,6], 2) # produces [[1,2], [3,4], [5,6]]
    slice(Integer[1,6], 2)  # produces [[1,2], [3,4], [5,6]]
    slice(4,2)              # produces [[0,1], [2,3]]
    slice('hello',2)        # produces [[h, e], [l, l], [o]]


You can also optionally pass a lambda to slice.

    $a.slice($n) |$x| { ... }
    slice($a) |$x| { ... }

The lambda should have either one parameter (receiving an array with the slice), or the same number
of parameters as specified by the slice size (each parameter receiving its part of the slice).
If there are fewer remaining elements than the slice size for the last slice, it will contain the remaining
elements. If the lambda has multiple parameters, excess parameters are set to undef for an array, or
to empty arrays for a hash.

    $a.slice(2) |$first, $second| { ... }

## `split`

* `split(String $str, String $pattern)`
    * Return type(s): `Any`. 
* `split(String $str, Regexp $pattern)`
    * Return type(s): `Any`. 
* `split(String $str, Type[Regexp] $pattern)`
    * Return type(s): `Any`. 

Splits a string into an array using a given pattern.
The pattern can be a string, regexp or regexp type.

```puppet
$string     = 'v1.v2:v3.v4'
$array_var1 = split($string, /:/)
$array_var2 = split($string, '[.]')
$array_var3 = split($string, Regexp['[.:]'])

#`$array_var1` now holds the result `['v1.v2', 'v3.v4']`,
# while `$array_var2` holds `['v1', 'v2:v3', 'v4']`, and
# `$array_var3` holds `['v1', 'v2', 'v3', 'v4']`.
```

Note that in the second example, we split on a literal string that contains
a regexp meta-character (`.`), which must be escaped.  A simple
way to do that for a single character is to enclose it in square
brackets; a backslash will also escape a single character.

## `sprintf`

* `sprintf()`
    * Return type(s): `Any`. 

Perform printf-style formatting of text.

The first parameter is format string describing how the rest of the parameters should be formatted.
See the documentation for the `Kernel::sprintf` function in Ruby for all the details.

## `step`

* `step(Iterable $iterable, Integer[1] $step)`
    * Return type(s): `Any`. 
* `step(Iterable $iterable, Integer[1] $step, Callable[1,1] &$block)`
    * Return type(s): `Any`. 

(Documentation in 3.x stub)

## `strftime`

* `strftime(Timespan $time_object, String $format)`
    * Return type(s): `Any`. 
* `strftime(Timestamp $time_object, String $format, Optional[String] $timezone)`
    * Return type(s): `Any`. 
* `strftime(String $format, Optional[String] $timezone)`
    * Return type(s): `Any`. 

(Documentation in 3.x stub)

## `tag`

* `tag()`
    * Return type(s): `Any`. 

Add the specified tags to the containing class
or definition.  All contained objects will then acquire that tag, also.

## `tagged`

* `tagged()`
    * Return type(s): `Any`. 

A boolean function that
tells you whether the current container is tagged with the specified tags.
The tags are ANDed, so that all of the specified tags must be included for
the function to return true.

## `template`

* `template()`
    * Return type(s): `Any`. 

Loads an ERB template from a module, evaluates it, and returns the resulting
value as a string.

The argument to this function should be a `<MODULE NAME>/<TEMPLATE FILE>`
reference, which will load `<TEMPLATE FILE>` from a module's `templates`
directory. (For example, the reference `apache/vhost.conf.erb` will load the
file `<MODULES DIRECTORY>/apache/templates/vhost.conf.erb`.)

This function can also accept:

* An absolute path, which can load a template file from anywhere on disk.
* Multiple arguments, which will evaluate all of the specified templates and
return their outputs concatenated into a single string.

## `then`

* `then(Any $arg, Callable[1,1] &$block)`
    * Return type(s): `Any`. 

(Documented in 3.x stub)

## `tree_each`

* `tree_each(Variant[Iterator, Array, Hash, Object] $tree, Optional[OptionsType] $options, Callable[2,2] &$block)`
    * Return type(s): `Any`. 
* `tree_each(Variant[Iterator, Array, Hash, Object] $tree, Optional[OptionsType] $options, Callable[1,1] &$block)`
    * Return type(s): `Any`. 
* `tree_each(Variant[Iterator, Array, Hash, Object] $tree, Optional[OptionsType] $options)`
    * Return type(s): `Any`. 

Any Puppet Type system data type can be used to filter what is
considered to be a container, but it must be a narrower type than one of
the default Array, Hash, Object types - for example it is not possible to make a
`String` be a container type.

~~~ puppet
$data = [1, {a => 'hello', b => [100, 200]}, [3, [4, 5]]]
$data.tree_each({container_type => Array, include_containers => false} |$v| { notice "$v" }
~~~

Would call the lambda 5 times with `1`, `{a => 'hello', b => [100, 200]}`, `3`, `4`, `5`

**Chaining** When calling `tree_each` without a lambda the function produces an `Iterator`
that can be chained into another iteration. Thus it is easy to use one of:

* `reverse_each` - get "leaves before root" 
* `filter` - prune the tree
* `map` - transform each element
* `reduce` - produce something else

Note than when chaining, the value passed on is a `Tuple` with `[path, value]`.

~~~ puppet
# A tree of some complexity (here very simple for readability)
$tree = [
 { name => 'user1', status => 'inactive', id => '10'},
 { name => 'user2', status => 'active', id => '20'}
]
notice $tree.tree_each.filter |$v| {
 $value = $v[1]
 $value =~ Hash and $value[status] == active
}
~~~

Would notice `[[[1], {name => user2, status => active, id => 20}]]`, which can then be processed
further as each filtered result appears as a `Tuple` with `[path, value]`.


For general examples that demonstrates iteration see the Puppet
[iteration](https://docs.puppetlabs.com/puppet/latest/reference/lang_iteration.html)
documentation.

## `type`

* `type(Any $value, Optional[Enum[detailed]] $inference_method)`
    * Return type(s): `Any`. 
* `type(Any $value, Enum[reduced] $inference_method)`
    * Return type(s): `Any`. 
* `type(Any $value, Enum[generalized] $inference_method)`
    * Return type(s): `Any`. 

(Documentation in 3.x stub)

## `unique`

* `unique(String $string, Optional[Callable[String]] &$block)`
    * Return type(s): `Any`. 
* `unique(Hash $hash, Optional[Callable[Any]] &$block)`
    * Return type(s): `Any`. 
* `unique(Array $array, Optional[Callable[Any]] &$block)`
    * Return type(s): `Any`. 
* `unique(Iterable $iterable, Optional[Callable[Any]] &$block)`
    * Return type(s): `Any`. 

The `unique` function returns a unique set of values from an `Iterable` argument.

* If the argument is a `String`, the unique set of characters are returned as a new `String`.
* If the argument is a `Hash`, the resulting hash associates a set of keys with a set of unique values.
* For all other types of `Iterable` (`Array`, `Iterator`) the result is an `Array` with
  a unique set of entries.
* Comparison of all `String` values are case sensitive.
* An optional code block can be given - if present it is given each candidate value and its return is used instead of the given value. This
  enables transformation of the value before comparison. The result of the lambda is only used for comparison.
* The optional code block when used with a hash is given each value (not the keys).

~~~puppet
# will produce 'abc'
"abcaabb".unique
~~~

~~~puppet
# will produce ['a', 'b', 'c']
['a', 'b', 'c', 'a', 'a', 'b'].unique
~~~

~~~puppet
# will produce { ['a', 'b'] => [10], ['c'] => [20]}
{'a' => 10, 'b' => 10, 'c' => 20}.unique

# will produce { 'a' => 10, 'c' => 20 } (use first key with first value)
Hash.new({'a' => 10, 'b' => 10, 'c' => 20}.unique.map |$k, $v| { [ $k[0] , $v[0]] })

# will produce { 'b' => 10, 'c' => 20 } (use last key with first value)
Hash.new({'a' => 10, 'b' => 10, 'c' => 20}.unique.map |$k, $v| { [ $k[-1] , $v[0]] })
~~~

~~~
# will produce [3, 2, 1]
[1,2,2,3,3].reverse_each.unique
~~~

~~~puppet
# will produce [['sam', 'smith'], ['sue', 'smith']]
[['sam', 'smith'], ['sam', 'brown'], ['sue', 'smith']].unique |$x| { $x[0] }

# will produce [['sam', 'smith'], ['sam', 'brown']]
[['sam', 'smith'], ['sam', 'brown'], ['sue', 'smith']].unique |$x| { $x[1] }

# will produce ['aBc', 'bbb'] (using a lambda to make comparison using downcased (%d) strings)
['aBc', 'AbC', 'bbb'].unique |$x| { String($x,'%d') }

# will produce {[a] => [10], [b, c, d, e] => [11, 12, 100]}
{a => 10, b => 11, c => 12, d => 100, e => 11}.unique |$v| { if $v > 10 { big } else { $v } } 
~~~

Note that for `Hash` the result is slightly different than for the other data types. For those the result contains the
*first-found* unique value, but for `Hash` it contains associations from a set of keys to the set of values clustered by the
equality lambda (or the default value equality if no lambda was given). This makes the `unique` function more versatile for hashes
in general, while requiring that the simple computation of "hash's unique set of values" is performed as `$hsh.map |$k, $v| { $v }.unique`.
(A unique set of hash keys is in general meaningless (since they are unique by definition) - although if processed with a different
lambda for equality that would be different. First map the hash to an array of its keys if such a unique computation is wanted). 
If the more advanced clustering is wanted for one of the other data types, simply transform it into a `Hash` as shown in the
following example.

~~~puppet
# Array ['a', 'b', 'c'] to Hash with index results in
# {0 => 'a', 1 => 'b', 2 => 'c'}
Hash(['a', 'b', 'c'].map |$i, $v| { [$i, $v]})

# String "abc" to Hash with index results in
# {0 => 'a', 1 => 'b', 2 => 'c'}
Hash(Array("abc").map |$i,$v| { [$i, $v]})
"abc".to(Array).map |$i,$v| { [$i, $v]}.to(Hash)
~~~

## `unwrap`

* `unwrap(Sensitive $arg, Optional[Callable] &$block)`
    * Return type(s): `Any`. 

Unwraps a Sensitive value and returns the wrapped object.

~~~puppet
$plaintext = 'hunter2'
$pw = Sensitive.new($plaintext)
notice("Wrapped object is $pw") #=> Prints "Wrapped object is Sensitive [value redacted]"
$unwrapped = $pw.unwrap
notice("Unwrapped object is $unwrapped") #=> Prints "Unwrapped object is hunter2"
~~~

You can optionally pass a block to unwrap in order to limit the scope where the
unwrapped value is visible.

~~~puppet
$pw = Sensitive.new('hunter2')
notice("Wrapped object is $pw") #=> Prints "Wrapped object is Sensitive [value redacted]"
$pw.unwrap |$unwrapped| {
  $conf = inline_template("password: ${unwrapped}\n")
  Sensitive.new($conf)
} #=> Returns a new Sensitive object containing an interpolated config file
# $unwrapped is now out of scope
~~~

## `versioncmp`

* `versioncmp(String $a, String $b)`
    * Return type(s): `Any`. 

Compares two version numbers.

Prototype:

    \$result = versioncmp(a, b)

Where a and b are arbitrary version strings.

This function returns:

* `1` if version a is greater than version b
* `0` if the versions are equal
* `-1` if version a is less than version b

This function uses the same version comparison algorithm used by Puppet's
`package` type.

## `warning`

* `warning(Any *$values)`
    * `*values` --- The values to log.
    * Return type(s): `Undef`. 

Log a message on the server at level notice.

## `with`

* `with(Any *$arg, Callable &$block)`
    * Return type(s): `Any`. 

Call a [lambda](https://docs.puppet.com/puppet/latest/reference/lang_lambdas.html)
with the given arguments and return the result. Since a lambda's scope is
[local](https://docs.puppetlabs.com/puppet/latest/reference/lang_lambdas.html#lambda-scope)
to the lambda, you can use the `with` function to create private blocks of code within a
class using variables whose values cannot be accessed outside of the lambda.

~~~ puppet
# Concatenate three strings into a single string formatted as a list.
$fruit = with("apples", "oranges", "bananas") |$x, $y, $z| { 
  "${x}, ${y}, and ${z}" 
}
$check_var = $x
# $fruit contains "apples, oranges, and bananas"
# $check_var is undefined, as the value of $x is local to the lambda.
~~~

## `yaml_data`

* `yaml_data(Struct[{path=>String[1]}] $options, Puppet::LookupContext $context)`
    * Return type(s): `Any`. 



> **NOTE:** This page was generated from the Puppet source code on 2018-08-14 10:19:44 -0700