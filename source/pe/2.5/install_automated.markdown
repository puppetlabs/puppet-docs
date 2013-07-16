---
layout: default
title: "PE 2.5 » Installing » Automated Installation"
subtitle: "Automated Installation"
canonical: "/pe/latest/install_automated.html"
---

To streamline deployment, the PE installer can run non-interactively. To do this, you must: 

* Create an answer file
* Run the installer with the `-a` or `-A` flags

Instead of interviewing a user to customize the installation, the installer will read your choices from the answer file and act on them immediately.

Automated installation can greatly speed up large deployments, and is crucial when [installing PE with the cloud provisioning tools](./cloudprovisioner_classifying_installing.html#installing-puppet). 

Obtaining an Answer File
-----

Answer files are simply shell scripts that declare variables used by the installer:

    q_install=y
    q_puppet_cloud_install=n
    q_puppet_enterpriseconsole_install=n
    q_puppet_symlinks_install=y
    q_puppetagent_certname=webmirror1.example.com
    q_puppetagent_install=y
    q_puppetagent_server=puppet
    q_puppetmaster_install=n
    q_vendor_packages_install=y

(A full list of these variables is available in the [answer file reference][answerfile].)

To obtain an answer file, you can:

* Use one of the example files provided in the installer's `answers` directory
* Retrieve the `answers.lastrun` file from a node on which you've already installed PE
* Run the installer with the `-s <FILE>` flag, which saves  an answer file without installing
* Write one by hand

**You must hand edit any pre-made answer file before using it,** as new nodes will need, at a minimum, a unique agent certname.

Editing Answer Files
-----

Although you can use literal strings in an answer file for one-off installations, you should fill certain variables dynamically with bash subshells if you want your answer files to be reusable. 

To run a subshell that will return the output of its command, use either the `$()` notation...

    q_puppetagent_certname=$(hostname -f)

...or backticks:

    q_puppetagent_certname=`uuidgen`

Answer files can also contain arbitrary shell code and control logic, but you will probably be able to get by with a few simple name-discovery commands.

See the [answer file reference][answerfile] for a complete list of variables and the conditions where they're needed, or simply start editing one of the example files in `answers/`. 

[answerfile]: ./install_answer_file_reference.html

Running the Installer in Automated Mode
-----

Once you have your answer file, simply run the installer with the `-a` or `-A` option, providing your answer file as an argument: 

    $ sudo ./puppet-enterprise-installer -a ~/normal_agent.answers

* Installing with the `-a` option will fail if any required variables are not set.
* Installing with the `-A` option will prompt the user for any missing answers. 


* * * 

- [Next: Answer File Reference](./install_answer_file_reference.html) &rarr;
