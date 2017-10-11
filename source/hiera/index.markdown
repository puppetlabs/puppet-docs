---
layout: default
title: "Hiera documentation"
toc: false
---

{% partial /hiera/_hiera_update.md %}

Hiera is a key/value lookup tool for configuration data. Hiera makes Puppet better by keeping site-specific data out of your manifests. Puppet classes can request whatever data they need, and your Hiera data will act like a site-wide config file. Hiera 3 is compatible with Puppet 4; for Puppet 3.8 or earlier, use Hiera 1.

## Versions

<ul>
{% assign this_doc = "hiera" %}

{% assign real_name = site.document_names[this_doc] %}
{% for base_url in site.document_version_order[this_doc] %}
{% if site.document_version_index[this_doc].latest == base_url %}{% assign past_latest = true %}{% endif %}
<li>
<a href="{{base_url}}">{{real_name}} {{site.document_list[base_url].version}}</a>
{% unless past_latest %}(not yet released){% endunless %}
{% if site.document_list[base_url].my_versions.pe != "latest" %}(Included in Puppet Enterprise {{site.document_list[base_url].my_versions.pe}}){% endif %}
</li>
{% endfor %}
</ul>
