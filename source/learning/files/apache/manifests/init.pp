# TODO write doc for class.
class apache {

  # Set OS-specific variables:
  case $operatingsystem {
    centos, redhat: {
      $apache_service  = 'httpd'
      $apache_package  = 'httpd'
      $apache_vhostdir = '/etc/httpd/conf.d'
    }
    debian, ubuntu: {
      $apache_service  = 'apache2'
      $apache_package  = 'apache2'
      $apache_vhostdir = '/etc/apache2/sites-enabled'
    }
  }

  # TODO: manage the documentroot and put a custom 404 and index.html page in place, like the example says to.

  # TODO: manage the config file.

  service {'apache':
    name => $apache_service,
    ensure => running,
    enable => true,
    require => Package['apache'],
  }
  package {'apache':
    name => $apache_package,
    ensure => latest,
  }
  file {'apache_vhosts':
    path => $apache_vhostdir,
    ensure => directory,
    require => Package['apache'],
  }

}
