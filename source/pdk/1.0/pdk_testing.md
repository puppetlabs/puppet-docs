---
layout: default
title: "Validating and testing modules with the Puppet Development Kit"
canonical: "/pdk/1.0/pdk_testing.html"
description: "Testing modules with the Puppet Development Kit, the shortest path to developing better Puppet code."
---

{:.concept}
## Validating and testing your module with PDK

The Puppet Development Kit (PDK) provides tools to help you run unit tests on your module and validate your module's metadata, syntax, and style.

By default, the PDK module template includes tools that can:

* Validate the `metadata.json` file.
* Validate Puppet syntax.
* Validate Puppet code style.
* Validate Ruby code style.
* Run unit tests.

If you are working behind a proxy, before you begin, ensure that you've added the correct environment variables. See [Running PDK behind a proxy](./pdk_install.html#running-pdk-behind-a-proxy) for details.

{:.concept}
### Validating modules

The validations included in PDK provide a basic check of the well-formedness of the module and syntax and style of the module's files. You do not need to write any tests for this validation.

By default, the `pdk validate` command validates the module's metadata, Puppet code syntax and style, and Ruby code syntax and style. You can also validates specific directories or files in the module, or validate  only certain types of validation, such as metadata or Puppet code.

You can also send module validation output in either JUnit or text format to a file. You can specify multiple output formats and targets in the same command, as long as the targets are each unique.

{:.task}
### Validate a module

To validate that your module is well-formed with correct syntax, run the `pdk validate` command. By default, this command runs metadata validation first, then Puppet validation, then Ruby validation. 

Optionally, you can validate only certain files or directories, run a specific type of validations, such as metadata or Puppet validation, or run all validations simultaneously. Additionally, you can send your validation output to a file in either JUnit or text format.

1. In your module's directory, from the command line, run `pdk validate`.

   * To run all validations simultaneously, use the `--parallel` flag and run `pdk validate --parallel.

   * To run just one type of validation on the module, specify `puppet`, `ruby`, or `metadata`. For example, to validate the module's metadata, run `pdk validate metadata`.

   * To send module validation output to a file, use the `pdk validate` command with the option `--format=format[:target]`. This option specifies the output format and an output target file. For example, to create a report file `report.xml` in the JUnit format, run `pdk validate --format=junit:report.xml`.

     You can specify multiple `--format` options, as long as they all have distinct output targets.

   * To run validations on a specific directory or file, pass the name of the file or directory as an argument with `pdk validate`. For example, to run all validations on the `/lib` directory only, run `pdk validate lib/`. 

See the PDK reference for a complete list of validation options.

Related topics:

* [PDK reference](./pdk_reference)

{:.concept}
### Unit testing modules

PDK can also run your unit tests on a module's Puppet code to verify that it compiles on all supported operating systems, and that the resources declared will be included in the catalog. PDK cannot test changes to the managed system or services.

When you generate a class, PDK creates a unit test file. This test file, located in your module's `/spec/classes` folder, includes a basic template for writing your unit tests. To learn more about how to write unit tests, see [rspec-puppet documentation](http://rspec-puppet.com/tutorial/).

PDK includes tools for running unit tests, but it does not write unit tests itself. However, if you are testing an empty PDK-generated module, you can run the unit test command to ensure that all dependencies are present and that the spec directory was created correctly. 

After you've written your unit tests, you can use the `pdk test unit` command to run all of the tests you've included in your module.

We suggest testing and validating your module anytime you are going to modify or add code, to verify that you are starting out with clean code. Then, as you create classes and write other code in your module, continue to write unit tests, validate, and unit test your code.

Related links:

* [rspec](http://rspec.info/)
* [rspec-puppet](https://github.com/rodjek/rspec-puppet/)
* [Writing rspec-puppet tests](http://rspec-puppet.com/tutorial/)


{:.task}
## Unit test your module

To unit test your module, use the `pdk test unit` command. This command runs all the unit tests in your module.

Before you begin, ensure that you have written unit tests for your module, unless you are unit testing a newly generated module with no classes or code in it.

1. In your module's directory, from the command line, run:

``` bash
pdk test unit
```

If there are no errors, this returns successfully as `exit code 0`, with no warnings.

See the PDK reference for a complete list of unit test options.

Related topics:

* [PDK reference](./pdk_reference)


