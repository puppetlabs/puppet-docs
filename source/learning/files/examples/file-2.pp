# /root/examples/file-2.pp
# http://docs.puppetlabs.com/learning/manifests.html#once-more-with-feeling

file {'/tmp/test1':
  ensure  => file,
  content => "Hi.",
}

file {'/tmp/test2':
  ensure => directory,
  mode   => 0644,
}

file {'/tmp/test3':
  ensure => link,
  target => '/tmp/test1',
}

user {'katie':
  ensure => absent,
}

notify {"I'm notifying you.":}
notify {"So am I!":}
