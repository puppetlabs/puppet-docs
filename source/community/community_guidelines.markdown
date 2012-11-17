---
title: "Community Guidelines and Code of Conduct for Puppet Communities"
layout: legacy
---

[redmine]: /community/puppet_projects_redmine_workflow.html

We want to keep the Puppet communities awesome, and we need your help to keep it that way. While we have specific guidelines for various tools (see links below), in general, you should:


* **Be nice**: Be courteous, respectful and polite to fellow community members: no regional, racial, gender, or other abuse will be tolerated. We like nice people way better than mean ones!
* **Encourage diversity and participation**: Make everyone in our community feel welcome, regardless of their background, and do everything possible to encourage participation in our community. 
* **Keep it legal**: Basically, don't get us in trouble. Post only content that you own, do not post private or sensitive information, and don't break the law.
* **Stay on topic**: Make sure that you are posting to the correct channel or and avoid off-topic discussions.  Also remember that nobody likes spam. 


Guideline Violations --- 3 Strikes Method
-----

The point of this section is not to find opportunities to punish people, but we do need a fair way to deal with people who are making our community suck.

1. **First occurrence**: We’ll give you a friendly, but public reminder that the behavior is inappropriate according to our guidelines.
2. **Second occurrence**:  We will send you a private message with a warning that any additional violations will result in removal from the community.
3. **Third occurrence**: Depending on the violation, we may need to delete or ban your account.


Notes:

* Obvious spammers are banned on first occurrence. If we don’t do this, we’ll have spam all over the place.
* Violations are forgiven after 6 months of good behavior, and we won’t hold a grudge.
* People who are committing minor formatting / style infractions will get some education, rather than hammering them in the 3 strikes process.
* Extreme violations of a threatening, abusive, destructive or illegal nature will be addressed immediately and are not subject to 3 strikes.
* Contact Dawn Foster to report abuse or appeal violations. In the case of appeals, we know that mistakes happen, and we’ll work with you to come up with a fair solution if there has been a misunderstanding.


Getting Help
-----

Puppet has a healthy community full of people who are happy to help you get unstuck, but the community works best if you know how it works. If you run into trouble with puppet, these guidelines will make it easier for you to quickly get help.


### Self-directed Troubleshooting


Puppet has a relatively long history and open development process for an open-source project, so there is a ton of information returned from google searches for various problems. To narrow down your results to the most relevant, try these google tips:

