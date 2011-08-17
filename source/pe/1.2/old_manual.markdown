Getting to Know Puppet Enterprise
=================================

An unmodified installation of Puppet Enterprise differs from an unmodified installation of the free version of Puppet in several subtle and not-so-subtle ways. 

The most immediate difference you'll notice is that every Puppet Enterprise component you install on a given machine is immediately started upon the installer's completion, and is already configured to start at boot; you do not need to configure additional `init` scripts. 

The following are some other important differences which aren't as immediately evident but which are worth becoming aware of:

## puppet master Under Passenger and Apache

Puppet master communicates with its agents via HTTP, and thus needs a web server; in unmodified standard Puppet, this means WEBrick, which is bundled with Ruby 1.8. 

WEBrick is an ideal default server because it works out of the box without additional configuration; it is less than ideal for production deployment, as it cannot handle simultaneous requests in parallel. Deployments which need to scale beyond an approximately ten node trial usually adopt one of several more efficient web servers.

Puppet Enterprise bundles Apache 2.2 and [Phusion Passenger](http://www.modrails.com/) (AKA `mod_rack` / `mod_passenger` / `mod_rails`), Puppet Labs' recommended solution for scaling, and it configures puppet master appropriately during installation. If you're familiar with puppet master under WEBrick or are following a tutorial written for the standard version of Puppet, you'll notice some behavioral differences; most visibly, puppet master often does not appear in the list of running processes, and there is no puppet master init script.

This is due to the way puppet master is managed by Apache and Passenger. In a nutshell, Apache handles all incoming HTTP requests, and if any of said requests are destined for an application managed by Passenger, `mod_passenger` will spawn and manage instances of that application as needed. (A more detailed but still compact overview of how Passenger manages Ruby applications can be found [here][passenger-architecture].) The upshot is that puppet master never needs to be run directly and will frequently not even be running, but as long as Apache (`pe-httpd`) is running, puppet master will be able to respond efficiently to agent nodes. 

Puppet Dashboard also runs under Passenger and Apache, and if you have installed puppet master and Dashboard on the same system, they will make use of the same Apache processes. 

Should you need to restart puppet master or Puppet Dashboard, you can simply restart Apache; use either your system's service controls or the copy of `apachectl` located in `/opt/puppet/sbin`. Alternately, if you wish to restart either service independently of Apache, you can modify (with `touch`, e.g.) `/var/opt/lib/pe-puppetmaster/tmp/restart.txt` and/or `/opt/puppet/share/puppet-dashboard/tmp/restart.txt`, respectively; see the Phusion Passenger documentation for more details. 

[passenger-architecture]: http://www.modrails.com/documentation/Architectural%20overview.html

## Names and Locations

Part of this distribution's goal is to provide a self-contained Puppet stack; to avoid file name and process name collisions, many of the standard files and directories are installed in locations slightly different from where a hand-installed/gem-installed/vendor-supplied copy of Puppet would place them. As such, experienced users may be briefly disoriented, and much of the standard documentation should be read with these alternate locations in mind. Below is a brief summary of how Puppet Enterprise's organization differs from that of standard Puppet:

* The Puppet software, which includes self-contained Ruby and Apache environments, is installed in `/opt/puppet`. Executables are in `/opt/puppet/bin` and `/opt/puppet/sbin`.
* Puppet Enterprise's main config directory is located at `/etc/puppetlabs/puppet`, rather than the more common `/etc/puppet`.
* User names, service and process names, and the names of several key directories (notably Puppet's `vardir`, `logdir`, and `rundir`; see the main Puppet documentation for more information about these directories) are all prefixed with `pe-`.
* As Puppet Enterprise uses its own version of Ruby, care must be taken to ensure that any `rake` tasks (e.g. for maintenance of Dashboard reports) or ad-hoc recipes are interpreted by the proper copy of the Ruby binaries. This can be accomplished by changing the environment on a per-command basis; e.g.: `PATH=/opt/puppet/bin:$PATH rake RAILS_ENV=production reports:prune upto=1 unit=mon`

