---
layout: default
title: Contribute
---

Contribute
==========

We welcome community contributions to the documentation! You can help by filing
tickets, reporting errors and typos, and editing the documentation.

* * *

Filing Tickets
--------------

The Puppet documentation is managed like a software project, and you can file
bug reports and feature requests in its
[issue tracker](https://tickets.puppetlabs.com/browse/DOCUMENT).
You'll need to create a [JIRA account](https://tickets.puppetlabs.com/secure/Signup!default.jspa)
if you don't already have one.

In your ticket, please give as much information as possible about what's
missing, what's inaccurate, or what's outdated, including URLs to the affected pages
and your best understanding of what the documentation _should_ say.
We'll begin looking into the problem and update the ticket as soon as possible.

Reporting Errors and Typos
--------------------------

If you spot a typo or other minor error and don't want to go through
the overhead of filing a ticket or editing the documentation, you can
report it via email to <docs@puppetlabs.com>.

Editing the Documentation
-------------------------

If there's a hole in the documentation and you know just what needs to be added, here's how to contribute directly:

### Use Git

Version control for the project is handled with
[Git](http://git-scm.com/). The URL of the repository is <http://github.com/puppetlabs/puppet-docs>
We recommend using a [GitHub](http://github.com) account and pull requests to
contribute to this project, but we also accept Git patches.

### Fork the Project and Clone the Repo

If you're using Github, [fork](http://help.github.com/forking/) our
repository, and clone your fresh repository to your local disk:

    $ git clone git@github.com:yourname/puppet-docs.git

If you're not using GitHub, just clone our copy directly (you can push
to your own remote host or provide git patches later):

    $ git clone git://github.com/puppetlabs/puppet-docs.git

### Learn How to Write Puppet Documentation

Read the [README](http://github.com/puppetlabs/puppet-docs/blob/master/README.markdown)
and [README_WRITING](http://github.com/puppetlabs/puppet-docs/blob/master/README_WRITING.markdown)
files in the puppet-docs source to learn more about how our documentation works;
read the [documentation style and usage guide](http://github.com/puppetlabs/puppet-docs/blob/master/style_and_usage.markdown)
for the project's language conventions. 

### Make Your Edits

Add your documentation fixes.

NOTE: If you modify any of the code used to generate the documentation, make sure you
provide passing tests that cover your changes.

### Preview Your Changes

Before committing any changes or submitting a patch, you should preview your changes. The [README](http://github.com/puppetlabs/puppet-docs/blob/master/README.markdown) provides information on how to set up the correct tools to run a local server that will allow you to preview all your changes as they'll appear on the website. 

### Commit and Push/Patch

* If you're using GitHub (or your own hosted repository), push to a
  remote branch.
* If you're not working with a remote, generate a patch of your
  changes for the next step.

NOTE: If you need a refresher on how to commit and work with remote
repositories in Git, you may want to visit [GitHub's articles and
screencasts](http://learn.github.com/).

### Submit a Ticket

Visit the [Puppet Documentation Project](https://tickets.puppetlabs.com/browse/DOCUMENT)
in JIRA and submit a ticket describing the problem and your proposed
changes; you'll need to create a [JIRA account](tickets.puppetlabs.com/secure/Signup!default.jspa)
if you don't already have one. Be sure to provide the background on
your change, the versions of Puppet (or supporting project)
to which the change pertains, and (if you're using GitHub or another
remote host) the URL to the branch you're submitting. (If you're working
with only a local Git repository, please attach one or more patches containing your edits.)

We'll get back to you on your contribution as soon as possible. And thanks!
