---
layout: default
title: "Puppet Development Kit"
canonical: "/pdk/1.0/pdk.html"
description: "About Puppet Development Kit, the shortest path to developing better Puppet code."
---

[workflow]: (./images/pdk-workflow.png)

Puppet Development Kit (PDK) is a package of development and testing tools to help you create great Puppet modules.

PDK includes key Puppet code development and testing tools for Linux, Windows, and OS X workstations, so you can install one package with the tools you need to create and validate new modules. PDK includes testing tools, a complete module skeleton, and command line tools to help you create, validate, and run tests on Puppet modules. PDK also includes all dependencies needed for its use.

PDK includes the following tools:

Tool   | Description
----------------|-------------------------
metadata-json-lint | Validates and lints `metadata.json` files in modules against  Puppet's module metadata style guidelines.
pdk | Generates and tests modules from the command line.
puppet-lint | Checks your Puppet code against the recommendations in the Puppet Language style guide.
puppet-syntax | Checks for correct syntax in Puppet manifests.
puppetlabs_spec_helper | Provides classes, methods, and Rake tasks to help with spec testing Puppet code.
rspec-puppet | Tests the behavior of Puppet when it compiles your manifests into a catalog of Puppet resources.
rspec-puppet-facts | Adds support for running rspec-puppet tests against the facts for your supported operating systems.

## Getting started

To get started, install PDK, create a module, and then create, validate, and test a class

![pkd workflow][workflow]

1. Generate a module using the `pdk new module` command.
1. Validate your module to verify that it is well-formed.
1. Unit test your module to verify that all dependencies and directories are present.
1. Generate a class for your module, using the `pdk new class` command.
1. Validate and unit test your module.

PDK can unit test code that it generates, but for any other code you add, you'll need to write unit tests. As you add code to your module, validate and unit test your module before and after adding code. This ensures that you are always developing on a clean, valid codebase.
