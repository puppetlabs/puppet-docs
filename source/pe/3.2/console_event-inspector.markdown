---
layout: default
title: "PE 3.2 » Console » Event Inspector"
subtitle: "Using Event Inspector"
canonical: "/pe/latest/console_event-inspector.html"
---

Puppet Enterprise (PE) event inspector is a reporting tool that provides data for **investigating the current state of your infrastructure.** Its focus is on **correlating information** and presenting it from multiple perspectives, in order to reveal common causes behind related events. Event inspector provides insight into *how* Puppet is managing configurations, and *what* is happening *where* when events occur.

Event inspector lets you accomplish two important tasks: **monitoring** a summary of your infrastructure's activity and **analyzing** the details of important changes and failures. Event inspector lets you analyze events from several different perspectives, so you can reject noise and choose the context that best allows you to understand events that concern you.

Structure and Terminology
-----

### Navigating Event Inspector

Event inspector can be reached by clicking __Events__ in the console's main navigation bar.

![Accessing event inspector][eventtab]

The event inspector page displays two panes of data. Clicking an item will show its details (and any sub-items) in the detail pane on the right. The context pane on the left always shows the list of items from which the one in the right pane was chosen, to let you easily view similar items and compare their states.

To backtrack out of the current list of items, you can use the breadcrumb navigation or the __previous__ button (appearing left of the left pane after you've drilled in at least one level). The back and forward buttons in your browser will behave normally, returning you to the previously loaded URL.

You can also bookmark pages as you investigate events on classes, nodes, and resources, allowing you to return to a previous set of events. However, after subsequent Puppet runs, the contents of the bookmarked pages may be different when you revisit them. Also, if there are no changes for a selected time period, the bookmarks may show default text indicating there were no events on that class, node, or resource.

![The full event inspector page][full_page]


> ### Note: Refreshing and Time Periods
>
> The event inspector page does not refresh automatically; it fetches data once when loading, and uses this same batch of data until the page is closed or reloaded. This ensures that shifting data won't accidentally disrupt an investigation.
>
> You can see how old the current data is by checking the timestamp at the top of the page. Reload the page in your browser to update the data to the most recent events.
>
> You can also restrict the time period over which event inspector is reporting by using the drop-down time period restriction menu. Event inspector does not display events that happened more than 24 hours in the past.
>
> ![Time period selector][time-selector]

### Events

An "event" is PE’s attempt to modify an individual property of a given resource. During a Puppet run, Puppet compares the _current state_ of each property on each resource to the _desired state_ for that property. If Puppet successfully compares them and the property is already in sync (the current state is the desired state), Puppet moves on to the next without noting anything. Otherwise, it will attempt some action and record an event, which will appear in the report it sends to the puppet master at the end of the run. These reports provide the data event inspector presents.

There are four kinds of events, all of which are shown in event inspector:

* **Change:** a property was out of sync, and Puppet had to make changes to reach the desired state.
* **Failure:** a property was out of sync; Puppet tried to make changes, but was unsuccessful.
* **No-op:** a property was out of sync, but Puppet was previously instructed to not make changes on this resource (via either the `--noop` command-line option, the `noop` setting, or the `noop => true` metaparameter). Instead of making changes, Puppet will log a no-op event and report the changes it _would_ have made.
* **Skip:** a prerequisite for this resource was not met, so Puppet did not compare its current state to the desired state. (This prerequisite is either a failure in one of the resource's dependencies or a timing limitation set with [the `schedule` metaparameter](/puppet/3.4/reference/metaparameter.html#schedule).) The resource may be in sync or out of sync; Puppet doesn't know yet.


### Perspectives

Event inspector can use three perspectives to correlate and contextualize information about events:

* Classes
* Nodes
* Resources

For example, if you were concerned about a failed service, say Apache or MongoDB, you could start by looking into failed resources or classes. On the other hand, if you were experiencing a geographic outage, you might start by drilling into failed node events.

Switching between perspectives can help you find the common threads among a group of failures, and follow them to a root cause. One way to think about this is to see the node as *where* an event takes place while a class shows *what* was changed, and a resource shows *how* that change came about.

Summary View: Monitoring Infrastructure
-----

When event inspector first loads, the left pane contains the **summary view.** This list is an overview of recent Puppet activity across your whole infrastructure, and can help you rapidly assess the magnitude of any issues.

The summary view is split into three sub-lists, with one for each perspective (classes, nodes, and resources). Each sub-list shows the number of events for that perspective, both as per-event-type counts and as bar graphs which measure against the total event count from that perspective. (For example, if four classes have events, and two of those classes have events that are failures, the "Classes with events" bar graph will be at 50%.)

You can click any item in the sub-lists (classes with failures, nodes with events, etc.) to load more specific info into the detail pane and begin looking for the causes of notable events. Until an item is selected, the right pane defaults to showing classes with failures.


![The summary pane][summary]



Analyzing Changes and Failures
-----

Once the summary view has brought a group of events to your attention, you can use event inspector to analyze their root causes.  Event inspector groups events into types based on their role in Puppet’s configuration code. Instead of taking a node-centric perspective on a deployment, event inspector takes a more holistic approach by adding the class and resource views. One way to think about this is to see the node as *where* an event takes place while a class shows *what* was changed, and a resource shows *how* that change came about. To see how this works in a practical sense, let's work through an example.

Assume you are a sysadmin and Puppet developer for a large web commerce enterprise. While you were in a meeting, your team started rolling out a new deployment of web servers. In the summary pane's default initial classes view, you note that a failure has been logged for the `Testweb` class that you use for test configurations on new web server instances.

![Default view with failure events][default-failure]

After you click `Testweb`, you can select the __Nodes with failures__ tab or the __Resources with failures__ tab, depending on how you want to investigate the failure on the class.

You click the __Resources with failures__ tab, which loads a detail view showing failed resources. In this case, you can see in the detail pane that there is an issue with a file resource, specifically `/var/www/first/.htaccess`.

![Failed Resources view][resource-failure]

Next, you drill down further by clicking on the failed resource in the detail pane. Note that the left pane now displays the failed resource info that was in the detail pane previously. This helps you stay aware of the context you're searching in. You can use the __previous__ button next to the left pane, the breadcrumb trail at the top, or the back button in your browser to step back through the process, if you wish.

After clicking the failed resource, the detail pane now shows the node it failed on.

![Resource Failed Node view][resource-node-failure-detail]

You bookmark this page and email the link to your team so they can see the specifics of the failure. You click on the failure, and the detail pane loads the specifics of the failure including the config version associated with the run and the specific line of code and manifest where the error occurs. You see from the error message that the error was caused by the manifest trying to set the owner of the file resource to a non-existent user (`Message: Could not find user www-data`) on the intended platform.

![Failed Resource Detail view][resource-detail]

You now know the cause of the failure and which line of which manifest you need to edit to resolve the issue. If you need help figuring out the issue with your code, you might wish to try [Geppetto](/geppetto/4.0/index.html), an IDE that can help diagnose puppet code issues. You'll probably also be having a word with your colleagues regarding the importance of remembering the target OS when working on a module!

Tips & Issues
-----

#### Runs that Restart PuppetDB Not Displayed

If a given puppet run restarts PuppetDB, puppet will not be able to submit a run report from that run to PuppetDB since, obviously, PuppetDB is not available. Because event inspector relies on data from PuppetDB, and PuppetDB reports are not queued, event inspector will not display any events from that run. Note that in such cases, a run report *will* be available via the console's __Reports__ tab. Having a puppet run restart PuppetDB is an unlikely scenario, but one that could arise in cases where some change to, say, a parameter in the `puppetdb` class causes the `pe-puppetdb` service to restart. This is a known issue that will be fixed in a future release.

#### Runs Without Events Not Displayed

If a run encounters a catastrophic failure where an error prevents a catalog from compiling, event inspector will not display any failures. This is because no events actually occurred. It's important to remember that event inspector is primarily concerned with events, not runs.

#### Time Sync is Important

Keeping time synchronized across your deployment will help event inspector produce accurate information and keep it running smoothly. Consider running NTP or similar across your deployment. As a bonus, NTP is easily managed with PE and doing so is an excellent way to learn puppet and PE if you are new to them. The [PE Deployment Guide](/guides/deployment_guide/dg_define_infrastructure.html#thing-one-ntp) can walk you through one simple method of NTP automation.

#### Scheduled Resources Log Skips

If the `schedule` metaparameter is set for a given resource, and the scheduled time has not yet arrived, that resource will log a "skip" event in event inspector. Note that this is only true for user-defined `schedule` and does not apply to built-in scheduled tasks that happen weekly, daily, etc.

#### Simplified Display for Some Resource Types

For resource types that take the `ensure` property, (e.g. user or file resource types), when the resource is first created, event inspector will only display a single event. This is because puppet has only changed one property (`ensure`) which sets all the baseline properties of that resource at once. For example, all of the properties of a given user are created when the user is added, just as they would be if the user was added manually. If a PE run changes properties of that user resource later, each individual property change will be shown as a separate event.


[eventtab]: ./images/console/event_inspector/event_tab.png
[summary]: ./images/console/event_inspector/summary_pane.png
[time-selector]: ./images/console/event_inspector/time-period_selector.png
[default-failure]: ./images/console/event_inspector/default-failure.png
[resource-failure]: ./images/console/event_inspector/failed-resources.png
[resource-detail]: ./images/console/event_inspector/resource-detail.png
[full_page]: ./images/console/event_inspector/full_page.png
[resource-node-failure-detail]: ./images/console/event_inspector/resource-node-failure-detail.png



* * *

- [Next: Viewing Reports and Inventory Data](./console_reports.html)
