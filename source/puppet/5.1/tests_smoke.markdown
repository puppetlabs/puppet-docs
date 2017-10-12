---
layout: default
title: Module smoke testing
---

You can smoke test your module manifests to check for compilation errors and to verify the changes your module will make to your system. This is not a substitute for full acceptance testing, but it can be useful for a quick check of your module.


For this kind of testing, you must be working with a system that has Puppet installed and is equivalent to your production environment. Before you begin, ensure that your module is valid and well-formed, and that it passes unit tests.

For each class or defined type in your module, you'll write a corresponding example manifest that declares that class or defined type. These manifests are normally contained in the `examples\` directory of the module.

Then you'll apply those example manifests in either a no-operation mode, to check for compilation errors and view a log of events, or in a virtual testing environment, to compare the resulting system state to the desired state.

This form of testing gives less assurance than full acceptance testing, but you can still examine the results and logs to determine whether the right events are being generated or the right system configuration is being enforced.

{:.concept}
## Writing example manifests

A well-formed Puppet module implements each of its classes or defined types in separate files in its `manifests\` directory. Thus, ensuring each class or type has an example manifest results in the `examples\` directory being a mirror image of the `manifests\` directory.

Class manifests in the `examples\` directory are typically basic manifests that declare the class, such as `include apache::ssl`. For parameterized classes, the example manifest must declare the class with all of its required parameters set.

For example:

~~~ ruby
    class {'ntp':
      servers => ['0.pool.ntp.org', '1.pool.ntp.org'],
    }
~~~

For defined resource types, you can increase test coverage by declaring multiple instances of the type, with varying values for their attributes:

~~~ ruby
    dotfiles::user {'root':
      overwrite => false,
    }
    dotfiles::user {'nick':
      overwrite => append,
    }
    dotfiles::user {'guest':
      overwrite => true,
    }
~~~

If a class or defined type depends on any other classes or resources, your example manifest must declare those as well:

~~~ ruby
    # git/manifests/gitosis.pp
    class git::gitosis {
      package {'gitosis':
        ensure => present,
      }
      Class['::git'] -> Class['git::gitosis']
    }

    # git/tests/gitosis.pp
    class{'git':}
    class{'git::gitosis':}
~~~

{:.concept}
## Running smoke tests

Smoke test your classes and defined types by applying the example manifests, either in no-operation mode or on a testing machine.

For basic smoke testing, apply the manifest with the `--noop` flag. This flag makes no actual changes to your system, but ensures that a catalog can be properly compiled. It also displays a log of events that would have been performed in a real operation.

Because Puppet is not making real changes to the system, a `--noop` run does have some limitations. For example, if your code contains one resource that creates a directory and another that depends on that directory, the run will fail, because that directory dependency does not exist. In a real operation, however, the directory would have been created, so the code would not fail for this reason.

For more advanced coverage, you can apply the manifest to a live system, preferably a virtual machine (VM) that matches the environment in which you expect to deploy code. You can expand your coverage further by maintaining stable snapshots of environments in various states, to ensure that your classes do what's expected in all the situations where they're likely to be applied.
