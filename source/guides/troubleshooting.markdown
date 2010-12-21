---
layout: default
title: Troubleshooting
---

Troubleshooting
===============

Answers to some common problems that may come up.

Basic workflow items are covered in the main section of the documentation.  If you're looking for how to do something unconventional, you may also wish to read [Techniques](./techniques.html).

* * *

## Why hasn't my new node configuration been noticed?

If you're using separate node definition files and import them into
site.pp with an import \*.node (for example) you'll find that new
files added won't get noticed until you restart puppetmasterd. This
is due to the fact globs aren't evaluated on each run, but only
when the 'parent' file is re-read.

To make sure your new file is actually read, simply 'touch' the
site.pp (or importing file) and the glob will be re-evaluated.

## Why don't my certificates show as waiting to be signed on my server when I do a "`puppetca --list`"?

`puppetca` must be run with root privileges. If you are not root, then re-run the
command with sudo:

    sudo puppetca --list

## I keep getting "certificates were not trusted". What's wrong?

Firstly, if you're re-installing a machine, you probably haven't
cleared the previous certificate for that machine. To correct the
problem:

1.  Run `sudo puppetca --clean {certname}` on the Puppetmaster to
    clear the certificates.
2.  Remove the entire SSL directory of the client machine:

        rm -r etc/puppet/ssl rm -r /var/lib/puppet/ssl

Assuming that you're not re-installing, by far the most common
cause of SSL problems is that the clock on the client machine is
set incorrectly, which confuses SSL because the "validFrom" date in
the certificate is in the future.

You can figure the problem out by manually verifying the
certificate with openssl:

    sudo openssl verify -CAfile /etc/puppet/ssl/certs/ca.pem /etc/puppet/ssl/certs/myhostname.domain.com.pem

This can also happen if you've followed the [Using Mongrel](./mongrel.html)
pattern to alleviate file download problems. If your set-up is such
that the host name differs from the name in the Puppet server
certificate, or there is any other SSL certificate negotiation
problem, the SSL handshake between client and server will fail. In
this case, either alleviate the SSL handshake problems (debug using
cURL), or revert to the original Webrick installation.

## I'm getting IPv6 errors; what's wrong?

This can apparently happen if Ruby is not compiled with IPv6
support; see the mail thread for more details. The only known
solution is to make sure you're running a version of Ruby compiled
with IPv6 support.

## I'm getting tlsv1 alert unknown ca errors; what's wrong?

This problem is caused by puppetmasterd not being able to read its
ca certificate. This problem might occur up to 0.18.4 but has been
fixed in 0.19.0. You can probably fix it for versions before 0.19.0
by changing the group ownership of the /etc/puppet/ssl directory to
the puppet group, but puppetd may change the group back. Having
puppetmasterd start as the root user should fix the problem
permanently until you can upgrade.

## Why does Puppet keep trying to start a running service?

The ideal way to check for a service is to use the hasstatus
parameter, which calls the init script with the status parameter.
This should report back to Puppet whether the service is running or
stopped.

In some broken scripts, however, the status output will be correct
("Ok" or "not running"), but the exit code of the script will be
incorrect. Most commonly, the script will always blindly return 0,
no matter what the actual service state is. Puppet only uses the
exit code, so interprets this as "the service is stopped".

There are two workarounds, and one fix. If you must deal with the
scripts broken behavior as is, you can modify your resource to
either use the pattern parameter to look for a particular process
name, or the status parameter to use a custom script to check for
the service status.

