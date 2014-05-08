[fromsource]: #installing-from-a-tarball

This is almost never recommended, but may be necessary in some cases.

#### 1. Ensure Prerequisites are Installed

Use your OS's package tools to install Ruby. In some cases, you may need to compile and install it yourself.

On Linux platforms, you should also ensure that the LSB tools are installed; at a minimum, we recommend installing `lsb_release`. See your OS's documentation for details about its LSB tools.

If you wish to use Puppet ≥ 3.2 [with `parser = future` enabled](/puppet/3/reference/lang_experimental_3_2.html), you should also install the `rgen` gem.

#### 2. Download Puppet and Facter

* Download Puppet [here][downloads].
* Download Facter [here](http://downloads.puppetlabs.com/facter/).

#### 3. Install Facter

Unarchive the Facter tarball, navigate to the resulting directory, and run:

    $ sudo ruby install.rb

#### 4. Install Puppet

Unarchive the Puppet tarball, navigate to the resulting directory, and run:

    $ sudo ruby install.rb

#### 5. Configure and Enable

Installing from a tarball requires some additional steps:

* Manually create a `puppet` group, by running `sudo puppet resource group puppet ensure=present`.
* Manually create a `puppet` user, by running `sudo puppet resource user puppet ensure=present gid=puppet shell='/sbin/nologin'`.
* Create and install init scripts for the puppet agent and/or puppet master services. See the `ext/` directory in the Puppet source for example init scripts {{ example_init }}.
* Manually create an `/etc/puppet/puppet.conf` file.

{{ after }}
