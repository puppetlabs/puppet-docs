package {'httpd':
  ensure => installed,
}
-> # ordering arrow
file {'/etc/httpd/conf/httpd.conf':
  ensure => file,
  source => '/root/examples/answers/httpd.conf',
}
~> # ordering-with-notification arrow
service {'httpd':
  ensure => running,
}

notify {"Apache configured!
You can test whether it's working by going to http://${::ipaddress}:80 in your web browser.":}
