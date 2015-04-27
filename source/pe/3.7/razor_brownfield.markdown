---
layout: default
title: " PE 3.8 » Razor » Safety Tips for Provisioning in a Brownfield Environment"
subtitle: "Provisioning in a Brownfield Environment"
canonical: "/pe/latest/razor_brownfield.html"

---

Razor provides great power and efficiency when it comes to provisioning
machines and bringing them under Puppet Enterprise management. But if you're not careful, you can inadvertently provision existing machines. In the worst cases, this can mean catastrophic data loss. We really want to make sure that doesn't happen.

This page recommends strategies to make your Razor processes safer for use
in brownfield environments, i.e. environments in which you have machines
that have not been installed by Razor but that are going to PXE boot
against the Razor server. Please familiarize yourself with these strategies
before you move on to provisioning machines in an environment with
previously provisioned machines.

## How Catastrophic Data Loss Can Occur

Before we talk about ways to avoid overwriting your machines, it's a good idea to understand how it can happen. Razor is designed to find and register nodes that boot up on your network. When Razor objects &#8212; repos, brokers, tasks, and policies &#8212; have been created and are ready to provision, Razor evaluates the nodes it finds against Razor's policies and determines whether the nodes are a match for any of them. **If nodes match a policy, then Razor provisions those nodes.** This means that the node will be unconditionally formatted and reinstalled from scratch, losing all data. It won't recognize that a node is already installed unless you register the node (as described below).

This is why we recommend that you test out Razor on a separate virtual environment before you begin provisioning in your production environment. That way, you'll have a better idea of how to manage Razor around your existing machines.

## Best Practices for Avoiding Overwriting Machines

The following strategies will help you avoid accidentally overwriting your
brownfield machines.

### Protect New Nodes

By default, Razor considers all new nodes that it discovers as eligible for
installation. If you need to be certain that no machine ever gets
accidentally reinstalled, set the `protect_new_nodes` configuration setting
to `true`. This marks all newly discovered nodes as `installed`. Nodes with
this setting will then boot locally and are protected from any
modifications by Razor. Razor will only consider those nodes eligible for
installation again when they're explicitly marked as available using the
`reinstall-node` command. New nodes will still be inventoried when they
boot against Razor for the very first time, but will boot locally
thereafter.

### Register Your Nodes

If you are very confident that you know all the machines in your
environment that have valuable content, leave `protect_new_nodes` set to `false` and instead, register your existing nodes using the `register-node` command before you create policies. The `register-node` command notifies Razor that a specific node is already installed. Razor then skips over nodes with `installed` set to `true` when attempting to match policies.

#### Two Ways to Register Nodes

Nodes can be registered in two ways: Through the microkernel or through the
`register-node` command. Only the `register-node` command uses the `installed` flag to mark the node as installed, which signals to Razor that the node should be ignored.

It's also possible for a node to be registered via the microkernel, but
still sitting in the microkernel waiting for a policy to bind to. In that
case, you can run the `register-node` command to change that node's `installed` flag, ensuring that the node doesn't bind to a policy when one becomes eligible. In this case, you will not create any policies at first so that all nodes are able to be registered through the `register-node` command. Once all existing nodes are inventoried, you can start creating policies for new machines that should be provisioned.

### Limit the Number of Nodes a Policy Can Bind To

Policies have a `max count` field that you can set to the number of nodes you want the policy to bind to. Limiting this number helps you keep tighter control over the nodes on your network that might match a policy and be provisioned.

* * *


[Next: Provision Nodes - How To](./razor_using.html)
