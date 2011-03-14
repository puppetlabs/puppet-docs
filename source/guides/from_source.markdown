---
layout: default
title: Using Puppet From Source
---

Using Puppet From Source
========================

Puppet is implemented in Ruby and uses standard Ruby
libraries. You should be able to run Puppet on any Unix-style host
with ruby. Windows support is planned for future releases.

* * *

Before you Begin
----------------

Make sure your host has Ruby version 1.8.2 or later:

    $ ruby -v

and, if you want to run the tests, rake:

    $ rake -V

While Puppet should work with ruby 1.8.1, there have been many reports of
problems with this version.

Make sure you have [Git][1]:

    $ git --version

Get the Source
--------------

Puppet relies on another Puppet Labs library,
[Facter][2]. Create a working directory and get them both:

    $ SETUP_DIR=~/git
    $ mkdir -p $SETUP_DIR
    $ cd $SETUP_DIR
    $ git clone git://github.com/puppetlabs/facter
    $ git clone git://github.com/puppetlabs/puppet

You will need to periodically run:

    $ git pull --rebase origin

From your repositories to periodically update your clone to the latest code.

If you want access to all of the tags in the git repositories, so that
you can compare releases, for instance, do the following from within
the repository:

    $ git fetch --tags

Then you can compare two releases with something like this:

    $ git diff 0.25.1 0.25.2

Most of the development on puppet is done in branches based either on
features or the major revision lines. Currently the "stable" branch is
0.25.x and development is in the "master" branch.  You can change to
and track branches by using the following:


    git checkout --track -b 0.25.x origin/0.25.x

Tell Ruby How to Find Puppet and Facter
---------------------------------------

Finally, we need to put the puppet binaries into our path and make the
Puppet and Facter libraries available to Ruby:

    $ PATH=$PATH:$SETUP_DIR/facter/bin:$SETUP_DIR/puppet/bin
    $ RUBYLIB=$SETUP_DIR/facter/lib:$SETUP_DIR/puppet/lib
    $ export PATH RUBYLIB

Note: environment variables (depending on your OS) can get stripped
when running as sudo.  If you experience problems, you may want to simply
execute things as root.

Next we must install facter.  Facter changes far less often than Puppet and is a very minimal tool/library:

    $ cd facter
    $ sudo ruby ./install.rb

[1]: http://git.or.cz/
[2]: http://puppetlabs.com/products/facter
