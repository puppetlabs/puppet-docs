---
layout: default
title: "Documenting modules"
---

[installing]: ./modules_installing.html
[fundamentals]: ./modules_fundamentals.html
[plugins]: ./plugins_in_modules.html
[publishing]: ./modules_publishing.html
[template]: ./READMEtemplate.txt
[forge]: https://forge.puppetlabs.com/
[commonmark]: http://commonmark.org/
[metadata.json]: ./modules_metadata.html
[pdk]: {{pdk}}/pdk.html



You should document any module you write, whether you the module is for internal use only or for publication on the Puppet Forge. When you write module documentation, follow best practices and our module README template.

Documenting your module helps future-you remember what your module was built to do, as well as helping to explain why you chose to do things one way versus another. And anyone else using your module will definitely appreciate it. Use Markdown and `.md` (or `.markdown`) files for your READMEs.

We've constructed a README template that you can use for your own modules. This template helps you put together complete and clear documentation.

Related topics:

* [Module fundamentals][fundamentals]: How to use and write Puppet modules.
* [Installing modules][installing]: How to install pre-built modules from the Puppet Forge.
* [Publishing modules][publishing]: How to publish your modules to the Puppet Forge.
* [Using plug-ins][plugins]: How to arrange plug-ins (like custom facts and custom resource types) in modules and sync them to agent nodes.
* [Markdown][commonmark]
* [README template][template]
* [Puppet Development Kit][pdk]: A package of development and testing tools to help you create great modules.


{:.concept}
## The README template

The module README template helps you put together complete and clear documentation.

If you used the Puppet Development Kit (or the deprecated `puppet module generate` command) to generate your module, you already have a copy of the README template in `.md` format in your module. You can also use the standalone template to guide you.

Related topics:

* [README template][template]

{:.concept}
### Creating a table of contents

The table of contents is a best practice, particularly for large or complicated modules.

The module name should be a Level 1 heading at the top of the module, followed by a Table of Contents in a Level 4 heading.

The section headings for each top-level section (following the numbered sections in the TOC) should be Level 2 headings, with each subsection decreasing from there. Subsections can be included in the ToC if needed, as shown in the example's Setup section.


``` markdown

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
```

{:.concept}
### Writing the module description

Write a module description that tells users what software the module is working with and what it does with that software.

This description helps the user decide if your module is what they want. Does your module just install the software? Does it install and configure it? Check the `summary` field in the module's [metadata.json][]. Your **Module Description** should be slightly longer and more informative than that.

A second paragraph can go into more depth on the "How?" and "What?" of a module, giving a user more information about what to expect from the module so they can assess whether they would like to use it or not.

``` markdown
## Module description

The cat module installs, configures, and maintains your cat in both
apartment and residential house settings.

The cat module automates the installation of a cat to your apartment or
house, and then provides options for configuring the cat to fit your
environment's needs. Once installed and configured, the cat module
automates maintenance of your cat through a series of resource types and providers.
```

{:.concept}
## Writing the Setup section

The **Setup** section should give a user the basic steps to successfully get their module functioning.

Module installation instructions are covered both on the module's Forge page AND in the Puppet docs, so don't reiterate them here. In this section, include the following subsections, as applicable:

* **What (modulename) affects**

  Include this section only if:

  * The module alters, overwrites, or otherwise touches files, packages, services, or operations other than the named software; OR
  * The module's general performance can overwrite, purge, or otherwise remove entries, files, or directories in a user's environment.

  For example:
  
  ``` markdown
  ## Setup

  ### What cat affects

  * Your dog door might be overwritten if not secured before installation.
  ```

* **Setup Requirements**

  Include this section only if the module requires additional software or some tweak to a user's environment. For instance, the firewall module uses Ruby-based providers which required pluginsync to be enabled.

* **Beginning with [modulename]**

  Always include this section to explain the minimum steps required to get the module up and running in a user's environment. This section can show basic Proof of Concept use cases, so it doesn't have to necessarily be something you would run in production. For very simple modules, "Declare the main `::cat` class" may be enough.

  ``` markdown
  ### Beginning with cat

  Declare the main `::cat` class.
  ```

{:.concept}
### Writing the Usage section

The **Usage** section should address how to solve some general problems with the module, and it should include code examples.

If your module does many things, include three to five examples of the most important or most common tasks a user can accomplish with your module.

How you structure this section depends on the structure of the module and how it works in the user's environment. Ask yourself questions such as, "What problems can users solve with this module?" or "What are a couple basic tasks a user can do to see how this module works in their environment?" to help get you started.

``` markdown
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
```

{:.concept}
### Writing the Reference section

This section is where your users can find a complete list of your module's classes, types, defined types providers, facts, and functions, along with the parameters for each.

Users frequently refer to this section to find specific details; most users don't _read it_ as such. You can provide this list either via Puppet Strings or as a complete list in the README **Reference** section.

Related topics:

