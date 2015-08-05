---
layout: default
title: Troubleshooting
---

Troubleshooting
===============

Answers to some common problems that may come up.

Basic workflow items are covered in the main section of the documentation.  If you're looking for how to do something unconventional, you may also wish to read [Techniques](./techniques.html).

* * *

## General

### My catalog won't compile and/or my code is behaving unpredictably. What's wrong?
Puppet 3 uses Ruby version 1.9, which is much stricter about character encodings than the version of Ruby used previously. As a result, puppet code that contains UTF-8 characters, such as accents or other non-ASCII characters, can fail or act unpredictably. There are a number of ways UTF-8 characters can make it into puppet code, such as downloading a Forge module where some piece of metadata (e.g., author's name) contains UTF-8 characters. With apologies to our international customers, the current solution is to strictly limit puppet code to the ASCII character set only, including any code comments or metadata. Puppet Labs is working on cleaning up character encoding issues in Puppet and the various libraries it interfaces with.

### Why hasn't my new node configuration been noticed?

If you're using separate node definition files and import them into
site.pp (with an `import *.node`, for example) you'll find that new
files added won't get noticed until you restart puppetmasterd. This
is due to the fact globs aren't evaluated on each run, but only
when the 'parent' file is re-read.

To make sure your new file is actually read, simply 'touch' the
site.pp (or importing file) and the glob will be re-evaluated.

### Why don't my certificates show as waiting to be signed on my server when I do a "`puppet cert --list`"?

puppet cert must be run with root privileges. If you are not root, then re-run the
command with sudo:

    sudo puppet cert --list

### I keep getting "certificates were not trusted". What's wrong?

Firstly, if you're re-installing a machine, you probably haven't
cleared the previous certificate for that machine. To correct the
problem:

1.  Run `sudo puppet cert --clean {node certname}` on the puppet master to
    clear the certificates.
2.  Remove the entire SSL directory of the client machine (`sudo rm -r /etc/puppet/ssl; rm -r /var/lib/puppet/ssl`).

Assuming that you're not re-installing, by far the most common
cause of SSL problems is that the clock on the client machine is
set incorrectly, which confuses SSL because the "validFrom" date in
the certificate is in the future.

You can figure the problem out by manually verifying the
certificate with openssl:

    sudo openssl verify -CAfile /etc/puppet/ssl/certs/ca.pem /etc/puppet/ssl/certs/myhostname.domain.com.pem

If your set-up is such
that the host name differs from the name in the Puppet server
certificate, or there is any other SSL certificate negotiation
problem, the SSL handshake between client and server will fail. In
this case, either alleviate the SSL handshake problems (debug using
cURL), or revert to the original Webrick installation.

### Agents are failing with a "hostname was not match with the server certificate" error; what's wrong?

Agent nodes determine the validity of the master's certificate based on hostname; if they're contacting it using a hostname that wasn't included when the certificate was signed, they'll reject the certificate.

To fix this error, either:

- Modify your agent nodes' settings to point to one of the master's certified hostnames. (This may also require adjusting your site's DNS.) To see the puppet master's certified hostnames, run:

        $ sudo puppet master --configprint certname

    ...on the puppet master server.
- Re-generate the puppet master's certificate:
    - Stop puppet master.
    - Delete the puppet master's certificate, private key, and public key:

            $ sudo find $(puppet master --configprint ssldir) -name "$(puppet master --configprint certname).pem" -delete
    - Edit the `certname` setting in the puppet master's `/etc/puppet/puppet.conf` file to match the puppet master's actual hostname, and the `dns_alt_names` setting in that file to match any other DNS names you expect the master to need to respond to.
    - Start a non-daemonized WEBrick puppet master instance, and wait for it to generate and sign a new certificate:

            $ sudo puppet master --no-daemonize --verbose

        You should stop the temporary puppet master with ctrl-C after you see the "notice: Starting Puppet master version 2.6.9" message.
    - Restart the puppet master.


### I'm getting IPv6 errors; what's wrong?

This can happen if Ruby is not compiled with IPv6
support. The only known
solution is to make sure you're running a version of Ruby compiled
with IPv6 support.

### I'm getting tlsv1 alert unknown ca errors; what's wrong?

This problem is caused by puppetmasterd not being able to read its
ca certificate. This problem might occur up to 0.18.4 but has been
fixed in 0.19.0. You can probably fix it for versions before 0.19.0
by changing the group ownership of the /etc/puppet/ssl directory to
the puppet group, but puppetd may change the group back. Having
puppetmasterd start as the root user should fix the problem
permanently until you can upgrade.

### Why does Puppet keep trying to start a running service?

The ideal way to check for a service is to use the hasstatus
attribute, which calls the init script with its `status` command.
This should report back to Puppet whether the service is running or
stopped.

In some broken scripts, however, the status output will be correct
("Ok" or "not running"), but the exit code of the script will be
incorrect. (Most commonly, the script will always blindly return 0.)
Puppet only uses the exit code, and so may behave unpredictably in
these cases.

There are two workarounds, and one fix. If you must deal with the
script's broken behavior as is, your resource can either use the "pattern"
attribute to look for a particular name in the process table, or use the
"status" attribute to specify a custom script that returns the proper exit
code for the service's status.

The longer-term fix is to rewrite the service's init script to use the proper
exit codes. When rewriting them, or submitting bug reports to vendors or
upstream, be sure to reference the
[LSB Init Script Actions](http://refspecs.linux-foundation.org/LSB_3.1.0/LSB-Core-generic/LSB-Core-generic/iniscrptact.html)
standard. This should carry more weight by pointing out an
official, published standard they're failing to meet, rather than
trying to explain how their bug is causing problems in Puppet.


### Why is my external node configuration failing? I get no errors by running the script by hand.

Most of the time, if you get the following error when running you
client

    warning: Not using cache on failed catalog
    err: Could not retrieve catalog; skipping run

it is because of some invalid YAML output from your external node
script. Check [yaml.org](http://www.yaml.org) if you
have doubts about validity.

## Puppet Syntax Errors

Puppet generates syntax errors when manifests are incorrectly
written. Sometimes these errors can be a little cryptic. Below is a
list of common errors and their explanations that should help you
trouble-shoot your manifests.

### Syntax error at '}'; expected '}' at manifest.pp:nnn

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
        path     => "/path/to/daemons"
    }

### Syntax error at ':'; expected ']' at manifest.pp:nnn

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

### Syntax error at '.'; expected '}' at manifest.pp:nnn

This error happens when you use unquoted comparators with dots in
them, as in:

    class autofs {

      case $kernelversion {
        2.6.9:   { $autofs_packages = ["autofs", "autofs5"] }
        default: { $autofs_packages = ["autofs"] }
      }
    }

That 2.6.9 needs to have double quotes around it, like so:

    class autofs {

       case $kernelversion {
         "2.6.9":   { $autofs_packages = ["autofs", "autofs5"] }
         default: { $autofs_packages = ["autofs"] }
       }
     }

### Could not match '\_define\_name' at manifest.pp:nnn on node nodename

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

### Duplicate definition: Classname::Define\_name[system] is already defined in file manifest.pp at line nnn; cannot redefine at manifest.pp:nnn on node nodename

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

### Syntax error at '=>'; expected ')'

This error results from incorrect syntax in a defined resource type:

    define foo($param => 'value') { ... }

Default values for parameters are assigned, not defined, therefore
a '=', not a '=>' operator is needed.

### Syntax error at '<<|'; expected '|>>'

You may get this error when using a manifest like:

    node a {
       @@foo_module::bar_exported_resource {
            .....
       }
    }

    node b {
       #where we collect things
       .....

       foo_module::bar_exported_resource <<| |>>
    }

[collector_syntax]: /puppet/latest/reference/lang_collectors.html#syntax

This confusing error is a result of improper (or rather lack of any) capitalization while collecting the exported resource --- [resource collectors use the capitalized form of the resource type.][collector_syntax] The manifest for the node b should actually be:

    node b {
        #where we collect things
        .....

        Foo_module::Bar_exported_resource <<| |>>
    }

### err: Exported resource Blah[$some\_title] cannot override local resource on node $nodename

While this is not a classic "syntax" error, it is a annoying error
nonetheless. The actual error tells you that you have a local
resource Blah[$some\_title] that puppet refuses to overwrite with a
collected resource of the same name. What most often happens, that
the same resource is exported by two nodes. One of them is
collected first and when trying to collect the second resource,
this error happens as the first is already converted to a "local"
resource.

## Common Misconceptions

### Node Inheritance and Variable Scope

It is generally assumed that the following will result in the
/tmp/puppet-test.variable file containing the string 'my\_node':

    class test_class {
        file { "/tmp/puppet-test.variable":
           content => "$testname",
           ensure  => present,
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
static or self-contained classes, and is, as a result, of quite
limited value.

A workaround is to define classes for your node types - essentially
include classes rather than inheriting them. For example:

    class test_class {
        file { "/tmp/puppet-test.variable":
           content => "$testname",
           ensure  => present,
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

### Class Inheritance and Variable Scope

The following would also not work as generally expected:

    class base_class {
        $myvar = 'bob'
        file {"/tmp/testvar":
             content => "$myvar",
             ensure  => present,
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
             ensure  => present,
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
variables that allow you to refer to variables from
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

## Custom Type & Provider development

### err: Could not retrieve catalog: Invalid parameter 'foo' for type 'bar'

When you are developing new custom types, you should restart both
the puppet master and the puppet agent before running the configuration
using the new custom type. The pluginsync feature will then
synchronise the files and the new code will be loaded when both
daemons are restarted.

