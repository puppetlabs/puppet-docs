---
layout: default
title: Module Smoke Testing
---

Module Smoke Testing
====================

Learn to write and run tests for each manifest in your Puppet module.

* * *

Doing some basic "Has it exploded?" testing on your Puppet modules is extremely easy, has obvious benefits during development, and can serve as a condensed form of documentation.

Testing in Brief
----------------

The baseline for module testing used by Puppet is that each manifest should have a corresponding test manifest that declares that class or defined type.

Tests are then run by using `puppet apply --noop` (to check for compilation errors and view a log of events) or by fully applying the test in a virtual environment (to compare the resulting system state to the desired state).

Writing Tests
-------------

A well-formed Puppet module implements each of its classes or defined types in separate files in its `manifests` directory. Thus, ensuring each class or type has a test will result in the `tests` directory being a complete mirror image of the `manifests` directory.

A test for a class is just a manifest that declares the class. Often, this is going to be as simple as `include apache::ssl`. For parameterized classes, the test must declare the class with all of its required attributes set:

~~~ ruby
    class {'ntp':
      servers => ['0.pool.ntp.org', '1.pool.ntp.org'],
    }
~~~

Tests for defined resource types may increase test coverage by declaring multiple instances of the type, with varying values for their attributes:

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

If a class (or type) depends on any other classes, the test will have to declare those as well:

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

Running Tests
-------------

Run tests by applying the test manifests with puppet apply.

For basic smoke testing, you can apply the manifest with `--noop`. This will ensure that a catalog can be properly compiled from your code, and it'll show a log of the RAL events that would have been performed; depending on how simple the class is, these are often enough to ensure that it's doing what you expect.

For more advanced coverage, you can apply the manifest to a live system, preferably a VM. You can expand your coverage further by maintaining a stable of snapshot environments in various states, to ensure that your classes do what's expected in all the situations where they're likely to be applied.

Automating all this is going to depend on your preferred tools and processes, and is thus left as an exercise for the reader.

Reading Tests
-------------

Since module tests declare their classes with all required attributes and with all prerequisites declared, they can serve as a form of drive-by documentation: if you're in a hurry, you can often figure out how to use a module (or just refresh your memory) by skimming through the tests directory.

This doesn't get anyone off the hook for writing real documentation, but it's a good reason to write tests even if your module is already working as expected.

Exploring Further
-----------------

This form of testing is extremely basic, and still requires a human reader to determine whether the right RAL events are being generated or the right system configuration is being enforced. For more advanced testing, you may want to investigate [cucumber-puppet][cukepup] or [cucumber-nagios][cukenag].

[cukepup]: https://github.com/nistude/cucumber-puppet
[cukenag]: http://auxesis.github.com/cucumber-nagios/
