#### 1. Download the Package

OS X users should install Puppet with official Puppet Labs packages. [Download them here](http://downloads.puppetlabs.com/mac/). You will need:

* The most recent Facter package
* The most recent Hiera package
* The most recent Puppet package

#### 2. Install Facter

Mount the Facter disk image, and run the installer package it contains.

#### 3. Install Hiera

Mount the Hiera disk image, and run the installer package it contains.

#### 4. Install Puppet

Mount the Puppet disk image, and run the installer package it contains.

#### 5. 10.8 and Earlier: Install JSON Gem

OS X 10.9 Mavericks includes the Ruby JSON library by default, but earlier versions don't. If installing on 10.8 or earlier, make sure JSON is installed by running:

    $ sudo gem install json

#### 6. Configure and Enable

The OS X packages are currently fairly minimal, and do not create launchd jobs, users, or default configuration or manifest files. You will have to:

* Manually create a `puppet` group, by running `sudo puppet resource group puppet ensure=present`.
* Manually create a `puppet` user, by running `sudo puppet resource user puppet ensure=present gid=puppet shell='/sbin/nologin'`.
* If you intend to run the puppet agent daemon regularly, or if you intend to automatically run puppet apply at a set interval, you must create and register your own launchd services. [See the post-installation instructions](#with-launchd) for a model.

{{ after }}
