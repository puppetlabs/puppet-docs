---
layout: default
title: "Facter 3.5 Release notes"
---

[puppet-agent 1.5.x]: /puppet/4.5/reference/about_agent.html

This page documents the history of the Facter 3.5 series. If you're upgrading from Facter 2, review the [Facter 3.0 release notes](../3.0/release_notes.html) for important information about other breaking changes, new features, and changed functionality. 

## Facter 3.5.1

Released January 19, 2017.

This is a bug fix release that includes two new command line options.

* [Fixed in Facter 3.5.1](https://tickets.puppetlabs.com/issues/?jql=fixVersion%20%3D%20%27FACT%203.5.1%27)
* [Introduced in Facter 3.5.1](https://tickets.puppetlabs.com/issues/?jql=affectedVersion%20%3D%20%27FACT%203.5.1%27)

### New features

#### New command line options

Facter will now output the names of facts that belong to each blockable and cacheable group of facts when using the `--list-block-groups` and `--list-cache-groups` command line options. The group name headers are still the only valid values to add to the `blocklist` and `ttls` fields in the config file, but this change makes it more apparent which facts will be blocked or cached.

* [FACT-1536](https://tickets.puppetlabs.com/browse/FACT-1536)

### Bug fixes

* [FACT-1551](https://tickets.puppetlabs.com/browse/FACT-1551): An issue has been corrected that could cause custom Ruby facts running on Windows to fail to run if they made use of the Ruby network stack (such as Net::HTTP).

* [FACT-1537](https://tickets.puppetlabs.com/browse/FACT-1537): Our automation for producing tarballs uses a whitelist to construct tarballs, so it does not pick up new directories automatically. This resulted in an incomplete tarball for Facter 3.5.0. Git clones and archives produced from Git were not affected. We have updated the whitelist, but the automation should still be refactored to remove this shortcoming.

* [FACT-1485](https://tickets.puppetlabs.com/browse/FACT-1485): Previously, Facter 3 would report `release` incorrectly on Amazon Linux, but this has been resolved.

## Facter 3.5.0

Released November 1, 2016.

This release introduces new features to Facter, and includes mindor bux fixes.

* [Fixed in Facter 3.5.0](https://tickets.puppetlabs.com/issues/?jql=fixVersion+%3D+%27FACT+3.5.0%27)
* [Introduced in Facter 3.5.0](https://tickets.puppetlabs.com/issues/?jql=affectedVersion+%3D+%27FACT+3.5.0%27)

### New Features

#### Cache values easily

Facter can now cache groups of facts for a specified length of time. Adding the name of a fact group along with a duration to the `ttls` section of the config file will cause Facter to only resolve that group of facts once, until the cache expires. 

For example: 

`facts : { ttls : [ { "kernel" : 30 days }, { "file system" : 1 hour } ] }`

Causes kernel and file system facts to be cached for 30 days and 1 hour, respectively. The names of cacheable fact groups can be found using the `--list-cache-groups` command line option. 

The location of the cache is `/opt/puppetlabs/facter/cache/cached_facts/` on Unix and `C:\ProgramData\PuppetLabs\facter\cache\cached_fact\` on Windows.

* [FACT-348](https://tickets.puppetlabs.com/browse/FACT-348)

#### Disable facts

Some facts are blockable in groups, as described in the fact schema. If you add one of these groups to the config file list element `blocklist`, it will not be resolved the next time Facter is run. This is useful to block facts that are very expensive to resolve, or even completely broken, if they are not needed by the user. 

For example: 

`facts : { blocklist : [ "EC2", "file system" ] } `

If this block is present in the config file, EC2 facts and file system facts (e.g. mountpoints, partitions) do not resolve. 

This feature is currently enabled for only a small subset of facts. If a fact has a `blockgroup` listed in its description, it can be blocked with this feature, along with all the other facts in that group. Blocking only subsets of groups is not supported. 

*[FACT-718](https://tickets.puppetlabs.com/browse/FACT-718)

#### New command line flags

##### Fact blocking

* `--no-block`: Causes the blocklist specified in the config file to be ignored. All available facts will be resolved. 
* `--list-block-groups`: Prints out the names of all blockable groups of facts. Adding one of these groups to the `blocklist` section of the config file will cause that group of facts to be blocked.

* [FACT-1512](https://tickets.puppetlabs.com/browse/FACT-1512)

##### `--list-cache-groups`

The `--list-cache-groups` command has been added to Facter, which will print the names of all groups of facts available for caching. You can specify one of these groups, along with a duration, in the `ttls` subsection of the config file, and it causes that group of facts to be cached for the specified length of time.

* [FACT-1511](https://tickets.puppetlabs.com/browse/FACT-1511)

##### `--no-cache`

The `--no-cache` command line flag has been added, which causes Facter to ignore the fact `times-to-live` as specified in the config file. It will neither load cached facts nor refresh the cache when run with this option.

* [FACT-1509](https://tickets.puppetlabs.com/browse/FACT-1509)

### Enhancements

* [FACT-1356](https://tickets.puppetlabs.com/browse/FACT-1356): Executable external facts can return data in YAML or JSON format, and Facter correctly parses it into a structured fact. If the returned value is not YAML, Facter falls back to parsing it as a `key=value` pair, and only fails to resolve if the output is none of these formats.

### Bug Fixes

* [FACT-1413](https://tickets.puppetlabs.com/browse/FACT-1413): This change formalizes fact precedence and resolution order when there are multiple top-level facts with the same name, and it fixes application of the `has_weight` field from custom facts.