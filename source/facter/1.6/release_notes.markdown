---
layout: default
title: Facter 1.6 Release Notes
description: Facter release notes for all 1.6 versions
---

This page documents the history of the Facter 1.6 series.

Facter 1.6.18
-----

### (maint) Fix failing manufacturer spec on Solaris 10

Without this patch the specs are failing against solaris 10.  The root
cause of the problem is that the manufacturer spec is getting a value
from a different resolver than the one being tested.  The example
expected the result to be nil rather than being resolved by the
alternative resolver.

This patch fixes the issue by changing the expectation such that the
manufacturer spec is not the value set by the resolver being tested.

### (maint) Add Ruby 2.0.0 to Travis build matrix

Without this patch we're not testing against Ruby 2.0.0 which has
recently been released.  This is a problem because we'd like a way to be
notified if a change set breaks compatibility with future supported
versions of Ruby.

This patch should not be taken as an indication that we fully support
Ruby 2.0, just as an indication that we plan to in the future.

### (maint) Update gem source in Gemfile

Without this patch installed the following warning message is displayed
on a Debian 6 system when running `bundle install --path vendor/bundle`:

> The source :rubygems is deprecated because HTTP requests are insecure.
> Please change your source to 'https://rubygems.org' if possible

This patch addresses the problem by changing the gem source to
https://rubygems.org which avoids the warning.

### Call correct function on IP in NetMask

This fixes the error "Could not retrieve netmask: wrong number of arguments (1
for 0)"

### Add missing require for macaddress

This fixes the error "Could not retrieve macaddress: uninitialized constant
Facter::Util::IP"

### (#13396) Unify ifconfig usage and lookup ifconfig path to fix support for recent net-tools

Without this patch applied linux systems with recent net-tools loose
support for ipaddress,macaddress and other network related facts.
This is due to a path change from /sbin/ifconfig to /bin/ifconfig.

This patch fixes this issue by unifying the lookup and execution of
ifconfig and testing where the ifconfig binary is installed.

### (maint) Add Travis CI support to active branches

Without this patch all active branches do not have proper Travis
configuration files.  This is a problem because Travis will exercise any
branch pushed to the puppetlabs organization repository on Github.  The
default behavior is to email notifications which is undesirable.

To address this problem Travis configuration settings are added to an
active branch.

Active branches are those that have recent activity when compared
against the following command:

    for k in `git branch -r |perl -pe s/^..//`
    do
    echo -e `git show --pretty=format:"%Cgreen%ci %Cblue%cr%Creset" $k|head -n 1`\\t$k;
    done | sort -r | grep origin

Which should produce output like:

    2013-01-06 11:01:40 -0800 3 hours ago   origin/1.6.x
    2013-01-05 23:33:48 -0800 14 hours ago  origin/master
    2012-12-27 10:03:43 -0800 10 days ago   origin/2.x
    2012-12-27 10:02:58 -0800 10 days ago   origin/1.7.x

### (#15306) Read /proc/self/status in binary mode

On at least a Joyent SmartMachine (illumos based Solaris) the file
/proc/self/status contains binary data. When read with File.read in Ruby
1.9, this is parsed as UTF-8 which fails with an exception. This patch
instead opens the file in binary mode to avoid the failure.


Facter 1.6.17
-----

### (#17840) Use enum_cpuinfo for x86 arch

Windows and Gentoo consider 32 bit x86 architectures to be called 'x86',
but this value was not handled when checking for processorcount
information. This patch adds x86 alongside the other synonyms for this
architecture.

### (#17487) Add support for HPUX NIC bonding in IP facts

Without this patch applied facter prints messages like

    $ facter
    Could not retrieve netmask_lan3_: undefined method `+' for nil:NilClass
    Could not retrieve macaddress_lan3_: undefined method `+' for nil:NilClass
    Could not retrieve network_lan3_: undefined method `+' for nil:NilClass
    Could not retrieve ipaddress6_lan3_: undefined method `+' for nil:NilClass
    Could not retrieve ipaddress_lan3_: undefined method `+' for nil:NilClass
    Could not retrieve mtu_lan3_: undefined method `+' for nil:NilClass
    ...
    interfaces => lan4_1,lan3_,lan1,lo0,lan4

The patch is a rewrite of Hongbo Hu's patch submitted in #11612 with sed
code implemented in Ruby.  The patch replaces the existing HP-UX unit tests
with an exhaustive selection of netstat -in, ifconfig, and lanscan examples
on various HP platforms with and without NIC bonding.

