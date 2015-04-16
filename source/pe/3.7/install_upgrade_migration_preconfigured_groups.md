---
layout: default
title: "PE 3.8 » Installing » Upgrading » PE 3.3 to PE 3.8 Migration Tool"
subtitle: "Migrating Classification Data From PE 3.3 to PE 3.8 - Preconfigured Node Groups"
canonical: "/pe/latest/install_upgrade_migration_preconfigured_groups.html"
---

PE 3.3 comes with the following preconfigured node groups and node classification to help you manage your infrastructure with Puppet:

Node groups:

* `default`
* `no mcollective`
* `mcollective`
* `puppet_master`
* `puppet_console`

Node classification:

* `pe_puppetdb`
* `puppet_enterprise::license`
* `pe_postgresql`
* `pe_mcollective`

During the migration process, the migration tool detects your PE 3.3 infrastructure groups and classification and does not export them. This is because PE 3.8 has a more comprehensive and slightly different set of preconfigured infrastructure groups and classification that get installed when you upgrade to PE 3.8. After you have upgraded to PE 3.8 and imported your PE 3.3 classification data, you can create rules in the PE 3.8 preconfigured node groups to ensure that the appropriate nodes are matched to those groups and classified with the infrastructure classes. For detailed information regarding the preconfigured node groups in PE 3.8, see [Preconfigured Node Groups](/console_classes_groups_preconfigured_groups.html).

> **Note:** Although `pe_repo` is a PE infrastructure-related class that comes preconfigured in PE 3.3, `pe_repo` is not removed from your PE 3.3 node classification during the migration process. If you have added the `pe-repo` class to other nodes besides the PE master node, your other nodes will still get this classification after the migration. 

> **Note:** In PE 3.3, if you have set up any node groups that are descendents of the preconfigured node groups listed above, the descendent node groups will **not** be migrated to PE 3.8.

> **Note:** If you have created groups in PE 3.3 and added any of the PE-Infrastructure classes directly to those groups, the migration tool will **not** remove those classes from your groups. After completing the migration, you will need to remove the PE Infrastructure classes from these groups. Rather than creating your own groups for managing PE components, we advise pinning nodes to the new preconfigured node groups in PE 3.8 [Preconfigured Node Groups](/console_classes_groups_preconfigured_groups.html)

The migration tool also detects any node groups in PE 3.3 that have the same name as the preconfigured node groups in PE 3.8 and warns you that you need to rename these groups. The names of preconfigured node groups in PE 3.8 are:

* `default`
* `Agent-specified environment`
* `Production environment`
* `PE ActiveMQ Broker`
* `PE Certificate Authority`
* `PE Console`
* `PE Infrastructure`
* `PE Master`
* `PE MCollective`
* `PE PuppetDB`
* `PE Agent`

> **Warning:** Any classification that you set in the Default node group in PE 3.3 will not be migrated. 


* * *


- [Next: Resolving Conflicts](./install_upgrade_migration_tool_conflicts.html)