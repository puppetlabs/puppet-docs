---
layout: default
title: "Getting started with the Puppet Development Kit"
canonical: "/pdk/1.0/pdk_get_started.html"
description: "Getting started with the Puppet Development Kit, the shortest path to developing better Puppet code."
---

[install]: ./pdk_install.html


**Note: this page is a draft in progress and is neither technically reviewed nor edited. Do not rely on information in this draft.**

Get started developing and testing Puppet modules with the Puppet Development Kit (PDK).

PDK includes testing tools, a complete module skeleton, and command line tools to help you create, validate, and run tests on Puppet modules.

To get started, you'll create and test a new module with PDK. 

1. Generate a new module with PDK, using the `pdk new module` command.
1. Validate and unit test your new module, to verify that your new module was created correctly.
1. Generate a new class for your module, using the `pdk new class` command.

These steps provide a basic workflow for development and testing with PDK. Then, as you add new code to your module, continue validating, testing, and iterating on your code as needed.

Before you begin, install the pdk package.

Related topics:

* [Installing the Puppet Development Kit][install]

{:.concept}
## Generating a new module with PDK

PDK generates the basic components of a new module and sets up the basic infrastructure you need to test your module.

When you create a new module with PDK, the `pdk new module` command asks you a series of questions, sets metadata based on your answers, and creates a `metadata.json` with the metadata for your new module. The new module that PDK creates includes all the infrastructure to use the other capabilities of `pdk`.

Each question has a default response that PDK uses if you hit **Enter** to skip the question. To generate a module with only the default values, you can skip the interview step by running `pdk new module module_name --skip-interview`.

