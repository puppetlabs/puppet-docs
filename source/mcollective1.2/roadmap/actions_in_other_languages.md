---
layout: default
title: Actions in other languages
disqus: true
canonical: "/mcollective/index.html"
---
[Queueing]: queueing_and_scheduling.html
[ThreadManagement]: thread_management.html
[BDD]: cucumber.html

# {{page.title}}

|                    |         |
|--------------------|---------|
|Target release cycle|**1.0.x**|
|Requires|[BDD], [ThreadManagement]|
|Related|[Queueing]|

## Overview

We would like to allow people to write actions in other languages, we focus on the action level abstraction since that will give most flexibility - you could write some actions in ruby hosted internally and just some others in other languages.

During the [Queueing] work we'll define a interface to write a request to disk and deal with replies via disk.  We'll use the same interface to pass requests to actions written in other languages.

The agent will be a wrapper, something like this:

{% highlight ruby %}
class Hello<RPC::Agent
	action hello, :external => "hello_action.sh" do
		validate :name, :shellsafe
	end
end
{% endhighlight %}

This will then validate the input etc and pass on a structured input to _$libdir/mcollective/agents.d/hello/hello_action.sh_.

Ideally you'd also still be able to do some input validation etc in the agent side to avoid your external scripts from being called with bogus into.

Libraries will have to be written for other languages to help parse the input/output format, hopefully it will be simple enough so this is accessible to even shell scripts.

