---
layout: default
title: "Puppet 0.23 Release Notes"
description: "Puppet release notes for version 0.23.x"
---

# Puppet 0.23 Release Notes

## 0.23.2

### Binaries and Configuration

The \-\-gen\_config option now generates a configuration with all
parameters under a heading that matches the relevant process name,
rather than keeping section headings.

### Types and Providers

Added support for managing interfaces on Red Hat.

## 0.23.1 (beaker)

### Language and Facts

You can now specify relationships to classes, which work exactly
like relationships to defined types:

    require => Class[myclass]

This works with qualified classes, too.

Added the +> syntax to resources, so parameter values can be added
to.

Hostnames can now be double quoted.

Both class and node names must both now be unique, for example you
cannot have a node and class with the same name.

### Exported/Collected Resources

You can now do simple queries in a collection of exported
resources. You still cannot do multi-condition queries, though.

### Binaries and Configuration

Running puppetca with \-\-clean now exits with a non-zero code if it
cannot find any host certificates to clean.

The Rails log level can now be set via the rails\_loglevel
parameter.

Puppet clients now have http proxy support.

### Types and Providers

Added the maillist type for managing mailing lists.

Added a mailalias type for managing mail aliases.

### Modules

Added autoloading of modules - you can now 'include' classes from
modules without ever needing to specifically load them.

### Plugins

The configuration client now pulls libraries down to $libdir, and
all autoloading is done from there with full support for any
reloadable file, such as types and providers. This is not backward
compatible -- if you're using pluginsync you'll need to disable it
on your clients until you can upgrade them.

## 0.23.0

### Functions

Fixed functions so that they accept most other rvalues as valid
values.

### Nodes

From 0.23.0 only ONE node source can be used - you can either use
LDAP, code, or an external node program, but not more than one.

### LDAP Nodes

LDAP node support has two changes, first, the "ldapattrs" attribute
is now used for setting the attributes to retrieve