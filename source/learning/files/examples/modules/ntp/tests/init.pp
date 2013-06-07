# Enable NTP with custom servers:
class {'ntp':
  servers => [ "0.pool.ntp.org dynamic",
               "1.pool.ntp.org dynamic", ],
}
# Make sure NTP is disabled (for VMs, e.g.):
# class {'ntp':
#   enable => false,
#   ensure => stopped,
# }
