#!/usr/bin/env perl

# This script writes cleaned versions of the auto-generated references for Puppet 0.24 through 0.25. Once you move them into place you'll still need to replace the original indexes (git co source/references/0.2*/index.markdown) and delete the metaparameter.markdown files for all the 0.24 versions (rm source/references/0.24*/metaparameter.markdown).

# Ideally this should never be used again, but break glass in case of emergency.

use feature ':5.10';
use warnings;
use strict;

my @versions = ('0.25.5', '0.25.4', '0.25.3', '0.25.2', '0.25.1', '0.25.0', '0.24.9', '0.24.8', '0.24.7', '0.24.6', '0.24.5');
my @refs = ("configuration", "function", "indirection", "metaparameter", "network", "report", "type");

for my $version (@versions) {
    chdir('/Users/nick/src/puppet'); # Hard-coded because this doesn't strictly need to be reusable.
    system( 'git', 'co', "tags/$version");
    chdir('/Users/nick/Desktop/references_temp'); # Also hard-coded.
    system( 'mkdir', $version); # Maybe barfs if the root folder isn't empty? Shrug!
    for my $ref (@refs) {
        my $cap_ref = $ref;
        $cap_ref =~ s/^(\w)/\u$1/; # Capitalized form for text we need to re-write.
        my $doc = qx{envpuppet puppetdoc -r $ref | rst2html-2.6.py -r "none"};
            # If we don't do -r "none," we get visible garbage blocks in the rst2html output.
        given ($doc){
            # Fun times with increasingly absurd s///gs!
            s/\A.*?<body>//s; # Kill the stylesheet and all useless frontmatter; we only want a HTML fragment.
            s/<\/(body|html)>//g; # Kill the dangling tags at the bottom.
            s/<div class="contents topic" id="contents">.*?<\/div>//sg; # Kill the table of contents, Jekyll makes its own.
            s/ (class|id)="[^"]+"//g; # Kill all classes and IDs.
            s/ href="#\w+"//g; # Kill all in-page hrefs, Jekyll makes its own.
            s/<a>(.*?)<\/a>/$1/g; # Kill all in-page links (this is a two-step process so we can preserve outbound links. Now that I look at this, I could have compressed it, but it wouldn't ultimately make this any prettier.)
            s/<\/?(span|div)>//g; # Kill all spans and divs. God this html is terrible.
            s/<pre>(.*?)<\/pre>/<pre><code>$1<\/code><\/pre>/sg; # Pre blocks turn into nested pre+code blocks.
            s/<(\/?)(cite|tt)>/<$1code>/g; # Cite and TT both turn into code spans.

            # Change all headers into Markdown. This is for indexing; we'll leave all other HTML as-is.
            # Special case for page titles: keep as H1.
            s/<h1>(\Q$cap_ref\E Reference)<\/h1>/$1\n=====\n/;
            # Configuration reference's headers are too big
            s/<h2>(.*?)<\/h2>/### $1\n/g if $ref eq "configuration";
            # Type reference's headers are uniformly shifted left, resulting in dirty TOC
            if ($ref eq "type") {
                s/<h2>(.*?)<\/h2>/### $1\n/g;
                s/<h3>(.*?)<\/h3>/#### $1\n/g;
                s/<h4>(.*?)<\/h4>/##### $1\n/g;
            }
            # These next four use promiscuous H1s and don't have built-in <hr>s
            s/<h1>(.*?)<\/h1>/----------------\r\r### $1\n/g if $ref eq "function";
            s/<h1>(.*?)<\/h1>/----------------\r\r### $1\n/g if $ref eq "network";
            s/<h1>(.*?)<\/h1>/----------------\r\r### $1\n/g if $ref eq "report";
            if ($ref eq "indirection") {
                s/<h1>(.*?)<\/h1>/----------------\r\r### $1\n/g;
                # Also, those h2s shouldn't be in the TOC. Bump to h4 which is past the TOC threshold.
                s/<h2>(.*?)<\/h2>/#### $1\n/g;
            }
            # Sweep up any extra headers
            s/<h1>(.*?)<\/h1>/$1\n=====\n/g;
            s/<h2>(.*?)<\/h2>/$1\n-----\n/g;
            s/<h3>(.*?)<\/h3>/### $1\n/g;
            s/<h4>(.*?)<\/h4>/#### $1\n/g;
            s/<h5>(.*?)<\/h5>/##### $1\n/g;
            $_ = "---\nlayout: default\ntitle: $cap_ref Reference\n---\n" . $_; # Prepend the Jekyll header for the page title and layout.
            open my $fh, '>', $version . '/' . $ref . '.markdown'; # ./$version/$ref.markdown
            print $fh $_;
            close $fh;
        }

    }

}
