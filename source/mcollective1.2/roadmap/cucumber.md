---
layout: default
title: Cucumber Testing Suite
disqus: true
canonical: "/mcollective/index.html"
---

[PoC]: http://github.com/ripienaar/mcollective-cucumber
[Cucumber]: http://github.com/aslakhellesoy/cucumber

# {{page.title}}

|                    |         |
|--------------------|---------|
|Target release cycle|**1.0.x**|
|Ticket              |[12](http://code.google.com/p/mcollective/issues/detail?id=12)|

## Overview

There isn't an automated testing suite today, we should work towards unit testing but to kick it off a cucumber based test suite for agents might be a good start for both internal project use and users.

You should be able to write scenarios that describe the behavior of a call to an agent, it should do the call over MC and evaluate the result.

[Cucumber] is a good choice for this as its BDD, we can provide some generic step definitions for users to use when writing their own agents.

## Testing Suite

With the basic [Cucumber] capability in place we should write an or a number of agents that tests the core functionality to start heading towards an automated test framework.  Eventually moving onto full unit testing.

## Proof of Concept
A [proof of concept][PoC] has been made that shows one possible scenario. See below for a cucumber feature that tests an agent.

{% highlight cucumber %}
Feature: Test the echo agent

    Background:
	Given I want to use the config file /home/rip/.mcollective
	And I want to test the echo agent
	And I want to test hosts with class /neph/
	And I want to test hosts with fact country=de

    Scenario: Test the echo action
	Given the following request parameters:
	  | msg | hello world |

	When I invoke the echo action
	Then the result should not be an error
	And the following parameters should be received as a result:
	  | msg  | hello world |
	  | time | /.+/        |
{% endhighlight %}
