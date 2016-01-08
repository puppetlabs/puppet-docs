---
layout: default
title: "Documenting Modules"
canonical: "/puppet/latest/reference/modules_documentation.html"
---

[installing]: ./modules_installing.html
[fundamentals]: ./modules_fundamentals.html
[plugins]: /guides/plugins_in_modules.html
[publishing]: ./modules_publishing.html
[template]: ./READMEtemplate.txt
[forge]: https://forge.puppetlabs.com/

Documenting Modules
=====

We highly encourage you to document any module you write, whether you intend the module solely for internal use or for publication on the [Puppet Forge][forge] (Forge). Documenting your module will help future-you remember what your module was built to do, as well as help explain why you chose to do things one way versus another. And anyone else using your module will definitely appreciate it.

There is a [README template][template] to assist you in putting together complete and clear documentation. We recommend using markdown and .md (or .markdown) files for READMEs. Below, we'll walk through the template and address best practices to help make your documenting efforts go more smoothly.

* Continue reading to learn README best practices.
* [See "Installing Modules"][installing] for how to install pre-built modules from the Puppet Forge.
* [See "Publishing Modules"][publishing] for how to publish your modules to the Puppet Forge.
* [See "Using Plugins"][plugins] for how to arrange plugins (like custom facts and custom resource types) in modules and sync them to agent nodes.


README Template
---

If you used the `puppet module generate` command to generate your module skeleton, you already have a copy of the README template in .md format. If you would like a standalone copy of the template, you can find it [here][template]. Again, we strongly recommend using .md format for your README.

