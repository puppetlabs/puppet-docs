# Configuring docs generation

Curated documentation for Puppet and tools for generating a deployable copy
of the docs site.

> **NOTE:** These instructions are no longer relevant for generating most documentation
published to puppet.com/docs, but are still useful for testing changes to content
generated from Puppet codebases.

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

Copyright
---------

Copyright (c) 2009-2019 Puppet, Inc. See LICENSE for details.
