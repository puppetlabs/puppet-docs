# Puppet Docs

Curated documentation and issue tracker for Puppet

## Where is everything?

Most of our documentation has been moved out of this repository. This repo contains:
  * Some of our older, unmaintained documentation, which is deprecated and may be removed from this repo without further notice. For archived docs for unmaintained, unsupported versions of Puppet, see the [Puppet docs archive](https://github.com/puppetlabs/docs-archive).
  * Reference documentation generated from code. This reference documentation is then rendered into HTML and included in the Puppet docs website.
  * The issue tracker, which community members can use to suggest improvements to puppet.com/docs.

As of Puppet 5.5, Puppet docs were migrated into the DITA XML format and have been maintained in a CMS. We removed each migrated page from this repository, so that the old content wasn't accidentally published.

As of Facter 3.12, the Facter docs were migrated to DITA and organized as part of the Puppet doc set. Updates to 3.12 (and later) should be made in DITA, not in this repo. The generated `core_facts.md` file is still this repository, but has moved to the `puppet/x.y` folder instead of `facter/x.y`.

## Reporting issues

Community members can use this repository to suggest documentation improvements.
The Technical Publications team regularly monitors and triages issues and requests here.
Planning and roadmap activity takes place internally, so you might not see much activity until a writer begins actively working on a reported issue.

💡 Restriction: There are no SLA agreements for issues filed in this way, and customer reports take priority. If you have a support contract, you should raise issues via [support request](https://support.puppet.com/) to get them resolved expediently.

💡 Restriction: As this is a public repo, avoid including any confidential or sensitive information in issues filed.

1. To get started, use the [`Issues`](https://github.com/puppetlabs/puppet-enterprise_issues/issues) tab above.
2. Search the existing queue to see if your concern has already been reported: 
    * If the concern was reported, you can comment on it with additional information or react with a 👍
      to add your support. You’ll get any future notifications of activity on that ticket.
    * If the concern was not reported, you can file your own issue, following the issue template to include as much
      helpful detail as you can. Include the full URL of the documentation webpage.

Thank you so much for helping us improve our products! Email `docs@puppet.com` if you have questions about contributing to the documentation.


## Copyright

Copyright (c) 2009-2024 Puppet, Inc. See LICENSE for details.
