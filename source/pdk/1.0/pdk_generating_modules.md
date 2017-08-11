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

When you create a module, PDK asks you a series of questions that it uses to create metadata for your module.

Each question has a default response that PDK uses if you skip the question. The answers you provide to these questions are stored and used as the new defaults for subsequent module generations. Optionally, you can skip the interview step and use the default answers for all metadata.

* Your Puppet Forge username. If you don't have a Forge account, you can accept the default value for this question. If you create a Forge account later, edit the module metadata manually with the correct value. 
* Module version. We use and recommend semantic versioning for modules.
* The module author's name.
* The license under which your module is made available. This should be an identifier from [SPDX License List](https://spdx.org/licenses/).
* A one-sentence summary about your module.
* The URL to your module's source code repository, so that other users can contribute back to your module.
* The URL to a web site that offers full information about your module, if you have one.
* The URL to the public bug tracker for your module, if you have one.

After you generate a module, validate and test the module _before_ you add classes or write new code in it. This allows you to verify that the module files and directories were correctly created.

PDK does not generate any classes at module creation. You'll generate new classes with the `pdk new class` command, which creates a class manifest and a test template file for the class. When you run this command, PDK creates a class manifest and a test template file for the class. You can then write tests in this template to validate your class's behavior.

If your new class should take parameters, you can specify them, along with the parameter's data type and values, on the command line when you generate your class. You can provide any number of parameters on the command line.

Related topics:

* [Module metadata][metadata]

{:.task}
### Generate a module with pdk

To generate a module with PDK's default template, use the `pdk new module` command.

Before you begin, ensure that you've installed the PDK package. If you are running PDK behind a proxy, be sure you've added the correct environment variables. See [Running PDK behind a proxy](./pdk_install.hmtl#running-pdk-behind-a-proxy) for details.

1. From the command line, run the `pdk new module` command, specifying the name of the module: `pdk new module module_name`
   
   Optionally, to skip the interview questions and generate the module with default values, use the ``skip-interview` flag when you generate the module: `pdk new module module_name --skip-interview`

1. Respond to the PDK dialog questions in the terminal. Each question indicates the default value it will use if you just hit **Enter**.

   1. Forge username: Enter your Forge username, if you have a Forge account.
   2. Version: Enter the semantic version of your module, such as "0.1.0".
   3. Author: Enter the name of the module author.
   4. License: If you want to specify a license other than "Apache-2.0," specify that here, such as "MIT", or "proprietary".
   5. Description: Enter a one-sentence summary that helps other users understand what your module does.
   6. Source code repository: Enter the URL to your module's source code repository.
   7. Where others can learn more: If you have a website where users can learn more about your module, enter the URL.
   8. Where others can report issues: If you have a public bug tracker for your module, enter the URL.

[DavidS: third time this is explained (in addition to copy in the pdk itself). Is that still useful?

1. If the metadata that PDK displays is correct, confirm to generate the module. If it is incorrect, enter `n` to cancel and start over.

[DavidS: not that a default set of supported operating systems is added, and that developers can/should edit those afterwards at will to provide correct information.]

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
`metadata.json` | File containing metadata for the module.
`/manifests` | Directory containing module manifests, each of which defines one class or defined type. PDK creates manifests only when you generate them with the `pdk new class` command.
`/spec` | Directory containing files and directories for spec testing.
`/spec/spec_helper.rb` | File containing containing any ERB or EPP templates.
`/spec/default_facts.yaml` | File containing default facts.
`/spec/classes` | Directory containing testing templates for any classes you generate with the `pdk new class` command.
`/templates` | Directory containing any ERB or EPP templates.

[DavidS: there are a number of additional/hidden files that configure optional third-party services, and tools, that should be mentioned here: 
* appveyor.yml https://www.appveyor.com/ Cloud-based testing on Windows
* .gitattributes and .gitignore: recommended defaults for using git
* .pmtignore: required defaults when building a module for the forge
* .rspec: default config for rspec
* .rubocop.yml: recommended settings for ruby style checking
* .travis.yml: http://travis-ci.org/ Cloud-based testing on Linux, and OSX
]

Related topics:

* [Module fundamentals][fundamentals]

{:.task}
## Generate a class

To generate a class in your module, use the `pdk new class` command, specifying the name of your new class.

To generate the main class of the module, which is defined in an `init.pp` file, give the class the same name as the module. [DavidS: See updated content in the Getting Started Guide ]

1. From the command line, in your module's directory, run `pdk new class class_name`.

   ``` bash
   pdk new class class_name
   ```

PDK creates the class in the `manifests` directory. It also creates a test file (like `class_name_spec.rb`) in your module's `spec/classes` directory. This test file includes a basic template for writing your own unit tests.