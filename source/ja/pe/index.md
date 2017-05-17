---
title: "Puppet Enterprise (日本語)"
---

<ul>
{% assign this_doc = "pe_ja" %}

{% assign real_name = site.document_names[this_doc] %}
{% for base_url in site.document_version_order[this_doc] %}
{% if site.document_version_index[this_doc].latest == base_url %}{% assign past_latest = true %}{% endif %}
<li>
<a href="{{base_url}}">{{real_name}} {{site.document_list[base_url].version}}</a>
{% unless past_latest %}(not yet released){% endunless %}
{% if site.document_version_index[this_doc].latest == base_url %}(latest){% endif %}
</li>
{% endfor %}
</ul>
