---
layout: default
title: "Puppet Development Kit command reference"
canonical: "/pdk/pdk_reference.html"
description: "Commands for the Puppet Development Kit, the shortest path to developing better Puppet code."
---

## Reference

### `pdk new module` command

Generates a new module.

Usage:

```
pdk new module [--template-url=git_url] [--license=spdx_identifier] [--vcs=vcs_provider] module_name [target_dir]
```

The `pdk new module` command accepts the following arguments and options. Arguments are optional unless otherwise specified.

#### `--template-url=git_url`

Overrides the template to use for this module. If possible, please contribute your improvements back to the default template at [puppetlabs/pdk-module-template](https://github.com/puppetlabs/pdk-module-template).

#### `--license=spdx_identifier`

Specifies the license this module is written under. See https://spdx.org/licenses/ for a list of open source licenses, or use `proprietary`. Defaults to `Apache-2.0`.

#### `--vcs=vcs_provider`

Specifies the version control driver. Valid values: `git`, `none`. Default: `git`.

#### `--skip-interview`

Suppress interactive queries for initial values. All questions will use the default values.

#### `module_name`

**Required**. Specifies the name of the module being created, including the namespace. e.g.: `username-my_module`

#### `target_dir`

Specifies the directory that the new module will be created in. Defaults to creating a new directory with the given `module_name` inside the current directory.

### `pdk new class` command

Generates a new class and skeleton test for it in the current module.

Usage:

```
pdk new class [--template-url=git_url] <class_name> [parameter_name[:parameter_type]] [parameter_name[:parameter_type]] ...
```

e.g.

```
cd my_module
pdk new class my_class "ensure:Enum['absent', 'present']" version:String
```

#### `--template-url`

Overrides the template to use when generating this class. If this is not
specified, the template used to generate the module will be used instead. If
that template is not available, the default template at
[puppetlabs/pdk-module-template](https://github.com/puppetlabs/pdk-module-template)
will be used.

#### `class_name`

The name of the class to generate. If the class name is not inside the module
namespace (e.g. module name is `apt` and the class name is `source`, then the
module name will automatically be prepended to the class name (e.g.
`apt::source`).

#### `parameter_name[:parameter_type]`

If the class should take parameters, they can be specified on the command line
to be added to the generated class. Optionally, the data type of the parameter
can be specified along with the parameter name, separated by a colon. Any
number of parameters can be provided on the command line.

### `pdk add provider` command

Adds a new resource provider to an existing module.

Usage:

```
pdk add provider [--template-url=git_url] provider_name [data_type:attribute_name]*
```

The `pdk add provider` command accepts the following arguments. Arguments are optional unless specified.

#### `--template-url=git_url`

Overrides the template to use for this module. If possible please contribute your improvements back to the default template at [puppetlabs/pdk](https://github.com/puppetlabs/pdk).

#### `provider_name`

**Required**. Specifies the name of the resource provider being created.

#### `data_type:attribute_name`

Specifies a list of attributes with their expected data types, such as `'Enum[absent, present]:ensure'`. If not specified, the data type will have no attributes.

### `pdk validate` command

Runs all static validations. Any errors are reported to the console in the format requested. The exit code is non-zero when errors occur.

Usage:

```
pdk validate --list
```

```
pdk validate [--format=format[:target]] [validations] [targets*]
```

#### `--list`

Displays a list of available validations and their descriptions. Using this option lists the tests without running them.

#### `--format=format[:target]`

Specifies the format of the output. Valid values: `junit`, `text`. Default: `text`.

Optionally, you can specify a target file for the given output format with the syntax: `--format=junit:report.xml`

Multiple `--format` options can be specified as long as they all have distinct output targets.

#### `validations`

Specifies a comma separated list of validations to run (or `all`). See the `--list` output for a list of available validations. Defaults to `all` if not supplied.

#### `targets`

Specifies a list of directories or individual files to validate. Validations which are not applicable to individual files will be skipped for those files. Defaults to validating everything.

#### Additional Examples

```
$ pdk validate metadata
Running 'metadata' validation on `new_module`: OK!
```

```
$ pdk validate all lib/
Running validations on `new_module/lib`:
* ruby syntax: OK!
* puppet syntax: (no puppet manifests found)
```

#### `pdk test unit` command

Runs unit tests. Any errors are displayed to the console and reported in the report-file, if requested. The exitcode is non-zero when errors occur.

Usage:

```
pdk test unit [--list] [--tests=test_list] [--format=format[:target]] [runner_options]
```

#### `--list`

Displays a list of unit tests and their descriptions. Using this option lists the tests without running them.

#### `--tests=test_list`

A comma-separated list of tests to run. Use this during development to pinpoint a single failing test. See the `--list` output for allowed values.

#### `--format=format[:target]`

Specifies the format of the output. Valid values: `junit`, `text`. Default: `text`.

Optionally, you can specify a target file for the given output format with the syntax: `--format=junit:report.xml`

Multiple `--format` options can be specified as long as they all have distinct output targets.

#### `runner_options`

<!-- this is a cop-out; alternatives are surfacing the real runner to advanced users, or completely wrapping the runner's interface -->

Specifies options to pass through to the actual test-runner. In the default template (and most commonly across modules), this is [rspec](https://relishapp.com/rspec/rspec-core/docs/command-line).