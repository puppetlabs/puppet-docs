if $operatingsystem =~ /(?i:debian|ubuntu)/ {
  package {'build-essential':
    ensure => installed,
  }
}
package {'gcc':
  ensure => installed,
}
