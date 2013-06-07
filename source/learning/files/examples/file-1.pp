# /root/examples/file-1.pp
# http://docs.puppetlabs.com/learning/manifests.html#resource-declarations

file {'testfile':
  path    => '/tmp/testfile',
  ensure  => present,
  mode    => 0640,
  content => "I'm a test file.",
}
