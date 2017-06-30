---
layout: default
title: "Getting started with the Puppet Development Kit"
canonical: "/pdk/pdk_get_started.html"
description: "Getting started with the Puppet Development Kit, the shortest path to developing better Puppet code."
---

**Note: this page is a draft in progress and is neither technically reviewed nor edited. Do not rely on information in this draft.**

# PDK Getting Started Guide [TODO: Jean, maybe Getting started isn't the best title? Create a new module or something taskier?]
 
[TODO: Jean write a shortdesc here]
[TODO: Jean get a graphic of the workflow]
[TODO: Jean write a PoC/qsg overview of the workflow creating a new module, in addition to the tasks and concepts below.]

[TODO: is the overview I've jotted out below roughly correct? it won't be in that format and maybe not in this exact spot later.]

{:.concept}
## Overview:

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


PDK generates the basic components of a new module, sets up the basic infrastructure you need to test your module, and initializes Git for you. [TODO: tell me more about what it means that it initializes Git and why the user cares about that.]

When you create a new module with PDK, the `pdk new module` command asks you a series of questions, sets some default values based on your environment [TODO: are these defaults related to the module + metadata creation, or to the testing infrastructure?], and creates a `metadata.json` with the metadata for your new module. The new module that PDK creates includes all the infrastructure to use the other capabilities of `pdk`.

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

If the information is correct, confirm the module generation with `Y`, and then PDK generates the module. If the information is incorrect, cancel with `n` and start over. [TODO: right? that's what you'd do, start over?]

PDK creates a module with directories like this:
 
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

The module that PDK generates has a basic module skeleton, but it doesn't include infrastructure for custom types or providers. If you need to manage a specific resource that is not covered by either Puppet's basic resource types or an existing module, you can create a new resource provider. [TODO is that right? I kinda made up the first sentence]

{:.concept}
## Generating resource providers with PDK

If you need to manage a specific resource that is not covered by either Puppet's basic resource types or an existing module, you can create a new resource provider with PDK.

Generating a new resource providers with PDK creates all the files required to define a resource type, its provider, and the associated basic tests. In this example, the resource type has an `ensure` property with the expected values, and a `String` property named `content`. If your types use Bash special characters, such as 'Enum[absent, present]:ensure' above, you must quote to avoid issues with the shell.


Related topics:

* Module metadata and `metadata.json`

{:.task}
### Generate a new module with pdk

To generate a new module with PDK's default template, use the `pdk new module` command.

Before you begin, you should have installed [TODO is there any configuration of PDK needed?] the puppet-pdk package.

1. From the command line, run the `pdk new module` command, specifying the name of the new module.

   ```
   pdk new module hello_module
   ```

1. Respond to PDK's dialog questions in the terminal.

1. If the metadata that PDK displays is correct, confirm to generate the module. If it is incorrect, type `n` to cancel and start over.

Related topics:

* Install PDK
* Add a new resource provider with PDK

{:.task}
### Add a new resource provider

If you need to manage a specific resource that is not covered by either Puppet's basic resource types or an existing module, create a new resource provider. [TODO: can they only do this for a module they generated with PDK? Or could you do it with a module created before PDK?]

1. From within an existing module, run `pdk add provider`, specifying the new provider name as well as any attributes along with their data types.

For example:

```
pdk add provider new_provider String:content 'Enum[absent, present]:ensure'
```

This creates all the files required to define a resource type, its provider, and the associated basic tests. In this example, the resource type has an `ensure` property with the expected values, and a `String` property named `content`. If your types use Bash special characters, such as 'Enum[absent, present]:ensure' above, you must quote to avoid issues with the shell.

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
 
{:.concept}
## Generating a class

PDK can generate classes for your new module to configure large or medium-sized chunks of functionality, such as all of the packages, config files, and services needed to run an application. [TODO: Jean to write better].

When you generate a new class, you'll need to define any parameters [TODO: can they define multiple parameters? how many? Should they just do the one and they add others later? And if so, is it a "they should" or "they must"? Please provide details about what arguments they can use with the new class command.] PDK creates both the class and a test file [TODO is that for unit testing? what about validation?]

For example:

``` bash
pdk new class hello_class "ensure:Enum['absent','present']"
```
 
This command creates a file in `hello_module/manifests` named `hello_class.pp`, with the ensure parameter defined. It should also create a test file in hello_module/spec/class named hello_class_spec.rb.
 
{:.task}
## Generate a new class

To generate a new class in your module, use the `pdk new class` command.

1. From the command line, in your module's directory, run:

``` bash
pdk new class hello_class "ensure:Enum['absent','present']"
```
 
