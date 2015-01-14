---
layout: default
title: "PE 3.7 » Deploying PE » Deactivating Nodes"
subtitle: "Deactivating a PE Agent"
canonical: "/pe/latest/node_deactivation.html"
---


From time to time, you may need to completely deactivate an agent node in your PE deployment. For example, you recently spun up a handful of virtual machines that were only needed for a short time, and now those nodes need to be deactivated. Deactivating a node is not the same as just using the console or terminal to “delete” a node. The following procedure outlines how to properly deactivate an agent node, which includes revoking the node's certificate, removing the node—and it's associated reports—from PuppetDB, deleting the node from the PE console, and stopping MCollective/live management on node. 

**To deactivate a PE agent**:

1. [Stop the agent service on the node you want to deactivate](./orchestration_puppet.html#start-and-stop-the-puppet-agent-service). 
2. On the Puppet master, deactivate the agent; run `puppet node deactivate <NODE NAME>`. 

   This deactivates the agent in PuppetDB. In some cases, the PE license count in the console will not decrease for up to 24 hours, but you can restart the `pe-memcached` service to update the license count sooner. 
   
3. On the Puppet master, revoke the agent certificate; run `puppet cert revoke <AGENT CERTNAME>`. 

4. Still on the Puppet master, run `puppet agent -t` to kick off a Puppet run.

   This Puppet run will copy the certificate revocation list (CRL) to the correct SSL directory for delivery to the agent.
   
5. Restart the Puppet master with `service pe-puppetserver restart`. 

   The certificate is only revoked after running `service pe-puppetserver restart`. In addition, the pe-puppetserver process won't re-read the certificate revocation list until the service is restarted. If you don't run `service pe-puppetserver restart`, the node will check in again on the next Puppet run and re-register with PuppetDB, which will increment the license count again. 
   
   > **Tip**: You will need to run `service pe-puppetserver restart` on any load-balanced masters in your system. 

6. Delete the node from the console. In the console, click **Nodes**. Click the node that you want to delete and click the __Delete__ button. 

   This action does **NOT** disable MCollective/live management on the node. 
   
   **Note**: If you delete a node from the node view without first deactivating the node, the node will be absent from the node list in the console, but the license count will not decrease, and on the next Puppet run, the node will be listed in the console. 

7. To disable MCollective/live management on the node, [uninstall the Puppet agent](./install_uninstalling.html#uninstalling-pe-from-agent-nodes), stop the pe-mcollective service (on the agent, run `service pe-mcollective stop`), or destroy the agent altogether. 

8. On the agent, remove the node certificates in `/etc/puppetlabs/mcollective/ssl/clients`. 

At this point, the node should be fully deactivated.
