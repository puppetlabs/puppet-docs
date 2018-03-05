Puppet Docs
===========

Curated documentation for Puppet and tools for generating a deployable copy
of the docs site.

Installation
------------

The tools and rake tasks for generating the puppet-docs site require Ruby 2.2.3 or greater.

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

Building and viewing
--------------------

1.  Generate the documentation:

        $ rake generate

2.  Start a little server to view it at http://localhost:9292:

        $ rake serve

    (You can use `rake run` to combine these steps.)
    Note that you will get errors because two repos, git@github.com:puppetlabs/DistelliHugoDocs.git and git@github.com:puppetlabs/pe-docs-private.git, are private. Remove these two references from the source/_config.yml file to fix the issue.

Errors and omissions
--------------------

If something in the documentation doesn't seem right -- or if you
think something important is missing, please [submit a ticket][1] to
[the "DOCUMENTATION" project][1] (not to Puppet itself).  The best way
to get your change in is to contribute it; see the next section for
details.

[1]: http://tickets.puppetlabs.com/browse/DOCUMENT
[3]: http://github.com
[4]: http://docs.puppetlabs.com/guides/style_and_usage.html

Copyright
---------

Copyright (c) 2009-2017 Puppet, Inc. See LICENSE for details.


