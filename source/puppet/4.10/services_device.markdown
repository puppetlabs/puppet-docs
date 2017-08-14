---
layout: default
title: "Puppet's services: Puppet device"
---


[man]: ./man/device.html
[device.conf]: ./config_file_device.html
[deviceconfig]: /configuration.html#deviceconfig
[PUP-1391]: https://tickets.puppetlabs.com/browse/PUP-1391
[report]: ./reporting_about.html

## Overview

Puppet device is an application that manages certificates, collects facts, retrieves and applies catalogs, and stores reports for a device. Devices that cannot run Puppet applications require a (proxy) Puppet agent to act as a proxy to run the Puppet device subcommand.

For details about the Puppet device command, see [the puppet device man page][man].

## Supported platforms

Puppet device runs similarly on both \*nix and Windows systems.

## Run environment

Unlike Puppet agent, Puppet device never runs as a daemon or service. It always runs as a single task in the foreground that manages devices, and exits.

### User

Puppet device runs as whichever user executed the Puppet device command.

You should run Puppet device as:

* `root` on \*nix systems
* Either `LocalService` or a member of the `Administrators` group on Windows systems

Due to a bug [PUP-1391][], the `--user=root` option is required, even when Puppet device is run as root, for runs that create certificates or keys.

### Logging

By default, Puppet device logs directly to the terminal. This is valuable for interactive use, but less valuable when running as a cron job or scheduled task.

When run with the `--logdest syslog` option, Puppet device logs to the \*nix syslog service. Your syslog configuration dictates where these messages will be saved, but the default location is `/var/log/messages` on Linux, `/var/log/system.log` on Mac OS X, and `/var/adm/messages` on Solaris.

When run with the `--logdest eventlog` option, it logs to the Windows Event Log. You can view its logs by browsing the Event Viewer. (Control Panel → System and Security → Administrative Tools → Event Viewer)

When run with the `--logdest <FILE>` option, it logs to the file specified by `<FILE>`.

You can adjust how verbose the logs are with the `--debug` and `--verbose` options.

### Network access

By default, Puppet device communicates over the network with the devices it manages. It never accepts inbound network connections.

In addition to local logging, Puppet device submits a [report][] to the Puppet master after each run.

## Configuration of Puppet device

Configure Puppet device with [device.conf][].

You can specify multiple devices in [device.conf][], which is configurable with the [deviceconfig][] setting.

For example:

~~~
[device.example.com]
type f5
url https://admin:password@device.example.com/
~~~

## Classification of agents and devices

### Agent

A common practice is to classify the proxy Puppet agent for a device with the base class of the device provider.

For example:

~~~
node 'device-proxy.example.com' {
	class {'f5': }
}
~~~

Apply the classification by running `puppet agent -t` on the proxy Puppet agent.

(Note that this can vary by device provider.)

### Device

Define resources on the device.

For example:

~~~
node 'device.example.com' {
	f5_virtualserver { '/Common/puppet_vs':
		ensure                     => 'present',
		provider                   => 'standard',
		description                => 'Hello World',
		destination_address        => '192.168.1.245',
		destination_mask           => '255.255.255.255',
		http_profile               => '/Common/http',
		service_port               => '443',
		protocol                   => 'tcp',
		source                     => '0.0.0.0/0',
		source_address_translation => 'automap',
	}
}
~~~

## Managing devices with Puppet device

To run Puppet device on demand and manage all of the devices specified in [device.conf][]

    $ puppet device -v --user=root

Since Puppet device doesn't run as a service, you must manually create a cron job or scheduled task if you want it to run on a regular basis.

On \*nix, you can use the Puppet resource command to set up a cron job. Below is an example that runs Puppet device once an hour; adjust the path to the Puppet command if you are not using Puppet Enterprise.

    $ sudo puppet resource cron puppet-device ensure=present user=root minute=30 command='/opt/puppetlabs/bin/puppet device --user=root --logdest syslog'

## Limitations with other Puppet applications

Puppet apply and Puppet resource cannot modify device resources. However, Puppet resource can inspect a device's resources when provided a url fact containing the device url as specified in [device.conf][].

For example:

~~~
export FACTER_url=https://admin:password@device.example.com/
puppet resource f5_virtualserver
~~~

Returns:

~~~
f5_virtualserver { '/Common/puppet_vs':
  ensure                                 => 'present',
  address_status                         => 'yes',
  address_translation                    => 'enabled',
  authentication_profiles                => ['none'],
  auto_last_hop                          => 'default',
  connection_limit                       => '0',
  connection_mirroring                   => 'disabled',
  connection_rate_limit                  => 'disabled',
  connection_rate_limit_destination_mask => '0',
  connection_rate_limit_mode             => 'per_virtual_server',
  connection_rate_limit_source_mask      => '0',
  default_persistence_profile            => 'none',
  default_pool                           => 'none',
  description                            => 'Hello World',
  destination_address                    => '192.168.1.245',
  destination_mask                       => '255.255.255.255',
  diameter_profile                       => 'none',
  dns_profile                            => 'none',
  fallback_persistence_profile           => 'none',
  fix_profile                            => 'none',
  ftp_profile                            => 'none',
  html_profile                           => 'none',
  http_compression_profile               => 'none',
  http_profile                           => '/Common/http',
  ipother_profile                        => 'none',
  irules                                 => ['none'],
  last_hop_pool                          => 'none',
  nat64                                  => 'disabled',
  ntlm_conn_pool                         => 'none',
  oneconnect_profile                     => 'none',
  port_translation                       => 'enabled',
  protocol                               => 'tcp',
  protocol_profile_client                => '/Common/tcp',
  protocol_profile_server                => '/Common/tcp',
  rate_class                             => 'none',
  request_adapt_profile                  => 'none',
  request_logging_profile                => 'none',
  response_adapt_profile                 => 'none',
  rewrite_profile                        => 'none',
  rtsp_profile                           => 'none',
  service_port                           => '443',
  sip_profile                            => 'none',
  socks_profile                          => 'none',
  source                                 => '0.0.0.0/0',
  source_address_translation             => 'automap',
  source_port                            => 'preserve',
  spdy_profile                           => 'none',
  ssl_profile_client                     => ['none'],
  ssl_profile_server                     => ['none'],
  state                                  => 'enabled',
  statistics_profile                     => 'none',
  stream_profile                         => 'none',
  vlan_and_tunnel_traffic                => 'all',
  vs_score                               => '0',
  web_acceleration_profile               => 'none',
  xml_profile                            => 'none',
}
~~~