---
layout: default
title: "PE 3.7 » Installing » Installing with an Answer File"
subtitle: "Installing with an Answer File"
canonical: "/pe/latest/install_automated.html"
---

You can run the Puppet Enterprise installer while logged into the target server in an automated mode that requires minimal user interaction. The installer will read pre-selected answers to the install configuration questions from an "answer file." There are two steps to the process:

1. Create an answer file or obtain the answer file created by the web-based installer. You can find the latter at `/opt/puppet/share/installer/answers` on the machine from which you ran the installer. 
2. Run the installer with the `-a` or `-A` flag pointed at the answer file.

The flag will cause the installer to read your choices from the answer file and act on them immediately instead of interviewing a user to customize the installation.

Installing with an answer file can greatly speed up large deployments and is crucial when [installing PE with the cloud provisioning tools](./cloudprovisioner_classifying_installing.html#installing-puppet). 

However, please note that an answer file installation requires you to run the installer with an answer file on each node on which you are installing a PE component. In other words, a monolithic installation will require you to run the installer with an answer file on one node, but a split installation will require you to run the installer with an answer file on three nodes. 

>**Warning**: If you're performing a split installation of PE using an answer file, install the components in the following order:
>
> 1. Puppet master
> 2. Puppet DB and database support (which includes the console database)
> 3. The PE console 

## Obtaining an Answer File

Answer files are simply shell scripts that declare variables used by the installer, such as:

    q_install=y
    q_puppet_cloud_install=n
    q_puppet_enterpriseconsole_install=n
    q_puppet_symlinks_install=y
    q_puppetagent_certname=webmirror1.example.com
    q_puppetagent_install=y
    q_puppetagent_server=puppet
    q_puppetmaster_install=n
    q_vendor_packages_install=y

(A full list of these variables is available in [Installing with an Answer File][answerfile].)

To obtain an answer file, you can:

* Use one of the example files provided in the installer's `answers` directory.
* Retrieve the `answers.lastrun` file from a node on which you've already installed PE.
* Write one by hand.

>**Tip**: If you want to use the answer file created from the web-based installer, you can find it at `/opt/puppet/share/installer/answers` on the machine from which you’re running the installer, but note that these answers are overwritten each time you run the installer.

**You must hand edit any pre-made answer file before using it**, as new nodes will need, at a minimum, a unique agent certname.

## Answer File Syntax

Answer files consist of normal shell script variable assignments:

    q_database_port=3306

Boolean answers should use Y or N (case-insensitive) rather than true, false, 1, or 0.

A variable can be omitted if a prior answer ensures that it won't be used (i.e. `q_puppetmaster_certname` can be left blank if `q_puppetmaster_install` = n).

Answer files can include arbitrary bash control logic and can assign variables with commands in subshells (`$(command)`). For example, to set an agent node's certname to its fqdn:

    q_puppetagent_certname=$(hostname -f)

To set it to a UUID:

    q_puppetagent_certname=$(uuidgen)

## Editing Answer Files

Although you can use literal strings in an answer file for one-off installations, you should fill certain variables dynamically with bash subshells if you want your answer files to be reusable. 

To run a subshell that will return the output of its command, use either the `$()` notation...

    q_puppetagent_certname=$(hostname -f)

...or backticks:

    q_puppetagent_certname=`uuidgen`

Answer files can also contain arbitrary shell code and control logic, but you will probably be able to get by with a few simple name-discovery commands.

See the [Installing with an Answer File][answerfile] for a complete list of variables and the conditions where they're needed, or simply start editing one of the example files in `answers/`. 

[answerfile]: ./install_automated.html

## Running the Installer with an Answer File

Once you have your answer file, simply run the installer with the `-a` or `-A` option, providing your answer file as an argument: 

    $ sudo ./puppet-enterprise-installer -a ~/my_answers.txt

* Installing with the `-a` option will fail if any required question variables are not set.
* Installing with the `-A` option will prompt the user for any missing answers to question variables.

**Note**: For security reasons, when the installer runs, the answer file gets permissions changes. The permissions get set to owner `root`, permissions `600`.

### Answer File Options

-a ANSWER_FILE Read answers from file and quit with error if an answer is missing.
-A ANSWER_FILE Read answers from file and prompt for input if an answer is missing. Full answer file is saved at <unpacked tarball dir>/answers.lastrun.<hostname>
-D Display debugging information.  Must be run with the "-a" or  "-A" flag.
-h Display this help.
-l LOG_FILE Log commands and results to file.  Must be run with the "-a" or  "-A" flag.
-n Run in 'noop' mode; show commands that would have been run
during installation without running them.  Must be run with the "-a" or  "-A" flag.
-q Run in quiet mode; the installation process is not displayed. Must be run with the "-a" flag.
-V Display very verbose debugging information. Must be run with the "-a" or  "-A" flag.

## Sample Answer Files

PE includes a collection of sample answer files in the `answers` directory of your distribution tarball. Sample answer file references are available for monolithic (all-in-one) and split installations. For split installations, the answer file references are broken out across the various components you will install; there is an answer file for the Puppet master, the console, and the PuppetDB components.

In addition to the answer file references for monolithic and split installations, we've included a reference for all possible answers that you can include in an answer file. 

Choose from the following:

* [Complete answer file reference](./install_complete_answer_file_reference.html)
* [Monolithic (all-in-one) installation](./install_mono_answers.html)
* [Split installation (puppet master node)](./install_split_master_answers.html)
* [Split installation (console node)](./install_split_console_answers.html)
* [Split installation (PuppetDB node)](./install_split_puppetdb_answers.html) 