[TODO: what if they don't have a Forge username? Should a Forge account be a prerequisite?]

Question   |Description   | Default value
----------------|:------------------:|-------------------------
What is your Puppet Forge username? | This will be used when uploading your module to the Forge. You can opt out of this at any time. The Forge username to associate the module with. By default, this is the username with which you are logged into your machine. | username
Puppet uses Semantic Versioning (semver.org) to version modules. What version is this module? | The current version of your module. This should follow semantic versioning. | 0.1.0
Who wrote this module? | By default, this is the username with which you are logged into your machine. | username
What license does this module code fall under? | The license under which your module is made available. This should be an identifier from https://spdk.org/licenses/. Common values are "Apache-2.0", "MIT", or "proprietary". | Apache-2.0
How would you describe this module in a single sentence? | A short summary to help other Puppet users understand what your module does. | (none)
Where is this module's source code repository? | The URL to your source code repository, most commonly on GitHub. This lets other users know where to go to contribute to your module. | (none)
Where can others go to learn more about this module? | If you have a web site that offers full information about your module, provide the URL here. | (none)
Where can others go to file issues about this module? | If you have a public bug tracker for your module, provide the URL here. | (none)

PDK then displays the metadata information that it will use to generate the new module. A typical `metadata.json` might look like this:

``` json
{
  "name": "username-module_name",
  "version": "0.1.0",
  "author": "username",
  "summary": "",
  "license": "Apache-2.0",
  "source": "",
  "project_page": "",
  "issues_url": "",
  "dependencies": [
    {
      "name": "puppetlabs-stdlib",
      "version_requirement": ">= 1.0.0"
    }
  ],
  "data_provider": null
}
```

If the information is correct, confirm the module generation with `Y`, and then PDK generates the module. If the information is incorrect, cancel with `n` and start over.

After you generate a new module, we suggest validating and testing the module _before_ you add classes or write new code in it. This allows you to verify that the module was correctly created.

PDK does not generate any classes at module creation. To add classes to your module, use the `pdk new class` command.

{:.concept}
### What is in the module PDK creates? <!--TODO Jean write a better title-->

PDK generates a basic module, which is a directory with a specific structure. This module contains directories To learn the basics of what a Puppet module includes, see the related topic about module fundamentals.

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

Related topics:

*[Module fundamentals](https://docs.puppet.com/puppet/5.0/modules_fundamentals.html)

{:.task}
### Generate a new module with pdk

To generate a new module with PDK's default template, use the `pdk new module` command.

1. From the command line, run the `pdk new module` command, specifying the name of the new module.

   ``` bash
   pdk new module module_name
   ```
   
   Optionally, to skip the interview questions and generate the module with default values, use the ``skip-interview` flag when you generate the module:

   `pdk new module module_name --skip-interview`

1. Respond to the PDK dialog questions in the terminal. To accept the default value for any question, hit **Enter**.

1. If the metadata that PDK displays is correct, confirm with `Y` to generate the module. If it is incorrect, enter `n` to cancel and start over.

Related topics:

* Install PDK
* Add a new resource provider with PDK

{:.concept}
## Generating a class

Generate classes for your module on the command line with PDK.

To create a new class, run the `pdk new class` command, specifying the name of your new class. To generate an `init.pp` class, the main class of a module, generate a class with the same name as the module: `pdk new class module_name`.

If the class name is not inside the module namespace, then the module name is automatically prepended to the class name. For example, if the module name is `apt` and the class name is `source`, the class is named `apt::source`.

PDK creates the new class manifest and a test template file. You can then write tests in this template to validate your class's behavior.

{:.concept}
### Specifying class parameters

If your new class should take parameters, specify them on the command line when you generate your class.

Specify the values that parameter accepts, and optionally, specify the data type of the parameter with with the parameter name. You can provide any number of parameters on the command line.


For example, to create a new class and define an `ensure` parameter for the class, run:

``` bash
pdk new class class_name "ensure:Enum['absent','present']"
```

This command creates a file in `module_name/manifests` named `class_name.pp`, with the ensure parameter defined. It also creates a test file in `module_name/spec/class` named `class_name_spec.rb`. This test file includes a basic template for writing your own unit tests.



Related topics:

* [Data types](TODO: LINK)

{:.task}
## Generate a new class

To generate a new class in your module, use the `pdk new class` command.

1. From the command line, in your module's directory, run:

   ``` bash
   pdk new class class_name "ensure:Enum['absent','present']"
   ```

{:.concept}
## Testing your module with PDK

[KARI: Testing and validating the module are two separate tasks; should I treat them as two separate concepts as well? I thought it made sense to lump them together as two kinds of "testing", but I'm reconsidering that.]

PDK provides tools to help you run unit tests on your module and validate your new module's metadata, syntax, and style.

By default, the PDK module template includes tools that can:

* Validate the `metadata.json`.
* Validate Puppet syntax.
* Validate Puppet code style.
* Validate Ruby code style.
* Run unit tests.

The validations included in PDK run quickly, but they provide only a basic check of the well-formedness of the module and the syntax of its files. You do not need to write any tests for this validation.

PDK can also run your unit tests on your module's Puppet code to verify that the resources declared will be included in the catalog. PDK cannot test changes to the managed system or services.

PDK creates a unit test file when you generate a class with `pdk new class`. This test file, located in your module's `/spec/class` folder, includes a basic template for writing your unit tests. To learn more about how to write unit tests, see [rspec-puppet documentation](http://rspec-puppet.com/tutorial/).

After you've written your unit tests, you can use the `pdk test unit` command to run all of the tests you've included in your module.

We suggest testing and validating your module anytime you are going to modify or add code, to verify that you are starting out with clean code. Then, as you create classes and write other code in your module, validate, test, and iterate on your code as needed.

Related links:

* [rspec](http://rspec.info/)
* [rspec-puppet](https://github.com/rodjek/rspec-puppet/)
* [Writing rspec-puppet tests](http://rspec-puppet.com/tutorial/)

{:.task}
### Validate your module with PDK 

To validate that your module is well-formed with correct syntax, run the `pdk validate` command.

1. In your new module's directory, from the command line, run:

   ``` bash
   pdk validate
   ```

You should get a result like:

``` bash
Running validations on `hello_module`:
* ruby syntax: OK!
* puppet syntax: OK!
[...]
```


{:.task}
### Unit test your module with PDK

To unit test your module, use the `pdk test unit` command. This command runs all the unit tests in your module.

Before you begin, you need to have written unit tests for your module. The exception to this is if you are testing an empty PDK-generated module. If you generated a module with PDK, and you have *not* added any new classes or code to it, PDK can test to make sure that the module was generated correctly.

1. In your new module's directory, from the command line, run:

``` bash
pdk test unit
```

If there are no errors, this returns successfully (exit code 0) with no warnings or errors on 0 examples.

