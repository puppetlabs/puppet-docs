---
layout: pe2experimental
title: "PE 2.0 » Welcome » Known Issues"
---

{% capture security_info %}Detailed info about security issues lives at <http://puppetlabs.com/security>, and security hotfixes for supported versions of PE are always available at <http://puppetlabs.com/security/hotfixes>. For security notifications by email, make sure you're on the [PE-Users](http://groups.google.com/group/puppet-users) mailing list.{% endcapture %}

Known Issues in Puppet Enterprise 2.0
=====

As we discover them, this page will be updated with known issues in each maintenance release of Puppet Enterprise 2.0. If you find new problems yourself, please file bugs in Puppet [here][puppetissues] and bugs specific to Puppet Enterprise [here][peissues]. 

{% comment %} (uncomment this once we have some issues)
To find out which of these issues you are affected by, run `/opt/puppet/bin/puppet --version`, the output of which will look something like `2.7.6 (Puppet Enterprise 2.0.1)`. To upgrade to a newer version of Puppet Enterprise, see the [chapter on upgrading](./install_upgrading.html).
{% endcomment %}

[peissues]: http://projects.puppetlabs.com/projects/puppet-enterprise/issues
[puppetissues]: http://projects.puppetlabs.com/projects/puppet/issues

Dynamic Man Pages are Incorrectly Formatted
-----

Man pages generated with the `puppet man` subcommand are not formatted as proper man pages, and are instead displayed as Markdown source text. This is a purely cosmetic issue, and the pages are still fully readable. 