---
layout: default
title: Contribute
---

We welcome community contributions to the documentation! You can help by reporting errors and typos, or by contributing new or updated sections. This topic describes the three main ways to contribute to the docs, and provides guidance on writing good documentation.

* * *

## Three ways to improve the Puppet documentation

### Filing a ticket

The Puppet documentation is managed like a software project, and you can file bug reports and feature requests in its
[issue tracker](https://tickets.puppetlabs.com/browse/DOCUMENT). You'll need to create a [JIRA account](https://tickets.puppetlabs.com/secure/Signup!default.jspa) if you don't already have one.

In your ticket, provide as much information as possible about what's missing, what's inaccurate, or what's outdated. Include URLs to the affected pages. Describe your best understanding of what the documentation _should_ say. We'll begin looking into the problem, and you can follow our progress in the ticket.

### Emailing us

If you spot a typo or other minor error and don't want to go through the overhead of filing a ticket or editing the documentation, you can report it by email to <docs@puppetlabs.com>.

### Sending a Github pull request

If there's a hole in the documentation and you know just what needs to be added, and if you're [familiar with Github](http://learn.github.com/), you can contribute directly to our open source project. Use your [GitHub](http://github.com) account to fork the [puppet-docs](http://github.com/puppetlabs/puppet-docs) repository, make your changes, and submit a pull request. To reduce editing churn and have your PR quickly accepted, follow the Puppet documentation style guidelines, below.

Documentation source files for certain Puppet-related components, such as Puppet language reference, MCollective, and PuppetDB, are kept in other repositories. See the [Contributing ReadMe](https://github.com/puppetlabs/puppet-docs/blob/master/CONTRIBUTING.md) for details.

## Puppet documentation style guidelines

### Source files

Puppet documentation is written in [Markdown format](https://daringfireball.net/projects/markdown/syntax), and stored in the `source` directory of the [puppet-docs](http://github.com/puppetlabs/puppet-docs) Github repository. Our build converts it to HTML and publishes it to <https://docs.puppetlabs.com/puppet/>. 

Each documentation `.markdown` or `.md` file starts with a (non-Markdown) header section, where you provide the topic title:

```
---
layout: default
title: My topic title
---
```

### Writing new topics from scratch

Each topic file should cover a single subject area. If the Puppet docs already have topics that discuss this area, modify those existing topics rather than creating a new one.

If you're writing a new topic, start with an overview:
- Provide definitions and descriptions that introduce the subject and place it within the context of the rest of Puppet.
- Provide diagrams if they help clarify relationships and structures. 
- Your goal is to help users solve problems and get things done. Avoid too much background information.

Next, describe things that the user *does*:
- Create a section for each major task users do. 
- List prerequisites, if any. 
- Use a numbered list to list the actions the user does to accomplish the task. 
- Finish by stating what the outcome is, and what the user might do next. 
- Provide code or command examples that show what to do for common scenarios.
- If there are multiple ways of doing something, describe only one: the most straight-forward way for the given context. 
- Use screen captures minimally (ideally not at all), and only to illustrate things that are otherwise impractical to describe. 
- Avoid mixing lengthy conceptual descriptions in with task steps. Put those in your overview section instead.

For reference information for a command line tool or an API, follow the layout patterns in similar existing Puppet documentation. If this is lengthy, split it into its own Markdown file.

Provide links to related Puppet documentation topics, or other resources.

### Updating existing documentation topics

Sometimes our docs are missing useful information that you can provide:
- basic-level concepts the original author took for granted, but are helpful for new users
- missing overviews, steps, or links
- missing prerequisites for tasks
- clarifying definitions for terms that Puppet is using differently than other technologies (for example, "class")
- helpful code or command line examples
- troubleshooting tips

### Tone

### Grammar, idiom, and spelling

### Headings

### Formatting