The patch also includes tests for MTU facts commented out as MTU facts have
not been implemented yet.  These can be uncommented after (#17808) is fixed.

### (#15001) ifconfig regex will optionally match 'addr:'

Newer versions of ifconfig, as found in Fedora 17, have changed the
output format of ifconfig. This change removed the 'addr:' string which
prevents the regex from matching. This patch makes matching 'addr:'
optional.

### (#17925) Fix ec2_userdata: 404 Not Found Error

Without this patch applied Facter returns the following error message to
the user when no user-data is present in the instance metadata server
when Facter is running on an instance in Amazon AWS EC2.

    $ facter ec2_userdata
    Could not retrieve ec2_userdata: 404 Not Found

This patch addresses the problem by handling the exception produced from
the HTTP 404 Not Found error.  In this circumstance of no user-data
being present, the fact value is not set.

With this patch applied the behavior is as follows:

    $ userdata=$(facter ec2_userdata); echo "userdata: [${userdata}]"
    userdata: []

And the error is not silently dropped with debugging turned on:

    $ facter --debug ec2_userdata
    No user-data present at http://169.254.169.254/latest/user-data/: server responded with 404 Not Found
    value for ec2_userdata is still nil

### (#16626) Fix handling of bonded Linux interfaces

Array#to_s doesn't produce the right format for hwaddrre to match, so
use #join instead.

Facter 1.6.16
-----

### (#17855) Rescue Timeout::Error

Previously, if the Facter::EC2.can_connect? method timed-out, an
instance of Timeout::Error would be raised. Under ruby 1.8.7, this class
is not a StandardError, and so wasn't rescued. And since the
can_connect? method is called when the ec2 code is loaded (as opposed to
a setcode block), the exception was never caught causing facter to exit.

In ruby 1.9.3, Timeout::Error is a StandardError, so the default
`rescue` block catches it.

This issue was caused by commit b336259e when trying to fix #17493.

This commit restores the explicit rescue of Timeout::Error so that it
behaves consistently on all supported ruby versions.



Facter 1.6.15
-----

### (#17177) Add MTU information to interfaces

add regex strings for linux bsd, and sunos to pull mtu information
add tests to confirm that information is valid
add the mtu label to interfaces.rb

### (#17493) Safer handling of EC2 'open' calls

Previously, when facter (and therefore) facter was run on an openstack
node, the metadata method did not protect against the 'open' method from
raising exceptions. Since we don't know ahead of time what the name of
the metadata ec2 fact(s) are, we have to add a rescue block outside of
the setcode block. If an exception occurs, we warn, similar to how
facter's built-in resolution mechanism warns about exceptions.

Previously, the ec2_userdata fact performed the 'open' call outside of
the setcode block, and only rescued one type of exception. This commit
moves the 'open' call into the setcode block, which automatically
rescues and warns if needed.

As a result of this change, the ec2_userdata fact is not evaluated until
actually requested, which simplifies the tests for the ec2 metadata
fact(s).

### (#11612) Add support for processorX facts on HP-UX

Without this patch applied, the processorX facts are not available on
HP-UX platforms.  This is a problem because the lack of these facts make
it difficult to write Puppet manifests that work on HP-UX and other
platforms like Linux that support the processorX facts.

These methods involve using machinfo when it is available, using
sched.models and getconf when machinfo is not available.  A suite of
RSpec tests are included as well as fixture files for four selected
examples of machinfo outputs, a sample sched.models file and unistd.h.

### (#16511) Do not call arp -an on Solaris nodes

Without this patch applied the EC2 facts cause Facter to execute the
`arp -an` system command on Solaris systems.  This is an invalid command
on Solaris 8, but not 9 or 10.  This is a problem because the following
output is displayed to the user every run:

    arp: -an: unknown host

The other problem is that facts which depend on this behavior working
are themselves broken and do not resolve on Solaris.

This patch _papers over the problem_, but does not fix the core issues
present in the EC2 facts.  The core problem is that way too much EC2
specific work is being done in the main scope, causing this behavior and
code paths to be exercised on systems like Solaris 8 that will never run
in EC2.

The example `arp -a` command example is copied from
http://docstore.mik.ua/orelly/networking_2ndEd/tcp/ch13_04.htm

Facter 1.6.14
-----

### (#16397) Update selinux_mount_point for 1.8.5 compatibility

The lines method does not exist for the String class in ruby 1.8.5, which
causes the selinux_mount_point function to print Could not retrieve selinux:
undefined method lines' for #String:0x2abc1ffefe88to STDERR. This commit
monkey patches facter with `lines` so that it can safely use the `lines`
method on 1.8.5. It monkey_patches both String and IO.
It also includes spec tests for the String and IO classes to verify they
respond to lines in the expected manner.

### (#11609) Fix processorX facts for AIX systems

Without this patch Facter running on AIX systems will output misleading
information in the indexed processorX facts.  This misleading
information looks like:

    $ facter processor0
    processor0 => 0PowerPC_POWER5
    processor1 => 6PowerPC_POWER5
    processor2 => 2PowerPC_POWER5
    processor3 => 4PowerPC_POWER5

There are a number of problems here.  First, the mapping of values to
their index is not stable, resulting in non-deterministic behavior.
Second, the AIX specific identifiers are leaking into the fact values.

I learned my lesson when I implemented the Mac OS X System Profiler sp_*
facts.  The lesson learned is that we should not implement facts
specific to a single platform, but instead re-use the existing
platform-agnostic and consistent facts we have.

To this end, this patch solves the problem by mapping the platform
specific processor identifiers to our incrementing index identifiers.
The patch makes sure to sort the list so the results are idempotent.
The new output is:

    $ facter processor0
    processor0 => PowerPC_POWER5
    processor1 => PowerPC_POWER5
    processor2 => PowerPC_POWER5
    processor3 => PowerPC_POWER5

### (#8210) Add a heavy virtual fact using virt-what

Without this patch facter does not return kvm when running inside of an
enterprise linux guest VM hosted on an enterprise linux kvm host.
This is a problem because facter improperly reports the virtual machine
is actually running on physical hardware, which is not true.  This
causes downstream problems for anyone relying on the virtual fact being
accurate.

This patch fixes the problem by adding a new resolver for the virtual
fact that has a very high weight.  The new resolver calls `virt-what`,
available on Enterprise Linux machines by installing the `virt-what`
package.  The last line of output is used to determine the virtual
machine hypervisor type.

If virt-what is not available or returns no output, then existing lower
weight resolvers are used instead.

### (maint) Remove rspec from shebang lines

Without this patch Ruby 1.9 is still complaining loudly about trying to parse
the spec files.

I'd prefer to remove the shebang lines entirely, but doing so will cause
encoding errors in Ruby 1.9.  This patch strives for a happy middle ground of
convincing Ruby it is actually working with Ruby while not confusing it to
think it should exec() to rspec.

This patch is the result of the following command run against the source tree:

find spec -type f -print0 | \
xargs -0 perl -pl -i -e 's,^\#\!\s?/(.*)rspec,\#! /usr/bin/env ruby,'

### (maint) Add newlines to all files (whitespace only)

Without this patch there are a number of files that do not have
newlines.  This is a problem because it makes it difficult to use
`perl -pl -i -e ...`

### (#16527) Fix processorcount fact on Solaris

Without this patch applied the processorcount fact on Solaris releases
without the kstat command produces the following error message:
Could not retrieve processorcount: private method `scan' called for nil:NilClass
This is a problem because there is no clear path forward for the end
user.

This patch fixes the problem by switching the command executed to gather
the processor count from executing `kstat` to executing `psrinfo` for
Solaris kernel releases before 5.8.

### (#16526) Fix physicalprocessorcount fact on Solaris

Without this patch applied Facter produces the following error output
when run on versions of Solaris prior to version 8.

    $ facter -d physicalprocessorcount
    /usr/sbin/psrinfo: illegal option -- p
    usage:
    psrinfo [-v] [processor_id ...]
    psrinfo -s processor_id

This is a problem because the value is not actually returned to the end user.

This patch fixes the problem by avoiding the use of the `-p` flag in versions
of Solaris prior to kernel release 5.8 (Solaris 8).  In these scenarios, we
simply count the number of lines in the output of the `psrinfo` command.

### (#16506) Fix illegal option error from uname on hpux

Without this patch applied Facter produces a misleading error message
when run on HP-UX:

    $ facter hardwareisa
    /usr/bin/uname: illegal option -- p
    usage: uname [-amnrsvil] [-S nodename]

This patch fixes the problem by changing the command to `uname -m` when running
on the HP-UX kernel.

### (#13535) Fix uptime; use `uptime` instead of `who -b`

Without this patch applied the uptime fact value is often wrong on some
flavors of Unix.  In particular, the value may be negative or simply
incorrect.

This is a problem because the Facter value does not contained the truth
of our reality.  This makes it difficult to model reality inside of
Puppet.

This patch fixes the problem by replacing the unreliable who -b method
and the Solaris kstat method with a simple call to the
"uptime" command.

This patch also adds RSpec tests for new method and remove RSpec tests
for removed methods.  Delete now-unused fixture file who_b_boottime.

### (#14764) Stop calling enum_cpuinfo and enum_lsdev on unsuitable platforms

Without this patch, the platform specific utility methods on
Facter::Util::Processor named enum_cpuinfo and enum_lsdev are always
called when Facter loads processor.rb.

This is a problem because exceptions will be raised during spec tests on
different platforms as described at
https://projects.puppetlabs.com/issues/14764

Facter 1.6.13
-----

### (#1415) Added case for Linux/IB to get correct IB address or fail predictably.

Originally, facter displayed a truncated infiniband MAC
address.

Now, If the interface starts with ib, use one of two methods
to get the infiniband MAC address or fails with a MAC address
of all FF otherwise.

### (#16005) Puppet agent generates ifconfig warnings on InfiniBand systems fix

Whenever ifconfig was called on systems with Ib interfaces, it
would echo direcly to STDERR.

This commit suppresses ifconfig STDERR messages.

### Improve rubysitedir fact

With ruby-1.9.3 -- at least on Fedora 17 -- trawling through the library
paths looking for the directory does not work.  Using RbConfig seems
more reliable and much simpler.

### (#5205) Update facter manpage

This commit doesn't handle the request in the ticket of dynamically generated
manpage, but it does update the man page to have updated flags and help,
correct license, copyright holder and copyright year. It also fills in the name
of the program for the manpage so that the header doesn't look quite so
mysterious.


Facter 1.6.12
-----

### (#15464) Make contributing easy via bundle Gemfile

Without this patch the process of figuring out how to quickly set up a
development and testing environment for the Puppet _application_ (not a
gem library) is unnecessarily complicated.

This patch addresses the problem by providing a Bundler compatible
Gemfile that specifies all of the Gem dependencies for the Puppet 2.7
application.

Puppet contributors can now easily get a working development and testing
environment using this sequence of commands:

    $ git clone --branch 2.7.x git://github.com/puppetlabs/puppet.git
    $ cd puppet/
    $ bundle install # Install all required dependencies
    $ rspec

The .noexec.yaml file excludes the `rake` command so that the Gemfile
doesn't raise an exception if the `rubygems-bundler` Gem is installed
and automatically running `bundle exec` for us.

The Gemfile.lock contains the exact dependency versions.  This file is
included in the version control system because we're treating Puppet as
an application rather than a library.

### Shift to using packaging repo for packaging tasks

This release introduces Facter's use of the packaging repo at
https://github.com/puppetlabs/packaging for packaging automation. From
source, doing a rake package:bootstrap clones packaging tasks into
ext/packaging and adds rake tasks for packaging of tar, gem, srpm,
rpm, and deb using tools such as rpmbuild and debuild, as well as
puppetlabs-namespaced tasks that use chroot environment tools and are
keyed to specifically interacting with the puppetlabs environment. The
packaging repo works in tandem with the new package-builder modules
designed to set up hosts for packaging,
https://github.com/puppetlabs/puppetlabs-rpmbuilder, and
https://github.com/puppetlabs/puppetlabs-debbuilder. This is very much
a work in progress, but a model for how packaging automation could
improve across many Puppet Labs projects.

### (#11640) Added support for new OpenStack MAC addresses

OpenStack changed the MAC address prefix they use to address an
issues with libvirt
OpenStack bug: https://bugs.launchpad.net/nova/+bug/921838

### (#10819) Avoid reading from /proc/self/mounts in ruby

Reading from /proc/self/mounts in ruby can cause hangs in certain
versions of
the Linux kernel. The problem appears when a puppet agent is run
with `--listen`,
which hold open a socket, and then ruby reads from
/proc/self/mounts. When this
occurs ruby calls select on the open filehandles which triggers a bug in the
kernel that causes the select to hang forever.

This commit uses an exec of cat instead of ruby file reading
operations, which
avoids the ruby interpreter having to call select and trigger the bug.
It appears that only /proc/self/mounts has this problem. Other
areas of /proc
were tested and did not cause the error.

Facter 1.6.11
-----

### (#15687) Selinux: Test for policyvers before reading it

Previously facter would read /#{selinux_mount_point}/policyvers without first
verifying it existed, which would spew stderr to the console if it did not
exist. This commit makes the default value for the fact "unknown" and only uses
a different value if policyvers exists. This also includes an updated test
which fails using the previous fact definition.

### (#15049) Return only one selinuxfs path as string from mounts

The block that parses /proc/self/mountinfo to find a selinuxfs filesystem would
return results as an array.  On Ruby 1.8, interpolating this into a string for
File.exists? when one result was returned worked, while on Ruby 1.9 it
interpolated as `["/sys/fs/selinux"]/enforce` so later failed.

This changes the block to return the single result string rather than an array.

This also fixes #11531 where multiple selinuxfs filesystems could be mounted,
as it returns only the first mountpoint.

The /proc file was changed from /proc/self/mountinfo to /proc/self/mounts for
compatibility with Linux 2.6.25 and older.


Facter 1.6.10
-----

### (#10261) Detect x64 architecture on Windows

Previously, the hardwaremodel fact was using

    RbConfig::CONFIG['host_cpu']

for Windows, but this returns i686 on a 64-bit OS, which is incorrect. And
this caused the architecture fact to be reported as i386, which is also
wrong.

This commit updates the hardwaremodel fact on Windows to return the
appropriate cpu model, e.g. x64, i686, etc. Based on that, the
architecture fact will either be x86 or x64, and can be used to install
architecture-specific packages, e.g. splunk-4.2.4-110225-x64-release.msi.

### (#13678) Add filename extension on absolute paths on windows

Running Facter::Util::Resolution.exec calls
Facter::Util::Resolution.which to get the absolute pathname to a binary.
If passing a relative path, puppet will check different search paths and
different filename extensions (like .com, .exe) to find the absolute
path on windows machines

For absolute paths the former behaviour was to just return true if the
path is a valid path to an executable, so "C:\Windows\System32\netsh"
was treated as invalid because it misses the correct extension
(netsh.exe) which caused the ipaddress6 fact to fail.

Change the behaviour of Facter::Util::Resolution.which to also try out
the different filename extensions if an absolute path is used.

### (#13678) Allow passing shell built-ins to exec method on windows

The former exec method tried to run the command on windows no matter
wether it could be found on the filesystem or not. This allowed end
users to run shell-builtins with the exec method.

The new exec method always tried to expand the binary first and returned
nil if the binary was not found. This commit now restores the old
behaviour on windows: Even if we fail to expand the command, we will try
to run the command in the exact same way as it was passed to the exec
method in case it is indeed a shell built-in. But we will now raise a
deprecation warning.

Reason for deprecating this "even if we cannot find it, just run it"
behaviour: We may want to predetermine the paths where facter tries to find
binaries in the future. A fall back behaviour may then lead to strange
results. Most built-ins can be expressed in pure ruby anyways.

### (#13678) Single quote paths on unix with spaces

If we want to execute a command foo which is found in a path with spaces
we have to quote the path in order to be able to pass the command to the
shell.

Instead of using double quotes we should use single quotes on unix. On
windows only double quotes are valid

### (#13678) Join PATHs correctly on windows

On windows File.join joins with the File::SEPARATOR which is '/' on
windows. While a lot of the windows API and the ruby filetests allow
/ as a separator we should use File::ALT_SEPARATOR ('\' on windows) to
create pathnames on windows

### maint: Add shared context for specs to imitate windows or posix

Add "windows" and "posix" shared contexts to rspec. The shared context
was borrowed from the puppet codebase. If you give :as_platform =>
:posix or :as_platform => :windows as an argument to a describe block or
a context block, it will stub is_windows, File::SEPARATOR, and
File::ALT_SEPARATOR. In addition to puppets shared_context it will also
stub File::PATH_SEPARATOR

### (#13678) Convert command to absolute paths before executing

The former behaviour of facter is to allow passing commands to
Facter::Util::Resolution.exec where the executable is not an absolute
pathname. To check if the executable is present on the system facter would
then run %{which commandname}. As a result we end up with two shell
invocations just to run a single command.

The fix now tries to convert the executable of the command into an
absolute pathname so we can easiliy check with the File.executable?
method if we can try to run the command.

The two methods `which` and `absolute_path?` are adopted from puppet
which claim to run on both windows and unix systems. This is great
because we do not have to distinct between the platforms in the exec
method anymore.

### (#14582) Fix noise in LSB facts

Redirect LSB fact's stderr to /dev/null to prevent excess noise.

Use git describe in Rakefile to determine pkg ver
This commit borrows from the puppet-dashboard tarball
generation rake task, using git describe to generate
the version string instead of using the hardcoded
value in lib/facter.rb. This allows the tarball task
to generate correctly named RC tarballs. Currently,
packaging RCs requires the manual renaming and tarring
of the generated directory. Because the built in rake/
PackageTask does not play well with long git-describe
strings, it is replaced with a different implementation
that can handle the longer git-describe version strings.
The gem package task still uses the rake built-in, so
the version string is santized for it.

### Bump Facter epoch to 1

This commit bumps the facter epoch to 1. This
is to address the errant release of a facter 2.0rc
to the Puppet Labs yum production repository, which
may have been then installed unintentionally by its
users.


Facter 1.6.9
-----

### (#11511) Split lsb facts into multiple files

If a fact is stored in a file that does not follow the convention
$factname.rb, we may encounter ordering and recursion issues as seen in
issue #11511. The concrete example was:

- flush clears all facts
- load_all is triggered to reload facts
- inside an .rb file we query the operatingsystem fact directly (say outside a Facter.add block)
- the operatingsystem fact has a suitable resolver for linux which
  wants to query the lsbdistid fact, which is (apperently) not yet
  loaded (this might not even be predictable)
- the loader doesnt find a lsbdistid.rb file so it triggers load_all
  (remember: we are still trying to get a value for operatingsystem)
- the load_all does load other files (like processor.rb) that want to
  query the architecture fact directly (outside a Facter.add block)
- the architecture fact is dependent on the operatingsystem fact, we are
  currently trying to resolve -> boom: recursion
  This commit implements one possible fix: Split the lsb facts into
  differnet files so the loader finds them. We therefore dont have to run
  load_all in the middle of a fact resolution.

### (#14332) Correct stubbing on Ubuntu

The tests for facter fail on Ubuntu because lsbdistid is not
correctly stubbed.
This patch fixes that small mistake by stubbing lsbdistid for all
Linux tests,
except where the test is really about testing for Ubuntu.

Facter 1.6.8
-----

### (#12831) Add rspec tests to have_which method in Resolution

Tests cases were originally provided by Ken Barber:

Previously we had no coverage of this important method. This adds very basic
testing, including failure testing for Windows.

### (#12831) Fix recursion on first kernel fact resolution

We encounter a recursion if we want to detect the kernel fact for the first
time:

The kernel codeblock calls

    Facter::Util::Resolution.exec("uname -s")

and Facter::Util::Resolution#exec wants to detect if we can use `which`
to get the full path of the command. But the method
Facter::Util::Resolution#have_which tries to query the kernel fact again
to check if we are on windows.

Change the check in have_which so we dont have to query the kernel fact.


Facter 1.6.7
-----

### (#12669) Preserve timestamps when installing files

Without the preserve option, ruby's FileUtils.install method uses the
current time for all installed files.  For backup systems, package
installs, and general pedantic sysadmins, preserving timestamps makes a
small improvement in the world.

### (#12813) Redirect lspci output to /dev/null

On linode instances, or any instance without a working /proc/bus/pci,
the following output is produced on stderr:

    pcilib: Cannot open /proc/bus/pci
    lspci: Cannot find any working access method.

This is very noisy over time, and does not produce anything of value.
Redirecting it to /dev/null removes the issue.

Facter 1.6.6
-----

### (#12666) Make ec2 facts work on CentOS again

   Refactoring the ec2 facts lost the support for CentOS where the
   hardware address in arp -an is uppercased.  Fix and add a unit
   test now that there are those

### Support EC2 facts on OpenStack

OpenStack exports an EC2 compatible API, so make the information
available via facts by knowing that OpenStack generates mac addresses
beginning with 02:16:3E

### (#12362) Use Tempfile to generate temp files

Previously, facter used ENV['TMP'], ENV['TEMP'], /tmp, etc as it's
temp directory search path, using the first one that existed. It then
used constant file names within the temp directory to re-write the
files in ruby's bin directory, and bat wrappers on Windows.

First, it leads to predictable temp file names, which is bad. Second,
when installing facter via a non-interactive ssh shell, e.g.

    $ ssh <host> ruby install.rb

which is what the acceptance test harness does, the TMP and TEMP
environment variables are usually not defined. So facter was always
defaulting to /tmp, which doesn't work when installing facter on
Windows agents during acceptance tests.

This commit just changes the install script to use ruby's Tempfile to
generate secure temp files that works in non-interactive shells.



Facter 1.6.5
-----

### EC2 Improvements

### (#11566) Add windows support for ec2 facts

This patch adds support for detecting ec2 on windows. This works by modifying
the linux methodology by using arp -a instead of arp -an and searching for the
mac address with a hyphen delimiter (as apposed to a quote).
I've added tests and a sample fixtures which adds output from arp -a from a
windows machine and linux machines, on ec2 and not on ec2.
I've also re-worked the decision making into a util class so the testing is
much easier to write and work with, so now we can test the individual mechanism
for detecting that we are in a cloud on their own. This will be much better
abstracted into their own fact(s) but for now this has the least impact to
solve the problem at hand. In the future this logic (and tests) can certainly
be re-used if such a fact was evercreated.
Thanks to Feifei Jia <fjia@yottaa.com> for contributing the original code.

### (#11196) Scan all arp entries for an ec2 mac

This patch now scans all arp entries for the magic EC2 mac address. At times
the mac entry was being returned out of order and since we only looked at the
first entry there were cases where the test would fail.
It also now removes the dependency on the arp fact which has become only
important to the EC2 fact anyway. This was to avoid hacking the arp fact
(which was obviously built for a different purpose) just to fix this issue.

### (#8279) Join ec2 fact output with commas

ec2 facts were being concatenated, which made array data harder to use.
Switched to comma delimited data.
Thanks to Hunter Haugen <hunter@puppetlabs.com> for this patch.


### Other Improvements

### (#10271) Identifying 'Amazon' using '/etc/system-release'
Previously the operating system detection depended upon the lsbrelease package.
This wasn't guaranteed to be present, so this could lead to incorrect detection.
To remedy this, the presence of /etc/system-release is now used for detection
on amazon linux.

### (#11436) Unify memorysize and memorytotal facts

Two different names were given for the amount of physical memory in a
given node. Switched to the name of 'memorysize' for the RAM and added a
fallback fact 'memorytotal' that reverts to the memorysize.

### (#7753) Added error checking when adding resolves

Added exception handling to the fact class. When adding a resolution to
a fact, if an exception was thrown outside of the setcode block, facter
would crash. Added handling so that if an exception is thrown, facter
logs the error and discards the fact.

Facter 1.6.4
-----

### (#11041) Add dmidecode as a requirement for rpm

We were implicitly relying on dmidecode to determine certain facts
without being certain that it was installed.  This change to the rpm
spec file will ensure we have dmidecode pulled in by rpm/yum as a
dependency and thus causing the correct functionality on facter.

Note this change only impacts EL based systems.  The debian packaging is
handled in another repository.

###  (#10885) Malformed facter.bat when ruby dir contains backreferences

Previously, we were substituting occurrences of <ruby> and <command>
in the Windows batch wrapper scripts with the corresponding
paths. However,the gsub replacement string was not escaped, so if a
path contained something that looked like a backreference,
e.g. C:\ruby\187, the gsub would try to replace the backreference with
the corresponding capture group. Since there aren't any capture
groups, the backreference was stripped from resulting facter.bat,
resulting in an invalid path, C:\ruby87\bin\facter.

This commit eliminates the need for gsub, since paths can contain
other characters that have special meaning in a regexp, e.g. '.'.

It also writes the bat file in 'text' mode so that the resulting file
has '\r\n' line endings.

###  (#10444) Add identification of system boards to Facter


Facter 1.6.3
-----

### (#7038) Validate prtdiag output in manufacturer

prtdiag cannot be run inside zones, and calling
Facter::Util::Resolution.exec on it will return nil. The manufacturer
utility was calling split() on nil, which was raising an exception.
Added validation of prtdiag output, and simplified the regex to extract
values for facts. Added more coverage for the related facts as well.


### (#10228) Ascendos OS support for various facts.

This patch will make various facts return the correct value on Ascendos
(a new RHEL rebuild - http://www.ascendos.org/):

* hardwareisa
* lsbmajdistrelease
* macaddress
* operatingsystem
* operatingsystemrelease
* osfamily
* uniqueid

### (#10233) Adds support for Parallels Server Bare Metal to Facter


Facter 1.6.2
-----

### Maint: (#9555) Change all cases of tabs and 4 space indentation to 2 space indentation.

Since 2 space indentation seems to be Puppets (and the ruby communities)
standard this patch converts all incorrect indentation to 2 spaces.

The fact that we were mixing the indentation was causing people to mix them
within files - sometimes using 4 space, sometimes 2 space. This single change
makes it consistent across all the code.

### New Fact: (#9830) Add sshecdsakey fact

 From version 5.7 onward, openssh has support for elliptic curve DSA keys[1,2].
 This commit adds a fact for those keytypes.

 1 - http://openssh.org/txt/release-5.7
 2 - http://tools.ietf.org/html/rfc5656

### New Platform: (#9404) Add memory & update processor facts for DragonFly and OpenBSD.

Since there was no coverage for memory tests these have been added for
the two OS's.

Also since the mechanism for processor detection was changes this was
fixed for OpenBSD. A similar mechanism was added for the new DragonFly
BSD support.


### Fix (#9404) De-clumsify CPU count detection and swap detection on OpenBSD.

As part of the DragonFly BSD work is was noticed that the OpenBSD
implementation could benefit from the same techniques so this commit
aligns that.

### Fix (#6728) Improve openvz/cloudlinux detection.

Added more cloudlinux detection, which has /proc/lve/list present on
cloudlinux hosts. Removed a default value from openvz_type detection,
which could lead to a virtual value of "unknown" if the openvz check
partially failed, which could cause other legitimate virtual tests to
be skipped.


### New Platform: (#7951) added OS support for Amazon Linux

### Maint: (#9787) Change rspec format so we use the default, not document

Current running rake spec in facter means we get the document output which is
very verbose. Unfortunately we are forcing this in our .rspec file so you
can’t override it on a user by user basis with ~/.rspec for example.

I think we should not define —format, which means the default is progress
(which is less verbose and better for the average Joe and hacker who just
wants red light/green light) and then if people really want document format
they can override this in their own ~/.rspec file.

This way its the best of both worlds – more meaningful defaults and allowing
user overrides.

### Fix (#7726) Silence prtconf error message inside zones

prtconf will output an error message when run inside a zone, which
clutters up facter output. Redirected the stderr to /dev/null.

### Fix (#4980, #6470) Fix architecture in Darwin and Ubuntu

Architecture now relies on the hardwaremodel fact unless special cased
otherwise, such as for linux distributions that require amd64 as the
expected architecture. Ubuntu was added as a special case, OpenBSD was
collapsed into the current architecture fact and Darwin was added by
removing the kernel confine statement for the architecture fact.

### New fact: (#6792) Added osfamily fact.

Added osfamily fact to determine if a given operating system is a
derivative of a common operating system.

### Fix (#6515 and #2945) Fix processorcount for arm, sparc & ppc for linux.

Previously we were unable to check processor type and count on other
architectures for linux. This fix corrects that.

To remove complication from the fact we have moved the logic for parsing
cpuinfo and lsdev into their own static classes in Facter::Util::Processor.
This is to help with stubbing and to segregate that action as now we have
more conditional cases.

Tests and corresponding cpuinfo fixtures have been added to test those
alternative platforms as well.

### Fix (#3856) Detect VirtualBox on Darwin as well as Linux and SunOS

### Fix (#7996) Restrict solaris cpu processor detection

x86_64 based solaris machines have a pkg_core_id field in output of
kstat cpu_info, which denotes the core id of a specific core relative to
the cpu. This could cause misreporting of processor count. The regex to
count cores was restricted to prevent this. Additional x86_64 tests were
added to verify this behavior.

### Fix (#7996) Add solaris processor facts

Adds processorcount and physicalprocessorcount facts for solaris.

Added minor whitespace change for physicalprocessorcount spec that
ccompanied adding a solaris section to the spec.

Thanks to Merritt Krakowitzer for his contributions to this patch.

### Fix (#9295) Initial detection of Hyper-V hypervisor

Pulled out from video card matching and dmidecode.

Future plans include grabbing version info and seeing if module
is loaded.

dmidecode info:

    System Information
        Manufacturer: Microsoft Corporation
        Product Name: Virtual Machine
        Version: 7.0
        Serial Number: ....-....-....-....-....-....-.. (removed)
        UUID: ........-....-....-....-............ (removed)
        Wake-up Type: Power Switch

### Fix (#2747) Fix detection of xen0 vs xenu in Xen 3.2.

Check for xsd_kva for dom0, rather than independent_wallclock (which is present
on both dom0 and domu). Work around /proc/xen/capabilities, which is
sometimes not world-readable.



Facter 1.6.1
-----

### Fix physicalprocessorcount on windows

Fix #9517

A broken test led to a broken fact. The WMI.execquery was incorrectly stubbed
to return an array when the actual WMI.execquery does not return an array. This
means that length, which works on arrays, does not work with WMI.execquery.
This fixes both the fact and the test. The test is unfortunately lifted to a
higher level, but it has the benefit of being correct.

Thanks to Eric Stonfer for the fact fix.

### Prevent repeated loading of fact files

Fix #8491

Fact loading could recurse indefinitely if a fact file attempted to call
Fact#value on a fact that was not yet defined before the current file.
If Fact#value was called outside of a setcode block, it would be
evaluated at load time and the loader would rescan the fact path from
the beginning and would reenter the current file, continuing until the
stack was full. This is a byproduct of the more exhaustive fact
searching introduced in 2255abee.

The resolution for this is to track the files that have been loaded and
ignore subsequent attempts to load them, emulating the behavior of
Kernel.require. However, since facts can be legitimately refreshed
over the life of a ruby process using Facter, Facter.clear will reset
the list of loaded files by destroying the fact collection, and
subsequently the loader.

Currently puppet agent will reload all facts preceeding a run, so normal
puppet agent behavior will remain as expected. However, the facter facts
terminus manually loads fact files itself and bypasses facter's search
path and standard loading mechanism. While it will benefit from the
recursion protection, it currently does not have a way to reset the
loaded file list.

### Fix logic for domain fact so hostname, then dnsdomainname and finally resolv.conf is used.

Fix #9457

A recent commit changed the logic for how this fall-through logic was
working. I've fixed the logic and added more coverage to pick up on this.

### Physical Memory on Windows

(#8439) Implement total and free physical memory on Windows

This commit adds the 'memoryfree' and 'memorytotal' facts for Windows.
These values represent the amount of physical free and total memory
respectively. Note that the free and total values come from different
WMI objects that report memory sizes in different units. The free
value reported by Win32_OperatingSystem is in kB whereas the total
value as reported by Win32_ComputerSystem is in bytes.

This commit does not add facts for free and total page sizes, since
the total page size is associated with the Win32_PageFileSetting
class, but WMI reports no instance(s) available when automatic page
file management is enabled (and it is by default).

### Physical Processor Count for Windows

(#8439) Add physicalprocessorcount and processor facts on Windows

This commit adds the 'physicalprocessorcount', 'processor{n}' and
'processorcount' facts. The 'physicalprocessorcount' fact is obtained
by counting the number of Win32_Processor instances. Note that the WMI
query does a select on just the Name property, because it is faster
than doing a 'select *'

On Windows 2008, each Win32_Processor represents a physical processor,
and the NumberOfLogicalProcessors property (which includes both multi
and/or hyperthreaded cores) represents the number of logical
processors. For example, a dual-core processor, with quad-hyper
threads per core, will report 1 physical processor and 8 logical
processors.

Note that the NumberOfCores property could be used to distinguish
between multi-core and hyperthreading processors, but the fact does
not distinguish between them.

On Windows 2003, each Win32_Processor represents a logical processor,
and the NumberOfLogicalProcessors property is not available. In this
case, the physicalprocessorcount fact will be over-reported, but the
number of logical processors will be correct.

With that said, if [this hotfix](http://support.microsoft.com/kb/932370) is installed, then 2003 behaves like
2008.

The Win32_Processor.Name property contains extra spaces:

    Intel(R) Core(TM) i7 CPU       M 620  @ 2.67GHz

So we 'squeeze' the output to eliminate duplicate spaces:

    processor0 => Intel(R) Core(TM) i7 CPU M 620 @ 2.67GHz

### IP Facts for Windows

(#8439) Add interface-specific ip facts for Windows

This commit adds Windows to the list of Facter::Util::IP
'supported_platforms'

It adds support for the 'interfaces' fact, e.g.

    interfaces =>
    Loopback_Pseudo_Interface_1,Local_Area_Connection,Teredo_Tunneling_Pseudo_Interface

On Windows, the name of the interface can be edited to include
non-alphanumeric characters, which are not valid fact names. This
commit changes the alphafy method to ensure the returned value only
includes alphanumeric characters (and underscore).

And the ipaddress, netmask, network, and ipaddress6 per-interface
facts, e.g.

    ipaddress_local_area_connection => 172.16.138.218
    netmask_local_area_connection => 255.255.255.0
    network_local_area_connection => 172.16.138.0

    ipaddress6_teredo_tunneling_pseudo_interface =>
    2001:0:4137:9e76:24de:36a7:53ef:7525

Note the per-interface macaddress fact is not yet supported.

Also these facts are only supported on 2008, because the output and
syntax of netsh is different on 2003. Also 2003 has dependencies on
the Routing and Remote Access service, which may not be running.

### Scientific Linux CERN Detection

Add Scientific Linux CERN detection to facter. Fixes #9260

Adds the SLC operatingsystem fact, and adds the SLC variant to all
locations that Scientific Linux is specified.

Added additional unit tests to verify that SLC would not be confused
with Scientific Linux.

#### CHANGELOG

* 3117e82 (#9517) Fix physicalprocessorcount on windows
* 4d93745 (#8491) Prevent repeated loading of fact files
* 6db71d4 (#9457) Fix logic for domain fact so hostname, then dnsdomainname and finally resolv.conf is used.
* 88f343c (#2344) VMware version parsing fix
* 6d47012 (#4869) Implement productname as Darwin hw.model
* d28d96c (#4508) Xen HVM domU not detected as virtual
* d55983e (#9178) Add Oracle Linux identification
* ec04277 (#4228) Ensure MAC address octets have leading zeroes.
* 3eb3628 Add Scientific Linux CERN detection to facter. Fixes #9260
* f810170 (#7957) is_virtual should be false for openvz host nodes
* 1414e0b (#9059) is_virtual should be false on vmware_server
* 7fb0e6a (#8439) Add interface-specific ip facts for Windows
* 5d5848c (#8439) Add ipaddress6 fact on Windows
* 7531a2b (#8439) Add ps fact on Windows
* ddb67c5 (#8439) Move macaddress resolution on Windows
* 0721f2f (#7682) Add complete support for Scientific Linux
* a347920 (#9183) Add support for Alpine linux detection
* 824fac0 (#8439) Add physicalprocessorcount and processor facts on Windows
* 9ef56d6 (#8439) Implement total and free physical memory on Windows
* b3e2274 (#8439) Add Facter::Util::WMI module
* 00bed7a (#8964) Search mountinfo for selinux mount point
* e8d00ec (#8964) Search mountinfo for selinux mount point
* c5d63d4 Fix #2766 - silence unknown sysctl values
* 5d9cc84 (#8660) Fix destdir option on Windows
* e329450 (#8247) Fixing arp DNS timeout issue.
* 15d0406 use each_line instead of each for strings in ruby 1.9
* 08b3f77 (#7854) Add Augeas library version fact
* e84c051 Fixed #7307 - Added serial number fact to Solaris


Facter 1.6.0
-----

###  License Change

Facter has moved to Apache 2.0 license

This is in line with our proposed plan to change
from the GPL license to Apache 2.0 for Puppet in 2.7.0 and
Facter in 1.6.0.

Please see this link for further explanation:

https://groups.google.com/d/topic/puppet-users/NuspYhMpE5o/discussion

### Speed Improvements

(#7670) Stop preloading all facts in the application

If a requested fact isn't found in the same location as its name, we want to
load all of the facts to find it. However, to simplify that, we were previously
just preloading all the facts every time. Because requesting a fact now
implicitly loads all facts if necessary, we can rely on that, providing results
much more quickly in the case where facts do match their filenames.


### Fact Detection Improvements

(#6728) Facter improperly detects openvzve on CloudLinux systems

Make the openvz check for more than just the vz directory to be sure it's
OpenVZ.

Update the OpenVZ fact to be slightly more resilient in it's checking of
OpenVZ, so it doesn't clash with CloudLinux's LVE container system.


(#6740) facter doesn't always respect facts in environment variables

On an OSX host:

    $ facter operatingsystem
    Darwin

    $ facter_operatingsystem=Not_Darwin facter operatingsystem
    Not_Darwin

But on a linux/solaris host:

    $ facter operatingsystem
    CentOS

    $ facter_operatingsystem=Not_CentOS facter operatingsystem
    CentOS

As the operatingsystem fact resolution for linux-based kernels has higher
precedence than the environment variable as it has more matching confines than
the value from the environment variable.

This patch adds from_environment to the resolution mechanism, which makes the
resolution have an artificially high weight by claiming the length of its
confines array is 1 billion.

### Documentation

(#5394) Document each Facter fact.

Document all the builtin Facter facts in puppetdoc/rdoc format.

This is laying the ground work for using a tool like puppet doc, or puppet
describe but for facter, so you can see what a fact is for and how it
resolves this. This is the "leg work" of documenting the actual facts, and
the syntax of them may change in future.



### CHANGELOG Highlights

* 926e912 (#7670) Stop preloading all facts in the application
* 2255abe (#7670) Never fail to find a fact that is present
* 6b1cd16 (#6614) Update ipaddress6 fact to work with Ruby 1.9
* 21fe217 (#6612) Changed uptime spec to be endian agnostic
* 19f96b5 (#6728) Facter improperly detects openvzve on CloudLinux systems
* 5b10173 (#5135) Fix faulty logic in physicalprocessorcount
* 53cd946 Ensures that ARP facts are returned only on EC2 hosts
* bfa038d Fixed #6974 - Moved to Apache 2.0 license
* d56bca8 refactor the mechanism for allowing for resolution ordering to be influenced
* 9f4c5c6 (#6740) facter doesn't always respect facts in environment variables
* bfc16f6 (#2714) Added timeout to prtdiag resulution
* 3efa9d7 (#3856) Add virtualbox detection via lspci (graphics card), dmidecode, and prtdiag for Solaris and corresponding tests. Darwin case is not handled yet.
* 7c80172 (#6883) Update Facter install.rb to be slightly more informative.
* d31e3f9 (#5394) Document each Facter fact.
* d6967a0 (#6613) Switch solaris macaddress fact to netstat