---
title: "Community Guidelines and Code of Conduct for Puppet Communities"
layout: default
---

[issue_tracker_workflow]: /community/puppet_projects_workflow.html

We want to keep the Puppet communities awesome, and we need your help to keep it that way. While we have specific guidelines for various tools (see links below), in general, you should:

-   **Be nice**: Be courteous, respectful and polite to fellow community members. No offensive comments related to gender, gender identity or expression, sexual orientation, disability, physical appearance, body size, race, religion; no sexual images in public spaces, real or implied violence, intimidation, oppression, stalking, following, harassing photography or recording, sustained disruption of talks or other events, inappropriate physical contact, or unwelcome sexual attention will be tolerated. We like nice people way better than mean ones!
-   **Encourage diversity and participation**: Make everyone in our community feel welcome, regardless of their background, and do everything possible to encourage participation in our community.
-   **Keep it legal**: Basically, don't get us in trouble. Share only content that you own, do not share private or sensitive information, and don't break the law.
-   **Stay on topic**: Make sure that you are posting to the correct online channel and avoid off-topic discussions. Also remember that nobody likes spam.

Guideline violations --- 3 strikes method
-----

The point of this section is not to find opportunities to punish people, but we do need a fair way to deal with people who do harm to our community. Extreme violations of a threatening, abusive, destructive, or illegal nature will be addressed immediately and are not subject to 3 strikes.

1.  **First occurrence**: We'll give you a friendly, but public, reminder that the behavior is inappropriate according to our guidelines.
2.  **Second occurrence**: We'll send you a private message with a warning that any additional violations will result in removal from the community.
3.  **Third occurrence**: Depending on the violation, we might need to delete or ban your account.

Notes:

-   Obvious spammers are banned on first occurrence. If we don’t do this, we’ll have spam all over the place.
-   Violations are forgiven after 6 months of good behavior, and we won’t hold a grudge.
-   People who are committing minor formatting / style infractions will get some education, rather than hammering them in the 3 strikes process.
-   Contact conduct@puppet.com to report abuse or appeal violations. This email list goes to Kara Sowles (kara at puppet.com) and Mike Guerchon (503-975-0623 or mikeg at puppet.com). In the case of appeals, we know that mistakes happen, and we’ll work with you to come up with a fair solution if there has been a misunderstanding.

Activity-specific guidelines
-----

