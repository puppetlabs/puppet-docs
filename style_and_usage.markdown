Style and Usage Guide
=====================

This guide provides content style guidelines for use by all content creators at Puppet Labs. This guide originated on the Docs team, but folds in style info from Marketing and Education as well. We'll be putting in place a process for contributing style decisions to the guide, and for identifying differences in style across various teams.

##Purpose

* Establish consistency across all Puppet Labs content – As a company, we strive to have consistent voice, structure, terms, format and other style. This consistency makes navigating content and technology easier and more intuitive for users. 
* Establish best practices for delivering the content that helps users solve problems.
* Help bring new writers up to speed quickly, without guess work.

* * *

##Writing for Users New to Puppet and PE

* Be straightforward -- don’t rely on implication. Make direct statements. Use conjunctive adverbs to connect ideas and help to bridge connections: “first,” “second,” “and then,” “next,” “therefore,” “also,” etc.
* Define things. If you’re working with a new feature, explicitly say what it is, and what problems it solves. Similarly, avoid jargon that will make new users feel excluded or frustrated.
* Use the same terms to refer to the same things. For example, if you title a page “Grouping and Classifying Nodes,” use those terms in the contents of the page.  
* Focus on the tasks users need to perform. If you’re writing about a new feature, identify what the user will do with that feature, and provide tasks (see Tasks section) that explicitly step the user through each task. Don’t just tell them what to do, but how to do it.
* Decide what information your users really want and need and provide that first. If you have time, and more information, then add extra pages for a deeper dive.
* Provide breathing space (white space).
* Use headings that quickly convey the content.
* Make content scannable.
* Use examples. A lot of examples.
* Use graphics and screenshots to provide another way of learning a thing.
* Empower the user. Never condescend.  

##Writing for Advanced Users
Today’s junior IT worker is potentially tomorrow’s automation or operations architect. Users who solve problems feel more confident. They’re encouraged to try new things and grow their skills. Our documentation can support users from basic tasks through to the rich, heady high-level concepts that an expert craves and that we have in good supply.

Writing for more advanced users should always be about providing more complex concepts, not complicated or convoluted prose, or complicated organization of content. No user will be upset if you make it easy for them to find the information they’re looking for or tell them how to do things. If they already know how to perform some of the steps, they will skip them.

###Examples
Quick Start: http://docs.puppetlabs.com/pe/latest/quick_writing_windows.html
Facter Overview: http://docs.puppetlabs.com/facter/2.0/fact_overview.html

## Revising Existing Content
Tips for revising content to meet the needs of new users:

* Identify the basic-level stuff that’s missing and write it.
* Provide summaries or overviews if they’re missing.
* Mention prerequisites or concepts a user should be comfortable with before getting started.
* Identify places within existing content that need to be revised and revise them with the above thoughts in mind to be more accessible.
* As appropriate and technologically possible, make content filterable by user, so advanced users can filter out the basic stuff.
* Provide definitions for terms that a new user might not be familiar with or might misunderstand—like “class,” which is different in the Puppet context than in many others. Do this in the earlier pages of a section of content. * Use your judgment about what a new user might or might not know or have seen before getting to this section.
* Glossary. Maybe multiple glossaries.

Link Text and Image Descriptions
-----

The text of a link should always describe the destination of the link; we should never use something like "see here" as the full text of a link.

Relatedly, image tags should always contain alt text that describes the content of the image. (E.g. `![Diagram: four agents connected to a single puppet master](./agent-master.png)`.)

