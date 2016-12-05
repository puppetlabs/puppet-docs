---
layout: default
title: "Language: Tags"
canonical: "/puppet/latest/reference/lang_tags.html"
---


[virtual]: ./lang_virtual.html
[exported]: ./lang_exported.html
[namespace]: ./lang_namespaces.html
[resources]: ./lang_resources.html
[classes]: ./lang_classes.html
[defined]: ./lang_defined_types.html
[collectors]: ./lang_collectors.html
[reports]: /guides/reporting.html#make-masters-process-reports
[report_format_3]: http://projects.puppetlabs.com/projects/puppet/wiki/Report_Format_3
[tagmail]: /puppet/latest/reference/report.html#tagmail
[tagmail_conf]: ./config_file_tagmail.html
[tagmeta]: /puppet/latest/reference/metaparameter.html#tag
[tagfunction]: /puppet/latest/reference/function.html#tag
[tags_setting]: /puppet/latest/reference/configuration.html#tags
[tagnames]: ./lang_reserved.html#tags
[relationships]: ./lang_relationships.html
[containment]: ./lang_containment.html
[collector_search]: ./lang_collectors.html#search-expressions
[catalog]: ./lang_summary.html#compilation-and-catalogs


[Resources][], [classes][], and [defined type instances][defined] may have any number of **tags** associated with them, plus they receive some tags automatically. Tags are useful for:

* [Collecting][collectors] resources
* Analyzing [reports][]
* Restricting catalog runs

Tag Names
-----

[See here for the characters allowed in tag names.][tagnames]

Assigning Tags to Resources
-----

A resource may have any number of tags. There are several ways to assign a tag to a resource.

### Automatic Tagging

Every resource automatically receives the following tags:

* Its resource type
* The full name of the [class][classes] and/or [defined type][defined] in which the resource was declared
* Every [namespace segment][namespace] of the resource's class and/or defined type

For example, a file resource in class `apache::ssl` would get the tags `file`, `apache::ssl`, `apache`, and `ssl`.

Class tags are generally the most useful, especially when setting up [tagmail][] or testing refactored manifests.

### Containment

Like [relationships][] and most metaparameters, tags are passed along by [containment][]. This means a resource will receive all of the tags from the class and/or defined type that contains it. In the case of nested containment (e.g. a class that declares a defined resource, or a defined type that declares other defined resources), a resource will receive tags from all of its containers.

### The `tag` Metaparameter

You can use [the `tag` metaparameter][tagmeta] in a resource declaration to add any number of tags:

~~~ ruby
    apache::vhost {'docs.puppetlabs.com':
      port => 80,
      tag  => ['us_mirror1', 'us_mirror2'],
    }
~~~

The `tag` metaparameter can accept a single tag or an array. These will be added to the tags the resource already has. Also, `tag` can be used with normal resources, [defined resources][defined], and classes (when using the resource-like declaration syntax). Since [containment][] applies to tags, the example above would assign the `us_mirror1` and `us_mirror2` tags to every resource contained by `Apache::Vhost['docs.puppetlabs.com']`.

### The `tag` Function

You can use [the `tag` function][tagfunction] inside a class definition or defined type to assign tags to the surrounding container and all of the resources it contains:

~~~ ruby
    class role::public_web {
      tag 'us_mirror1', 'us_mirror2'

      apache::vhost {'docs.puppetlabs.com':
        port => 80,
      }
      ssh::allowgroup {'www-data': }
      @@nagios::website {'docs.puppetlabs.com': }
    }
~~~

The example above would assign the `us_mirror1` and `us_mirror2` tags to all of the defined resources being declared in the class `role::public_web`, as well as to all of the resources each of them contains.

Using Tags
-----

### Collecting Resources

Tags can be used as an attribute in the [search expression][collector_search] of a [resource collector][collectors]. This is mostly useful for realizing [virtual][] and [exported][] resources.

### Restricting Catalog Runs

Puppet agent and puppet apply can use [the `tags` setting][tags_setting] to only apply a subset of the node's [catalog][]. This is useful when refactoring modules, and allows you to only apply a single class on a test node.

The `tags` setting can be set in `puppet.conf` (to permanently restrict the catalog) or on the command line (to temporarily restrict it):

    $ sudo puppet agent --test --tags apache,us_mirror1

The value of the `tags` setting should be a comma-separated list of tags (with no spaces between tags).

### Sending Tagmail Reports

The built-in [tagmail report handler][tagmail] can send emails to arbitrary email addresses whenever resources with certain tags are changed. See the following for more info:

* [The tagmail report handler][tagmail]
* [The `tagmail.conf` file][tagmail_conf]

### Reading Tags in Custom Report Handlers

Resource tags are available to custom report handlers and out-of-band report processors: Each `Puppet::Resource::Status` object and `Puppet::Util::Log` object has a `tags` key whose value is an array containing every tag for the resource in question. See the following pages for more info:

* [Processing Reports][reports]
* [Report Format 3][report_format_3] (the report format used by Puppet 3)

