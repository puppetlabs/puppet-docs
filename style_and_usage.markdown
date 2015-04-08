Style and Usage Guide
=====================

This guide provides content style guidelines for use by all content creators at Puppet Labs. This guide originated on the Docs team, but folds in style info from Marketing and Education as well. We'll be putting in place a process for contributing style decisions to the guide, and for identifying differences in style across various teams.

##Purpose

* Establish consistency across all Puppet Labs content – As a company, we strive to have consistent voice, structure, terms, format and other style. This consistency makes navigating content and technology easier and more intuitive for users. 
* Establish best practices for delivering the content that helps users solve problems.
* Help bring new writers up to speed quickly, without guess work.

* * *

Writing for Our Audience
----
As our user community grows, all content at Puppet Labs needs to shift to accommodate users who have less familiarity with config management, Puppet or Puppet Enterprise. 

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

Tone
-----

The following list is an attempt to capture our tone.

* Strive to be friendly and authoritative. 
* In addition to being friendly, be concise, but not terse. 
* Make content scannable, but not to the point of skeletal. 
* Use present tense just about always.
* Avoid passive voice, just about always. 

No: The use of execs in your puppet manifests is not recommended.
Yes: We recommend against the use of execs in your puppet manifests.

Passive constructions are not more "formal" or "official" than active ones, and they don't suggest a culture of responsibility or ownership.

* Use 2nd person just about always. 
* Use “we” when you mean Puppet Labs. As in, “we recommend that you test Razor in a completely isolated environment.” Avoid we in steps. You or implied you, as in imperative voice, makes it clearer that the user should do something.
* In cases where you must refer to users, use the terms “people” or “person” instead of “users” or “user” -- it’s friendlier. 

##Inclusive Language

Use gender-neutral, inclusive language. As a base guide, here are some  recommended guidelines from Sarah Lawrence College that mesh well with our preferred voice. 

* As mentioned, use second person (you, your, yours), where possible and appropriate. Second person not only eliminates gender reference, but also makes the copy more personal and engaging.

* Where second person is inappropriate or impractical—in a policy statement, for example—first try to rework the copy to eliminate singular gendered pronouns (he, she, him, her). Remove them altogether, use plural nouns and pronouns, or employ articles (a, an, the). Use non-gendered nouns as needed (student, person, individual, one), but try to do so sparingly to avoid excessive repetition and cumbersome structure. For example: 

	“By default, these CSRs must be manually signed by an admin user, using either the puppet cert command or the ‘node requests’ page of the Puppet Enterprise console.”

* When absolutely unavoidable, use plural non-gendered pronouns (they, them, their) to replace singular gendered pronouns (he, she, him, her).
	
	Tip 1: Avoid conditional sentences introduced by if or when, which often require the use of pronouns: “When we ran this, the resources weren’t synced in the order we wrote them.”

* Avoid sexist assumptions such as those found in turns of phrase like "simple enough for your Aunt Tillie to understand." or "the guys in the server room" when referring to sysadmins in general. 

	It goes without saying: We respect our subjects' preferred gender identities.
	As a general note, think very carefully about the words and metaphors you use and what they might mean to different people. If something strikes you as potentially problematic, it probably is. If someone suggests to you that a particular word or turn of phrase might be offensive or hurtful, resist the urge to defend your choice on the basis of your good intentions, and instead think of another way to put it. 

* Metaphors or analogies: can be tough to localize. Don’t feel like you can’t use them if it will help to illustrate a concept, but stick to comparisons that are relatively innocuous and universal.

* Avoid terms that set a superior or patronizing tone, such as “clearly,” or “obviously.” This site does a nice job of explaining why: http://css-tricks.com/words-avoid-educational-writing/. 

* Be honest, but don't be negative about our products or about competitors.

Headings
----
Headings are a major way that users find what they’re looking for. Good headings quickly introduce the subject of the content that follows, and help users decide at a glance if the content they’re looking for is contained in that section.

Following some basic rules for headings will improve consistency, and users of the docs will get used to seeing things like certain types of headings indicating certain types of content. This will further enhance their ability to quickly find the information they need.

###Guidelines

