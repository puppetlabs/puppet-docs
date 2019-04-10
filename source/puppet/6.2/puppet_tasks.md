---
layout: default
title: "Bolt tasks"
---

[writing]: https://puppet.com/docs/bolt/latest/writing_tasks_and_plans.html
[bolt]: https://puppet.com/docs/bolt/latest/bolt.html
[pe_tasks]: https://puppet.com/docs/pe/latest/orchestrator/running_tasks.html

Bolt tasks are single, ad hoc actions that you can run on target machines in your infrastructure, allowing you to make as-needed changes to remote systems. You can run tasks with the Puppet Enterprise orchestrator or with Puppet's standalone task runner, Bolt.

Sometimes you need to do arbitrary tasks in your infrastructure that aren't about enforcing the state of machines. You might need to restart a service, run a troubleshooting script, or get a list of the network connections to a given node.

Tasks allow you to do actions like these with either the PE orchestrator or with Bolt, a standalone task runner. The orchestrator uses PE to connect to the remote nodes, while Bolt connects directly to the remote nodes with SSH or WinRM, without requiring any existing Puppet installation. Bolt can also run plans, which chain multiple tasks together for more complex actions.

You can write tasks, which are a lot like scripts, in any programming language that can run on the target nodes, such as Bash, Python, or Ruby. Tasks are packaged within modules, so you can reuse, download, and share tasks on the Forge. Metadata for each task describes the task, validates input, and controls how the task runner executes the task.

Related topics:

* [Writing tasks and plans][writing]
* [Running tasks and plans with Bolt][bolt]
* [Running tasks with the PE orchestrator][pe_tasks]