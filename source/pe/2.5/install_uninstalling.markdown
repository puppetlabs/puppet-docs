---
layout: default
title: "PE 2.5 » Installing » Uninstalling"
subtitle: "Uninstalling Puppet Enterprise"
---

Use the `puppet-enterprise-uninstaller` script to uninstall PE. This script can remove a working PE installation, or undo a partially failed installation to prepare for a re-install.

Using the Uninstaller
-----

To run the uninstaller, ensure that it is in the same directory as the installer script, and run it with root privileges from the command line:

    $ sudo ./puppet-enterprise-uninstaller

The uninstaller will ask you to confirm that you want to uninstall.

By default, the uninstaller will remove the Puppet Enterprise software, users, logs, cron jobs, and caches, but it will leave your modules, manifests, certificates, databases, and configuration files in place, as well as the home directories of any users it removes.

You can use the following command-line flags to change the installer's behavior:

### Uninstaller Options

`-p`
: Purge additional files. With this flag, the uninstaller will also remove all
  configuration files, modules, manifests, certificates, and the
  home directories of any users created by the PE installer.

`-d`
: Also remove any databases during the uninstall. 

`-h`
: Display a help message.

`-n`
: Run in 'noop' mode; show commands that would have been run
  during uninstallation without running them.

`-y`
: Don't ask to confirm uninstallation, assuming an answer of yes.

`-s`
: Save an [answer file][answerfile] and quit without uninstalling.

`-a`
: Read answers from file and fail if an answer is missing. See the [uninstaller answers section][uninstaller_answers] of the answer file reference for a list of available answers.

`-A`
: Read answers from file and prompt for input if an answer is missing. See the [uninstaller answers section][uninstaller_answers] of the answer file reference for a list of available answers.

[uninstaller_answers]: ./install_answer_file_reference.html#uninstaller-answers
[answerfile]: ./install_automated.html

Thus, to remove every trace of PE from a system, you would run:

    $ sudo ./puppet-enterprise-uninstaller -d -p


* * * 

- [Next: Automated Installation](./install_automated.html)
