Puppet Docs
===========

OSX specific instructions assuming you are using MacPorts
http://www.macports.org

Installation
------------

Steps for installing the documentation-generating code:

1.  Clone the repository:

    $ git clone git://github.com/puppetlabs/puppet-docs.git

2.  Add the mcollective documentation:

    $ git submodule update --init

2.  Install rake, libxml2, libxslt, and pygments.

    $ sudo port -d install rb-rake libxml2 libxslt py-pygments

3.  Install the ruby dependencies

    $ sudo rake install

4.  Generate the documentation:

    $ rake generate

5.  Start a little server to view it at http://localhost:9292:

    $ rake serve

    Note: Use `rake run` to combine these last two steps.

Copyright
---------

Copyright (c) 2009-2011 Puppet Labs. See LICENSE for details.


