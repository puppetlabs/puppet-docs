Thank you for helping us improve our docs! Here are some non-obvious things you might need to know when committing to this repo:

* Beware of source/references/VERSION
* MCollective doesn't live here
* PuppetDB doesn't live here

# Please don't do drive-by edits to references

These files are all **automatically generated** from strings in the Puppet source code. If you edit the old frozen versions, we will generate a fresh page of "wrong" text when the next version of Puppet comes out!

Instead, please edit the text [in the Puppet source code](https://github.com/puppetlabs/puppet) (see below for a list of locations) and submit a pull request to the Puppet project. Be careful about quoting and escaping, and be sure to read Puppet's [contributing guidelines](https://github.com/puppetlabs/puppet/blob/master/CONTRIBUTING.md). For minor docs edits, you can skip filing a JIRA ticket and instead begin your commit message with `(docs)`.

## Locations of Docs text in the Puppet source

* For configuration.html, look in `lib/puppet/defaults.rb`.
* For function.html, look in `lib/puppet/parser/functions/NAME.rb`.
* For indirection.html, look in `lib/puppet/indirector/INDIRECTION/TERMINUS.rb`.
* For metaparameter.html, look in `lib/puppet/type.rb` and search for `newmetaparam(:NAME)`.
* For report.html, look in `lib/puppet/reports/NAME.rb`.
* For type.html, look in `lib/puppet/type/NAME.rb` or `lib/puppet/provider/NAME/PROVIDER.rb`.
    * If you find something wrong with the **provider features** (the big tables with Xs in them), please just file a bug report instead; fixing them is kind of complicated. 

## Should I also edit the old frozen versions?

Only sometimes. Most of our readers only care about the most recent version in the release series they're using.

* If you're fixing an error that could actually ruin someone's day, that's pretty important! We would love a patch to the old versions.
* If it's just a "nice to have" fix that clarifies something confusing, please don't patch everything back to 0.24.5. We would love a patch to _just the most recent versions_ in the current and maintenance release series.

# MCollective docs don't live here

The MCollective docs live in the `website` directory in [the main MCollective GitHub repo](https://github.com/puppetlabs/marionette-collective); whenever we update docs.puppetlabs.com, we pull in the latest content from the `master` branch. Please submit pull requests there.

The navigation sidebar DOES live here, at `source/_includes/mcollective_menu.html`.

# PuppetDB docs don't live here

Although we host the PuppetDB 0.9 and 1.0 manuals, the docs for version 1.1 and later were moved into the `documentation` directory in [the main PuppetDB GitHub repo](https://github.com/puppetlabs/puppetdb). Whenever we update docs.puppetlabs.com, we pull in the latest content from the versioned branches.

To edit the PuppetDB docs, submit a pull request to **the earliest** `major.minor.x` branch that has the problem you're trying to fix. In your pull request message, you should request that the change be merged forward.

The navigation sidebars DO live here, at `source/_includes/puppetdb<VERSION>.html`.

## Should I also edit the 0.9/1.0 Docs?

No.
