Puppet Docs
===========

Curated documentation for Puppet.

Installation
------------

Clone the repository:

    $ git clone git://github.com/reductivelabs.com/puppet-docs.git
    
Install the `bundler` gem, if you don't have it.

    $ sudo gem install bundler

Install the dependencies (this won't install them system-wide):

    $ cd puppet-docs
    $ gem bundle

Generate the documentation:

    $ bin/generate

Look at `output/index.html`, eg:

    $ open output/index.html

Contribution
------------

* Fork the project.
* Make your documentation addition/fix
* If you're fixing or adding features to the generation 
  infrastructure, add tests (or right now, start them!)
* Commit, do not mess with the README, LICENSE, etc.
* TODO: Add a ticket to the Redmine project when you're done with details.

Copyright
---------

Copyright (c) 2009 Reductive Labs. See LICENSE for details.
