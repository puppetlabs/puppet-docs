---
layout: default
title: "Validating and testing modules with the Puppet Development Kit"
canonical: "/pdk/1.0/pdk_testing.html"
description: "Testing modules with Puppet Development Kit, the shortest path to developing better Puppet code."
---

{:.concept}
## Validating and testing your module with PDK

Puppet Development Kit (PDK) provides tools to help you run unit tests on your module and validate your module's metadata, syntax, and style.

By default, the PDK module template includes tools that can:

* Validate the `metadata.json` file.
* Validate Puppet syntax.
* Validate Puppet code style.
* Validate Ruby code style.
* Run unit tests.

If you are working behind a proxy, before you begin, ensure that you've added the correct environment variables. See [Running PDK behind a proxy](./pdk_install.html#running-pdk-behind-a-proxy) for details.

{:.concept}
### Validating modules

The validations included in PDK provide a basic check of the well-formedness of the module, and the syntax and style of the module's files. You do not need to write any tests for this validation.

By default, the `pdk validate` command validates the module's metadata, Puppet code syntax and style, and Ruby code syntax and style. Optionally, PDK can autocorrect some common code style problems. You can customize it to validate specific directories or files in the module, or validate only certain types of validation, such as metadata or Puppet code.

You can send module validation output to a file in either JUnit or text format. You can specify multiple output formats and targets in the same command, as long as the targets are each unique.

{:.task}
### Validate a module

To validate that your module is well-formed with correct syntax, run the `pdk validate` command. By default, this command runs metadata validation first, then Puppet validation, then Ruby validation. 

Optionally, you can validate only certain files or directories, run a specific type of validations, such as metadata or Puppet validation, or run all validations simultaneously. Additionally, you can send your validation output to a file in either JUnit or text format.

1. In your module's directory, from the command line, run `pdk validate`

   * To run all validations simultaneously, use the `--parallel` flag: `pdk validate --parallel`

   * To run just one type of validation on the module, pass in `puppet`, `ruby`, or `metadata`. For example, to validate the module's metadata, run `pdk validate metadata`
   
   * To run validations on a specific directory or file, pass in the name of the file or directory. For example, to run all validations on the `/lib` directory only, run `pdk validate lib/`

   * To automatically correct some common code style problems, run `pdk validate` with the `--auto-correct` option.

   * To send module validation output to a file, use the option `--format=format[:target]`, which lets you specify the desired output format and target file. For example, to create a report file `report.txt`, run `pdk validate --format=text:report.txt`
   
     You can specify multiple `--format` options, provided they all have distinct output targets.

   

See the PDK reference for a complete list of validation command options.

Related topics:

* [PDK reference](./pdk_reference)

{:.concept}
### Unit testing modules

PDK can run your unit tests on a module's Puppet code to verify that it compiles on all supported operating systems, and that the resources declared will be included in the catalog. PDK cannot test changes to the managed system or services.

When you generate a class, PDK creates a unit test file. This test file, located in your module's `/spec/classes` folder, includes a basic template for writing your unit tests. To learn more about how to write unit tests, see [rspec-puppet documentation](http://rspec-puppet.com/tutorial/).

PDK includes tools for running unit tests, but it does not write unit tests itself. However, if you are testing an empty PDK-generated module, you can run the unit test command to verify that all dependencies are present and that the spec directory was created correctly. 

After you've written your unit tests, you can use the `pdk test unit` command to run all of the tests you've included in your module.

Test and validate your module anytime you are going to modify or add code, to verify that you are starting out with clean code. Then, as you create classes and write other code in your module, continue to validate it, and to write and run unit tests.

Related links:

* [rspec](http://rspec.info/)
* [rspec-puppet](https://github.com/rodjek/rspec-puppet/)
* [Writing rspec-puppet tests](http://rspec-puppet.com/tutorial/)


{:.task}
## Unit test your module

To unit test your module, use the `pdk test unit` command. This command runs all the unit tests in your module.

Before you begin, ensure that you have written unit tests for your module, unless you are unit testing a newly generated module with no classes or code in it.

1. In your module's directory, from the command line, run `pdk test unit`.

If there are no errors, the command returns successfully as `exit code 0`, with no warnings.

See the PDK reference for a complete list of unit test options.

Related topics:

* [PDK reference](./pdk_reference)