* Use H1 for page titles only.
* Use H2-H4 heading levels to structure the content on your page. Make sure that the lower-level headings are grouped appropriately under high-level headings. This helps to indicate the relationship between sections of content.

	For example:
		H1 Title
  			H2
     			H3
     			H3
 			H2
     			H3

* If you are using Headings smaller than H4, this is a signal that your document structure might be getting a bit too elaborate. In cases like this, consider splitting out content into more than one page and consider also whether you are overdoing the headings.
* Make sure titles and headings are detailed enough to convey the point of a section.
Spell out Puppet Enterprise in H1s and 2s. This is especially important for H1s (page titles), and H2s. Can be a judgement call in H3 and below.
* Page titles: For intro and concept heavy pages, use a descriptive noun phrase, such as * Beginner’s Guide to Modules, About Puppet Enterprise, Bare Metal Provisioning with Razor. If the page is about describing and providing steps in a process, make it a gerund, such as Installing Puppet Enterprise or Tuning and Scaling
* **Task headings**: Start with an Imperative that signals that the content tells how to do something. For example, Classify a Node. Include Repos.
* **Concepts and overview content**: Use a descriptive noun phrase.
* In general, use title capitalization for headers, in particular, for H1s-H3s. If you are using a sentence or a question as a header, as in an FAQ, and particularly for lower level headings, you might find that sentence-style capitalization makes the most sense. This can be a judgement call, but particularly for the Docs site, we should default to title capitalization in most cases. 
* Only H2 and H3 appear in the TOC -- keep that in mind.

Content Types
----
A page of documentation generally includes several content types -- Intro or overview content, perhaps a process overview, then a handful of tasks. There are some that you would not likely combine, like language reference and tasks. The recommended length of pages is something we're still considering and that might change when we move to a new toolset.

Some guidelines around content types:

* Separate different types of content. If a page contains both concepts and steps to do something, for example, separate concepts from numbered steps sections. Don’t work in the concepts about the thing with the steps to complete a task with the thing.
* Show how to do things (anticipate and answer questions, solve problems). Don’t give a tour of the UI.
* If there are several ways to do something, choose the most common way and write that. You might need to get some insight on the most common way from your team, user research, etc. Users are in a hurry. They want us to guide them. If there are multiple ways, provide the way that’s most direct and expect some users to extrapolate a route at the thing from a different point of entry. 

	If for some reason it is important to describe more than one approach, then do so in a way that will be easily parsed by the user. For example, if there are several different steps in each way, then have two separate sets of steps. Don’t try to cram both in one set of steps. If just one step is a little different, though, you can provide that alternative in the same step with the main approach.

###Types of Content

* Intro/Overview content
* Concepts
* Tasks
	* single step task
	* multi-step task
	* multi-task process
* Reference
	* Language reference
	* APIs
* FAQ/Decision/Troubleshooting

