---
layout: pe2experimental
title: "PE 2.0 » Welcome » Known Issues"
---

{% capture security_info %}Detailed info about security issues lives at <http://puppetlabs.com/security>, and security hotfixes for supported versions of PE are always available at <http://puppetlabs.com/security/hotfixes>. For security notifications by email, make sure you're on the [PE-Users](http://groups.google.com/group/puppet-users) mailing list.{% endcapture %}

* * *

&larr; [Welcome: New Features and Release Notes](./welcome_whats_new.html) --- [Index](./) --- [Welcome: Getting Support](./welcome_getting_support.html) &rarr;

* * *

Known Issues in Puppet Enterprise 2.0
=====

As we discover them, this page will be updated with known issues in each maintenance release of Puppet Enterprise 2.0. If you find new problems yourself, please file bugs in Puppet [here][puppetissues] and bugs specific to Puppet Enterprise [here][peissues]. 

To find out which of these issues you are affected by, run `/opt/puppet/bin/puppet --version`, the output of which will look something like `2.7.9 (Puppet Enterprise 2.0.1)`. To upgrade to a newer version of Puppet Enterprise, see the [chapter on upgrading](./install_upgrading.html).

[peissues]: http://projects.puppetlabs.com/projects/puppet-enterprise/issues
[puppetissues]: http://projects.puppetlabs.com/projects/puppet/issues


Issues Still Outstanding
-----

The following issues affect the currently shipped version of PE (and all prior releases in the 2.0.x series, unless otherwise stated). 

### Installer Cannot Prevent or Recover From DNS Errors

The installer in PE 2.0 does not currently check for DNS misconfiguration. Such problems can cause the installer to fail, leaving the PE software in an undefined state. To work around this, you should:

* Be sure to read this guide's [Preparing to Install chapter](./install_preparing.html) before installing, and make sure DNS at your site is configured appropriately.
* If the installer has failed, follow [the instructions in the troubleshooting section of this guide][failed_install].

[failed_install]: ./maint_common_config_errors.html#how-do-i-recover-from-a-failed-install

### Internet Explorer 8 Can't Access Live Management Features

The console's [live management](./console_live.html) page doesn't load in Internet Explorer 8. Although we are working on supporting IE8, you should currently use another browser (such as Internet Explorer 9 or Google Chrome) to access PE's live management features. 

### Dynamic Man Pages are Incorrectly Formatted

Man pages generated with the `puppet man` subcommand are not formatted as proper man pages, and are instead displayed as Markdown source text. This is a purely cosmetic issue, and the pages are still fully readable. 

* * *

&larr; [Welcome: New Features and Release Notes](./welcome_whats_new.html) --- [Index](./) --- [Welcome: Getting Support](./welcome_getting_support.html) &rarr;

* * *


Issues Affecting PE 2.0.0
-----

### Installer Cannot Detect or Recover From a Misconfigured Firewall

This issue was fixed in PE 2.0.1, which will detect and warn of firewall misconfigurations. 

The installer in PE 2.0.0 may fail and leave the PE software in an undefined state if your firewall doesn't allow access to the [required ports](./install_preparing.html#firewall-configuration). If your installation fails due to firewall issues, you should follow [the instructions in the troubleshooting section of this guide][failed_install].

### Console's `reports:prune` Task Leaves Orphaned Data

This issue was fixed in PE 2.0.1, and the upgrade process will delete any orphaned data that remains in your console database without requiring any additional user action.

The console's historical node reports can be deleted periodically to control disk usage; this is usually done by [creating a cron job for the `reports:prune` rake task](./maint_maintaining_console.html#cleaning-old-reports). However, in PE 2.0.0, this task [leaves behind orphaned records in the database][resource_statuses]. 

If you aren't at risk of running out of disk space, simply upgrade to Puppet Enterprise 2.0.1 or later at your leisure. 

If you _are_ about to run out of disk, and cannot immediately upgrade PE on your console server, you can:

* Download [this updated rake fragment][updated_task].
* Put it in `/opt/puppet/share/puppet-dashboard/lib/tasks/` on your console server, replacing the existing `prune_reports.rake` file.
* Run the following command on your console server:

        $ sudo /opt/puppet/bin/rake \
        -f /opt/puppet/share/puppet-dashboard/Rakefile \
        RAILS_ENV=production \
        reports:prune:orphaned

    This task will have to be run after every time you run the `reports:prune` task, until you are able to upgrade to an unaffected version of Puppet Enterprise. <!-- Remember to delete the links to this issue from maint_maintaining_console.markdown, once the fix gets rolled in. -->

[updated_task]: https://raw.github.com/puppetlabs/puppet-dashboard/3652aca542671059cdb88e1408efff64cc3cb878/lib/tasks/prune_reports.rake
[resource_statuses]: http://projects.puppetlabs.com/issues/6717

### The Uninstaller Script is Not Shipped With PE

This issue was fixed in PE 2.0.1, which includes the uninstaller. 

[uninstaller]: ./files/puppet-enterprise-uninstaller

The Puppet Enterprise uninstaller script was not included with PE 2.0. Although it is included in subsequent PE releases, you can [download it here][uninstaller]. 

Before you can use it, you must move the uninstaller script into the directory which contains the installer script. The uninstaller and the installer _must_ be in the same directory. Once it is in place, you can make the uninstaller executable and run it:

    # sudo chmod +x puppet-enterprise-uninstaller
    # sudo ./puppet-enterprise-uninstaller

### When Upgrading, `passenger-extra.conf` Requires Manual Edits

This issue was fixed in PE 2.0.1, and the upgrader script now automatically tunes the `passenger-extra.conf` file.

Upgrading to PE 2.0.0 requires you to edit the `/etc/puppetlabs/httpd/conf.d/passenger-extra.conf` file, **on both the puppet master and the console server,** so that it looks like this:

    # /etc/puppetlabs/httpd/conf.d/passenger-extra.conf
    PassengerHighPerformance on
    PassengerUseGlobalQueue on
    PassengerMaxRequests 40
    PassengerPoolIdleTime 15
    PassengerMaxPoolSize 8
    PassengerMaxInstancesPerApp 4

Some of these settings can be tuned:

* `PassengerMaxPoolSize` should be four times the number of CPU cores in the server.
* `PassengerMaxInstancesPerApp` should be one half the `PassengerMaxPoolSize`.

