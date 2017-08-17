---
layout: default
title: "Puppet Development Kit release notes"
---

Release notes for Puppet Development Kit (PDK), a development kit containing tools for developing and testing Puppet code.

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

### Known issues

#### `pdk test unit --list` output lacks information

Output from `pdk test unit --list` lacks detailed information and tests appear duplicated. To get the full text descriptions, execute the tests in JUnit format by running `pdk test unit --format=junit`.[PDK-374](https://tickets.puppetlabs.com/browse/PDK-374).

#### PowerShell errors if `Remove-Item` on the module directory

If you `Remove-Item` on a module folder, PowerShell errors because of a spec fixture symlink. To remove the module directory, use `-Force`: `Remove-Item -Recurse -Force <module_dir>` <!--SDK-316-->
