Puppet Docs
===========

Curated documentation for Puppet.

Installation
------------

1.  Clone the repository:

    $ git clone git://github.com/reductivelabs.com/puppet-docs.git

2.  Use your package manager to install rake.    

3.  Install the dependencies

    $ sudo rake install

    If the above fails, you may need to use your package manager to install
    files such as libxml2-dev and libxslt-dev

4.  Generate the documentation:

    $ rake generate

5.  Start a little server to view it at http://localhost:9292:

    $ rake serve

    Note: Use `rake run` to combine these last two steps.

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

[1]: http://projects.reductivelabs.com/projects/puppet-docs
[2]: http://reductivelabs.com/trac/puppet/wiki
[3]: http://github.com

Copyright
---------

Copyright (c) 2009 Reductive Labs. See LICENSE for details.
