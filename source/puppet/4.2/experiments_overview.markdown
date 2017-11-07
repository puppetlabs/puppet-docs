---
layout: default
title: "Experimental Features: Overview"
canonical: "/puppet/latest/experiments_overview.html"
---


Summary
-----

Officially released versions of Puppet can include certain experimental features, which are turned off by default. See the sidebar menu of this page for information on the experimental features currently available.

Typically, these features are being considered for widespread adoption but are not yet ready for production. Sometimes they have a solid design but unknown performance and resource usage and need to be tested in the field before they can be considered safe. Other times, even the design is tentative, and we need feedback from users who find it usable or unusable.

By shipping these features early in disabled form, we hope to lower the bar for testing and giving feedback. We want it to be easier for normal users to join conversations about Puppet's future.


Risks and Support
-----

Experimental features are **not officially supported** by Puppet Labs, and we do not recommend that you turn them on in a production environment. They are available for testing in relatively safe scratch environments, and are used **at your own risk.** Puppet employees and community members will do their best to help you in informal channels like IRC and the puppet-users and puppet-dev mailing lists, but we make no promises about experimental functionality.

Enabling experimental features might degrade the performance of your Puppet infrastructure, interfere with the normal operation of your managed nodes, introduce unexpected security risks, or have other undesired effects.

This is especially relevant to Puppet Enterprise customers. If Puppet Labs support is assisting you with a problem, we might ask you to disable any experimental features.

Changes to Experimental Features
-----

Experimental features are exempt from semantic versioning --- they can change at any time, not limited to major or minor release boundaries.

These changes might include adding or removing functionality, changing the names of settings and other affordances, and more.

Documentation of Experimental Features
-----

The Puppet reference manual contains documentation pages for all of the currently available experimental features. These pages will be focused on enabling a feature and running through the most interesting parts of its functionality; they might lag slightly behind the feature as implemented.

When a feature has experienced major changes across minor versions, we will note the differences at the top of that feature's page.

Each feature's page will attempt to give some context about the status of that feature and its prospects for official release.

Giving Feedback on Experimental Features
-----

If you are testing Puppet's experimental features: Thank you! Please tell us more about your experience, so we can keep making Puppet better.

* The best places to talk about experimental features are the [puppet-users](https://groups.google.com/group/puppet-users) and [puppet-dev](https://groups.google.com/group/puppet-dev) mailing lists. This tells us what's working and what isn't, while also helping others learn from your experience. For more information about the Puppet Labs mailing lists, please see [the community guidelines for mailing lists](/community/community_guidelines.html#mailing-list-guidelines).
* For more immediate conversations, you can use the #puppet and #puppet-dev channels on irc.freenode.net. For more information about these channels, please see [the community guidelines for IRC](/community/community_guidelines.html#irc-guidelines).
