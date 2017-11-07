---
layout: default
title: Release Tasks
disqus: true
canonical: "/mcollective/reference/development/releasetasks.html"
---

# {{page.title}}

Notes on what to do when we release

 * update Changelog
 * update ReleaseNotes
 * update rakefile for version
 * update website news section
 * tag release
 * update release notes with release date
 * build and release rpms
 * build and release debs using ami-0db89079
 * send mail
 * Announce on freshmeat

## Building RPMs
Boot up an instance of the EC2 demo AMIs

{% highlight console %}
# gem install rake
# git clone git://github.com/puppetlabs/marionette-collective.git
# cd marionette-collective
# git checkout 0.x.x
# rake rpm
{% endhighlight %}

Copy the RPMs and test it.

## Building debs
Boot up an instance of _ami-0db89079_ and do more or less the following:

**Note: There's some bug, you might need to run _make deb_ twice to make it work**

{% highlight console %}
# apt-get update
# apt-get install rake irb rdoc build-essential subversion devscripts dpatch cdbs rubygems git-core
# git clone git://github.com/puppetlabs/marionette-collective.git
# cd marionette-collective
# git checkout 0.x.x
# rake deb
{% endhighlight %}

Copy do test installs on the machine make sure it looks fine and ship them off the AMI, shut it.  Make sure to copy the source deb as well.
