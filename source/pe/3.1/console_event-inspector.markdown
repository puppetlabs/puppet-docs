---
layout: default
title: "PE 3.1 » Console » Event Investigator"
subtitle: "Using Event Investigator"
canonical: "/pe/latest/console_event-investigator.html"
---

Overview
-----

The Puppet Enterprise (PE) event inspector is a reporting tool that provides multiple, dynamic ways to view the state of your infrastructure, providing both broad and specific insight into how Puppet is managing configurations. Specifically, event inspector lets you accomplish two important tasks: monitoring and analysis. Day-to-day, Event inspector can show you what's been happening to your infrastructure as a whole while Puppet applies the configuration data contained in your manifests. If particular events, such as a string of configuration failures, merit further investigation, you can drill down into the data to analyze what happened. Data is presented from the perspective of resources, classes, and nodes giving you needed context so you can easily see where, why, and how events are occurring. 

An event is PE's attempt to modify an individual property of a given resource. Event monitor displays four different possible outcomes for an event:

1. Change: a successful enforcement of a configuration state that resulted in a change to a resource's property
2. Failure: an unsuccessful enforcement of a configuration state
3. Noop: a successful simulation of enforcing a configuration state
4. Skip: an unattempted enforcement of a configuration state due to an upstream failure to enforce a dependent state

Monitoring
-----

![The event tab][eventtab]

You load event inspector by clicking the "Events" tab in the console's main navigation bar. Event inspector's summary view loads, with a summary pane on the left showing you an overview of activity in your infrastructure. Events can be viewed from three different perspectives: events that affected nodes, events that affected classes, and events that affected resources. You can see at a glance whether or not PE has been successful at enforcing your configurations.

![The summary pane][summary]

**Note:** the event inspector page does not refresh automatically. You can see how old the data is by checking the time stamp at the top of the page. Reload the page to update the data (we've included a convenient link for you to do that right on the page). You can restrict the time period on which event inspector is reporting by using the drop-down menu.
![Time period selector][time-selector]

Each section of the summary pane shows events from the perspective of nodes, classes, and resources. If anything appears amiss or you simply want to know more about a given event from a given perspective, you can click on it to drill down and analyze the event.
 
 Analysis
-----

While PE has long provided an ability to look at run reports on a per node basis, allowing you to see which nodes failed during a run, this ability becomes less and less useful as a deployment grows. Beyond 20-30 nodes, a different approach is needed to better understand why failures are occurring. When dozens or even hundreds of nodes have failures, looking at individual run reports for nodes is unwieldy and involves a lot of guess-work and investigation to determine the root cause of those failures. 
Event inspector provides a better way, allowing you to understand events quickly and easily. Instead of taking a node-centric perspective on a deployment, event inspector takes a more holistic approach by adding class and resource views in addition to node view. One way to think about this is to see the node as *where* a change takes place, while a class shows *what* was changed and a resource shows *how* that change came about.



Tips & Issues
-----




[eventtab]: ./images/console/event_inspector/event_tab.png
[summary]: ./images/console/event_inspector/summary_pane.png
[time-selector]: ./images/console/event_inspector/time-period_selector.png





* * *

- [Next: Navigating the Live Management Page](./console_navigating_live_mgmt.html)
