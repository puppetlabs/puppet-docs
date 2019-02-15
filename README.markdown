# Puppet Docs

Curated documentation for Puppet.

## Where is everything?

This repo has been split into two distinct branches of documentation, archived and current. The master branch contains only documentation that is presently being generated into HTML and delivered to our Drupal integration. The archive branch contains older versions of documentation that are to be migrated to a new archive site.

Starting in Puppet 5.5, and continuing into current releases, we are migrating much of the Puppet documentation into DITA format in a CMS called easyDITA. When we have migrated a Markdown page in the docs to DITA, we delete it from here so that it's clear what page to update when changes come (and so that the old content isn't accidentally published). 

Starting in Facter 3.12, the Facter docs have been migrated to easyDITA (in the Puppet doc set), so updates to 3.12 (and later) should be made there instead of here. The generated core_facts.md file is still in github, but has moved to the puppet/x.y folder instead of facter/x.y.

## Contributions from the Puppet community are still very welcome.

- If something in the documentation doesn't seem right, or if you think something important is missing, open a Jira ticket in the DOCUMENT project here: https://tickets.puppetlabs.com/projects/DOCUMENT/ Let us know the URL of the page, and describe the changes you think it needs.
- Or email docs@puppet.com if you have questions about contributing to the documentation.


## Copyright

Copyright (c) 2009-2018 Puppet, Inc. See LICENSE for details.
