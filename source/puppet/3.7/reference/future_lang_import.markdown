---
layout: default
title: "Future Parser: Import"
canonical: "/puppet/latest/reference/future_lang_import.html"
---

[enc]: /guides/external_nodes.html

Import
---
The use of the `import` keyword to import arbitrary manifests into the catalog compilation
has been discontinued and has been replaced by the ability to "import" a set of manifests in
a directory structure by referencing the root of the directory structure instead of a single
`site.pp` manifest.

All manifests (`.pp` files) in the referenced directory and all subdirectories (recursively)
are imported in ascending alphabetical order.

The result is the same as if all the `.pp` files in the directory structure had been concatenated
into a single `site.pp` manifest.

The ability to use a directory structure is typically used to keep instructions per node
in separate files, and the ability to use nested directories is typically used to group files
in order to make it easier to name and find them.

An alternative to using a directory structure to assign classes and parameters to nodes
is to use the [ENC][enc].
