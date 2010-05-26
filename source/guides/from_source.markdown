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
{:shell}

and, if you want to run the tests, rake:

    $ rake -V
{:shell}

While Puppet should work with ruby 1.8.1, there have been many reports of
problems with this version.

Make sure you have [Git][1]:

    $ git --version
{:shell}

Get the Source
--------------

Puppet relies on another Puppet Labs library,
[Facter][2]. Create a working directory and get them both:

    $ SETUP_DIR=~/git
    $ mkdir -p $SETUP_DIR
    $ cd $SETUP_DIR
    $ git clone git://github.com/reductivelabs/facter
    $ git clone git://github.com/reductivelabs/puppet
{:shell}

You will need to periodically run:

    $ git pull --rebase origin
{:shell}

From your repositories to periodically update your clone to the latest code.

If you want access to all of the tags in the git repositories, so that
you can compare releases, for instance, do the following from within
the repository:

    $ git fetch --tags
{:shell}

Then you can compare two releases with something like this:

    $ git diff 0.25.1 0.25.2
{:shell}

Most of the development on puppet is done in branches based either on
features or the major revision lines. Currently the "stable" branch is
0.25.x and development is in the "master" branch.  You can change to
and track branches by using the following:


    git checkout --track -b 0.25.x origin/0.25.x
{:shell}

Tell Ruby How to Find Puppet and Facter
---------------------------------------

Finally, we need to put the puppet binaries into our path and make the
Puppet and Facter libraries available to Ruby:

    $ PATH=$PATH:$SETUP_DIR/facter/bin:$SETUP_DIR/puppet/bin
    $ RUBYLIB=$SETUP_DIR/facter/lib:$SETUP_DIR/puppet/lib
    $ export PATH RUBYLIB
{:shell}

Facter changes far less often than Puppet and it is very minimal (a
single library file and a single executable), so it is probably best
to just install it directly:

    $ cd facter
    $ sudo ruby ./install.rb
{:shell}

[1]: http://git.or.cz/
[2]: http://puppetlabs.com/products/facter
