Puppet Docs
===========

Curated documentation for Puppet.

Installation
------------

Steps for installing the documentation-generating code:

1.  Clone the repository:

    $ git clone git://github.com/reductivelabs/puppet-docs.git

2.  Use your package manager to install rake, libxml2-dev, and
    libxslt-dev.  Package names may vary by platform.

3.  Install the ruby dependencies

    $ sudo rake install

4.  Generate the documentation:

    $ rake generate

5.  Start a little server to view it at http://localhost:9292:

    Install librack-ruby1.8 using your package manager.   The
    name of the package may vary by platform.

    Also install python-docutils which is needed to build
    the generated reference docs.

    $ rake serve

    Note: Use `rake run` to combine these last two steps.

Build Generated Docs For A Given Puppet Version
-----------------------------------------------

$ VERSION=0.25.0 rake references:puppetdoc

requires python-docutils

Errors and Omissions
--------------------

If something in the documentation doesn't seem right -- or if you
think something important is missing, please [submit a ticket][1] to
[the "puppet-docs" project][1] (not to Puppet itself).  The best way
to get your change in is to contribute it; see the next section for
details.

NOTE: If you're talking about additional content, keep in mind that it might
make more sense to be on the [Wiki][2].  You might want to start by
adding it there.

Contributing Changes
--------------------

* Fork the project (we recommend [GitHub][3])
* Make sure you read the writing guide, README_WRITING.markdown
* Make your documentation addition/fix -- preferably in a branch.
* If you're fixing or adding features to the generation
  infrastructure, add some passing specs.
* Commit, do not mess with the README, LICENSE, etc.
* [Submit a ticket][1] requesting your contribution be added, and make
  sure you note the location of the repository and branch.

[1]: http://projects.puppetlabs.com/projects/puppet-docs
[2]: http://projects.puppetlabs.com/projects/puppet/wiki/
[3]: http://github.com

Copyright
---------

Copyright (c) 2009-2010 Puppet Labs. See LICENSE for details.


