---
layout: default
title: "Getting started with the Puppet Development Kit"
canonical: "/pdk/pdk_get_started.html"
description: "Getting started with the Puppet Development Kit, the shortest path to developing better Puppet code."
---

**Note: this page is a draft in progress and is neither technically reviewed nor edited. Do not rely on information in this draft.**

# PDK Getting Started Guide [TODO: Jean, maybe Getting started isn't the best title? Create a new module or something taskier?]
 
[TODO Jean write a shortdesc here]
 
## Create a new module
 
1. On the command line, run

```
pdk new module sample_module
```

This is an example of creating a test module with defaults: 

```
pdk new module hello_module
pdk (INFO): Creating new module: hello_module
We need to create a metadata.json file for this module. Please answer the following questions; if the question is not applicable to this module, feel free to leave it blank.
 
What is your Puppet Forge username? [testuser]
-->
 
Puppet uses Semantic Versioning (semver.org) to version modules.
What version is this module? [0.1.0]
-->
 
Who wrote this module? [testuser]
-->
 
What license does this module code fall under? [Apache-2.0]
-->
 
How would you describe this module in a single sentence? [(none)]
-->
 
Where is this module's source code repository? [(none)]
-->
 
Where can others go to learn more about this module? [(none)]
-->
 
Where can others go to file issues about this module? [(none)]
-->
 
----------------------------------------
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
----------------------------------------
 
About to generate this module; continue? [Y]
--> y
```
 
Here is an example of the module and directories generated from the command:
 
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
 
 
## Run Validate on module
 
Run basic validate command on the empty repo
 
```
pdk validate
```
 
This should return successfully (exit code 0) with no warnings or errors.
[NOTE: Will provide an example when this features is ready]
[TODO
 
## Run Unit Tests on module
 
Run the basic test command on the new repo.
 
```
pdk test unit
```
This should return successfully (exit code 0) with no warnings or errors on 0 examples.
 
## Generate a class
 
Generate a new class:
 
```
pdk new class hello_class “ensure:Enum[‘absent’,’present’]”
```
 
This command should create a file in hello_module/manifests named hello_class.pp with the ensure parameter defined. It should also create a test file in hello_module/spec/class named hello_class_spec.rb.
 
## Run validation again
 
```
pdk validate
```
 
This should return successfully (exit code 0) with no warnings or errors.
[NOTE: Will provide an example when this features is ready]
 
## Run unit tests again
 
```
pdk test unit
```
This should return successfully (exit code 0)... [NOTE: unsure whether there will be a test stub here that reports any generated examples]

