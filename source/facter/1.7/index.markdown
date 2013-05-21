---
layout: default
title: "Facter 1.7 Documentation"
nav: facter17.html
---

Facter is Puppet's cross-platform system profiling library. It discovers and reports per-node facts, which are available in your Puppet manifests as variables. 

* [The list of core facts](/facter/1.7/core_facts.html) lists and describes every built-in fact that ships with Facter. 
* [The custom facts guide](/guides/custom_facts.html) explains how to write and distribute your own custom or external facts. 


## What's new in Facter 1.7

### External Facts

It's now possible to create external facts with structured text (e.g. YAML, JSON, or a Facter-specific plaintext format) or with a script that returns fact names and values in a specific format (e.g. Ruby or Perl). Please see the [custom facts guide][] for a detailed explanation and caveats.

### on\_flush DSL method

Also new in Facter 1.7 is the `on_flush` DSL method, usable when defining new custom
facts.  This feature is designed for those users who are implementing their own custom facts.

The `on_flush` method allows the fact author to register a callback Facter will invoke whenever a cached fact value is flushed.  This is useful to keep a set of dynamically generated facts in sync without making lots of expensive system calls to resolve each fact value.

Please see the [`solaris_zones` fact][solaris_zones_fact] for an example of how the `on_flush` method is used to invalidate the cached value of a model shared by many
dynamically generated facts. 

[custom facts guide]: /guides/custom_facts.html#external-facts
[solaris_zones_fact]: https://github.com/puppetlabs/facter/commit/e4eb583d4ac48e7dcae5335bda278595340591ca#L0R17
