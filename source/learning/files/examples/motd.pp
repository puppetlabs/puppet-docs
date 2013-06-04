# motd.pp

file {'motd':
  ensure  => file,
  path    => '/etc/motd',
  mode    => 0644,
  content => "This Learning Puppet VM's IP address is ${ipaddress_eth0}. It thinks its
hostname is ${fqdn}, but you might not be able to reach it there
from your host machine. It is running ${operatingsystem} ${operatingsystemrelease}.
Web console login:
  URL: https://${ipaddress_eth0}
  User: puppet@example.com
  Password: learningpuppet
",
}
