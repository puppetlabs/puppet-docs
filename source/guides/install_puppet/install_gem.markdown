[fromgems]: #installing-from-gems

On \*nix platforms without native packages available, you can install Puppet with Ruby's `gem` package manager.

#### 1. Ensure Prerequisites are Installed

Use your OS's package tools to install both Ruby and RubyGems. In some cases, you may need to compile and install these yourself.

On Linux platforms, you should also ensure that the LSB tools are installed; at a minimum, we recommend installing `lsb_release`. See your OS's documentation for details about its LSB tools.

#### 2. Install Puppet

To install Puppet and Facter, run:

    $ sudo gem install puppet

#### 3. Configure and Enable

{% capture example_init %}([Red Hat](https://github.com/puppetlabs/puppet/blob/master/ext/redhat), [Debian](https://github.com/puppetlabs/puppet/blob/master/ext/debian), [SUSE](https://github.com/puppetlabs/puppet/blob/master/ext/suse), [systemd](https://github.com/puppetlabs/puppet/blob/master/ext/systemd), [FreeBSD](https://github.com/puppetlabs/puppet/blob/master/ext/freebsd), [Gentoo](https://github.com/puppetlabs/puppet/blob/master/ext/gentoo), [Solaris](https://github.com/puppetlabs/puppet/blob/master/ext/solaris)){% endcapture %}

Installing with gem requires some additional steps:

* Manually create a `puppet` group, by running `sudo puppet resource group puppet ensure=present`.
* Manually create a `puppet` user, by running `sudo puppet resource user puppet ensure=present gid=puppet shell='/sbin/nologin'`.
* Create and install init scripts for the puppet agent and/or puppet master services. See the `ext/` directory in the Puppet source for example init scripts {{ example_init }}.
* Manually create an `/etc/puppet/puppet.conf` file.
* Locate the Puppet source on disk, and manually copy the `auth.conf` file from the `/conf` directory to `/etc/puppet/auth.conf`.
* If you get the error `require: no such file to load` when trying to run Puppet, define the RUBYOPT environment variable as advised in the [post-install instructions](http://docs.rubygems.org/read/chapter/3#page70) of the RubyGems User Guide.

{{ after }}

