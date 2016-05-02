# PE and puppet-agent Version Tables

This code is a bit of a mess, because it's not really in its final form. I'm planning to integrate it into our improved references generator at some point, once that... starts... existing?

Also, it needs the `git` gem. There's a Gemfile so you can use Bundler to run everything, or you can just install that one gem globally.

Anyway, for now the interface to this is:

1. Check out this repo.
1. Make sure you have access to the private enterprise-dist and puppet-agent repos.
1. Run `build-all.rb`.
1. Grab the files in the `output` directory and move them into `puppet-docs/source/{puppet-agent,pe}`. Check them in.

Do steps 3 and 4 every time there's a puppet-agent or PE release.

The pe.json and agent.json files might also be interesting. Among other things, they can act as a more full-featured replacement for things like the Kerminator scripts that tell you what's in a given PE or puppet-agent version.
