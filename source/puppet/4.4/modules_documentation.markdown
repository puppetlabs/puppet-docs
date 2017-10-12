---
layout: default
title: "Documenting Modules"
canonical: "/puppet/latest/modules_documentation.html"
---

[installing]: ./modules_installing.html
[fundamentals]: ./modules_fundamentals.html
[plugins]: /guides/plugins_in_modules.html
[publishing]: ./modules_publishing.html
[template]: ./READMEtemplate.txt
[forge]: https://forge.puppetlabs.com/
[commonmark]: http://commonmark.org/
[metadata.json]: ./modules_metadata.html


We strongly encourage you to document any module you write, whether you intend the module solely for internal use or for publication on the [Puppet Forge][forge] (Forge). Documenting your module helps future-you remember what your module was built to do, as well as helping to explain why you chose to do things one way versus another. And anyone else using your module will definitely appreciate it.

There is a [README template][template] to assist you put together complete and clear documentation. We recommend using [Markdown][commonmark] and .md (or .markdown) files for READMEs. Below, we'll walk through the template and address best practices to help make your documentation efforts go more smoothly.

* Continue reading to learn README best practices.
* [See "Installing Modules"][installing] for how to install pre-built modules from the Puppet Forge.
* [See "Publishing Modules"][publishing] for how to publish your modules to the Puppet Forge.
* [See "Using Plugins"][plugins] for how to arrange plugins (like custom facts and custom resource types) in modules and sync them to agents.


README Template
---

If you used the `puppet module generate` command to generate your module skeleton, you already have a copy of the README template in .md format. You can also use the standalone [template][template] to guide you. Again, we strongly recommend using .md format for your README.

## Introduction

