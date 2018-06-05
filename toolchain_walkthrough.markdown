[Markdown]: http://daringfireball.net/projects/markdown
[YARD]: http://yardoc.org
[kramdown]: http://kramdown.rubyforge.org
[Puppet contribution guidelines]: https://github.com/puppetlabs/puppet/blob/master/CONTRIBUTING.md
[Jekyll]: https://github.com/mojombo/jekyll
[Liquid wiki]: https://github.com/Shopify/liquid/wiki

# The Puppet docs toolchain

_... wherein we discuss the innards of docs.puppet.com_

> **Note:** This README describes a previous documentation publishing workflow to static HTML content served on https://docs.puppet.com. Docs are now published to the puppet.com Drupal CMS instance at https://puppet.com/docs/, which imports bare HTML output and renders it.

## Elevator pitch

The Puppet docs site was a collection of static HTML files generated from [Markdown][] source files and from Puppet itself. When we talk about the toolchain, we're talking about the collection of tools and services in use to generate the site then deploy it to the web servers for docs.puppet.com. Among the things the toolchain provides:

-   HTML for the Puppet docs site
-   References generated from inline documentation in Puppet's source code

## Initial setup

[The instructions on GitHub](https://github.com/puppetlabs/puppet-docs/blob/master/README.markdown) explain how to get a functioning docs toolchain in place.

## Tools and Services

### Git and GitHub

The Puppet docs repository lives on GitHub:

<https://github.com/puppetlabs/puppet-docs>

#### Git workflow

For working with the puppet-docs repository from day to day:

-   Fork puppetlabs/puppet-docs

-   Clone your fork to your machine ("set up a local remote"):

    `git clone git@github.com:#{your_github_username}/puppet-docs.git`

-   Designate puppetlabs/puppet-docs as your git upstream:

    `git remote add upstream git@github.com:puppetlabs/puppet-docs.git`

-   Make changes from a branch on your local:

    `git checkout -b name_of_topic_branch`

-   Update your local master before merging your branch changes:

    `git pull upstream master`

-   Merge your topic branch to your local master:

    `git merge name_of_topic_branch`

-   Push from master to master:

    `git push upstream master`

If you have a very small change to make, update your master branch (`git pull upstream master`), make your change, then push it (`git push upstream master`).

> **Note:** Some content on https://puppet.com/docs is not generated from these Markdown docs. If an expected change doesn't appear on https://puppet.com/docs within 24 hours, file a [DOCUMENT ticket](https://tickets.puppetlabs.com/DOCUMENT) with a link to the page and and a link to the commits containing the desired changes, so a Puppet technical writer can follow up.

### Jekyll

[Jekyll][] is a static site generator. It takes a directory full of files written in HTML or Markdown and generates a site of static HTML. If you're used to dealing with a content management system such as WordPress or Drupal elsewhere, these things are worth knowing:

-   Jekyll doesn't allow you to edit content on a live site. You edit Markdown files, save them, then regenerate the entire site.
-   Jekyll has to regenerate the entire site every time it's generated. That includes all the navigation elements and pages.
-   Jekyll _does not use_ the remote GitHub repository to generate the site. It uses what's in the git branch you're working on. You should generally use the [git workflow](#git-workflow) outlined above to make sure you're not generating a site with bits that aren't ready for primetime.

##### What do I need to know about this?

**Day-to-day:** Not much:

-   See the section on [generating the site](#generating) to learn how to generate the docs site.
-   See the section on [navigation and templating](#navigation-and-templating) if you need to change a section's navigation or templating.

**Toolsmiths:** We're currently carrying patches on Jekyll in order to get it to:

-   use symlinked pages and directories (the upstream Jekyll maintainer has security concerns about allowing symlinks)
-   process files/directories with a leading "\_" (because Jekyll's filename convention uses "\_" for config files and other unprocessables)

We keep our fork of Jekyll in a Puppet-owned GitHub repository:

<https://github.com/puppetlabs/jekyll>

Our bundler Gemfile references that fork of Jekyll and builds the jekyll gem from the `puppetdocs` branch.

#### Bundler

Bundler is a tool that allows you to make sure you've got all the Ruby gems you need to successfully build the docs site. You'll use it once when you're setting up your toolchain, then occasionally as the toolchain is updated. It shouldn't come up much.

##### What do I need to know about this?

**Day-to-day:** Sometimes you'll try to run a rake task to build the site and get an error because the bundler Gemfile has been updated. Just run `bundle update` and that should straighten it out.

**Toolsmiths:** Bundler was introduced to get a handle on loadpath problems. Now we use it as a one-stop way to get most gem dependencies onto a new system with a single command. We also use it to build a gem from our forked version of Jekyll (See [above][#jekyll]).

#### Pygments

Jekyll uses the Pygments application to provide syntax highlighting. Pygments parses HTML `<code>` blocks and applies CSS to them. Pygments does a good job, but it's slow.

##### What do I need to know about this?

**Day-to-day:** Not much. You should have installed Pygments as part of your initial toolchain setup.

**Toolsmiths:** We recently added a Jekyll plugin that caches Pygments HTML output, dramatically speeding up the toolchain build times. See `source/_plugins/pygments_cache.rb`.

#### kramdown

The Puppet docs site is written in Markdown. In order to get advanced HTML features, such as tables, we use the [kramdown][] Markdown interpreter. Kramdown understands vanilla Markdown (which is limited to a very few tags) along with a large set of additional markup conventions. kramdown is provided via a Ruby gem, which is installed during toolchain setup via the rubygems [bundler](#bundler).

##### What do I need to know about this?

**Day-to-day:** Not much.

**Toolsmiths:** kramdown provides a superset of vanilla Markdown. If you ever decide to change Markdown parsers, you'll need to make sure the new parser supports kramdown's features. We are most dependent on its ability to generate tables, but there are also cases in the Puppet docs where we use footnotes. Neither of these features are native to vanilla Markdown.

kramdown also treats markup inside HTML block-level elements differently from vanilla Markdown.

#### Liquid templating

Jekyll uses Liquid to provide a limited amount of relatively safe in-line logic for templates.

##### What do I need to know about this?

**Day-to-day:** Not much.

**Toolsmiths:** Liquid usually comes up in the context of providing conditional logic for inclusion/exclusion of certain page elements depending on the Puppet version they apply to. For instance, take a look at `source/_includes/references_general.html`, which includes the following Liquid markup:

	{% capture version %}{% reference_version %}{% endcapture %}
	...
	 {% unless version < "3.1" %}
		 <li>{% iflink "Developer Documentation", "./developer/index.html" %}</li>
	{% endunless %}

which uses a Liquid plugin found in `source/_plugins/reference_version.rb` to discern which version of the Puppet references a page is displaying and toggles the display of a link to the developer YARD docs, which were not available prior to Puppet 3.1.

See the [Liquid wiki][] for a complete reference to Liquid functions (Liquid for Designers) and extensions (Liquid for Developers).

#### YARD

> **Note:** Puppet no longer publishes YARD output for current versions of Puppet to puppet.com/docs or docs.puppet.com. For details on generating this developer documentation on your own, see <https://puppet.com/docs/puppet/latest/yard/index.html>.

Among YARD's featues:

-   Simple templating that allows developers to include and display useful metadata, such as whether a function is part of the public API
-   Markdown support
-   The ability to provide a simple desktop documentation webserver with nothing more than a local copy of the Puppet repo

##### What do I need to know about this?

**Day-to-day:** You should generate YARD documentation each time a new patch release of Puppet is made. See the section on [generated references](#generated-references) below.

**Toolsmiths:** There's room for improvement in the YARD templating, but that should be coordinated with the platform team's developers since YARD templating has to pull double duty, both for output on a desktop docs webserver and as part of the generated references.

#### Puppet documentation

> **Note:** The content generated by `puppet doc` is being supplanted by the use of [Puppet Strings](https://github.com/puppetlabs/puppet-strings), but is still used for most of the generated reference documentation.

Much Puppet code includes what are referred to as "doc strings," generally brief inline documentation made available via the `puppet doc` command. The Puppet docs site keeps a copy of Puppet's `puppet doc` output. The latest version is linked in the sidebar of the Puppet reference manual:

<http://docs.puppetlabs.com/puppet/latest>

##### Editing Puppet docs

To modify Puppet documentation, you need to:

1.  Read the [Puppet contribution guidelines][], even if you're a Puppet employee
2.  Fork the puppet repo
3.  Make your changes in a topic branch
4.  Submit a pull request

##### Revising past versions of Puppet docs

Since we keep generated references for every patch release of Puppet, there will be times when you need to make a change to legacy generated references. Consult with developers on this, since you can't always be sure under which point or patch release a change was introduced. Generally speaking, making a change to the last patch release in a series (e.g. 2.7.21) is all that's required, since that in turn will be presented as the latest, canonical version of a given document.

##### What do I need to know about this?

**Day-to-day:** You should generate Puppet references each time a new patch release of Puppet is made. See the section on [generated references](#generated-references) below.

> **WARNING:** Do not regenerate references for older versions of these documents: Sometimes changes are made to the existing versions, and regenerating them will overwrite these changes.

**Toolsmiths:** Puppet documentation can be crabby. Here are some things to look out for:

-   Clean loadpath: You should never have Puppet installed from Puppet provided packages on a system that's generating documents unless you've got a sound plan for isolating the version of Ruby you're using to generate the docs from system Ruby libraries (e.g. rbenv or rvm).
-   ActiveRecord: A few parts of Puppet have declared dependencies on ActiveRecord but do not actually use it and will not raise an error if ActiveRecord isn't present (Puppet 3 or later). If generated reference pages come up blank, doublecheck for ActiveRecord.

### Apache and Puppet

> **Note:** This section refers only to content on docs.puppet.com, which is no longer regularly updated. Today, publishing to Drupal-powered puppet.com is handled by an internal import pipeline.

Eventually, once the site is deployed to the servers, it's served by Apache, although it could be served by more or less anything.

In production, the Apache virtual host file is managed by a Puppet module in a private Puppet repo.

## Working With the Toolchain

#### Where do things live in the filesystem?

The content for the docs site lives in the `_source` directory of the puppet-docs repo:

> **Note:** This tree is not regularly updated and might not reflect the accurate state of the repository.

    .
    ├── README.txt
    ├── _cache (pygments cache, unversioned and ignored, leave alone for fast site builds)
    ├── _config.yml (a number of mappings for sidebar menus plus basic config are here)
    ├── _includes (look for sidebar menu items here)
    ├── _layouts
    │   ├── default.html
    │   ├── frontpage.html
    │   └── legacy.html (provides a ToC in the right sidebar)
    ├── _plugins (Jekyll plugins)
    ├── community
    ├── config.ru (configuration for preview server run from `rake preview`)
    ├── contribute.markdown
    ├── dashboard
    ├── facter
    ├── files
    │   ├── errors
    │   │   ├── general_404.html (custom 404 page: this will have to change when templates change)
    │   │   └── versioned_404.html (special 404 page to help users navigate mismatch of docs between versions)
    │   ├── fonts
    │   ├── javascripts
    │   └── stylesheets
    ├── guides
    ├── hiera
    ├── images
    ├── learning
    ├── man
    ├── module_cheat_sheet.html
    ├── module_cheat_sheet.pdf
    ├── output (directory where Jekyll keeps HTML output before deploy)
    ├── pe
    ├── puppet
    ├── puppet_baseline
    ├── puppet_core_types_cheatsheet.pdf
    ├── puppetdb
    ├── references (generated references, you will not usually want to edit these)
    ├── release_notes (central location for release notes links)
    │   ├── development_code_names.markdown
    │   └── index.markdown
    └── windows

### Generating the docs

Generating the Puppet docs site using the Rakefile in the top of the docs repo.

#### The core site

__Rake command:__ `rake generate`

If all you need to do is regenerate the docs site to reflect changes you've made:

```
$ cd puppet-docs
$ rake generate
$ rake serve
```

Visit `http://localhost:9292` to review your changes.

> **Note:** Some Puppet subprojects keep their own copies of their documentation. These projects are automatically checked out when the documentation is generated and no user intervention is required.

##### What do I need to know about this?

**Day-to-day:**

-   Sometimes `rake` will fail with an error referencing "bundler." Run `bundle update` in your puppet-docs directory and that should sort it out.
-   Sometimes, early in the build process, you'll see errors related to mcollective or PuppetDB being in a detached HEAD state. Feel free to ignore those.

**Toolsmith:**

Look at the `:generate` task in the Rakefile. For the mcollective and PuppetDB docs generation, check the `externalsources` namespace in the Rakefile. For configuration of the external sources, see `config.yml` at the top of the puppet-docs repo.

#### Generated References/YARD Docs

__Rake command:__ `rake references`

The generated references and YARD docs are produced from inline documentation in Puppet. You need to regenerate these with each patch release of Puppet. Once the references are generated, the new files will need to be added to the repo and committed. The new files are located under `_source/references`.

> **WARNING:** Sometimes we have to go correct existing generated references. Regenerating older references will overwrite those corrections.

## Navigation, templating, pages

> **Note:** The content published to puppet.com/docs does not use the templates described here.

### Templates

The templates Jekyll uses to generate the site live in `_source/layouts`. They include:

-   **frontpage.html** for the front page of the docs site
-   **default.html** which provides for a generated table of contents at the top of the page and a left-side navigation menu
-   **legacy.html** which provides for a generated table of contents as a right-side menu

CSS and JavaScript for the templates lives in `source/files/stylesheets` and `source/files/javascripts` respectively.

In addition to the basic templates, there are also two error pages in the `source/files/errors` directory:

-   **general_404.html**, a 404 page with links to commonly sought items across the docs site
- *  *versioned_404.html**, a 404 page that helps users find their way to current versions of older docs

### Navigation

The HTML for navigation elements that appear in the sidebars/rails on individual pages lives in `source/_includes`. Menus are assigned to a given page using a Liquid function called from the template files (`source/_plugins/render_nav.rb`) and configured in the `_config.yml` file found on the top level of the puppet-docs repo.

So, for pages using the default layout, to add a new navigation menu to the left rail, edit the `defaultnav` hash in `_config.yml` to map the files under a given directory to an HTML file you've placed in `source/_includes`.

### Pages

Jekyll expects each page to include YAML frontmatter. It should, at a minimum, include a `layout` and `title` value, e.g.

```yaml
---
layout: default
title: "Hiera 1: Command Line Usage"
---
```

In addition, you can include a few other values in the frontmatter:

-   `canonical`
-   `description`
-   `toc`
-   `subtitle`
-   `munge_header_ids`
-   `nav`
-   `version_note`

**Canonical:** Designates the canonical version of a given page. We use this to generate a canonical link that guides search engines to the most current, most relevant version of a given page. Testing has shown that this is very effective for consolidating search traffic on the most recent version of a given document. Format the canonical value as an absolute path from the docroot:

```yaml
canonical: "/puppetdb/1.1/configure.html"
```

**Description:** Designates a description meta tag for a given page. The description is used by search engines to generate a preview snippet in results pages, so this should not typically exceed 150 characters. Format this as a string:

```yaml
description: "The hiera command line tool is useful for previewing and validating your hierarchy before putting it into production."
```

If you don't designate a description value, the templates will automatically include the first 150 characters of a given page as the description field. This isn't always ideal, but it's what Google would do automatically, and it keeps SEO tools in use around the company from complaining about the total lack of a description tag.

**Toc:** True or false; defaults to true. Whether to include the in-page TOC at the top of this page. This can be disabled for pages that don't need it.

**Subtitle:** By default, the `title` variable will be used in the `<title>` tag, the big title banner in the masthead, and the small title right above the in-page TOC. This will replace the small title if it's present.

**Munge header IDs:** Currently not implemented, but the new-style type reference uses it anyway. The idea is that if we: 1. Build a replacement for Kramdown's auto ID attribute thing for headers, and 2. have some pages with explicit header IDs like `<h3 id="thing">` (like on the new-style type reference), then this could keep the header munger from overwriting those explicit IDs.

**Nav:** This lets you set a sidebar nav snippet, which should be the relative path to a file inside the `_includes` directory. This lets you override the nav snippets set by the `defaultnav` map in the `_config.yml` file.

**Version note:** This lets you set a version note that will appear somewhere on the page (under the page title header and before the in-page TOC, at the time of this writing). This lets you override the per-large-document notes set in `_config.yml` in the `version_notes` map.

Version notes can optionally include a `<p class="noisy">`, which will make the note pop a bit more if it's something we really want users to notice.