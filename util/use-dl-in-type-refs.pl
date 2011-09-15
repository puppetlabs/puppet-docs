#!/usr/bin/env perl

# NF: This script was written to automatically convert type references generated from the 2.6.x and 2.7.x series to use definition lists instead of h5 elements for parameters. Since the fix to the reference generator was only checked into the 2.7.x branch (in commit ac7c146cd82dd6de41ab57b9e0cbd4179dfcdc45), this will probably need to be used one or two more times.

use warnings;
use strict;
# use feature ":5.10";

my $in_a_type = 0;
my $in_some_parameters = 0;
my $first_line_of_definition = 0;

while (<>) {
    if ($in_a_type and $in_some_parameters) {
        if ($first_line_of_definition and m/^\S/) {
            print ": $_";
            $first_line_of_definition = 0;
        }
        elsif (m/^#####/) {
            s/^##### //;
            print $_;
            $first_line_of_definition = 1;
        }
        elsif (m/\S/) { # at least one non-whitespace char in line
            print "    " unless m/^----+\s*$/;
            print "$_";
        }
        else { # must be whitespace-only
            print $_ unless $first_line_of_definition; # shrink up the gap
        }
    }
    else {
        print $_;
    }
    
    # Once we're past the frontmatter:
    if ($in_a_type == 0 and m/^----+\s*$/) {
        $in_a_type = 1;
    }
    # Once we leave a type:
    if ($in_a_type and $in_some_parameters and m/^----+\s*$/) {
        $in_some_parameters = 0;
    }
    # When we enter something's parameters:
    if ($in_a_type and $in_some_parameters == 0 and m/^#### Parameters$/) {
        $in_some_parameters = 1;
    }
}