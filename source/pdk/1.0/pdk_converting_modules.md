---
layout: default
title: "Converting a module with the Puppet Development Kit"
canonical: "/pdk/1.0/pdk_get_started.html"
description: "Converting a module with the Puppet Development Kit, the shortest path to developing better Puppet code."
---

[install]: ./pdk_install.html
[metadata]: {{puppet}}/modules_metadata.html
[fundamentals]: {{puppet}}/modules_fundamentals.html
[interview]: ./pdk_metadata_interview.html

{:.concept}
## Converting modules for PDK usage

The PDK converts the basic components of a module to a PDK standard (defined by a template) and sets up an infrastructure for testing it.

To convert an existing module with a default template, use the `pdk convert` command.

> **Note:** Before you begin, please ensure that your module is either backed up or has version control. PDK convert will modify files within your module and this should be taken into account before starting this process.


{:.task}
### Convert Process

1. From the command line, within the directory of the existing module you want to convert, run the convert command: `pdk convert`

    If the existing module has a metadata.json present it is merged with the default metadata information provided from within the template. If the metadata does not exist the PDK will prompt and ask a series of interview questions in order to create the modules metadata.

    For more detailed information on the interview process, please see [the interview documentation][interview].

2. A summary of the files that have changed will be output, and you will then be prompted to either continue with the process or abort.

    Regardless of your answer a fully detailed report will be generated for the changes that will be applied. This report will be titled `report.txt` and can be found in the top directory of the module.
    Please note that this report will be replaced by an updated version every time you run the `convert` command.

    Currently the PDK will read in any extra configuration it can find in the form of a sync.yml file that should be located in the top directory of the module. Any configuration defined in this file will be applied.

3. If you choose to continue the process, the changes outlined in the report will be applied to the module.


### Command Options

1. pdk convert --noop

    Use 'noop' to run a no-op or dry-run mode. This is useful for seeing what changes Puppet will make without actually executing the changes. 


2. pdk convert --force

    Use 'force' to run the convert command and to automatically apply the changes.

    Please Note: This command can be potentially destructive as it will manipulate your files. Ensure you back up any of your work beforehand, or commit to a source control tool.


{:.reference}
### Customization

As the `PDK convert` command overwrites files in accordance with the template, we have provided the support to customise the files through a `sync.yml` file. This file is automatically read in before rendering, and any configuration defined in it will be applied to the relevant files. To ensure any configuration you define is accounted for, please ensure this file is present at the top level directory of the module and in a valid yaml format.

The following is a valid example of a `.sync.yml` file:
```
appveyor.yml:
  delete: true
.travis.yml:
  extras:
  - rvm: 2.1.9
    script: bundle exec rake rubocop
```

{:.reference}
### Potential File Changes

PDK converts an existing module by absorbing configuration from the current setup and applying it to a new set of files generated from the specified templates.

Because of this, you should expect the following files to be either modified or created when running `pdk convert` against your module:

Files and directories   | Description
----------------|-------------------------
Module directory | Directory with the same name as the module. Contains all of the module's files and directories.
`Gemfile` | File describing Ruby gem dependencies.
`Rakefile` | File listing tasks and dependencies.
`appveyor.yml` | File containing configuration for Appveyor CI integration.
`.gitignore` | File listing module files that Git should ignore.
`.pmtignore` | File listing module files that the `puppet module` command should ignore.
`.rspec` | File containing the default configuration for RSpec.
`.rubocop.yml` | File containing recommended settings for Ruby style checking.
`.travis.yml` | File containing configuration for cloud-based testing on Linux and OSX. See [travis-ci](http://travis-ci.org/) for more information.
`.gitlab-ci.yml`| File containing configuration for GitLab CI jobs.
`.yardopts`| File containing configuration for [YARD](https://yardoc.org/) to find out which source files, extra files, and formatting options you want to generate your documentation with.

Related topics:

* [Module fundamentals][fundamentals]

