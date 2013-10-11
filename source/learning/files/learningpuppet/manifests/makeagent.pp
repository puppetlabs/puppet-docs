# = Class: learningpuppet::makeagent
#
# This class will configure a Puppet Enterprise system to STOP offering puppet
# master services. It was designed to let readers of the Learning Puppet
# series[1] create agent nodes by duplicating their original virtual machine,
# instead of having to download or build another VM from scratch.
#
# After the class is applied, the node will not be running puppet master
# services, and the puppet agent daemon will be stopped, so you can view the
# master/agent interactions in closer detail and on your own schedule. The new
# node should be configured to contact the correct puppet master, although you
# may need to edit its /etc/hosts file in order for name resolution to work.
#
# == Parameters:
#
# $newname:: An optional hostname for the new agent node. Defaults to "agent1"
# if omitted.
#
# == Requires:
#
# This class expects to be applied on a CentOS system with Puppet Enterprise
# 2.0.x installed, such as the Learning Puppet VM.[3] It hasn't been tested with
# other operating systems running PE, and may or may not work with them.
#
# == Sample use:
#
# $ sudo puppet apply -e "class {'learningpuppet::makeagent': newname => 'agent3'}"
#
# [1]: http://docs.puppetlabs.com/learning
# [2]: http://info.puppetlabs.com/learning-puppet-vm
#
class learningpuppet::makeagent ($newname = 'agent1', $deletemodules = true) {
  # Disable all master-only services:

  $puppetmaster_services = ["pe-memcached", "pe-httpd", "pe-activemq", "pe-puppet-dashboard-workers"]

  service { $puppetmaster_services:
    ensure    => stopped,
    enable    => false,
    hasstatus => true,
  }

  # Disable puppet agent. (You'll be controlling the first several runs
  # personally, to get a better view of what it does.)

  service {'pe-puppet':
    ensure    => stopped,
    enable    => false,
    hasstatus => true,
  }

  # When random resource ordering interacts w/ random run times for the
  # puppet agent service, there's a slim chance that puppet agent would bring
  # activemq back to life before we have a chance to change the facts. Use a
  # resource chain to prevent that.

  Service['pe-puppet'] -> Service['pe-activemq']

  # Get rid of the puppet master cron jobs. They're just scripts in the cron
  # directories, so we don't have to use the cron resource type.

  $puppetmaster_cronfiles = ["/etc/cron.d/default-add-all-nodes", "/etc/cron.hourly/puppet_baselines.sh"]

  file {$puppetmaster_cronfiles:
    ensure => absent,
  }

  # Set our new hostname...
  # TODO: make this OS-agnostic. (Right now it might be EL-specific.)

  $network_content = "NETWORKING=yes
NETWORKING_IPV6=yes
HOSTNAME=${newname}.localdomain
"

  file {'network':
    ensure  => file,
    path    => '/etc/sysconfig/network',
    content => $network_content,
    require => Host['myself'],
  }
  service {'network':
    ensure    => running,
    enable    => true,
    subscribe => File['network'],
    hasstatus => true,
  }
  if $hostname != "${newname}" {
    exec {'set hostname':
      command => "/bin/hostname ${newname}",
      require => File['network'],
      before  => Service['network'],
    }
  }

  # ... and make sure we can resolve said name:

  host {'myself':
    name         => "${newname}.localdomain",
    ensure       => present,
    ip           => "${ipaddress_eth0}",
    host_aliases => "${newname}",
    comment      => "This host helps Puppet think we have site-wide DNS set up correctly.",
  }

  # Make sure puppet.conf has the new certname and doesn't have puppet master
  # settings:

  file {'puppet.conf':
    path    => '/etc/puppetlabs/puppet/puppet.conf',
    ensure  => file,
    content => template('learningpuppet/puppet.conf.erb'),
    require => Service['pe-puppet'],
  }

  # Destroy everything in Puppet's SSL directory, so we can act like a brand-new
  # just-installed agent:

  file {'ssldir':
    path => '/etc/puppetlabs/puppet/ssl',
    ensure  => directory,
    purge   => true,
    recurse => true,
    force   => true,
  }

  # Undo any NTP or Apache work left over from the standalone exercises, so you
  # can redo it in agent mode. No really, this will be cooler than it sounds.

  class {'learningpuppet::resetexamples': deletemodules => $deletemodules}

}