## Introduction
We start with listing the module's name as a Level 1 Heading, followed by a table of contents as a Level 4 Heading.

    #modulename

    ####Table of Contents

    1. [Overview](#overview)
    2. [Module Description - What the module does and why it is useful](#module-description)
    3. [Setup - The basics of getting started with [Modulename]](#setup)
        * [What [Modulename] affects](#what-[modulename]-affects)
        * [Setup requirements](#setup-requirements)
        * [Beginning with [Modulename]](#beginning-with-[Modulename])
    4. [Usage - Configuration options and additional functionality](#usage)
    5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
    5. [Limitations - OS compatibility, etc.](#limitations)
    6. [Development - Guide for contributing to the module](#development)

The table of contents is optional but suggested as best practice, particularly for larger or more complicated modules.

The section headings for each top-level section (and top-level sections should follow the numbered sections in the TOC) will be Level 2 Headings, with each sub-section decreasing from there

## Overview and Description

The **Overview** and **Description** sections are covered together because both sections depend on and are built off of each other.

Assume **Overview** is one of the first things a user will read. It should very briefly address what software the module is working with and what it does with that software. Does it just install it? Does it install and configure it? If you are looking for inspiration, check the `summary` field in the module's metadata.json. Your overview should be just slightly longer and more informative than that.

~~~
## Overview

The cat module installs, configures, and maintains your cat in both
apartment and residential house settings.
~~~

For modules used internally, the overview section may be omitted.

**Module Description** goes into slightly more depth on the "How?" and "What?" of a module, giving a user more information about what to expect from the module so they can assess whether they would like to use it or not.

~~~
## Module Description

The cat module automates the installation of a cat to your apartment or
house, and then provides options for configuring the cat to fit your
environment's needs. Once installed and configured, the cat module
automates maintenance of your cat through a series of resource types and providers.
~~~

## Setup

Overall, the **Setup** section should give a user the basic steps to successfully get their module functioning (install instructions for a module are covered both on the module's Forge page AND in the Puppet Reference Manual and should not be reiterated here).

The **What (Modulename) Affects** section should only be used IF: 1.) the module alters, overwrites, or otherwise touches files, packages, services, or operations outside the named software; or 2.) the module's general performance may overwrite, purge, or otherwise remove entries, files, or directories in a user's environment.

~~~
## Setup

### What cat affects

* Your dog door may be overwritten if not secured before installation.
~~~

The **Setup Requirements** section is becoming increasingly unnecessary as Puppet continues to grow. However, it is still occasionally necessary when a module requires additional software or some tweak to a user's environment to work properly. For instance, the firewall module uses Ruby-based providers which required pluginsync to be enabled.

The **Beginning with [Modulename]** section should cover the minimum steps required to get the module up and running in a user's environment. (Note: This does not necessarily mean it should be running in production. This step most often covers basic Proof of Concept use cases.) It's entirely OK if this section is just "Declare the main `::cat` class." For very simple modules, this will often be the case.

~~~
### Beginning with cat

Declare the main `::cat` class.
~~~

## Usage

The **Usage** section should address how to solve some general problems with the module, and include code examples. If your module does a large amount of things, you should put some (3 - 5) examples of the most important or most asked-for tasks a user can accomplish with your module.

How you structure this section will depend on the structure of the module and how it was built to work in the user's environment. Asking yourself questions like, "What problems can users solve with this module?" or "What are a couple basic tasks a user can do to see how this module works in their environment?" will help get you started.

~~~
## Usage

All interaction with your cat can be done through the main cat class. With
the default options, a basic cat will be installed with no optimizations.

### I just want cat, what's the minimum I need?

    include '::cat'

### I want to configure my lasers

Use the following to configure your lasers for a random-pattern, 20 minute
playtime at 3AM local time.

    class { 'cat':
      laser => {
        pattern    => 'random',
        duration   => '20',
        start_time => '0300',
      }
    }
~~~

## Reference

Generally, unless your module is very small (only 1 - 4 classes or defined types (defines)), the **Reference** section should have a small table of contents that first list the public classes, defines, and resource types of your module and then list the private classes, defines, and resource types. You should include a brief description of what these items accomplish in your module. If you are feeling productive, it is nice to provide a link to each listed item.

~~~
## Reference

### Classes

#### Public Classes
*[`pet::cat`](#petcat): Installs and configures a cat in your environment.

#### Private Classes
*[`pet::cat::install`](#petcatinstall): Handles the cat packages.
*[`pet::cat::configure`](#petcatconfigure): Handles the configuration file.
~~~

Then, list the parameters, providers, or features for each thing:

~~~
### `pet::cat`

#### Parameters

##### `purr`
Enables purring in your cat. Valid options: 'true' or 'false'. Default: 'true'.

##### `meow`
Enables vocalization in your cat. Valid options: 'string'. Default: 'medium-loud'.

#### `laser`
Specifies the type, duration, and timing of your cat's laser show. Default: undef

Valid options: A hash with the following keys:

* `pattern` - accepts 'random', 'line', or a string mapped to a custom laser_program, defaults to 'random'.
* `duration` - accepts an integer in seconds, defaults to '5'.
* `frequency` - accepts an integer, defaults to 1.
* `start_time` - accepts an integer specifying the 24-hr formatted start time for the program.
~~~

## Limitations and Development

The **Limitations** section is the place to call out surprise incompatibilities.

~~~
## Limitations

This module cannot be used with the smallchild module.
~~~

Since your module is awesome, other users will want to play with it. The **Development** section is where you let them know what the ground rules for contributing are.

README Style Notes
---

## General Principles of READMEs

1. Write for both web and terminal viewing. We highly prefer [markdown](http://daringfireball.net/projects/markdown/syntax). Above all else, your module must be readable and scannable relatively easily.
2. Limit the number of external links. Linking to anything on the web is limiting the utility of the module, particularly if you publish it to the Forge and a range of users may be using it in various environments. Also, links look gross in plain markdown and will make your README less readable.
3. Scannability is key. READMEs are formulaic and repetitious for a reason. The repetition means that no matter the module, a user knows where to go to get what information and can easily scan for what they are looking for.

## Style and Formatting

1. When referring to the module, the module's name is lowercase. When referring to the software the module is automating, the software's name is uppercase (as appropriate).
2. *Public classes* are intended to be tweaked, changed, or otherwise interacted with by the user. *Private classes* are intended to do the behind-the-scenes work of the module (for instance, grabbing the package and installing it) and are not intended for the user to touch or look at.
3. Every parameter should have a description that starts with an action verb if at all possible (such as, "Sets the...", "Enables...", "Determines...", "Specifies..."). The description should be followed, in the same paragraph, by "Valid options:" (such as, "Valid options: an array"). Valid options should be followed by "Default:", if applicable. It should look like:


   ~~~
   Specifies the type of meow the cat service uses at food distribution time. Valid options: 'bark', 'low', 'rumble', 'loud', or 'none'. Default: 'low'
or
Sets the food intake limit for your cat service. Determined in grams. Valid options: Integer; maximum = 100g
   ~~~

4. Parameters should be listed in alphabetical order. This sounds arbitrary, but it makes updating the module SO MUCH EASIER.
5. Every parameter should specify what the valid options (or inputs or values) are. This might be a string, integers, an array, or specific values.
6. When possible you should mark parameters as Required or Optional.
7. < > do not render in markdown. Ask us how we know.
8. You don't need to comment out _ because neither GitHub nor the Forge's markdown rendering hides _.
9. The Forge's markdown rendering is exactly GitHub's rendering.