Both of these are mostly for accessibility reasons, but they also help friendly robots like search engines. [This page has more about screen readers](http://www.webcredible.co.uk/user-friendly-resources/web-accessibility/screen-readers.shtml) and how they render web pages.

Version Issues
--------------

Occasionally, like with 2.6, a major version changes the terminology or the
names of various tools and services. After one of these changes, all
documentation not addressing backwards compatibility should use the new names
and terminology exclusively.

Eventually, we may need a more prominent "decoder" document; in the meantime,
the [Tools](./tools.html) reference will do.

Dialect and Spelling
-------

The docs project favors (but never favours) American spellings.

Agent and Master Systems
------------------------

Systems running puppet master should be usually called "puppet master
servers," "puppet master nodes," or "puppet masters." Systems running puppet
agent should usually be called "agent nodes." In general we should avoid using
"server" and "client" alone to describe these roles, because agent nodes
(clients) are almost always servers themselves.

### Node, Agent, Server, Host, System

* Node: Any computer; all other info must be gleaned from context. When using
  this term, you shouldn't expect that it necessarily means agent node.
* System: Synonym for node.
* Agent or agent node: a computer running puppet agent on a regular basis.
* Server: Cannot be assumed to mean puppet master server, since most systems
  running Puppet are servers in some capacity. If you mean puppet master
  server, say so, or just call it the puppet master. By contrast, the `server`
  setting in puppet.conf's `[agent]` block has sufficient context that it's
  obviously referring to the puppet master.
* Host: Since we have a "host" resource type, the term "host" should not be used
  to refer to a computer.

"Puppet"
--------

Here's how to style the word "puppet," depending on how it's being used:

1. When referring to the entire suite/solution, Puppet is a normal proper noun.
2. When referring to an executable tool by name (e.g. "puppet agent"), it is
downcased; the principle here is that when an utterance is both a proper name
and part of an executable statement, we should treat it more like code than like
a name.
    * However, tool names obey sentence case (e.g. "Puppet doc is your new
    friend.") and title case.
3. When the name of a tool is used as an adjectival noun or is referring to a
piece of hardware by synecdoche (e.g. "your puppet master server" or "your
puppet master" or "managing ten puppet agents"), follow rule 2.
4. When the name of a tool is functioning as a _complete_ shell command, style
it as code (e.g. "...and then run `puppet agent`"). Code spans in Markdown are
\`delimited by backticks\`. If you are instructing the reader to run the tool
but have not provided a _complete_ command (e.g. "...after the task completes,
run puppet agent again with the same command line flags."), follow rule 2.
5. Puppet Dashboard is always treated as a normal proper noun in both expanded
and shortened ("Dashboard") forms. This is because Dashboard never gets executed
by a user at the command line, and thus is only a product name and not an
executable statement.

Other Capitalization Questions
------------------------------

The basic rationale to use when capitalizing words is: is this a proper noun?
This turns out to be a squirrely question, but the judgement we went with
during the PE2 launch and have felt pretty okay about since is that PRODUCTS
are proper nouns, but FEATURES are not. That is, "live management" wouldn't be
capitalized, and neither would "faces" -- they aren't independent products. In
fact, we don't even capitalize the console.

This was one of those tricky calls that we might revisit at some point, but
for the time being, I (NF) feel pretty good about erring on the side of not
looking like a bad fantasy novel.

Placeholder Text
----------------

Surround placeholder text with either curly braces or angle brackets, depending
on the context. When possible, try to word placeholder text such that the reader
won't try to enter it verbatim. e.g.:
"Puppet file server URIs are formatted as
`puppet://{server hostname (optional)}/{mount point}/{remainder of path}`."

Quoting Commands and Responses
------------------------------

If you're quoting a shell command inline, context should keep it from being
confusing. If quoting a group of commands and responses as a code block, prefix
the commands with $ or #. For clarity, you can choose to prefix shorter
responses with >, but longer responses are usually visually distinctive enough
to be obvious.

Sudo
----

Per feedback from Product (Nigel), the docs (especially those dealing with PE)
should generally prefix example commands that need superuser privileges with
`sudo`, rather than explaining the privileges needed (too much) or expecting
readers to pick up on the distinction between $ and # (not enough).

Define/Declare
--------------

Use standard verbs to describe the things that can be done to Puppet constructs:

You **define** a class or resource type when you write its implementation. For
defined resource types, this is done with the `define` keyword; for classes,
it's done with `class some::class { ... }`. You could consider the definition of
native resource types to happen in their Ruby type/provider code.

To **declare** a resource or class is to create an instance of the thing that
was previously defined. That is, you define a type, but you declare a resource.
Declaring classes is done with the `class { "some::class": attribute => value,}`
syntax or with the `include` statement.

Attributes, Values, and Parameters
----------------------------------

Resource (and parameterized class) declarations consist of a type, a title, and
a series of **attribute** `=>` **value** pairs.

When defining a resource type or a parameterized class, you specify a list of
**parameters** it accepts (e.g.
`define gitrepo($giturl, $path = $title, $branches = [master]) { ... }`).

Thus, parameters are relevant to the implementation, and attributes are relevant
to the interface.

Troubleshooting Doc Guidelines
-----

Documents meant to help troubleshoot problems should follow these principles:

* Be action-oriented
* If users can pick and choose from a number of options, use bulleted lists.
  If users should do EVERY step in a series, use numbered lists. The latter
  should be more common.
* Steps should be accompanied by actual copy-and-pasteable commands that test
  whatever the step asks you to check.

Markup
-----

Documents in this repo are in Markdown format with several extensions.

* Each file should begin with YAML frontmatter, per Jekyll's requirements. See
  any file for an example.
* The Markdown processor we use (Kramdown) supports the definition list and
  table markup extensions from PHP Markdown Extra. The docs use these in various
  places.
* We also use several Jekyll-specific Liquid tags. If we ever switch backends,
  the behavior of these will have to be re-implemented. The tags we're using
  include:
    * {% include <file name relative to the _includes directory> %} --- Insert
      a snippet from the `_includes` directory. If you're including into body
      text, the snippet can contain Markdown and what-have-you, but if you're
      including directly into a template, it must be mostly normal HTML
      (although it can contain more Liquid tags).
    * {% highlight <language> %}... some code ...{% endhighlight %} --- This
      uses the `pygmentize` command to color up code examples. See `pygmentize
      -L lexers` to see a list of what's allowed. Note that this automatically
      puts everything within into a `<pre><code>` block, so indenting it is
      superfluous, but as long as the language is something like ruby where
      indentation is non-semantic, indenting reduntantly can make your text
      editor's Markdown highlighting behave better, especially if the example is
      full of underscores or something. To highlight Puppet code, use {%
      highlight ruby %}. There's a Puppet lexer available, but it doesn't ship
      with pygments by default, and much of our puppet code actually blows it
      up, so we should turn it on in a dev branch at some point and submit bug
      requests. <https://github.com/rodjek/puppet-pygments-lexer/>
    * {% capture <name> %} ... {% endcapture %} --- Capture some text so you
      can render it elsewhere in the page with {{ <name> }}.
    * {% iflink "Link text", "/link/destination.html" %} --- Custom to our
      site. Renders a normal link, unless it would point to the current page, in
      which case it renders `<span class="currentpage">Link text</span>`.
    * `{% render_nav %}` --- If the YAML frontmatter specifies a filename in
      its "nav" key, this tag renders that file, which it will find in the
      `_includes` directory. Otherwise it renders the default nav snippet from
      `_config.yml`. This should really only be called from templates.

There is also at least one case where we abuse Markdown:

* Asides in an article should be styled as Markdown blockquotes. We should
  properly be using <aside> elements, but:

    * It's really convenient to make a Markdown blockquote.
    * We don't use blockquotes for actual QUOTES anywhere in the docs, which
      effectively makes it an abandoned element.
    * The Markdown spec, such as it is, says processors should ignore any
      further Markdown formatting inside an explicit HTML block element (like
      `<aside>`), so using the proper tag would entail spewing raw HTML around our
      documents. This can be turned off in some processors, but we would
      prefer to not rely that heavily on implementation details; plus turning it
      on might wreck something else.

Console UI Terminology
-----

This is the current most-canonical list of the words we have for parts of the console UI, as of January 12, 2012's meeting with Randall. Nick F modified the LM stuff in June 2013 with some limited input from UX.

 - The bar at the very top is the MAIN NAVIGATION or PRIMARY NAVIGATION.
      - Clicking on an element in the main navigation takes you to a SECTION of the console. This word is vague and unconcrete because the divisions between the sections are vague and unconcrete.

 - The sidebar is the SIDEBAR. It contains:
      - the NODE STATE SUMMARY. Clicking a state takes you to the NODE LIST (changed node list, failed node list, etc.).
      - the GROUP SUMMARY. Clicking a group takes you to that group's PAGE.
      - the CLASS SUMMARY. Clicking a class takes you to that class's PAGE.

 - From the nodes section, or any other list of nodes, you can get to a node's DETAIL PAGE. Likewise for any class, group, or report; each individual object has its own DETAIL PAGE.
      - A report detail page contains TABS that show different parts of the report.
 - The landing page of the reports section is the REPORTS LIST. You can refer to the inventory search section as a section, a page, or just the inventory search. Likewise for the file search.
 - The live management SECTION or PAGE contains three TABS and a FILTERABLE NODE LIST (or just NODE LIST) in the SIDEBAR.
      - The Browse Resources tab contains a RESOURCE TYPE NAVIGATION for switching between RESOURCE TYPE PAGES.
          - Resource type pages contain a search field, a "Find Resources" button, and a LIST OF RESOURCES, any of which can be clicked to reach their RESOURCE DETAIL PAGE. (These can be referred to by type: "package detail page.")
      - The Advanced Tasks tab contains a TASK NAVIGATION on the left side for switching between several ACTION LISTS. Each action list is just an MCollective agent plugin.
          - Action lists contain ACTIONS. We can also call these TASKS, but "actions" is more harmonious with the command line orchestration terminology, which cannot be changed.
              - When you click an action, it reveals a RED "RUN" BUTTON and any available ARGUMENT FIELDS.
      - The Control Puppet tab consists of a single ACTION LIST.
