---
layout: default
title: "Puppet Development Kit release notes"
canonical: "/pdk/1.0/release_notes.html"
description: "Puppet Development Kit release notes"
---

Release notes for Puppet Development Kit (PDK), a development kit containing tools for developing and testing Puppet code. For known issues, see PDK [known issues](./known_issues.html)

## PDK 1.1.0.0

Released September 2017

### Bug fixes

#### Installing PDK in a non-default location caused an error

Installing PDK in a non-default location caused an error condition because the template URL was saved into the answer file. With this release, the template URL is no longer saved into the answer file. [PDK-430](https://tickets.puppetlabs.com/browse/PDK-430)

#### PDK package installation created unnecessary directories

PDK package installation created an unnecessary directory: `/etc/puppetlabs` on Linux, `/private/etc/puppetlabs` on OSX, `C:\Documents and Settings\$user\Application Data\PuppetLabs` on Windows. These directories are no longer created on installation

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

## PDK 1.0.1.0

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