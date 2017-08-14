---
layout: default
title: "Developing a module with the Puppet Development Kit"
canonical: "/pdk/1.0/pdk_get_started.html"
description: "Developing a module with the Puppet Development Kit, the shortest path to developing better Puppet code."
---

[install]: ./pdk_install.html
[metadata]: {{puppet}}/modules_metadata.html
[fundamentals]: {{puppet}}/modules_fundamentals.html

{:.concept}
## Generating modules and classes with PDK

PDK generates the basic components of a module and sets up the basic infrastructure for testing it.

To create module metadata, PDK asks you a series of questions. Each question has a default response that PDK uses if you skip the question. The answers you provide to these questions are stored and used as the new defaults for subsequent module generations. PDK also adds a default set of supported operating systems to your metadata, which you can manually edit after module creation.

Optionally, you can skip the interview step and use the default answers for all metadata.

When you run the `pdk new module` command, the tool asks the following questions:

* Your Puppet Forge user name. If you don't have a Forge account, you can accept the default value for this question. If you create a Forge account later, edit the module metadata manually with the correct value. 
* Module version. We use and recommend semantic versioning for modules.
* Your name.
* The license under which your module is made available, an identifier from [SPDX License List](https://spdx.org/licenses/).
* A one-sentence summary about your module.
* The URL to your module's source code repository, so that other users can contribute back to your module.
* The URL to a web site that offers full information about your module, if you have one.
* The URL to the public bug tracker for your module, if you have one.

After you generate a module, validate and test the module _before_ you add classes or write new code in it. This allows you to verify that the module files and directories were correctly created.

After you create the module, create classes by running the `pdk new class` command. It creates a class manifest, with the naming convention `<CLASS_NAME>.pp`. For the module's main class, which has the same name as the module, the class manifest is named `init.pp`.

The new class command also creates a test template file for the class. You can then write tests in this template to validate your class's behavior.

Related topics:

* [Module metadata][metadata]

{:.task}
### Generate a module with PDK

To generate a module with a default template, use the `pdk new module` command.

Before you begin, ensure that you've installed the PDK package. If you are running PDK behind a proxy, be sure you've added the correct environment variables. See [Running PDK behind a proxy](./pdk_install.hmtl#running-pdk-behind-a-proxy) for details.

1. From the command line, run the new module command, specifying the name of the module: `pdk new module <MODULE_NAME>`
   
   Optionally, to skip the interview questions and generate the module with default values, add the `skip-interview` flag: `pdk new module <MODULE_NAME> --skip-interview`

1. Respond to the PDK dialog questions. Each question indicates the default value it will use if you just press **Enter**.

   1. Forge username: Enter your Forge username, if you have a Forge account.
   2. Version: Enter the semantic version of your module, such as "0.1.0".
   3. Author: Enter the name of the module author (you or someone else responsible for the module's content).
   4. License: If you want to specify a license other than "Apache-2.0," specify that here, such as "MIT", or "proprietary".
   5. Description: Enter a one-sentence summary that helps other users understand what your module does.
   6. Source code repository: Enter the URL to your module's source code repository.
   7. Where others can learn more: If you have a website where users can learn more about your module, enter the URL.
   8. Where others can report issues: If you have a public bug tracker for your module, enter the URL.

1. If the metadata that PDK displays is correct, confirm to generate the module. If it is incorrect, cancel and start over.

{:.reference}
### Module contents

PDK generates a basic module, a directory with a specific structure. This module contains directories and files you need to start developing and testing your module.

To learn the basics of what a Puppet module includes, see the related topic about module fundamentals.

PDK creates the following files and directories for your module:

Files and directories   | Description
----------------|-------------------------
Module directory | Directory with the same name as the module. Contains all of the module's files and directories.
Gemfile | File describing Ruby gem dependencies.
Rakefile | File listing tasks and dependencies.
`appveyor.yml` | File containing configuration for Appveyor CI integration.
`.gitattributes` | Recommended defaults for using Git.
`.gitignore` | File listing module files that Git should ignore.
`/manifests` | Directory containing module manifests, each of which defines one class or defined type. PDK creates manifests when you generate them with the `pdk new class` command.
`metadata.json` | File containing metadata for the module.
`.pmtignore` | File listing module files that the `puppet module` command should ignore. 
`.rspec` | File containing the default configuration for RSpec.
`.rubocop.yml` | File containing recommended settings for Ruby style checking.
`/spec` | Directory containing files and directories for spec testing.
`/spec/spec_helper.rb` | File containing containing any ERB or EPP templates.
`/spec/default_facts.yaml` | File containing default facts.
`/spec/classes` | Directory containing testing templates for any classes you generate with the `pdk new class` command.
`/templates` | Directory containing ERB or EPP templates. Required when building a module to upload to the Forge.
`.travis.yml` | File containing configuration for cloud-based testing on Linux and OSX. See [travis-ci](http://travis-ci.org/) for more information.

Related topics:

* [Module fundamentals][fundamentals]

{:.task}
## Generate a class with PDK

Use the `pdk new class` command to generate a new class for the module.

> **Note:** To generate the module's main class, which is defined in an `init.pp` file, give the class the same name as the module.

1. From the command line, in your module's directory, run `pdk new class <CLASS_NAME>` 

PDK creates the new class manifest and a test file (`class_name_spec.rb`) in your module's `/spec/classes` directory. This test template checks that your class compiles on all supported operating systems as listed in the `metadata.json`. You can then write additional tests in the provided file to validate your class's behavior.