-   [Getting technical help](#getting-technical-help)
-   [IRC guidelines](#irc-guidelines)
-   [Mailing list guidelines](#mailing-list-guidelines)
-   [Ask Puppet Q&A site guidelines](#ask-puppet-qa-site-guidelines)
-   [Bug guidelines](#bug-guidelines)
-   [Documentation guidelines](#documentation-guidelines)
-   [Git / source guidelines](#git--source-guidelines)
-   [Forge and module guidelines](#forge--module-guidelines)
-   [Event code of conduct](#event-code-of-conduct)

### Getting technical help

Puppet has a healthy community full of people who are happy to help you get unstuck, but the community works best if you know how it works. If you run into trouble with puppet, these guidelines will make it easier for you to quickly get help.

Puppet has a relatively long history and open development process for an open-source project, so there is a ton of information returned from search engines for various problems. To narrow down your results to the most relevant, try these search tips:

1.  Restrict your search to site:tickets.puppetlabs.com. This disregards the old Trac / reductivelabs wiki and gets you more recent hits.
2.  Join the [puppet-users Google group](https://groups.google.com/group/puppet-users) and use the search box on the group page to search the mailing list. This eliminates duplicate hits from mailing list mirrors like nabble and lets you order results by date so you aren’t confused by a bug that's already fixed.
3.  Use correct Puppet-specific terminology for your problem, like "yum provider", "file resource", and "manifest". For help, see the [glossary of Puppet vocabulary](/references/glossary.html).

In general, we suggest searching the documentation site, or browsing from the [front page of the docs.](/).

We also provide various [commercial services](https://puppet.com/support-services) around Puppet --- including training, professional services, support, and certification --- for people who want a little extra hands-on help.

If you can't solve a problem on your own, there are a lot of places where you can get help from (and help!) your fellow community members. The sections below cover the norms and expectations in each area of the Puppet community.

### IRC/Slack

A great place to get real-time help with Puppet is our IRC channel: #puppet on irc.freenode.net. You can join with your favorite IRC client as well as [Freenode's web client](http://webchat.freenode.net/). There are many helpful people there, in addition to some of the Puppet staff.

Please read and understand this [fantastic guide to getting help for open-source projects on IRC](http://workaround.org/getting-help-on-irc) before diving in. All of the points there apply to #puppet, especially “Don’t repeat yourself”, “Don’t ask to ask”, and “Stick around”. #puppet in particular has heavy concentrations of people in UK (GMT) and West-coast US (PST), so asking your question when those time zones are in business hours is more likely to get a good result.

Be aware that the IRC channel is not an official support channel, it’s an ad-hoc group of people (some of whom work on puppet for a living) self-organizing to help each other out. If you do not receive an answer to your question, (especially if you have not followed the [getting help on IRC best practices](http://workaround.org/getting-help-on-irc)!!), that doesn’t mean you are out of options, the software is hopelessly broken, or your problem is insoluble. It just means you need to keep troubleshooting.

The [Puppet Community Slack](https://puppetcommunity.slack.com) features several channels where users can talk about about Puppet (among other things). For some Puppet events, we'll also create a Slack to help connect attendees. The following guidelines apply to all Slack channels and groups as well as IRC.

Some additional conduct guidelines:

-   Don't be a jerk: Treat people with respect and consideration.
-   Be helpful: Be patient with new people and be willing to jump in to answer questions.
-   Stay calm: The written word is always subject to interpretation, so give people the benefit of the doubt and try not to let emotions get out of control.
-   Don't post chunks: Avoid posting big chunks of text --- use [pastebin](http://pastebin.com/), [gists](https://gist.github.com), or other similar services to shorten it to a link.
-   Be patient: Folks might not be around when you ask a question, so wait a while for someone to speak before leaving.
-   Search first: Believe it or not, your question might not be new or you might be able to find someone who has already asked or answered your question. Do a thorough search of the [IRC log archives](http://www.puppetlogs.com/) to see if it has been answered before.
-   Don't private message: Ask permission before you send someone a private message (PM). Not everyone likes them. Also, by keeping it in public, others with similar issues can see the solution you were given.
-   More information: This [IRC primer](http://irchelp.org/irchelp/ircprimer.html) for new users and the [general IRC guidelines](http://freenode.net/channel_guidelines.shtml), from freenode, are also useful resources.

### Mailing list guidelines

Remember, when you post to a community mailing list, you are, in effect, asking a large group of people to give you some of their time and attention --- to download your message, read it, and potentially reply to it. It is simply polite to make sure your message is relevant to as many of the people receiving the message as possible. Many of the guidelines below stem from this basic principle.

**Puppet community mailing lists**

-   [Puppet-Users](https://groups.google.com/group/puppet-users): For any and all Puppet discussion.
-   [PE-Users](https://groups.google.com/a/puppet.com/forum/#!forum/pe-users): For discussions specific to [Puppet Enterprise](https://puppet.com/product).
-   [Puppet-Dev](https://groups.google.com/group/puppet-dev): For all public discussions related to the development of the Puppet codebase.
-   [Puppet-Razor](https://groups.google.com/group/puppet-razor): For any and all questions about the [Razor](/pe/latest/razor_intro.html) project.
-   [MCollective-Users](https://groups.google.com/forum/#!forum/mcollective-users): For discussions about the [MCollective](/mcollective/) project.
-   [Puppet-Announce](https://groups.google.com/group/puppet-announce) (read-only): A list for announcements related to Puppet, such as major version releases
-   [Puppet-Security](https://groups.google.com/forum/#!forum/puppet-security-announce) (read-only): A list for announcements of security-related releases of Puppet software.
-   [Puppet Bugs](https://groups.google.com/group/puppet-bugs) (read-only): An automated list that gets a copy of all project ticket activity.
-   [Puppet Commit](https://groups.google.com/group/puppet-commit) (read-only): An automated list that gets a copy of all git source code commits.

**Search first**

-   Your question might not be new. Thoroughly search the mailing list archives (linked above) to see if it has been answered before.
-   Repeatedly posting the same questions can waste time for everyone on the list.

**Stay on topic**

-   Review a few posts from our lists before deciding where to post your question (see links to mailing lists above).
-   Recruiters are not permitted to post jobs to our mailing lists. However, if you are an active community member and you are personally hiring more people to work on Puppet, you may post relevant job descriptions.

**Avoid cross-posting**

-   If you have a question, please pick the list that is most relevant to your topic and post the question only on that list.
-   Only important community announcements (such as conferences and new releases) should be posted to multiple lists at the same time. When you post to multiple lists, please specify one list where people should reply with questions, and put the other lists in the blind carbon copy (bcc).

**Keep it short**

Remember that thousands of copies of your message will exist in mailboxes:

-   Keep your messages as short as possible.
-   Avoid excessively long log output. Select only the most relevant lines, or if lots of log output is required, place the log in [pastebin](http://pastebin.com/), [gists](https://gist.github.com), or a similar service and link to it.
-   Don't excessively quote previous messages in the thread. Trim the quoted text down to the most recent or relevant content only.

**Use proper posting style**

-   Please avoid using HTML or rich text: Set your mailer to send only plain text messages to avoid getting caught in our spam filters and avoid irritating people who have disabled these types of formats.
-   Do not “top post”. Use interleaved posting where possible: Bottom, interleaved posting is replying to the relevant parts of the previous correspondence just below the block(s) of sentences. For a comment to another block of sentences of the same quoted text, you should move below that relevant block again. Do not reply below the whole of the quoted text. Also, remove any irrelevant text.
-   Use links: Please provide URLs to articles wherever possible. Avoid cutting and pasting whole articles, especially considering the fact that not everyone may be interested.
-   Don't include large attached files: Instead of including large attachments, please upload your file to a server and post a link to the file from your email message.

**Do not hijack threads**

-   Post new questions or new topics as new threads (new email message). Please do not reply to a random thread with a new question or start an unrelated topic of conversation in an existing thread. This creates confusion and makes it much less likely that you will get a response.

**Subscribers only**

-   Only subscribers can post to our mailing lists. If you would like to contribute to our mailing lists, we think it is only fair that you be a subscriber. Note: If you want to participate only occasionally, you can subscribe to a list and set your email options to digest or no mail and read the web archives when you want to catch up.
-   To reduce spam, we may moderate posts from new mailing list users. If your message doesn’t appear right away, please be patient and give us a little time to respond to the list moderation requests.

**Recipients**

-   Always reply to the mailing list (not the individual) when answering questions. In many cases, one person will post the question and several others will be silently waiting to see the answer on the list. This also helps avoid repeat questions because others can search the mailing list to get answers.
-   Always group-reply to a message. Some of the email recipients might not be subscribed, might have turned off email delivery, or may read list messages with lower priority than messages addressed to them directly. For the same reasons, it is advisable to add relevant people to the recipient list explicitly.

Credit to the [Fedora Mailing List Guidelines](http://fedoraproject.org/wiki/Communicate/MailingListGuidelines) as a starting point under the Creative Commons Attribution-ShareAlike 3.0 Unported license.

### Ask Puppet Q&A site guidelines

The [Ask Puppet](https://ask.puppet.com) site is a place where you can get answers to questions about anything related to Puppet.

Here are a few guidelines:

-   Please search before asking your question to make sure that someone hasn't already answered it.
-   If you ask a question and someone replies with an answer that works for you, please remember to go back to the Ask site and mark that answer as "correct" by clicking the checkmark next to the answer.
-   If you are reading answers to other people's questions, and you find a good answer, vote it up. Likewise, please vote down unhelpful answers so help other people avoid using them.
-   Leave comments on answers if you want to add some additional information, like a helpful tip or advice. You should also leave a comment on answers that didn't work for you, with notes about why it didn't work, to help us all learn from your experience.
-   Ask is a community website. You are encouraged to add relevant tags and make other improvements.
-   You get karma points to encourage people who are being helpful on the site. The site administrator can also remove karma points in the unlikely event that someone tries to abuse the system. :)
-   If you see spam or any inappropriate content, please flag it as offensive to notify our moderators.
-   If you find a bug in the way the Ask site itself works or you want to suggest a feature, you can submit an issue to our [Ask bug tracker](https://tickets.puppetlabs.com/browse/ASK).

### Bug guidelines

You can log bug reports and support tickets for Puppet using our [ticketing system](https://tickets.puppetlabs.com/browse/PUP). In order to cut down on ticket spam, the tracker requires you to register and log in before the “New issue” link appears in the UI.

Here are a few guidelines that apply specifically to our bug tracker:

-   Each bug report is for only one issue. If you find several issues, please separate them into several reports.
-   Search before you file a bug, and try to avoid filing duplicates by taking a look at whether your issue has already been filed before.
-   Don't start debates on topics not directly related to the scope of a specific issue. We have mailing lists and other places for longer discussions.
-   Remove unnecessary lines when quoting other comments.
-   Please double check to make sure that the information you are including is public (not confidential), especially in attached log files or screenshots.

We encourage community members to help us triage bugs, and this is a great way for anyone to get involved without ever writing a line of code. Refer to our [Workflow for Puppet Open-Source Projects][issue_tracker_workflow] document for more details about the process for filing and triaging bugs.

### Documentation guidelines

-   We encourage contributions to our documentation.
-   Our documentation is licensed under a [Creative Commons Attribution-Share Alike 3.0 United States License](http://creativecommons.org/licenses/by-sa/3.0/us/).
-   For suggestions or minor corrections, just email docs@puppet.com.
-   To contribute text or make larger-scale suggestions, see the [instructions for contributing](/contribute.html).
-   If you would like to submit your own content, you can fork the project on [GitHub](http://github.com/puppetlabs/puppet-docs), make changes, and send us a pull request. See the README files in the project for more information about how to generate and view a copy of the website.

### Git / source guidelines

-   If you want to contribute code, start with a discussion on an appropriate mailing list to make sure that what you want to submit is a good idea and architected in a way that will be useful for others.
-   Look at existing pull requests and issues to make sure that you aren’t duplicating effort.
-   Review any existing CONTRIBUTOR.MD files associated with the project.
-   If you are new to git or GitHub, you might find these resources useful: [GitHub help files](http://help.github.com/), [Git cheat sheets](http://help.github.com/git-cheat-sheets/), and [Git Reference documentation](http://gitref.org/).

### Forge / module guidelines

The [Puppet Forge](https://forge.puppet.com/) is a repository of modules, written and contributed by users, and we encourage you to publish your modules on the Forge.

-   Start with the [Publishing Modules](/puppet/latest/reference/modules_publishing.html) document to learn how to publish your modules to the Puppet Forge.
-   See the [Module Fundamentals](/puppet/latest/reference/modules_fundamentals.html) document for how to write and use your own Puppet modules.
-   See the [Installing Modules](/puppet/latest/reference/modules_installing.html) document for how to install pre-built modules from the Puppet Forge.
-   See the [Using Plugins](/guides/plugins_in_modules.html) document for how to arrange plugins (like custom facts and custom resource types) in modules and sync them to agent nodes.

### Event code of conduct

Exhibitors, speakers, sponsors, staff and all other attendees at events organized by Puppet (such as PuppetConf, Puppet Camps, and training classes) or held at Puppet facilities are subject to these community guidelines and code of conduct. We are dedicated to providing a harassment-free experience for everyone, and we do not tolerate harassment of participants in any form.

We ask you to be considerate of others and behave professionally and respectfully to all other participants. Remember that sexual language and imagery is not appropriate for any event venue, including talks. Participants violating these rules may be sanctioned or expelled from the event without a refund at the discretion of the organizers or Puppet staff members.

Harassment includes offensive verbal comments related to gender, gender identity or expression, sexual orientation, disability, physical appearance, body size, race, religion, sexual images in public spaces, real or implied violence, intimidation, oppression, stalking, following, harassing photography or recording, sustained disruption of talks or other events, inappropriate physical contact, and unwelcome sexual attention. Participants asked to stop any harassing behavior are expected to comply immediately.

If a participant engages in harassing behavior, the event organizers may take any action they deem appropriate, including warning the offender or expulsion from the event with no refund. If you are being harassed, notice that someone else is being harassed, or have any other concerns, please contact a member of the event staff immediately.

Event staff will be happy to help participants address concerns. All reports will be treated as confidential. We strongly encourage you to address your issues privately with any of our staff members who are organizing the event. We encourage you to avoid disclosing information about the incident until the staff have had sufficient time in which to address the situation. Please also keep in mind that public shaming can be counter-productive to building a strong community. We do not condone nor participate in such actions.

We value your attendance. If you cannot find a member of the event staff or are not comfortable contacting one of the staff, you can alternatively contact conduct@puppet.com, Kara Sowles (kara at puppet.com) or Mike Guerchon (503-975-0623 or mikeg at puppet.com).

We expect all participants to follow these rules at all event venues and related social events.

### Credits

Credit to [01.org](https://01.org/community/participation-guidelines) and [meego.com](http://wiki.meego.com/Community_guidelines), since they formed the starting point for many of these guidelines.

The Event Code of Conduct is based on the [example policy from the Geek Feminism wiki](http://geekfeminism.wikia.com/wiki/Conference_anti-harassment), created by the Ada Initiative and other volunteers. The [PyCon Code of Conduct](https://github.com/python/pycon-code-of-conduct) also served as inspiration.

### License

These documents belong to the community and are licensed under the Creative Commons. You can help improve them!

<a rel="license" href="http://creativecommons.org/licenses/by-sa/3.0/us/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-sa/3.0/us/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-sa/3.0/us/">Creative Commons Attribution-Share Alike 3.0 United States License</a>.

