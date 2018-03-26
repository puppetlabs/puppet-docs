
NEEDS:

* WHAT IS IT? CONCEPT
* COMMAND REFERENCE
* STYLE GUIDE
* HOW TO PUPPET STRINGS
  * CREATE A MARKDOWN
  * GENERATE AND VIEW HTML DOCS
  * PUBLISHING TO THE FORGE


Puppet Strings combines source code and code comments to create complete, user-friendly documentation for modules.

Strings can generate documentation for classes, defined types, functions, and resource types in HTML, JSON, and Markdown formats. Instead of manually writing and formatting long reference lists, add descriptive tags and comments along with the code for each element (class, defined type, function) of your module. Strings automatically extracts some information, such as data types and attribute defaults from the code, so you need to add minimal documentation comments. Whenever you update code, update your documentation comments at the same time.

Strings outputs documentation as HTML, JSON, and Markdown.

HTML output includes the module README along with reference documentation for all classes, defined types, functions, and resource types. You can render the HTML in any browser.

JSON output includes the reference documentation only, and sends output to either STDOUT or to a file.

Markdown output includes reference documentation only, and writes the information to a REFERENCE.md file in the main module directory.

Related links:

* [Puppet Strings style guide]({{puppet}}/puppet_strings_style.html)
* [Module README Template]({{puppet}}/modules_documentation.html)
* [YARD Getting Started Guide](http://www.rubydoc.info/gems/yard/file/docs/GettingStarted.md)
* [YARD Tags Overview](http://www.rubydoc.info/gems/yard/file/docs/Tags.md)



{:.task}
## Install Puppet Strings

### Requirements

  * Ruby 2.1.9 or newer
  * Puppet 4.0 or newer
  * The `yard` Ruby gem

1. Install the YARD gem by running `gem install yard`
1. Install the `puppet-strings` gem by running `gem install puppet-strings`
1. **Optional**: Set YARD options for Strings.
   
   To use YARD options with Puppet Strings, specify a `yardopts` file in the same directory in which you run `puppet strings`. Puppet Strings supports the Markdown format and automatically sets the YARD `markup` option to `markdown`.
   
   To see a list of available YARD options, run `yard help doc`. For details about YARD options configuration, see the [YARD docs](http://www.rubydoc.info/gems/yard/file/docs/GettingStarted.md#config).


{:.concept}
## Generating documentation with Puppet Strings

By default, Puppet Strings outputs documentation as HTML, or you can specify JSON or Markdown output instead.

Strings generates reference documentation based on the code and Strings code comments in all Puppet and Ruby source files under the `./manifests/`, `./functions/`, `./lib/`, `./types/`, and `./tasks/` directories.

Strings outputs HTML of the reference information and the module README to the module's `./doc/` directory. This output can be rendered in any browser.

JSON and Markdown output include the reference documentation only. Strings sends JSON output to either STDOUT or to a file. Markdown output is written to a REFERENCE.md file in the module's main directory.

{:.task}
### Generate documentation in HTML

To generate HTML documentation for a Puppet module, run Strings from that module's directory.

1. Change directory into the module: `cd /modules/<MODULE_NAME>`.
2. Run the command: `puppet strings`.

To generate documentation for specific files or directories in a module, run the `puppet strings generate` subcommand and specify the files or directories as a space-separated list. 

```
puppet strings generate first.pp second.pp
```

To generate documentation for specific directories, run the `puppet strings generate` command and specify the directories:

```
$ puppet strings generate 'modules/foo/lib/**/*.rb' 'modules/foo/manifests/**/*.pp' 'modules/foo/functions/**/*.pp' ...
```

{:.task}
### Generate documentation in Markdown

Strings outputs documentation in Markdown to a Markdown file in the main directory of the module.

By default, Markdown output generates a `REFERENCE.md` file, but you can specify a different location or filename if you prefer. The generated Markdown includes reference information only. The `REFERENCE.md` file is the same format and information we are introducing into Puppet Supported modules.

1. Change directory into the module: `cd /modules/<MODULE_NAME>`.
2. Run the command: `puppet strings generate --format markdown`.

   To specify a different file, use the `--out` option and specify the path and filename:

   ```
   puppet strings generate --format markdown --out docs/INFO.md
   ```

{:.task}
### Generate documentation in JSON

Strings can generate a JSON file or print JSON to stdout. This can be useful for handling or displaying the data with your own custom applications.

By default, Strings prints JSON output to stdout.

1. Change directory into the module: `cd /modules/<MODULE_NAME>`.
2. Run the command: `puppet strings generate --format json`.

   To generate JSON documentation to a file instead, use the `--out` option and specify a filename:
   
   ```
   puppet strings generate --format json --out documentation.json
   ```

For details about Strings JSON output, see [Strings JSON schema](https://github.com/puppetlabs/puppet-strings/blob/master/JSON.md).

{:.concept}
## Viewing HTML documentation

Strings generates documentation as HTML, JSON, or Markdown in the module. You can view this documentation in any web browser or text editor, depending on the output.

For Markdown output, Strings creates a `REFERENCE.md` file in the main directory of the module. View this file by opening it in your text editor.

By default, Strings outputs documentation as HTML in a `/doc/` folder in the module. You can view the HTML for a single module or for all of your installed modules in any web browser.

{:.task}
### View HTML documentation for a single module

Strings generates documentation as HTML, JSON, or Markdown in the module. You can view this documentation in a web browser or text editor, depending on the output.

 To view the HTML documentation for a module

1. Change into the module's `/doc` directory by running `cd <MODULE_NAME>/doc`
2. Open the index page by running `open _index.html`


If you specify Markdown output, Strings creates a `REFERENCE.md` file in the main directory of the module. View this file the same way you would view any 

{:.task}
### View HTML documentation for all installed modules

You can view HTML documentation for all your local modules with the `server` action.

This action serves documentation for all modules in the [module path](https://docs.puppet.com/puppet/latest/reference/dirs_modulepath.html) at `http://localhost:8808`.

1. View HTML documentation in your web browser by running `puppet strings server`


{:.task}
## Publish documentation to GitHub Pages with Rake tasks

To publish generated HTML documentation to GitHub Pages, set up Rake tasks for Puppet Strings and generate your docs with a Rake task.

The `strings:gh_pages:update` tasks is available in `puppet-strings/tasks`.

This task:

1. Creates a `doc` directory in the root of your project.
1. Creates a `gh-pages` branch of the current repository, if it doesn't already exist.
1. Checks out the `gh-pages` branch of the current repository.
1. Generates Strings documentation.
1. Commits the changes and pushes them to the `gh-pages` branch with the `--force` flag.

This task keeps the `gh-pages` branch up to date with the current code and uses the `--force` option when pushing to the `gh-pages` branch.

{:.task}
### Set up Rake tasks

To set up Rake tasks, update your Gemfile and your Rakefile.

1.  Add the following to your Gemfile to use `puppet-strings`:

    ```ruby
    gem 'puppet-strings'
    ```

2.  Add the following to your `Rakefile` to use the `puppet-strings` tasks:

    ```ruby
    require 'puppet-strings/tasks'
    ```
   
    Adding this `require` automatically creates the Rake tasks below.


{:.task}
### Generate and push documentation to GitHub Pages

To generate Puppet Strings documentation and make it available on [GitHub Pages](https://pages.github.com/), use the `strings:gh_pages:update` task.

1. Generate and push your docs by running `strings:gh_pages:update`


## Reference

### `puppet strings` command

The `puppet strings` command generates module documentation based on code and code comments. 

By default, running `puppet strings` generates HTML documentation for a module into a `doc/` directory within that module. To pass any options or arguments, use the `generate` action.

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
`--out` | Specifies an output location for documentation | A valid directory location and filename.    | If not specified, outputs to default locations depending on format: HTML (`/docs/`), Markdown (main module directory), or JSON (stdout).
Filenames or directory paths | Outputs documentation for only specified files or directories. | Markdown, JSON.    | If not specified, Strings outputs HTML documentation.
`--verbose` | Logs verbosely. | none    | If not specified, Strings logs basic information.
`--debug` | Logs debug information. | none    | If not specified, Strings does not log debug information.
`--markup FORMAT` | The markup format to use for docstring text | "markdown", "textile", "rdoc", "ruby", "text", "html", or "none"    | By default, Strings outputs HTML, if no `--format` is specified or Markdown if `--format markdown` is specified.
`--help` | Displays help documentation for the command. | Markdown, JSON    | If not specified, Strings outputs HTML documentation.
## Reference


{:.section}
### Available Strings tags

[NOTE: THIS NEEDS TO BE A TABLE, BUT MAYBE I CAN WAIT TILL IT'S IN DITA]

* `@api`: Describes the resource as private or public, most commonly used with classes or defined types.
* `@example`: Shows an example snippet of code for an object. The first line is an optional title. See above for more about how to [include examples in documentation](#including-examples-in-documentation).
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
* `@raise`Documents any exceptions that can be raised by the given component. For example: `# @raise PuppetError this error will be raised if x`
* `@return`: Describes the return value (and type or types) of a method. You can list multiple return tags for a method if the method has distinct return cases. In this case, begin each case with "if".
* `@see`: Adds "see also" references. Accepts URLs or other code objects with an optional description at the end. Note that the URL or object is automatically linked by YARD and does not need markup formatting.
* `@since`: Lists the version in which the object was first added.
* `@summary`: A short description of the documented item.

## Additional Resources

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
