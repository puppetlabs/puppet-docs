# /root/examples/user-absent.pp
# http://docs.puppetlabs.com/learning/manifests.html#begin
user {'katie':
  ensure => absent,
}
