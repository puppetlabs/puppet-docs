---
title: "Redmine Workflow for Puppet Open-Source Projects"
layout: default
---


This document serves as a guide for managing bugs in Puppet open-souce projects (Puppet, Facter, Mcollective, Hiera, PuppetDB).
Puppetlabs uses JIRA as its bug tracker, at <http://tickets.puppetlabs.com/>.
This guide covers the following tasks:

  - [How to Create a JIRA Account](#create-a-jira-account)
  - [How to file a new bug](#submitting-a-bug)
  - [How to migrate a bug from Redmine]()
  - [How to help triage bugs]()

## Create a JIRA Account

In order to prevent spam and fake accounts, Puppetlabs requires users to create an account on JIRA before commenting on or filing new tickets.
Accounts can be created by visiting <http://tickets.puppetlabs.com> and following the "Sign Up" link in the "Login" box.


## Submitting a Bug

First, thank you! Conventional wisdom holds that bug reports are bad, but we think that while bugs themselves may be bad, quality bug reports are incredibly valuable and a great way to contribute back to the project.

### Search for duplicates

There's a good possibility that your issue has already been reported, but the JIRA database is huge and locating similar issues can take some practice.
Here are two strategies for finding out if your bug has already been reported (and potentially solved!) by someone else:

1. Use the issue search built into JIRA which is available from the menu bar under "Issues > Search for Issues".
   When searching, be sure to adjust the filters --- especially those available from the "Project" menu.
   Comprehensive instructions for searching JIRA can be found on the Atlassian website: <https://confluence.atlassian.com/display/JIRA061/Searching+for+Issues>
2. Join and search the 'puppet-bugs' group: <http://groups.google.com/group/puppet-bugs> , but set your email delivery options to "none" or "abridged summary".
   Every action on a bug in the Puppet issue trackers will generate an email to this group, so it's a handy, date-ordered way to keep tabs on what's happening.
   Using the Google Groups interface also lets you search through the bug traffic without pulling in any extraneous results.

If you find an existing bug that matches your issue (even if it's a close-but-not exact match), add a comment describing what you're seeing.
Even a simple "I'm having this exact issue" comment is helpful to determine how widespread an impact the issue has.
Use the "Vote" field in the right sidebar to indicate your support and optionally add yourself as a "Watcher" so future updates to the bug will be e-mailed to you.

If you find bugs similar to, but different in some important way, from what you're seeing, file a new issue and link it to the earlier bug(s) using the "Link" action which can be found under the "More" menu.

Finally, if you come back empty-handed from your searching, it's probably time to file a new bug.

### Filing a good bug

Simon Tatham, the developer of PuTTy, has a fantastic write-up on [How to Report Bugs Effectively](http://www.chiark.greenend.org.uk/~sgtatham/bugs.html). It ought to be required reading for anyone participating in a software project, especially so for open-source projects like Puppet. Even if you don't go all the way through the process he describes, please provide:

* Summary -- A short, accurate description of the problem. As Simon's article says, describe the facts of what you see ("Puppet gives the error message 'x' when I do 'y'") rather than opinion ("Puppet needs to stop printing 'y'").
* Environment -- Due to the huge range of system configurations that Puppet works on, your operating system distribution and version, Ruby version and packager, Puppet and Facter versions and means by which you installed them, can all be highly relevant information that can make the difference between reproducibility and mystification for the next person to look at the bug report.
* Steps to reproduce -- What can another Puppet user do to reproduce the error? If the problem is from a manifest, it's very helpful to extract the relevant code down to as small a section of Puppet code as possible. As a bug reporter, just the process of disentangling the problematic Puppet code from your environment (classes, external node classifier, etc) can sometimes help you solve the problem yourself; however, even if it doesn't, it will greatly aid the developers and community members who are trying to help fix the problem.
* Expected results -- What is the original problem you are trying to solve? It's possible that there's an avenue to solve your problem that is better supported or more well-understood and therefore won't trigger the bug. Additionally, having this information about _intent_ will help future people who might be searching for help solving the same problem.
* Actual results -- Please provide specific, cut-and-pasted error messages from the output of Puppet/Facter/Ruby etc. Particularly for puppet, it's helpful to run with the `--debug --trace` options because those provide Ruby backtraces in event of an error.
* Regression -- did this work in an earlier version and break when you upgraded? Regressions are a very real problem in a codebase as complicated as Puppet's, because it's very difficult to predict the side-effects of a change somewhere deep in the guts of the code. If you are conversant with Git, it can be hugely helpful to run a `git bisect` on the problem to determine exactly where the regression was introduced. Scott Chacon's [Pro Git section on bisect](http://git-scm.com/book/en/Git-Tools-Debugging-with-Git) is a great introduction to `git bisect`.

### Metadata you can use

There are a number of metadata fields in JIRA, some of which are applicable to all projects while others are project specific.
When filing a new issue, filling in the following fields accurately makes bug triage a lot easier:

* *Component(s)* -- components define the broad category that a ticket falls into.
  When choosing values for this field, hovering the mouse over entries in the pull down list will display descriptions for what is covered by a given component.
  In general, an issue should be specific enough that it is covered by a single component --- but multiple components can be assigned if necessary.
* *Labels* -- labels aid in searches and help further categorize tickets.
  The advantage labels offer over the "Components" field is that they are not limited to a fixed list and can be created as required.
  However, this can lead to a proliferation of labels that overlap but are not quite duplicates.
* *Affects Version(s)* -- The version in which you've experienced the bug.
  Generally issues that have been encountered and reproduced against the latest point release of a major version are going to get more attention than ones against older versions.
  (Often the first question is going to be "Have you tried this against the latest version?")
* *Environment* -- details concerning the environment in which a bug can be re-produced.
  At a minimum, this should be filled out with the name and version of the operating system where the bug was observed.
  Other important details can also be added concerning related pieces of software such as Facter versions, Apache versions, etc.

Other relevant fields become useful through the course of the bug's lifecycle:

* *Links* -- if your bug is associated with code on Github, a link should be added containing pointing to the pull request you've submitted.
* *Fix Version(s)* -- the product owners for the various projects maintain a list of bugs that are going into future releases; the "Fix Version(s)" field indicates the release that a work-in-progress bug is expected to be fixed in.
* *Status* and *Assignee* -- see the "Workflow for Bugs" section below for a description of how these fields are used.

The other fields aren't used and can be left blank (due date, estimated time, etc).

### Tracking and updating bug

Once you've submitted a bug, you'll be emailed on every update.
When you want to get update emails about bugs you did not create, you can add yourself as a "watcher" using the "Watch" link in the right hand sidebar of each bug page.


## Workflow for bugs

### Initial triage

Bugs that are in *Status*: _Unreviewed_ are said to need triage. There's a [Pre-made query for Unreviewed tickets](https://projects.puppetlabs.com/projects/puppet/issues?query_id=19) that will bring up tickets for Puppet and all its sub-projects. Anyone can triage a ticket! Here's how:

1. Check the ticket makes sense - is it clear what the requester wants?
    * Is the problem description detailed enough?
    * Is there a description of what is broken and how to replicate the problem?
    * Is it clear what the affected version(s)/platform/feature this affects?
    * Is it assigned to the right category and does it have descriptive keywords?
    * Is the output/code/log data clear and structured (you can edit this by updating the ticket and clicking the "More" button next to the "Change properties" line)
2. Is it assigned to the right tracker - is this a Bug or a Feature?
3. Can you replicate the problem?
4. Can you fix the problem?  Patches and tests are very welcome! See our [Contribution Guidelines](https://github.com/puppetlabs/puppet/blob/master/CONTRIBUTING.md) for how to get started.

The output of the triage process should be moving the bug to one of the states in "Ticket Status Workflow" section below.

### Ticket Status Workflow

* *Status*: _Needs more information_, *Assignee*: _Author_ -- Appropriate if the author needs to provide more information to make the issue reproducible.
* *Status*: _Duplicate_, *Related Issues*: _Duplicates: (Original Bug)_ -- If the author did not find an earlier bug which describes their issue, but one exists, the newer bug should be closed as a duplicate by setting its status to _Duplicate_ and using the *Related Issues* field to indicate the original bug number.
* *Status*: _Investigating_, *Assignee*: _Triager_ -- If you make some progress on the ticket but cannot come to immediate resolution, make yourself the *Assignee* and set the state to _Investigating_.
* *Status*: _Needs decision_, *Assignee*: _Product Owner_ -- Often, the problem described in the ticket is not obviously a bug. It might be a request for a new feature or a change in existing behaviour. In this case the product owner for the project needs to make a decision about whether the change fits into the product direction or perform further investigation and discovery into what the right solution ought to be. Setting the *Status* to _Needs decision_ and *Assignee* to the product owner will ensure it gets to the right people (even if, as often happens, the product owner him- or herself is not the final decision-maker, part of the job is to make sure the right eyes see the issue).
* *Status*: _Accepted_, *Assignee*: _Community or Puppetlabs Developer_ -- Once a ticket is actively being worked on, but no code is ready to merge, it should go into _Accepted_ status and be assigned to the person working on it. Tickets which are in status _Accepted_ but do not have an owner are not being actively worked on.
* *Status*: _In Topic Branch Pending Review_, *Assignee*: _Community-Support Developer_ -- Once there is code in a pull request, and the *Branch* field indicates the URL of the pull request, the developer responsible for community support will perform code review and take further action (comment, request further code or tests, merge).
* *Status*: _Merged Pending Release_, *Assignee*: _Release Engineer_ -- After merging completed code, the community support developer sets the _Merged Pending Release_ status and adds a comment with the github URL of the commit that contains the merge (e.g. https://github.com/puppetlabs/puppet/commit/abcdefbadc0ffee
* *Status*: _Closed_, *Assignee*: _Person who closed it_ -- Either been released or no further action can be taken on it. Closer should add a comment with the final resolution of the ticket ("Not to be fixed", "Unable to reproduce", etc)
* *Status*: _Requires CLA to be signed_, *Assignee*: _Author_ -- Even if the code and tests are there, we need a Contributor License Agreement on file before we can merge the code. [Sign the Contributor License Agreement here.](https://cla.puppetlabs.com/)

#### Potentially Unused Statuses

* _Code Insufficient_, _Tests Insufficient_ -- With the development workflow on github, these should come up as part of pull request code review/comments and don't require synchronizing to redmine
* _Rejected_ -- Sounds harsher than it needs to be! Nobody likes being rejected. Why not just "Closed"?

### Communicating during investigation

Change *Assignee* to the person who has the next action on the bug. For example if a community member triages a bug and determines that the submitter didn't include enough detail to reproduce the problem, she should assign the ticket back to the originator and set the *Status* to _Needs more Information_. When the originator supplies the additional info, he should set *Assignee* back to the person who asked the question and update status to *Investigating*.

### Release Planning and Workflow

As the development, product, and UX team members for a project plan for an upcoming release, they organize the pile of potential work into a _backlog_ that becomes a sorted list of features to add and bugs to fix before the release is ready. Each work item will be associated with one or more Redmine bugs, which will get their *Target version* set to the [semantically-versioned](http://semver.org) release number. Tickets that are targeted at a `x` release, like `3.x`, are roughly sorted but not being actively worked on. (Tickets that have no target version and no owner are essentially in the "pile" and almost certainly not being worked on).

This workflow enables the "Versions" view of Redmine, linked off the ["Roadmap"](http://projects.puppetlabs.com/projects/puppet/roadmap) for each project, to act as a burn-down chart for the work remaining for a particular release. The teams will periodically scrub the bugs intended for a particular release and either bring in new issues or retarget bugs that, due to time or scope changes, won't be addressed. Once all the tickets for a release are in *Status*: _Merged Pending Release_, the release is unblocked and the Release Engineering team can begin building packages and updating the repositories.

Once a release is out in the wild, the release engineer sweeps through the bugs that were merged in that release, marks them Closed and sets the *Released in* field to the version number of the freshly released software.

### Boilerplate text for ticket triage

#### Duplicate issue

Hi, thanks for the bug report. This is a duplicate of #XXXX, so I am closing this ticket in favor of the older one. Please add yourself as a watcher on that ticket to track the progress of the fix.

#### Related to open pull request

There is an open pull request which fixes this issue  -- it would be wonderful if you could try the code that is posted here: https://github.com/puppetlabs/puppet/pull/XXX and comment on #XXXX with any issues you run into.

#### Needs more information

I've put this ticket's status into "Needs more Information" and assigned it to you. Please either (a) update it with the information I've requested and re-assign it to me if you need more help, or (b) change the status to "Closed" if you were able to resolve the issue on your own.

#### Code Insufficient

I've put this ticket's status into "Code Insufficient" and assigned it to you. Please either (a) update the ticket or pull request with a version of code which addresses the issues, or (b) assign it back to me if you are blocked on the problem and I'll move things forward.

#### Contributor guidelines

Our guidelines for patch submission are described in the [CONTRIBUTING.md](https://github.com/puppetlabs/puppet/blob/master/CONTRIBUTING.md)
in the puppetlabs/puppet github repo.
