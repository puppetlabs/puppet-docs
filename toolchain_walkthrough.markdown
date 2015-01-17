# The Puppet Docs Toolchain

_... wherein we discuss the innards of docs.puppetlabs.com_

## Elevator Pitch

The Puppet Labs docs site is a collection of static HTML files generated from [Markdown][] source files and from Puppet itself. When we talk about the toolchain, we're talking about the collection of tools and services in use to generate the site then deploy it to the web servers for docs.puppetlabs.com. Among the things the toolchain provides:

- The HTML for the Puppet Labs docs site
- References generated from inline documentation in Puppet itself
- YARD developer documentation
- PDFs of Puppet references

## Initial Setup

[The instructions on Github](https://github.com/puppetlabs/puppet-docs/blob/master/README.markdown) explain how to get a functioning docs toolchain in place.

## Tools and Services

### Git & Github

The Puppet Labs docs repository lives on Github:

<https://github.com/puppetlabs/puppet-docs>

#### Git Workflow

For working with the puppet-docs repository from day to day, we recommend:

- Forking puppetlabs/puppet-docs

- Cloning your fork to your machine ("set up a local"):
    `git clone git@github.com:#{your_github_username}/puppet-docs.git`

- Designating puppetlabs/puppet-docs as your git upstream:
    `git remote add upstream git@github.com:puppetlabs/puppet-docs.git`

- Making changes from a branch on your local:
    `git checkout -b name_of_topic_branch`

- Updating your local master before merging your branch changes:
    `git pull upstream master`

- Merging your topic branch to your local master:
    `git merge name_of_topic_branch`

- Pushing from master to master:
    `git push upstream master`

If you have a very small change to make, just make sure your master branch is up to date (`git pull upstream master`), make your change, then push it.

### Jekyll

[Jekyll][] is a static site generator. It takes a directory full of files written in HTML or Markdown and generates a site of static HTML. If you're used to dealing with a content management system such as WordPress or Drupal elsewhere, these things are worth knowing:

- Jekyll doesn't allow you to edit content on a live site: you have to make your changes to the Markdown file, save them, then generate the site.
- Jekyll has to regenerate the entire site every time it's generated. That includes all the navigation elements and pages.
- Jekyll __does not use__ the remote Github repository to generate the site. It uses what's in the git branch you're working on. You should generally use the [git workflow](#git-workflow) outlined above to make sure you're not generating a site with bits that aren't ready for primetime.

##### What do I need to know about this?

**Day-to-day:** Not much:

- See the section on [generating the site](#generating) to learn how to generate the docs site.
- See the section on [navigation and templating](#navigation-and-templating) if you need to change a section's navigation or templating.

**Toolsmiths:** We're currently carrying patches on Jekyll in order to get it to:

- use symlinked pages and directories (the upstream Jekyll maintainer has security concerns about allowing symlinks)
- process files/directories with a leading "\_" (because Jekyll's filename convention uses "\_" for config files and other unprocessables)

We keep our fork of Jekyll in a Puppet-owned github repository:

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

#### Liquid Templating

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

The Puppet Labs platform team recently adopted [YARD][] as its tool of choice for developer documentation in Puppet. Among YARD's featues:

- simple templating that allows developers to include and display useful metadata, such as whether a function is part of the public API
- Markdown support
- the ability to provide a simple desktop documentation webserver with nothing more than a local copy of the Puppet repo

Though YARD documentation is easily read via its built-in webserver, the Puppet docs site keeps a copy of YARD's generated output:

<http://docs.puppetlabs.com/references/3.1.latest/developer/index.html>

##### What do I need to know about this?

**Day-to-day:** You should generate YARD documentation each time a new patch release of Puppet is made. See the section on [generated references](#generated-references) below.

**Toolsmiths:** There's room for improvement in the YARD templating, but that should be coordinated with the platform team's developers since YARD templating has to pull double duty, both for output on a desktop docs webserver and as part of the generated references.

#### Puppet Documentation

Much Puppet code includes what are referred to as "doc strings," generally brief inline documentation made available via the `puppet doc` command. The Puppet docs site keeps a copy of Puppet's `puppet doc` output. The latest version is linked in the sidebar of the Puppet reference manual:

<http://docs.puppetlabs.com/puppet/3/reference/>

##### Editing Puppet Docs

To modify Puppet documentation, you need to:

1. Read the [Puppet contribution guidelines][], even if you're a Puppet employee
2. fork the puppet repo
3. make your changes in a topic branch
4. submit a pull request

##### Revising Past Versions of Puppet Docs

Since we keep generated references for every patch release of Puppet, there will be times when you need to make a change to legacy generated references. Consult with developers on this, since you can't always be sure under which point or patch release a change was introduced. Generally speaking, making a change to the last patch release in a series (e.g. 2.7.21) is all that's required, since that in turn will be presented as the latest, canonical version of a given document.

##### What do I need to know about this?

**Day-to-day:** You should generate Puppet references each time a new patch release of Puppet is made. See the section on [generated references](#generated-references) below.

___WARNING: You should not regenerate references for older versions of these documents: Sometimes changes are made to the existing versions, and regenerating them will overwrite these changes.___

**Toolsmiths:** Puppet documentation can be crabby. Here are some things to look out for:

- Clean loadpath: You should never have Puppet installed from Puppet-Labs-provided packages on a system that's generating documents unless you've got a sound plan for isolating the version of Ruby you're using to generate the docs from system Ruby libraries (e.g. rbenv or rvm).
- ActiveRecord: A few parts of Puppet have declared dependencies on ActiveRecord but do not actually use it and will not raise an error if ActiveRecord isn't present (Puppet 3 or later). If generated reference pages come up blank, doublecheck for ActiveRecord.


### Apache and Puppet

Eventually, once the site is deployed to the servers, it's served by Apache, although it could be served by more or less anything.

In production, the Apache virtual host file is managed by a Puppet module in the puppetlabs-modules repo. This is a private repository only accessible to Puppet Labs employees.

If you need to do redirects from one page to another within the docs.puppetlabs.com domain, where by "you" we mean "us," edit the puppetlabs-modules/site/profile/manifests/web/static/docs.pp file. (This file changed in early August, 2014, when Ops refactored our web stack to use Nginx. As of Aug 8, it's in the nginx_next branch, but it will get merged to production very soon.)

If you need to do redirects from the wiki, edit the puppetlabs-modules/dist/redmine/templates/vhost-redmine-unicorn.nginx.erb file. WATCH OUT, because there's another file that looks nearly identical but is not used.

## Linkchecker

Linkchecker is a python app that does what it says on the tin. It's not a mandatory part of the toolchain, but it's nice to run once in a while and catch the inevitable link rot. You can install it with macports by running sudo port install linkchecker, not sure if there's another good way to install it.

The docs for linkchecker are a little bit crap, and some of its behavior isn't clear, but here's what I've managed to nail down:

### Neuter the templates, then generate the site

All our templates include these conditional stylesheet links for IE that cause linkchecker to stop reading the file as soon as they reach them. So you have to delete them in each _layouts/something.html file, then restore them when you're done with the whole process.

    <!--[if IE 7]>
	  <link rel="stylesheet" type="text/css" href="/files/stylesheets/ie_7.css" media="screen"> <!-- index -->
    <![endif]-->

    <!--[if IE 8]>
	    <link rel="stylesheet" type="text/css" href="/files/stylesheets/ie_8.css" media="screen"> <!-- index -->
    <![endif]-->

Then generate the site with rake generate.

### Make a ~/.linkchecker/linkcheckerrc file, or edit it if it exists

You want the ignorewarnings line to look like this:

ignorewarnings=url-content-duplicate,http-moved-permanent

This prevents a bunch of noise I'm having to wrestle with right now.

### Make sure you're serving the site locally with apache... or something

This thing spins up like 100 threads to do http requests, so the little webrick server made by "rake serve" is a no-go.

And since we use domain-less links all over the place, the site doesn't quite work as local files, so it has to be served by something. Hmm, maybe nginx would make this go faster. :/

#### OH WAIT, HOLD ON

It looks like the config file allows a localwebroot setting for checking absolute URLs in local files?

localwebroot=/Users/nick/puppet-docs/output/

YES, set that and do a local check.

### Limit your command

As far as I can tell, the default behavior is to recurse infinitely on the domain you provide, and go one step outwards on links to other domains. This gets INSSSAAANNNNEEE, but I don't know what a safe recursion limit is for catching all the links. I guess it only takes six degrees to reach Kevin Bacon, so maybe peg it at 6 and see what happens? Anyway, this time I left it at infinite, but blocked anything outside the local area and didn't recurse into any /references/ links.

    linkchecker --anchors --ignore-url='^(?!file:///)' --no-follow-url='^file:///Users/nick/Documents/puppet-docs/output/references/' /Users/nick/Documents/puppet-docs/output/

That one above is using the local filesystem, which is so much faster OMG. What I was doing before was using the local apache server:

    linkchecker --anchors --ignore-url='^(?!http://docs.magpie)' --no-follow-url='docs.magpie.lan/references/' http://docs.magpie.lan

If we wanted to set a recursion limit, it'd be `-r 6` or whatever.

Oh, and we're using the `--anchors` flag because anchors matter on our internal links.

### Also

I've experienced with doing things like -r 0 or -r 1 and giving it a file glob, with the hope that that would make it slurp every file and be faster because it's not recursing, and it didn't work. Good thought, though.

## Working With the Toolchain

#### Where do things live in the filesystem?

The content for the docs site lives in the `_source` directory of the puppet-docs repo:

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

### Generating the Docs

Generating the Puppet docs site using the Rakefile in the top of the docs repo. The

#### The core site

__Rake command:__ `rake generate`

If all you need to do is regenerate the docs site to reflect changes you've made:

`$ cd puppet-docs`
`$ rake generate`
`$ rake preview`

Visit `http://localhost:9292` to review your changes.

> **Note:** Some Puppet subprojects keep their own copies of their documentation. These projects are automatically checked out when the documentation is generated and no user intervention is required.

##### What do I need to know about this?

**Day-to-day:**

- Sometimes `rake` will fail with an error referencing "bundler." Run `bundle update` in your puppet-docs directory and that should sort it out.
- Sometimes, early in the build process, you'll see errors related to mcollective or PuppetDB being in a detached HEAD state. Feel free to ignore those.

**Toolsmith:**

Look at the `:generate` task in the Rakefile. For the mcollective and PuppetDB docs generation, check the `externalsources` namespace in the Rakefile. For configuration of the external sources, see `config.yml` at the top of the puppet-docs repo.

#### Generated References/YARD Docs

__Rake command:__ `VERSION=3.1.1 rake references`

The generated references and YARD docs are produced from inline documentation in Puppet.  You need to regenerate these with each patch release of Puppet. Once the references are generated, the new files will need to be added to the repo and committed. The new files are located under `_source/references`.

**WARNING:** Sometimes we have to go back and make corrections to existing generated references. Please do not regenerate older references or those corrections will likely be overwritten.

##### What do I need to know about this?

**Day-to-day:** You shouldn't have Puppet, Hiera or Facter packages installed on your system because there's a good chance they'll cause the generated documentation to be incorrect. You should either have Puppet installed via a gem or use it from a clone of the repository.

**Toolsmith:** The rake task for references calls `lib/puppet_docs/reference.rb`, which does some stuff to clean out the Ruby loadpath, check out captive versions of Puppet, Facter and Hiera, and then use the captive Puppet to generate the references.

### Deploying

__Rake command:__ `rake deploy` generates the site and deploys it to the docs.puppetlabs.com server.

For this command to work, you should generate an ssh key and make sure operations has included it for use with the mirror0 and mirror1 servers.

## Navigation, Templating, Pages

### Templates

The templates Jekyll uses to generate the site live in `_source/layouts`. They include:

- **frontpage.html** for the front page of the docs site
- **default.html** which provides for a generated table of contents at the top of the page and a left-side navigation menu
- **legacy.html** which provides for a generated table of contents as a right-side menu

CSS and JavaScript for the templates lives in `source/files/stylesheets` and `source/files/javascripts` respectively.

In addition to the basic templates, there are also two error pages in the `source/files/errors` directory:

- **general_404.html**, a 404 page with links to commonly sought items across the docs site
- **versioned_404.html**, a 404 page that helps users find their way to current versions of older docs

If you want to introduce new error pages for more than not-found errors, or if you decide to designate a different file altogether, you'll need to visit the Puppet Labs `puppetlabs-modules` repo:

<https://github.com/puppetlabs/puppetlabs-modules/>

and edit `production/site/puppetlabs/templates/docs_vhost.erb`. Please do this by forking `puppetlabs-modules`, creating a topic branch, and submitting a pull request.

### Navigation

The HTML for navigation elements that appear in the sidebars/rails on individual pages lives in `source/_includes`. Menus are assigned to a given page using a Liquid function called from the template files (`source/_plugins/render_nav.rb`) and configured in the `_config.yml` file found on the top level of the puppet-docs repo.

So, for pages using the default layout, to add a new navigation menu to the left rail, edit the `defaultnav` hash in `_config.yml` to map the files under a given directory to an HTML file you've placed in `source/_includes`.

### Pages

Jekyll expects each page to include YAML frontmatter. It should, at a minimum, include a `layout` and `title` value, e.g.

	---
	layout: default
	title: "Hiera 1: Command Line Usage"
	---

In addition, you can include a few other values in the frontmatter:

* `canonical`
* `description`
* `toc`
* `subtitle`
* `munge_header_ids`
* `nav`
* `version_note`

**Canonical:** Designates the canonical version of a given page. We use this to generate a canonical link that guides search engines to the most current, most relevant version of a given page. Testing has shown that this is very effective for consolidating search traffic on the most recent version of a given document. Format the canonical value as an absolute path from the docroot:

	canonical: "/puppetdb/1.1/configure.html"

**Description:** Designates a description meta tag for a given page. The description is used by search engines to generate a preview snippet in results pages, so this should not typically exceed 150 characters. Format this as a string:

	description: "The hiera command line tool is useful for previewing and validating your hierarchy before putting it into production."

If you don't designate a description value, the templates will automatically include the first 150 characters of a given page as the description field. This isn't always ideal, but it's what Google would do automatically, and it keeps SEO tools in use around the company from complaining about the total lack of a description tag.

**Toc:** True or false; defaults to true. Whether to include the in-page TOC at the top of this page. This can be disabled for pages that don't need it.

**Subtitle:** By default, the `title` variable will be used in the `<title>` tag, the big title banner in the masthead, and the small title right above the in-page TOC. This will replace the small title if it's present.

**Munge header IDs:** Currently not implemented, but the new-style type reference uses it anyway. The idea is that if we: 1. Build a replacement for Kramdown's auto ID attribute thing for headers, and 2. have some pages with explicit header IDs like `<h3 id="thing">` (like on the new-style type reference), then this could keep the header munger from overwriting those explicit IDs.

**Nav:** This lets you set a sidebar nav snippet, which should be the relative path to a file inside the `_includes` directory. This lets you override the nav snippets set by the `defaultnav` map in the `_config.yml` file.

**Version note:** This lets you set a version note that will appear somewhere on the page (under the page title header and before the in-page TOC, at the time of this writing). This lets you override the per-large-document notes set in `_config.yml` in the `version_notes` map.

Version notes can optionally include a `<p class="noisy">`, which will make the note pop a bit more if it's something we really want users to notice.

## Reference Links (remove when done with draft)
[Markdown]: http://daringfireball.net/projects/markdown
[YARD]: http://yardoc.org
[kramdown]: http://kramdown.rubyforge.org
[Puppet contribution guidelines]: https://github.com/puppetlabs/puppet/blob/master/CONTRIBUTING.md
[Jekyll]: https://github.com/mojombo/jekyll
[Liquid wiki]: https://github.com/Shopify/liquid/wiki
<!--
##### What do I need to know about this?

**Day-to-day:**

**Toolsmith:**
-->


