---
layout: default
title: "Puppet Development Kit"
canonical: "/pdk/1.0/pdk.html"
description: "About the Puppet Development Kit, the shortest path to developing better Puppet code."
---

The Puppet Development Kit (PDK) is a package of development and testing tools to help you create great Puppet modules.

The PDK includes key Puppet code development and testing tools for Linux, Windows, and OS X workstations, so you can install one package with the tools you need to create and validate new modules. PDK includes testing tools, a complete module skeleton, and command line tools to help you create, validate, and run tests on Puppet modules. PDK also includes all dependencies needed for its use.

To get started, you'll create and test a module with PDK. 

1. Generate a module with PDK, using the `pdk new module` command.
1. Validate and unit test your module, to verify that the files and directories were created correctly.
1. Generate a new class for your module, using the `pdk new class` command.

These steps provide a basic workflow for development and testing with PDK. Then, as you add new code to your module, continue validating, testing, and iterating on your code as needed.

<!--TK: overview workflow graphic-->

PDK includes the following tools:

Tool   | Description
----------------|-------------------------
pdk | Command line tool for generating and testing modules
rspec-puppet | Tests the behavior of Puppet when it compiles your manifests into a catalog of Puppet resources.
puppet-lint | Checks your Puppet code against the recommendations in the Puppet Language style guide.
puppet-syntax | Checks for correct syntax in Puppet manifests, templates, and Hiera YAML.
metadata-json-lint | Validates and lints `metadata.json` files in modules against  Puppet's module metadatastyle guidelines.
rspec-puppet-facts | Adds support for running rspec-puppet tests against the facts for your supported operating systems.
puppetlabs_spec_helper | Provides classes, methods, and Rake tasks to help with spec testing Puppet code.


PDK docs:

* Installing the PDK package
* Getting started writing modules
* Contributing to PDK
* Sample module skeleton
* Troubleshooting PDK