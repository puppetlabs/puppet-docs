---
layout: default
title: " PE 3.8 » Razor » Safety Tips for Provisioning in a Brownfield Environment"
subtitle: "Provisioning in a Brownfield Environment"
canonical: "/pe/latest/razor_brownfield.html"

---

Razor provides great power and efficiency when it comes to provisioning machines and bringing them under Puppet Enterprise management. But if you're not careful, you can inadvertently provision existing machines. In the worst cases, this can mean catastrophic data loss. We really want to make sure that doesn't happen.

This page recommends strategies to make your Razor processes safer for use in brownfield environments. Please familiarize yourself with these strategies before you move on to provisioning machines.

## How Catastrophic Data Loss Can Occur

Before we talk about ways to avoid overwriting your machines, it's a good idea to understand how it can happen. Razor is designed to find and register nodes that boot up on your network. When Razor objects &#8212; repos, brokers, tasks and policies &#8212; have been created and are ready to provision, Razor evaluates the nodes it finds against its policies and determines whether the node is a match for the the policy. If it is, then Razor provisions that node. It won't recognize that a node is already installed unless you register the node (as described below). If a node matches, then it's provisioned.

This is why we recommend that you test out Razor on a separate virtual environment before you begin provisioning in your production environment. That way, you'll have a better idea how to manage Razor around your existing machines.

## Best Practices for Avoiding Overwriting Machines

The following strategies will help you avoid accidentally overwriting your brownfield machines.

### Register Your Nodes

Register your existing nodes using the `register-nodes` command before you create policies. Using the `register nodes` command notifies Razor that your existing machines are already installed. Then Razor skips over them when attempting to match policies.

Nodes can be registered in two ways: Through the microkernel or through the `register-node` command, but only the `register-node` command uses the `installed` flag to mark the node as installed, which signals to Razor that the node should be ignored.

It's also possible for a node to be registered via the microkernel, but still sitting in the microkernel waiting for a policy to bind to. In that case, you can run the `register-node` command to change that node's `installed` flag, ensuring that the node doesn't bind to a policy when one becomes eligible. In this case, you will not create any policies at first, so that all nodes are able to be registered through the `register-node` command. Then, once all existing nodes are inventoried, you can start creating policies for new machines that should be provisioned.

### Limit the Number of Nodes a Policy Can Bind to

Policies have a `max count` field that you can set to the number of nodes you want the policy to bind to. Limiting this number helps you keep tighter control over the nodes on your network that might policy match and be provisioned.

* * *


[Next: Provision Nodes - How To](./razor_using.html)



