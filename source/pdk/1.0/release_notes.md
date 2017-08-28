---
layout: default
title: "Puppet Development Kit release notes"
canonical: "/pdk/1.0/release_notes.html"
description: "Puppet Development Kit release notes"
---

Release notes for Puppet Development Kit (PDK), a development kit containing tools for developing and testing Puppet code. For known issues, see PDK [known issues](./known_issues.html)

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