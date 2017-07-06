---
layout: default
title: "Getting started with the Puppet Development Kit"
canonical: "/pdk/pdk_get_started.html"
description: "Getting started with the Puppet Development Kit, the shortest path to developing better Puppet code."
---

**Note: this page is a draft in progress and is neither technically reviewed nor edited. Do not rely on information in this draft.**


[TODO: Jean write a shortdesc here]
[TODO: Jean get a graphic of the workflow]
[TODO: Jean write a PoC/qsg overview of the workflow creating a new module, in addition to the tasks and concepts below.]

[TODO: is the overview I've jotted out below roughly correct? it won't be in that format and maybe not in this exact spot later.]

The Puppet Development Kit provides unified tooling to make developing and testing Puppet modules easier. This guide walks you through creating and testing your first module with PDK.

1. install
2. generate new module
3. validate
4. unit test
5. create a class
6. validate again
7. test again
8. write code
9. validate and test
10. repeat 8 and 9 ad infinitum

{:.concept}
## Generating a new module with pdk


PDK generates the basic components of a new module and sets up the basic infrastructure you need to test your module.

When you create a new module with PDK, the `pdk new module` command asks you a series of questions, sets some metadata default values based on your environment, and creates a `metadata.json` with the metadata for your new module. The new module that PDK creates includes all the infrastructure to use the other capabilities of `pdk`.

Each question has a default response that PDK uses if you hit **Enter** to skip the question. [TODO Jean to maybe make this info a table]

* What is your Puppet Forge username? [testuser]
* Puppet uses Semantic Versioning (semver.org) to version modules.
What version is this module? [0.1.0]
* Who wrote this module? [testuser]
* What license does this module code fall under? [Apache-2.0]
* How would you describe this module in a single sentence? [(none)]
* Where is this module's source code repository? [(none)]
* Where can others go to learn more about this module? [(none)]
* Where can others go to file issues about this module? [(none)]

PDK then displays the metadata information that it will use to generate the new module:

``` json
{
  "name": "testuser-hello_module",
  "version": "0.1.0",
  "author": "testuser",
  "summary": null,
  "license": "Apache-2.0",
  "source": null,
  "project_page": null,
  "issues_url": null,
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

PDK creates a module with directories such as:

```
hello_module/
Gemfile
appveyor.yml
metadata.json

hello_module/manifests:
hello_module/spec:
default_facts.yml
spec_helper.rb

hello_module/templates:

```

{:.task}
### Generate a new module with pdk

To generate a new module with PDK's default template, use the `pdk new module` command.

Before you begin, you should have already installed the puppet-pdk package.

1. From the command line, run the `pdk new module` command, specifying the name of the new module.

   ```
   pdk new module hello_module
   ```

1. Respond to PDK's dialog questions in the terminal. To accept the default value for any question, hit **Enter**.

1. If the metadata that PDK displays is correct, confirm with `Y` to generate the module. If it is incorrect, enter `n` to cancel and start over.

Related topics:

* Install PDK
* Add a new resource provider with PDK

{:.concept}
## Generating a class

PDK can generate classes for your new module to configure large or medium-sized chunks of functionality, such as all of the packages, config files, and services needed to run an application. [TODO: Jean to write better].

To define parameters in the class you are creating, specify them on the command line with the `pdk new class` command. You should also specify the values that parameter accepts, and optionally, you can specify parameter's data type. You can provide any number of parameters can be provided on the command line.

For example, to define an `ensure` parameter:

``` bash
pdk new class hello_class "ensure:Enum['absent','present']"
```

This command creates a file in `hello_module/manifests` named `hello_class.pp`, with the ensure parameter defined. It also creates a test file in `hello_module/spec/class` named `hello_class_spec.rb`.
 
{:.task}
## Generate a new class

To generate a new class in your module, use the `pdk new class` command.

1. From the command line, in your module's directory, run:

``` bash
pdk new class hello_class "ensure:Enum['absent','present']"
```
 


{:.concept}
## Testing your module with PDK

Testing your module with PDK validate and unit tests.

By default, the PDK module template provides tools for validating your new module's syntax and running unit tests on your module. 

The validations included in PDK run quickly, but they provide only a basic check of the well-formedness of the module and the syntax of its files. PDK unit tests use [rspec](http://rspec.info/) for Ruby-level unit testing, and [rspec-puppet](https://github.com/rodjek/rspec-puppet/) for catalog-level unit testing. [TODO: what does catalog-level mean? Is this what changes in the catalog with you use the module?]

Validate and test after generating a new module to be sure that it was generated correctly. Then, as you create classes and write other code in your module, validate and test your code frequently. [TODO I said frequently, but what is our recommendation specifically? If you were teaching me how to code, what would you tell me about testing? Do not say "do it in production."]

{:.task}
## Validate your module with PDK 

To validate that your module is well-formed with correct syntax, run the `pdk validate` command.


1. From the command line in your new module's directory, run:

   ```
   pdk validate
   ```

You should get a result like:

``` bash
Running validations on `hello_module`:
* ruby syntax: OK!
* puppet syntax: OK!
[...]
```

If you get errors on a module you are writing, fix your errors. [TODO Jean, write this better] If you get errors on a freshly created module with no new code in it, [TODO well, then what should they do?]

{:.task}
### Unit tests your module with PDK

PDK's default template sets up [rspec](http://rspec.info/) for Ruby-level unit testing, and [rspec-puppet](https://github.com/rodjek/rspec-puppet/) for catalog-level unit testing.

1. From the command line, in the module's directory, run all unit tests with:

``` bash
pdk test unit
```

<!-- // TODO: git hosting services (integration); code manager workflow integration; CI/CD Integration --> [TODO: what is all this stuff here, halp?]

This should return successfully (exit code 0) with no warnings or errors on 0 examples.
[TODO: will be a test stub here that reports any generated examples?]



If you get errors on a module you are writing, fix your errors. [TODO Jean, write this better] If you get errors on a freshly created module with no new code in it, [TODO well, then what should they do?]
 
