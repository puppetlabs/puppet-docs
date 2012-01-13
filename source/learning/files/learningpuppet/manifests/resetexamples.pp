# = Class: learningpuppet::resetexamples
#
# This class undoes some of the more interesting example work assigned in
# Learning Puppet. It's meant to set the stage for trying different ways to
# declare the classes and defined types you made.
#
# You can use this class independently, but it was made to be declared by the
# learningpuppet::makeagent class.
#
class learningpuppet::resetexamples ($deletemodules = true) {

  # Destroy any NTP and Apache modules:
  # These could have various names, depending on the user's preference.
  $examplemodules = [
    '/etc/puppetlabs/puppet/modules/ntp',
    '/etc/puppetlabs/puppet/modules/httpd',
    '/etc/puppetlabs/puppet/modules/apache',
    '/etc/puppetlabs/puppet/modules/apache2'
  ]

  if $deletemodules {
    file {$examplemodules:
      ensure  => absent,
      purge   => true,
      recurse => true,
      force   => true,
    }
  }

  # Set OS-specific variables:
  case $operatingsystem {
    centos, redhat: {
      $ntp_service     = 'ntpd'
      $apache_service  = 'httpd'
      $apache_package  = 'httpd'
      $apache_vhostdir = '/etc/httpd/conf.d'
    }
    debian, ubuntu: {
      $ntp_service     = 'ntp'
      $apache_service  = 'apache2'
      $apache_package  = 'apache2'
      $apache_vhostdir = '/etc/apache2/sites-enabled'
    }
  }

  # Undo any NTP work:
  service {'ntp':
    name => $ntp_service,
    ensure => stopped,
    enable => false,
  } ->
  package {'ntp':
    ensure => purged,
  } ->
  file {'/etc/ntp.conf':
    ensure => absent,
  }

  # Sidenote: to do short runs of imperative ordering in Puppet, you can just put
  # those familiar chaining -> arrows between the related resources.

  service {'apache':
    name => $apache_service,
    ensure => stopped,
    enable => false,
  } ->
  package {'apache':
    name => $apache_package,
    ensure => purged,
  } ->
  file {'apache_vhosts':
    path => $apache_vhostdir,
    ensure => absent,
    purge => true,
    recurse => true,
    force => true,
  }

}
