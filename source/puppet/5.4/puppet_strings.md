
NEEDS:

* WHAT IS IT? CONCEPT
* COMMAND REFERENCE
* STYLE GUIDE
* HOW TO PUPPET STRINGS
  * CREATE A MARKDOWN
  * GENERATE AND VIEW HTML DOCS
  * PUBLISHING TO THE FORGE


Puppet Strings combines source code and code comments to create complete, user-friendly documentation for modules.

Strings can generate module documentation for classes, defined types, functions, and resource types in HTML, JSON, and Markdown formats.

|                |                                                                 |
| -------------- |---------------------------------------------------------------- |
| *Code*         | [GitHub][repo]                                                  |
| *Issues*       | [Puppet JIRA Tracker][JIRA]                                     |
| *License*      | [Apache 2.0][LICENSE]                                           |
| *Change log*   | [CHANGELOG.md][changelog]                                       |
| *Contributing* | [CONTRIBUTING.md][contributing] and [COMMITTERS.md][committers] |

[repo]: https://github.com/puppetlabs/puppet-strings
[JIRA]: https://tickets.puppetlabs.com/browse/PDOC
[LICENSE]: https://github.com/puppetlabs/puppet-strings/blob/master/LICENSE
[changelog]: https://github.com/puppetlabs/puppet-strings/blob/master/CHANGELOG.md
[contributing]: https://github.com/puppetlabs/puppet-strings/blob/master/CONTRIBUTING.md
[committers]: https://github.com/puppetlabs/puppet-strings/blob/master/COMMITTERS.md

## Installing Puppet Strings

### Requirements

To run Strings, you need the following software:

  * Ruby 1.9.3 or newer
  * Puppet 3.7 or newer
  * The `yard` Ruby gem

Note that if you are running PE 3.8, you'll have a few extra steps to install puppet-strings.

### 1. Install the YARD Gem

The easiest way to install the `yard` gem is with Puppet itself:

For Puppet >= 4 and Puppet Enterprise 2015.2 and later:

```
$ puppet resource package yard provider=puppet_gem
```

For Puppet 3.x:

```
$ puppet resource package yard provider=gem
```

For Puppet Enterprise 3.8 (Linux):

```
GEM_HOME=/opt/puppet/lib/ruby/gems/1.9.1 puppet resource package yard provider=gem
```

For Puppet Enterprise 3.8 (Windows):

```
$env:GEM_HOME = "C:\Program Files\Puppet Labs\Puppet Enterprise\sys\ruby\lib\ruby\gems\2.0.0"
puppet resource package yard provider=gem
```

### 2. Puppet Enterprise 3.8 in Linux only: Install the redcarpet gem

```
GEM_HOME=/opt/puppet/lib/ruby/gems/1.9.1 puppet resource package redcarpet provider=gem
```

### 3. Install Puppet Strings

