---
layout: default
title: "PE 3.1 » Console » Event Investigator"
subtitle: "Using Event Investigator"
canonical: "/pe/latest/console_event-investigator.html"
---

Overview
-----

The Puppet Enterprise (PE) event inspector is a tool that provides multiple, dynamic ways to view the state of your infrastructure, providing both broad and specific insight into how Puppet is managing configurations. Specifically, event inspector lets you accomplish two important tasks: monitoring and analysis. Day-to-day, Event inspector can show you what's been happening to your infrastructure as whole while Puppet applies the configuration data contained in your manifests. If particular events, such as a string of configuration failures, merit further investigation, you can drill down into the data to see what happened. Data is presented from the perspective of resources, classes, and nodes so you can easily see where, why, and how events are occurring. 

An event is (align with Joe). Event monitor displays four different types of events:

1. Change: a successful application of a configuration state
2. Failure: unsuccessful application of a configuration state
3. Noop: a successful simulation of a configuration state
4. Skip: an unapplied change (due to an upstream failure of a dependent state)

Monitoring
-----

![The event tab][eventtab]

You load event inspector by clicking the "Events" tab in the console's main navigation bar. Event inspector's summary view loads, with a summary pane on the left showing you an overview of activity in your infrastructure. Events can be viewed from three different perspectives: events that affected nodes, events that affected classes, and events that affected resources.

![The summary pane][summary]

**Note:** the event inspector page does not refresh automatically. You can see how old the data is by checking the time stamp at the top of the page. Reload the page to update the data (we've included a convenient link for you to do that right on the page). You can restrict the time period on which event inspector is reporting by using the drop-down menu.
[TODO: screenshot]

Each section of the summary pane shows events from the perspective of nodes, classes, and resources.
 
 Analysis
-----






[eventtab]: ./images/console/event_inspector/event_tab.png
[summary]: ./images/console/event_inspector/summary_pane.png





* * *

- [Next: Navigating the Live Management Page](./console_navigating_live_mgmt.html)
