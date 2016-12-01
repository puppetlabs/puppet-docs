---
layout: default
title: "Formats: Reports"
canonical: "/puppet/latest/reference/format_report.html"
---


Puppet 3.0.0 through 3.2.4 uses report format 3. Puppet 3.3.0 and later uses report format 4.

Starting with Puppet 3.3.0, report objects being sent to the puppet master can be serialized as pson (a variant of json that allows byte sequences that aren't valid utf-8 characters). This is a change from Puppet 3.2.4 and earlier, which only allowed reports to be serialized as yaml. The report serialization format can be changed for compatibility with older puppet masters with the `report_serialization_format` setting.

{% include reportformat/3.markdown %}

{% include reportformat/4.markdown %}
