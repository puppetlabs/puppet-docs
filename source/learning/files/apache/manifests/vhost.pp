# Definition: apache::vhost
#
# This class installs Apache Virtual Hosts
#
# Parameters:
# - The $port to configure the host on
# - The $docroot provides the DocumentationRoot variable
# - The $template option specifies whether to use the default template or override
# - The $priority of the site
# - The $serveraliases of the site
# - The $options for the given vhost
# - The $vhost_name for name based virtualhosting, defaulting to *
#
# Actions:
# - Install Apache Virtual Hosts
#
# Requires:
# - The apache class
#
# Sample Usage:
#  apache::vhost { 'site.name.fqdn':
#    priority => '20',
#    port => '80',
#    docroot => '/path/to/docroot',
#  }
#
define apache::vhost(
    $port,
    $docroot,
    $template      = 'apache/vhost-default.conf.erb',
    $priority      = '25',
    $servername    = '',
    $serveraliases = '',
    $options       = "Indexes FollowSymLinks MultiViews",
    $vhost_name    = '*'
  ) {

  include apache

  # Below is a pre-2.6.5 idiom for having a parameter default to the title,
  # but you could also just declare $servername = "$title" in the parameters
  # list and change srvname to servername in the template.

  if $servername == '' {
    $srvname = $title
  } else {
    $srvname = $servername
  }
  case $operatingsystem {
    'centos', 'redhat', 'fedora': { $vdir   = '/etc/httpd/conf.d'
                                    $logdir = '/var/log/httpd'}
    'ubuntu', 'debian':           { $vdir   = '/etc/apache2/sites-enabled'
                                    $logdir = '/var/log/apache2'}
    default:                      { $vdir   = '/etc/apache2/sites-enabled'
                                    $logdir = '/var/log/apache2'}
  }
  file {
    "${vdir}/${priority}-${name}.conf":
      content => template($template),
      owner   => 'root',
      group   => 'root',
      mode    => '755',
      require => Package['httpd'],
      notify  => Service['httpd'],
  }

}