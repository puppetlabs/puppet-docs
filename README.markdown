Puppet Docs
===========

Curated documentation for Puppet and tools for generating a deployable copy
of the docs site.

Installation
------------

The tools and rake tasks for generating the puppet-docs site require Ruby 1.8.7.

To install the documentation-generating code:

1.  Clone the repository:

        $ git clone git://github.com/puppetlabs/puppet-docs.git

2.  Use your package manager to install rake, libxml2-dev, libxslt-dev, and pygments.
    Package names may vary by platform; for example, using Macports, these packages could
    be installed with:

        $ sudo port -d install rb-rake libxml2 libxslt py-pygments

    Make sure there is a `pygmentize` command available! If your package tools
    install the pygmentize binary with a different name (like Macports does),
    you must symlink it so Jekyll can find the command.

3.  Install the Ruby dependencies:

    The Puppet docs project uses Ruby Bundler to ensure that you have the correct dependencies
    installed on your system and that the documents are being built with the correct versions
    of needed binaries. To install the project's requirements:

        $ sudo gem install bundler
        $ cd puppet-docs
        $ bundle install --path=vendor/bundle

Building and Viewing
--------------------

1.  Generate the documentation:

        $ rake generate

2.  Start a little server to view it at http://localhost:9292:

        $ rake serve

    (You can use `rake run` to combine these steps.)

Deploying the Site
------------------

To deploy a new copy of the site to the production servers (Puppet Labs employees only):

    $ rake deploy

(This is several commands bundled into one: `rake build`,
`rake mirror0 vlad:release`, and `rake mirror1 vlad:release`.)

Build Generated Docs for a Given Puppet Version
-----------------------------------------------

    $ VERSION=0.25.0 rake references:puppetdoc

For the generated docs to build correctly, you may not have Puppet in your default Ruby load path.
We recommend building the generated docs on a system where you have not installed Puppet as
a package for your operating system. If this isn't possible, we recommend using [rvm][] or
[rbenv][] with a minimal Ruby installation to build the generated docs.


Build Updated HTML Manpages
---------------------------

    $ PUPPETDIR=~/Documents/puppet rake update_manpages

You will need to point the PUPPETDIR environment variable at a git checkout of
the Puppet code. Currently, we only maintain a single version of the manpages,
and this task will only work cleanly with Puppet 2.7 or higher. Unlike
generating references, this task is not currently run on a set schedule.

Generate a PDF or Other Single-File Documentation
-------------------------------------------------

    (update page order)
    $ rake generate_pdf
    $ rake serve_pdf
    (replace '-latest-' in index.html with literal
        latest version, e.g. '-2-6-7-')
    (point PDF-generating tool at localhost:9292)

See pdf_mask/README.txt for more details.

Errors and Omissions
--------------------

If something in the documentation doesn't seem right -- or if you
think something important is missing, please [submit a ticket][1] to
[the "puppet-docs" project][1] (not to Puppet itself).  The best way
to get your change in is to contribute it; see the next section for
details.


Contributing Changes
--------------------

* Fork the project (we recommend [GitHub][3])
* Make sure you read the writing guide (README_WRITING.markdown) and the
style and usage guide, which are both in the root of this project.
* Make your documentation addition/fix -- preferably in a branch.
* If you're fixing or adding features to the generation
  infrastructure, add some passing specs.
* Commit, do not mess with the README, LICENSE, etc.
* [Submit a ticket][1] requesting your contribution be added, and make
  sure you note the location of the repository and branch.

[1]: http://tickets.puppetlabs.com/browse/DOCUMENT
[3]: http://github.com
[4]: http://docs.puppetlabs.com/guides/style_and_usage.html
[rvm]: https://rvm.io
[rbenv]: https://github.com/sstephenson/rbenv

Copyright
---------

Copyright (c) 2009-2016 Puppet, Inc. See LICENSE for details.


