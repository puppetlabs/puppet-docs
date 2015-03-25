---
layout: default
title: "Contributing to the Puppet Forge"
canonical: "/forge/contributing.html"
---

[puppet-users]:  https://groups.google.com/forum/?fromgroups#!forum/puppet-users
[irc]:           https://webchat.freenode.net/?channels=puppet-razor
[freenode]:      http://freenode.net/
[best-practice]: http://sethrobertson.github.com/GitBestPractices/
[dev]:           https://groups.google.com/forum/?fromgroups#!forum/puppet-dev


#Contributing to Puppet Labs Modules

## How to contribute

Puppet Labs modules on the Puppet Forge are open projects and community contributions are essential for keeping them great. We can't access the huge number of platforms and myriad hardware, software, and deployment configurations that Puppet is intended to serve.

We want to keep it as easy as possible to contribute changes so that our modules work in your environment. There are a few guidelines that we need contributors to follow so that we can have a chance of keeping on top of things.


### Getting Started

* Make sure you have a [GitHub account](https://github.com/signup/free).
* Submit [a ticket](https://jira.puppetlabs.com/browse/MODULES) for your issue, assuming one does not already exist.
   * Read the [JIRA Guide](https://docs.puppetlabs.com/community/puppet_projects_workflow.html) to get started! 
   * Please make sure to use the [Search](https://docs.puppetlabs.com/community/puppet_projects_workflow.html#search-for-duplicates) feature in JIRA to see if your issue has already been reported/addressed.
   * Please try to clearly describe the issue, including the steps to reproduce
   any bug.
   * Please include the story of "why" you want to do something.
* Fork the repository on GitHub.
* Glance at the [Git Best Practices][best-practice] document, even if you don't read it all yet.
* If this is a new feature, make sure you discuss it on the
 [puppet-users mailing list][puppet-users] before getting started on code.


### How to Get Help

We really want it to be simple to contribute to modules, so you can
get started quickly. A big part of that is being available to help you figure
out the right way to solve a problem and to make sure you get up to speed quickly.

You can always reach out and ask for help:

* by email or through the web on the [puppet-users@googlegroups.com][puppet-users]
 mailing list.  (membership is required to post.)
* by IRC, through [#puppet][irc] on [the FreeNode IRC network][freenode].


### Discuss Your Change

You should start by discussing your change in public:

* for small but clear changes, [open an issue describing the bug or feature](https://jira.puppetlabs.com/browse/MODULES).
* for larger changes, send an email to puppet-dev@googlegroups.com or
 [post through the web][dev] before creating the issue.

Any and all members of the community can respond to an issue, and make comments or suggestions. You should take these comments seriously, but you
are not obliged to do what they say.

If the issue is going in the wrong direction, one of the project leaders will
comment, so that you don't waste time building a solution that won't be accepted.  If you don’t get a response you can @mention a committer in a GitHub message, or CC a committer to the discussion thread.

While we love getting code submitted to our projects, the act of submitting
code does not guarantee it will be merged. This is why we encourage discussion
prior to code submissions.


### Making Changes

* Create a topic branch for your work.
   * You should branch off the `master` branch unless otherwise specified by the specific module.
   * Name your branch by the type of contribution and target:
       * Generally, the type is `bug`, or `feature`, but if they don't fit pick
       something sensible.
   * To create a topic branch based on master:
    `git checkout master && git pull && git checkout -b bug/master/my_contribution`
* Don't work directly on the `master` branch, or any other core branch. Your pull request will be rejected unless it is on a topic branch.
* Every commit should do one thing and only one thing.
* Having too many commits is better than having too few commits.
* Check for unnecessary whitespace with `git diff --check` before committing.
* Make sure your commit messages are in the proper format.

~~~
    (#99999) Make the example in CONTRIBUTING imperative and concrete

    Without this patch applied the example commit message in the CONTRIBUTING
    document is not a concrete example.  This is a problem because the
    contributor is left to imagine what the commit message should look like
    based on a description rather than an example.  This patch fixes the
    problem by making the example concrete and imperative.

    The first line is a real life imperative statement with a ticket number
    from our issue tracker.  The body describes the behavior without the patch,
    why this is a problem, and how the patch fixes the problem when applied.
~~~

* Make sure you have added tests for your changes.
* Run _all_ the tests to assure nothing else was accidentally broken.
   * If possible, run the acceptance tests as well as the unit tests.
   * You can *always* ask for help getting the tests working or with writing tests.
   * Furthermore, if you aren't up to writing tests for your work, indicate it clearly in your pull request. You won't be rejected for a lack of tests, but someone else will need to add those tests before we can merge your contribution.

#### Branch and Version Compatibility

Any change to a module should strive as much as possible to be compatible
with all released versions of Puppet. We want to avoid multiple incompatible
versions as much as possible.

We are willing to accept backward-incompatible changes if there is
no possible way around it. Those changes MUST provide a migration strategy
and, if possible, deprecation warnings about the older functionality. Ask for help from the community or a Puppet Labs employee if you'd like some advice on approaches here.

### Submitting Changes

* Push your changes to a topic branch in your fork of the repository.
* Submit a pull request to the repository in the puppetlabs organization.
* Update your ticket to mark that you have submitted code and are ready to be
 reviewed, if it is separate from the pull request.
* A committer checks that the pull request is well formed.  If not, they will
 ask that it is fixed so that:

   1. it is on it's own, appropriately named, branch.
   2. it only has commits relevant to the specific issue.
   3. it has appropriate, clear, and effective commit messages.

* A committer can start a pull request specific discussion; at this point that covers:

   1. Reviewing the code for any obvious problems.
   2. Providing feedback based on personal experience on the subject.
   3. Testing relevant examples on an untested platform.
   4. Thoroughly stepping through the change to understand potential side-effects.
   5. Examining discrepancies between the original issue and the pull request.
   6. Using @mentioning to involve another committer in the discussion.

Anyone can offer their assessment of a pull request or be involved in the
discussion, but keep in mind that this isn't the time to decide if the pull
request is desired or not. The only reason it should be rejected at this
point is if someone skipped the earlier steps in the process and submitted
code before any discussion happened.

* Every review should add any specific changes required to the pull request:
   * For comments on specific code, using GitHub line comments.
   * For general changes, include them in the final assessment.
* Every review should end by specifying the type of review and a vote:
   1. Good to merge.
   2. Good to merge with minor changes (which are specified, or line comments).
   3. Not good to merge without major changes (which are specified).
* Any committer can merge after there is a vote of "good to merge".
   1. Committers are trusted to do the right thing - you can merge your own code, but you should make sure you get appropriate independent review.
   2. Most changes should not merge unless a code review has been completed.

### Becoming a Committer

Puppet Labs modules are an open project: any contributor can become a committer.  Being a committer comes with great responsibility: your decisions directly shape the community, as well as the effectiveness of Puppet Forge modules. You will probably invest more and produce less as a committer than a regular developer
submitting pull requests.

As a committer, your code is subject to the same review and commit restrictions
as regular committers.  You must exercise greater caution than most people in
what you submit and include in the project.

On the other hand, you have several additional responsibilities over and above
those of a regular developer:

1. You are responsible for reviewing code from other developers.
2. You are responsible for giving constructive feedback that action can be taken on when code isn't quite there yet
3. You are responsible for ensuring that quality, tested code is committed.
4. You are responsible for ensuring that code merges into the appropriate branch (if applicable).
5. You are responsible for ensuring that our community is diverse, accepting, and friendly.

The best way to become a committer is to fulfill those requirements in the
community, so that it is clear that approving you is just a formality.

The process for adding a committer is:

1. A candidate has demonstrated familiarity with the quality guidelines and
  coding standards by submitting at least two pull requests that are accepted
  without modification.
2. The candidate is proposed by an existing committer.
3. The product owner at Puppet Labs responsible for the Puppet Forge and Modules reviews the candidate and makes a decision.

The decision on adding a committer is absolutely private and any feedback to candidates about why they were not accepted is at the option of the product owner.

#### Removing Committers

Removing a committer happens if they don't live up to their responsibilities, or if they violate the community standards. This is done by the product owner. The details of why are private, and will not be shared.