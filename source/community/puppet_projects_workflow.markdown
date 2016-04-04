---
title: "JIRA Workflow for Puppet Open-Source Projects"
layout: default
---

This is a guide for managing bugs in Puppet open-source projects, including Puppet, Facter, MCollective, Hiera, and PuppetDB.
The official Puppet bug tracker is run through JIRA and is located at <http://tickets.puppetlabs.com/>.
This guide covers the following tasks:

  - [How to Create a JIRA Account](#create-a-jira-account)
  - [How to file a new bug](#submitting-a-bug)
  - [How to migrate a bug from Redmine](#migrating-tickets-from-redmine)
  - [How to help triage bugs](#workflow-for-bugs)

## Create a JIRA Account

In order to prevent spam and fake accounts, Puppet requires users to create an account on JIRA before filing new tickets or commenting on existing ones.
Accounts can be created by visiting <http://tickets.puppetlabs.com> and following the "Sign Up" link in the "Login" box.


## Submitting a Bug

First, thank you!
While bugs themselves may be bad, quality bug reports are incredibly valuable and a great way to contribute back to the project.

### Search for duplicates

There's a good possibility that your issue has already been reported, but the JIRA database is huge and locating similar issues can take some practice.
Here are two strategies for finding out whether your bug has already been reported (and potentially solved!) by someone else:

1. _JIRA Search_:
   In JIRA, access the issue search by going to the menu bar and choosing "Issues > Search for Issues".
   The search interface contains several drop down menus that can be used to filter issues using fields such as project or assignee in addition to matching words or phrases.
   The search interface can also be toggled to "advanced" mode, which allows queries to be specified using JQL (JIRA Query Language).
   For example, the following JQL query could be used to find all unresolved bugs in the Puppet project that contain a certain phrase:

        type = Bug AND resolution = Empty AND project = "Puppet" AND text ~ "some phrase"

   Comprehensive instructions for searching JIRA, including tips for using JQL, can be found on the Atlassian website: <https://confluence.atlassian.com/display/JIRA061/Searching+for+Issues>
2. _User Group_:
   Join and search the "puppet-bugs" group: <http://groups.google.com/group/puppet-bugs> , but set your email delivery options to "none" or "abridged summary".
   Every action on a bug in the Puppet issue trackers will generate an email to this group, so it's a handy, date-ordered way to keep tabs on what's happening.
   Searches in the puppet-bugs archive can be refined using [Search Terms](https://support.google.com/groups/answer/2371405).
   Two useful refinements are:
     - Using `author:issue-updates@puppetlabs.com` to return tickets reported to the JIRA tracker.
     - Using `author:tickets@puppetlabs.com` to return tickets reported to the old Redmine Tracker.
   If your search turns up an open ticket in the old Redmine tracking system, please create a new JIRA ticket that contains an updated description with a link pointing to the Redmine ticket.

If you find an existing bug within JIRA that matches your issue (even if it's a close-but-not exact match), add a comment describing what you're seeing.
Even a simple "I'm having this exact issue" comment is helpful to determine how widespread an impact the issue has.
Use the "Vote" field in the right sidebar to indicate your support and optionally add yourself as a "Watcher" so future updates to the bug will be e-mailed to you.

If you find bugs similar to, but different in some important way, from what you're seeing, open a new issue and link it to the earlier bug(s) using the "Link" action which can be found in the "More" menu located below the ticket title.
Finally, if you come back empty-handed from your searching, it's time to file a new bug using the steps described in the next section.

### Filing a good bug

Simon Tatham, the developer of PuTTy, has a fantastic write-up on [How to Report Bugs Effectively](http://www.chiark.greenend.org.uk/~sgtatham/bugs.html).
It is highly recommended reading for anyone participating in the Puppet open-source project.

New tickets can be opened in JIRA by following [this link](https://tickets.puppetlabs.com/secure/CreateIssue!default.jspa) or by clicking on the "Create Issue" button in the JIRA menu bar.
After selecting the appropriate "Project" and issue "Type" (usually Bug or New Feature), please fill out the following fields:

* Summary -- A short, accurate description of the problem. As Simon's article says, describe the facts of what you see ("Puppet gives the error message 'x' when I do 'y'") rather than opinion ("Puppet needs to stop printing 'y'").
* Environment -- Due to the huge range of system configurations that Puppet works on, information about your operating system distribution and version, Ruby version and packager, as well as Puppet and Facter versions and the means by which you installed them, can all be highly relevant information that can make the difference between reproducibility and mystification for the next person to look at the bug report.
* Description -- A good description provides the information required for effective troubleshooting.
  The following elements are particularly important:
  * Steps to reproduce -- What can another Puppet user do to reproduce the error?
    If the problem is from a manifest, it's very helpful to extract the relevant Puppet code down to as small a section as possible.
    As a bug reporter, just the process of disentangling the problematic Puppet code from your environment (classes, external node classifier, etc) can sometimes help you solve the problem yourself; however, even if it doesn't, it will greatly aid the developers and community members who are trying to help fix the problem.
  * Expected results -- What is the original problem you are trying to solve?
    It's possible that there's an avenue to solve your problem that is better supported or more well-understood and therefore won't trigger the bug.
    Additionally, having this information about _intent_ will help users in the future who might be searching for help solving the same problem.
  * Actual results -- Please provide specific, cut-and-pasted error messages from the output of Puppet/Facter/Ruby etc.
    Particularly for Puppet, it's helpful to run with the `--debug --trace` options because they will provide Ruby backtraces in event of an error.
  * Regression -- did this work in an earlier version and break when you upgraded?
    Regressions are a very real problem in a codebase as complicated as Puppet's, as it's very difficult to predict the side-effects of a change somewhere deep in the guts of the code.
    If you are conversant with Git, it can be hugely helpful to run a `git bisect` on the problem to determine exactly where the regression was introduced.
    Scott Chacon's [Pro Git section on bisect](http://git-scm.com/book/en/Git-Tools-Debugging-with-Git) is a great introduction to `git bisect`.

### Metadata you can use

There are a number of metadata fields in JIRA, some of which are applicable to all projects and othersi that are project specific.
When filing a new issue, filling in the following fields accurately makes bug triage a lot easier for all projects:

* *Component(s)* -- components define the broad category that a ticket falls into.
  When choosing values for this field, hover the mouse over entries in the pull down list to display descriptions for what is covered by a given component.
  In general, an issue should be specific enough that it is covered by a single component, but multiple components can be assigned if necessary.
* *Labels* -- labels aid in searches and help further categorize tickets.
  The advantage labels offer over the "Components" field is that they are not limited to a fixed list and can be created as required.
  However, this can lead to a proliferation of labels that overlap but are not quite duplicates, so take care when affixing labels to your bug.
* *Affects Version(s)* -- The version in which you've experienced the bug.
  Generally issues that have been encountered and reproduced against the latest point release of a major version are going to get more attention than ones against older versions.
  If you do not see your version of Puppet listed, please try reproducing the bug against a newer version.
* *Environment* -- details concerning the environment in which a bug can be re-produced.
  At a minimum, this should be filled out with the name and version of the operating system where the bug was observed.
  Other important details can also be added concerning related pieces of software such as Facter versions, Apache versions, etc.

Other relevant fields become useful through the course of the bug's lifecycle:

* *Links* -- Issue links are used to reference other JIRA tickets or external web pages.
  If your bug is associated with code on Github, a link should be added pointing to the pull request you've submitted.
  Additionally, if your bug is related to a ticket in the old Redmine tracker, a link should be added pointing to the old bug report.
* *Fix Version(s)* -- the product owners for the various projects maintain a list of bugs that are going into future releases; the "Fix Version(s)" field indicates the release that a work-in-progress bug is expected to be fixed in.
* *Status* and *Assignee* -- see the "Workflow for Bugs" section below for a description of how these fields are used.

The other fields aren't used and ought to be left blank (due date, estimated time, etc).

### Tracking and updating bug

Once you've submitted a bug, you'll be emailed on every update.
When you want to get update emails about bugs you did not create, you can add yourself as a "watcher" using the "Watch" link in the right hand sidebar of each bug page.


## Migrating Tickets from Redmine

Bug tracking for Puppet projects was managed for many years using the Redmine bugtracker hosted at <http://projects.puppetlabs.com>.
Going forward, all ticket activity has shifted to JIRA and Redmine has been placed in read-only mode.

If you find an old, unclosed Redmine ticket that relates to an issue that is still occurring, please create a new JIRA ticket that contains an updated description with a link pointing to the Redmine ticket.


## Workflow for Bugs

### Initial triage

Bugs that are in *Status*: _Open_ are said to need triage.
There's a [Pre-made query for Unreviewed tickets](https://tickets.puppetlabs.com/issues/?filter=11300) that will bring up tickets for all open source projects.
Anyone can triage a ticket! Here's how:

1. Check that the ticket makes sense - is it clear what the requester wants?
    * Is the problem description detailed enough?
    * Is there a description of what is broken and how to replicate the problem?
    * Is it clear what the affected version(s)/platform/feature is?
    * Is it assigned to the right component and does it have descriptive labels?
    * Is the output/code/log data clear and structured (you can edit this by clicking on the description)
2. Check that the ticket "Type" is correct - is this a Bug or a Feature?
3. Can you replicate the problem?
4. Can you fix the problem?  Patches and tests are very welcome! See our [Contribution Guidelines](https://github.com/puppetlabs/puppet/blob/master/CONTRIBUTING.md) for how to get started.

The output of the triage process should be moving the bug to one of the states in "Ticket Status Workflow" section below.

### Ticket Status Workflow

The status of an issue can be changed using the "Workflow" menu at the top of the ticket page.
Links to other JIRA tickets and external web pages can be created using the "Link" entry under the "More" menu.

* *Status*: _Needs Information_, *Assignee*: _Author_ -- Appropriate if the author needs to provide more information to make the issue reproducible.
* *Status*: _Resolved_, *Resolution:* _Duplicate_, *Link Issues*: _Duplicates: (Original Bug)_ -- If the author did not find an earlier bug which describes their issue, but one exists, the newer bug should be closed as a duplicate by setting its status to _Resolved_ and choosing a resolution of _Duplicate_.
  A link to the earlier bug should be added.
* *Status*: _Assessing_, *Assignee*: _Triager_ -- If you make some progress on the ticket but cannot come to immediate resolution, make yourself the *Assignee* and set the state to _Assessing_.
* *Status*: _Needs Information_, *Assignee*: _Product Owner_ -- Often, the problem described in the ticket is not obviously a bug.
  It might be a request for a new feature or a change in existing behaviour.
  In this case the product owner for the project needs to make a decision about whether the change fits into the product direction or perform further investigation and discovery into what the right solution ought to be.
  Setting the *Status* to _Needs Information_ and *Assignee* to the product owner will ensure it gets to the right people (even if, as often happens, the product owner him- or herself is not the final decision-maker, part of the job is to make sure the right eyes see the issue).
* *Status*: _Ready for Engineering_, *Assignee*: _Community or Puppet Developer_ -- Once a ticket is actively being worked on, but no code is ready to merge, it should go into _Ready for Engineering_ status and be assigned to the person working on it.
  Tickets which are in status _Ready for Engineering_ but do not have a target release assigned by the product owner are not being actively worked on by Puppet Labs.
* *Status*: _Ready for Merge_, *Assignee*: _Puppet Developer_ -- Once there is code in a pull request, and a *Link* has been created pointing to the pull request, the developer responsible for community support will perform code review and take further action (comment, request further code or tests, merge).
* *Status*: _Resolved_, *Resolution*: _Fixed_ -- This status is set when a fix for an issue has been merged, but is pending validation and release.
* *Status*: _Closed_, *Assignee*: _Person who closed it_ -- Either been released or no further action can be taken on it. Closer should add a comment with the final resolution of the ticket ("Fixed", "Duplicate", "Cannot Reproduce", etc)

### Communicating during investigation

Change *Assignee* to the person who has the next action on the bug.
For example if a community member triages a bug and determines that the submitter didn't include enough detail to reproduce the problem, they should assign the ticket back to the originator and set the *Status* to _Needs Information_.
When the originator supplies the additional info, they should set *Assignee* back to the person who asked the question and update the status to *Assessing*.

### Boilerplate text for ticket triage

#### Duplicate issue

Hi, thanks for the bug report. This is a duplicate of #XXXX, so I am closing this ticket in favor of the older one. Please add yourself as a watcher on that ticket to track the progress of the fix.

#### Related to open pull request

There is an open pull request which fixes this issue  -- it would be wonderful if you could try the code that is posted here: https://github.com/puppetlabs/puppet/pull/XXX and comment on #XXXX with any issues you run into.

#### Needs more information

I've put this ticket's status into "Needs Information" and assigned it to you.
Please either (a) update it with the information I've requested and re-assign it to me if you need more help, or (b) change the status to "Closed" if you were able to resolve the issue on your own.

#### Code Insufficient

I've put this ticket's status into "Failed Review" and assigned it to you. Please either (a) update the ticket or pull request with a version of code which addresses the issues, or (b) assign it back to me if you are blocked on the problem and I'll move things forward.

#### Contributor guidelines

Our guidelines for patch submission are described in the [CONTRIBUTING.md](https://github.com/puppetlabs/puppet/blob/master/CONTRIBUTING.md)
in the puppetlabs/puppet github repo.
