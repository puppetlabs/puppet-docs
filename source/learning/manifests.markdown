---
layout: default
title: Learning Puppet — Manifests
---


[2state]: ./images/manifest_to_defined_state_unified.png
[cheat]: /puppet_core_types_cheatsheet.pdf


Begin
-----

Did you do the `puppet resource` exercises from the [last chapter](./ral.html)? Let's remove the user account you created.

In a text editor --- `vim`, `emacs`, or `nano` --- create a file with the following contents and filename:

~~~ ruby
    # /root/examples/user-absent.pp
    user {'katie':
      ensure => absent,
    }
~~~

Save and close the editor, then run:

    # puppet apply /root/examples/user-absent.pp
    notice: /Stage[main]//User[katie]/ensure: removed
    notice: Finished catalog run in 0.07 seconds

Now run it again:

    # puppet apply /root/examples/user-absent.pp
    notice: Finished catalog run in 0.03 seconds

Cool: You've just written and applied your first Puppet manifest.


Manifests
---------

Puppet programs are called "manifests," and they use the `.pp` file extension.

The core of the Puppet language is the _resource declaration._  A resource declaration describes a _desired state_ for one resource.

(Manifests can also use various kinds of logic: conditional statements, collections of resources, functions to generate text, etc. We'll get to these later.)

Puppet Apply
-----

Like `resource` in the last chapter, `apply` is a Puppet subcommand. It takes the name of a manifest file as its argument, and enforces the desired state described in the manifest.

We'll use it below to test small manifests, but it can be used for larger jobs too. In fact, it can do nearly everything an agent/master Puppet environment can do.

Resource Declarations
---------------------

[declaration]: /puppet/latest/reference/lang_resources.html
[strings]: /puppet/latest/reference/lang_datatypes.html#strings
[datatypes]: /puppet/latest/reference/lang_datatypes.html

Let's start by looking at a single resource:

~~~ ruby
    # /root/examples/file-1.pp

    file {'testfile':
      path    => '/tmp/testfile',
      ensure  => present,
      mode    => 0640,
      content => "I'm a test file.",
    }
~~~

[The complete syntax and behavior of resource declarations are documented in the Puppet reference manual][declaration], but in short, they consist of:

* The **type** (`file`, in this case)
* An opening curly brace (`{`)
    * The **title** (`testfile`)
    * A colon (`:`)
    * A set of **attribute `=>` value** pairs, with a comma after each pair (`path => '/tmp/testfile',` etc.)
* A closing curly brace (`}`)

Try applying the short manifest above:

    # puppet apply /root/examples/file-1.pp
    notice: /Stage[main]//File[testfile]/ensure: created
    notice: Finished catalog run in 0.05 seconds

This is just the reverse of what we saw above when we removed the user account: Puppet noticed that the file didn't exist, and created it. It set the desired content and mode at the same time.

    # cat /tmp/testfile
    I'm a test file.
    # ls -lah /tmp/testfile
    -rw-r----- 1 root root 16 Feb 23 13:15 /tmp/testfile

If we try changing the mode and applying the manifest again, Puppet will fix it:

    # chmod 0666 /tmp/testfile
    # puppet apply /root/examples/file-1.pp
    notice: /Stage[main]//File[testfile]/mode: mode changed '0666' to '0640'
    notice: Finished catalog run in 0.04 seconds

And if you run the manifest again, you'll see that Puppet doesn't do anything --- if a resource is in the desired state already, Puppet will leave it alone.

> **Exercise:** Declare another file resource in a manifest and apply it. Try setting a new desired state for an existing file --- for example, changing the login message by setting the content of `/etc/motd`. You can [see the attributes available for the file type here.](/references/latest/type.html#file)

### Syntax Hints

Watch out for these common errors:

* Don't forget commas and colons! Forgetting them causes errors like `Could not parse for environment production: Syntax error at 'mode'; expected '}' at /root/manifests/1.file.pp:6 on node learn.localdomain`.
* Capitalization matters! The resource type and the attribute names should always be lowercase.
* The values used for titles and attribute values will usually be [strings][], which you should usually quote. [Read more about Puppet's data types here.][datatypes]
    * There are two kinds of quotes in Puppet: single (`'`) and double (`"`). The main difference is that double quotes let you interpolate $variables, which we cover in another lesson.
    * Attribute names (like `path`, `ensure`, etc.) are special keywords, not strings. They shouldn't be quoted.

Also, note that Puppet lets you use whatever whitespace makes your manifests more readable. We suggest visually lining up the `=>` arrows, because it makes it easier to understand a manifest at a glance. (The Vim plugins on the Learning Puppet VM will do this automatically as you type.)

Once More, With Feeling!
------------------------

Now that you know resource declarations, let's play with the file type some more. We'll:

* Put multiple resources of different types in the same manifest
* Use new values for the `ensure` attribute
* Find an attribute with a special relationship to the resource title
* See what happens when we leave off certain attributes
* See some automatic permission adjustments on directories

~~~ ruby
    # /root/examples/file-2.pp

    file {'/tmp/test1':
      ensure  => file,
      content => "Hi.\n",
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
~~~

Apply:

    # puppet apply /root/examples/file-2.pp
    notice: /Stage[main]//File[/tmp/test1]/ensure: created
    notice: /Stage[main]//File[/tmp/test3]/ensure: created
    notice: /Stage[main]//File[/tmp/test2]/ensure: created
    notice: So am I!
    notice: /Stage[main]//Notify[So am I!]/message: defined 'message' as 'So am I!'
    notice: I'm notifying you.
    notice: /Stage[main]//Notify[I'm notifying you.]/message: defined 'message' as 'I'm notifying you.'
    notice: Finished catalog run in 0.05 seconds

Cool. What just happened?

### New Ensure Values, Different States

The `ensure` attribute is somewhat special. It's available on most (but not all) resource types, and it controls whether the resource exists, with the definition of "exists" being somewhat local.

With files, there are several ways to exist:

* As a normal file (`ensure => file`)
* As a directory (`ensure => directory`)
* As a symlink (`ensure => link`)
* As any of the above (`ensure => present`)
* As nothing (`ensure => absent`).

A quick check shows how our manifest played out:

    # ls -lah /tmp/test*
    -rw-r--r--  1 root root    3 Feb 23 15:54 test1
    lrwxrwxrwx  1 root root   10 Feb 23 15:54 test3 -> /tmp/test1

    /tmp/test2:
    total 16K
    drwxr-xr-x 2 root root 4.0K Feb 23 16:02 .
    drwxrwxrwt 5 root root 4.0K Feb 23 16:02 ..

    # cat /tmp/test3
    Hi.


### Titles and Namevars

Notice how our original file resource had a `path` attribute, but our next three left it out?

Almost every resource type has one attribute whose value defaults to the resource's title. For the `file` resource, that's `path`. Most of the time (`user`, `group`, `package`...), it's `name`.

These attributes are called **"namevars."**  They are generally the attribute that corresponds to the resource's _identity,_ the one thing that should always be unique.

If you leave out the namevar for a resource, Puppet will re-use the title as its value. If you _do_ specify a value for the namevar, the title of the resource can be anything.

> #### Identity and Identity
>
> So why even have a namevar, if Puppet can just re-use the title?
>
> There are two kinds of identity that Puppet recognizes:
>
> * Identity within Puppet itself
> * Identity on the target system
>
> Most of the time these are the same, but sometimes they aren't. For example, the NTP service has a different name on different platforms: on Red Hat-like systems, it's called `ntpd`, and on Debian-like systems, it's `ntp`. These are logically the same resource, but their identity on the target system isn't the same.
>
> Also, there are cases (usually exec resources) where the system identity has no particular meaning, and putting a more descriptive identity in the title can help tell your colleagues (or yourself in two months) what a resource is supposed to be doing.
>
> By allowing you to split the title and namevar, Puppet makes it easy to handle these cases. We'll cover this later when we get to conditional statements.
>
> #### Uniqueness
>
> Note that you can't declare the same resource twice: Puppet always disallows duplicate _titles_ within a given type, and usually disallows duplicate _namevar values_ within a type.
>
> This is because resource declarations represent desired final states, and it's not at all clear what should happen if you declare two conflicting states. So Puppet will fail with an error instead of accidentally doing something wrong to the system.

### Missing Attributes: "Desired State = Whatever"

On the `/tmp/test1` file, we left off the `mode` and `owner` attributes, among others. When we omit attributes, Puppet doesn't manage them, and any value is assumed to be the desired state.

If a file doesn't exist, Puppet will default to creating it with permissions mode 0644, but if you change that mode, Puppet won't change it back.

Note that you can even leave off the `ensure` attribute, as long as you don't specify `content` or `source` --- this can let you manage the permissions of a file if it exists, but not create it if it doesn't.

### Directory Permissions: 644 = 755

We said `/tmp/test2/` should have permissions mode 0644, but our `ls -lah` showed mode 0755. That's because Puppet groups the read and traverse permissions for directories.

> **Details:** With directories, the 4 bit controls whether someone can _list_ the directory and the 1 bit controls whether they can _access any files_ it contains.
>
> Most of the time, you want these abilities to be grouped together. However, when recursively managing directories with the `recurse` attribute, you wouldn't want to set all permissions to 0755, because any plain files contained by the directory would become executable! And if Puppet didn't automatically adjust directory permissions, recursively setting permissions of 0644 would make the files in a directory inaccessible to users who should be able to access them.
>
> By automatically grouping those permissions, it becomes much easier to set a directory's permissions to match the permissions of the files it contains.

Destinations, Not Journeys
---------------

You've noticed that we talk about "desired states" a lot, instead of talking about making changes to the system. This is the core of thinking like a Puppet user.

If you were writing an explanation to another human of how to put a system into a desired state, using the OS's default tools, it would read something like "Check whether the mode of the sudoers file is 0440, using `ls -l`. If it's already fine, move on to the next step; otherwise, run `chmod 0440 /etc/sudoers`."

Under the hood, Puppet is actually doing the same thing, with some of the same OS tools. But it wraps the "check" step together with the "and fix if needed" step, and presents them as a single interface.

The effect is that, instead of writing a bash script that looks like a step-by-step for a beginning user, you can write Puppet manifests that look like shorthand notes for an expert user.


> Aside: Compilation
> -----
>
> Manifests don't get used directly when Puppet syncs resources. Instead, the flow of a Puppet run goes a little like this:
>
> ![Diagram: Manifests are compiled into a catalog, which is then applied to yield the desired system state.][2state]
>
> As we mentioned above, manifests can contain conditional statements, variables, functions, and other forms of logic. But before being applied, manifests get _compiled_ into a document called a **"catalog,"** which _only_ contains resources and hints about the order to sync them in.
>
> With puppet apply, the distinction doesn't mean much. In a master/agent Puppet environment, though, it matters more, because agents only see the catalog:
>
> * By using logic, manifests can be flexible and describe many systems at once. A catalog describes desired states for **one** system.
> * By default, agent nodes can only retrieve their own catalog; they can't see information meant for any other node. This separation improves security.
> * Since catalogs are so unambiguous, it's possible to _simulate_ a catalog run without making any changes to the system. (This is usually done by running `puppet agent --test --noop`.) You can even use special diff tools to compare two catalogs and see the differences.

The Site Manifest and Puppet Agent
-----

We've seen how to use puppet apply to directly apply manifests on one system. The puppet master/agent services work very similarly, but with a few key differences:

**Puppet apply:**

* A user executes a command, triggering a Puppet run.
* Puppet apply reads the manifest passed to it, compiles it into a catalog, and applies the catalog.

**Puppet agent/master:**

* Puppet agent runs as a service, and triggers a Puppet run about every half hour (configurable).
    * On your VM, which runs Puppet Enterprise, the agent service is named `pe-puppet`. (Puppet agent can also be configured to run from cron, instead of as a service.)
* Puppet agent does not have access to any manifests; instead, it requests a pre-compiled catalog from a puppet master server.
    * On your VM, the puppet master appears as the `pe-httpd` service. A sandboxed copy of Apache with Passenger manages the puppet master application, spawning and killing new copies of it as needed.
* The puppet master always reads **one** special manifest, called the "site manifest" or site.pp. It uses this to compile a catalog, which it sends back to the agent.
    * On your VM, the site manifest is at `/etc/puppetlabs/puppet/manifests/site.pp`.
* After getting the catalog, the agent applies it.

This way, you can have many machines being configured by Puppet, while only maintaining your manifests on one (or a few) servers. This also gives some extra security, as described above under "Compilation."

> ### Exercise: Use Puppet Agent/Master to Apply the Same Configuration
>
> To see how the same manifest code works in puppet agent:
>
> * Edit `/etc/puppetlabs/puppet/manifests/site.pp` and paste in the three file resources from the manifest above.
>     * Watch out for some of the existing code in site.pp, and don't disturb any `node` statements yet. You can paste the resources at the bottom of the file and they'll work fine.
> * Delete or mutilate the files and directories we created in `/tmp`.
> * Run `puppet agent --test`, which will trigger a single puppet agent run in the foreground so you can see what it's doing in real time.
> * Check `/tmp`, and notice that the files are back to their desired state.

> ### Exercise: SSH Authorized Key
>
> Write and apply a manifest that uses the [`ssh_authorized_key` type](/references/stable/type.html#sshauthorizedkey) to let you log into the learning VM as root without a password.
>
> **Bonus work:** Try putting it directly into the site manifest, instead of using puppet apply. [Use the console to trigger a puppet agent run](/pe/latest/orchestration_puppet.html), and [check the reports in the console](/pe/latest/console_reports.html) to see whether the manifest worked.
>
> * You'll need to have an SSH key pair, a terminal application on your host system, and some basic understanding of how SSH works. You can get all of these with a little outside research.
> * Watch out: you can't just paste the line from `id_rsa.pub` into the `key` attribute of the resource. You'll need to separate its components out into multiple attributes. Read the documentation for the `ssh_authorized_key` type to see how.


Next
----

**Next Lesson:**

You know how to use the fundamental building blocks of Puppet code, so now it's time to learn [how those blocks fit together](./ordering.html).

**Off-Road:**

You already know how to do a bit with Puppet, and managing file ownership and permissions is important.

Are there any files on your systems that you've had a hard time keeping in sync? You already know enough to lock them down. [Download Puppet Enterprise for free][dl], follow [the quick start guide][quick] to get a small environment installed, then try putting some file resources at the bottom of the puppet master's `site.pp` file to manage those files on every machine.


[dl]: http://info.puppetlabs.com/download-pe.html
[quick]: /pe/latest/quick_start.html