Start with listing the module's name as a Level 1 Heading, followed by a table of contents as a Level 4 Heading.

    # modulename

    #### Table of Contents

    1. [Module Description - What the module does and why it is useful](#module-description)
    2. [Setup - The basics of getting started with [modulename]](#setup)
        * [What [modulename] affects](#what-[modulename]-affects)
        * [Setup requirements](#setup-requirements)
        * [Beginning with [modulename]](#beginning-with-[modulename])
    3. [Usage - Configuration options and additional functionality](#usage)
    4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
    5. [Limitations - OS compatibility, etc.](#limitations)
    6. [Development - Guide for contributing to the module](#development)

The table of contents is a best practice, particularly for large or complicated modules.

The section headings for each top-level section (following the numbered sections in the TOC) should be Level 2 Headings, with each subsection decreasing from there. Subsections can be included in the ToC if needed, as shown in the Setup subsections above.

## Module Description

Assume **Module Description** is the first thing a user reads. First, it should briefly address what software the module is working with and what it does with that software. Does it just install it? Does it install and configure it? Check the `summary` field in the module's [metadata.json][]. Your **Module Description** should be slightly longer and more informative than that.

A second paragraph can go into more depth on the "How?" and "What?" of a module, giving a user more information about what to expect from the module so they can assess whether they would like to use it or not.

~~~
## Module Description

The cat module installs, configures, and maintains your cat in both
apartment and residential house settings.

The cat module automates the installation of a cat to your apartment or
house, and then provides options for configuring the cat to fit your
environment's needs. Once installed and configured, the cat module
automates maintenance of your cat through a series of resource types and providers.
~~~

## Setup

Overall, the **Setup** section should give a user the basic steps to successfully get their module functioning. (Module installation instructions are covered both on the module's Forge page AND in the Puppet Reference Manual, so don't reiterate them here).

**What (modulename) affects** is used only if:

* the module alters, overwrites, or otherwise touches files, packages, services, or operations other than the named software; OR
* the module's general performance may overwrite, purge, or otherwise remove entries, files, or directories in a user's environment.

~~~
## Setup

### What cat affects

* Your dog door might be overwritten if not secured before installation.
~~~

**Setup Requirements** is used only if the module requires additional software or some tweak to a user's environment. For instance, the firewall module uses Ruby-based providers which required pluginsync to be enabled.

**Beginning with [modulename]** should cover the minimum steps required to get the module up and running in a user's environment. (Note: This does not necessarily mean it should be running in production. This step most often covers basic Proof of Concept use cases.) For very simple modules, this section is often just "Declare the main `::cat` class."

~~~
### Beginning with cat

Declare the main `::cat` class.
~~~

## Usage

The **Usage** section should address how to solve some general problems with the module, and it should include code examples. If your module does a large number of things, you should put three to five examples of the most important or most common tasks a user can accomplish with your module.

How you structure this section depends on the structure of the module and how it works in the user's environment. Ask yourself questions such as, "What problems can users solve with this module?" or "What are a couple basic tasks a user can do to see how this module works in their environment?" to help get you started.

~~~
## Usage

All interaction with your cat can be done through the main cat class. With
the default options, a basic cat will be installed with no optimizations.

### I just want cat, what's the minimum I need?

    include '::cat'

### I want to configure my lasers

Use the following to configure your lasers for a random-pattern, 20-minute
playtime at 3 a.m. local time.

    class { 'cat':
      laser => {
        pattern    => 'random',
        duration   => '20',
        start_time => '0300',
      }
    }
~~~

## Reference

The **Reference** section should contain a complete list of classes, defines, types, functions, etc., along with their parameters.

Generally, unless your module is very small (only 1 - 4 classes or defines (defined resource types)), start with a small table of contents that first lists the classes, defines, and resource types of your module. If your module contains both public and private classes, defines, etc, list the public and the private separately. Include a brief description of what these items do in your module. It's especially helpful if you  provide a link to each listed item.

~~~
## Reference

### Classes

#### Public Classes
*[`pet::cat`](#petcat): Installs and configures a cat in your environment.

#### Private Classes
*[`pet::cat::install`]: Handles the cat packages.
*[`pet::cat::configure`]: Handles the configuration file.
~~~

After this mini-contents, list the parameters, providers, or features for each thing. Be sure to include valid or acceptable values and any defaults that apply.

~~~
### `pet::cat`

#### Parameters

##### `purr`
Enables purring in your cat. Valid options: 'true' or 'false'. Default: 'true'.

##### `meow`
Enables vocalization in your cat. Valid options: 'string'. Default: 'medium-loud'.

#### `laser`
Specifies the type, duration, and timing of your cat's laser show. Default: undef.

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

1. Write for both web and terminal viewing. We recommend [Markdown][commonmark]. Above all else, your module must be easily readable and scannable.
2. Limit the number of external links. Linking to anything on the web limits the usability of the module, particularly if a range of users might use it in various environments, such as in terminal. Also, links look gross in plain Markdown and make your README less readable.
3. Scannability is key. READMEs are formulaic and repetitious for a reason. Repetition means that no matter the module, users know where to get the information they're looking for.

## Style and Formatting

1. When referring to the module, the module's name is lowercase. When referring to the software the module is automating, the software's name is uppercase (as appropriate).
2. *Public* classes and defines are intended to be tweaked, changed, or otherwise interacted with by the user. **Private** classes and defines do the behind-the-scenes work of the module (for instance, grabbing the package and installing it) and are not intended for the user to touch or look at.
3. Every parameter should have a description that starts with an action verb if at all possible (such as, "Sets the...", "Enables...", "Determines...", "Specifies..."). The description should be followed, in the same paragraph, by valid options (such as, "Valid options: an array"). Valid options should be followed by any default, if applicable.

    For example:


        Specifies the type of meow the cat service uses at food distribution time. Valid options: 'bark', 'low', 'rumble', 'loud', or 'none'. Default: 'low'.


    or

        Sets the food intake limit for your cat service. Determined in grams. Valid options: Integer; maximum = 100g.

4. List parameters in alphabetical order. This makes it **so much easier** for the user to find what they are looking for, not to mention how much easier it makes the readme to update.
5. Specify the valid options (or inputs or values) for **every** parameter. This might be a string, integers, an array, or specific values.
6. Mark parameters as Required or Optional whenever possible
7. < > do not render in Markdown. Ask us how we know.
8. You don't need to comment out _ because neither GitHub nor the Forge's Markdown rendering hides _.
9. The Forge's Markdown rendering is exactly GitHub's rendering.

## Documentation Best Practices

If you really want your documentation to shine, following a few best practices can help make your documentation clear and readable.

1. Use the second person; that is, write directly to the person reading your document. For example, “If you’re installing the cat module on Windows....”
2. Use the imperative; that is, tell the user what they should do. For example, “Secure your dog door before installing the cat module.”
3. Use the active voice whenever possible. For example, “We recommend that you install cat and bird modules on separate instances” rather than “It is recommended that you install cat and bird modules on separate instances."
4. Use the present tense, almost always. You seldom need the word "will," for example. Events that regularly occur should be present tense: "This parameter *sets* your cat to 'purebred'. The purebred cat *alerts* you for breakfast at 6 a.m." Only use future tense when you are specifically referring to something that takes place at a time in the future, such as "The `tail` parameter is deprecated and *will be* removed in a future version. Use `manx` instead."
5. Lists, whether ordered or unordered, make things clearer for the reader. When steps should happen in a sequence, use an ordered list (1, 2, 3…). If order doesn’t matter, like in a list of options or requirements, use an unordered (bulleted) list.

