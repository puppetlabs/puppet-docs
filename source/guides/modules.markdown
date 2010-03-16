Puppet Modules
--------------

Modules are an excellent way for you to organize your Puppet content.
Learn to use them early!

* * *

Puppet Modules
--------------

When you have multiple files related to a single application, it
often makes sense to turn them into a module. This allows you to
distribute all of the files in one chunk, and Puppet will
automatically look through its module path for the files when you
go to use them.  Puppet Best Practices encourage almost always
writing modules, as it will make your Puppet infrastructure
easier to manage.

Modules can contain three types of files, each of which must be
stored in a separate subdirectory:

-   Manifests - must be stored in manifests/, and if you create
    manifests/init.pp then that file will be loaded if you import the
    module name directly, e.g. import "mymodule". All other manifests
    must have the module name included in the import statement, e.g.,
    import "mymod/mymanifest".
-   Templates - must be stored in templates/, and the module name
    must be added to the template name:
    template("mymodule/mytemplate.erb")
-   Files - stored in files/, these are available from the file
    server under modules/\<module name>/\<file name>.

These three file types cover all of the content you would provide
to puppetmasterd. For a more detailed description of how modules
should be organised, see [[Module Organisation]] .

(For info on how you can put types and facts into your modules, see
the wiki page [[Plugins In Modules]] )

Module Documentation
--------------------

From Puppet version 0.24.7 you can generate automated documentation
from resources, classes and modules using the puppetdoc tool. You
can find more detail at the
[Puppet Manifest Documentation](http://www.reductivelabs.com/trac/puppet/wiki/PuppetManifestDocumentation)
page.

Some Available Modules
----------------------

A number of stand-alone modules are available:

-   [Trac module](http://github.com/lak/puppet-trac/tree/master) 
    - A module for managing Trac
-   [Mercurial module](http://github.com/lak/puppet-mercurial/tree/master)
    - A module for managing Mercurial
-   [Mongrel module](http://github.com/lak/puppet-mongrel/tree/master)
    - A module for managing the Mongrel web server
-   [nginx module](http://github.com/lak/puppet-nginx/tree/master)
    - A module for managing the nginx web server
-   [Subversion module](http://github.com/lak/puppet-subversion/tree/master)
    - A module for managing Subversion
-   [SQLite3 module](http://github.com/lak/puppet-sqlite3/tree/master)
    - A module for managing the SQLite3 DBMS
-   [RubyGems module](http://github.com/lak/puppet-rubygems/tree/master)
    - A module for managing RubyGems
-   [Ruby module](http://github.com/lak/puppet-ruby/tree/master)
    - A module for managing Ruby
-   [Rails module](http://github.com/lak/puppet-rails/tree/master)
    - A module for managing the Rails framework
-   [Puppet module](http://github.com/lak/puppet-puppet/tree/master)
    - A recursive module for managing Puppet
-   [PostgreSQL module](http://github.com/lak/puppet-postgres/tree/master)
    - A module for managing the PostgreSQL DBMS
-   [git module](git://oppermannen.com/modules/git.git/) 
    - Ubuntu/Debian specific at the moment (only available with the git:// protocol atm)
-   [xen module](git://oppermannen.com/modules/xen.git/)
    - easily create xen domU's (only tested on Ubuntu feisty for now; only available with the git:// protocol atm)
-   [pbuilder](http://caspian.raphink.net/puppet/pbuilder_module_0.02.tgz)
    - create, update and purge Debian pbuilders
-   [sysctl type](http://spook.wpi.edu/sysctl) 
    - A native type for managing /etc/sysctl.conf - A Module which integrates this type and give a nice define, to set the sysctl, as well immediately [sysctl module](http://github.com/duritong/puppet-sysctl)
-   [puppet-module-denyhosts](http://github.com/pjs/puppet-module-denyhosts)
    - A module for managing Denyhosts
    ([http://denyhosts.sf.net](http://denyhosts.sf.net))
-   [ssh::auth](http://www.reductivelabs.com/trac/puppet/wiki/Recipes/ModuleSSHAuth)
    - centrally create, distribute, and revoke ssh keys for users.

Reductive Labs is working on a solution to allow everyone's modules to be hosted in one place.  More on this later!

Module Collections
------------------

There are also several collections of modules available:

-   [[Complete Configuration]] - David Schmitt's complete
    configuration modules
-   [Example42](http://www.example42.com/) - Lab42's configuration module
    collection
-   [eshao's complete configuration](http://github.com/eshao/puppet)
    -- another complete set of modules/configuration/documentation for
    Puppet on FreeBSD (documents any changes from production set).
    Heavily focuses on demonstrating best practices and techniques to
    reduce code size. Author won't bite: willing to entertain emails to
    explain/document any confusing aspects.
-   [Puppet Managed](http://puppetmanaged.org/) - Puppetmanaged.org
    module collection
-   [Puppet Common Modules](http://projects.reductivelabs.com/projects/show/pcm) and see also [[Module Standards]]
-   [Reductive Labs](http://modules.reductivelabs.com/) - ReductiveLabs repository
-   [Koumbit modules](http://git.koumbit.net/) - Koumbit.org managed modules
-   [Immerda modules](http://git.puppet.immerda.ch/) - Immerda.ch managed modules
-   [p@rdalys](http://github.com/wrobel/pardalys/tree/master/pardalys) - A set of puppet modules and extensions for the [Kolab](http://www.kolab.org) groupware server
-   [Camptocamp](http://github.com/camptocamp) - Camptocamp repository
-   [Tryphon](http://github.com/albanpeignier/tryphon-puppet/tree/master) - Tryphon build scripts for Puppet includes rake tasks, cucumber tests and generate tasks
-   [Puzzle](http://puppet.git.puzzle.ch) - Puzzle repository
-   [Riseup](https://labs.riseup.net/code/projects/show/puppetmodules) - Riseup Labs modules




