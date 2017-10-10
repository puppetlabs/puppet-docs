---
layout: default
title: "Puppet Server Documentation"
toc: false
---

Puppet Server is the next-generation application for managing Puppet agents.

For the most part, we've integrated the Puppet Server documentation into [the Puppet documentation](/puppet/latest/). For a list of all documentation related to Puppet Server, or for information about an older version of Puppet Server, see one of the links below.

## Versions

> **Note:** The Puppet Server 2.x series supports Puppet 4.x, and the 1.x series supports later versions of Puppet 3.x. See the release notes for each version for full compatibility details.

<ul>
{% assign this_doc = "puppetserver" %}

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

