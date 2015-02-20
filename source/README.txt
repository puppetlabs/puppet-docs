Thanks for downloading the offline version of the Puppet Labs documentation
site. There are two ways to view this content:

Local Web Server
================

This site expects that it's being served at the root of a webserver (like
https://docs.puppetlabs.com), and uses many absolute links. This means many
features of the site will be broken unless you arrange a local webserver for it.

You can move this directory to the DocumentRoot of an existing web server, or
you can use Ruby to start a small, bare-bones webserver. (This has only been
tested on POSIX systems like Linux or Mac OS X.)

To start the mini-server, do the following:

1. Ensure you have the rack gem installed, running `sudo gem install rack` if necessary.
2. Navigate to this directory in your terminal.
3. Run `rackup` to start the web server.
4. In your web browser, navigate to http://localhost:9292
5. When finished, you can stop the webserver by returning to the original
   terminal window and hitting ctrl-C.


Munge Links
===========

Alternately, we provide a small Ruby script that can automatically change all of
the site's absolute links to relative links. This makes the site work without a
web server; you can simply open the index.html file in a web browser and begin
reading. You'll miss out on convenience features (like translating `directory/`
to `directory/index.html`), but the site will be browsable.

You'll have to run the script locally, on a system that has Ruby installed.
(This has only been tested on POSIX systems like Linux or Mac OS X.)

1. Navigate to this directory in your terminal.
2. Run `ruby ./linkmunger.rb`
3. Wait for the script to finish.
4. Open the index.html file (or any other .html file in this archive) in your
   web browser.
