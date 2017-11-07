---
layout: default
title: "Puppet Enterprise User's Guides"
toc: false
---

Puppet Enterprise is the best-of-breed distribution for the Puppet family of systems automation tools.

## Versions

> **Note:** We've skipped several version numbers in the course of PE's history (there was no 3.4, 3.5, 3.6, or 2016.3), and have changed version numbering schemes a few times. For information on the current versioning scheme, see [Puppet Enterprise Version Numbers](/pe/latest/pe_versioning.html).

<ul>
{% assign this_doc = "pe" %}

{% assign real_name = site.document_names[this_doc] %}
{% for base_url in site.document_version_order[this_doc] %}
<li>
<a href="{{base_url}}">{{real_name}} {{site.document_list[base_url].version}}</a>
</li>
{% endfor %}
</ul>
