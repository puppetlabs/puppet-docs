---
layout: default
title: "Facter documentation"
toc: false
---

Facter is Puppet's cross-platform system profiling library. It discovers and reports per-node facts, which are available in your Puppet manifests as variables.

## Versions

> **Note**: Facter versions prior to 3.0 will go end of life December 31, 2016. Please update if you haven't already.

<ul>
{% assign this_doc = "facter" %}

{% assign real_name = site.document_names[this_doc] %}
{% for base_url in site.document_version_order[this_doc] %}
<li>
<a href="{{base_url}}">{{real_name}} {{site.document_list[base_url].version}}</a>
{% if site.document_list[base_url].my_versions.pe != "latest" %}(Included in Puppet Enterprise {{site.document_list[base_url].my_versions.pe}}){% endif %}
</li>
{% endfor %}
</ul>

