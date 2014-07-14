---
layout: default
title: "PE 3.3 » Installing » Answer File Reference Overview"
subtitle: "Answer File Reference Overview"
canonical: "/pe/latest/install_answer_file_reference.html"
---

Answer files are used for automated installations of PE. See [the section on automated installation](./install_automated.html) for more details.

Answer File Syntax
------------------

Answer files consist of normal shell script variable assignments:

    q_database_port=3306

Boolean answers should use Y or N (case-insensitive) rather than true, false, 1, or 0.

A variable can be omitted if a prior answer ensures that it won't be used (i.e. `q_puppetmaster_certname` can be left blank if `q_puppetmaster_install` = n).

Answer files can include arbitrary bash control logic and can assign variables with commands in subshells (`$(command)`). For example, to set an agent node's certname to its fqdn:

    q_puppetagent_certname=$(hostname -f)

To set it to a UUID:

    q_puppetagent_certname=$(uuidgen)

Sample Answer Files
-------------------

PE includes a collection of sample answer files in the `answers` directory of your distribution tarball. Answer file references are available for monolithic (all-in-one) and split installations. For split installations, the answer file references are broken out across the various components you will install; there is an answer file for the puppet master, the console, and the PuppetDB components.

Choose from the following:

* [Monolithic (all-in-one) installation](./install_mono_answers.html)
* [Split installation (puppet master node)](./install_split_master_answers.html)
* [Split installation (console node)](./install_split_console_answers.html)
* [Split installation (PuppetDB node)](./install_split_puppetdb_answers.html)

Uninstaller Answers
-----

`q_pe_uninstall`
: **Y or N** --- Whether to uninstall. Answer files must set this to Y.

`q_pe_purge`
: **Y or N** --- Whether to purge additional files when uninstalling, including all
  configuration files, modules, manifests, certificates, and the
  home directories of any users created by the PE installer.

`q_pe_remove_db`
: **Y or N** --- Whether to remove any PE-specific databases when uninstalling.


* * *

- [Next: What gets installed where?](./install_what_and_where.html)
