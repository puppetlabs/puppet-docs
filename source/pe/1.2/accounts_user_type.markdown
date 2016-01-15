---
layout: default
title: "PE 1.2 Manual: The accounts::user Type"
canonical: "/pe/latest/accounts_user_type.html"
---

{% include pe_1.2_nav.markdown %}

The `accounts::user` Type
=====

This defined type manages a single user account. Many of its parameters echo those of the standard [`user` type](/puppet/2.6/reference/type.html#user). Unlike the `user` type, it will also create and manage the user's home directory, create and manage a primary group with the same name as the user, manage a set of SSH public keys for the user, and optionally lock the user's account. 

The `accounts::user` type can be used on all of the platforms supported by Puppet Enterprise.

## Usage Example

~~~ ruby
    # /etc/puppetlabs/puppet/modules/site/manifests/users.pp
    class site::users {
      # Declaring a dependency: we require several shared groups from the site::groups class (see below).
      Class[site::groups] -> Class[site::users]
      
      # Setting resource defaults for user accounts: 
      Accounts::User {
        shell => '/bin/zsh',
      }
      
      # Declaring our accounts::user resources:
      accounts::user {'puppet':
        locked  => true,
        comment => 'Puppet Service Account',
        home    => '/var/lib/puppet',
        uid     => '52',
        gid     => '52',
      }
      accounts:: user {'sysop':
        locked  => false,
        comment => 'System Operator',
        uid     => '700',
        gid     => '700',
        groups  => ['admin', 'sudonopw'],
        sshkeys => ['ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAwLBhQefRiXHSbVNZYKu2o8VWJjZJ/B4LqICXuxhiiNSCmL8j+5zE/VLPIMeDqNQt8LjKJVOQGZtNutW4OhsLKxdgjzlYnfTsQHp8+JMAOFE3BD1spVnGdmJ33JdMsQ/fjrVMacaHyHK0jW4pHDeUU3kRgaGHtX4TnC0A175BNTH9yJliDvddRzdKR4WtokNzqJU3VPtHaGmJfXEYSfun/wFfc46+hP6u0WcSS7jZ2WElBZ7gNO4u2Z+eJjFWS9rjQ/gNE8HHlvmN0IUuvdpKdBlJjzSiKZR+r/Bo9ujQmGY4cmvlvgmcdajM/X1TqP6p3OuouAk5QSPUlDRV91oEHw== sysop+moduledevkey@puppetlabs.com'],
      }
      accounts::user {'villain':
        locked  => true,
        comment => 'Test Locked Account',
        uid     => '701',
        gid     => '701',
        groups  => ['admin', 'sudonopw'],
        sshkeys => ['ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAwLBhQefRiXHSbVNZYKu2o8VWJjZJ/B4LqICXuxhiiNSCmL8j+5zE/VLPIMeDqNQt8LjKJVOQGZtNutW4OhsLKxdgjzlYnfTsQHp8+JMAOFE3BD1spVnGdmJ33JdMsQ/fjrVMacaHyHK0jW4pHDeUU3kRgaGHtX4TnC0A175BNTH9yJliDvddRzdKR4WtokNzqJU3VPtHaGmJfXEYSfun/wFfc46+hP6u0WcSS7jZ2WElBZ7gNO4u2Z+eJjFWS9rjQ/gNE8HHlvmN0IUuvdpKdBlJjzSiKZR+r/Bo9ujQmGY4cmvlvgmcdajM/X1TqP6p3OuouAk5QSPUlDRV91oEHw== villain+moduledevkey@puppetlabs.com'],
      }
      accounts::user {'jeff':
        comment => 'Jeff McCune',
        groups => ['admin', 'sudonopw'],
        uid => '1112',
        gid => '1112',
        sshkeys => [
                      'ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAwLBhQefRiXHSbVNZYKu2o8VWJjZJ/B4LqICXuxhiiNSCmL8j+5zE/VLPIMeDqNQt8LjKJVOQGZtNutW4OhsLKxdgjzlYnfTsQHp8+JMAOFE3BD1spVnGdmJ33JdMsQ/fjrVMacaHyHK0jW4pHDeUU3kRgaGHtX4TnC0A175BNTH9yJliDvddRzdKR4WtokNzqJU3VPtHaGmJfXEYSfun/wFfc46+hP6u0WcSS7jZ2WElBZ7gNO4u2Z+eJjFWS9rjQ/gNE8HHlvmN0IUuvdpKdBlJjzSiKZR+r/Bo9ujQmGY4cmvlvgmcdajM/X1TqP6p3OuouAk5QSPUlDRV91oEHw== jeff+moduledevkey@puppetlabs.com',
                      'ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAwLBhQefRiXHSbVNZYKu2o8VWJjZJ/B4LqICXuxhiiNSCmL8j+5zE/VLPIMeDqNQt8LjKJVOQGZtNutW4OhsLKxdgjzlYnfTsQHp8+JMAOFE3BD1spVnGdmJ33JdMsQ/fjrVMacaHyHK0jW4pHDeUU3kRgaGHtX4TnC0A175BNTH9yJliDvddRzdKR4WtokNzqJU3VPtHaGmJfXEYSfun/wFfc46+hP6u0WcSS7jZ2WElBZ7gNO4u2Z+eJjFWS9rjQ/gNE8HHlvmN0IUuvdpKdBlJjzSiKZR+r/Bo9ujQmGY4cmvlvgmcdajM/X1TqP6p3OuouAk5QSPUlDRV91oEHw== jeff+moduledevkey2@puppetlabs.com',
                      'ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAwLBhQefRiXHSbVNZYKu2o8VWJjZJ/B4LqICXuxhiiNSCmL8j+5zE/VLPIMeDqNQt8LjKJVOQGZtNutW4OhsLKxdgjzlYnfTsQHp8+JMAOFE3BD1spVnGdmJ33JdMsQ/fjrVMacaHyHK0jW4pHDeUU3kRgaGHtX4TnC0A175BNTH9yJliDvddRzdKR4WtokNzqJU3VPtHaGmJfXEYSfun/wFfc46+hP6u0WcSS7jZ2WElBZ7gNO4u2Z+eJjFWS9rjQ/gNE8HHlvmN0IUuvdpKdBlJjzSiKZR+r/Bo9ujQmGY4cmvlvgmcdajM/X1TqP6p3OuouAk5QSPUlDRV91oEHw== jeff+moduledevkey3@puppetlabs.com',
                      'ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAwLBhQefRiXHSbVNZYKu2o8VWJjZJ/B4LqICXuxhiiNSCmL8j+5zE/VLPIMeDqNQt8LjKJVOQGZtNutW4OhsLKxdgjzlYnfTsQHp8+JMAOFE3BD1spVnGdmJ33JdMsQ/fjrVMacaHyHK0jW4pHDeUU3kRgaGHtX4TnC0A175BNTH9yJliDvddRzdKR4WtokNzqJU3VPtHaGmJfXEYSfun/wFfc46+hP6u0WcSS7jZ2WElBZ7gNO4u2Z+eJjFWS9rjQ/gNE8HHlvmN0IUuvdpKdBlJjzSiKZR+r/Bo9ujQmGY4cmvlvgmcdajM/X1TqP6p3OuouAk5QSPUlDRV91oEHw== jeff+moduledevkey4@puppetlabs.com'
                  ],
      }
      accounts::user {'dan':
        comment => 'Dan Bode',
        uid => '1109',
        gid => '1109',
        sshkeys => ['ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAwLBhQefRiXHSbVNZYKu2o8VWJjZJ/B4LqICXuxhiiNSCmL8j+5zE/VLPIMeDqNQt8LjKJVOQGZtNutW4OhsLKxdgjzlYnfTsQHp8+JMAOFE3BD1spVnGdmJ33JdMsQ/fjrVMacaHyHK0jW4pHDeUU3kRgaGHtX4TnC0A175BNTH9yJliDvddRzdKR4WtokNzqJU3VPtHaGmJfXEYSfun/wFfc46+hP6u0WcSS7jZ2WElBZ7gNO4u2Z+eJjFWS9rjQ/gNE8HHlvmN0IUuvdpKdBlJjzSiKZR+r/Bo9ujQmGY4cmvlvgmcdajM/X1TqP6p3OuouAk5QSPUlDRV91oEHw== dan+moduledevkey@puppetlabs.com'],
      }
      accounts::user {'nigel':
        comment => 'Nigel Kersten',
        uid => '2001',
        gid => '2001',
        sshkeys => ['ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAwLBhQefRiXHSbVNZYKu2o8VWJjZJ/B4LqICXuxhiiNSCmL8j+5zE/VLPIMeDqNQt8LjKJVOQGZtNutW4OhsLKxdgjzlYnfTsQHp8+JMAOFE3BD1spVnGdmJ33JdMsQ/fjrVMacaHyHK0jW4pHDeUU3kRgaGHtX4TnC0A175BNTH9yJliDvddRzdKR4WtokNzqJU3VPtHaGmJfXEYSfun/wFfc46+hP6u0WcSS7jZ2WElBZ7gNO4u2Z+eJjFWS9rjQ/gNE8HHlvmN0IUuvdpKdBlJjzSiKZR+r/Bo9ujQmGY4cmvlvgmcdajM/X1TqP6p3OuouAk5QSPUlDRV91oEHw== nigel+moduledevkey@puppetlabs.com'],
      }
    }
    
    # /etc/puppetlabs/puppet/modules/site/manifests/groups.pp
    class site::groups {
      Group { ensure => present, }
      group {'developer':
        gid => '3003',
      }
      group {'sudonopw':
        gid => '3002',
      }
      group {'sudo':
        gid => '3001',
      }
      group {'admin':
        gid => '3000',
      }
    }
~~~


## Parameters

### `name`

The user's name.  While limitations differ by operating system, it is generally a good idea to restrict user names to 8 characters, beginning with a letter. Defaults to the resource's title.

### `ensure`

Whether the user and its primary group should exist.  Valid values are `present` and `absent`. Defaults to `present`.

### `shell`

The user's login shell.  The shell must exist and be executable. Defaults to `/bin/bash`.

### `comment`

A description of the user.  Generally a user's full name. Defaults to the user's `name`.

### `home`

The home directory of the user. Defaults to `/home/<user's name>`

### `uid`

The user's uid number.  Must be specified numerically; defaults to being automatically determined (`undef`).

### `gid`

The gid of the primary group with the same name as the user; the `accounts::user` type will create and manage this group. Must be specified numerically; defaults to being automatically determined (`undef`). 

### `groups`

An array of groups the user belongs to.  The primary group should not be listed. Defaults to an empty array.

### `membership`

Whether specified groups should be considered the **complete list** (`inclusive`) or the **minimum list** (`minimum`) of groups to which the user belongs.  Valid values are `inclusive` and `minimum`; defaults to `minimum`.

### `password`

The user's password, in whatever encrypted format the local machine requires. Be sure to enclose any value that includes a dollar sign ($) in single quotes ('). Defaults to `'!!'`, which prevents the user from logging in with a password.

### `locked`

Whether the user should be prevented from logging in; set this to `true` for system users and users whose login privileges have been revoked. Valid values are `true` and `false`; defaults to false. 

### `sshkeys`

An array of SSH public keys associated with the user. Unlike with the [`ssh_authorized_key`](/puppet/2.6/reference/type.html#sshauthorizedkey) type, these should be **complete public key strings** that include the type and name of the key, exactly as the key would appear in its `id_rsa.pub` or `id_dsa.pub` file. Defaults to an empty array.

