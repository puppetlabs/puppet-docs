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

Community Resources
-------------------

A listing of available modules and user supplied modules are
maintained on the Puppet Wiki [here](http://projects.reductivelabs.com/projects/puppet/wiki/Puppet_Modules).