####Introductions
Products, features, tools, libraries, etc. have their own sections in the documentation and need an introduction. An introduction might be the user’s first encounter with Puppet Labs documentation, so it should be welcoming (see Tone).  Each page of documentation should also have an introduction. The introduction might take up an entire page (if it's an introduction to a set of pages) or might be just a short paragraph. 

**Heading**: Descriptive noun phrase, such as Beginner’s Guide to Modules, About Puppet Enterprise, Bare Metal Provisioning with Razor.
Recommended elements for introductions:

* A greeting.
	
	For example:
	“Welcome! This is the user’s guide for Puppet Enterprise 3.2.0.”
	
	Don’t overdo it with the welcome -- a message like this works best on the top-level pages for products or features, but might sound a little weird and forced further in (i.e., don’t say,  “Welcome to ‘Navigating the Console.’”).
* Name and quick description or definition of the the application or feature that the section is about -- what it does, its purpose, etc.
* Assumptions that the section is working with.
* What the section or page of documentation will cover.
* Links to related pages of documentation.
	* Link text should be the title of the page, which will indicate what info that page contains.
* Optional: as appropriate, you can segue into concepts or process overviews from intro sections. These two are generally appropriate for section introductions rather than product introductions.   

####Concepts
These sections can be a natural extension of the introduction and go deeper into the feature or product. Consider the questions that a user might have and answer them here.

Concept sections cover things like:

* The purpose of the product or feature
* What problems it helps you solve
* How it helps you solve problems
* High-level information about how you do a thing with the feature, tool, product, etc.
* What’s going on behind the scenes or decisions that were made when the feature was designed that improve the user experience

Be judicious about that last bullet point in particular -- you likely know much more about the thing you’re documenting than the user needs to learn, and you don’t need to share all the info just because you have it. Consider what questions a user might have and address those.

**Concept Headings**:  Can be noun phrases like for introductions.

####Tasks
Tasks provide steps for how to do something. You might call it a procedure or how-to, but it tells you how to accomplish a goal. Besides reference, this is the information that users are looking for most, often in times of frustration or distress, so task sections need to be as direct, easy to find, easy to read, and efficient as possible.

Describe first what user will accomplish, and then how. This guideline applies to both introductions to tasks, and to steps that include the purpose or outcome of the step. For example,

Not this:
“Kick off a puppet run with live management to actually create the new repo with the agent packages.”

But this instead:
“To create a new repo containing the agent packages, use live management to kick off a puppet run.”

Not just what to do, but also how to do it. New users, even advanced sys admins or architects, aren’t necessarily familiar with our applications. No one is going to get mad if you give them too much information. They will, however, be frustrated if you provide too little. And if they can’t find what they need in the docs, where are they going to find it?

#####Types of Tasks

Depending on the users your content is targeting, tasks might be one of two types:

* **Prescriptive** tasks teach how to do a thing a specific way, like those found in the PE Quick Start Guides. Prescriptive tasks are most helpful in introductory content for new users, or for situations like installing components, where there are specific choices that should be made depending on the install. 
* **Recipe-style** tasks teach a process in a more general way, with the understanding that the user will have to make decisions based on their own particular IT and Puppet or PE infrastructures. The Beginner’s Guide to Modules provides a good example of recipe-style tasks.
* 
#####When to Use Tasks
 
Create tasks for anything users do with the software. Installing and configuring software and features should be presented in tasks (often multiple tasks that make up a process). Any work performed with the applications should be presented in tasks. What are users trying to get done? What are users struggling to get done? What are their pain points and how does the software address those? These are tasks. It’s imperative that we provide steps that are easy to find, easy to read, easy to scan.

#####Elements of Tasks

Heading: Imperative that signals that the content tells how to do something. For example, Classifying a Node, or Classify a Node. Including Repos, or Include Repos

Brief intro: Provide some introductory information that’s pertinent to the task, such as:

* A little information that describes what the task accomplishes. This can help users confirm that these are the steps they want to perform, and when they finish, they know what they should see.
* A little information about what you need to have done before you can do this specific task, or context setting -- why you do this, or why you do it the way it's described. For example, a few Razor tasks included creating a .json file that you could use to store several lines of code when creating an object.
* If there are multiple ways to do something, you might mention why you chose the approach you chose (but be judicious -- don't feel like you have to say "these steps show you how to do this thing on the console, but you can also do that from the CLI" because you'd have to say that about so many things it would become useless.)

	**Note**: By design,troubleshooting sections present more than one way of doing something. That’s okay!

Only use this section if there's important information to impart. If there's not, you can skip it. If you are just going to be repeating what the heading says, don’t provide an intro section, just go straight to the steps.

Numbered steps: Provide instructions for each step in the task. Keep in mind that when people are following these steps, they're likely looking away and back to the content because they're performing the steps in another window or screen.

Steps should have these characteristics:

* Be relatively short.
* Use plenty of white space.
* Start with where you do the thing, then say what you do: On the console sidebar, click Add Class.
* Bold UI elements, use back ticks to format code, and use quotes to indicate text users should type (except for code), so users can easily find their place and the thing they are supposed to click, type, etc.
* Use the console if you're writing PE steps.
* Be written in imperative voice - type this, click that.
* Optional: include screenshots, sample code blocks, or graphics if there's something that can help to make the step clearer.
* Split a task if it’s getting super long. Find a way to break it up -- the most natural break possible.

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
