---
layout: default
title: "Puppet Strings style guide"
---


To document your module with Puppet Strings, add descriptive tags and comments for each class, defined type, function, and resource type or provider.

Strings uses these tags and comments, along with the structure of the module code, to generate complete reference information for your module. When you update your code, update your documentation comments at the same time.

This style guide applies to:

* Puppet Strings version 1.2 and later
* Puppet 4 and later

For information about the specific meaning of terms like 'must,' 'must not,' 'required,' 'should,' 'should not,' 'recommend,' 'may,' and 'optional,' see [RFC 2119](https://www.ietf.org/rfc/rfc2119.txt).

{:.section}
## The module README

Include basic module information and extended usage examples for common use cases in your module README. Strings generates reference information, but the README tells users what your module does and how to use it.

Strings does not generate information for type aliases or facts. If your module includes these elements, document them in your README.

The README should contain the following sections:

* Module description: What the module does and why it is useful.
* Setup: Prerequisites for module use and getting started information.
* Usage: Instructions and examples for common use cases or advanced configuration options.
* Reference: If the module contains facts or type aliases, include a short Reference section. All other Reference information is handled by Strings and is not included in the README.
* Limitations: OS compatibility and known issues.
* Development: Guide for contributing to the module.

{:.section}
## Comment style guidelines

Strings documentation comments inside module code follow these rules and guidelines:

* Place an element's documentation comment immediately before the code for that element. Do not put a blank line between the comment and its corresponding code.
* Each comment tag (such as `@example`) may have more than one line of comments. Indent additional lines with two spaces.
* Keep each comment line to no more than 140 characters, to improve readability.
* Separate comment sections (such as `@summary`, `@example`, or the `@param` list) with a blank comment line (that is, a `#` with no additional content) to improve readability.
* Untagged comments for a given element are output in an overview section that precedes all tagged information for that code element.
* If an element, such as a class or parameter, is deprecated, indicate it in the description for that element with **Deprecated** in bold.

{:.section}
### Classes and defined types

Document each class and defined type, along with its parameters, with comments before the code.

List the class and defined type information in the following order:

1. A `@summary` tag, a space, and then a summary describing the class or defined type.
1. Optional: Other tags such as `@see`, `@note`, or `@api private`.
1. Optional: Usage examples, each consisting of:
   1. An `@example` tag with a description of a usage example on the same line
   1. Code example showing how the class or defined type is used. This example should be directly under the `@example` tag and description, indented two spaces.
1. One `@param` tag for each parameter in the class or defined type. See the Parameters section for formatting guidelines.

{:.section}
### Parameters

Add parameter information as part of any class, defined type, or function that accepts parameters.

Parameter information should appear in the following order:

1. The `@param` tag, a space, and then the name of the parameter.
1. A description of what the parameter does. This may be either on the same line as the `@param` tag or on the next line, indented with two spaces.
1. Additional information about valid values that is not clear from the data type. For example, if the data type is [String], but the value must specifically be a path, say so here.
1. Other information about the parameter, such as warnings or special behavior.

For example:

```
# @param noselect_servers
#   Specifies one or more peers to not sync with. Puppet appends 'noselect' to each matching item in the `servers` array.
```


{:.example}
#### Example class

```
# @summary configures the Apache PHP module
#
# @example Basic usage
#   class { 'apache::mod::php':
#     package_name => 'mod_php5',
#     source       => '/etc/php/custom_config.conf',
#     php_version  => '7',
#   }
#
# @see http://php.net/manual/en/security.apache.php
#
# @param package_name
#   Names the package that installs mod_php
# @param package_ensure
#   Defines ensure for the PHP module package
# @param path
#   Defines the path to the mod_php shared object (.so) file.
# @param extensions
#   Defines an array of extensions to associate with PHP.
# @param content
#   Adds arbitrary content to php.conf.
# @param template
#   Defines the path to the php.conf template Puppet uses to generate the configuration file.
# @param source
#   Defines the path to the default configuration. Values include a puppet:/// path.
# @param root_group
#   Names a group with root access
# @param php_version
#   Names the PHP version Apache will be using.
#
class apache::mod::php (
  $package_name     = undef,
  $package_ensure   = 'present',
  $path             = undef,
  Array $extensions = ['.php'],
  $content          = undef,
  $template         = 'apache/mod/php.conf.erb',
  $source           = undef,
  $root_group       = $::apache::params::root_group,
  $php_version      = $::apache::params::php_version,
) { … }
```

{:.example}
#### Example defined type

```
# @summary
#   Create and configure a MySQL database.
#
# @example Create a database
#   mysql::db { 'mydb':
#     user     => 'myuser',
#     password => 'mypass',
#     host     => 'localhost',
#     grant    => ['SELECT', 'UPDATE'],
#   }
#
# @param name
#   The name of the database to create. (dbname)
# @param user
#   The user for the database you're creating.
# @param password
#   The password for $user for the database you're creating.
# @param dbname
#   The name of the database to create.
# @param charset
#   The character set for the database.
# @param collate
#   The collation for the database.
# @param host
#   The host to use as part of user@host for grants.
# @param grant
#   The privileges to be granted for user@host on the database.
# @param sql
#   The path to the sqlfile you want to execute. This can be single file specified as string, or it can be an array of strings.
# @param enforce_sql
#   Specifies whether executing the sqlfiles should happen on every run. If set to false, sqlfiles only run once.
# @param ensure
#   Specifies whether to create the database. Valid values are 'present', 'absent'. Defaults to 'present'.
# @param import_timeout
#   Timeout, in seconds, for loading the sqlfiles. Defaults to 300.
# @param import_cat_cmd
#   Command to read the sqlfile for importing the database. Useful for compressed sqlfiles. For example, you can use 'zcat' for .gz files.
#
```

{:.section}
### Functions

Put documentation comments for functions immediately before the function definition, and include the following information:

1. An untagged docstring describing what the function does.
1. One `@param` tag for each parameter in the function. See the Parameters section for formatting guidelines.
1. A `@return` tag with the data type and a description of the returned value.
1. Optionally, a usage example, consisting of:
   1. An `@example` tag with a description of a usage example on the same line.
   1. Code example showing how the function is used. This example should be directly under the `@example` tag and description, indented two spaces.
1. For custom Ruby functions, docs should come immediately before each ‘dispatch’ call.
1. For functions in Puppet, docs should come immediately before the function name.

{:.example}
#### Ruby function examples

This example function has one potential return type.

```
# An example 4.x function.
Puppet::Functions.create_function(:example) do
  # @param first The first parameter.
  # @param second The second parameter.
  # @return [String] Returns a string.
  # @example Calling the function
  #   example('hi', 10)
  dispatch :example do
    param 'String', :first
    param 'Integer', :second
  end

  # ...
end
```

If the function has more than one potential return type, specify a `@return` tag for each. Begin each tag string with ‘if’ to differentiate between cases.

```
# An example 4.x function.
Puppet::Functions.create_function(:example) do
  # @param first The first parameter.
  # @param second The second parameter.
  # @return [String] If second argument is less than 10, the name of one item.
  # @return [Array] If second argument is greater than 10, a list of item names.
  # @example Calling the function.
  #   example('hi', 10)
  dispatch :example do
    param 'String', :first
    param 'Integer', :second
  end

  # ...
end
```

{:.example}
#### Puppet function example

```
# @param name the name to say hello to.
# @return [String] Returns a string.
# @example Calling the function.
#    example(‘world’)
function example(String $name) {
    “hello, $name”
}
```

{:.section}
### Resource types

Add descriptions to the type and its attributes by passing either a here document (heredoc) or a short string to the `desc` method. Strings automatically detects much of the information for types, including the parameters and properties, collectively known as attributes.

To document the resource type itself, pass a here document (heredoc) to the `desc` method immediately after the type definition. Using a heredoc allows you to use multiple lines and String comment tags for your type documentation. For details about heredocs in Puppet, see [strings](./lang_data_string.html#heredocs) in the language reference.

For attributes, where a short description is usually enough, pass a string to `desc` in the attribute. Strings interprets text strings passed to `desc` in the same way it interprets the `@param` tag. Descriptions passed to `desc` should be no more than 140 characters. If you need a long description for an attribute, pass a heredoc to `desc` in the attribute itself.

You do not need to add tags for other method calls. Every other method call present in a resource type is automatically included and documented by Strings, and each attribute is updated accordingly in the final documentation. This includes method calls such as `defaultto`, `newvalue`, and `namevar`.

If your type dynamically generates attributes, document those attributes with the `@!puppet.type.param` and `@!puppet.type.property` tags before the type definition. You cannot use any other tags before the resource type definition.

Document the resource type description in the following order:

1. Directly under the type definition, indented two spaces, the `desc` method, with a heredoc including a descriptive delimiting keyword, such as `DESC`.
1. A `@summary` tag with a summary describing the type.
1. Optionally, usage examples, each consisting of:
   1. An `@example` tag with a description of a usage example on the same line.
   1. Code example showing how the type is used. This example should be directly under the `@example` tag and description, indented two spaces.

{:.example}
#### Example resource type

```
# @!puppet.type.param [value1, value2, value3] my_param Documentation for a dynamic parameter.
# @!puppet.type.property [foo, bar, baz] my_prop Documentation for a dynamic property.
Puppet::Type.newtype(:database) do
  desc <<-DESC
An example resource type.
@example Using the type.
  database { ‘foo’:
    qux => ‘hi’,
  }
DESC

     newproperty(:qux) do
       desc ‘Is a metasyntactic variable’
     end

     newparam(:foo) do`
    desc ‘Is another metasyntactic variable’
    defaultto “THE CLOUD”
  end
end
```

{:.section}
### Resource API type

For resource API types, follow the guidelines for standard resource types, but pass the heredoc or documentation string to a `desc` key in the data structure. You can include tags and multiple lines with the heredoc. Strings extracts the heredoc information along with other information from this data structure.

The heredoc and documentation strings that Strings uses are called out in comments in this code example:

{:.example}
#### Resource API example

```
Puppet::ResourceApi.register_type(
  name: 'apt_key',
  # HEREDOC BEGINS BELOW
  docs: <<-EOS,
@summary Fancy new type.
@example Fancy new example.
 apt_key { '6F6B15509CF8E59E6E469F327F438280EF8D349F':
   source => 'http://apt.puppetlabs.com/pubkey.gpg'
 }

This type provides Puppet with the capabilities to
manage GPG keys needed by apt to perform package validation. Apt has its own GPG keyring that can be manipulated through the `apt-key` command.

**Autorequires**:
If Puppet is given the location of a key file which looks like an absolute path this type will autorequire that file.
EOS
# HEREDOC ENDS
  attributes:   {
    ensure:      {
      type: 'Enum[present, absent]',
       # DOCS PASSED TO DESC:
       desc: 'Whether this apt key should be present or absent on the target system.'**
    },
    id:          {
      type:      'Variant[Pattern[/\A(0x)?[0-9a-fA-F]{8}\Z/], Pattern[/\A(0x)?[0-9a-fA-F]{16}\Z/], Pattern[/\A(0x)?[0-9a-fA-F]{40}\Z/]]',
      behaviour: :namevar,
       # DOCS PASSED TO DESC:
       desc:      'The ID of the key you want to manage.',**
    },
    # ...
    created:     {
      type:      'String',
      behavior: :read_only,
       # DOCS PASSED TO DESC:
       desc:      'Date the key was created, in ISO format.',**
    },
  },
  autorequires: {
    file:    '$source', # will evaluate to the value of the `source` attribute
    package: 'apt',
  },
)
```

{:.section}
### Puppet tasks and plans

Puppet Strings documents Puppet tasks automatically, taking all information from the task metadata. Document Puppet task plans just as you would a class or defined type, with tags and descriptions in the plan file.

List the plan information in the following order:


1. A `@summary` tag, a space, and then a summary describing the plan.
1. Optional: Other tags such as `@see`, `@note`, or `@api private`.
1. Optional: Usage examples, each consisting of:
   1. An `@example` tag with a description of a usage example on the same line
   1. Code example showing how the plan is used. This example should be directly under the `@example` tag and description, indented two spaces.
1. One `@param` tag for each parameter in the plan. See the Parameters section for formatting guidelines.

For example:

```puppet
# @summary A simple plan.
#
# @param param1
#   First param.
# @param param2
#   Second param.
# @param param3
#   Third param.
plan baz(String $param1, $param2, Integer $param3 = 1) {
  run_task('foo::bar', $param1, blerg => $param2)
}
```
