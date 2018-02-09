---
title: "PuppetDB 0.9 » Spec » Catalog Wire Format"
layout: default
canonical: "/puppetdb/latest/api/wire_format/catalog_format.html"
---

PuppetDB receives a new, specifically modified catalog wire format from puppet masters.

##  Previous Wire Format Shortcomings

There are a number of issues with the built-in JSON wire format used
in Puppet prior to PuppetDB:

1. The format isn't actually JSON, it's PSON. This means a catalog may
contain non-UTF-8 data. This can present problems for conforming JSON
parsers that expect Unicode.

2. Dependency edges aren't represented as first-class entities in the
wire format. Instead, dependencies have to be parsed out of resource
attributes.

3. Containment edges can point to resources that aren't in the
catalog's list of resources. Examples of this include things like Stage[main], or other special
classes.

4. There are no (good) provisions for binary data, which can show up
in a catalog via use of `generate`, among other functions

5. Resources can refer to other resources in several ways: by proper name, by alias, by
using a type-specific namevar (such as $path for the file type). None
of this is normalized in any way, and consumers of the wire format
have to sift through all of this. And for the case of type-specific
namevars, it may be impossible for a consumer to reconcile (because
the consumer may not have access to puppet source code)

In general, for communication between master and agent, it's useful to have the wire format as stripped-down as
possible. But for other consumers, the catalog needs to be precise in
its semantics. Otherwise, consumers just end up (poorly) re-coding the
catalog-manipulation logic from puppet proper. Hence the need for a wire format that allows consuming code (which
may not even originate from puppet) can handle this data.

## New Catalog Interchange format

A catalog is serialized as JSON (which implies UTF-8 encoding). Unless
otherwise noted, null is not allowed anywhere in the catalog.

    {"metadata": {
        "type": "catalog",
        "version": 1
        }
     "data": {
        "name": <string>,
        "version": <string>,
        "classes":
            [<string>, <string>, ...],
        "tags":
            [<string>, <string>, ...],
        "edges":
            [<edge>, <edge>, ...],
        "resources":
            [<resource>, <resources>, ...]
        }
    }

All keys are mandatory, although values that are lists may be empty
lists.

`"name"` is the certname the catalog is associated with.

`"version"` is an arbitrary tag that uniquely identifies this catalog
across time for a single node.

### Encoding

The entire catalog is expected to be valid JSON, which requires strict UTF-8
encoding.

### Data type: `<string>`

A JSON string. Because the catalog is UTF-8, these must also
be UTF-8.

### Data type: `<integer>`

A JSON int.

### Data type: `<boolean>`

A JSON boolean.

### Data type: `<edge>`

A JSON Object of the following form:

    {"source": <resource-spec>,
     "target": <resource-spec>,
     "relationship": <relationship>}

All keys for `edge` are required.

### Data type: `<resource-spec>`

Synonym: `<resource-hash>`. A JSON Object of the following form:

    {"type": <string>,
     "title": <string>}

For every resource-spec listed in the catalog, there *must* be a corresponding
resource in the "resources" list with matching type and title
attributes. Among other things, this means that edges refer to
resources by their resource-spec, and not by an alias or implicit
namevar.

### Data type: `<relationship>`

One of the following strings:

* `contains`
* `required-by`
* `notifies`
* `before`
* `subscription-of`

This mirrors Puppet's `->` construct in terms of defining the source and the target of an edge.

### Data type: `<resource>`

    {"type": <string>,
     "title": <string>,
     "aliases": [<string>, <string>, ...],
     "exported": <boolean>,
     "file": <string>,
     "line": <string>,
     "tags": [<string>, <string>, ...],
     "parameters": {<string>: JSON Object,
                    <string>: JSON Object,
                    ...}
    }

All keys for `resource` are required.

The `"aliases"` list must include all aliases
for a resource beyond the title itself. This includes names in explicit `"alias"` parameters, or implied namevars of the type
itself.

## Differences from Current Wire Format

1. The format is fully documented here.

2.  Information that previously had to be deduced by the puppetmaster is now
codified inside of the wire format. All possible aliases for a
resource are listed as attributes of that resource. The list of edges
now contains edges of all types, not just containment edges. And that
list of edges is normalized to refer to the `Type` and `Title` of a
resource, as opposed to referring to it by any of its aliases.

3. The new format is explicitly versioned. This format is version 1.0.0, unambiguously.

4., Catalogs will be explicitly transformed into this
format. Currently, the behavior of `#to_pson` is simply expected to "Do
The Right Thing" in terms of serialization.

## Future Development Goals

1. Binary data support is yet to be developed.
2. The use of a more compact, binary representation of the wire format may be considered. For example, using something like MessagePack, BSON, Thrift,
   or Protocol Buffers.
