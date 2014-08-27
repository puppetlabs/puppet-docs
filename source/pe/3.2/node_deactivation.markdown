---
layout: default
title: "PE 3.2 » Deploying PE » Deactivating Nodes"
subtitle: "Deactivating a PE Agent Node"
canonical: "/pe/latest/node_deactivation.html"
---


Deactivating a PE Agent Node
----------------
From time to time, you may need to completely deactivate an agent node in your PE deployment. For example, you recently spun up a handful of virtual machines that were only needed for a short time, and now those nodes need to be deactivated. Deactivating a node is not the same as just using the console or terminal to “delete” a node. The following procedure outlines how to properly deactivate an agent node, which includes revoking the node's certificate, removing the node—and it's associated reports—from PuppetDB, deleting the node from the PE console, and stopping MCollective/live management on node. 

**To deactivate a PE agent node**:

1. [Stop the agent service on the node you want to deactivate](./orchestration_puppet.html). 
2. On the master, deactivate the node; run `puppet node deactivate <node name>`. 

   This deactivates the agent node in PuppetDB. In some cases, the PE license count in the console will not decrease for up to 24 hours, but you can restart the `pe-memcached` service to update the license count sooner.  
   
3. On the master, revoke the agent certificate; run `puppet cert clean <node name>`. 

4. Complete the agent’s certificate revocation. On the master, run `service pe-httpd restart`. 

   The certificate is only revoked after running `pe-httpd restart`. In addition, the Apache process won't re-read the certificate revocation list until the service is restarted. If you don't run `pe-httpd restart`, the node will check in again on the next puppet run and re-register with puppetDB, which will increment the license count again. 
   
   > **Tip**: You will need to run `pe-httpd restart` any load-balanced masters in your system. 

5. Delete the node from the console. Navigate to the node detail page for the deactivated node, and click the __Delete__ button. 

   Alternatively, you can also run `/opt/puppet/bin/rake -f /opt/puppet/share/puppet-dashboard/Rakefile RAILS_ENV=production node:del[node name]`.

   This action does **NOT** disable MCollective/live management on the node. 
   
   **Note**: If you delete a node from the node view without first deactivating the node, the node will be absent from the node list in the console, but the license count will not decrease, and on the next puppet run, the node will be listed in the console. 

6. To disable MCollective/live management on the node stop the pe-mcollective service (on the agent, run `service pe-mcollective stop`), or destroy the agent node altogether. 

7. On the agent node, remove the node certificates in `/etc/puppetlabs/mcollective/ssl/clients`. 

At this point, the node should be fully deactivated.