* [Puppet Strings](#puppet-strings)

{:.section}
#### Creating the Reference with Puppet Strings

Use Puppet Strings comments in your code to document your Puppet classes, defined types, functions, and resource types and providers so that you and your users can generate the module's reference information.

Puppet Strings processes both the README and comments from your code into HTML or JSON format documentation. This allows you and your users to generate detailed documentation for your module.

Include comments for each element (classes, functions, defined types, parameters, and so on) in your module. These comments must precede the code for that element. Comments should contain the following information, arranged in this order:

* A description giving an overview of what the element does.
* Any additional information about valid values that is not clear from the data type. (For example, if the data type is [String], but the value specifically must be a path.)
* The default value, if any for that element.

For example:

``` puppet
# @param config_epp Specifies a file to act as a EPP template for the config file. Valid options: a path (absolute, or relative to the module path). Example value: 'ntp/ntp.conf.epp'. A validation error is thrown if you supply both this param **and** the `config_template` param.
```

If you use Strings to document your module, include information about it in your **Reference** section so that your users will know how to generate your module's documentation. See Puppet Strings documentation for details on usage, installation, and correctly writing documentation comments.

{:.section}
#### Writing a Reference list

If you aren't using Puppet Strings code comments to document your module, then include a Reference list of each of your classes, defined types, types, functions, and so on, along with their parameters.

Generally, unless your module is very small (only 1 -- 4 classes or defined resource types), start your **Reference** section with a small table of contents that first lists the classes, defined types, and resource types of your module.

If your module contains both public and private classes, defined types, etc, list the public and the private separately. Include a brief description of what these items do in your module. It's especially helpful if you provide a link to each listed item.

```
## Reference

### Classes

#### Public classes

*[`pet::cat`](#petcat): Installs and configures a cat in your environment.

#### Private classes

*[`pet::cat::install`]: Handles the cat packages.
*[`pet::cat::configure`]: Handles the configuration file.
```

After this mini-contents, list the parameters, providers, or features for each thing. Be sure to include valid or acceptable values and any defaults that apply.

Each element in this list should include:

  * The data type, if applicable.
  * A description of what the element does.
  * Valid values, if the data type doesn't make it obvious.
  * Default value, if any.

```
### `pet::cat`

#### Parameters

##### `purr`

Data type: Boolean.

Enables purring in your cat.

Default: `true`.

##### `meow`

Enables vocalization in your cat. Valid options: 'string'.

Default: 'medium-loud'.

#### `laser`

Specifies the type, duration, and timing of your cat's laser show.

Default: `undef`.

Valid options: A hash with the following keys:

* `pattern` - accepts 'random', 'line', or a string mapped to a custom laser_program, defaults to 'random'.
* `duration` - accepts an integer in seconds, defaults to '5'.
* `frequency` - accepts an integer, defaults to 1.
* `start_time` - accepts an integer specifying the 24-hr formatted start time for the program.
```

{:.concept}
### Writing the Limitations and development sections

The **Limitations** section warns your users of issues, and the **Development** section tells your users how they can contribute to your module.

In the **Limitations** section, list any incompatibilities, known issues, or other warnings.

```
## Limitations

This module cannot be used with the smallchild module.
```

In the **Development** section, tell other users the ground rules for contributing to your project and how they should submit their work.

{:.concept}
### README style notes

To write a clear, concise, and comprehensible README, we recommend following a few principles, best practices, and style guidelines.

{:.section}
#### General principles of READMEs

1. Write for both web and terminal viewing. We recommend [Markdown][commonmark]. Above all else, your module must be easily readable and scannable.
2. Limit the number of external links. Linking to anything on the web limits the usability of the module, particularly if a range of users might use it in various environments, such as in terminal. Also, links look gross in plain Markdown and make your README less readable.
3. Scannability is key. READMEs are formulaic and repetitious for a reason. Repetition means that no matter the module, users know where to get the information they're looking for.

{:.section}
#### Style and formatting

1. When referring to the module, the module's name is lowercase. When referring to the software the module is automating, the software's name is uppercase (as appropriate).
2. *Public* classes and defined types are intended to be tweaked, changed, or otherwise interacted with by the user. **Private** classes and defined types do the behind-the-scenes work of the module (for instance, grabbing the package and installing it) and are not intended for the user to touch or look at.
3. Every parameter should have a description that starts with an action verb if at all possible (such as, "Sets the...", "Enables...", "Determines...", "Specifies..."). The description should be followed, in the same paragraph, by valid options (such as, "Valid options: an array"). Valid options should be followed by any default, if applicable.

   For example:


   ``` markdown
   Specifies the type of meow the cat service uses at food distribution time. Valid options: 'bark', 'low', 'rumble', 'loud', or 'none'. Default: 'low'.
   ```

   or

   ``` markdown
   Sets the food intake limit for your cat service. Determined in grams. Valid options: Integer; maximum = 100g.
   ```

4. List parameters in alphabetical order. This makes it **so much easier** for the user to find what they are looking for, not to mention how much easier it makes the readme to update.
5. Specify the valid options (or inputs or values) for **every** parameter. This might be a string, integers, an array, or specific values.
6. Mark parameters as Required or Optional whenever possible
7. < > do not render in Markdown. Ask us how we know.
8. You don't need to comment out _ because neither GitHub nor the Forge's Markdown rendering hides _.
9. The Forge's Markdown rendering is exactly the same as GitHub's rendering.

{:.section}
#### Documentation best practices

If you really want your documentation to shine, following a few best practices can help make your documentation clear and readable.

1. Use the second person; that is, write directly to the person reading your document. For example, “If you’re installing the cat module on Windows....”
2. Use the imperative; that is, tell the user what they should do. For example, "Secure your dog door before installing the cat module."
3. Use the active voice whenever possible. For example, "We recommend that you install cat and bird modules on separate instances" rather than "It is recommended that you install cat and bird modules on separate instances."
4. Use the present tense, almost always. You seldom need the word "will," for example. Events that regularly occur should be present tense: "This parameter *sets* your cat to 'purebred'. The purebred cat *alerts* you for breakfast at 6 a.m." Only use future tense when you are specifically referring to something that takes place at a time in the future, such as "The `tail` parameter is deprecated and *will be* removed in a future version. Use `manx` instead."
5. Lists, whether ordered or unordered, make things clearer for the reader. When steps should happen in a sequence, use an ordered list (1, 2, 3…). If order doesn’t matter, like in a list of options or requirements, use an unordered (bulleted) list.

