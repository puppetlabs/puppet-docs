---
layout: default
title: Queuing and Scheduling
disqus: true
canonical: "/mcollective/index.html"
---
[InitialMailThread]: http://groups.google.com/group/mcollective-users/browse_frm/thread/583dbf305bef2f8d
[ThreadManagement]: thread_management.html
[OtherLanguages]: actions_in_other_languages.html
[SLURM]: https://computing.llnl.gov/linux/slurm/overview.html
[BDD]: cucumber.html

# {{page.title}}

|                    |         |
|--------------------|---------|
|Target release cycle|**1.0.x**|
|Requires|[BDD], [ThreadManagement]|
|Related|[OtherLanguages]|


## Overview
Currently mcollective is all real time and not optimised for long running tasks or scheduled tasks.

The use case for these can be:

 * do yum updates
 * run puppetd --test and get output later
 * dig through lots of log files
 * restart a service at 4am
 * build vms, this a multi stage task with dependencies: make volume, make config, dd image into volume, start vm

We want to add the ability to:

 * Schedule any agent/action to be called at a later time
 * Query scheduled jobs or completed job results
 * Terminate jobs currently running
 * Edit/Delete jobs scheduled but not yet started

Any SimpleRPC action should have the scheduling ability.

During this process a job interface will be created to represent a SimpleRPC request on disk.  This format should be documented and usable by other languages.  The reply format should be similarly documented.  This will effecitvely mean a [action could be written in a different programming language than ruby][OtherLanguages].  In the main agent a Stub will exist identifying an action as an exernal process type.

For multi stage jobs a job should be able to create subsequent jobs allowing you to chain associated tasks in a specific order with built in dependencies - a failed job will not create the next leg in the process.

When creating a new job a dependency should optionally be supported, the dependency will list a jobid that has to complete first before this job can be started.  Since jobid's need to be unique we could potentially support dependencies on jobs run on other nodes.

This was [discussed on the mailing list][InitialMailThread].

## Sample Usage

To do a puppet run today we do something like this:

{% highlight ruby %}
puppet = rpcclient("puppetd")
printrpc puppet.status
{% endhighlight %}

To do a scheduled task right now but just in the background:

{% highlight ruby %}
puppet = rpcclient("puppetd")
jobid = puppet.status(:forcerun => true, :schedule => :background)

puts "Submitted job id #{jobid}"
{% endhighlight %}

This will fork a background run into the background so that even if you restart mcollectived - like with your puppet run - the running job will be managed by the forked manager.

The job results will then be saved when it's done on the node and later its output can be fetched by job id.

Instead of the plain _:background_ you will be able to provide a schedule like _2010-09-01 04:00_

## Job Storage
Jobs will be stored on each node, we want to make them resilient to all sorts of failure.

The current mcollectived will have a thread that tracks jobs due to start and will then fork off a manager.  Potentially we might need a second daemon to manage the job queue but will try to avoid this.

Replies will also be stored on disk on every node.

The real time nature of mcollective will be used to create/edit/delete/query the jobs on disk, this will ensure maximum portability across middleware systems.  We could use something like beanstalk for the jobs but that would just add extra dependencies.

## Inspiration
Some systems that might be worth reviewing for inspiration or to learn how job scheduling works in other industries:

  * [The Simple Linux Utility for Resource Management][SLURM]