The fix is to rewrite the init script to use the proper exit codes.
When rewriting them, or submitting bug reports to vendors or
upstream, be sure to reference the
[LSB Init Script Actions](http://refspecs.linux-foundation.org/LSB_3.1.0/LSB-Core-generic/LSB-Core-generic/iniscrptact.html)
standard. This should carry more weight by pointing out an
official, published standard they're failing to meet, rather than
trying to explain how their bug is causing problems in Puppet.

## I'm using the Nagios types but the Puppet run on the server running Nagios is starting to take ages

**Note:** This has heavily been improved with 0.25 and it's not
anymore a problem. The proposed workaround should be considered
only on systems running puppet \< 0.25

If you are exporting Nagios objects, they will need to be collected
on your Nagios server to be added to the nagios service
configuration file.

Let's say you are exporting some hundreds of nagios\_service
objects, the corresponding nagios\_service.cfg file will be quite
large. On every puppet run however, for each and every
nagios\_service defined, puppet will have to seek through that file
to see if anything has changed. This is incredibly time consuming.

You'll have better results using the "target" option for the
nagios\_service tyepe, e.g.

    nagios_service { "check_ssh_$fqdn":
         ensure => present,
         check_command => "check_ssh",
         use => "generic-service",
         host_name => $fqdn,
         service_description => "SSH",
         target => "/etc/nagios/nagios_service.d/check_ssh_$fqdn"
    }

This will dramatically improve your puppet run performance, as
puppet only has to look in the directory for the file it needs and
seek through a file with only one service definition in it.

## Why is my external node configuration failing ? I get no errors by running the script by hand.

Most of the time, if you get the following error when running you
client

    warning: Not using cache on failed catalog
    err: Could not retrieve catalog; skipping run

it is because of some invalid YAML output from your external node
script. Check [http://www.yaml.org](http://www.yaml.org) if you
have doubts about validity.

# Puppet Syntax Errors

Puppet generates syntax errors when manifests are incorrectly
written. Sometimes these errors can be a little cryptic. Below is a
list of common errors and their explanations that should help you
trouble-shoot your manifests.

## Syntax error at '}'; expected '}' at manifest.pp:nnn

This error can occur when:

    service { "fred" }

This contrived example demonstrates one way to get the very
confusing error of Puppet's parser expecting what it found. In this
example, the colon ( : ) is missing after the service title. A
variant looks like:

    service { "fred"
        ensure => running
    }

and the error would be Syntax error at 'ensure'; expected '}' .

You can also get the same error if you forget a comma. For
instance, in this example the comma is missing at the end of line
3:
 service {
      "myservice":
        provider => "runit"
        path => "/path/to/daemons"
    }

## Syntax error at ':'; expected ']' at manifest.pp:nnn

This error can occur when:

    classname::define_name {
        "jdbc/automation":
            cpoolid     => "automationPool",
            require     => [ Classname::other_define_name["automationPool"] ],
    }

The problem here is that Puppet requires that object references in
the require lines to begin with a capital letter. However, since
this is a reference to a class and a define, the define also needs
to have a capital letter, so Classname::Other\_define\_name would
be the correct syntax.

## Syntax error at '.'; expected '}' at manifest.pp:nnn

This error happens when you use unquoted comparators with dots in
them, a'la:

    class autofs {

      case $kernelversion {
        2.6.9:   { $autofs_packages = ["autofs", "autofs5"] }
        default: { $autofs_packages = ["autofs"] }
      }
    }

That 2.6.9 needs to have doublequotes around it, like so:

    class autofs {

       case $kernelversion {
         "2.6.9":   { $autofs_packages = ["autofs", "autofs5"] }
         default: { $autofs_packages = ["autofs"] }
       }
     }

## Could not match '\_define\_name' at manifest.pp:nnn on node nodename

This error can occur using a manifest like:

    case $ensure {
        "present": {
            _define_name {
                "$title":
                    user        => $user,
            }
        }
    }

This one is simple - you cannot begin a function name (define name)
with an underscore.

## Duplicate definition: Classname::Define\_name[system] is already defined in file manifest.pp at line nnn; cannot redefine at manifest.pp:nnn on node nodename

This error can occur when using a manifest like:

    Classname::define_name {
         "system":
             properties  => "Name=system";
         .....
         "system":
              properties  => "Name=system";
     }

The most confusing part of this error is that the line numbers are
usually the same - this is the case when using the block format
that Puppet supports for a resource definition. In this contrived
example, the system entry has been defined twice, so one of them
needs removing.

## Syntax error at '=>'; expected ')'

This error can occur when you use a manifest like:

    define foo($param => 'value') { ... }

Default values for parameters are assigned, not defined, therefore
a '=', not a '=>' operator is needed.

## err: Exported resource Blah[$some\_title] cannot override local resource on node $nodename

While this is not a classic "syntax" error, it is a annoying error
none-the-less. The actual error tells you that you have a local
resource Blah[$some\_title] that puppet refuses to overwrite with a
collected resource of the same name. What most often happens, that
the same resource is exported by two nodes. One of them is
collected first and when trying to collect the second resource,
this error happens as the first is already converted to a "local"
resource.

# Common Misconceptions

## Node Inheritance and Variable Scope

It is generally assumed that the following will result in the
/tmp/puppet-test.variable file containing the string 'my\_node':

    class test_class {
        file { "/tmp/puppet-test.variable":
           content => "$testname",
           ensure => present,
        }
    }

    node base_node {
        include test_class
    }

    node my_node inherits base_node {
        $testname = 'my_node'
    }

Contrary to expectations, /tmp/puppet-test.variable is created with
no contents. This is because the inherited test\_class remains in
the scope of base\_node, where $testname is undefined.

Node inheritance is currently only really useful for inheriting
static or self-contained classes, and is as a result of quite
limited value.

A workaround is to define classes for your node types - essentially
include classes rather than inheriting them. For example:

    class test_class {
        file { "/tmp/puppet-test.variable":
           content => "$testname",
           ensure => present,
        }
    }

    class base_node_class {
        include test_class
    }

    node my_node {
        $testname = 'my_node'
        include base_node_class
    }

/tmp/puppet-test.variable will now contain 'my\_node' as desired.

## Class Inheritance and Variable Scope

The following would also not work as generally expected:

    class base_class {
        $myvar = 'bob'
        file {"/tmp/testvar":
             content => "$myvar",
             ensure => present,
        }
    }

    class child_class inherits base_class {
        $myvar = 'fred'
    }

The /tmp/testvar file would be created with the content 'bob', as
this is the value of $myvar where the type is defined.

A workaround would be to 'include' the base\_class, rather than
inheriting it, and also to strip the $myvar out of the included
class itself (otherwise it will cause a variable scope conflict -
$myvar would be set twice in the same child\_class scope):

    $myvar = 'bob'

    class base_class {
        file {"/tmp/testvar":
             content => "$myvar",
             ensure => present,
        }
    }

    class child_class {
        $myvar = 'fred'
        include base_class
    }

In some cases you can reset the content of the file resource so
that the scope used for the content (e.g., template) is rebound.
Example:

    class base_class {
        $myvar = 'bob'
        file { "/tmp/testvar":
             content => template("john.erb"),
        }
    }

    class child_class inherits base_class {
        $myvar = 'fred'
        File["/tmp/testvar"] { content => template("john.erb") }
    }

(john.erb contains a reference like \<%= myvar %>.)

To avoid the duplication of the template filename, it is better to
sidestep the problem altogether with a define:

    class base_class {
        define testvar_file($myvar="bob") {
             file { $name:
                 content => template("john.erb"),
             }
        }
        testvar_file { "/tmp/testvar": }
    }

    class child_class inherits base_class {
        Base_class::Testvar_file["/tmp/testvar"] { myvar => fred }
    }

Whilst not directly solving the problem also useful are qualified
variables that allow you to refer to and assign variables from
other classes. Qualified variables might provoke alternate methods
of solving this issue. You can use qualified methods like:

    class foo {
        $foovariable = "foobar"
    }

    class bar {
        $barvariable = $foo::foovariable
    }

In this example the value of the of the $barvariable variable in
the bar class will be set to foobar the value of the $foovariable
variable which was set in the foo class.

# Custom Type & Provider development

## err: Could not retrieve catalog: Invalid parameter 'foo' for type 'bar'

When you are developing new custom types, you should restart both
the puppetmasterd and the puppetd before running the configuration
using the new custom type. The pluginsync feature will then
synchronise the files and the new code will be loaded when both
daemons are restarted.

