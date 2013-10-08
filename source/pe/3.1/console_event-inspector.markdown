---
layout: default
title: "PE 3.1 » Console » Event Inspector"
subtitle: "Using Event Inspector"
canonical: "/pe/latest/console_event-inspector.html"
---

Overview
-----

Puppet Enterprise (PE) event inspector is a reporting tool that provides multiple, dynamic ways to view the state of your infrastructure. It provides both broad and specific insight into *how* Puppet is managing configurations and *what* is happening *where* when it does. 

Specifically, event inspector lets you accomplish two important tasks: monitoring and analysis. Day-to-day, event inspector can show you what's been happening to your infrastructure as PE applies the configuration data contained in your manifests. If particular events, such as a string of resource failures, merit further investigation, you can drill down into the data to analyze what happened, why it happened, and on which nodes. 

Data in event inspector is presented from three perspectives:

* classes
* nodes
* resources 
  
This lets you choose the context you want to use to help you most easily see where, why, and how events are occurring. For example, if you were concerned about a failed service, say Apache or MongoDB, you could start by looking into failed resources or classes. On the other hand, if you were experiencing a geographic outage, you might start by drilling into failed node events.

An event is PE's attempt to modify an individual property of a given resource. Event inspector displays four different possible outcomes for an event:

1. Change: a successful enforcement of a configuration state that resulted in a change to a resource's property
2. Failure: an unsuccessful enforcement of a configuration state
3. Noop: a successful simulation of enforcing a configuration state
4. Skip: enforcement of a configuration state was not attempted due to the lack of a triggering event (such as an upstream failure to enforce a dependent state, or a scheduling event)

Monitoring
-----

![Accessing event inspector][eventtab]

You load event inspector by clicking "Events" in the console's main navigation bar. Event inspector's summary view loads, with a summary pane on the left showing you an overview of activity in your infrastructure. Events are shown from three perspectives: events that affected classes, events that affected nodes, and events that affected resources. The summary lets you see at a glance whether or not PE has been successful at enforcing your configurations. The detail pane on the right shows you the default selection, classes with failures.

Each section of the summary pane shows the number and type of events that affected nodes, classes, and resources. Events are shown both in absolute numbers and with bar graphs that show the ratio of a given type of event to the total number of events for a given perspective.. The summary helps you assess the overall state of your infrastructure quickly, and helps you easily determine the seriousness of an issue. It also provides an interface that gives access to greater detail. If anything appears amiss or you simply want to know more about a given event from a given perspective, you can click on that event type in the summary to drill down and view the event in increasing levels of detail. You can also easily access run reports if you want to see details about the puppet run that generated the event.

![The summary pane][summary]

**Note:** the event inspector page does not refresh automatically. You can see how old the data is by checking the time stamp at the top of the page. Reload the page in your browser to update the data to the most recent events. You can restrict the time period on which event inspector is reporting by using the drop-down menu. Event inspector cannot display events that happened more than 24 hours in the past.
![Time period selector][time-selector]

 
 Analysis
-----

While PE has long provided an ability to look at run reports on a per node basis, allowing you to see which nodes failed during a given run, this ability becomes less and less useful as a deployment grows. Beyond 20-30 nodes, a different approach is often needed to better understand why failures are occurring. When dozens or more of nodes have failures, looking at individual run reports for failed nodes is unwieldy and involves a lot of guess-work and repetition to determine the root cause of those failures. 

Event inspector provides a better way, allowing you to understand the root causes of events quickly and easily by grouping events into types based on their role in puppet's configuration code. Instead of taking a node-centric perspective on a deployment, event inspector takes a more holistic approach by adding class and resource views. One way to think about this is to see the node as *where* an event takes place, while a class shows *what* was changed and a resource shows *how* that change came about. 

To see how this works in a practical sense, let's work through an example.

### Diagnosing a Failure with Event Inspector

Assume you are a sysadmin and puppet developer for a large web commerce enterprise. While you were in a meeting, your team started rolling out a new deployment of web servers. In the summary pane's default initial classes view, you note that a failure has been logged for the `testweb` class that you use for test configurations on new web server instances. 

![Default view with failure events][default-failure]

In the resource summary, you click on "failed", which loads a detail view showing failed resources. In this case, you can see in the detail pane that there is an issue with a file resource, specifically `/var/www/first/.htaccess`.

![Failed Resources view][resource-failure]

Next, you drill down further by clicking on the failed resource in the detail pane. Note that the summary pane now displays the failed resource info that was in the detail pane previously. This helps you stay aware of the context you're searching in. You can use the arrow button next to the summary pane or the bread-crumb trail at the top to step back through the process if you wish. (As with most web applications, the back button on your browser may not give you the expected result.)

The detail pane now shows you all the failures for that resource on every node it failed on. You click on the most recent failure and the event detail pane shows you the specifics of the failure including the config version associated with the run and the specific line of code and manifest where the error occurs. Further, you see from the error message that the error was caused by the manifest trying to set the owner of the file resource to a non-existent user (`Message: Could not find user www-data`) on the intended platform.

![Failed Resource Detail view][resource-detail]

You now know the cause of the failure and which line of which manifest you need to edit to resolve the issue. If you need help figuring out the issue with your code, you might wish to try [Geppetto](/geppetto/geppetto.html), an IDE that can help diagnosis puppet code issues. You'll probably also be having a word with your colleagues regarding the importance of remembering the target OS when you're working on a module!

Tips & Issues
-----

#### Runs that Restart PuppetDB Not Displayed

If a given puppet run restarts PuppetDB, puppet will not be able to submit a run report from that run to PuppetDB since, obviously, PuppetDB is not available. Because event inspector relies on data from PuppetDB, and PuppetDB reports are not queued, event inspector will not display any events from that run. Note that in such cases, a run report *will* be available via the console's "Reports" tab. Having a puppet run restart PuppetDB is an unlikely scenario, but one that could arise in cases where some change to, say, a parameter in the `puppetdb` class causes the `pe-puppetdb` service to restart. This is a known issue that will be fixed in a future release.

#### Runs Without Events Not Displayed

If a run encounters a catastrophic failure where an error prevents a catalog from compiling, event inspector will not display any failures. This is because no events actually occurred. It's important to remember that event inspector is primarily concerned with events, not runs.

#### Time Sync is Important

Keeping time synchronized across your deployment will help event inspector produce accurate information and keep it running smoothly. Consider running NTP or similar across your deployment. As a bonus, NTP is easily managed with PE and doing so is an excellent way to learn puppet and PE if you are new to them. The [PE Deployment Guide](/guides/deployment_guide/dg_define_infrastructure.html#thing-one-ntp) can walk you through one, simple method of NTP automation.

#### Scheduled Resources Log Skips
If the `schedule` metaparameter is set for a given resource, and the scheduled time has not yet arrived, that resource will log a "skip" event in event inspector.

#### Simplified Display for Some Resource Types
For some resource types (e.g. user or file resource types), when the resource is first created, event inspector will simplify what's shown in the resource detail pane by collapsing individual properties into one. If PE changes the resource later, each individual property change will be shown as a separate event.


[eventtab]: ./images/console/event_inspector/event_tab.png
[summary]: ./images/console/event_inspector/summary_pane.png
[time-selector]: ./images/console/event_inspector/time-period_selector.png
[default-failure]: ./images/console/event_inspector/default-failure.png
[resource-failure]: ./images/console/event_inspector/failed-resources.png
[resource-detail]: ./images/console/event_inspector/resource-detail.png



* * *

- [Next: Navigating the Live Management Page](./console_navigating_live_mgmt.html)