1. Restrict your search to site:projects.puppetlabs.com – this will cut out the old Trac / reductivelabs wiki and get you more recent hits.
2. Join the [puppet-users google group](http://groups.google.com/group/puppet-users) and use the search box on the group page to search the mailing list. this eliminates duplicate hits from ML mirrors like nabble and lets you order results by date so you aren’t getting confused by a bug that was fixed three versions ago.
3. Use correct Puppet-specific terminology for your problem like yum provider, file resource, and manifest.


Many general questions about Puppet and Puppet Labs are answered in the [Frequently Asked Questions](http://docs.puppetlabs.com/guides/faq.html). Otherwise, the [Documentation Start](http://docs.puppetlabs.com/) is the place to go. Also available is [“Pulling Strings with Puppet”](http://www.amazon.com/gp/product/1590599780?ie=UTF8&tag=puppet0e-20&linkCode=as2&camp=1789&creative=9325&creativeASIN=1590599780) by James Turnbull which is the first book to be written about Puppet and its sequel [“Pro Puppet”](http://www.amazon.com/gp/product/1430230576?ie=UTF8&tag=puppet0e-20&linkCode=as2&camp=1789&creative=390957&creativeASIN=1430230576).
 
We also provide various [commercial services](http://puppetlabs.com/services/overview/) around Puppet (training, professional services, support, certification and more) for people who want a little extra help.

If you can't solve a problem on your own, there are a lot of places you can go to get help from (and help back!) your fellow community members. The sections below cover the norms and expectations in each area of the Puppet community.

Activity-Specific Guidelines
-----

* [IRC Guidelines](#irc-guidelines)
* [Mailing List Guidelines](#mailing-list-guidelines)
* [Bug Guidelines](#bug-guidelines)
* [Documentation Guidelines](#documentation-guidelines)
* [Git / Source Guidelines](#git--source-guidelines)
* [Forge and Module Guidelines](#forge--module-guidelines)

### IRC Guidelines


A great place to get real-time help with Puppet is our IRC channel: #puppet on irc.freenode.net. There are usually many helpful people there in addition to some of the Puppetlabs staff.
Please read and understand this [fantastic guide to getting help for open-source projects on irc](http://workaround.org/getting-help-on-irc) before diving in. All of the points there apply to #puppet, especially “Don’t repeat yourself”, “Don’t ask to ask”, and “Stick around”. #puppet in particular has heavy concentrations of people in UK (GMT) and West-coast US (PST), so asking your question when those time zones are in business hours is more likely to get a good result.


Be aware that the IRC channel is not an official support channel, it’s an ad hoc group of people (some of whom work on puppet for a living) self-organizing to help each other out. If you do not receive an answer to your question, (especially if you have not followed the [getting help on irc best practices](http://workaround.org/getting-help-on-irc)!!), that doesn’t mean you are out of options, the software is hopelessly broken, or your problem is insoluble. It just means you need to keep troubleshooting.


We also have a few IRC-specific guidelines:

* Don't be a jerk: Treat people with respect and consideration.
* Be helpful: Be patient with new people and be willing to jump in to answer questions.
* Stay calm: The written word is always subject to interpretation, so give people the benefit of the doubt and try not to let emotions get out of control.
* Don't post chunks: Avoid posting big chunks of text --- use pastebin or a similar service to shorten it to a link.
* Be patient: Folks might not be around when you ask a question, so wait a while for someone to speak before leaving.
* Search first: Believe it or not, your question might not be new or you might be able to find someone who has already asked or answered your question. Do a thorough search of the [IRC log archives](http://www.puppetlogs.com/) to see if it has been answered before.
* Don't private message: Ask permission before you send someone a private message (PM). Not everyone likes them. Also, by keeping it in public, others with similar issues can see the solution you were given.
* More information: This [IRC primer](http://irchelp.org/irchelp/ircprimer.html) for new users and the [general IRC guidelines](http://freenode.net/channel_guidelines.shtml), from freenode, are also useful resources.


### Mailing List Guidelines


Remember, when you post to a community mailing list, you are, in effect, asking a large group of people to give you some of their time and attention --- to download your message, read it, and potentially reply to it. It is simply polite to make sure your message is relevant to as many of the people receiving the message as possible. Many of the guidelines below stem from this basic principle.


**Puppet Community Mailing Lists**

* [Puppet-Users](https://groups.google.com/group/puppet-users): The Puppet users mailing list, for any and all Puppet discussion.
* [Puppet-Dev](https://groups.google.com/group/puppet-dev): The Puppet-dev mailing list, for all public discussions related to the development of the puppet codebase.
* [Puppet-Razor](https://groups.google.com/group/puppet-razor): The mailing list for any and all questions about the Razor project. 
* [Puppet-Announce](https://groups.google.com/group/puppet-announce) (Read-Only): A list for announcements related to Puppet, e.g.; major version releases
* [Puppet Bugs](http://groups.google.com/group/puppet-bugs) (Read-Only): An automated list that gets a copy of all project ticket activity.
* [Puppet Commit](http://groups.google.com/group/puppet-commit) (Read-Only): An automated list that gets a copy of all git source code commits.

**Search First**

* Believe it or not, your question might not be new. Do a thorough search of the mailing list archives (linked above) to see if it has been answered before.
* You waste everyone's time if you post repeat questions.

**Stay on Topic**

* Review a few posts from our lists before deciding where to post your question (see links to mailing lists above).
* Recruiters are not permitted to post jobs to our mailing lists. However, if you are an active community member and you are personally hiring more people to work on Puppet, you may post relevant job descriptions.

**Avoid Cross-Posting**

* If you have a question, please pick the list that is most relevant to your topic and post the question only on that list.
* Only important community announcements (like conferences, new releases, etc.) should be posted to multiple lists at the same time. When you post to multiple lists, please specify which one list people should reply to with questions and put the other lists in the bcc.

**Keep It Short**

Remember that thousands of copies of your message will exist in mailboxes:

* Keep your messages as short as possible.
* Avoid excessively long log output (select only the most relevant lines, or place the log on a website or in a pastebin, instead if the log messages are very long).
* Don't excessively quote previous messages in the thread (trim the quoted text down to only the most recent/relevant messages).

**Use Proper Posting Style**

* Please avoid using  HTML or Rich Text: Set your mailer to send only plain text messages to avoid getting caught in our spam filters and avoid irritating people who have disabled these types of formats.
* Do not “top post”. Use interleaved posting where possible: Bottom, interleaved posting is replying to the relevant parts of the previous correspondence just below the block(s) of sentences. For a comment to another block of sentences of the same quoted text, you should move below that relevant block again. Do not reply below the whole of the quoted text. Also, remove any irrelevant text.
* Use links: Please provide URLs to articles wherever possible. Avoid cutting and pasting whole articles, especially considering the fact that not everyone may be interested.
* Don't include large attached files: Instead of including large attachments, please upload your file to a server and post a link to the file from your email message.


**Do Not Hijack Threads**

* Post new questions or new topics as new threads (new email message). Please do not reply to a random thread with a new question or start an unrelated topic of conversation in an existing thread. This creates confusion and makes it much less likely that you will get a response.


**Subscribers Only**

* Only subscribers can post to our mailing lists. If you would like to contribute to our mailing lists, we think it is only fair that you be a subscriber. Note: If you want to participate only occasionally, you can subscribe to a list and set your email options to digest or no mail and read the web archives when you want to catch up. 
* To reduce spam, we may moderate posts from new mailing list users. If your message doesn’t appear right away, please be patient and give us a little time to respond to the list moderation requests.


**Recipients**

* Always reply to the mailing list (not the individual) when answering questions. In many cases, one person will post the question and several others will be silently waiting to see the answer on the list. This also helps avoid repeat questions because others can search the mailing list to get answers.
* Always group-reply to a message. Some of the email recipients might not be subscribed, might have turned off email delivery, or may read list messages with lower priority than messages addressed to them directly. For the same reasons, it is advisable to add relevant people to the recipient list explicitly.


Credit to the [Fedora Mailing List Guidelines](http://fedoraproject.org/wiki/Communicate/MailingListGuidelines) as a starting point under the Creative Commons Attribution-ShareAlike 3.0 Unported license.


### Bug Guidelines


You can lodge bug reports and support tickets for Puppet at the [Redmine ticketing system](http://projects.puppetlabs.com/projects/show/puppet). In order to cut down on ticket spam, the tracker requires you to register and log in before the “New issue” link appears in the UI.


Here are a few guidelines that apply specifically to our bug tracker:

* Each bug report is for only one issue. If you find several issues, please separate them into several reports.
* Do a search before you file a bug, and try to avoid filing duplicates by taking a look at whether your issue has already been filed before.
* Don't start endless debates on topics not directly related to the scope of a specific bug report. We have mailing lists and other places for longer discussions.
* Avoid quoting complete previous comments by stripping unneeded lines.
* Please double check to make sure that the information you are including is public (not confidential), especially in attached log files or screenshots.
* We encourage community members to help us triage bugs, and this is a great way for anyone to get involved without ever writing a line of code. For more details, see our [Redmine Workflow][redmine] document.
* Refer to our [Redmine Workflow][redmine] document for more details about the process for filing bugs.


### Documentation Guidelines

* We encourage contributions to our documentation.
* Our documentation is licensed under a [Creative Commons Attribution-Share Alike 3.0 United States License](http://creativecommons.org/licenses/by-sa/3.0/us/).
* For suggestions or minor corrections, just email faq@puppetlabs.com. 
* To contribute text or make larger-scale suggestions, see the [instructions for contributing](http://docs.puppetlabs.com/contribute.html). 
* If you would like to submit your own content, you can fork the project on [github](http://github.com/puppetlabs/puppet-docs), make changes, and send us a pull request. See the README files in the project for more information about how to generate and view a copy of the website.


### Git / Source Guidelines

* If you want to contribute code, you might want to start with a discussion on the mailing list to make sure that what you want to submit is a good idea or architected in a way that will be useful for others.
* Look at existing pull requests to make sure that you aren’t duplicating effort. 
* Review any existing CONTRIBUTOR.MD files associated with the project.
* If you are new to git or github, you might find these resources useful: [github help files](http://help.github.com/), [Git cheat sheets](http://help.github.com/git-cheat-sheets/), and [Git Reference documentation](http://gitref.org/).


### Forge / Module Guidelines

The [Puppet Forge](http://forge.puppetlabs.com/) is a repository of modules, written and contributed by users, and we encourage you to publish your modules on the Forge.

* Start with the [Publishing Modules](http://docs.puppetlabs.com/puppet/3/reference/modules_publishing.html) document to learn how to publish your modules to the Puppet Forge.
* See the [Module Fundamentals](http://docs.puppetlabs.com/puppet/3/reference/modules_fundamentals.html) document for how to write and use your own Puppet modules.
* See the [Installing Modules](http://docs.puppetlabs.com/puppet/3/reference/modules_installing.html) document for how to install pre-built modules from the Puppet Forge.
* See the [Using Plugins](http://docs.puppetlabs.com/guides/plugins_in_modules.html) document for how to arrange plugins (like custom facts and custom resource types) in modules and sync them to agent nodes.

Credit to [01.org](https://01.org/community/participation-guidelines) and [meego.com](http://wiki.meego.com/Community_guidelines), since they formed the starting point for many of these guidelines.
