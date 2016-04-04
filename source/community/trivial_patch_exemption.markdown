---
title: "Trivial Patch Exemption Policy"
layout: default
---

General Rule
-----

The definition of trivial below is intended to correspond roughly with changes that would, on their own, not be sufficiently robust or creative to enjoy copyright protection.  Generally, changes that do not involve any creative decisions, or that are extremely small, are not protectable.

**Policy**: Contributions that are trivial, as defined below, do not require the contributor to have signed the [Contributor License Agreement](https://cla.puppetlabs.com/).

**Puppet Definition of Trivial**: A trivial patch is a pull request that does not contain creative work. As a rule of thumb, changes are trivial patches if they:

* are fewer than 10 lines, and
* introduce no new functionality.

General Guidance for Using this Policy
-----

Since, we need to be consistent within Puppet about what we consider trivial, the following is meant to provide general guidance about what is defined as trivial.

A patch containing any of the following things is not trivial, no matter how short the patch (even if it is less than 10 lines in length):

* A new feature.
* A translation.
* A creative way of solving a bug.
* Extensive or creative comments.

A patch containing the following items would be trivial if less than 10 lines, and are likely to be trivial even above that threshold:

* Spelling / grammar fixes.
* Correcting typos like the transposition of letters in a variable name.
* Cleaning up comments in the code.
* Changes to white space or formatting.
* Patches that are purely deletions, such as removal of duplicate information or code that never executes.
* Bug fixes that change default return values or error codes stored in constants, literals, or simple variable types.
* Adding logging messages or debugging output.
* Changes to 'metadata' files like Gemfile, .gitignore, example configuration files, build scripts, etc.
* Changes that reflect outside facts, like renaming a build directory or changing a constant.
* Configuration changes
* Changes in build or installation scripts
* Re-ordering of objects or subroutines within a source file (such as alphabetizing routines)
* Moving source files from one directory or package to another, with no changes in code.
* Breaking a source files into multiple source files, or consolidating multiple source files into one source file, with no code changes

There are many gray areas. If it doesn't fall into one of the above categories, please check with docs@puppetlabs.com.

