# Puppet Docs

Curated documentation for Puppet.

## Where is everything?

Most of our documentation has been moved out of this repository. This repo contains:
  * Some of our older, unmaintained documentation, which is deprecated and may be removed from this repo without further notice. For archived docs for unmaintained, unsupported versions of Puppet, see the [Puppet docs archive](https://github.com/puppetlabs/docs-archive).
  * Reference documentation generated from code. This reference documentation is then rendered into HTML and included in the Puppet docs website.

As of Puppet 5.5, Puppet docs were migrated into the DITA XML format and have been maintained in a CMS. We removed each migrated page from this repository, so that the old content wasn't accidentally published.

As of Facter 3.12, the Facter docs were migrated to DITA and organized as part of the Puppet doc set. Updates to 3.12 (and later) should be made in DITA, not in this repo. The generated `core_facts.md` file is still this repository, but has moved to the `puppet/x.y` folder instead of `facter/x.y`.

## Contributions from the Puppet community are welcome

If something in the documentation doesn't seem right, or if you think something important is missing, we want to hear from you! Please send us feedback in any of the following ways:
* Use the feedback form on the relevant page to send us details of the issue.
* Open a Jira ticket in the DOCUMENT project here: https://tickets.puppetlabs.com/projects/DOCUMENT/ Let us know the URL of the page, and describe the changes you think it needs.
* Email `docs@puppet.com` if you have questions about contributing to the documentation.


## Copyright

Copyright (c) 2009-2021 Puppet, Inc. See LICENSE for details.