Install the [puppet-strings](https://rubygems.org/gems/puppet-strings) gem. To ensure that Strings is installed in the right place, install the gem with Puppet as shown below.

For Puppet 4.x and Puppet Enterprise 2015.2 and later:

```
$ puppet resource package puppet-strings provider=puppet_gem
```

For Puppet 3.x:

```
$ puppet resource package puppet-strings provider=gem
```

For Puppet Enterprise 3.8 (Linux):

```
GEM_HOME=/opt/puppet/lib/ruby/gems/1.9.1 puppet resource package puppet-strings provider=gem
```

For Puppet Enterprise 3.8 (Windows)

```
$env:GEM_HOME = "C:\Program Files\Puppet Labs\Puppet Enterprise\sys\ruby\lib\ruby\gems\2.0.0"
puppet resource package puppet-strings provider=gem
```

### 4. Optional: Set YARD options for Strings

Puppet Strings supports YARD options (on the command line, run `yard help doc` for a list of possible options. To set YARD options, specify a `yardopts` file in the same directory in which you run `puppet strings`. 

Puppet Strings supports the Markdown format and automatically sets the YARD `markup` option to `markdown`.

## Generating documentation with Puppet Strings

The `puppet strings` command processes the `README` file, as well as all Puppet and Ruby source files under the `./manifests/`, `./functions/`, and `./lib/`
directories, and then creates HTML documentation under the `./doc/` directory.

### Generate module documentation

To generate documentation for a Puppet module, run Strings from that module's directory. 

1. Change directory into the module: `cd /modules/sample-module`.
2. Run the command: `puppet strings`.

### Generate documentation for specific files

To generate documentation for specific files in a module, run the `puppet strings generate` subcommand and specify the files. 

```
puppet strings generate first.pp second.pp
```

To generate documentation for specific directories, run the `puppet strings generate` command and specify the directories:

```
$ puppet strings generate 'modules/foo/lib/**/*.rb' 'modules/foo/manifests/**/*.pp' 'modules/foo/functions/**/*.pp' ...
```

### Set additional options for document generation

If you need to specify additional options when generating documentation, use the `puppet strings:generate` rake task. This command behaves exactly as `puppet strings generate`, but allows you to add the following parameters:

* `patterns`: the search patterns to use for finding files to document (defaults to `manifests/**/*.pp functions/**/*.pp types/**/*.pp lib/**/*.rb`).
* `debug`: enables debug output when set to `true`.
* `backtrace`: enables backtraces for errors when set to `true`.
* `markup`: the markup language to use (defaults to `markdown`).
* `yard_args`: additional arguments to pass to YARD.

For setup and usage details for the `puppet strings:generate` task, see [Rake tasks](#rake-tasks).

## Viewing generated documentation

Strings generates documentation as HTML in a `./doc/` directory within the module for which you are generating documentation. Strings can also serve the generated docs locally or output documentation in JSON.

### Serve documents locally

Strings can serve the generated HTML documentation with the `server` action. This action serves documentation for all modules in the [module path](https://docs.puppet.com/puppet/latest/reference/dirs_modulepath.html) at `http://localhost:8808`.

To serve documentation locally, run:

```
$ puppet strings server
```

### Output documents in JSON

Strings can produce documentation in JSON and then either generate a `.json` file or print JSON to stdout. This can be useful for handling or displaying the data with your own custom applications.

To generate JSON documentation to a file, run:

```
$ puppet strings generate --format json --out documentation.json
```

To generate and then print JSON documentation to stdout, run:

```
$ puppet strings generate --format json
```

For details about Strings JSON output, see [Strings JSON schema](https://github.com/puppetlabs/puppet-strings/blob/master/JSON.md).

### Output documents in Markdown

Strings can also produce documentation in Markdown and then either generate an `.md` file or print Markdown to stdout. The generated markdown layout has been reviewed and approved by Puppet's tech pubs team and is the same that is used in Puppet Supported modules.

To generate REFERENCE.md:

```
$ puppet strings generate --format markdown
```

To write Markdown documentation to another file, use the --out option:

```
$ puppet strings generate --format markdown --out docs/INFO.md
```

### Output documents to GitHub Pages

To generate documents and then make them available on [GitHub Pages](https://pages.github.com/), use the Strings rake task `strings:gh_pages:update`. See [Rake tasks](#rake-tasks) for setup and usage details.

## Documenting Puppet code for Strings

Strings relies on code comments and YARD docstrings to specify documentation comments. Comments can include free-form text that is treated as a high-level overview for the element being documented. You can also include any number of YARD tags that hold semantic metadata for various aspects of the code. These tags allow you to add this data to the code without worrying about presentation.

### Documenting Puppet classes and defined types

To document Puppet classes and defined types, use a series of comments to create a YARD docstring before the class or defined type definition.

```puppet
# An example class.
#
# This is an example of how to document a Puppet class
#
# @summary A short summary of the purpose of the class.
#
# @example Declaring the class
#   include example
#
# @param first The first parameter for this class
# @param second The second parameter for this class
class example_class(
  String $first  = $example::params::first_arg,
  Integer $second = $example::params::second_arg,
) inherits example::params {
  # ...
}
```

The Strings elements appearing in the above comment block are:

* Three comment lines, not prefixed with tags, give the class description.
* The `@summary` YARD tag, which can be used for a short description of the class (fewer than 140 characters recommended).
* The `@example` YARD tag, immediately followed by an optional title.
* The `include` statement, which adds the usage example code.
* Two `@param` tags, with the name of the parameter first, followed by a string describing the parameter's purpose.

Puppet 4 is a typed language, so Puppet Strings automatically documents the parameter types from code. You may optionally include a parameter type in the `@param` tag. Strings will emit a warning and ignore the documented type should it differ from the actual type.

With Puppet 3 code, you must always include the parameter type with the `@param` tag:

```
# @param first [String] The first parameter for this class.
# @param second [Integer] The second parameter for this class.
```

Defined types are documented in exactly the same way as classes:

```
#
# This is an example of how to document a defined type.
# @param ports The array of port numbers to use.
define example_type(
   Array[Integer] $ports = []
) {
  # ...
}
```

### Documenting resource types and providers

To document resource types, pass descriptions for each parameter, property, and the resource type itself to the `desc` method. Each description can include other tags as well, including examples.

```ruby
Puppet::Type.newtype(:example) do
  desc <<-DESC
An example resource type.
@example Using the type.
  example { foo:
    param => 'hi'
  }
DESC

  newparam(:param) do
    desc 'An example parameter.'
    # ...
  end

  newproperty(:prop) do
    desc 'An example property.'
    #...
  end

  # ...  
end
```
 
If your resource type includes dynamically created parameters and properties, you must also use the `#@!puppet.type.param` and `#@!puppet.type.property` directives **before** the `newtype` call. This is necessary because Strings does not evaluate Ruby code, so it cannot detect dynamic attributes.

```ruby
# @!puppet.type.param [value1, value2, value3] my_param Documentation for a dynamic parameter.
# @!puppet.type.property [foo, bar, baz] my_prop Documentation for a dynamic property.
Puppet::Type.newtype(:example) do
  #...
end
```

Document providers similarly, again using the `desc` method:

```ruby
Puppet::Type.type(:example).provide :platform do
  desc 'An example provider.'

  # ...
end
```

All provider method calls, including `confine`, `defaultfor`, and `commands`, are automatically parsed and documented by Strings. The `desc` method is used to generate the docstring, and can include tags such as `@example` if written as a heredoc.

Document types that use the new [Resource API](https://github.com/puppetlabs/puppet-resource_api):

```ruby
Puppet::ResourceApi.register_type(
  name: 'database',
  docs: 'An example database server resource type.',
  attributes: {
    ensure: {
      type: 'Enum[present, absent, up, down]',
      desc: 'What state the database should be in.',
      default: 'up',
    },
    address: {
      type: 'String',
      desc: 'The database server name.',
      behaviour: :namevar,
    },
    encrypt: {
      type: 'Boolean',
      desc: 'Whether or not to encrypt the database.',
      default: false,
      behaviour: :parameter,
    },
  },
)
```

Here, the `docs` key acts like the `desc` method of the traditional resource type. Everything else is the same, except that now everything is a value in the data structure, not passed to methods.

**Note**: Puppet Strings can not evaluate your Ruby code, so only certain static expressions are supported.

### Documenting functions

Puppet Strings supports the documenting of defined functions with the Puppet 4 API, the Puppet 3 API, or in the Puppet language itself.

#### Document Puppet 4 functions

To document a function in the Puppet 4 API, use a YARD docstring before the `create_function` call and before any `dispatch` calls:

```ruby
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

**Note**: Puppet Strings automatically uses the parameter type information from the `dispatch` block to document the parameter types. Only document your parameter types when the Puppet 4.x function contains no `dispatch` calls.

If the Puppet 4 function contains multiple `dispatch` calls, Puppet Strings automatically creates `overload` tags to describe the function's overloads:

```ruby
# An example 4.x function.
Puppet::Functions.create_function(:example) do
  # Overload by string.
  # @param first The first parameter.
  # @return [String] Returns a string.
  # @example Calling the function
  #   example('hi')
  dispatch :example_string do
    param 'String', :first
  end

  # Overload by integer.
  # @param first The first parameter.
  # @return [Integer] Returns an integer.
  # @example Calling the function
  #   example(10)
  dispatch :example_integer do
    param 'Integer', :first
  end

  # ...
```

The resulting HTML for this example function documents both `example(String $first)` and `example(Integer $first)`.

#### Document Puppet 3 functions

To document a function in the Puppet 3 API, use the `doc` option to `newfunction`:

```ruby
Puppet::Parser::Functions.newfunction(:example, doc: <<-DOC
Documentation for an example 3.x function.
@param param1 [String] The first parameter.
@param param2 [Integer] The second parameter.
@return [Undef]
@example Calling the function.
  example('hi', 10)
DOC
) do |*args|
  #...
end
```

Because Puppet 3 is not typed in the way Puppet 4 is, specify the type for each parameter (for example, `@param [String]` for a string parameter). If a parameter type is omitted, a default of the `Any` Puppet type will be used.

#### Document Puppet language functions

To document Puppet functions written in the Puppet language, use a YARD docstring before the function definition:

```puppet
# An example function written in Pupppet.
# @param name The name to say hello to.
# @return [String] Returns a string.
# @example Calling the function
#   example('world')
function example(String $name) {
  "hello $name"
}
```

**Note**: Puppet Strings automatically uses the parameter type information from the function's parameter list to document the parameter types.

### Including examples in documentation

The `@example` YARD tag adds usage examples to any Ruby or Puppet language code.

```puppet
# @example String describing what this example demonstrates.
#   $content = example('world')
#   if $content == 'world' {
#     include world
#   }
function example(string $name) {
  "hello $name"
}
```

The string following the `@example` tag is an optional title which is displayed prominently above the code block.

The example body must begin on a newline underneath the tag, and each line of the example itself must be indented by
at least one space. Further indentation is preserved as preformatted text in the generated documentation.

### Including multi-line tag descriptions

You can spread tag descriptions across multiple lines, similar to multi-line examples, as long as subsequent lines are each uniformly indented by at least one space.

For example:

```puppet
# @param name The name the function uses to say hello. Note that this
#   description is extra long, so we've broken it up onto newlines for the sake
#   of readability.
function example(string $name) {
  "hello $name"
}
```

## Reference

### Available Strings tags

* `@api`: Describes the resource as private or public, most commonly used with classes or defined types.
* `@example`: Shows an example snippet of code for an object. The first line is an optional title. See above for more about how to [include examples in documentation](#including-examples-in-documentation).
* `@param`: Documents a parameter with a given name, type and optional description.
* `@!puppet.type.param`: Documents dynamic type parameters. See [Documenting resource types and providers](#documenting-resource-types-and-providers) above.
* `@!puppet.type.property`: Documents dynamic type properties. See [Documenting resource types and providers](#documenting-resource-types-and-providers) above.
* `@return`: Describes the return value (and type or types) of a method. You can list multiple return tags for a method if the method has distinct return cases. In this case, begin each case with "if".
* `@see`: Adds "see also" references. Accepts URLs or other code objects with an optional description at the end. Note that the URL or object is automatically linked by YARD and does not need markup formatting.
* `@since`: Lists the version in which the object was first added.
* `@summary`: A short description of the documented item.

### Rake tasks

You can use Puppet Strings rake tasks to generate documentation with additional options or to make your generated docs available on [GitHub Pages](https://pages.github.com/).

The `strings:generate` and `strings:gh_pages:update` tasks are available in `puppet-strings/tasks`.

First, update your Gemfile and your Rakefile.:

1.  Add the following to your Gemfile to use `puppet-strings`:

    ```ruby
    gem 'puppet-strings'
    ```

2.  Add the following to your `Rakefile` to use the `puppet-strings` tasks:

    ```ruby
    require 'puppet-strings/tasks'
    ```
   
    Adding this `require` automatically creates the Rake tasks below.

#### Generate documentation with additional options

Use the `strings:generate` task to generate documentation:

```
$ rake strings:generate
```

This command behaves exactly as `puppet strings generate`, but allows you to add the following parameters:

* `patterns`: the search patterns to use for finding files to document (defaults to `manifests/**/*.pp functions/**/*.pp types/**/*.pp lib/**/*.rb`).
* `debug`: enables debug output when set to `true`.
* `backtrace`: enables backtraces for errors when set to `true`.
* `markup`: the markup language to use (defaults to `markdown`).
* `yard_args`: additional arguments to pass to YARD.

For example, the task below adds a search pattern, debugs output, backtraces errors, sets the markup language to `markdown`, and passes an additional YARD argument setting the readme file to `README.md`:

```
$ rake strings:generate\['**/*{.pp\,.rb}, true, true, markdown, --readme README.md']
```

#### Generate documentation on GitHub Pages

To generate Puppet Strings documentation and make it available on [GitHub Pages](https://pages.github.com/), use the `strings:gh_pages:update` task.

This task:

1. Creates a `doc` directory in the root of your project.
2. Checks out the `gh-pages` branch of the current repository in the `doc` directory (it creates a branch if one does not already exist).
3. Generates Strings documentation with the `strings:generate` task.
4. Commits the changes and pushes them to the `gh-pages` branch **with the `--force` flag**.

This task aims to keep the `gh-pages` branch up to date with the current code and uses the `-f` flag when pushing to the `gh-pages` branch.

**Please note this operation is destructive if not used properly.**

### Additional Resources

Here are a few other good resources for getting started with documentation:

  * [Module README Template](https://docs.puppet.com/puppet/latest/reference/modules_documentation.html)
  * [YARD Getting Started Guide](http://www.rubydoc.info/gems/yard/file/docs/GettingStarted.md)
  * [YARD Tags Overview](http://www.rubydoc.info/gems/yard/file/docs/Tags.md)

## Developing and Contributing

We love contributions from the community!

If you'd like to contribute to puppet-strings, check out [CONTRIBUTING.md](https://github.com/puppetlabs/puppet-strings/blob/master/CONTRIBUTING.md) to get information on the contribution process.

### Running Specs

If you plan on developing features or fixing bugs in Puppet Strings, it is essential that you run specs before opening a pull request.

To run specs, run the `spec` rake task:

    $ bundle install --path .bundle/gems
    $ bundle exec rake spec

## Support

Please log tickets and issues in our [JIRA tracker][JIRA]. A [mailing list](https://groups.google.com/forum/?fromgroups#!forum/puppet-users) is available for asking questions and getting help from others.

There is also an active #puppet channel on the Freenode IRC network.

We use semantic version numbers for our releases and recommend that users upgrade to
patch releases and minor releases as they become available.

Bug fixes and ongoing development will occur in minor releases for the current major version. Security fixes will be ported to a previous major version on a best-effort basis, until the previous major version is no longer maintained.
