Puppet Dashboard
================

Puppet Dashboard is a web front end that keeps you informed and in control of everything going on in your Puppet ecosystem. It currently functions as a [node configuration tool](#external_node_tool) and [a reporting dashboard](#reporting) and will soon do much more.

* * *

Dependencies
------------

* ruby >= 1.8.1
* rake >= 0.8.4
* mysql

Installation
------------

1. **Obtain the source:** `git clone git://github.com/reductivelabs/puppet-dashboard.git`

2. **Configure the database:** `rake install`

3. **Start the server:** `script/server`

This will start a local Puppet Dashboard server on port 3000. As a Rails application, Puppet Dashboard can be deployed in any server configuration that Rails supports. Instructions for deployment via Phusion Passenger coming soon.

NOTE: Puppet Dashboard is configured to use a MySQL database by default. Consult the Rails Guides section on [Configuring A Database](http://guides.rubyonrails.org/getting_started.html#configuring-a-database) for information on how to set up a different database.

Reporting
---------

### Report Import

To import puppet run reports stored in /var/puppet/lib/reports:

    rake reports:import
{:shell}

To specify a different report directory:

    rake reports:import REPORT_DIR /path/to/your/reports
{:shell}

### Live report aggregation

To enable report aggregation in Puppet Dashboard, the file `lib/puppet/puppet_dashboard.rb` must be available in Puppet's lib path. The easiest way to do this is to add `RAILS_ROOT/lib/puppet` to `$libdir` in your `puppet.conf`, where `RAILS_ROOT` is the directory containing this README. Then ensure that your puppetmasterd runs with the option `--reports puppet_dashboard`.

The puppet_dashboard report assumes that your Dashboard server is available at `localhost` on port 3000 (as it would be if you started it via `script/server`). For now, you will need to modify the constants in `puppet_dashboard.rb` if this is not the case.

External Node Tool
------------------

Puppet Dashboard functions as an external node tool. All nodes make a puppet-compatible YAML specification available for export. See `bin/external_node` for an example script that connects to Puppet Dashboard as an external node tool.
