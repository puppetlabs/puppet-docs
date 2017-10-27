---
layout: default
title: "Puppet Development Kit release notes"
canonical: "/pdk/1.0/release_notes.html"
description: "Puppet Development Kit release notes"
---

Release notes for Puppet Development Kit (PDK), a development kit containing tools for developing and testing Puppet code. For known issues, see PDK [known issues](./known_issues.html).

## PDK 1.2.1

Released 26 Oct 2017

This is a security release that updates several components and dependencies bundled in PDK. For the complete list of resolved issues, see the [PDK project](https://tickets.puppetlabs.com/browse/PDK/fixforversion/27912).

### Bug fixes

#### `pdk validate` failed if the module directory and name did not match

When validating a module, validation for the `autoloader_layout` check failed if the module directory was not the exact module name. That is, if validating an ntp module, Puppet Lint passed `/path/ntp` but failed `/path/puppetlabs-ntp`. This release fixes the issue so that either of the examples would pass. [PDK PR 325](https://github.com/puppetlabs/pdk/pull/325)

## PDK 1.2.0

Released 10 October 2017

### New features

#### Creation of tasks

PDK can now create tasks in modules. Tasks allow you to perform ad hoc actions for on-demand infrastructure change. When you create a module, PDK creates an empty `./tasks` folder. When you create a task, PDK creates template files for the task (`<TASK>.sh`) and the task metadata (`<TASK.json`>. See the [Create a task](./pdk_generating_modules.html#create-a-task) topic for details.

#### PDK validates task metadata

When you run `pdk validate metadata`, PDK validates both module and task metadata files.

### Improvements

#### CLI help is improved

This release adds more context to ambiguous help output from `pdk help`. [PDK-482](https://tickets.puppetlabs.com/browse/PDK-482)

#### Module creation adds examples and files subdirectories

The `pdk new module` command now creates `./examples` and `./files` subdirectories in the new module, to provide hints on what is possible and where these things should go. [PDK-479](https://tickets.puppetlabs.com/browse/PDK-479)

### Bug fixes

#### Running PDK commands on Windows 7 failed

Trying to use PDK on Windows 7 resulted in access errors and Ruby failure. This release fixes the issue. [PDK-461](https://tickets.puppetlabs.com/browse/PDK-461)

#### Git version in PDK did not install some dependencies on Windows

The version of Git included in the PDK packages did not work correctly with Bundler on Windows, so gem dependencies specified in a module's Gemfile with a Git source were not correctly installed. This release fixes this issue. [PDK-502](https://tickets.puppetlabs.com/browse/PDK-502)

#### Module interview gave an incorrect licensing link

This release fixes an incorrect link to the spdx.org website in the new module interview. [PDK-543](https://tickets.puppetlabs.com/browse/PDK-543)

#### PDK validate failed to validate using Windows paths

This release fixes an issue where `puppet-lint` was not properly escaping bundle commands in Windows. There is a note added to the help text in PDK. The root cause will be fixed in a `puppet-lint` release. [PDK-555](https://tickets.puppetlabs.com/browse/PDK-555)

#### Validation stopped if errors were encountered

The `pdk validate` now runs all possible validators, even if one of them reports an error.


## PDK 1.1.0

Released 14 September 2017

### New features

#### Generation of defined types

PDK can now generate defined types in a module. Usage is almost identical to the class generation: `pdk new defined_type <name>`. For usage details, see [Generating modules](./pdk_generating_modules.html) and the PDK [Reference](./pdk_reference.html)

#### Selection of Operating System support when creating a new module

The module creation interview now asks which Operating Systems your module supports. You can select supported OSes from an interactive dialog menu.

### Improvements

#### Improved error output

* The `pdk test unit` provides improved error messages when unit tests fail to better show what went wrong. [PDK-369](https://tickets.puppetlabs.com/browse/PDK-369)

* Errors from `spec_prep` and `spec_clean` failures are improved to provide only relevant error information. [PDK-465](https://tickets.puppetlabs.com/browse/PDK-465)

* If you try to create a class that already exists, PDK gives an error instead of a fatal error. [PDK-415](https://tickets.puppetlabs.com/browse/PDK-415)

#### User-friendly help messages after generation of a module

After module creation, PDK tells you where the new module is located and what steps you can take next. [PDK-365](https://tickets.puppetlabs.com/browse/PDK-365)

### Bug fixes

#### Modules generated with PDK no longer depend on stdlib module by default

This release removes an unnecessary dependency on the puppetlabs-stdlib module in a newly generated module's `metadata.json`. [PDK-450](https://tickets.puppetlabs.com/browse/PDK-450)

#### Installing PDK in a non-default location caused an error

Installing PDK in a non-default location caused an error condition because the template URL was saved into the answer file. With this release, the template URL is no longer saved into the answer file. [PDK-430](https://tickets.puppetlabs.com/browse/PDK-430)

#### PDK package installation created unnecessary directories

PDK package installation created an unnecessary directory: `/etc/puppetlabs` on Linux, `/private/etc/puppetlabs` on OSX, `C:\Documents and Settings\$user\Application Data\PuppetLabs` on Windows. These directories are no longer created on installation. [PDK-424](https://tickets.puppetlabs.com/browse/PDK-424)

#### Generated `.gitattributes` file caused Ruby validation failure

An error in the generated `gitattributes` file caused Ruby style checking with Rubocop to fail. Now PDK configures `.gitattributes` to correctly match end-of-line behavior with the recommended Git attribute configuration, always requiring LF line ends. [PDK-443](https://tickets.puppetlabs.com/browse/PDK-443).

#### PDK module template contained a TravisCI configuration error

An error in the module template's TravisCI configuration (`.travis.yml`) caused TravisCI to not run any CI jobs. This was because the environment variable `CHECK`, which specifies what each TravisCI build job should do, was undefined. TravisCI now properly runs the unit tests and validators. [PDK-448](https://tickets.puppetlabs.com/browse/PDK-448)

#### PDK conflicted with the Puppet 5 gem

If Puppet 5 and PDK were both specified in a Bundler Gemfile, Puppet code within PDK conflicted with the Puppet 5 gem, causing an unhandled exception. [PDK-420](https://tickets.puppetlabs.com/browse/PDK-420)

#### PDK did not work correctly with PowerShell 2

This release improves the PowerShell integration so that PDK works on PowerShell 2, the standard version on Windows 7. [PDK-463](https://tickets.puppetlabs.com/browse/PDK-463)

#### PDK not added to PATH in some shells

PDK was not automatically added to the PATH in some shells, including zsh on Mac OS X and Debian. This issue is now resolved on our supported OSes. [PDK-446](https://tickets.puppetlabs.com/browse/PDK-446)

## PDK 1.0.1

Released 17 August 2017

### Bug fixes

#### PowerShell's PATH environment variable became corrupted

This release fixes an issue where the PATH environment variable on Windows PowerShell became corrupted, breaking all other PDK commands.

## Puppet Development Kit 1.0.0.1

Released 15 August 2017.

This is the first major release of Puppet Development Kit (PDK).

### New features

* Generates modules with a complete module skeleton, metadata, and README template.
* Generates classes.
* Generates unit test templates for classes.
* Validates `metadata.json` file.
* Validates Puppet code style and syntax.
* Validates Ruby style and syntax.
* Runs RSpec unit tests on modules and classes.