---
layout: default
title: "Puppet Development Kit command reference"
canonical: "/pdk/1.0/pdk_reference.html"
description: "Commands for Puppet Development Kit, the shortest path to developing better Puppet code."
---

## `pdk new module` command

Generates a new module.

Usage:

```
pdk new module [--template-url=<GIT_URL>] [--license=<IDENTIFIER>] <module_name> [<TARGET_DIR>]
```

The `pdk new module` command accepts the following arguments and options. Arguments are optional unless the Description indicates it is **Required**.

Argument   | Description   | Values      | Default
----------------|:---------------:|:------------------:|-------------------------
`--template-url=<GIT_URL>` | Overrides the template to use for this module. | A valid Git URL or path to a local template.    | Defaults to the current pdk-module-template.    | The current pdk-module-template.
`--license=<IDENTIFIER>` | Specifies the license for this module is written under. | See https://spdx.org/licenses/ for a list of open source licenses, or use `proprietary`.    | `Apache-2.0`
`--skip-interview` | questions. Default values for all metadata. | None    | Ask questions.
`<module_name>` | **Required**. Specifies the name of the module being created. | A module name beginning with a lowercase letter and including only lowercase letters, digits, and underscores.    | No default.
`<TARGET_DIR>` | Specifies the directory that the new module will be created in. | A valid directory path.    | Creates a directory with the given `module_name` inside the current directory.

## `pdk new class` command

Generates a new class and test templates for it in the current module.

Usage:

```
pdk new class [--template-url=<GIT_URL>] <class_name> [<parameter_name>[:<PARAMETER_TYPE>]]
```

For example:

```
cd my_module
pdk new class my_class
```

Argument   | Description   | Values      | Default
----------------|:---------------:|:------------------:|-------------------------
`--template-url=<GIT_URL>` | Overrides the template to use when generating this class. | A valid Git URL or path to a local template.   | Uses the template used to generate the module. If that template is not available, the default template at [puppetlabs/pdk-module-template](https://github.com/puppetlabs/pdk-module-template) is used.
`<class_name>` | **Required**. The name of the class to generate. | A class name beginning with a lowercase letter and including only lowercase letters, digits, and underscores.    | No default.

## `pdk new defined_type` command

Generates a new defined type and test templates for it in the current module.

Usage:

```
pdk new defined_type [--template-url=<GIT_URL>] <defined_type_name> [<parameter_name>[:<PARAMETER_TYPE>]]
```

For example:

```
cd my_module
pdk new defined_type my_defined_type
```

Argument   | Description   | Values      | Default
----------------|:---------------:|:------------------:|-------------------------
`--template-url=<GIT_URL>` | Overrides the template to use when generating this defined\_type. | A valid Git URL or path to a local template.   | Uses the template used to generate the module. If that template is not available, the default template at [puppetlabs/pdk-module-template](https://github.com/puppetlabs/pdk-module-template) is used.
`<defined_type_name>` | **Required**. The name of the defined type to generate. | A defined type name beginning with a lowercase letter and including only lowercase letters, digits, and underscores.    | No default.

## `pdk validate` command

Runs all static validations. Any errors are reported to the console in the format requested. The exit code is non-zero when errors occur.

Usage:

```
pdk validate --list
```

```
pdk validate [--format=<FORMAT>[:<TARGET_FILE>]] [<VALIDATIONS>] [<TARGETS>*]
```

Argument   | Description   | Values      | Default
----------------|:---------------:|:------------------:|-------------------------
`--auto-correct` | Automatically corrects some common code style problems | None.    | Off.
`--list` | Displays a list of available validations and their descriptions. Using this option lists the tests without running them. | None.    | No default.
`--format=<FORMAT>[:<TARGET_FILE>]` | Specifies the format of the output. Optionally, you can specify a target file for the given output format, for example `--format=junit:report.xml` | Specifies the output format and an output target file. Multiple `--format` options can be specified as long as they all have distinct output targets. | `junit` (JUnit XML), `text`(plain text).    | `text`
`--parallel` | Runs all validations simultaneously, using multiple threads. | None.    | No default.
`<VALIDATIONS>` | A comma-separated list of validations to run (or `all`) | See the `--list` output for a list of available validations.    | `all`
`<TARGETS>` | A list of directories or individual files to validate. Validations which are not applicable to individual files will be skipped for those files. | A space-separated list of directories or files.    | Validates all available directories and files.

## `pdk test unit` command

Runs unit tests. Errors are displayed to the console and reported in the target file, if specified. The exit code is non-zero when errors occur.

Usage:

```
pdk test unit --list
```

or

```
pdk test unit [--tests=<TEST_LIST>] [--format=<FORMAT>[:<TARGET_FILE>]]
```

Argument   | Description   | Values      | Default
----------------|:---------------:|:------------------:|-------------------------
`--list` | Displays a list of unit tests and their descriptions. Using this option lists the tests without running them. | None.    | No default.
`--tests=<TEST_LIST>` | A comma-separated list of tests to run. Use this during development to pinpoint a single failing test. | See the `--list` output for allowed values.    | No default.
`--format=<FORMAT>[:<TARGET_FILE>]` | Specifies the format of the output. Optionally, you can specify a target file for the given output format, for example:`--format=junit:report.xml`. Multiple `--format` options can be specified as long as they all have distinct output targets. | `junit` (JUnit XML), `text`(plain text).     | `text`
