---
layout: default
title: Agent Thread Management
disqus: true
canonical: "/mcollective/index.html"
---
[Queueing]: queueing_and_scheduling.html
[BDD]: cucumber.html

# {{page.title}}

|                    |         |
|--------------------|---------|
|Target release cycle|**1.0.x**|
|Related|[Queueing]|
|Requires|[BDD]|

## Overview

At present we have very naive thread management.  When an agent gets called we start that agent in a thread, when it's time is up we kill the agent.  This has the unfortunate side effect that if a user _system()_ anything in an agent we leave zombies.

We need:

 * An exec harness that people should use to fork system tools
 * A better way to kill threads that first shut down system commands started with the harness
 * Actions should elect if they can just be killed or should be left to run.  Ones left to run might have to be _background_ tasks as per [Queueing].

Agents should use this to do any exec calls to avoid zombies and to ensure they get shut down cleanly

