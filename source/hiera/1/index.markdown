---
title: "Hiera 1: Overview"
layout: default
---


[puppet]: /puppet
[config]: ./configuring.html
[install]: ./installing.html
[data_sources]: ./data_sources.html
[hierarchy]: ./hierarchy.html
[with_puppet]: ./puppet.html
[command_line]: ./command_line.html
[complete_example]: ./complete_example.html


{% partial /hiera/_hiera_update.md %}

Hiera is a key/value lookup tool for configuration data, built to **make [Puppet][] better** and let you **set node-specific data without repeating yourself.** See ["Why Hiera?" below](#why-hiera) for more information, or get started using it right away:

Getting Started With Hiera
-----

> To get started with Hiera, you'll need to do all of the following:
>
> * [Install Hiera][install], if it isn't already installed.
> * [Make a `hiera.yaml` config file][config].
> * [Arrange a hierarchy][hierarchy] that fits your site and data.
> * [Write data sources][data_sources].
> * [Use your Hiera data in Puppet][with_puppet] (or any other tool).

After you have Hiera working, you can adjust your data and hierarchy whenever you need to. You can also [test Hiera from the command line][command_line] to make sure it's fetching the right data for each node.

### Learning From Example

If you learn best from example code, start with [this simple end-to-end Hiera and Puppet walkthrough][complete_example]. To learn more, you can go back and read the sections linked above.


Why Hiera?
-----

### Making Puppet Better

Hiera makes Puppet better by **keeping site-specific data out of your manifests.** Puppet classes can request whatever data they need, and your Hiera data will act like a site-wide config file.

This makes it:

* Easier to configure your own nodes: default data with multiple levels of overrides is finally easy.
* Easier to re-use public Puppet modules: don't edit the code, just put the necessary data in Hiera.
* Easier to publish your own modules for collaboration: no need to worry about cleaning out your data before showing it around, and no more clashing variable names.

### Avoiding Repetition

With Hiera, you can:

* Write common data for _most_ nodes
* Override _some_ values for machines located at a particular facility...
* ...and override some of _those_ values for one or two unique nodes.

This way, you only have to write down the _differences_ between nodes. When each node asks for a piece of data, it will get the specific value it needs.

To decide which data sources can override which, Hiera uses a **configurable hierarchy.** This ordered list can include both **static** data sources (with names like "common") and **dynamic** ones (which can switch between data sources based on the node's name, operating system, and more).

