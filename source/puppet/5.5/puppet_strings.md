
Produce complete, user-friendly module documentation by using Puppet Strings. Strings uses special code comments and the source code to generate documentation for a module's classes, defined types, functions, and resource types and providers.

If you are a module author, add descriptive tags and comments with the code for each element (class, defined type, function) of your module. Strings extracts information from Puppet and Ruby code, such as data types and attribute defaults. Whenever you update code, update your documentation comments at the same time.

Both module users and authors can generate module documentation with Strings. Even if the module contains no code comments, Strings generates minimal documentation based on the information it can extract from the code.

Strings outputs documentation as HTML, JSON, or Markdown.

HTML output, which you can read in any web browser, includes the module README and reference documentation for all classes, defined types, functions, and resource types. 

JSON output includes the reference documentation only. You can write it either to `STDOUT` or to a file.

Markdown output includes the reference documentation only, and writes the information to a `REFERENCE.md` file.

**Related links**:

* [Puppet Strings style guide]({{puppet}}/puppet_strings_style.html)
* [Module README Template]({{puppet}}/modules_documentation.html)
* [YARD Getting Started Guide](http://www.rubydoc.info/gems/yard/file/docs/GettingStarted.md)
* [YARD Tags Overview](http://www.rubydoc.info/gems/yard/file/docs/Tags.md)

{:.task}
## Install Puppet Strings

Requires:

  * Ruby 2.1.9 or newer
  * Puppet 4.0 or newer
  * The `yard` Ruby gem

1. Install the YARD gem by running `gem install yard`
1. Install the `puppet-strings` gem by running `gem install puppet-strings`
1. **Optional**: Set YARD options for Strings.
   
   To use YARD options with Strings, specify a `yardopts` file in the same directory in which you run `puppet strings`. Strings supports the Markdown format and automatically sets the YARD `markup` option to `markdown`.
   
   To see a list of available YARD options, run `yard help doc` on the command line. For details about YARD options configuration, see the [YARD docs](http://www.rubydoc.info/gems/yard/file/docs/GettingStarted.md#config).


{:.concept}
## Generating documentation with Puppet Strings

Generate documentation in HTML, JSON, or Markdown by running Puppet Strings. Strings creates reference documentation based on the code and comments in all Puppet and Ruby source files under the `./manifests/`, `./functions/`, `./lib/`, `./types/`, and `./tasks/` directories.

By default, Strings outputs HTML of the reference information and the module README to the module's `./doc/` directory. You can open and read the generated HTML documentation in any browser.

If you specify JSON or Markdown output, documentation includes the reference information only. Strings writes Markdown output to a `REFERENCE.md` file, or sends JSON output either to `STDOUT` or to a file.

{:.task}
### Generate and view documentation in HTML

To generate HTML documentation for a Puppet module, run Strings from that module's directory:

1. Change directory into the module: `cd /modules/<MODULE_NAME>`
2. Run the command: `puppet strings`

Strings outputs HTML to the `./doc/` directory in the module.

To generate documentation for specific files or directories in a module, run the `puppet strings generate` subcommand and specify the files or directories as a space-separated list. 

For example:

```
puppet strings generate first.pp second.pp
```

or

```
$ puppet strings generate 'modules/foo/lib/**/*.rb' 'modules/foo/manifests/**/*.pp' 'modules/foo/functions/**/*.pp' ...
```

To view the generated HTML documentation for a module, open the `index.html` file in the module's `./doc/` folder.

To view HTML documentation for all of your local modules, run `puppet strings server` from any directory. This command serves documentation for all modules in the [module path](./dirs_modulepath.html) at `http://localhost:8808`.

{:.task}
### Generate documentation in Markdown

To generate reference documentation in Markdown, specify the `markdown` format when you run Strings. The reference documentation includes descriptions, usage details, and parameter information for classes, defined types, functions, and resource types and providers.

Strings generates Markdown output as a `REFERENCE.md` file in the main module directory, but you can specify a different filename or location with command line options.

1. Change directory into the module: `cd /modules/<MODULE_NAME>`
2. Run the command: `puppet strings generate --format markdown`

   To specify a different file, use the `--out` option and specify the path and filename:

   ```
   puppet strings generate --format markdown --out docs/INFO.md
   ```

View the Markdown file by opening it in a text editor or Markdown viewer.

{:.task}
### Generate documentation in JSON

To generate reference documentation as JSON output to a file or to standard output, specify the `json` format when you run Strings. JSON output is useful if you want to use the output in a custom application that reads JSON.

By default, Strings prints JSON output to `STDOUT`.

1. Change directory into the module: `cd /modules/<MODULE_NAME>`
2. Run the command: `puppet strings generate --format json`

   To generate JSON documentation to a file instead, use the `--out` option and specify a filename:
   
   ```
   puppet strings generate --format json --out documentation.json
   ```

For details about Strings JSON output, see [Strings JSON schema](https://github.com/puppetlabs/puppet-strings/blob/master/JSON.md).


{:.task}
## Publish documentation to GitHub Pages

To make your module documentation available on GitHub Pages, generate and publish HTML documentation with a Rake task.

The `strings:gh_pages:update` Rake task, available in `puppet-strings/tasks`, performs the following actions:

1. Creates a `doc` directory in the root of your project.
1. Creates a `gh-pages` branch of the current repository, if it doesn't already exist.
1. Checks out the `gh-pages` branch of the current repository.
1. Generates Strings documentation.
1. Commits the documentation and pushes it to the `gh-pages` branch with the `--force` flag.

This task keeps the `gh-pages` branch up to date with the current code and uses the `--force` option when pushing to the `gh-pages` branch.

Before you begin, update your Gemfile and your Rakefile.

1.  Add the following to your Gemfile to use `puppet-strings`:

    ```ruby
    gem 'puppet-strings'
    ```

2.  Add the following to your Rakefile to use the `puppet-strings` tasks:

    ```ruby
    require 'puppet-strings/tasks'
    ```
   
    Adding this `require` automatically creates the Rake tasks below.


To generate Puppet Strings documentation and publish it on [GitHub Pages](https://pages.github.com/), use the `strings:gh_pages:update` task.

1. Generate and push your docs by running `strings:gh_pages:update`

## Reference

### `puppet strings` command

The `puppet strings` command generates module documentation based on code and code comments.

By default, running `puppet strings` generates HTML documentation for a module into a `./doc/` directory within that module. To pass any options or arguments, use the `generate` action.

Usage: `puppet strings [--generate] [--server]`

Action   | Description   
----------------|-------------------------

`generate` | Generates documentation with any specified parameters, including format and output location.
`server` | Serves documentation for all modules in the [module path](https://docs.puppet.com/puppet/latest/reference/dirs_modulepath.html) locally at `http://localhost:8808`.

{:.section}
### `puppet strings generate` action

Usage: `puppet strings [generate] [--format <FORMAT>][--out <DESTINATION>] [<ARGUMENTS>]

For example:

```
puppet strings generate --format markdown --out docs/info.md
```

```
puppet strings generate manifest1.pp manifest2.pp
```

Option   | Description   | Values      | Default
----------------|:---------------:|:------------------:|-------------------------

`--format` | Specifies a format for documentation. | Markdown, JSON    | If not specified, Strings outputs HTML documentation.
`--out` | Specifies an output location for documentation | A valid directory location and filename.    | If not specified, outputs to default locations depending on format: HTML (`./doc/`), Markdown (main module directory), or JSON (`STDOUT`).
Filenames or directory paths | Outputs documentation for only specified files or directories. | Markdown, JSON.    | If not specified, Strings outputs HTML documentation.
`--verbose` | Logs verbosely. | none    | If not specified, Strings logs basic information.
`--debug` | Logs debug information. | none    | If not specified, Strings does not log debug information.
`--markup FORMAT` | The markup format to use for docstring text | "markdown", "textile", "rdoc", "ruby", "text", "html", or "none"    | By default, Strings outputs HTML, if no `--format` is specified or Markdown if `--format markdown` is specified.
`--help` | Displays help documentation for the command. | Markdown, JSON    | If not specified, Strings outputs HTML documentation.

{:.section}
### Available Strings tags

[TODO: THIS NEEDS TO BE A TABLE, BUT MAYBE I CAN WAIT TILL IT'S IN DITA]

* `@api`: Describes the resource as belonging to the private or public API. Specify as private, `# @api private`, to mark a module element, such as a class, as part of the private API.
* `@example`: Shows an example snippet of code for an object. The first line is an optional title, and any subsequent lines are automatically formatted as a code snippet. Use for specific examples of a given component. One example tag per example.
* `@param`: Documents a parameter with a given name, type and optional description.
* `@!puppet.type.param`: Documents dynamic type parameters. See [Documenting resource types and providers](#documenting-resource-types-and-providers) above.
* `@!puppet.type.property`: Documents dynamic type properties. See [Documenting resource types and providers](#documenting-resource-types-and-providers) above.
* `@option`: With a `@param` tag, defines what optional parameters the user can pass in an options hash to the method.
  For example:
  ```
  # @param [Hash] opts
  #      List of options
  # @option opts [String] :option1
  #      option 1 in the hash
  # @option opts [Array] :option2
  #      option 2 in the hash
  ```
* `@raise`: Documents any exceptions that can be raised by the given component. For example: `# @raise PuppetError this error will be raised if x`
* `@return`: Describes the return value (and type or types) of a method. You can list multiple return tags for a method if the method has distinct return cases. In this case, begin each case with `if`.
* `@see`: Adds "see also" references. Accepts URLs or other code objects with an optional description at the end. The URL or object is automatically linked by YARD and does not need markup formatting. Appears in the generated documentation as a "See Also" section. Use one tag per reference (website, related method, etc).
* `@since`: Lists the version in which the object was first added. Strings does not verify that the specified version exists. You are responsible for providing accurate information.
* `@summary`: A description of the documented item. This summary should be 140 characters or fewer.
