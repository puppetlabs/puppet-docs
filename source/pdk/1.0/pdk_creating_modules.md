---
layout: default
title: "Creating a module with the Puppet Development Kit"
canonical: "/pdk/1.0/pdk_get_started.html"
description: "Creating a module with the Puppet Development Kit, the shortest path to developing better Puppet code."
---

[install]: ./pdk_install.html
[metadata]: {{puppet}}/modules_metadata.html
[fundamentals]: {{puppet}}/modules_fundamentals.html

{:.concept}
## Creating modules and classes with PDK

PDK creates the basic components of a module and sets up an infrastructure for testing it.

To create module metadata, PDK asks you a series of questions. Each question has a default response that PDK uses if you skip the question. The answers you provide to these questions are stored and used as the new defaults for subsequent module creations. PDK also adds a default set of supported operating systems to your metadata, which you can manually edit after module creation.

Optionally, you can skip the interview step and use the default answers for all metadata.

When you run the `pdk new module` command, the tool requests the following information:

* Your Puppet Forge user name. If you don't have a Forge account, you can accept the default value for this question. If you create a Forge account later, edit the module metadata manually with the correct value. 
* Module version. We use and recommend semantic versioning for modules.
* Your name.
* The license under which your module is made available, an identifier from [SPDX License List](https://spdx.org/licenses/).
* A list of operating systems your module supports.
* A one-sentence summary about your module.
* The URL to your module's source code repository, so that other users can contribute back to your module.
* The URL to a web site that offers full information about your module, if you have one.
* The URL to the public bug tracker for your module, if you have one.

After you create a module, validate and test the module _before_ you add classes or write new code in it. This allows you to verify that the module files and directories were correctly created.

When you have validated the module, create classes by running the `pdk new class` command. The new class command also creates a test template file for the class. You can then write tests in this template to validate your class's behavior.

Related topics:

* [Module metadata][metadata]

{:.task}
### Create a module with PDK

To create a module with a default template, use the `pdk new module` command.

Before you begin, ensure that you've installed the PDK package. If you are running PDK behind a proxy, be sure you've added the correct environment variables. See [Running PDK behind a proxy](./pdk_install.hmtl#running-pdk-behind-a-proxy) for details.

1. From the command line, run the new module command, specifying the name of the module: `pdk new module <MODULE_NAME>`
   
   Optionally, to skip the interview questions and create the module with default values, add the `skip-interview` flag: `pdk new module <MODULE_NAME> --skip-interview`

1. Respond to the PDK dialog questions. Each question indicates the default value it will use if you just press **Enter**.

   1. Forge username: Enter your Forge username, if you have a Forge account.
   2. Version: Enter the semantic version of your module, such as "0.1.0".
   3. Author: Enter the name of the module author (you or someone else responsible for the module's content).
   4. License: If you want to specify a license other than "Apache-2.0," specify that here, such as "MIT", or "proprietary".
   5. Operating System Support: Select which operating systems your module supports, choosing from the dialog menu.
   5. Description: Enter a one-sentence summary that helps other users understand what your module does.
   6. Source code repository: Enter the URL to your module's source code repository.
   7. Where others can learn more: If you have a website where users can learn more about your module, enter the URL.
   8. Where others can report issues: If you have a public bug tracker for your module, enter the URL.

1. If the metadata that PDK displays is correct, confirm to create the module. If it is incorrect, cancel and start over.

{:.reference}
### Module contents

PDK creates a basic module, a directory with a specific structure. This module contains directories and files you need to start developing and testing your module.

To learn the basics of what a Puppet module includes, see the related topic about module fundamentals.

PDK creates the following files and directories for your module:

Files and directories   | Description
----------------|-------------------------
Module directory | Directory with the same name as the module. Contains all of the module's files and directories.
`README.md` | File containing a README template for your module.
`Gemfile` | File describing Ruby gem dependencies.
`Rakefile` | File listing tasks and dependencies.
`appveyor.yml` | File containing configuration for Appveyor CI integration.
`.gitattributes` | Recommended defaults for using Git.
`.gitignore` | File listing module files that Git should ignore.
`/manifests` | Directory containing module manifests, each of which defines one class or defined type. PDK creates manifests when you create them with the `pdk new class` command.
`metadata.json` | File containing metadata for the module.
`.pmtignore` | File listing module files that the `puppet module` command should ignore.
`.rspec` | File containing the default configuration for RSpec.
`.rubocop.yml` | File containing recommended settings for Ruby style checking.
`/spec` | Directory containing files and directories for spec testing.
`/spec/spec_helper.rb` | Helper code to set up preconditions for spec tests.
`/spec/default_facts.yaml` | File containing default facts.
`/spec/classes` | Directory containing testing templates for any classes you create with the `pdk new class` command.
`/templates` | Directory containing any ERB or EPP templates. Required when building a module to upload to the Forge.
`.travis.yml` | File containing configuration for cloud-based testing on Linux and OSX. See [travis-ci](http://travis-ci.org/) for more information.

Related topics:

* [Module fundamentals][fundamentals]

{:.task}
## Create a class with PDK

Use the `pdk new class` command to create a new class for the module. It creates a class manifest file, with the naming convention `class_name.pp`.

> **Note:** To create the module's main class, which is defined in an `init.pp` file, give the class the same name as the module.

1. From the command line, in your module's directory, run `pdk new class <CLASS_NAME>` 

PDK creates the new class manifest and a test file (`class_name_spec.rb`) in your module's `/spec/classes` directory. The test template checks that your class compiles on all supported operating systems as listed in the `metadata.json`. You can then write additional tests in the provided file to validate your class's behavior.

{:.task}
## Create a defined type with PDK

Use the `pdk new defined_type` command to create a new defined type for the module. This creates a defined type manifest file, with the naming convention `defined_type_name.pp`.

1. From the command line, in your module's directory, run `pdk new defined_type <DEFINED_TYPE_NAME>`

PDK creates the new defined type manifest and a test file (`defined_type_spec.rb`) in your module's `/spec/defines` directory. The test template checks that your defined type compiles on all supported operating systems as listed in the `metadata.json`. You can then write additional tests in the provided file to validate your defined type's behavior.


